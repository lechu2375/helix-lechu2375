do
ix.chat.Register("try", {
 	format = "((Próba))%s %s",
 	GetColor = function() return Color(140, 122, 230)end,
 	CanHear = ix.config.Get("chatRange", 280) * 2,
 	prefix = {},
	description = "@cmdMe",
 	indicator = "Trying...",
	deadCanChat = true
})

ix.command.Add("try", {
	description = "Try do something",
	arguments = ix.type.text,
	OnRun = function(self, client, text)
        local str
        if not string.EndsWith(text,".") then
            text = text.."."
        end
        local git = tobool(math.random(0, 1))
        if git then 
            str= " odniósł sukces próbując "..text
        else
            str = " zawiódł próbując "..text
        end
		ix.chat.Send(client, "try", str)
        

	end
})


ix.chat.Register("apply", {
	OnChatAdd = function(self, speaker, text)
		chat.AddText(Color(140, 122, 230), "((Identification))"..text)
	end,	
 	CanHear = ix.config.Get("chatRange", 280),
	indicator = "Identifies himself...",
	deadCanChat = false
})

ix.command.Add("apply", {
	description = "Identify",
	OnRun = function(self, client, text)
		local inv = client:GetCharacter():GetInventory()
		local cid = inv:GetItemsByUniqueID("cid")
		
		local str
		if cid[1] then
			str=" CID:"..cid[1]:GetData("id", "00000").." Personalia:"..cid[1]:GetData("name", "Nieprzypisany")
		else
			str="Brak CID"
		end
		ix.chat.Send(client, "apply", str)
	end
})

ix.command.Add("doorkick", {
	description = "Wypierdol drzwi",
	OnRun = function(self, client)
		if client:Team()==FACTION_MPF or client:Team()==FACTION_OTA  then
			local trace = client:GetEyeTraceNoCursor()
			if trace.Entity:GetClass() =="prop_door_rotating" then
				client:ForceSequence("kickdoorbaton")
				timer.Simple(1, function()
					trace.Entity:EmitSound("physics/wood/wood_panel_impact_hard1.wav",90)
					trace.Entity:Fire("Unlock")
					trace.Entity:Fire("Open")
				end)
			else
				client:Notify("Nie ma czego wyważyć.")
			end
		end
	end
})

end
