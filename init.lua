-- Hammerspoon Configurations

----------------------------------------------------
--------------- Default Bindings -------------------
----------------------------------------------------
cmd2CtrlKeys = {
    "z",    -- Undo
    "s",    -- Save
    "a"     -- Select All
}
for i=1,#cmd2CtrlKeys do
    local key = cmd2CtrlKeys[i]
    hs.hotkey.bind({"ctrl"}, key, nil, function()
        hs.eventtap.keyStroke({"cmd"}, key)
      end)
end


ctrlShiftKeys = {
    "c",    -- Copy
    "v",    -- Paste
    "z",    -- Redo
}
for i=1,#ctrlShiftKeys do

    local key = ctrlShiftKeys[i]
    hs.hotkey.bind({"ctrl", "shift"}, key, nil, function()
        hs.eventtap.keyStroke({"cmd"}, key)
      end)
end

-- ctrl+shift+z = Redo
hs.hotkey.bind({"ctrl", "shift"}, "z", nil, function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "z")
  end)

-- Rebind quit from cmd+q to cmd+shift+q
hs.hotkey.bind({"cmd"}, "q", nil, function()
    showToast("Use cmd+shift+q")
  end)
hs.hotkey.bind({"cmd", "shift"}, "q", nil, function()
    local app = hs.application.frontmostApplication()
    app:kill()
  end)

----------------------------------------------------
-------------- Workspace Bindings ------------------
----------------------------------------------------
local workspaceMap = {
    {
        app="Firefox.app",
        hotkey="2",
        hint="2"
    },
    {
        app="iterm.app",
        hotkey="1",
        hint="1"
    },
    {
        app="Visual Studio Code.app",
        hotkey="3",
        hint="3"
    },
    {
        app="Slack.app",
        hotkey="4",
        hint="4"
    },
}
for i, d in pairs(workspaceMap) do
    local appName = workspaceMap[i]["app"] 
    local hotKey = workspaceMap[i]["hotkey"]
    local hint = workspaceMap[i]["hint"]
    -- showToast("ctrl + " .. d)
    hs.hotkey.bind({"ctrl", "alt", "shift", "cmd"}, hotKey, function()
        showToast(hint)
        hs.application.launchOrFocus(appName)
        focusVScode:disable()
        hs.eventtap.keyStroke({"ctrl", "alt", "shift", "cmd"}, hotKey)
      end)
end

hs.window.filter.new('Firefox.app')
    :subscribe(hs.window.filter.windowFocused, function() focusVScode:enable() end)
    :subscribe(hs.window.filter.windowUnfocused, function() focusVScode:disable() end)

----------------------------------------------------
--------------- Browser Bindings -------------------
----------------------------------------------------

browserNames = {
    "Brave Browser",
    "Google Chrome",
    "Firefox",
    "Safari"
}
browserBindings = { 
    "l",    -- Focus address bar
    "t",    -- Create a new tab
    "w",    -- Close current tab
    "r",    -- Reload current tab
    "c",
    "v"
}

for i=1,#browserNames do
    for j=1,#browserBindings do
        
        local key = browserBindings[j]
        local browserHandler = hs.hotkey.new("ctrl", key, nil, function()
            hs.eventtap.keyStroke({"cmd"}, key)
            -- showToast("ctrl + " .. key)
          end)

        hs.window.filter.new(browserNames[i])
            :subscribe(hs.window.filter.windowFocused,function() browserHandler:enable() end)
            :subscribe(hs.window.filter.windowUnfocused,function() browserHandler:disable() end)
    
    end
end


----------------------------------------------------
--------------- Copy/Paste Bindings ----------------
----------------------------------------------------
-- MOVED TO KARA
-- editorNames = {
--     "Sublime Text",
--     "PyCharm CE",
--     "Visual Studio Code",

--     "Brave Browser",
--     "Google Chrome",
--     "Firefox",
--     "Safari"

--     -- "iTerm2"    -- blocks ctrl+c interrupt

-- }
-- editorBindings =  {
--     "c",    -- Copy
--     "v",    -- Paste 
-- }

-- for i=1,#editorNames do
--     for j=1,#editorBindings do
        
--         local key = editorBindings[j]
--         local editorHandler = hs.hotkey.new("ctrl", key, nil, function()
--             hs.eventtap.keyStroke({"cmd"}, key)
--             -- showToast("ctrl + " .. key)
--           end)

--         hs.window.filter.new(browserNames[i])
--             :subscribe(hs.window.filter.windowFocused,function() editorHandler:enable() end)
--             :subscribe(hs.window.filter.windowUnfocused,function() editorHandler:disable() end)
    
--     end
-- end

----------------------------------------------------
----------------- Iterm2 Bindings -------------------
----------------------------------------------------

itermBindings = {
    "t",    -- New Tab
    -- "w",    -- Close Window, messes with vim ctrl+ww
    "n",    -- New Window
}

for i=1,#itermBindings do

    local key = itermBindings[i]
    local itermHandler = hs.hotkey.new("ctrl", key, nil, function()
        hs.eventtap.keyStroke({"cmd"}, key)
        -- showToast("ctrl + " .. key)
      end)

    hs.window.filter.new("iTerm2")
        :subscribe(hs.window.filter.windowFocused,function() itermHandler:enable() end)
        :subscribe(hs.window.filter.windowUnfocused,function() itermHandler:disable() end)
    
end

----------------------------------------------------
-------------------- Utils -------------------------
----------------------------------------------------

function showNotification(msg)
    hs.notify.new({title=msg, informativeText="Hammerspoon"}):send()
end

function showToast(msg)
    hs.alert.show(msg)
end
