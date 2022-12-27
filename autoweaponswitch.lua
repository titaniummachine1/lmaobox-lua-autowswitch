--[[
    script: auto wepaon switch
    by: terminator
]]

local menuLoaded, MenuLib = pcall(require, "Menu")
assert(menuLoaded, "MenuLib not found, please install it!")
assert(MenuLib.Version >= 1.43, "MenuLib version is too old, please update it!")

--[[ Menu ]]
local Menu = MenuLib.Create("auto wepon switch", MenuFlags.AutoSize)
Menu.Style.TitleBg = { 10, 200, 100, 255 }
Menu.Style.Outline = true

local Options = {
    Enabled = Menu:AddComponent(MenuLib.Checkbox("Enable", true)),
    targethealth = Menu:AddComponent(MenuLib.Slider("health percentage", 0, 100, 92)),
    Enabledsafemode = Menu:AddComponent(MenuLib.Checkbox("Enable safe-mode", true))
}

local primaryWeapon = "crossbow" -- set the primary weapon to the heal gun
local lastTick = 0 -- initialize a variable to store the last tick
local client = client
local entities = entities

local function OnCreateMove()
    -- check if the "Enable" button is checked
    if Options.Enabled:GetValue() then
        -- get the local player
        local medic = entities.GetLocalPlayer()

        -- get the players on the team
        local players = entities.FindByClass("CTFPlayer")

        -- initialize a variable to store the target player
        local target = nil

        -- loop through all the players on the team
        for i, player in ipairs(players) do
            -- check if the player is a teammate and is damaged
            if player:GetTeamNumber() == medic:GetTeamNumber() and player:GetHealth() < Options.targethealth:GetValue() then
                -- set the target player
                target = player
                break
            end
        end

        -- check if the medic is using the primary weapon
        if medic:GetActiveWeaponName() == primaryWeapon then
            -- check if the primary weapon has fired
            if medic:GetPropInt("m_nTickBase") > lastTick then
                -- set the lastTick variable to the current tick
                lastTick = medic:GetPropInt("m_nTickBase")

                -- switch back to the secondary weapon
                client.Command("slot2", true)
            end
        else
            -- check if the target player is valid and the medic has more than 1.2 seconds of Ubercharge remaining
            if target and medic:GetPropFloat("m_flUbercharge") > 1.2 then
                -- switch to the primary weapon
                client.Command("slot1", true)
                print("medigun")
            end
        end
    end
end





  
  

local function OnUnload()
    MenuLib.RemoveMenu(Menu)

    client.Command('play "ui/buttonclickrelease"', true)
end

callbacks.Unregister("CreateMove", "PR_CreateMove")
callbacks.Unregister("Unload", "PR_Unload")

callbacks.Register("CreateMove", "PR_CreateMove", OnCreateMove)
callbacks.Register("Unload", "PR_Unload", OnUnload)

client.Command('play "ui/buttonclick"', true)