AddEventHandler("OnPluginStart", function(event)
    RegisterMenus()
end)

AddEventHandler("OnAllPluginsLoaded", function(event)
    if GetPluginState("cookies") == PluginState_t.Started then
        exports["cookies"]:RegisterCookie("deathmatch.primarygun", "weapon_ak47")
        exports["cookies"]:RegisterCookie("deathmatch.secondarygun", "weapon_deagle")
    end
end)
AddEventHandler("OnPlayerSpawn", function(event)
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if player:IsFirstSpawn() then return end
    
    if not player:IsFakeClient() then
        local primaryGun = exports["cookies"]:GetPlayerCookie(playerid, "deathmatch.primarygun") or "weapon_ak47"
        local secondaryGun = exports["cookies"]:GetPlayerCookie(playerid, "deathmatch.secondarygun") or "weapon_deagle"
        player:GetWeaponManager():GiveWeapon(tostring(primaryGun)) 
        player:GetWeaponManager():GiveWeapon(tostring(secondaryGun))
    end

end)

AddEventHandler("OnPlayerDeath", function(event)
    local attackerid = event:GetInt("attacker")
    local attacker = GetPlayer(attackerid)
    if not attacker or not attacker:IsValid() then
        return
    end

    local RegenHP = config:Fetch("deathmatch.RegenHP")
    
    NextTick(function()
        attacker:CBaseEntity().Health = math.min(attacker:CBaseEntity().Health + RegenHP, 100)
        attacker:CCSPlayerPawn().HealthShotBoostExpirationTime = server:GetCurrentTime() + 1
        local weapons = attacker:GetWeaponManager():GetWeapons()
        for i=1,#weapons do
            local maxammo = weapons[i]:CBasePlayerWeaponVData().MaxClip1
            weapons[i]:CBasePlayerWeapon().Clip1 = maxammo
        end
    end)
end)
