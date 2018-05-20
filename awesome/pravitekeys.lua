local awful = require("awful");
local altkey = "Mod1"
local modkey = "Mod4"

function run_or_raise (cmd, rule)
   local matcher = function (c)
      return awful.rules.match(c, rule)
   end
   awful.client.run_or_raise(cmd, matcher)
end


pravitekeys = awful.util.table.join(
   awful.key({ altkey, "Control" }, "f",
      function ()
         run_or_raise("firefox", {class = "Firefox"})
   end),

   awful.key({ altkey, "Control" }, "v",
   function ()
      run_or_raise("VirtualBox", {class = "VirtualBox"})
   end),

   awful.key({ altkey, "Control" }, "r",
   function ()
      run_or_raise("urxvtc", {class = "URxvt"})
   end),

   awful.key({ altkey, "Control" }, "e",
   function ()
      run_or_raise("emacs", {class = "Emacs"})
   end),

   awful.key({ altkey, "Shift" }, "e",
   function ()
      run_or_raise("pcmanfm", {class = "Pcmanfm"})
   end)
)

return pravitekeys
