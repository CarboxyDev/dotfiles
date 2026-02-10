-- Variables to track current and previous applications for app switching
local currentApp = nil
local previousApp = nil
local isSwitching = false  -- Flag to prevent tracking during manual switches

-- F2 editor cycling: list of text editors
local editorApps = {"Cursor", "Visual Studio Code", "Antigravity", "Codex"}
local editorSet = {}
for _, name in ipairs(editorApps) do editorSet[name] = true end
local lastFocusedEditorName = nil

local function containsIgnoreCase(haystack, needle)
  if not haystack or not needle then return false end
  return string.find(string.lower(haystack), string.lower(needle), 1, true) ~= nil
end

local function editorNameFromApp(app)
  if not app then return nil end

  local appName = app:name()
  if appName and editorSet[appName] then return appName end

  local bundleID = app:bundleID() or ""
  local candidates = {
    appName or "",
    bundleID,
  }

  for _, value in ipairs(candidates) do
    if containsIgnoreCase(value, "cursor") then return "Cursor" end
    if containsIgnoreCase(value, "visual studio code") or containsIgnoreCase(value, "vscode") then
      return "Visual Studio Code"
    end
    if containsIgnoreCase(value, "antigravity") then return "Antigravity" end
    if containsIgnoreCase(value, "codex") then return "Codex" end
  end

  return nil
end

-- Find a running app by name, trying multiple lookup strategies
local function findRunningApp(name)
  local app = hs.application.get(name)
  if app and app:isRunning() then return app end
  app = hs.appfinder.appFromName(name)
  if app and app:isRunning() then return app end
  -- Partial/fuzzy match as last resort
  app = hs.application.find(name)
  if app and app:isRunning() then return app end
  -- Final fallback: case-insensitive substring match against running app names.
  -- This handles apps whose displayed name differs slightly (e.g. "OpenAI Codex").
  local lname = string.lower(name)
  local fallback = nil
  for _, runningApp in ipairs(hs.application.runningApplications()) do
    local runningName = runningApp:name()
    if runningName and string.find(string.lower(runningName), lname, 1, true) then
      if runningApp:mainWindow() then
        return runningApp
      end
      fallback = fallback or runningApp
    end
  end
  if fallback and fallback:isRunning() then return fallback end
  return nil
end

-- Only focus an app if it's already running; otherwise do nothing.
local function focusIfRunning(idOrName)
  local app = findRunningApp(idOrName)
  if app then
    app:unhide()
    app:activate(true)
    local win = app:mainWindow()
    if win then win:focus() end
  end
end

-- Application watcher to track focused applications
local appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
  if eventType == hs.application.watcher.activated then
    -- Only update history if we're not in the middle of a manual switch
    if not isSwitching and currentApp and currentApp ~= appObject then
      previousApp = currentApp
    end
    currentApp = appObject
    -- Track last focused editor for F2 priority
    local matchedEditor = nil
    if appName and editorSet[appName] then
      matchedEditor = appName
    else
      matchedEditor = editorNameFromApp(appObject)
      if not matchedEditor then
        local frontWin = hs.window.frontmostWindow()
        matchedEditor = editorNameFromApp(frontWin and frontWin:application() or nil)
      end
    end
    if matchedEditor then
      lastFocusedEditorName = matchedEditor
    end
  end
end)
appWatcher:start()

local function cycleEditors()
  -- Build list of currently running editors
  local runningEditors = {}
  for i, name in ipairs(editorApps) do
    local app = findRunningApp(name)
    if app then
      table.insert(runningEditors, {name = name, app = app})
    end
  end

  if #runningEditors == 0 then return end

  -- If only one editor is running, just focus it
  if #runningEditors == 1 then
    focusIfRunning(runningEditors[1].name)
    return
  end

  -- Find which editor is currently focused (compare by PID for reliability)
  local focused = hs.application.frontmostApplication()
  local focusedPid = focused and focused:pid()
  local focusedEditorIdx = nil

  for i, editor in ipairs(runningEditors) do
    if focusedPid and editor.app:pid() == focusedPid then
      focusedEditorIdx = i
      break
    end
  end

  if focusedEditorIdx then
    -- Current app is an editor: cycle to next running editor
    local nextIdx = focusedEditorIdx % #runningEditors + 1
    local nextName = runningEditors[nextIdx].name
    lastFocusedEditorName = nextName
    focusIfRunning(nextName)
  else
    -- Current app is not an editor:
    -- 1) Prefer the directly previous app if it's an editor.
    -- 2) Otherwise use last tracked editor.
    -- 3) Fallback to the first running editor.
    local target = runningEditors[1].name
    local previousEditor = editorNameFromApp(previousApp)
    if previousEditor then
      for _, editor in ipairs(runningEditors) do
        if editor.name == previousEditor then
          target = previousEditor
          break
        end
      end
    elseif lastFocusedEditorName then
      for _, editor in ipairs(runningEditors) do
        if editor.name == lastFocusedEditorName then
          target = lastFocusedEditorName
          break
        end
      end
    end
    lastFocusedEditorName = target
    focusIfRunning(target)
  end
