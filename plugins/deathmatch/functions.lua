
function UpdateWeapon(player, weapon, bType)
    if bType == "primary" then
        exports["cookies"]:SetPlayerCookie(player:GetSlot(),"deathmatch.primarygun", weapon)
        player:GetWeaponManager():GiveWeapon(weapon)
    elseif bType == "secondary" then
        exports["cookies"]:SetPlayerCookie(player:GetSlot(),"deathmatch.secondarygun", weapon)
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

function SetColor(player, color)
    local playerModelEntity = CBaseModelEntity(player:CCSPlayerPawn())
    if not playerModelEntity:IsValid() then return end
    if player:CBaseEntity().Health > 0 then
        playerModelEntity.RenderMode = RenderMode_t.kRenderGlow
        playerModelEntity.Render = color
    end
end