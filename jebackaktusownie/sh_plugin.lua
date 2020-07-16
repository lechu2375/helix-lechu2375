PLUGIN.name ="TFA Attchs as items"
PLGUIN.description = "Jebac kaktusownie"

function PLUGIN:TFA_PreCanAttach(wep,attn)
    return (wep:GetOwner():GetCharacter():GetInventory():HasItem(attn))
end

    local items= {}
    for k,_ in pairs(TFA.Attachments.Atts) do
        items[k]={
            ["name"] = k,
            ["model"] = "models/props_junk/cardboard_box004a.mdl",
            ["width"] = 1,
		    ["height"] = 1,
            ["desc"] = "You can attach it to the weapon."
        }
    end
    for k,v in pairs(items) do
        local ITEM = ix.item.Register(k, nil, false, nil, true)
        ITEM.name = v.name
        ITEM.description = v.desc
        ITEM.model = v.model
        ITEM.width = v.width or 1
        ITEM.height = v.height or 1
        ITEM.category = "attachmens"
        function ITEM:GetDescription()
		    return self.description
	    end
    end

concommand.Add("getattachements", function(ply)
    PrintTable(ply:GetActiveWeapon().AttachmentCache)
end)