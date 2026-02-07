#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Start Adden Workflow
# @raycast.mode compact
# @raycast.alias start, adden

# Optional parameters:
# @raycast.icon 🤖

PROJECT=~/Github/adden-frontend
FRONTEND_URL="http://localhost:3000"

# 1. Open iTerm2 and run commands in a new tab (or new window if none exists)
osascript <<EOF
tell application "iTerm2"
  activate
  if (count of windows) is 0 then
    create window with default profile
  else
    tell current window
      create tab with default profile
    end tell
  end if
  tell current session of current window
    write text "cd $PROJECT; n"
  end tell
end tell
EOF

# 2. Open Chrome tab
osascript <<EOF
tell application "Google Chrome"
    activate
    try
        open location "$FRONTEND_URL"
    on error
        make new window
        set URL of active tab of window 1 to "$FRONTEND_URL"
    end try
end tell
EOF

# 3. Open Cursor editor in the project folder (maximized)
if command -v cursor >/dev/null 2>&1; then
  (cd "$PROJECT" && cursor .) &
else
  open -a "Cursor" "$PROJECT" &>/dev/null &
fi

# Wait a moment for Cursor to open, then maximize it
sleep 0.5
osascript <<'EOF'
tell application "Finder"
  set screenBounds to bounds of window of desktop
  set screenWidth to item 3 of screenBounds
  set screenHeight to item 4 of screenBounds
end tell

tell application "System Events"
  tell process "Cursor"
    tell window 1
      set position to {0, 0}
      set size to {screenWidth, screenHeight}
    end tell
  end tell
end tell
EOF

exit 0
