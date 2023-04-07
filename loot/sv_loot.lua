local ItemsToSpawn= {"smg","paper","soda"} //items to spawn
local allowedmodels = {"models/props_wasteland/controlroom_storagecloset001a.mdl"} // containers with these model will be able to get random loot
local customItems = {}
customItems["models/props_junk/wood_crate001a_damaged.mdl"] = {"smg","soda"} // unique loot pool pel model




function SpawnAtContainer()
    local containers = ents.FindByClass("ix_container")
    if(!containers) then return false end
    for k,v in pairs(containers) do
        if(v.password or !table.HasValue(allowedmodels,v:GetModel())) then
            if(customItems[v:GetModel()]) then
                continue
            end
            //print(k,"remove")
            table.remove(containers,k)
        end
    end
    if(!containers) then return false end
    local RandomContainer = containers[math.random(1,#containers)]
    //print(RandomContainer)
    if(RandomContainer)then
        local inv = RandomContainer:GetInventory()
        local item
        if(ItemsToSpawn) then
            local customTable = customItems[RandomContainer:GetModel()]
            if(customTable) then
                item = customTable[math.random(1, #customTable)]
            else
                item = ItemsToSpawn[math.random(1, #ItemsToSpawn)]
            end
            inv:Add(item)
        end
    end

end 

function RefreshItemSpawnerTimer()
    if(timer.Exists("ItemSpawnerTimer"))then
        timer.Remove("ItemSpawnerTimer")
    end
    timer.Create("ItemSpawnerTimer",ix.config.Get("ItemSpawnerInterval",10),0,SpawnAtContainer)
end
RefreshItemSpawnerTimer()
