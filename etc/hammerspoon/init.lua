-- vim: set ts=3 sw=3 et:

local function keyCode(key, modifiers)
   modifiers = modifiers or {}
   return function()
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
      hs.timer.usleep(1000)
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()      
   end
end

local function remapKey(modifiers, key, keyCode)
   hs.hotkey.bind(modifiers, key, keyCode, nil, keyCode)
end

local function disableAllHotkeys()
   for k, v in pairs(hs.hotkey.getHotkeys()) do
      v['_hk']:disable()
   end
end

local function enableAllHotkeys()
   for k, v in pairs(hs.hotkey.getHotkeys()) do
      v['_hk']:enable()
   end
end

local function handleGlobalAppEvent(name, event, app)
   if event == hs.application.watcher.activated then
      --hs.alert.show(name)
      print("name = [" .. name .. "]")
      if name == "iTerm2" or name == "VirtualBox VM" then
         print("disableAllHotkeys")
         disableAllHotkeys()
      else
         print("enableAllHotkeys")
         enableAllHotkeys()
      end
   end
end

appsWatcher = hs.application.watcher.new(handleGlobalAppEvent)
appsWatcher:start()

remapKey({'cmd'}, 'a', keyCode('left', {'cmd'}))
remapKey({'cmd'}, 'e', keyCode('right', {'cmd'}))

remapKey({'option'}, 'tab', keyCode('f1', {'cmd'}))
