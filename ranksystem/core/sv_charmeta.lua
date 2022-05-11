local char = ix.meta.character

function char:setRank(rank)
    rank = string.lower(rank)
    local dataType = ix.util.GetTypeFromValue(rank)
    local rankTable = ix.faction.Get(self:GetFaction()).ranks
    if dataType == ix.type.string  and  rankTable then 
        for index,v in pairs(rankTable) do
            if string.lower(v.shortname) == rank or string.lower(v.longname) == rank then
                self:SetRank(index)
                return true
            end
        end
    elseif dataType == ix.type.number then
        if #rankTable>=rank then
            self:SetRank(rank) 
            return false 
        end
    end
    return false
end
