util.AddNetworkString("globaltimerupdate")
GlobalTimer = GlobalTimer or {}
GlobalTimer.Name = GlobalTimer.Name or ""
GlobalTimer.EndTime = GlobalTimer.EndTime or 0 
function TimerSend(name,endtime)
    endtime= CurTime()+endtime
    GlobalTimer.Name = name
    GlobalTimer.EndTime = endtime
    net.Start("globaltimerupdate")
        net.WriteString(GlobalTimer.Name)
        net.WriteString(tostring(GlobalTimer.EndTime))
    net.Broadcast()
end

timer.Create("GlobalTimerUpdater",2,0, function()
    if(GlobalTimer.EndTime>CurTime()) then
        net.Start("globaltimerupdate")
            net.WriteString(GlobalTimer.Name)
            net.WriteString(tostring(GlobalTimer.EndTime))
        net.Broadcast()
    end
end)