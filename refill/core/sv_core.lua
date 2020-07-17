util.AddNetworkString("requestStock")
REFILL_EXPLOIT = 1
REFILL_SUCCESS = 2

ix.log.AddType("vendorRestock", function(client,type)
    local tabela ={
        [REFILL_EXPLOIT] = "has sent fake data to the server. Probably exploiter.",
        [REFILL_SUCCESS] = "has refilled item."
    }
    return string.format("%s %s", client:Name(),tabela[type])
end,FLAG_DANGER)

net.Receive("requestStock", function(_,ply)
    if (ply.restockDelay or CurTime())>CurTime() then
        return 
    else
        ply.restockDelay = CurTime()+2
        local char = ply:GetChar()
        if not char then return end
        local dataTable = net.ReadTable()
        local usedBox = ply.usedBox
        local sum=0
        for _,v in pairs(dataTable) do  //zliczanie ilosci przedmiotow do odnowienia
            sum=sum+v
        end
        local cap = usedBox:GetData("capacity") or usedBox.capacity
        if sum>cap  then //jak  by za duzo 
            ix.log.Add(ply,"vendorRestock",REFILL_EXPLOIT)
            return
        end
        if !ply.vendorRefill:IsValid() then //jesli jakims cudem nie ma vendora
            ply:Notify("Something went wrong with vendor validation.")
            return
        end
        if ply.vendorRefill:GetPos():Distance(ply:GetPos())>100 then//no jak za daleko albo physgunem go  ktos wyjebie toprzykro mi
            ply:Notify("You are too far from the vendor.")
        end

        local items = ply.vendorRefill.items
        for k,v in pairs(dataTable) do
            if items[k][VENDOR_MAXSTOCK]<items[k][VENDOR_STOCK]+v then//something went wrong kurwa exploiter report
                ix.log.Add(ply,"vendorRestock",REFILL_EXPLOIT)
                continue
            elseif v>0 then
                ply.vendorRefill:SetStock(k,items[k][VENDOR_STOCK]+v)
                ix.log.Add(ply,"vendorRestock",REFILL_SUCCESS)
            end
        end

        usedBox:SetData("capacity",cap-sum)
        ply.vendorRefill = nil
        ply.usedBox = nil
    end


end)


