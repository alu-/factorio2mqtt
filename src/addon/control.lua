local lookup_table = {}
for k, v in pairs(defines.events) do
    lookup_table[v] = k
end

-- cleanup
-- helpers.remove_path(path)

local count = 0
local function get_file_name()
    count = count + 1
    return script.mod_name .. "_" .. count .. ".json"
end

for k, v in pairs(defines.events) do
    if k ~= "on_tick" and k ~= "on_entity_damaged" then
        script.on_event(
                k,
                function(event)
                    event.id = event.name
                    event.name = lookup_table[event.id]

                    log(serpent.block(event))
                    helpers.write_file(
                            get_file_name(),
                            helpers.table_to_json(event),
                            false,
                            (game.is_multiplayer() and 0 or 1)
                    )
                end
        )
    end
end

