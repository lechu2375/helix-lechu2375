/*

      _          _                        _              _      _                                              _        
     | |   ___  | |__     __ _    ___    | | __   __ _  | | __ | |_   _   _   ___    ___   __      __  _ __   (_)   ___ 
  _  | |  / _ \ | '_ \   / _` |  / __|   | |/ /  / _` | | |/ / | __| | | | | / __|  / _ \  \ \ /\ / / | '_ \  | |  / _ \
 | |_| | |  __/ | |_) | | (_| | | (__    |   <  | (_| | |   <  | |_  | |_| | \__ \ | (_) |  \ V  V /  | | | | | | |  __/
  \___/   \___| |_.__/   \__,_|  \___|   |_|\_\  \__,_| |_|\_\  \__|  \__,_| |___/  \___/    \_/\_/   |_| |_| |_|  \___|
                                                                                                                        
*/
PLUGIN.name = "Refilled"
PLUGIN.author = "Lechu2375"
PLUGIN.desc = "Allows players to refill stock of the vendor, vending machines and even ration distributors."
ix.util.Include("core/sv_core.lua")
ix.util.Include("core/cl_derma.lua")


ix.command.Add("refill", {
	description = "refill box",
	AdminOnly = true,
	OnRun = function(self, client, text)
		local ent = client:GetEyeTraceNoCursor().entity
		if IsValid(ent) and ent:GetClass()=="ix_item" then
			PrintTable(ent:GetItemTable())
		end
	end
})

