local char = ix.meta.character

function char:AddKarma(amount)
    amount = self:GetKarma()+math.abs(amount)
    self:SetKarma(amount)
end

function char:SubtractKarma(amount)
    amount = self:GetKarma()-math.abs(amount)
    self:SetKarma(amount)
end