end

-- Most Important Shortcuts (do nothing if the app isn't already open)
hs.hotkey.bind({}, "F1", function() focusIfRunning("Google Chrome") end)
hs.hotkey.bind({}, "F2", cycleEditors)
hs.hotkey.bind({}, "F3", function() focusIfRunning("iTerm") end)
hs.hotkey.bind({}, "F4", function() focusIfRunning("Notion") end)
hs.hotkey.bind({}, "F5", function() focusIfRunning("Figma") end)

hs.hotkey.bind({"opt"}, "F1", function() focusIfRunning("Google Chrome") end)
hs.hotkey.bind({"opt"}, "F2", cycleEditors)
hs.hotkey.bind({"opt"}, "F3", function() focusIfRunning("iTerm") end)
hs.hotkey.bind({"opt"}, "F4", function() focusIfRunning("Notion") end)
hs.hotkey.bind({"opt"}, "F5", function() focusIfRunning("Figma") end)

-- Capslock (F19) to switch between current and previous app
hs.hotkey.bind({}, "F19", function()
  if previousApp and previousApp:isRunning() then
    isSwitching = true
    previousApp:activate(true)
    -- Swap current and previous
    currentApp, previousApp = previousApp, currentApp
    -- Reset flag after a short delay
    hs.timer.doAfter(0.5, function()
      isSwitching = false
    end)
  end
end)

-- Cycle through main apps
local mainApps = {"Google Chrome", "Cursor", "Visual Studio Code", "Antigravity", "Codex", "iTerm", "Notion", "Figma"}

-- Helper function to find current app index
local function getCurrentAppIndex()
  local focused = hs.application.frontmostApplication()
  if not focused then return 1 end

  local focusedName = focused:name()
  for i, appName in ipairs(mainApps) do
    if focusedName == appName then
      return i
    end
  end
  return 1  -- default to first app if current app not in list
end

-- Right Command (F15) - cycle forward
hs.hotkey.bind({}, "F15", function()
  local currentIndex = getCurrentAppIndex()
  local startIndex = currentIndex
  print("F15: Starting from index " .. currentIndex .. " (" .. mainApps[currentIndex] .. ")")
  local attempts = 0
  repeat
    currentIndex = currentIndex % #mainApps + 1
    attempts = attempts + 1
    print("F15: Trying index " .. currentIndex .. " (" .. mainApps[currentIndex] .. ")")
    local app = hs.application.get(mainApps[currentIndex]) or hs.appfinder.appFromName(mainApps[currentIndex])
    if app and app:isRunning() then
      print("F15: Found running app, activating")
      app:activate(true)
      break
    end
  until attempts >= #mainApps
end)

-- Right Option (F16) - cycle backward
hs.hotkey.bind({}, "F16", function()
  local currentIndex = getCurrentAppIndex()
  print("F16: Starting from index " .. currentIndex .. " (" .. mainApps[currentIndex] .. ")")
  local attempts = 0
  repeat
    currentIndex = currentIndex - 1
    if currentIndex < 1 then currentIndex = #mainApps end
    attempts = attempts + 1
    print("F16: Trying index " .. currentIndex .. " (" .. mainApps[currentIndex] .. ")")
    local app = hs.application.get(mainApps[currentIndex]) or hs.appfinder.appFromName(mainApps[currentIndex])
    if app and app:isRunning() then
      print("F16: Found running app, activating")
      app:activate(true)
      break
    end
  until attempts >= #mainApps
end)

-- Remap CMD+F1..F5 to CMD+1..5 as you had
for i = 1, 5 do
  hs.hotkey.bind({"cmd"}, "F"..i, function()
    hs.eventtap.keyStroke({"cmd"}, tostring(i))
  end)
end

--- Experimental Macros ---
-- local isRunning = false

-- hs.hotkey.bind({"rightcmd"}, "1", function()
--   if isRunning then return end
--   isRunning = true

--   -- Step 1: Focus iTerm2
--   hs.application.launchOrFocus("iTerm")

--   hs.timer.doAfter(1.5, function()
--     hs.eventtap.keyStroke({"cmd"}, "1")  -- Tab 1

--     hs.timer.doAfter(0.3, function()
--       hs.eventtap.keyStrokes("n")
--       hs.eventtap.keyStroke({}, "return")

--       hs.timer.doAfter(0.5, function()
--         hs.application.launchOrFocus("Google Chrome")

--         hs.timer.doAfter(0.5, function()
--           hs.eventtap.keyStroke({"cmd"}, "t")

--           hs.timer.doAfter(0.3, function()
--             hs.eventtap.keyStrokes("localhost:3000")
--             hs.eventtap.keyStroke({}, "return")

--             -- Done: allow re-entry
--             isRunning = false
--           end)
--         end)
--       end)
--     end)
--   end)
-- end)
