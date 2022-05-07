local centerx,centery = ScrW()/2,ScrH()/2
local topmid = ScrH()-ScrH()*.6
local giveuptext = "X 로 리스폰 |"
local calltext = " H 로 도움 요청"
function PLUGIN:DrawOverlay()
    if(bDrawDeathText)then
        
        draw.SimpleText(calltext,"ixTitleFont",centerx,centery,color_white)
        surface.SetFont("ixTitleFont")
        local sizex,sizey = surface.GetTextSize(giveuptext)
        draw.SimpleText(giveuptext,"ixTitleFont",centerx-sizex,centery,color_white)
        surface.SetFont("ix3D2DFont")
        local str = math.Round(ix.config.Get("TimeToRevive", 30)-(CurTime()-TimeToDie))  
        sizex,sizey = surface.GetTextSize(str)
        draw.SimpleText(str,"ix3D2DFont",centerx-sizex/2,topmid,color_white)
    end
end

net.Receive("DrawDeathText", function()
    local bool = net.ReadBool()
    bDrawDeathText = bool
    if(bDrawDeathText) then
    TimeToDie = CurTime()
    end
end)    

function PLUGIN:PlayerButtonDown(ply,button)
    if((LocalPlayer().nextReviveAction or CurTime())<=CurTime()) then
        LocalPlayer().nextReviveAction = CurTime()+4
        if(button==KEY_H) then
            net.Start("ReviveAction")
                net.WriteUInt(1,1)
            net.SendToServer()
        elseif(button==KEY_X)then
            net.Start("ReviveAction")
                net.WriteUInt(1,0)
            net.SendToServer()
        end
    end
end