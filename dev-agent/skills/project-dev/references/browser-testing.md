# Browser Testing — Live-Test Guide

Use this guide when the issue affects a browser-based UI.

## Goal

The orchestrator should be able to reproduce the behavior, take screenshots, and attach concrete evidence without requiring the operator to do the first verification pass manually.

## Basic Flow

1. deploy or start the lab build
2. open the browser tool or Playwright
3. sign in with the test account
4. navigate to the affected screen
5. reproduce the exact behavior
6. capture screenshots at each important step
7. record what each screenshot proves

## Login Strategies

### Standard UI login

If the app supports username and password login in the UI:

1. navigate to `<lab-url>`
2. log in as `<test-user>`
3. wait for the app to finish loading

### Session injection

If the UI hides the normal login flow or only supports SSO, inject a session token through the browser tool. The exact storage key is app-specific; document it in this file for your own project.

Template:

```javascript
() => {
  const session = {
    accessToken: "<token>",
    userId: "<user-id>",
    baseUrl: "<base-url>",
  };
  localStorage.setItem("<session-storage-key>", JSON.stringify(session));
  return "ok";
}
```

## Evidence Rules

- screenshots should match the claimed behavior
- full-page screenshots are useful for layout regressions
- console logs are useful for broken scripts or network failures
- if the bug involved multiple states, capture each state

## Responsive Checks

For responsive work, use Playwright with real viewport sizes. Do not guess from CSS alone.

Example:

```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page(viewport={"width": 375, "height": 812})
    page.goto("<lab-url>", wait_until="networkidle")
    page.screenshot(path="/tmp/mobile.png", full_page=True)
    browser.close()
```

Suggested widths:

- `375x812`
- `500x900`
- `768x1024`
- `1280x720`

## Tips

- always take a fresh snapshot before clicking browser-tool refs
- reload after session injection so the app re-reads storage
- wait for network idle or the visible loading state to finish
- keep a short text note next to each screenshot explaining what it proves

