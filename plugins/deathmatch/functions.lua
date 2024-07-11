
function UpdateWeapon(player, weapon, bType)
    if bType == "primary" then
        player:SetVar("primarygun", weapon)
        db:Query(string.format("UPDATE `players_guns` SET primarygun = '%s' WHERE steamid = '%s'", weapon, tostring(player:GetSteamID())))
        player:GetWeaponManager():GiveWeapon(weapon)
    elseif bType == "secondary" then
        player:SetVar("secondarygun", weapon)
        db:Query(string.format("UPDATE `players_guns` SET secondarygun = '%s' WHERE steamid = '%s'", weapon, tostring(player:GetSteamID())))
        player:GetWeaponManager():GiveWeapon(weapon)
    end
end

function GetWeaponFromSlot(player, slot_id)
    if not player then return nil end
    local weapons = player:GetWeaponManager():GetWeapons()
    for i=1,#weapons do
        if weapons[i]:CCSWeaponBaseVData().GearSlot == slot_id then
            return weapons[i]
        end
    end
    return nil
end