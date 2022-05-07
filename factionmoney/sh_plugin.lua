PLUGIN.name = "Faction acc"
PLUGIN.author = "Lechu2375"
ix.util.Include("sv_plugin.lua")
	ix.util.Include("cl_derma.lua")
 	ix.command.Add("SetFactionMoney", {
 		description = "Set money for faction",
 		adminOnly = true,
 		arguments = {
 			ix.type.string,
 			ix.type.number
 		},
 		OnRun = function(self, client, uniqueID, number)
		 	local FactionAccountTable
            if(FactionAccountConnectTable[uniqueID]) then
        		FactionAccountTable =  FactionAccount[FactionAccountConnectTable[uniqueID]]
    		else
        		FactionAccountTable =  FactionAccount[uniqueID]
    		end
            if(FactionAccountTable) then
                FactionAccountTable.money = math.abs(number)
                return client:Notify(string.format("Faction  %s now has %s money",FactionAccountTable.name,number))
            end
		end
})
 	ix.command.Add("FactionMoneyManagement", {
 		description = "Set money for faction",
 		adminOnly = true,
 		arguments = ix.type.string,
 		OnRun = function(self, client, factionUID)
		 	local FactionAccountTable
            if(FactionAccountConnectTable[factionUID]) then
        		FactionAccountTable =  FactionAccount[FactionAccountConnectTable[factionUID]]
    		else
        		FactionAccountTable =  FactionAccount[factionUID]
    		end
			for k,v in pairs(FactionAccount)do
				if(v.name==FactionAccountTable.name) then
					factionUID = k
					break 
				end
			end
			if(FactionAccountTable) then
				local toSend = {}
				toSend.money = FactionAccountTable.money
				toSend.nextSalaryBonus = FactionAccountTable.nextSalaryBonus
				net.Start("FactionMoneyWindowOpen")
					net.WriteTable(toSend)
					net.WriteString(factionUID)
				net.Send(client)
			end
		end
})