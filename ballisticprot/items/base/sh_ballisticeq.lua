ITEM.name = "Ballistic plate"
ITEM.model = Model("models/gibs/metal_gib4.mdl")
ITEM.description = "Daje przewagę jak cie cos  jebnie"
ITEM.protectionlevel =  1


if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end


function ITEM:GetDescription()
	local dDesc = self.description
	local basicDur = self.protectionlevel*100
	local durability = self:GetData("durability") or basicDur
	local toadd = ""
	if durability<=basicDur*.2 then
		toadd="Destroyed"
	elseif durability<=basicDur*.5 then
		toadd="Damaged"
	elseif durability<=basicDur*.75 then
		toadd="Used"
	else 
		toadd="New"
	end
	return dDesc.."\nStatus: "..toadd.."\nClass:"..self.protectionlevel
end

ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
		item:RemovePlate(item.player)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		local client = item.player
		local char = client:GetCharacter()
		local items = char:GetInventory():GetItems()

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (v.base == item.base and itemTable:GetData("equip")) then
					client:Notify("Plate already equipped")
					return false
				end
			end
		end
		item:SetData("equip", true)
		item:OnEquipped()
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and item:CanEquipOutfit() and
			hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

function ITEM:RemovePlate(client)
	local character = client:GetCharacter()
	self:SetData("equip", false)
	self:OnUnequipped()
end


ITEM:Hook("drop", function(item)
	if (item:GetData("equip")) then
		item:RemovePlate(item:GetOwner())
	end
end)

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		return false
	end

	return true
end

function ITEM:OnRemoved()
	if (self.invID != 0 and self:GetData("equip")) then
		self.player = self:GetOwner()
			self:RemovePlate(self.player)
		self.player = nil
	end
end

function ITEM:OnEquipped()
end

function ITEM:OnUnequipped()
end

function ITEM:CanEquipOutfit()
	return true
end