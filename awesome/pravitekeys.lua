local lain = require("lain")
local awful = require("awful")
local beautiful = require("beautiful")
local volume = lain.widget.pulse()
local altkey = "Mod1"
local modkey = "Mod4"

function run_or_raise (cmd, rule)
   local matcher = function (c)
      return awful.rules.match(c, rule)
   end
   awful.client.run_or_raise(cmd, matcher)
end


pravitekeys = awful.util.table.join(
   -- if app is running, raise it, otherwise launch it
   awful.key({ modkey }, "a",
      function ()
         run_or_raise("google-chrome-stable", {class = "Google-chrome"})
   end),

   awful.key({ modkey }, "q",
      function ()
         run_or_raise("firefox", {class = "firefox"})
   end),

   awful.key({ modkey, "Shift" }, "v",
      function ()
         run_or_raise("VirtualBox", {class = "VirtualBox"})
   end),

   awful.key({ altkey, "Control" }, "r",
      function ()
         run_or_raise("st", {class = "St"})
   end),

   awful.key({ modkey }, "e",
      function ()
         run_or_raise("emacsclient -a '' -c -n", {class = "Emacs"})
         -- run_or_raise("emacs", {class = "Emacs"})
   end),

   awful.key({ modkey }, "d",
      function ()
         run_or_raise("gtk-launch com.alibabainc.dingtalk", {class = "dingtalk"})
         -- run_or_raise("emacs", {class = "Emacs"})
   end),

   awful.key({ modkey, "Shift" }, "e",
      function ()
         run_or_raise("pcmanfm", {class = "Pcmanfm"})
   end),

   awful.key({ modkey }, "p",
      function ()
         awful.spawn.with_shell("screenshot")
   end),

   -- PulseAudio volume control
   awful.key({ }, "XF86AudioRaiseVolume",
      function ()
         os.execute(string.format("pactl set-sink-volume %s +1%%", volume.device))
         volume.update()
         beautiful.volume.update()
   end),
   awful.key({ modkey }, "Up",
      function ()
         os.execute(string.format("pactl set-sink-volume %s +1%%", volume.device))
         volume.update()
         beautiful.volume.update()
   end),
   awful.key({ }, "XF86AudioLowerVolume",
      function ()
         os.execute(string.format("pactl set-sink-volume %s -1%%", volume.device))
         volume.update()
         beautiful.volume.update()
   end),
   awful.key({ modkey }, "Down",
      function ()
         os.execute(string.format("pactl set-sink-volume %s -1%%", volume.device))
         volume.update()
         beautiful.volume.update()
   end),
   awful.key({ }, "XF86AudioMute",
      function ()
         os.execute(string.format("pactl set-sink-mute %s toggle", volume.device))
         volume.update()
         beautiful.volume.update()
   end),
   awful.key({ modkey, "Shift" }, "m",
      function ()
         os.execute(string.format("pactl set-sink-mute %s toggle", volume.device))
         volume.update()
         beautiful.volume.update()
   end)
)

return pravitekeys
