#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Stop Adden Workflow
# @raycast.mode compact
# @raycast.alias stop-adden

# Optional parameters:
# @raycast.icon 🛑

PROJECT=~/Github/adden-frontend
FRONTEND_URL="http://localhost:3000"

# 1. Close Cursor window with the project
osascript <<EOF
tell application "System Events"
  tell process "Cursor"
    set windowCount to count of windows
    repeat with i from 1 to windowCount
      try
        close window i
      end try
    end repeat
  end tell
end tell
EOF

# 2. Close Chrome tab with localhost:3000
osascript <<EOF
tell application "Google Chrome"
  set window_list to every window
  repeat with the_window in window_list
    set tab_list to every tab in the_window
    repeat with the_tab in tab_list
      if URL of the_tab contains "$FRONTEND_URL" then
        close the_tab
      end if
    end repeat
  end repeat
end tell
EOF

# 3. Close iTerm2 tab/window with the project directory
osascript <<EOF
tell application "iTerm2"
  repeat with the_window in windows
    repeat with the_tab in tabs of the_window
      repeat with the_session in sessions of the_tab
        set session_path to variable named "PWD" of the_session
        if session_path contains "$PROJECT" then
          close the_session
        end if
      end repeat
    end repeat
  end repeat
end tell
EOF

exit 0
