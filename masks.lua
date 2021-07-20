PLUGIN.name = "Masks"
PLUGIN.author = "Lechu2375"

ix.char.RegisterVar("masked", {
	field = "masked",
	fieldType = ix.type.bool,
	default = false,
    isLocal = false,
    bNoDisplay = true
})

function PLUGIN:GetCharacterName(speaker, chatType)

    if(speaker:GetCharacter():GetMasked()) then
        local SteamID = speaker:SteamID64()
        SteamID = string.Left(SteamID, 5)
        SteamID = SteamID..speaker:UserID()
        return ("Masked "..SteamID)
    end
end

if(SERVER)then
    function PLUGIN:PlayerInteractItem(client, action, item)
        if(action=="Equip" and item.mask==true)then
            client:GetCharacter():SetMasked(true)
        elseif (action=="EquipUn" and item.mask==true) then
            client:GetCharacter():SetMasked(false)
        end
    end
end
