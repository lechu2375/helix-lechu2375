util.AddNetworkString("VendorDecilineSound")
function PLUGIN:PlayerDeath( victim,inflictor,attacker )
    if(!(attacker:IsPlayer())) then return end
    if(ix.config.Get("KarmaEnabled", true)) then
        local vChar =  victim:GetCharacter()
        local aChar = attacker:GetCharacter()
        if(vChar:GetKarma()>50) then
            aChar:SubtractKarma(1)
        else
            aChar:AddKarma(1)
        end
    end
end

function PLUGIN:PlayerUse(client,ent)
    if(!(ent:GetClass()=="ix_vendor")) then return end
    local char = client:GetCharacter()
    if(char:GetKarma()<50) then
        if((client.NextKarmaNotify or CurTime())<=CurTime()) then
            client:ChatNotify("Low Karma")
            client.NextKarmaNotify = CurTime()+2
            net.Start("VendorDecilineSound")
            net.WriteEntity(ent)
            net.Send(client)
        end 
        return false 
    end
end
function PLUGIN:CanPlayerTradeWithVendor(client)
    local char = client:GetCharacter()
    if(char:GetKarma()<50) then
        client:ChatNotify("Low Karma")
        return false 
    end
end
