util.AddNetworkString("ReviveAction")
local maleSounds = {
    "vo/npc/male01/help01.wav","vo/Streetwar/sniper/male01/c17_09_help01.wav","vo/Streetwar/sniper/male01/c17_09_help02.wav"
}
local femaleSounds = {
    "vo/npc/female01/help01.wav","vo/canals/arrest_helpme.wav"
}
net.Receive("ReviveAction", function(len,ply)
    local character = ply:GetCharacter()
    if(!character) then return end
     local action = net.ReadUInt(1)
    print(action)
    if(IsValid(ply.ixRagdoll) and (ply.nextReviveAction or CurTime())<=CurTime() ) then
        ply.nextReviveAction = CurTime()+4

        if(action==0 and ply:Alive()) then
            local uid = "dietime"..character:GetID() 
            timer.Remove(uid)
            ply:Kill()
            
        else
            if(ply:IsFemale()) then
                ply:EmitSound(femaleSounds[ math.random( #femaleSounds ) ],90)
            else
                ply:EmitSound(maleSounds[ math.random( #maleSounds ) ],90)
            end
        end
    end
end)

