ITEM.name = "Repair kit"
ITEM.description = "You can use it to repair used weapon."
ITEM.model = "models/props_junk/cardboard_box004a.mdl"
ITEM.fixamount = 35
ITEM.width = 2


if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
        local name = tooltip:AddRow("repair")
        name:SetText(string.format("Repairs weapon by %s points.",self.fixamount)) 
        name:SizeToContents()
        tooltip:SizeToContents()
	end
end

ITEM.functions.use = {
	name = "Fix Weapon",
	tip = "Fix weapon in your hands",
	icon = "icon16/bullet_wrench.png",
	OnRun = function(item)
    	local client = item.player
        local character = item.player:GetCharacter()
        local weaponitem = character:GetEquippedWeaponItem(client:GetActiveWeapon():GetClass())
		weaponitem:SetData("equip",false)
        client:StripWeapon(weaponitem.class)
		client:EmitSound("physics/metal/weapon_footstep2.wav")
		client:SetAction("Repairing weapon...",5,function()
			RepairWeapon(weaponitem,item.fixamount)
			client:EmitSound("physics/metal/weapon_footstep1.wav")
		end)
		return true
	end,
	OnCanRun = function(item)
		local client = item.player
        local character = client:GetCharacter()
        local bCanUse = character:GetEquippedWeaponItem(client:GetActiveWeapon():GetClass())
		return bCanUse
	end
}