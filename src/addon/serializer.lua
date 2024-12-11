local entities = require("entities")

function serialize(data)
    -- @todo Write a generator script that generates Entity classes that contain a property list. This insane function is way to cumbersome to maintain.
    local function get_entity_fields(entity)
        local property_list = {
            "absorbed_pollution",
            "active",
            "ai_settings",
            "alert_parameters",
            "allow_dispatching_robots",
            "always_on",
            "amount",
            "armed",
            "artillery_auto_targeting",
            "associated_player",
            "autopilot_destination",
            "autopilot_destinations",
            "backer_name",
            "beacons_count",
            "belt_neighbours",
            "belt_shape",
            "belt_to_ground_type",
            "bonus_mining_progress",
            "bonus_progress",
            "bounding_box",
            "burner",
            "cargo_pod",
            "chain_signal_state",
            "character_corpse_death_cause",
            "character_corpse_player_index",
            "character_corpse_tick_of_death",
            "cliff_orientation",
            "color",
            "combat_robot_owner",
            "combinator_description",
            "commandable",
            "connected_rail",
            "connected_rail_direction",
            "consumption_bonus",
            "consumption_modifier",
            "copy_color_from_train_stop",
            "corpse_expires",
            "corpse_immune_to_entity_placement",
            "crafting_progress",
            "crafting_speed",
            "crane_destination",
            "crane_destination_3d",
            "crane_grappler_destination",
            "crane_grappler_destination_3d",
            "custom_status",
            "damage_dealt",
            "destructible",
            "direction",
            "draw_data",
            "driver_is_gunner",
            "drop_position",
            "drop_target",
            "effective_speed",
            "effectivity_modifier",
            "effects",
            "electric_buffer_size",
            "electric_drain",
            "electric_emissions_per_joule",
            "electric_network_id",
            "electric_network_statistics",
            "enable_logistics_while_moving",
            "energy",
            "energy_generated_last_tick",
            "entity_label",
            "filter_slot_count",
            "fluidbox",
            "fluids_count",
            "follow_offset",
            "follow_target",
            "friction_modifier",
            "ghost_localised_description",
            "ghost_localised_name",
            "ghost_name",
            "ghost_prototype",
            "ghost_type",
            "ghost_unit_number",
            "gps_tag",
            "graphics_variation",
            "grid",
            "health",
            "held_stack",
            "held_stack_position",
            "highlight_box_blink_interval",
            "highlight_box_type",
            "ignore_unprioritised_targets",
            "infinity_container_filters",
            "initial_amount",
            "insert_plan",
            "inserter_filter_mode",
            "inserter_stack_size_override",
            "inserter_target_pickup_count",
            "is_entity_with_health",
            "is_entity_with_owner",
            "is_headed_to_trains_front",
            "is_military_target",
            "item_requests",
            "kills",
            "last_user",
            "link_id",
            "linked_belt_neighbour",
            "linked_belt_type",
            "loader_container",
            "loader_filter_mode",
            "loader_type",
            "localised_description",
            "localised_name",
            "logistic_cell",
            "logistic_network",
            "max_health",
            "minable",
            "mining_drill_filter_mode",
            "mining_progress",
            "mining_target",
            "mirroring",
            "name",
            "name_tag",
            "neighbour_bonus",
            "neighbours",
            "object_name",
            "operable",
            "orientation",
            "parameters",
            "pickup_position",
            "pickup_target",
            "player",
            "pollution_bonus",
            "power_production",
            "power_switch_state",
            "power_usage",
            "previous_recipe",
            "procession_tick",
            "productivity_bonus",
            "products_finished",
            "prototype",
            "proxy_target",
            "pump_rail_target",
            "quality",
            "radar_scan_progress",
            "rail_layer",
            "recipe_locked",
            "relative_turret_orientation",
            "removal_plan",
            "remove_unfiltered_items",
            "render_player",
            "render_to_forces",
            "request_from_buffers",
            "result_quality",
            "robot_order_queue",
            "rocket_parts",
            "rocket_silo_status",
            "rotatable",
            "secondary_bounding_box",
            "secondary_selection_box",
            "selected_gun_index",
            "selection_box",
            "shooting_target",
            "signal_state",
            "spawn_shift",
            "spawning_cooldown",
            "speed",
            "speed_bonus",
            "splitter_filter",
            "splitter_input_priority",
            "splitter_output_priority",
            "stack",
            "status",
            "sticked_to",
            "sticker_vehicle_modifiers",
            "stickers",
            "storage_filter",
            "supports_direction",
            "tags",
            "temperature",
            "tick_grown",
            "tick_of_last_attack",
            "tick_of_last_damage",
            "tile_height",
            "tile_width",
            "time_to_live",
            "time_to_next_effect",
            "timeout",
            "to_be_looted",
            "torso_orientation",
            "train",
            "train_stop_priority",
            "trains_count",
            "trains_in_block",
            "trains_limit",
            "tree_color_index",
            "tree_color_index_max",
            "tree_gray_stage_index",
            "tree_gray_stage_index_max",
            "tree_stage_index",
            "tree_stage_index_max",
            "type",
            "unit_number",
            "units",
            "use_filters",
            "valid",
            "vehicle_automatic_targeting_parameters",
        }

        local o = {}
        for _, field_name in pairs(property_list) do
            log("field name: " .. field_name)
            log("object name: " .. entity.object_name)
            log("entity name: " .. entity.name) -- straight-rail

            if (
                field_name == "spawning_cooldown" or
                field_name == "absorbed_pollution" or
                field_name == "spawn_shift" or
                field_name == "units"
            ) and entity.object_name ~= "Spawner" then
               -- invalid property for this entity object
            elseif field_name == "ai_settings" and (entity.object_name ~= "Unit" or entity.object_name ~= "SpiderUnit") then
                -- invalid property for this entity object
            elseif (
                    field_name == "alert_parameters" or
                    field_name == "parameters"
            ) and entity.object_name ~= "ProgrammableSpeaker" then
                -- invalid property for this entity object
            elseif (
                field_name == "allow_dispatching_robots" or
                field_name == "associated_player" or
                field_name == "player" or
                field_name == "tick_of_last_attack" or
                field_name == "tick_of_last_damage"
            ) and entity.object_name ~= "Character" then
                -- invalid property for this entity object
            elseif field_name == "always_on" and entity.object_name ~= "Lamp" then
                -- invalid property for this entity object
            elseif (
                field_name == "amount" or
                field_name == "initial_amount"
            ) and entity.object_name ~= "ResourceEntity" then
                -- invalid property for this entity object
            elseif (
                field_name == "armed" or
                field_name == "timeout"
            ) and entity.object_name ~= "LandMine" then
                -- invalid property for this entity object
            elseif (
                field_name == "artillery_auto_targeting"
            ) and entity.object_name ~= "ArtilleryWagon" and entity.object_name ~= "ArtilleryTurret" then
                -- invalid property for this entity object
            elseif (
                field_name == "autopilot_destination" or
                field_name == "autopilot_destinations" or
                field_name == "follow_offset" or
                field_name == "follow_target" or
                field_name == "torso_orientation" or
                field_name == "vehicle_automatic_targeting_parameters"
            ) and entity.object_name ~= "SpiderVehicle" then
                -- invalid property for this entity object
            elseif (
                field_name == "belt_neighbours"
            ) and entity.object_name ~= "TransportBeltConnectable" then
                -- invalid property for this entity object
            elseif (
                field_name == "belt_shape"
            ) and entity.object_name ~= "TransportBelt" then
                -- invalid property for this entity object
            elseif (
                field_name == "belt_to_ground_type"
            ) and entity.object_name ~= "UndergroundBelt" then
                -- invalid property for this entity object
            elseif (
                field_name == "bonus_progress" or
                field_name == "crafting_speed" or
                field_name == "crafting_progress" or
                field_name == "result_quality" or
                field_name == "products_finished"
            ) and entity.object_name ~= "CraftingMachine" then
                -- invalid property for this entity object
            elseif (
                field_name == "cargo_pod"
            ) and entity.object_name ~= "RocketSiloRocket" then
                -- invalid property for this entity object
            elseif (
                field_name == "signal_state" or
                field_name == "chain_signal_state"
            ) and entity.object_name ~= "RailChainSignal" then
                -- invalid property for this entity object
            elseif (
                field_name == "character_corpse_death_cause" or
                field_name == "character_corpse_tick_of_death" or
                field_name == "character_corpse_player_index"
            ) and entity.object_name ~= "CharacterCorpse" then
                -- invalid property for this entity object
            elseif (
                field_name == "cliff_orientation"
            ) and entity.object_name ~= "Cliff" then
                -- invalid property for this entity object
            elseif (
                field_name == "combat_robot_owner"
            ) and entity.object_name ~= "CombatRobot" then
                -- invalid property for this entity object
            elseif (
                field_name == "combinator_description"
            ) and (
                entity.object_name ~= "ArithmeticCombinator" or
                entity.object_name ~= "DeciderCombinator" or
                entity.object_name ~= "ConstantCombinator"
            ) then
                -- invalid property for this entity object
            elseif (
                field_name == "connected_rail"
            ) and entity.object_name ~= "CombatRobot" then
                -- invalid property for this entity object
            elseif (
                field_name == "connected_rail" or
                field_name == "connected_rail_direction" or
                field_name == "train_stop_priority" or
                field_name == "trains_count" or
                field_name == "trains_limit"
            ) and entity.object_name ~= "TrainStop" then
                -- invalid property for this entity object
            elseif (
                field_name == "consumption_modifier" or
                field_name == "effectivity_modifier" or
                field_name == "friction_modifier"
            ) and entity.object_name ~= "Car" then
                -- invalid property for this entity object
            elseif (
                field_name == "copy_color_from_train_stop" or
                field_name == "is_headed_to_trains_front" or
                field_name == "draw_data"
            ) and entity.object_name ~= "RollingStock" then
                -- invalid property for this entity object
            elseif (
                field_name == "corpse_expires" or
                field_name == "corpse_immune_to_entity_placement"
            ) and entity.object_name ~= "Corpse" then
                -- invalid property for this entity object
            elseif (
                field_name == "crane_destination" or
                field_name == "crane_destination_3d" or
                field_name == "crane_grappler_destination" or
                field_name == "crane_grappler_destination_3d"
            ) and entity.object_name ~= "AgriculturalTower" then
                -- invalid property for this entity object
            elseif (
                field_name == "damage_dealt" or
                field_name == "ignore_unprioritised_targets" or
                field_name == "kills" or
                field_name == "shooting_target"
            ) and entity.object_name ~= "Turret" then
                -- invalid property for this entity object
            elseif (
                field_name == "enable_logistics_while_moving"
            ) and entity.object_name ~= "Vehicle" then
                -- invalid property for this entity object
            elseif (
                field_name == "energy_generated_last_tick"
            ) and entity.object_name ~= "Generator" then
                -- invalid property for this entity object
            elseif (
                field_name == "electric_network_statistics"
            ) and entity.object_name ~= "ElectricPole" then
                -- invalid property for this entity object
            elseif (
                field_name == "ghost_localised_description" or
                field_name == "ghost_localised_name" or
                field_name == "ghost_name" or
                field_name == "ghost_prototype" or
                field_name == "ghost_type" or
                field_name == "ghost_unit_number"
            ) and entity.object_name ~= "Ghost" then
                -- invalid property for this entity object
            elseif (
                field_name == "held_stack" or
                field_name == "held_stack_position" or
                field_name == "inserter_target_pickup_count" or
                field_name == "inserter_stack_size_override" or
                field_name == "inserter_filter_mode" or
                field_name == "pickup_target" or
                field_name == "pickup_position" or
                field_name == "use_filters"
            ) and entity.object_name ~= "Inserter" then
                -- invalid property for this entity object
            elseif (
                field_name == "highlight_box_type" or
                field_name == "highlight_box_blink_interval"
            ) and entity.object_name ~= "HighlightBox" then
                -- invalid property for this entity object
            elseif (
                field_name == "infinity_container_filters" or
                field_name == "remove_unfiltered_items"
            ) and entity.object_name ~= "InfinityContainer" then
                -- invalid property for this entity object
            elseif (
                field_name == "insert_plan" or
                field_name == "item_requests"
            ) and (entity.object_name ~= "EntityGhost" or entity.object_name ~= "ItemRequestProxy") then
                -- invalid property for this entity object
            elseif (
                field_name == "link_id"
            ) and entity.object_name ~= "LinkedContainer" then
                -- invalid property for this entity object
            elseif (
                field_name == "linked_belt_neighbour" or
                field_name == "linked_belt_type"
            ) and entity.object_name ~= "LinkedBelt" then
                -- invalid property for this entity object
            elseif (
                field_name == "loader_container" or
                field_name == "loader_filter_mode" or
                field_name == "loader_type"
            ) and entity.object_name ~= "Loader" then
                -- invalid property for this entity object
            elseif (
                field_name == "mining_drill_filter_mode" or
                field_name == "mining_target"
            ) and entity.object_name ~= "MiningDrill" then
                -- invalid property for this entity object
            elseif (
                field_name == "neighbour_bonus"
            ) and entity.object_name ~= "Reactor" then
                -- invalid property for this entity object
            elseif field_name == "neighbours" then
                -- this property changes, see https://lua-api.factorio.com/2.0.24/classes/LuaEntity.html#neighbours
            elseif (
                field_name == "power_production" or
                field_name == "power_usage"
            ) and entity.object_name ~= "ElectricEnergyInterface" then
                -- invalid property for this entity object
            elseif (
                field_name == "power_switch_state"
            ) and entity.object_name ~= "PowerSwitch" then
                -- invalid property for this entity object
            elseif (
                field_name == "previous_recipe"
            ) and entity.object_name ~= "Furnace" then
                -- invalid property for this entity object
            elseif (
                field_name == "procession_tick"
            ) and entity.object_name ~= "CargoPod" then
                -- invalid property for this entity object
            elseif (
                field_name == "proxy_target" or
                field_name == "removal_plan"
            ) and entity.object_name ~= "ItemRequestProxy" then
                -- invalid property for this entity object
            elseif (
                field_name == "pump_rail_target"
            ) and entity.object_name ~= "Pump" then
                -- invalid property for this entity object
            elseif (
                field_name == "radar_scan_progress"
            ) and entity.object_name ~= "Radar" then
                -- invalid property for this entity object
            elseif (
                field_name == "rail_layer"
            ) and (entity.object_name ~= "RailSignal" or entity.object_name ~= "RailChainSignal" )  then
                -- invalid property for this entity object
            elseif (
                field_name == "recipe_locked"
            ) and entity.object_name ~= "AssemblingMachine" then
                -- invalid property for this entity object
            elseif field_name == "request_from_buffers" then
                -- Useable only on entities that have requester slots. I don't have a list of these so we'll ignore this for now.
            elseif (
                field_name == "robot_order_queue"
            ) and (entity.object_name ~= "ConstructionRobot" or entity.object_name ~= "LogisticRobot") then
                -- invalid property for this entity object
            elseif (
                field_name == "rocket_parts" or
                field_name == "rocket_silo_status"
            ) and entity.object_name ~= "RocketSilo" then
                -- invalid property for this entity object
            elseif (
                field_name == "selected_gun_index"
            ) and (entity.object_name ~= "Character" or entity.object_name ~= "Car" or entity.object_name ~= "SpiderVehicle") then
                -- invalid property for this entity object
            elseif (
                field_name == "splitter_filter" or
                field_name == "splitter_input_priority" or
                field_name == "splitter_output_priority"
            ) and (entity.object_name ~= "Splitter" or entity.object_name ~= "LaneSplitter") then
                -- invalid property for this entity object
            elseif (
                field_name == "stack" or
                field_name == "to_be_looted"
            ) and entity.object_name ~= "ItemEntity" then
                -- invalid property for this entity object
            elseif (
                field_name == "sticked_to"
            ) and entity.object_name ~= "Sticker" then
                -- invalid property for this entity object
            elseif field_name == "storage_filter" then
                -- Useable only on logistic containers with the "storage" logistic_mode https://lua-api.factorio.com/2.0.24/classes/LuaEntity.html#storage_filter
            elseif (
                field_name == "tick_grown"
            ) and entity.object_name ~= "Plant" then
                -- invalid property for this entity object
            elseif (
                field_name == "time_to_live"
            ) and (entity.object_name ~= "CombatRobot" or entity.object_name ~= "HighlightBox" or entity.object_name ~= "Smoke" or entity.object_name ~= "Sticker") then
                -- invalid property for this entity object
            elseif (
                field_name == "time_to_next_effect"
            ) and entity.object_name ~= "SmokeWithTrigger" then
                -- invalid property for this entity object
            elseif (
                field_name == "trains_in_block"
            ) and entity.object_name ~= "Rail" then
                -- invalid property for this entity object
            elseif (
                field_name == "tree_color_index" or
                field_name == "tree_color_index_max" or
                field_name == "tree_gray_stage_index" or
                field_name == "tree_gray_stage_index_max" or
                field_name == "tree_stage_index" or
                field_name == "tree_stage_index_max"
            ) and entity.object_name ~= "Tree" then
                -- invalid property for this entity object

            else
                o[field_name] = entity[field_name]
            end
        end

        log(serpent.block(entities[entity.name]))

        return o
    end

    --game.print(serpent.block(data))
    local output = {}
    for k, v in pairs(data) do
        if type(v) == "string" then
            output[k] = v
        elseif type(v) == "number" then
            output[k] = v
        elseif type(v) == "userdata" then
            if v.object_name == "LuaEntity" then
                output[k] = get_entity_fields(v)
            else
                game.print("HANDLE NEW CLASS: " .. v.object_name)
            end
        else
            game.print("wut: " .. k .. " type: " .. type(v))
            --game.print(serpent.block(v))

            for a, b in pairs(v) do
                game.print(a)
                game.print(b)
            end

            output[k] = v
        end
    end

    return helpers.table_to_json(output)
end
