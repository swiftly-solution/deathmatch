function RegisterMenus()
    menus:Register("guns", "Guns Menu", "FF0000", {
        { "Rifles", "riflemenu" },
        { "Pistols", "pistolmenu" }
    })

    local enableSnipers = config:Fetch("deathmatch.EnableSnipers")
    local enableScopes  = config:Fetch("deathmatch.EnableGunsWithScopes")

    local rifleMenuItems = {
        { "AK-47", "sw_ak47" },
        { "M4A4", "sw_m4a4" },
        { "M4A1-S", "sw_m4a1" },
    }

    if enableSnipers then
        table.insert(rifleMenuItems, 2, { "AWP", "sw_awp" })
    end

    if enableSnipers or enableScopes then
        table.insert(rifleMenuItems, { "SSG-08", "sw_ssg" })
        table.insert(rifleMenuItems, { "SG-553", "sw_sg" })
    end

    menus:Register("riflemenu", "Rifle Menu", "FF0000", rifleMenuItems)

    menus:Register("pistolmenu", "Pistol Menu", "FF0000", {
        { "Deagle", "sw_deagle" },
        { "USP-S", "sw_usp" },
        { "P250", "sw_p250" }
    })
end
