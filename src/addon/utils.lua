function has_value (tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local count = 0
function get_file_name()
    count = count + 1
    return script.mod_name .. "_" .. count .. ".json"
end