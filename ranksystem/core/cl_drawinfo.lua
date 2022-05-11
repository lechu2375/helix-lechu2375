local char = ix.meta.character

function char:getRankIcon()
    local rankTable = ix.faction.Get(self:GetFaction()).ranks
    if rankTable then
        if rankTable[self:GetRank()].img then
            return rankTable[self:GetRank()].img
        else
            return false
        end
    end
end

function PLUGIN:PopulateCharacterInfo(client, character, tooltip)
	local rank = character:getLongRank()
	if rank then
		local panel = tooltip:AddRowAfter("rank", "name")
		panel:SetBackgroundColor(ix.faction.Get(character:GetFaction()).color) 
		panel:SetFontInternal("ixMediumFont")
		panel:SetText(rank)
		if character:getRankIcon() then
			local icon = panel:Add("DImage")
			icon:SetImage(character:getRankIcon())
			icon:SetSize( 32, 16 )
			icon:Dock(RIGHT)
		end
		panel:SizeToContents()
    end

	local id = tonumber(character:GetPlayer():UserID())
	net.Start("requestOrders")
		net.WriteInt(id,10)
	net.SendToServer()
	//print("[DEBUG] Wysłano zapytanie o ordery.")

	local ordersT = orderCache[character:GetID()]
	local factionOrders = ix.faction.Get(character:GetFaction())["orders"]
	if ordersT then
		local panel = tooltip:AddRow("orders")
		panel:SetText("Orders:")
		panel:SetImportant()
		panel:SizeToContents()
		for k,_ in pairs(ordersT) do
			local order = factionOrders[k]
			local panel = tooltip:AddRow("order"..k)
			panel:SetText(order["name"])
			panel:SetFontInternal("ixMonoMediumFont")
			local icon = panel:Add("DImage")
				icon:SetImage(order["img"])
				icon:SetSize( 124, 93 )
			icon:Dock(RIGHT)
			panel:SizeToContents()
			panel:SetSize(124, 93)
			

			local descpanel = tooltip:AddRow("order"..k.."desc")
			descpanel:SetText(order["desc"])
			descpanel:SetFontInternal("ixMonoSmallFont")
			descpanel:SizeToContents()
		end
		

	end
end



