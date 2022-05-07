function PLUGIN:PlayerShootWeapon(client,class)
  
   
  local character = client:GetCharacter()
    if(!character)then return end
    local WeaponItem = character:GetEquippedWeaponItem(class)
    if(!WeaponItem) then return end
    local Durability = WeaponItem:GetData("durability",WeaponItem.durability)
    if(Durability<1)then
        WeaponItem:SetData("equip",false)
        client:StripWeapon(class)
    end
    WeaponItem:SetData("durability",(Durability-1))
end

function RepairWeapon(item,amount)
    if(!item or !amount)  then 
        return false 
    end
    local MaxRepair = item.durability
    local durability = math.Clamp(item:GetData("durability",MaxRepair)+amount,0,MaxRepair)
    //print(durability)
    item:SetData("durability",durability)
end

function PLUGIN:CanPlayerInteractItem(client, action, item, data)
    action = string.lower(action)
    item = ix.item.instances[item]
    if( item and item.durability and action=="equip") then
        return item:GetData("durability",item.durability)>0
    end
end
