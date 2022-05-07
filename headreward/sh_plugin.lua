PLUGIN.name = "Head Rewards"
PLUGIN.author = "Lechu2375"
ActiveRewards = ActiveRewards or {}
function SetupHeadReward(factionkillers,factionvictims,reward,statement)
    ActiveRewards[factionkillers] = {
        ["victims"] = factionvictims,
        ["reward"] = reward,
        ["statement"] = statement
    }
end
/*
SetupHeadReward(FACTION_CITIZEN3,FACTION_CITIZEN,9000,function(attacker,victim)
    print(attacker:Team(),victim:Team())
    return victim:Team()==FACTION_CITIZEN
end)*/
function PLUGIN:PlayerDeath(victim,inflictor,attacker )
    if(!attacker:IsPlayer()) then return end
    factionkillers = attacker:Team()
    local rewardTable = ActiveRewards[factionkillers]
    if(rewardTable) then
        local bSucc = rewardTable.statement(attacker,victim)
        if(bSucc) then
            AddFactionSalaryBonus(ix.faction.indices[factionkillers].uniqueID,rewardTable.reward)
        end
        local dialogtable = rewardTable.talker:GetNetVar( "dialogue",false)
        dialogtable.npc["assasination"]= "No."
        rewardTable.talker:SetNetVar("dialogue",dialogtable)
        ActiveRewards[factionkillers] = nil
    end
end


ix.command.Add("headreward", {
	description = "SetHeadReward",
	adminOnly = true,
	arguments = {ix.type.string,ix.type.string,ix.type.number},
	OnRun = function(self, client,attackerfaction,victimfaction,reward)
		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
        local attackers = ix.faction.Get(attackerfaction)
        local victims = ix.faction.Get(victimfaction)
        if(!attackers or !victims) then
            return "Something went wrong  with finding factions."
        end
		-- Validate it is a door.
		if (IsValid(entity) and entity:GetClass()=="ix_talker") then
            local dialogtable = entity:GetNetVar( "dialogue",false)
            dialogtable.npc["assasination"]= "Yeah, there is reward for head one of "..victims.name.." member"
            dialogtable.player["assasination"]= "Do you have any good information for me?"
            entity:SetNetVar("dialogue",dialogtable)
            
            SetupHeadReward(ix.faction.GetIndex(attackerfaction),ix.faction.GetIndex(victimfaction),reward,
            function(attacker,victim)
                return victim:Team()==ix.faction.GetIndex(victimfaction)
            end)
            ActiveRewards[ix.faction.GetIndex(attackerfaction)].talker = entity
			-- Tell the player they have made the door (un)disabled.
			return "Good."
		else
			-- Tell the player the door isn't valid.
			return "@dNotValid"
		end
	end
})

