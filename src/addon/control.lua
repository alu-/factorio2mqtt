-- @todo verify that mod works in multiplayer
-- @todo check that mod is compatible with other mods that are using custom events
require("utils")
require("serializer")

local lookup_table = {}
for k, v in pairs(defines.events) do
    lookup_table[v] = k
end

local function send(event)
    event.id = event.name
    event.name = lookup_table[event.id]
    helpers.write_file(
        get_file_name(),
        serialize(event),
        false,
        (game.is_multiplayer() and 0 or 1)
    )
end

local enabled_events = {}
local function load_enabled_events()
    local event_settings = settings.global["factorio2mqtt-event-list"].value
    if event_settings == "" then
        for k, v in pairs(defines.events) do
            table.insert(enabled_events, k)
        end
    else
        for i in string.gmatch(event_settings, '([^, ]+)') do
            table.insert(enabled_events, i)
        end
    end
end
load_enabled_events()
local enabled = settings.global["factorio2mqtt-enabled"].value

local function on_event(event)
    if event.name == defines.events.on_runtime_mod_setting_changed then
        if event.setting == "factorio2mqtt-event-list" then
            enabled_events = {}
            load_enabled_events()
        elseif event.setting == "factorio2mqtt-enabled" then
            enabled = settings.global["factorio2mqtt-enabled"].value
        end
    end

    if enabled and has_value(enabled_events, lookup_table[event.name]) then
        send(event)
    end
end

for event_name, _ in pairs(defines.events) do
    if event_name ~= "on_tick" then -- todo remove this line, this is just to test easier without console spam
        script.on_event(event_name, on_event)
    end
end
