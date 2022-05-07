PLUGIN.nama = "Weapon Durability"
PLUGIN.author = "Lechu2375"

ix.util.Include("sv_shootdetect.lua")
ix.util.Include("sh_charmeta.lua")
ix.util.Include("sv_weaponhandling.lua")

 	ix.command.Add("TestRepair", {
 		description = "gyuu",
 		adminOnly = true,
        arguments = ix.type.number,
 		OnRun = function(self, client,amount)
            local character = client:GetCharacter()
            local weaponitem = character:GetEquippedWeaponItem(client:GetActiveWeapon():GetClass())
            //print(weaponitem,"itemek")
            RepairWeapon(weaponitem,amount)
		end
})


if(CLIENT) then
      function PLUGIN:PopulateItemTooltip(tooltip, item)
            local durability =  item:GetData("durability",item.durability)
            if (durability and item.durability) then
                  local name = tooltip:AddRow("durability")
                  local percentage = ((durability/item.durability)*100)
                  percentage = math.Round(percentage)
                  if(percentage<=20 and percentage>1) then
                  name:SetText(string.format("Usage %s%%. \n This weapon will break soon.",percentage)) 
                  elseif (percentage<1) then
                        name:SetText(string.format("Broken weapon",percentage))
                        name:SetTextColor(Color(255,0,0))
                  else
                        name:SetText(string.format("Usage %s%%.",percentage))
                  end
                                                
                  name:SizeToContents()
                  tooltip:SizeToContents()
            end
      end

end