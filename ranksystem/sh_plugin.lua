PLUGIN.name = "System rang"
PLUGIN.desc = "Umożliwia korzystanie z rang frakcyjnych"
PLUGIN.author= "Lechu2375"
ix.util.Include("core/sv_charmeta.lua")
ix.util.Include("core/sh_core.lua")
ix.util.Include("core/cl_drawinfo.lua")
ix.util.Include("core/sv_orderssql.lua")
ix.util.Include("core/cl_orders.lua")
ix.util.Include("sh_chatfix.lua")
factionRanks = {}
factionRanks.scoreboardRanks = {
	[FACTION_USMC] = true
}
ix.char.RegisterVar("rank", { //SetRank(int) Nie używać, funkcja pomocznicza setRank(int lub string), GetRank() returnuje int
	field = "rank",
	fieldType = ix.type.number,
	default = 1
})
if SERVER then
	ix.log.AddType("rankPromote", function(client,target)
		return string.format("%s awansował %s na rangę %s", client:Name(),target:GetName(),target:getLongRank())
	end, FLAG_WARNING)
end

ix.flag.Add("o", "Access to orders.")

ix.command.Add("Promote", {
	description = "Promote someone.",
	arguments = {
		ix.type.character,
		ix.type.string
	},
	OnRun = function(self, client, target,rank)
		if not canPromote(client:GetChar(),target,rank) then
			return client:Notify("Coś poszło nie tak.")
		end
        local result = target:setRank(rank)
		if result then
			client:Notify("Pomyślnie awansowano gracza.")
			ix.log.Add(client, "rankPromote",target)
		else
			client:Notify("Awansowanie nie powiodło się.")
		end
	end
})

ix.command.Add("PlyTransfer", {
	description = "@cmdPlyTransfer",
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.text
	},
	OnRun = function(self, client, target, name)
		local faction = ix.faction.teams[name]

		if (!faction) then
			for _, v in pairs(ix.faction.indices) do
				if (ix.util.StringMatches(L(v.name, client), name)) then
					faction = v

					break
				end
			end
		end

		if (faction) then
			target.vars.faction = faction.uniqueID
			target:SetFaction(faction.index)
			target:clearOrders()
			target:SetRank(1)
			if (faction.OnTransferred) then
				faction:OnTransferred(target)
			end

			for _, v in ipairs(player.GetAll()) do
				v:NotifyLocalized("cChangeFaction", client:GetName(), target:GetName(), L(faction.name, v))
			end
			
		else
			return "@invalidFaction"
		end
	end
})

--==============================================================
ix.command.Add("GiveMedal", {
	description = "Give medal to someone",
	arguments = {
		ix.type.character,
		ix.type.number
	},
	OnRun = function(self, client,target, order)
		if not client:GetCharacter():HasFlags("o") then
			return client:Notify("You dont have access to orders")
		end
		local team = ix.faction.Get(target:GetFaction())
		if team.orders and team.orders[order] then
			if target:giveOrder(order) then
				client:Notify("Orders give succes")
			else
				client:Notify("He has already that order")
			end
		else
			client:Notify("Wrong Order")
		end
	end
})





ix.command.Add("TakeOrder", {
	description = "Take Order from someone",
	arguments = {
		ix.type.character,
		ix.type.number
	},
	OnRun = function(self, client,target,medal)
		target:removeOrder(medal)

	end
})






