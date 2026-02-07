-- Variables to track current and previous applications for app switching
local currentApp = nil
local previousApp = nil
local isSwitching = false  -- Flag to prevent tracking during manual switches

-- Application watcher to track focused applications
local appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
  if eventType == hs.application.watcher.activated then
    -- Only update history if we're not in the middle of a manual switch
    if not isSwitching and currentApp and currentApp ~= appObject then
      previousApp = currentApp
    end
    currentApp = appObject
  end
end)
appWatcher:start()

-- Only focus an app if it's already running; otherwise do nothing.
local function focusIfRunning(idOrName)
  local app = hs.application.get(idOrName) or hs.appfinder.appFromName(idOrName)
  if app and app:isRunning() then
    app:activate(true)          -- brings it to front without launching
    -- optional: focus its main window if you prefer
    -- local win = app:mainWindow(); if win then win:focus() end
  end
end

-- F2 editor cycling: priority-ordered list of text editors
local editorApps = {"Cursor", "Visual Studio Code", "Antigravity"}
local lastEditorIndex = 0

local function cycleEditors()
  -- Build list of currently running editors
  local runningEditors = {}
  for i, name in ipairs(editorApps) do
    local app = hs.application.get(name) or hs.appfinder.appFromName(name)
    if app and app:isRunning() then
      table.insert(runningEditors, {name = name, priority = i})
    end
  end

  if #runningEditors == 0 then return end

  -- If only one editor is running, just focus it
  if #runningEditors == 1 then
    focusIfRunning(runningEditors[1].name)
    lastEditorIndex = runningEditors[1].priority
    return
  end

  -- Find which editor is currently focused
  local focused = hs.application.frontmostApplication()
  local focusedName = focused and focused:name() or ""
  local focusedEditorIdx = nil

  for i, editor in ipairs(runningEditors) do
    if editor.name == focusedName then
      focusedEditorIdx = i
      break
    end
  end

  if focusedEditorIdx then
    -- Current app is an editor: cycle to next running editor
    local nextIdx = focusedEditorIdx % #runningEditors + 1
    focusIfRunning(runningEditors[nextIdx].name)
    lastEditorIndex = runningEditors[nextIdx].priority
  else
    -- Current app is not an editor: focus highest priority running editor
    focusIfRunning(runningEditors[1].name)
    lastEditorIndex = runningEditors[1].priority
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
local mainApps = {"Google Chrome", "Cursor", "Visual Studio Code", "Antigravity", "iTerm", "Notion", "Figma"}

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
