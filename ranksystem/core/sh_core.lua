local char = ix.meta.character

function char:getLongRank()
    local rankTable = ix.faction.Get(self:GetFaction()).ranks
    if rankTable then
        if rankTable[self:GetRank()].longname then
            return rankTable[self:GetRank()].longname
        else
            return
        end
    end
end

function char:getShortRank()
    local rankTable = ix.faction.Get(self:GetFaction()).ranks
    if rankTable then
        if rankTable[self:GetRank()].longname then
            return rankTable[self:GetRank()].shortname
        else
            return 
        end
    end
end



function PLUGIN:GetCharacterName(speaker, chatType)
    local faction = speaker:Team()
    if factionRanks.scoreboardRanks[faction] then
        local char = speaker:GetCharacter()
        return char:getLongRank().." "..char:GetName()
    end
end

function canPromote(promoter,who,rank)
    if promoter:GetPlayer():IsAdmin() then //jest admin  to moze
        //print("nie ma admina")
        return true 
    end
    if !(promoter:GetFaction()==who:GetFaction()) then //inna  frakcja nie moze
        //print("nie ta frakcja")
        promoter:GetPlayer():Notify("You can't promote someone from diffrent faction.")
        return false
    end
    
    rank = string.lower(rank)
    if isstring(rank) then //konwersja rangi w stringu na range int numer kurwa
        local rankTable = ix.faction.Get(who:GetFaction()).ranks
        for index,v in pairs(rankTable) do
            if string.lower(v.shortname) == rank or string.lower(v.longname) == rank then
                rank = index
                break
            end
        end
    end
    if isstring(rank) then 
        //print("brak takiej rangi")
        promoter:GetPlayer():Notify("Wrong rank.")
        return false
    end
    local pRank = promoter:GetRank()
    if pRank<=rank then //jak ktos chce awansowac typa wyzej od sb nie moze
        //print("za wysoko")
        promoter:GetPlayer():Notify("You can't promote someone higher than you.")
        return false
    end
    
    if ix.faction.Get(promoter:GetFaction()).ranks[promoter:GetRank()].canPromote then
        return true
    end
    
    return false
end