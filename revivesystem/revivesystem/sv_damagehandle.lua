util.AddNetworkString("DrawDeathText")
function PLUGIN:EntityTakeDamage(ent,dmg)
    if(!(ent:IsPlayer())) then return end
    if(ent:GetMoveType()==MOVETYPE_NOCLIP) then return end
    local character = ent:GetCharacter()
    local dmgAmount = dmg:GetDamage()
    if((ent:Health()-dmgAmount)<0) then
       if(IsValid(ent.ixRagdoll)) then
            ent:Kill()
            ent.CanGetUp = true
            local uid = "dietime"..character:GetID() 
            timer.Remove(uid)
            return
       end


        dmg:SetDamage(0)
        ent:SetHealth(30)
        local time = ix.config.Get("TimeToRevive", 30)
        ent:SetRagdolled(true)
        net.Start("DrawDeathText")
        net.WriteBool(true)
        net.Send(ent)
        ent.CanGetUp = false
        local uid = "dietime"..character:GetID()
        timer.Create(uid,time-1,1, function()
            if(IsValid(ent)) then
                ent:Kill()
            end
        end)
    end
end
function PLUGIN:OnCharacterGetup(client)
    local character = client:GetCharacter()
    local uid = "dietime"..character:GetID() 
    timer.Remove(uid)
    net.Start("DrawDeathText")
    net.WriteBool(false)
    net.Send(client)
    client.CanGetUp = true
end
function PLUGIN:PostPlayerDeath(ply)
    net.Start("DrawDeathText")
    net.WriteBool(false)
    net.Send(ply)
    ply.CanGetUp = true
end
