--[[
          Lua made by Lena. Have fun. <3
          
    ⠄⠄⠄⣰⣿⠄⠄⠄⠄⠄⢠⠄⠄⢀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
    ⠄⠄⢰⣿⠿⠄⡀⠄⠄⠄⠘⣷⡀⠄⠢⣄⠄⠄⠄⠄⠄⠄⠄⣠⠖⠁⠄⠄⠄⠄
    ⠄⣤⢸⣿⣿⣆⠣⠄⠄⠄⠄⠸⣿⣦⡀⠙⢶⣦⣄⡀⠄⡠⠞⠁⢀⡴⠄⠄⠄⠄
    ⢰⣿⣎⣿⣿⣿⣦⣀⠄⠄⠄⠄⠹⣿⣿⣦⢄⡙⠻⠿⠷⠶⠤⢐⣋⣀⠄⠄⠄⠄
    ⢸⣿⠛⠛⠻⠿⢿⣿⣧⢤⣤⣄⣠⡘⣿⣿⣿⡟⠿⠛⠂⠈⠉⠛⢿⣿⠄⠄⠄⠄
    ⠄⡇⢰⣿⣇⡀⠄⠄⣝⣿⣿⣿⣿⣿⣿⣿⣿⣶⣿⡄⠄⠈⠄⣷⢠⡆⠄⠄⠄⠄
    ⢹⣿⣼⣿⣯⢁⣤⣄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⣴⠶⣲⣵⠟⠄⠄⠄⠄.
    ⠄⢿⣿⣿⣿⣷⣮⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣾⣟⣡⡴⠄⠄⠄⠄⠁
    ⠄⠰⣭⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⡀⠄⠄⠄⠄
    ⠄⠄⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣭⣶⡞⠄⠄⠄⠄⠄
    ⠄⠄⠐⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠄⠄⠄⠄⠄⠄
    ⠄⠄⠄⠈⠻⣿⣿⣿⣿⣿⣿⣯⣿⣯⣿⣾⣿⣿⣿⣿⣿⡿⠋⠄⠄⠄⠄⠄⠄⠄
    ⠄⠄⠄⠄⠄⠄⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣵⠄⠄⠄⠄⠄⠄⠄⠄⠄
    ⠄⠄⠄⠄⠄⠄⠄⢀⣿⣯⣟⣿⣿⣿⡿⣟⣯⣷⣿⣿⡏⣤⠄⠄⠄⠄⠄⠄⠄⠄
    ⠄⠄⠄⠄⠄⠄⠄⣞⢸⣿⣿⣿⣾⣷⣿⣿⣿⣿⣿⣿⣇⣿⡆⠄⠄⠄⠄⠄⠄⠄
]]

-------------------------------------
-- Globals
-------------------------------------

notify = util.toast
wait = util.yield
trigger_commands = menu.trigger_commands
natives_version = "1663599444-uno"
util.require_natives(natives_version)
dev_vers = false

-------------------------------------
-- Lists
-------------------------------------

local online = menu.list(menu.my_root(), "Online", {"lenaonline"}, "Online Options")
local anti_orb = menu.list(online, "Anti Orb", {"antiorb"}, "Protections against the Orbital Cannon.")

-------------------------------------
-- Auto Update
-------------------------------------

local status, auto_updater = pcall(require, "auto-updater")
if not status then
    local auto_update_complete = nil util.toast("Installing auto-updater...", TOAST_ALL)
    async_http.init("raw.githubusercontent.com", "/hexarobi/stand-lua-auto-updater/main/auto-updater.lua",
        function(result, headers, status_code)
            local function parse_auto_update_result(result, headers, status_code)
                local error_prefix = "Error downloading auto-updater: "
                if status_code ~= 200 then util.toast(error_prefix..status_code, TOAST_ALL) return false end
                if not result or result == "" then util.toast(error_prefix.."Found empty file.", TOAST_ALL) return false end
                filesystem.mkdir(filesystem.scripts_dir() .. "lib")
                local file = io.open(filesystem.scripts_dir() .. "lib\\auto-updater.lua", "wb")
                if file == nil then util.toast(error_prefix.."Could not open file for writing.", TOAST_ALL) return false end
                file:write(result) file:close() util.toast("Successfully installed auto-updater lib", TOAST_ALL) return true
            end
            auto_update_complete = parse_auto_update_result(result, headers, status_code)
        end, function() util.toast("Error downloading auto-updater lib. Update failed to download.", TOAST_ALL) end)
    async_http.dispatch() local i = 1 while (auto_update_complete == nil and i < 40) do util.yield(250) i = i + 1 end
    if auto_update_complete == nil then error("Error downloading auto-updater lib. HTTP Request timeout") end
    auto_updater = require("auto-updater")
end
if auto_updater == true then error("Invalid auto-updater lib. Please delete your Stand/Lua Scripts/lib/auto-updater.lua and try again") end

local default_check_interval = 604800
local auto_update_config = {
    source_url="https://raw.githubusercontent.com/Lenalein2001/Orb-Detection/main/Orbital-Detection.lua",
    script_relpath=SCRIPT_RELPATH,
    switch_to_branch=selected_branch,
    verify_file_begins_with="--",
    check_interval=86400,
    silent_updates=false,
    dependencies={
        {
            name="Natives",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Orb-Detection/main/natives-1663599444-uno.lua",
            script_relpath="/lib/natives-1663599444-uno.lua",
            check_interval=default_check_interval,
        },
    }
}

