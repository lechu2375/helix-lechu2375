
PLUGIN.name = "Talking NPCs"
PLUGIN.author = "Black Tea (NS 1.0), Neon (NS 1.1) Lechu2375(IX)"
PLUGIN.desc = "Adding talking NPCs."

PLUGIN.chatDelay = { min = .5, max = 1 }
PLUGIN.defaultDialogue = {
	npc = {
		["_start"] = "Hello, This is default Text.",
		["test1"] = "He is also known as 'Black Tea'. He is really famous for incredible sucky coding skill and not working buggy code. Long time ago, I suggested him to kill himself but he refused.",
		["!vendoropen"] = "Maybe.",
	},
	player = {
		["_quit"] = "I gotta go.",
		["test1"] = "Can you tell me who is rebel1324?",
		["!vendoropen"] = "Do you have something for me?"
	},
}


if (SERVER) then
	local PLUGIN = PLUGIN
	
	function PLUGIN:SaveData()
		local data = {}
			for k, v in ipairs(ents.FindByClass("ix_talker")) do
				local inventory = v:GetInventory()
				data[#data + 1] = {
					name = v:GetNetVar("name"),
					desc = v:GetNetVar("desc"),
					pos = v:GetPos(),
					angles = v:GetAngles(),
					model = v:GetModel(),
					factions = v:GetNetVar("factiondata", {}),
					dialogue = v:GetNetVar( "dialogue", self.defaultDialogue ),
					classes = v:GetNetVar("classdata", {}),
					bubble = v:GetNoBubble(),
					money = v.money,
					items = v.items,
					bodygroupstring = GetBodygroupString(v),
					talkerskin = v:GetSkin()
				}
			end

		self:SetData(data)
	end

	function PLUGIN:LoadData()
		for k, v in ipairs(self:GetData() or {}) do
			local entity = ents.Create("ix_talker")
			entity:SetPos(v.pos)
			entity:SetAngles(v.angles)
			entity:Spawn()
			entity:SetModel(v.model)
			entity:SetNetVar("dialogue", v.dialogue)
			entity:SetNetVar("factiondata", v.factions)
			entity:SetNetVar("classdata", v.classes)
			entity:SetNetVar("name", v.name)
			entity:SetNetVar("desc", v.desc)
			entity:SetNoBubble(v.bubble)
			SetBodygroupsByString(entity,v.bodygroupstring)
			entity:SetSkin((v.talkerskin or 0))
			entity.money = v.money
			local items = {}

			for uniqueID, data in pairs(v.items) do
				if (not data or not ix.item.Get(tostring(uniqueID))) then continue end
				items[tostring(uniqueID)] = data
			end
			entity.items = items
		end
	end
end




function GetBodygroupString(ent) 
	local amount = ent:GetNumBodyGroups()
	local bodygroups = ""
	for i=1,amount do
		bodygroups=bodygroups..ent:GetBodygroup(i)
	end
	return bodygroups
end

function SetBodygroupsByString(ent,bodygroupstring) 
	if(!bodygroupstring) then return end
	local amount = string.len(bodygroupstring)
	local bodygroups = bodygroupstring
	for i=1,amount do
		ent:SetBodygroup(i,string.sub(bodygroupstring,i,i))
	end
	return bodygroups
end








if(SERVER)then
	net.Receive("ixVendorRemakeOpen", function()
		print("essa2")
		if (IsValid(ix.gui.menu)) then
			net.Start("ixVendorRemakeClose")
			net.SendToServer()
			return
		end
		
		local entity = net.ReadEntity()
		
		if (!IsValid(entity)) then
			return
		end
		
		entity.money = net.ReadUInt(16)
		entity.items = net.ReadTable()

		local inventory = entity:GetInventory()
		if (inventory and inventory.slots) then
			if IsValid(ix.gui.vendorRemake) then
				ix.gui.vendorRemake:Remove()
			end
			
			local localInventory = LocalPlayer():GetCharacter():GetInventory()
			ix.gui.vendorRemake = vgui.Create("ixVendorRemakeView")
			ix.gui.vendorRemake.entity = entity
			
			if (localInventory) then
				ix.gui.vendorRemake:SetLocalInventory(localInventory)
			end
			
			ix.gui.vendorRemake:SetVendorTitle(entity:GetDisplayName())
			ix.gui.vendorRemake:SetVendorInventory(entity:GetInventory())
			
			if (entity.money) then
				if (localInventory) then
					ix.gui.vendorRemake:SetLocalMoney(LocalPlayer():GetCharacter():GetMoney())
				end
				ix.gui.vendorRemake:SetVendorMoney(entity.money)
			end
		end
	end)


end













properties.Add("vendor_edit2", {
	MenuLabel = "Edit Vendor",
	Order = 999,
	MenuIcon = "icon16/user_edit.png",

	Filter = function(self, entity, client)
		if (!IsValid(entity)) then return false end
		if (entity:GetClass() != "ix_talker") then return false end
		if (!gamemode.Call( "CanProperty", client, "vendor_edit", entity)) then return false end

		return CAMI.PlayerHasAccess(client, "Helix - Manage Vendors", nil)
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		local entity = net.ReadEntity()

		if (!IsValid(entity)) then return end
		if (!self:Filter(entity, client)) then return end

		entity.receivers[#entity.receivers + 1] = client

		local itemsTable = {}

		for k, v in pairs(entity.items) do
			if (!table.IsEmpty(v)) then
				itemsTable[k] = v
			end
		end

		client.ixVendor = entity

		net.Start("ixVendorEditor")
			net.WriteEntity(entity)
			net.WriteUInt(entity.money or 0, 16)
			net.WriteTable(itemsTable)
			net.WriteFloat(entity.scale or 0.5)
			net.WriteTable(entity.messages)
			net.WriteTable(entity.factions)
			net.WriteTable(entity.classes)
		net.Send(client)
	end
})
properties.Add("vendor_fixlegs", {
	MenuLabel = "FixLegs",
	Order = 998,
	MenuIcon = "icon16/user_edit.png",

	Filter = function(self, entity, client)
		if (!IsValid(entity)) then return false end


		return CAMI.PlayerHasAccess(client, "Helix - Manage Vendors", nil)
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		local entity = net.ReadEntity()
		entity:DropToFloor()
	end
})