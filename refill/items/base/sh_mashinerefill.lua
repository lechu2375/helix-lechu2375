ITEM.name = "Box of cans"
ITEM.description = "Zapas  napojów do  automatu."
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.width = 3
ITEM.height = 2
ITEM.capacity = 10

function ITEM:GetDescription()
    return (self.description.."\n".."Cans:"..(self:GetData("capacity") or self.capacity))
end


ITEM.functions.Restock = {
	OnRun = function(itemTable)
		local client = itemTable.player
        local ent = client:GetEyeTraceNoCursor().Entity
        if(ent:IsValid() and ent:GetClass()=="ix_vendingmachine") then
            local items = ent.Items
            local capacity = itemTable:GetData("capacity") or itemTable.capacity
            local resupply = {}
            for k,_ in pairs(items) do
                resupply[k] = math.abs(ent:GetStock(k)-ent.MaxStock)
            end          
            for k,v in pairs(resupply) do
                if v<=0 then continue end
                if capacity<=0 then break end
                for i = v,1,-1 do 
                    if capacity<=0 then break end
                    ent:SetStock(k,ent:GetStock(k)+1)
                    capacity=capacity-1
                end
            end
            itemTable:SetData("capacity",capacity)

            if capacity<=0 then 
                return true 
            else
                return false
            end
        end
	end,
    OnCanRun = function(itemTable)
        local client = itemTable.player
        local ent =  client:GetEyeTraceNoCursor().Entity
		return (ent:IsValid() and ent:GetClass()=="ix_vendingmachine" and  ent:GetPos():Distance(client:GetPos())<100)
	end
}
ITEM.functions.RestockNearest = {
	OnRun = function(itemTable)
		local client = itemTable.player
        local entsTable = ents.FindInSphere(client:GetPos(),100)
        local ent
        for _,v in pairs(entsTable) do
            if v:GetClass()=="ix_vendingmachine" then
                ent = v
                break
            end
        end
        
        if(ent:IsValid()) then
            local items = ent.Items
            local capacity = itemTable:GetData("capacity") or itemTable.capacity
            local resupply = {}
            for k,_ in pairs(items) do
                resupply[k] = math.abs(ent:GetStock(k)-ent.MaxStock)
            end          
            for k,v in pairs(resupply) do
                if v<=0 then continue end
                if capacity<=0 then break end
                for i = v,1,-1 do 
                    if capacity<=0 then break end
                    ent:SetStock(k,ent:GetStock(k)+1)
                    capacity=capacity-1
                end
            end
            itemTable:SetData("capacity",capacity)

            if capacity<=0 then 
                return true 
            else
                return false
            end
        end
	end
}
