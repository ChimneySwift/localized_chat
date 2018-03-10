local chat_range = tonumber(minetest.setting_get("chat_range")) or 50

local function send_online_staff(message)
    local players = minetest.get_connected_players()
    for i in pairs(players) do
        local name = players[i]:get_player_name()
        if minetest.check_player_privs(name, {kick=true})then
            minetest.chat_send_player(name, message)
        end
    end
end

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
        local message = "["..name.."] "..msg

        -- Send to all staff
        send_online_staff(message)

        -- Get pos to send from
        local player = minetest.get_player_by_name(name)
        local pos = player:get_pos()

        -- Get objects
        local objects = minetest.get_objects_inside_radius(pos, chat_range)
        for i, o in pairs(objects) do
            -- Only send to players who aren't staff (otherwise staff will get 2 messages)
            if o:is_player() then
                local name = o:get_player_name()
                if not minetest.check_player_privs(name, {kick=true}) then
                    minetest.chat_send_player(name, message)
                end
            end
        end
        return true
    end
end)
