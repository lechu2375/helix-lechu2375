
PLUGIN.name = "Opaski"
PLUGIN.description = "Nowe opaski dla citizenów, które po założeniu wyświetlają pod nickiem stosowny tekst."
PLUGIN.author = "lechu2375"


ix.util.Include("cl_hooks.lua")

function PLUGIN:PrePlayerLoadedCharacter( client, character, currentChar )

    if client:GetNW2String( "band" ) then client:SetNW2String( "band", nil ) end

    for k, v in pairs( character:GetInventory():GetItems() ) do

        if not v.band or not v:GetData( "equip", false ) then continue end

        client:SetNW2String( "band", v.band )

        break

    end

end