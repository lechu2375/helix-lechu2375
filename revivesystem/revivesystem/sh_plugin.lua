PLUGIN.name = "Revive System"
PLUGIN.author = "Lechu2375"
ix.util.Include("sv_damagehandle.lua")
ix.util.Include("sv_soundemit.lua")
ix.util.Include("cl_screen.lua")
ix.config.Add("TimeToRevive",30, "Time in seconds to revive until death.", nil, {
	category = "Revive System",
    data = {min = 1, max = 1000}
})
ix.command.Add("CharGetUp", {
	description = "@cmdCharGetUp",
	OnRun = function(self, client, arguments)
		local entity = client.ixRagdoll
		print(entity.CanGetUp)
		if (IsValid(entity) and entity.ixGrace and entity.ixGrace < CurTime() and
			entity:GetVelocity():Length2D() < 8 and !entity.ixWakingUp and (entity.CanGetUp==true or entity.CanGetUp==nil)) then
			entity.ixWakingUp = true
			entity:CallOnRemove("CharGetUp", function()
				client:SetAction()
			end)

			client:SetAction("@gettingUp", 5, function()
				if (!IsValid(entity)) then
					return
				end

				hook.Run("OnCharacterGetup", client, entity)
				entity:Remove()
			end)
		end
	end
})