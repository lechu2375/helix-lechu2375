  
ITEM.name = "아드레날린 주사"
ITEM.model = "models/kek1ch/stim3.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.healamount = 30
ITEM.description = "의식불명에 빠진 사람을 소생시킬 수 있는 약물입니다."
ITEM.category = "의료품"

ITEM.functions.useForward = { 
	name = "소생시키기",
	tip = "중상을 입어 의식을 잃은 사람을 사람을 소생시킵니다",
	icon = "icon16/user_add.png",
    sound = "interface/inv_stim_3p2.ogg",	
	OnRun = function(item)
        local ply = item.player
        local trace = ply:GetEyeTraceNoCursor()
		local target = trace.Entity
        local str = string.format("%s 를 소생시키고 있습니다...", target:GetNetVar("player"):Name() )
        ply:SetAction(str, 8)
        ply:DoStaredAction(target, function()
            local ply = target:GetNetVar("player") 
            net.Start("DrawDeathText")
            net.WriteBool(false)
            net.Send(ply)
            ply:SetHealth(10)
            ply:SetRagdolled(false,0)
            local uid = "dietime"..ply:GetCharacter():GetID() 
            timer.Remove(uid)
        end,8)

	end,
    OnCanRun =  function(item)
        local ply = item.player
		local trace = ply:GetEyeTraceNoCursor()
		local target = trace.Entity
        return target:GetClass()=="prop_ragdoll"
    end
}