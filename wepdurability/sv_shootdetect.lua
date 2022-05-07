function PLUGIN:StartCommand(ply,ucmd)
    local character = ply:GetCharacter()
    if(!character) then return end
    local button =  ucmd:GetButtons()
    if(button==IN_ATTACK) then
        if(ply.lastweapon and ply.lastammo)then
            print(ply:GetActiveWeapon():GetHoldType())
            if(ply.lastweapon==ply:GetActiveWeapon():GetClass() and ply.lastammo~=ply:GetActiveWeapon():Clip1()) then
                //print("sczał")
                hook.Run("PlayerShootWeapon",ply,ply.lastweapon)
            elseif((ply:GetActiveWeapon():GetHoldType()=="melee" or ply:GetActiveWeapon():GetHoldType()=="knife") and (ply.meleesdelay and ply.meleesdelay<=CurTime()))then
                hook.Run("PlayerShootWeapon",ply,ply.lastweapon)
            end
            
        end
        ply.meleesdelay = CurTime()+.4
        SDUpadteWeapon(ply)
    end
end
function PLUGIN:PlayerSwitchWeapon(client)
    SDUpadteWeapon(client)
    //client.shooted = 0
end
function SDUpadteWeapon(client)
    if(IsValid(client))then
        local wep = client:GetActiveWeapon()
        if(IsValid(wep)) then
            client.lastweapon = wep:GetClass()
            client.lastammo = wep:Clip1()
        end
    end
    //print(client.shooted)
end



