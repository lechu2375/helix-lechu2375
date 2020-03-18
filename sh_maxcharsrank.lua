PLUGIN.name = "Rank based max chars"
PLUGIN.author = "Lechu2375"
PLUGIN.description = "Maximal characters are based on player group."
PLUGIN.license =  "MIT not for use on Kaktusownia opensource.org/licenses/MIT"
//FOR ADDING NEW RANKS CHECK 28 LINE
local pluginTable = {}
local function addRanked(group,amount)
    if !isstring(group)  then
        Error("[MaxCharsPlugin]Group should be number!")
    end
    if !isnumber(amount) then
        error("[MaxCharsPlugin]Amount should be number!")
    end
    pluginTable[group] = amount
end

function PLUGIN:GetMaxPlayerCharacter(client)
    if pluginTable[client:GetUserGroup()] then
        return pluginTable[client:GetUserGroup()]
    end
end
//EXAMPLES\\
/*
addRanked("user",2)
addRanked("vip",3)
addRanked("admin",2)
addRanked("superadmin",4)
just copy the function and change arguments to whatever you want.

The syntax is: addRanked(string userGroup,int maxChars)
*/
//PASTE UNDER THERE NEW DECLARATIONS
addRanked("superadmin",4)
