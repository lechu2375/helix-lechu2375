PLUGIN.name = "Global timer"
PLUGIN.author = "Lechu2375"
ix.util.Include("sv_core.lua")
ix.util.Include("cl_core.lua")

ix.command.Add("SetGlobalTimer", {
	description = "Set someone Karma amount",
	adminOnly = true,
	arguments = {
		ix.type.string,
		ix.type.number
	},
	OnRun = function(self, client, name, TimeToEnd)
        TimerSend(name,TimeToEnd)
	end
})