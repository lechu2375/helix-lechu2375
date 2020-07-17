ITEM.name = "Vendor Refill Box"
ITEM.description = "Zapas  napojów do  automatu."
ITEM.model = "models/props_junk/cardboard_box001a.mdl"
ITEM.width = 3
ITEM.height = 2
ITEM.capacity = 5

function ITEM:GetDescription()
    return (self.description.."\n".."Items:"..(self:GetData("capacity") or self.capacity))
end


ITEM.functions.Restock = {
	OnRun = function(itemTable)
		local client = itemTable.player
        local ent = client:GetEyeTraceNoCursor().Entity
        if(ent:IsValid() and ent:GetClass()=="ix_vendor") then
            local items = ent.items
            local toRestock =  {}
            for k,v in  pairs(items) do
                if istable(v) and !table.IsEmpty(v)  and v[VENDOR_STOCK] and v[VENDOR_STOCK]<v[VENDOR_MAXSTOCK] then
                    toRestock[k] = v[VENDOR_MAXSTOCK]-v[VENDOR_STOCK]
                end
            end      
            local nTable= {
                ["amount"] = itemTable:GetData("capacity") or  itemTable.capacity,
                ["toRestock"] = toRestock
            }
            net.Start("requestStock")
                net.WriteTable(nTable)
            net.Send(client)  
            client.usedBox = itemTable
            client.vendorRefill = ent
            return false
        end
	end,
    OnCanRun = function(itemTable)
        local client = itemTable.player
        local ent =  client:GetEyeTraceNoCursor().Entity
		return (itemTable:GetData("capacity") or itemTable.capacity)>0 and  ent:IsValid() and ent:GetClass()=="ix_vendor" and  ent:GetPos():Distance(client:GetPos())<100
	end
}

/*


ITEM.functions.Empty = {
	OnRun = function(itemTable)
        local boxEnt = itemTable.entity
        local newBox = ents.Create("prop_physics")
        newBox:SetModel("models/props_junk/cardboard_box001a_gib01.mdl")
        newBox:SetPos(boxEnt:GetPos()+Vector(0,0,5))
        
        return true,newBox:Spawn()
        
	end,
    OnCanRun = function(itemTable)
        return ((itemTable:GetData("capacity") or 0)<=0 and IsValid(itemTable.entity))
	end
}*/ /*I got there problem with gib, if you want you can try to fix it.
Spawning carton gib from spawnmenu works well, but my "simple" spawn has problem with "folding" carton*/
