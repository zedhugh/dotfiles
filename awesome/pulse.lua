local helpers = require("lain.helpers")
local dkjson  = require("lain.util.dkjson")
local shell   = require("awful.util").shell
local wibox   = require("wibox")
local string  = string
local type    = type

-- PulseAudio volume
-- lain.widget.pulse

local function get_device_name(sink)
   local names = {
      sink.description,
      sink.properties["api.alsa.path"],
      sink.properties["device.description"],
   }

   local name = names[1]
   for i = 2, #names do
      local current_name = names[i]

      if not name then
         name = names[i]
      elseif current_name and string.len(name) > string.len(current_name) then
         name = current_name
      end
   end

   return name or "N/A"
end

local function split_sink_and_json(text)
   local fn = string.gmatch(text, "[^\r\n]+")
   local default_sink = fn()
   local json_text = fn()
   return default_sink, json_text
end

local function parse_sink(text)
   local sink_name, json_text = split_sink_and_json(text)

   local sink
   for _, s in pairs(dkjson.decode(json_text)) do
      if sink then
         break
      end
      if s.name == sink_name then
         sink = s
      end
   end

   local names = {}

   local channel_map, vol, props = sink.channel_map, sink.volume, sink.properties

   local channel = {}
   local ch = 1
   for ch_name in string.gmatch(channel_map, "([%w-]+)") do
      local vol_text = vol[ch_name].value_percent
      channel[ch] = string.match(vol_text, "(%d+)%%") or "N/A"
      ch = ch + 1
   end

   local volume = {
      index = sink.index,
      device = get_device_name(sink),
      muted = sink.mute,
      channel = channel,
      left = channel[1] or "N/A",
      right = channel[2] or "N/A",
   }

   return volume
end

local function factory(args)
   args           = args or {}

   local pulse    = { widget = args.widget or wibox.widget.textbox(), device = "N/A" }
   local timeout  = args.timeout or 5
   local settings = args.settings or function() end

   pulse.devicetype = args.devicetype or "sink"
   pulse.cmd = args.cmd or "pactl get-default-" .. pulse.devicetype .. ";pactl -f json list " .. pulse.devicetype .. "s"

   function pulse.update()
      helpers.async({ shell, "-c", type(pulse.cmd) == "string" and pulse.cmd or pulse.cmd() },
         function(s)
            if not s or #s == 0 then
               volume_now = nil
            else
               volume_now = parse_sink(s)
               pulse.device = volume_now.index
            end

            widget = pulse.widget
            settings()
      end)
   end

   helpers.newtimer("pulse", timeout, pulse.update)

   return pulse
end

return factory
