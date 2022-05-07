ENT.Type = "anim"
ENT.PrintName = "Talker"
ENT.Category = "IX"
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ID")
	self:NetworkVar("Bool", 0, "NoBubble")
	self:NetworkVar("String", 0, "DisplayName")
	self:NetworkVar("String", 1, "Description")
end

	function ENT:Initialize()
		if (SERVER) then
			self:SetModel("models/mossman.mdl")
			self:SetUseType(SIMPLE_USE)
			self:SetMoveType(MOVETYPE_NONE)
			self:DrawShadow(true)
			self:SetSolid(SOLID_BBOX)
			self:PhysicsInit(SOLID_BBOX)

			self.items = {}
			self.messages = {}
			self.factions = {}
			self.classes = {}
			
			self:SetNetVar("name", "John Doe")
			self:SetNetVar("desc", "")

			self.receivers = {}

			local physObj = self:GetPhysicsObject()

			if (IsValid(physObj)) then
				physObj:EnableMotion(false)
				physObj:Sleep()
			end
		end

		timer.Simple(1, function()
			if (IsValid(self)) then
				self:setAnim()
			end
		end)
	end

	local PLUGIN = PLUGIN
	function ENT:GetInventory()
		return ix.item.inventories[self:GetID()]
	end

function ENT:GetMoney()
	return self.money
end



function ENT:GetStock(uniqueID)
	if (self.items[uniqueID] and self.items[uniqueID][VENDOR_MAXSTOCK]) then
		return self.items[uniqueID][VENDOR_STOCK] or 0, self.items[uniqueID][VENDOR_MAXSTOCK]
	end
end

function ENT:GetPrice(uniqueID, selling)
	local price = ix.item.list[uniqueID] and self.items[uniqueID] and
		self.items[uniqueID][VENDOR_PRICE] or ix.item.list[uniqueID].price or 0

	if (selling) then
		price = math.floor(price * (self.scale or 0.5))
	end

	return price
end

function ENT:HasMoney(amount)
	-- Vendor not using money system so they can always afford it.
	if (!self.money) then
		return true
	end

	return self.money >= amount
