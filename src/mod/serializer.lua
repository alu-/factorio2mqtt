local entities = require("entities")
local classes = require("classes")

function serialize(data)
    -- @todo test with other mods
    local function get_fields(subject)
        log(serpent.block(subject))
        --[[
        log("Looking into " .. subject.object_name)
        log("Looking into " .. subject.name)
        log("type name: " .. subject.type) -- resource
        log("object name: " .. subject.object_name) -- LuaEntity
        log("entity name: " .. subject.name) -- copper-ore
        log("entity.prototype.name: " .. subject.prototype.name) -- straight-rail
        log("entity.prototype.object_name: " .. subject.prototype.object_name) -- LuaEntityPrototype
        log("entity.prototype.type: " .. subject.prototype.type) -- straight-rail
        ]]--

        -- various classes that have attributes that cannot be read because of some other state
        if subject.object_name == "LuaItemStack" and not subject.valid_for_read then
            return {}
        elseif subject.object_name == "LuaElectricNetworkFlowStatistics" then
            return {}
        end

        local function should_recurse(field)
            return type(field) == "userdata"
        end

        local fields = {}
        if has_key(classes, subject.object_name) and subject.object_name ~= "LuaEntity" then
            for field_name, subclasses in pairs(classes[subject.object_name]["attributes"]) do
                if subject.object_name == "LuaPlayer" and (field_name == "infinity_inventory_filters" or field_name == "remove_unfiltered_items") then
                    -- @todo This is player being in map editor mode I think, so this needs to be handled here.
                else
                    if #subclasses == 0 then
                        fields[field_name] = subject[field_name]
                    else
                        -- @todo This attribute is only for some subclasses, need a good way to connect a Subclass name to this subject
                        log("Attribute " .. field_name .. " is only for some subclasses, skipping.")
                    end

                end
            end
        elseif has_key(entities, subject.type) then
            for _, field_name in pairs(entities[subject.type]) do
                if (should_recurse(subject[field_name])) then
                    fields[field_name] = get_fields(subject[field_name])
                else
                    fields[field_name] = subject[field_name]
                end
            end
        else
            log("Not in lookup table: " .. subject.type)
            log(serpent.block(subject))
            log(type(subject))
        end

        return fields
    end

    local output = {}
    for k, v in pairs(data) do
        if type(v) == "nil" or type(v) == "boolean" or type(v) == "number" or type(v) == "string" or type(v) == "table" then
            output[k] = v
        elseif type(v) == "userdata" then
            output[k] = get_fields(v)
        else
            -- probably function or thread
            log("Ran into unknown type: " .. type(v))
        end
    end

    return helpers.table_to_json(output)
end
