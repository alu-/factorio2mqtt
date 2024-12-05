-- @todo verify that mod works in multiplayer
-- @todo check that mod is compatible with other mods that are using custom events
require("utils")

local lookup_table = {}
for k, v in pairs(defines.events) do
    lookup_table[v] = k
end

local function send(event)
    event.id = event.name
    event.name = lookup_table[event.id]
    helpers.write_file(
        get_file_name(),
        helpers.table_to_json(event),
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
local on_alert_enabled = settings.global["factorio2mqtt-alerts"].value

local function on_event(event)
    if event.name == defines.events.on_runtime_mod_setting_changed then
        if event.setting == "factorio2mqtt-event-list" then
            enabled_events = {}
            load_enabled_events()
        elseif event.setting == "factorio2mqtt-enabled" then
            enabled = settings.global["factorio2mqtt-enabled"].value
        elseif event.setting == "factorio2mqtt-alerts" then
            on_alert_enabled = settings.global["factorio2mqtt-alerts"].value
        end
    end
    
    if enabled and has_value(enabled_events, lookup_table[event.name]) then
        send(event)
    end
end

for event_name, _ in pairs(defines.events) do
    script.on_event(event_name, on_event)
end

local function on_alert()
    if on_alert_enabled then
        -- game.print(helpers.table_to_json(defines.alert_type))
        for index, player in pairs(game.players) do
            local alerts_by_surface = player.get_alerts({})
            for surface_index, alerts_by_type in pairs(alerts_by_surface) do
                for alert_type, alerts in pairs(alerts_by_type) do
                    for _, alert in pairs(alerts) do
                        game.print(alert_type)
                        game.print(helpers.table_to_json(alert))
                        -- alert tick is the same for all events if they are the same, should we cache this and only show new ticks?
                        -- better would be an on_alert event..
                    end
                end
            end
        end
    end
end

script.on_nth_tick(60, on_alert);