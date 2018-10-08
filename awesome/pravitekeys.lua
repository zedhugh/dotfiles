local awful = require("awful");
local beautiful = require("beautiful")
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
         run_or_raise("android-studio", {class = "jetbrains-studio"})
   end),

   awful.key({ modkey }, "q",
      function ()
         run_or_raise("firefox", {class = "Nightly"})
   end),

   awful.key({ modkey, "Shift" }, "v",
      function ()
         run_or_raise("VirtualBox", {class = "VirtualBox"})
   end),

   awful.key({ altkey, "Control" }, "r",
      function ()
         run_or_raise("urxvtc", {class = "URxvt"})
   end),

   awful.key({ modkey }, "e",
      function ()
         run_or_raise("emacs", {class = "Emacs"})
   end),

   awful.key({ modkey, "Shift" }, "e",
      function ()
         run_or_raise("pcmanfm", {class = "Pcmanfm"})
   end),

   -- ALSA volume control
   awful.key({ }, "XF86AudioRaiseVolume",
      function ()
         os.execute(string.format("amixer set %s 1%%+", beautiful.volume.channel))
         beautiful.volume.update()
   end),
   awful.key({ modkey }, "Up",
      function ()
         os.execute(string.format("amixer set %s 1%%+", beautiful.volume.channel))
         beautiful.volume.update()
   end),
   awful.key({ }, "XF86AudioLowerVolume",
      function ()
         os.execute(string.format("amixer set %s 1%%-", beautiful.volume.channel))
         beautiful.volume.update()
   end),
   awful.key({ modkey }, "Down",
      function ()
         os.execute(string.format("amixer set %s 1%%-", beautiful.volume.channel))
         beautiful.volume.update()
   end),
   awful.key({ }, "XF86AudioMute",
      function ()
         os.execute(string.format("amixer set %s toggle", beautiful.volume.togglechannel
                                     or beautiful.volume.channel))
         beautiful.volume.update()
   end),
   awful.key({ modkey, "Shift" }, "m",
      function ()
         os.execute(string.format("amixer set %s toggle", beautiful.volume.togglechannel
                                     or beautiful.volume.channel))
         beautiful.volume.update()
   end)
)

return pravitekeys
