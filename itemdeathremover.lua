PLUGIN.name = "Death item remover"
PLUGIN.author = "Lechu2375"

if(SERVER)then
    function PLUGIN:PostPlayerDeath(ply)
        local character = ply:GetCharacter()
        if(!character) then return end
        local items = character:GetInventory():GetItems()
        local faction = character:GetFaction()
        print(FACTION_SCIENTISTS,faction)
        for k,v in pairs(items)do

            if(v.removeOnDeath and !(table.HasValue(v.dropDisableFactions,faction))) then
                v:Remove()
            end
        end
    end
end