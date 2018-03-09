local chat_range = tonumber(minetest.setting_get("chat_range")) or 100

minetest.register_on_chat_message(function(name, message)
    message = minetest.strip_colors(message)
    local first_char = message:sub(1,1)
    minetest.log(first_char)
    if first_char == "[" then
        local msg = message:sub(2)
        if not msg or msg == "" then
            minetest.chat_send_player(name, "Append \"[\" to the front of your message to broadcast only to players within a "..chat_range.." node radius")
            return true
        end
        local player = minetest.get_player_by_name(name)
        local pos = player:get_pos()
        local objects = minetest.get_objects_inside_radius(pos, chat_range)
        for i, o in pairs(objects) do
            if o:is_player() then
                minetest.chat_send_player(o:get_player_name(), "["..name.."] "..msg)
            end
        end
        return true
    end
end)