GlobalTimer = GlobalTimer or {}
GlobalTimer.Name = GlobalTimer.Name or ""
GlobalTimer.EndTime = GlobalTimer.EndTime or 0 

net.Receive("globaltimerupdate", function()
    local Name = net.ReadString()
    local EndTime = tonumber(net.ReadString())
    GlobalTimer.Name = Name
    GlobalTimer.EndTime = EndTime
end)
local centerx = ScrW()/2
local hpos = ScrH()
function PLUGIN:PostRenderVGUI()
    if(GlobalTimer.EndTime<CurTime()) then  return end
    surface.SetFont("ixSubTitleFont")
    surface.SetTextColor(color_white)
    local name = GlobalTimer.Name 
    local timeLeft = string.FormattedTime( math.floor(GlobalTimer.EndTime-CurTime()), "%02i:%02i" )
    local width,height = surface.GetTextSize(name)
    surface.SetTextPos(centerx-width/2,0)
    surface.DrawText(name)
    width,height = surface.GetTextSize(timeLeft)
    surface.SetTextPos(centerx-width/2,height)
    surface.DrawText(timeLeft)
end