data:extend({
    {
        type = "bool-setting",
        name = "factorio2mqtt-enabled",
        localised_name = "Send events",
        setting_type = "runtime-global",
        default_value = true
    },
    {
        type = "string-setting",
        name = "factorio2mqtt-event-list",
        localised_name = "Events to send",
        localised_description = "Leave blank to send all events (not recommended)",
        setting_type = "runtime-global",
        allow_blank = true,
        default_value = "on_console_chat, on_entity_damaged, on_entity_died"
    }
})