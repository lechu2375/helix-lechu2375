--HOW TO MAKE NEW BAND?
--MAKE AN ITEM, AND SET ITEM.BAND TO PROPER STRING
--like: ITEM.band = "blue"
--Now add key to the table below with color and description
--[string identificator={Color,string description}]

local bands = { --taka tablica, żeby nie zapierdalać po tabelach itemku
	["brown"] = {Color(102, 51, 51),"Brązowa opaska lojalisty"},
	["red"] = {Color(192, 57, 43),"Czerwona opaska lojalisty"},
	["green"] = {Color(39, 174, 96),"Zielona opaska lojalisty"},
	["blue"] = {Color(41, 128, 185),"Niebieska opaska lojalisty"},
	["white"] = {Color(221, 221, 221),"Biała opaska lojalisty"},
	["gold"] = {Color(241, 196, 15),"Złota opaska lojalisty"},
	["violet"] = {Color(142, 68, 173),"Fioletowa opaska lojalisty"}
} --why I have created table instead of declaring everything in item table? I just didn't know how character tooltip works, I wasn't sure if 
--(..)tooltip updates every tick.. 


function PLUGIN:PopulateCharacterInfo(client, character, tooltip)
	local band = client:GetNW2String("band",false) --string z typem opaski, czyli można rzec, że kolorem
	if band then --jako, że po zdjęciu banda NWString jest nilem to można zajebać takiego checka
		local panel = tooltip:AddRowAfter("name", "band")
		panel:SetBackgroundColor(bands.band[1]) 
		panel:SetText(bands.band[2])
		panel:SizeToContents()
    end
end	
