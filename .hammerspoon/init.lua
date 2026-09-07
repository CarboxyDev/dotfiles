-- Keep Hammerspoon active after login.
hs.autoLaunch(true)

-- Variables to track current and previous applications for app switching
local currentApp = hs.application.frontmostApplication()
local previousApp = nil
local currentWindow = hs.window.frontmostWindow()
local previousWindow = nil
local isSwitching = false  -- Flag to prevent tracking during manual switches
local switchSettleDelay = 0.15

local function isSameApp(firstApp, secondApp)
  return firstApp ~= nil
    and secondApp ~= nil
    and firstApp:pid() == secondApp:pid()
end

local function recordActiveApp(app)
  if not app or isSameApp(currentApp, app) then return end
  previousApp = currentApp
  currentApp = app
end

local appBundleIDs = {
  ["Zed"] = "dev.zed.Zed",
  ["Visual Studio Code"] = "com.microsoft.VSCode",
}

local function containsIgnoreCase(haystack, needle)
  if not haystack or not needle then return false end
  return string.find(string.lower(haystack), string.lower(needle), 1, true) ~= nil
end

local function editorNameFromApp(app)
  if not app then return nil end

  local appName = app:name() or ""
  local bundleID = app:bundleID() or ""
  if bundleID == appBundleIDs["Visual Studio Code"]
    or containsIgnoreCase(bundleID, "com.microsoft.vscode")
    or containsIgnoreCase(appName, "visual studio code")
    or string.lower(appName) == "code"
  then
    return "Visual Studio Code"
  end
  return nil
end

-- Find a running app by name, trying multiple lookup strategies
local function findRunningApp(name)
  local function isUsable(app)
    if not app or not app:isRunning() then return false end
    -- Some editors (notably Zed) can briefly report no mainWindow while
    -- starting or restoring a workspace. They are still valid app targets.
    return true
  end

  local app = hs.application.get(appBundleIDs[name] or name)
  if isUsable(app) then return app end
  app = hs.appfinder.appFromName(name)
  if isUsable(app) then return app end
  -- Partial/fuzzy match as last resort
  app = hs.application.find(name)
  if isUsable(app) then return app end
  -- Final fallback: case-insensitive substring match against running app names.
  -- This handles apps whose displayed name differs slightly (e.g. "OpenAI Codex").
  local lname = string.lower(name)
  for _, runningApp in ipairs(hs.application.runningApplications()) do
    local runningName = runningApp:name()
    if editorNameFromApp(runningApp) == name and isUsable(runningApp) then
      return runningApp
    end
    if runningName and string.find(string.lower(runningName), lname, 1, true) and isUsable(runningApp) then
      return runningApp
    end
  end
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
    -- Update immediately; the application watcher callback can arrive later.
    recordActiveApp(app)
  end
end

local function focusFirstRunningApp(appNames)
  for _, name in ipairs(appNames) do
    if findRunningApp(name) then
      focusIfRunning(name)
      return
    end
  end
end

-- Application watcher to track focused applications
dotfilesAppWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
  if eventType == hs.application.watcher.activated then
    -- Read the real frontmost app so a delayed watcher event cannot put stale
    -- history back after a rapid switch.
    local activatedApp = hs.application.frontmostApplication() or appObject
    recordActiveApp(activatedApp)

  end
end)
dotfilesAppWatcher:start()

-- Track focused windows so Mission Control, trackpad, and same-app window changes count.
dotfilesWindowWatcher = hs.window.filter.new(true)
dotfilesWindowWatcher:subscribe(hs.window.filter.windowFocused, function(window)
  if not window then return end

  if not isSwitching and currentWindow and currentWindow:id() ~= window:id() then
    previousWindow = currentWindow
  end
  currentWindow = window
end)

-- Seed app history with the app that is actually focused when Hammerspoon loads.
currentApp = hs.application.frontmostApplication()

-- Most Important Shortcuts (do nothing if the app isn't already open)
hs.hotkey.bind({}, "F1", function() focusIfRunning("Google Chrome") end)
hs.hotkey.bind({}, "F2", function() focusIfRunning("com.openai.codex") end)
hs.hotkey.bind({}, "F3", function() focusFirstRunningApp({"Ghostty", "iTerm"}) end)
hs.hotkey.bind({}, "F4", function() focusIfRunning("Visual Studio Code") end)
hs.hotkey.bind({}, "F5", function() focusIfRunning("Notion") end)
hs.hotkey.bind({}, "F6", function() focusIfRunning("Bruno") end)

hs.hotkey.bind({"alt"}, "F1", function() focusIfRunning("Google Chrome") end)
hs.hotkey.bind({"alt"}, "F2", function() focusIfRunning("com.openai.codex") end)
hs.hotkey.bind({"alt"}, "F3", function() focusFirstRunningApp({"Ghostty", "iTerm"}) end)
hs.hotkey.bind({"alt"}, "F4", function() focusIfRunning("Visual Studio Code") end)
hs.hotkey.bind({"alt"}, "F5", function() focusIfRunning("Notion") end)
hs.hotkey.bind({"alt"}, "F6", function() focusIfRunning("Bruno") end)

local function switchToPreviousWindow()
  if previousWindow and previousWindow:application() and previousWindow:application():isRunning() then
    isSwitching = true
    previousWindow:focus()
    currentWindow, previousWindow = previousWindow, currentWindow
    hs.timer.doAfter(switchSettleDelay, function()
      isSwitching = false
    end)
    return
  end

  -- Fall back to application history if the previous window no longer exists.
  if previousApp and previousApp:isRunning() then
    isSwitching = true
    previousApp:activate(true)
    -- Swap current and previous
    currentApp, previousApp = previousApp, currentApp
    -- Reset flag after a short delay
    hs.timer.doAfter(switchSettleDelay, function()
      isSwitching = false
    end)
  end
end

-- Caps Lock reaches this binding through Karabiner when configured, or through
-- the native hidutil login agent installed with these dotfiles.
hs.hotkey.bind({}, "F19", switchToPreviousWindow)

-- Cycle through main apps
local mainApps = {"Google Chrome", "Codex", "iTerm", "Visual Studio Code", "Zed", "Antigravity", "Notion", "Figma"}

-- Helper function to find current app index
local function getCurrentAppIndex()
  local focused = hs.application.frontmostApplication()
  if not focused then return 1 end

  local focusedPid = focused:pid()
  for i, appName in ipairs(mainApps) do
    local app = findRunningApp(appName)
    if app and app:pid() == focusedPid then
      return i
    end
  end
  return 1  -- default to first app if current app not in list
end

-- Right Option (F16) - cycle backward
hs.hotkey.bind({}, "F16", function()
  local currentIndex = getCurrentAppIndex()
  local attempts = 0
  repeat
    currentIndex = currentIndex - 1
    if currentIndex < 1 then currentIndex = #mainApps end
    attempts = attempts + 1
    local app = findRunningApp(mainApps[currentIndex])
    if app and app:isRunning() then
      app:activate(true)
      break
    end
  until attempts >= #mainApps
end)

-- Remap CMD+F1..F6 to CMD+1..6 as you had
for i = 1, 6 do
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