end

	

	function ENT:canAccess(client)
		if (client:IsAdmin()) then
			return true
		end

		local allowed = false
		local uniqueID = ix.faction.indices[client:Team()].uniqueID

		if (self.factions and table.Count(self.factions) > 0) then
			if (self.factions[uniqueID]) then
				allowed = true
			else
				return false
			end
		end

		if (allowed and self.classes and table.Count(self.classes) > 0) then
			local class = ix.class.list[client:getChar():getClass()]
			local uniqueID = class and class.uniqueID

			if (!self.classes[uniqueID]) then
				return false
			end
		end

		return true
	end

	function ENT:setAnim()
		for k, v in ipairs(self:GetSequenceList()) do
			if (v:lower():find("idle") and v != "idlenoise") then
				return self:ResetSequence(k)
			end
		end

		self:ResetSequence(4)
	end

	if (CLIENT) then
		function ENT:CreateBubble()
			self.bubble = ClientsideModel("models/extras/info_speech.mdl", RENDERGROUP_OPAQUE)
			self.bubble:SetPos(self:GetPos() + Vector(0, 0, 84))
			self.bubble:SetModelScale(0.6, 0)
		end

		function ENT:Think()
			local noBubble = self:GetNoBubble()

			if (IsValid(self.bubble) and noBubble) then
				self.bubble:Remove()
			elseif (!IsValid(self.bubble) and !noBubble) then
				self:CreateBubble()
			end

			if ((self.nextAnimCheck or 0) < CurTime()) then
				self:setAnim()
				self.nextAnimCheck = CurTime() + 60
			end

			self:SetNextClientThink(CurTime() + 0.25)

			return true
		end

		function ENT:Draw()
			local bubble = self.bubble

			if (IsValid(bubble)) then
				local realTime = RealTime()

				bubble:SetAngles(Angle(0, realTime * 120, 0))
				bubble:SetRenderOrigin(self:GetPos() + Vector(0, 0, 84 + math.sin(realTime * 3) * 0.03))
			end

			self:DrawModel()
		end

		function ENT:OnRemove()
			if (IsValid(self.bubble)) then
				self.bubble:Remove()
			end
		end
		
		netstream.Hook("ix_Dialogue", function(data)
			if (IsValid(ix.gui.dialogue)) then
				ix.gui.dialogue:Remove()
				return
			end
			ix.gui.dialogue = vgui.Create("ix_Dialogue")
			ix.gui.dialogue:Center()
			ix.gui.dialogue:SetEntity(data)
	if LocalPlayer():IsAdmin() then
			if (IsValid(ix.gui.edialogue)) then
				ix.gui.dialogue:Remove()
				return
			end
			ix.gui.edialogue = vgui.Create("ix_DialogueEditor")
			--ix.gui.edialogue:Center()
			ix.gui.edialogue:SetEntity(data)
	end
		end)
		local TEXT_OFFSET = Vector(0, 0, 20)
		local toScreen = FindMetaTable("Vector").ToScreen
		local colorAlpha = ColorAlpha
		local drawText = ix.util.drawText
		local configGet = ix.config.get

		ENT.PopulateEntityInfo = true

		function ENT:OnPopulateEntityInfo(container)
			local name = container:AddRow("name")
			name:SetImportant()
			name:SetText(self:GetNetVar("name","John Doe"))
			name:SizeToContents()

			local descriptionText = self:GetNetVar("desc", "")


			if (descriptionText != "") then
				local description = container:AddRow("description")
				description:SetText(self:GetNetVar("desc", ""))
				description:SizeToContents()
			end
		end
	else
		function ENT:Use(activator)
			activator.LastTalker = self 
			local factionData = self:GetNetVar("factiondata", {})
			if !factionData[ix.faction.indices[activator:Team()].uniqueID] and !activator:IsSuperAdmin() then
				activator:ChatPrint( self:GetNetVar( "name", "John Doe" )..": I don't want talk with you." )
				return
			end
			netstream.Start(activator, "ix_Dialogue", self)
		end
		netstream.Hook("ix_DialogueData", function( client, data )
			if (!client:IsSuperAdmin()) then
				return
			end
			local entity = data[1]
			local dialogue = data[2]
			local factionData = data[3]
			local classData = data[4]
			local name = data[5]
			local desc = data[6]
			local model = data[7]

			
			if (IsValid(entity)) then
				entity:SetNetVar("dialogue", dialogue)
				entity:SetNetVar("factiondata", factionData)
				entity:SetNetVar("classdata", classData)
				entity:SetNetVar("name", name)
				entity:SetNetVar("desc", desc)
				entity:SetModel(model)
				entity:setAnim()

				client:Notify("You have updated this talking npc's data.")
			end
		end)
		function ENT:SetMoney(value)
			self.money = value

			net.Start("ixVendorRemakeMoney")
				net.WriteUInt(value and value or -1, 16)
			net.Send(self.receivers)
		end

		function ENT:GiveMoney(value)
			if (self.money) then
				self:SetMoney(self:GetMoney() + value)
			end
		end

		function ENT:TakeMoney(value)
			if (self.money) then
				self:GiveMoney(-value)
			end
		end

		function ENT:SetStock(uniqueID, value)
			if (!self.items[uniqueID][VENDOR.MAXSTOCK]) then
				return
			end

			self.items[uniqueID] = self.items[uniqueID] or {}
			self.items[uniqueID][VENDOR.STOCK] = math.min(value, self.items[uniqueID][VENDOR.MAXSTOCK])

			net.Start("ixVendorRemakeStock")
				net.WriteString(uniqueID)
				net.WriteUInt(value, 16)
			net.Send(self.receivers)
		end

		function ENT:AddStock(uniqueID, value)
			if (!self.items[uniqueID][VENDOR.MAXSTOCK]) then
				return
			end

			self:SetStock(uniqueID, self:GetStock(uniqueID) + (value or 1))
		end

		function ENT:TakeStock(uniqueID, value)
			if (!self.items[uniqueID][VENDOR.MAXSTOCK]) then
				return
			end

			self:AddStock(uniqueID, -(value or 1))
		end
		function ENT:SpawnFunction(client, trace)
			local angles = (trace.HitPos - client:GetPos()):Angle()
			angles.r = 0
			angles.p = 0
			angles.y = angles.y + 180

			local entity = ents.Create("ix_talker")
			entity:SetPos(trace.HitPos)
			entity:SetAngles(angles)
			entity:Spawn()
			entity:BuildInventory()
			
			PLUGIN:SaveData()

			return entity
		end
		function ENT:BuildInventory(callback, w, h)
			local invID = os.time() + self:EntIndex()
			
			if self:GetID() ~= 0 then
				invID = self:GetID()
			end
			
			local inventory = ix.item.CreateInv(w or 1, h or 1, invID)
			
			inventory.vars.isNewVendor = true
			inventory.noSave = true
			
			if (callback) then
				callback(inventory)
			end

			self:SetInventory(inventory)
		end
		
		function ENT:SetInventory(inventory)
			if (inventory) then
				self:SetID(inventory:GetID())
				inventory.OnAuthorizeTransfer = function(inventory, client, oldInventory, item)
					if (IsValid(client) and IsValid(self) and inventory.vars and inventory.vars.isNewVendor) then
						return false
					end
				end
			end
		end
		
		function ENT:OnRemoveInventory()
			local index = self:GetID()
			
			if (!ix.shuttingDown and !self.ixIsSafe and ix.entityDataLoaded and index) then
				local inventory = ix.item.inventories[index]

				if (inventory) then
					ix.item.inventories[index] = nil
					self.items = {}

					hook.Run("VendorRemakeRemoved", self, inventory)
				end
			end
		end

		function ENT:OnRemove()
			self:OnRemoveInventory()
		end
	end

function ENT:CanAccess(client)
	local bAccess = false
	local uniqueID = ix.faction.indices[client:Team()].uniqueID

	if (self.factions and !table.IsEmpty(self.factions)) then
		if (self.factions[uniqueID]) then
			bAccess = true
		else
			return false
		end
	end

	if (bAccess and self.classes and !table.IsEmpty(self.classes)) then
		local class = ix.class.list[client:GetCharacter():GetClass()]
		local classID = class and class.uniqueID

		if (classID and !self.classes[classID]) then
			return false
		end
	end

	return true
end