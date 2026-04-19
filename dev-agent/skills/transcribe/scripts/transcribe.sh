#!/usr/bin/env bash
# Transcribe audio with a local speech-to-text endpoint, with Gemini fallback.
# Usage: transcribe.sh <audio-file> [language]

set -euo pipefail

API_URL="${TRANSCRIBE_API_URL:-http://127.0.0.1:10301}"
FILE="${1:-}"
LANG="${2:-}"

if [[ -z "$FILE" ]]; then
    echo "Usage: transcribe.sh <audio-file> [language]" >&2
    exit 1
fi

if [[ ! -f "$FILE" ]]; then
    echo "Error: file not found: $FILE" >&2
    exit 1
fi

extract_text() {
    python3 - <<'PY' "$1"
import json
import sys

payload = sys.argv[1]
try:
    data = json.loads(payload)
except Exception:
    sys.exit(1)

text = data.get("text")
if isinstance(text, str) and text:
    print(text)
    sys.exit(0)
sys.exit(1)
PY
}

stt_ok=false
if curl -s --connect-timeout 3 --max-time 5 -o /dev/null "${API_URL}/health" 2>/dev/null; then
    curl_args=(-s -X POST "${API_URL}/v1/audio/transcriptions" -F "file=@${FILE}" -F "model=whisper-1")
    [[ -n "$LANG" ]] && curl_args+=(-F "language=${LANG}")
    response="$(curl --max-time 120 "${curl_args[@]}" 2>/dev/null)" && stt_ok=true
fi

if $stt_ok; then
    if text="$(extract_text "$response" 2>/dev/null)"; then
        printf '%s\n' "$text"
        exit 0
    fi
fi

api_key="${GEMINI_API_KEY:-${GOOGLE_API_KEY:-}}"
if [[ -n "$api_key" ]]; then
    echo "[local transcription unavailable at ${API_URL}, using Gemini fallback]" >&2

    ext="${FILE##*.}"
    case "${ext,,}" in
        ogg)  mime="audio/ogg" ;;
        mp3)  mime="audio/mpeg" ;;
        wav)  mime="audio/wav" ;;
        m4a)  mime="audio/mp4" ;;
        webm) mime="audio/webm" ;;
        mp4)  mime="audio/mp4" ;;
        *)    mime="application/octet-stream" ;;
    esac

    b64="$(base64 -w0 "$FILE")"
    lang_hint=""
    [[ -n "$LANG" ]] && lang_hint=" The audio language is ${LANG}."

    tmpjson="$(mktemp)"
    trap 'rm -f "$tmpjson"' EXIT
    cat > "$tmpjson" <<EOF
{"contents":[{"parts":[{"inline_data":{"mime_type":"${mime}","data":"${b64}"}},{"text":"Transcribe the audio exactly as spoken. Output only the transcription text.${lang_hint}"}]}]}
EOF

    gemini_response="$(curl -s --max-time 120 \
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${api_key}" \
        -H "Content-Type: application/json" \
        -d @"$tmpjson" 2>/dev/null)"

    if python3 - <<'PY' "$gemini_response" 2>/dev/null
import json
import sys

data = json.loads(sys.argv[1])
print(data["candidates"][0]["content"]["parts"][0]["text"])
PY
    then
        exit 0
    fi

    echo "Error: Gemini transcription failed" >&2
    exit 1
fi

echo "Error: local transcription endpoint unreachable at ${API_URL} and no Gemini fallback key is set." >&2
echo "Set TRANSCRIBE_API_URL or export GEMINI_API_KEY / GOOGLE_API_KEY." >&2
exit 1

