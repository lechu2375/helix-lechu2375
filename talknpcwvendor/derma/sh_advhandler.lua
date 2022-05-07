local PLUGIN = PLUGIN
ix.plugin = ix.plugin or {}
ix.plugin.list = ix.plugin.list or {}
local questPLUGIN = ix.plugin.list.quests--ix.plugins.list( "quests" )
if not questPLUGIN then
	print( 'quest_honeya example will not work properly without "quest" plugin.' )
end

/*---------------------------------------------------------
	This is advanced handler for dialogue plugin.
	You can make some quest like things with this.
	But I recommends you don't care about this handler
	If you don't know how to code. 
	
	I will not answer any question about how to use this plugin.
	Unless you have any clue about this dialogue handler.
--------------------------------------------------------*/

-- You can call SpecialCall with !.
-- example. when a player call dialouge that has uid "!quest_recieve_test" then it will call SpecialCall["quest_receive_test"].
PLUGIN.SpecialCall =
{

		["honeya"] = { -- QUEST EXAMPLE.
			sv = function( client, data ) 
				if client:HasQuest( "honeya" ) then
					-- questPLUGIN = from the "quests" plugin.
					local pqst_dat = client:GetQuest( "honeya" ) -- get player quest data
					if client:CanCompleteQuest( "honeya", pqst_dat ) then -- If see player can complete quest
						client:GiveQuestReward( "honeya", pqst_dat ) -- Give quest reward

						client:RemoveQuest( "honeya" ) -- and remove player quest.
						data.done = true -- send client data.done. It will generate you're done text.
					else
						data.done = false
					end
				else
					-- set quest and get quest.
					data.gotquest = true -- Just got a quest!
					local d_qst = questPLUGIN:GetQuest( "honeya" )
					client:AddQuest( "honeya", d_qst:GenerateData( client ) )

					 -- Give a quest that has uniqueid 'honeya' and generates random data for quest.
					-- Quest data generating function is in sh_quests.lua file.
				end
				return data -- MUST RETURN DATA
			end,
			cl = function( client, panel, data )
				if data.gotquest then
					timer.Simple(1, function()
					local d_qst = questPLUGIN:GetQuest( "honeya" )
					local pqst_dat = LocalPlayer():GetQuest( "honeya" ) 
					//print("honeyacl")
					//PrintTable(data)
					if(pqst_dat)then-- get player quest data
						panel:AddChat( data.name, "Can you get some items for me?" )
						for k, v in pairs( pqst_dat ) do
							panel:AddCustomText( Format( d_qst.desc, unpack( { v, ix.item.list[k].name } ) ), "ixChatFont" )

						end
					end
						panel.talking = false -- Get quest and end the converstaion.
					
					end)
					return
				end
				if data.done then
					panel:AddChat( data.name, "Okay I'll give you some moeney!")
				else
					panel:AddChat( data.name, "You don't have enough items to return your quest.")
				end
				panel.talking = false
			end,
		},
		["quest_art"] = {
			sv = function( client, data ) 
				if client:HasQuest( "art" ) then
					-- questPLUGIN = from the "quests" plugin.
					local pqst_dat = client:GetQuest( "art" ) -- get player quest data
					if client:CanCompleteQuest( "art", pqst_dat ) then -- If see player can complete quest
						client:GiveQuestReward( "art", pqst_dat ) -- Give quest reward
						client:RemoveQuest( "art" ) -- and remove player quest.
						data.done = true -- send client data.done. It will generate you're done text.
					else
						data.done = false
					end
				else
					-- set quest and get quest.
					data.gotquest = true -- Just got a quest!
					local d_qst = questPLUGIN:GetQuest( "art" )
					client:AddQuest( "art", d_qst:GenerateData( client ) ) -- Give a quest that has uniqueid 'honeya' and generates random data for quest.
					-- Quest data generating function is in sh_quests.lua file.
				end
				return data -- MUST RETURN DATA
			end,
			cl = function( client, panel, data )
				if data.gotquest then
					local d_qst = questPLUGIN:GetQuest( "art" )
					local pqst_dat = LocalPlayer():GetQuest( "art" ) 
					panel:AddChat( data.name, "Есть один заказ:" )
					for k, v in pairs( pqst_dat ) do
						panel:AddCustomText( Format( d_qst.desc, unpack( { v, ix.item.list[k].name } ) ), "ixChatFont" )
					end
					panel.talking = false -- Get quest and end the converstaion.
					return
				end
				if data.done then
					panel:AddChat( data.name, "Ну, спасибо! Выручил! Держи оплату.")
				else
					panel:AddChat( data.name, "Как-то я не заметил, что у тебя есть нужный артефакт. Я же говорил:")
					local d_qst = questPLUGIN:GetQuest( "art" )
					local pqst_dat = LocalPlayer():GetQuest( "art" )
					for k, v in pairs( pqst_dat ) do
						panel:AddCustomText( Format( d_qst.desc, unpack( { v, ix.item.list[k].name } ) ), "ixChatFont" )
					end
				end
				panel.talking = false
			end,
		},
 		["molotov1"] = {
			sv = function( client, data ) 
				if client:HasQuest( "molotov1" ) then
					-- questPLUGIN = from the "quests" plugin.
					local pqst_dat = client:GetQuest( "molotov1" ) -- get player quest data
					if client:CanCompleteQuest( "molotov1", pqst_dat ) then -- If see player can complete quest
						client:GiveQuestReward( "molotov1", pqst_dat ) -- Give quest reward
						client:RemoveQuest( "molotov1" ) -- and remove player quest.
						data.done = true -- send client data.done. It will generate you're done text.
					else
						data.done = false
					end
				else
					-- set quest and get quest.
					data.gotquest = true -- Just got a quest!
					local d_qst = questPLUGIN:GetQuest( "molotov1" )
					client:AddQuest( "molotov1", d_qst:GenerateData( client ) ) -- Give a quest that has uniqueid 'honeya' and generates random data for quest.
					-- Quest data generating function is in sh_quests.lua file.
				end

				return data -- MUST RETURN DATA
			end,
			cl = function( client, panel, data )

				if data.gotquest then
					local d_qst = questPLUGIN:GetQuest( "molotov1" )
					local pqst_dat = LocalPlayer():GetQuest( "molotov1" ) 

					if(ppst_dat)then
						panel:AddChat( data.name, "연구에 필요한 표본들을 구해다주게 :" )
						for k, v in pairs( pqst_dat ) do
							panel:AddCustomText( Format( d_qst.desc, unpack( { v, ix.item.list[k].name } ) ), "ixChatFont" )
						end
					end
					panel.talking = false -- Get quest and end the converstaion.
					return
				end
				

				if data.done then
					panel:AddChat( data.name, "고맙네 젊은이, 보수를 받아가게.")
				else
					panel:AddChat( data.name, "표본이 부족하네 :")
					local d_qst = questPLUGIN.curQuests[self:GetCharacter():GetID()]

					if(d_qst)then
						for k, v in pairs( pqst_dat ) do
							local itemname
							if(!ix.item.list[k])then
								itemname = "Unregistered item"..k
							else
								itemname = ix.item.list[k].name
							end
							panel:AddCustomText( Format( d_qst.desc, unpack( { v, itemname } ) ), "ixChatFont" )
						end
					end
				end
				panel.talking = false
			end,
		},

		["test2"] = {
			sv = function( client, data )
				return data -- MUST RETURN DATA
			end,
			cl = function( client, panel, data ) 
				panel.talking = false -- Ends the current conversation and allows player to talk about other topics.
			end,
		},

		["test"] = {
			sv = function( client, data )
				client:EmitSound( "items/smallmedkit1.wav" )
				client:SetHealth( 100 )
				return data -- MUST RETURN DATA
			end,
			cl = function( client, panel, data ) 
				panel:AddChat( data.name, "By the name of Black Tea! You're healed!" )
				panel.talking = false -- Ends the current conversation and allows player to talk about other topics.
			end,
		},
		["vendoropen"] = {
			sv = function( client, data )
				local talker = client.LastTalker
				local inventory = talker:GetInventory()
				local activator = client
				local character = activator:GetCharacter()

				if (!talker:CanAccess(activator) or hook.Run("CanPlayerUseVendor", activator) == false) then
					if (talker.messages[VENDOR_NOTRADE]) then
						activator:ChatPrint(talker:GetDisplayName()..": "..talker.messages[VENDOR_NOTRADE])
					else
						activator:NotifyLocalized("vendorNoTrade")
					end

					return
				end

				talker.receivers[#talker.receivers + 1] = activator

				if (talker.messages[VENDOR_WELCOME]) then
					activator:ChatPrint(talker:GetDisplayName()..": "..talker.messages[VENDOR_WELCOME])
				end

				local items = {}

				-- Only send what is needed.
				for k, v in pairs(talker.items) do
					if (!table.IsEmpty(v) and (CAMI.PlayerHasAccess(activator, "Helix - Manage Vendors", nil) or v[VENDOR_MODE])) then
						items[k] = v
					end
				end

				talker.scale = talker.scale or 0.5

				activator.ixVendor = talker

				-- force sync to prevent outdated inventories while buying/selling
				if (character) then
					character:GetInventory():Sync(activator, true)
				end

				net.Start("ixVendorOpen")
					net.WriteEntity(talker)
					net.WriteUInt(talker.money or 0, 16)
					net.WriteTable(items)
					net.WriteFloat(talker.scale or 0.5)
				net.Send(activator)

				ix.log.Add(activator, "vendorUse", talker:GetDisplayName())
				return data 
			end,
			cl = function( client, panel, data ) 
				panel.talking = false
			end,
		},
}

-- Handler.
if SERVER then
	netstream.Hook( "ix_DialogueMessage", function( client, data)
		if string.Left( data.request, 1 ) == "!" then
			data.request = string.sub( data.request, 2 )
			if PLUGIN.SpecialCall[ data.request ] then
				data = PLUGIN.SpecialCall[ data.request ].sv( client, data )
				netstream.Start( client, "ix_DialoguePingpong", data )
			else
				print( Format( "%s( %s ) tried to call invalid dialouge request( %s ) from %s.", client:Name(), client:Nick(), data.request, data.name ) )
				print( "Please check PLUGIN.SpecialCall or NPC's dialouge unique id." )
				client:EmitSound( "HL1/fvox/hev_general_fail.wav" )
			end
		end
	end)
else
	netstream.Hook( "ix_DialoguePingpong", function( data )
		if IsValid( ix.gui.dialogue ) then
			if PLUGIN.SpecialCall[ data.request ] then
				timer.Simple(0.5, function()
				PLUGIN.SpecialCall[ data.request ].cl( client, ix.gui.dialogue, data )
				end)
			end
		end
	end)
end