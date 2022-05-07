PLUGIN.name = "Karma system"
PLUGIN.author = "Lechu2375"

ix.util.Include("sv_core.lua")
ix.util.Include("sv_meta.lua")

ix.char.RegisterVar("karma", {
	field = "karma",
	fieldType = ix.type.number,
	default = 100,
	isLocal = false,
	bNoDisplay = true
})


ix.config.Add("KarmaEnabled", true, "Should Karma be calculated on kill?", nil, {
	category = "Karma System"
})

ix.command.Add("SetCharacterKarma", {
	description = "Set someone Karma amount",
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.number
	},
	OnRun = function(self, client, target, amount)
		target:SetKarma(amount)
		client:Notify(string.format("%s now has %s karma points",target:GetName(),target:GetKarma()))
	end
})
ix.command.Add("AddCharacterKarma", {
	description = "Add karma points to someone",
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.number
	},
	OnRun = function(self, client, target, amount)
		target:AddKarma(amount)
		client:Notify(string.format("%s now has %s karma points",target:GetName(),target:GetKarma()))
	end
})
ix.command.Add("TakeCharacterKarma", {
	description = "Take karma points from someone",
	adminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.number
	},
	OnRun = function(self, client, target, amount)
		target:SubtractKarma(amount)
		client:Notify(string.format("%s now has %s karma points",target:GetName(),target:GetKarma()))
	end
})

local KarmaRanks = { //if is higher  or equal then good
	["Satanic"] = 0,
	["Evil"]  = 21,
	["Neutral"] = 41,
	["Heroic"] = 61,
	["Saint"] = 81
}
function GetKarmaRank(karma)
	local KarmaRank  = "None"
	for k,v in SortedPairsByValue(KarmaRanks) do
		if(karma>=v) then
			KarmaRank = k
		end
	end
	return KarmaRank
end

if(CLIENT)  then
	net.Receive("VendorDecilineSound", function()
		local ent = net.ReadEntity()
	    ent:EmitSound("vo/k_lab/kl_nonsense.wav")	
	end)

	function PLUGIN:CreateCharacterInfo(charInfo)
        charInfo.karma = charInfo:Add("ixListRow")
		charInfo.karma:SetList(charInfo.list)
		charInfo.karma:Dock(TOP)
		charInfo.karma:SizeToContents()
    end

    function PLUGIN:UpdateCharacterInfo(charInfo)
        local char = LocalPlayer():GetChar()
        if(charInfo.karma) then
            charInfo.karma:SetLabelText("Your karma rank")
            charInfo.karma:SetText(GetKarmaRank(char:GetKarma()))
            charInfo.karma:SizeToContents()
        end
    end

	function PLUGIN:PopulateCharacterInfo(client, character, tooltip)
		local KarmaAmount = character:GetKarma()
		if KarmaAmount then
			local panel = tooltip:AddRowAfter("karma", "name")
			panel:SetText(string.format("He is %s",GetKarmaRank(KarmaAmount)))
			panel:SizeToContentsX()
		end
	end
end