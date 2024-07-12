AddEventHandler("OnPluginStart", function(event)
    db = Database("deathmatch")
    if not db:IsConnected() then return end

    db:Query("CREATE TABLE IF NOT EXISTS `players_guns` (`steamid` varchar(128) NOT NULL, `primarygun` varchar(128) NOT NULL, `secondarygun` varchar(128) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;")
    RegisterMenus()
end)


AddEventHandler("OnPlayerConnectFull", function(event)
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    db:Query(string.format("SELECT * FROM `players_guns` WHERE steamid = '%s' LIMIT 1", tostring(player:GetSteamID())), function(err, result)
        if #result > 0 then
            local primarygun = result[1]["primarygun"] or "weapon_ak47"
            local secondarygun = result[1]["secondarygun"] or "weapon_deagle"
            player:SetVar("primarygun", primarygun)
            player:SetVar("secondarygun", secondarygun)
        end
    end)


end)

AddEventHandler("OnPlayerSpawn", function(event)
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    
    if player:IsFirstSpawn() then
        db:Query(string.format("SELECT * FROM `players_guns` WHERE steamid = '%s' LIMIT 1", tostring(player:GetSteamID())), function(err, result)
            if #result == 0 then
                db:Query(string.format("INSERT IGNORE INTO `players_guns` (steamid, primarygun, secondarygun) VALUES ('%s', 'weapon_ak47', 'weapon_deagle')", tostring(player:GetSteamID())))
            end
        end)
    end

    if not player:IsFakeClient() then
        player:GetWeaponManager():GiveWeapon(tostring(player:GetVar("primarygun")))
        player:GetWeaponManager():GiveWeapon(tostring(player:GetVar("secondarygun")))
    end

end)

AddEventHandler("OnPlayerDeath", function(event)
    local playerid = event:GetInt("userid")
    local attackerid = event:GetInt("attacker")
    local player = GetPlayer(playerid)
    local attacker = GetPlayer(attackerid)

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
