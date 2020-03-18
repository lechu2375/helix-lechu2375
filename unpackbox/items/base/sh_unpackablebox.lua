ITEM.name = "Box Base"
ITEM.model = Model("models/props_junk/cardboard_box001a.mdl")
ITEM.description = "Unpack it."
ITEM.width = 2
ITEM.height = 2

ITEM.functions.Unpack = {
	OnRun = function(item)
        if item.entunbox then
            local pos = item.entity:GetPos()
            pos:Add(Vector(0,0,50))//prevention for stuck ents inside  world
            local spawned = ents.Create(item.entunbox)
            spawned:SetPos(pos)
            spawned:Spawn()
            return true
        end
		
	end,
	OnCanRun = function(item)
                return IsValid(item.entity)
	end
}