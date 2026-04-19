---
name: transcribe
description: Transcribe audio files with a local or self-hosted speech-to-text endpoint, with Gemini fallback when configured. Use for voice messages, audio attachments, or explicit transcription requests.
---

# Audio Transcription

Transcribe audio files with a speech-to-text server that exposes an OpenAI-style transcription API.

## Configuration

Set `TRANSCRIBE_API_URL` to your speech-to-text endpoint.

- default example: `http://127.0.0.1:10301`
- expected endpoint: `<base-url>/v1/audio/transcriptions`

Optional fallback:

- `GEMINI_API_KEY`
- `GOOGLE_API_KEY`

## Quick Start

```bash
./scripts/transcribe.sh /path/to/audio.ogg
./scripts/transcribe.sh /path/to/audio.ogg en
```

## Manual Curl

```bash
curl -s -X POST "${TRANSCRIBE_API_URL:-http://127.0.0.1:10301}/v1/audio/transcriptions" \
  -F "file=@/path/to/audio.ogg" \
  -F "model=whisper-1"
```

## Supported Formats

- `.ogg`
- `.wav`
- `.mp3`
- `.m4a`
- `.webm`

## Health Check

```bash
curl -s "${TRANSCRIBE_API_URL:-http://127.0.0.1:10301}/health"
```

## Notes

- the endpoint values in this repository are placeholders
- replace them with your own local or hosted service
- if Gemini fallback is enabled, the script can still return a transcription when the local endpoint is unavailable

