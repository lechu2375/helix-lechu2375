ITEM.name = "Loot base"
ITEM.model = "models/props_junk/cardboard_box004a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Item that can save your life."
ITEM.category = "lootboxes"
ITEM.lootcategories = { //min number 0 max 100
    ["blue"] = 0, 
    ["navy"] = 80, //if random number is higher or euqual 80 then curren category will be navy
    ["purple"] = 95,//if random number is higher or euqual 95 then curren category will be navy
    ["pink"] = 95.2,
    ["red"] = 99.18
}

function ITEM:GetRandomLootCategory()
    local number = math.Rand(0,100)
    local category
    for k,v in SortedPairsByValue(self.lootcategories) do
        if(number>=v) then
            category=k
        end
    end
    return category
end

function ITEM:GetDescription()
    local str = self.description
    local lootitems = self.loot
    for k,v in SortedPairsByValue(self.lootcategories) do
        str = str.."\n"..math.Round(100-v,3).."%:\n"
        for num,item in pairs(lootitems[k]) do
            str = str..item
            if(num~=#lootitems[k])  then
                str=str.."\n"
            end
        end
    end
    return str
end

function ITEM:GetRandomItemByLootCategory(category)
    local lootTable = self.loot[category]
    if(!lootTable) then
        return false
    end
    local randomUID = lootTable[math.random(1,#lootTable)]
    return randomUID
end


	local sounds = {
		"physics/cardboard/cardboard_box_impact_soft3.wav",
		"physics/cardboard/cardboard_cup_impact_hard1.wav",
		"physics/cardboard/cardboard_box_break1.wav",
		"physics/cardboard/cardboard_box_break2.wav"
	}

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.open = { -- sorry, for name order.
	name = "Open",
	tip = "Open case and get random item",
	icon = "icon16/heart_add.png",  
	OnRun = function(item)
        local category = item:GetRandomLootCategory()
        local uid = item:GetRandomItemByLootCategory(category)
        local client = item.player
        if(uid) then
            ix.util.EmitQueuedSounds(client,sounds, 0, .1)
            client:SetAction("Unboxing...", 4, function()
                client:GetCharacter():GetInventory():Add(uid)
                return false
            end)
        else
            client:Notify("Something went wrong with unboxing.")
        end
        return true
	end,
    OnCanRun = function(item)
        return(!item.entity and !IsValid(item.entity))
    end
}


