util.AddNetworkString("hitEffect")
local char = ix.meta.character

function char:getArmorClass()
    local items=self:GetInventory():GetItems()
    for k,v in pairs(items) do
        if v.base == "base_ballisticeq" and v:GetData("equip") == true then
            return v.protectionlevel
        end
    end
    return false
end



function char:getArmorItem()
    local items=self:GetInventory():GetItems()
    for k,v in pairs(items) do
        if v.base == "base_ballisticeq" and v:GetData("equip") == true then
            return v
        end
    end
    return false
end

function char:getArmorItemByHG(hitgroup)
    local items=self:GetInventory():GetItems()
    for k,v in pairs(items) do
        if v.base == "base_ballisticeq" and v:GetData("equip") == true and v.hitgroup == hitgroup then
            return v
        end
    end
    return false
end

local armorLevels ={
    [1] = 15,
    [2] = 25,
    [3] = 35,
    [4] = 45
}
function  PLUGIN:ScalePlayerDamage(ply,hitgroup,dmginfo)
    local char = ply:GetCharacter()
    local damage = dmginfo:GetDamage()
    if damage<1 then return true end
    if hitgroup  == HITGROUP_RIGHTARM or hitgroup  == HITGROUP_LEFTARM then
        hitgroup = HITGROUP_CHEST
    end
    local item = char:getArmorItemByHG(hitgroup)
    if item then
        local class = item.protectionlevel
        local durability = item:GetData("durability") or item.protectionlevel * 100
        if durability>=damage then
            if damage>armorLevels[class] then --dmg wiekszy niz ochronka
                
                item:SetData("durability",math.max(0,durability-damage))
                if math.random(1,100)>=40 then
                    damage=math.max(0,damage-armorLevels[class])
                    ply:EmitSound("physics\metal\metal_solid_impact_bullet"..math.random(1,4)..".wav",70)
                    
                    
                end
                
            else --dmg mniejszy od ochronki
                item:SetData("durability",math.max(0,durability-damage))
                damage=math.max(0,damage-armorLevels[class])
                ply:EmitSound("physics\metal\metal_solid_impact_bullet"..math.random(1,4)..".wav",70)
                
                
            end
        else
            item:SetData("durability",math.max(0,durability-damage))
            if math.random(1, durability)>math.random(1,item.protectionlevel * 100) then
                
                damage=math.max(0,damage-armorLevels[class])
                ply:EmitSound("physics\metal\metal_solid_impact_bullet"..math.random(1,4)..".wav",70)
                
                
            end
        end
        dmginfo:SetDamage(damage)
    end
end

