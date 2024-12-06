-- @todo check that mod is compatible with other mods that are using custom events
-- @todo create a custom event that logs generic json messages, for use with other mods
require("utils")

-- setting variables
local enabled = settings.global["factorio2mqtt-enabled"].value
local on_alert_enabled = settings.global["factorio2mqtt-alerts"].value
local enabled_events = {}

-- cache variables
local alerts_seen = {}
local lookup_table = {}
for k, v in pairs(defines.events) do
    lookup_table[v] = k
end

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

local function send(data, type)
    if type == "on_event" then
        data.id = data.name
        data.name = lookup_table[data.id]
    elseif type == "alert" then
        game.print("Hydrate alert")
    end

    helpers.write_file(
        get_file_name(),
        helpers.table_to_json(data), -- serpent.dump or game.table_to_json?
        false,
        (game.is_multiplayer() and 0 or 1)
    )
end

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
        send(event, "on_event")
    end
end

local function compare_alerts(a1, a2)
    -- @todo compare a lot more stuff
    return a1["tick"] == a2["tick"]
end

local function is_new_alert(alert)
    for _, old_alert in pairs(alerts_seen) do
        if compare_alerts(alert, old_alert) then
            game.print("ALERT IS SAME")
            return false
        end
    end

    game.print("This alert is new, recording it")
    game.print(helpers.table_to_json(alert))

    table.insert(alerts_seen, alert)
    return true
end

local function on_alert()
    if on_alert_enabled then
        -- game.print(helpers.table_to_json(defines.alert_type))
        for index, player in pairs(game.players) do
            local alerts_by_surface = player.get_alerts({})
            for surface_index, alerts_by_type in pairs(alerts_by_surface) do
                for alert_type, alerts in pairs(alerts_by_type) do
                    for _, alert in pairs(alerts) do
                        -- @todo check if this alert is in alerts_seen
                        -- @todo clean alerts_seen, somehow. max ticks?
                        if is_new_alert(alert) then
                            send(alert, "alert")
                        end
                        --game.print(alert_type)
                        --game.print(helpers.table_to_json(alert))
                        -- alert tick is the same for all events if they are the same, should we cache this and only show new ticks?
                        -- better would be an on_alert event..
                    end
                end
            end
        end
    end
end

load_enabled_events()

for event_name, _ in pairs(defines.events) do
    script.on_event(event_name, on_event)
end
script.on_nth_tick(60, on_alert);