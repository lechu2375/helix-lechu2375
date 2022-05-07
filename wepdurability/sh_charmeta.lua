local character = ix.meta.character

function character:GetEquippedWeaponItem(class)
    local inventory = self:GetInventory()
    local items = inventory:GetItems()
    for _,v in pairs(items) do
        if(v.class and v.class == class and v:GetData("equip")) then
            return v
        end
    end
    return false
end