if not dev_vers then
    auto_updater.run_auto_update(auto_update_config)
end

-------------------------------------
-- Functions
-------------------------------------

function BitTest(bits, place)
    return (bits & (1 << place)) ~= 0
end

function IsPlayerUsingOrbitalCannon(player)
    return BitTest(memory.read_int(memory.script_global((2657589 + (player * 466 + 1) + 427))), 0) -- Global_2657589[PLAYER::PLAYER_ID() /*466*/].f_427), 0
end

-------------------------------------
-- Features
-------------------------------------

local IsInOrbRoom = {}
local IsOutOfOrbRoom = {}
local IsAtOrbTable = {}
local IsNotAtOrbTable = {}
announce_orb = false
menu.toggle(anti_orb, "Notify on orb usage", {"notifyorb"}, "Notifies you if a Player has entered the Orbital Cannon Room.", function()
    util.create_tick_handler(function()  
        for pid in players.list(false, true, true) do
            if players.get_position(pid).x > 323 and players.get_position(pid).y < 4834 and players.get_position(pid).y > 4822 and players.get_position(pid).z <= -59.36 then
                if IsOutOfOrbRoom[pid] and not IsInOrbRoom[pid] then
                    notify(players.get_name(pid) .." has entered the orbital cannon room.")
                end
                if players.get_position(pid).x < 331 and players.get_position(pid).x > 330.40 and players.get_position(pid).y > 4830 and players.get_position(pid).y < 4830.40 and players.get_position(pid).z <= -59.36 then
                    if IsNotAtOrbTable[pid] and not IsAtOrbTable[pid] then
                        notify(players.get_name(pid) .." is calling an Orbital Strike!")
                    end
                    IsAtOrbTable[pid] = true
                    IsNotAtOrbTable[pid] = false
                end
                IsInOrbRoom[pid] = true
                IsOutOfOrbRoom[pid] = false
            else
                if IsInOrbRoom[pid] and not IsOutOfOrbRoom[pid] then
                    notify(players.get_name(pid) .." has left the orbital cannon room.")
                end
                IsAtOrbTable[pid] = false
                IsInOrbRoom[pid] = false
                IsOutOfOrbRoom[pid] = true
                IsNotAtOrbTable[pid] = true
            end
        end
    end)
end)

local orbital_blips = {}
local draw_orbital_blips = false
menu.toggle(anti_orb, "Show Orbital Cannon", {"showorb"}, "Shows you where the Player is aiming at.", function(on)
    if not util.is_session_transition_active() then
        draw_orbital_blips = on
        while true do
            if not draw_orbital_blips then 
                for pid, blip in orbital_blips do 
                    util.remove_blip(blip)
                    orbital_blips[pid] = nil
                end
                break 
            end
            for _, pid in players.list(false, true, true) do
                local cam_rot = players.get_cam_rot(pid)
                local cam_pos = players.get_cam_pos(pid)
                if players.is_in_interior(pid) then
                    if IsPlayerUsingOrbitalCannon(pid) then 
                        util.draw_debug_text(players.get_name(pid) .. " is Using the Orbital Cannon!")
                        if orbital_blips[pid] == nil then 
                            local blip = HUD.ADD_BLIP_FOR_COORD(cam_pos.x, cam_pos.y, cam_pos.z)
                            HUD.SET_BLIP_SPRITE(blip, 588)
                            HUD.SET_BLIP_COLOUR(blip, 59)
                            HUD.SET_BLIP_NAME_TO_PLAYER_NAME(blip, pid)
                            orbital_blips[pid] = blip
                        else
                            HUD.SET_BLIP_COORDS(orbital_blips[pid], cam_pos.x, cam_pos.y, cam_pos.z)
                        end
                    else
                        if orbital_blips[pid] ~= nil then 
                            util.remove_blip(orbital_blips[pid])
                            orbital_blips[pid] = nil
                        end
                    end
                end
            end
            wait()
        end
    end
end)

menu.action(menu.my_root(), "Check for Updates", {""}, "", function()
    auto_update_config.check_interval = 0
    if auto_updater.run_auto_update(auto_update_config) then
        notify("No updates found")
    end
end)

function player(pid)
    kick_root = menu.ref_by_rel_path(menu.player_root(pid), "Kick")
    menu.action(kick_root, "Block Kick", {"block"}, "Will kick and block the player from joining you ever again.", function()
        if menu.get_edition() >= 1 then
            if players.get_name(pid) == players.get_name(players.user()) then
                notify("You can't Kick yourself.")
            else
                wait(200)
                trigger_commands("historyblock" .. players.get_name(pid) .. " on")
                wait(200)
                if math.random(1, 100) <= 10 then
                    trigger_commands("ban" .. players.get_name(pid))
                else
                    trigger_commands("breakup" .. players.get_name(pid))
                end
            end
        else
            if players.get_name(pid) == players.get_name(players.user()) then
                notify("You can't Kick yourself.")
            else
                wait(200)
                trigger_commands("historyblock" .. players.get_name(pid) .. " on")
                wait(200)
                trigger_commands("kick" .. players.get_name(pid))
            end
        end
    end, nil, nil, COMMANDPERM_RUDE)
end

players.on_join(player)
players.dispatch_on_join()
util.keep_running()