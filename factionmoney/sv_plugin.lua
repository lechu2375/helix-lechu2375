util.AddNetworkString("FactionMoneyWindowOpen")
util.AddNetworkString("FactionMoneyAction")
local salaryinterval = 2
function PLUGIN:LoadData()
    FactionAccount = ix.data.Get("factionaccount",{},false,true)
    print("Loading Faction Accounts")
    for _,v in pairs(ix.faction.indices) do 
        if(!FactionAccount[v.uniqueID]) then
            FactionAccount[v.uniqueID] = {}
            FactionAccount[v.uniqueID].money = math.random(0, 100)
            FactionAccount[v.uniqueID].name = v.name
            FactionAccount[v.uniqueID].lastSalary = os.time()
            FactionAccount[v.uniqueID].nextSalary = os.time()+salaryinterval
            FactionAccount[v.uniqueID].nextSalaryBonus = 0
        end
    end
end
FactionAccountConnectTable = {
    ["warsongs"] =  "citizen"
}


function PLUGIN:SaveData()
    if(!FactionAccount) then
        FactionAccount={}
    end
    ix.data.Set("factionaccount",FactionAccount,false,true)
end

timer.Create("FactionSalaryChecker",5,0,function()
    //print("salary check")
    for k,v in pairs(FactionAccount) do
        if(v.nextSalary<=os.time()) then
            AddFactionMoney(k,(ix.faction.teams[k].salary or 100)+(v.nextSalaryBonus or 0))
            v.lastSalary = os.time()
            v.nextSalary = os.time()+salaryinterval
            v.nextSalaryBonus = 0
        end
    end
end)

function AddFactionMoney(uniqueID,amount)
    //print(uniqueID,"nil?")
    local FactionAccountTable
    if(FactionAccountConnectTable[uniqueID]) then
        FactionAccountTable =  FactionAccount[FactionAccountConnectTable[uniqueID]]
    else
        FactionAccountTable =  FactionAccount[uniqueID]
    end
    if(!FactionAccountTable) then
        return false
    end
    FactionAccountTable.money = FactionAccountTable.money+math.abs(amount)
    return true
end
function TakeFactionMoney(uniqueID,amount)
    if(FactionAccountConnectTable[uniqueID]) then
        FactionAccountTable =  FactionAccount[FactionAccountConnectTable[uniqueID]]
    else
        FactionAccountTable =  FactionAccount[uniqueID]
    end
    if(!FactionAccountTable) then
        return false
    end
    FactionAccountTable.money = FactionAccountTable.money-math.abs(amount)
    return true
end

function AddFactionSalaryBonus(uniqueID,amount)
        local FactionAccountTable
    if(FactionAccountConnectTable[uniqueID]) then
        FactionAccountTable =  FactionAccount[FactionAccountConnectTable[uniqueID]]
    else
        FactionAccountTable =  FactionAccount[uniqueID]
    end
    if(!FactionAccountTable) then
        return false
    end
    FactionAccountTable.nextSalaryBonus = FactionAccountTable.nextSalaryBonus+math.abs(amount)
    return true
end

function AddFactionSalaryBonus(uniqueID,amount)
    local FactionAccountTable
    if(FactionAccountConnectTable[uniqueID]) then
        FactionAccountTable =  FactionAccount[FactionAccountConnectTable[uniqueID]]
    else
        FactionAccountTable =  FactionAccount[uniqueID]
    end
    if(!FactionAccountTable) then
        return false
    end
    FactionAccountTable.nextSalaryBonus = FactionAccountTable.nextSalaryBonus+math.abs(amount)
    return true
end

function GetFactionMoney(uniqueID)
    local FactionAccountTable
    if(FactionAccountConnectTable[uniqueID]) then
        FactionAccountTable =  FactionAccount[FactionAccountConnectTable[uniqueID]]
    else
        FactionAccountTable =  FactionAccount[uniqueID]
    end

    return FactionAccountTable.money
end

local charMeta = ix.meta.character

function charMeta:GetFactionMoney()
    local FactionAccountTable
    local uniqueID  = ix.faction.indices[self:GetFaction()].uniqueID
    if(FactionAccountConnectTable[uniqueID]) then
        FactionAccountTable =  FactionAccount[FactionAccountConnectTable[uniqueID]]
    else
        FactionAccountTable =  FactionAccount[uniqueID]
    end

    return FactionAccountTable.money
end



net.Receive("FactionMoneyAction", function(len,ply)
    if(!(ply:IsAdmin()))then return end
    local action = net.ReadUInt(2)
    local uniqueID = net.ReadString()
    local character = ply:GetCharacter()
    //print(action)

    if(action==0)then
        local toTake = net.ReadUInt(20) //XD
        local amount = GetFactionMoney(uniqueID)
        if(amount>=toTake)then
            TakeFactionMoney(uniqueID,toTake)
            character:GiveMoney(toTake)
        end
    elseif(action==1)then
        local toSet = net.ReadUInt(20) //XD


        local FactionAccountTable
        if(FactionAccountConnectTable[uniqueID]) then
            FactionAccountTable =  FactionAccount[FactionAccountConnectTable[uniqueID]]
        else
            FactionAccountTable =  FactionAccount[uniqueID]
        end
        FactionAccountTable.money = toSet
    elseif(action==2)then
        local toGive = net.ReadUInt(20) //XD
        if(character:HasMoney(toGive)) then
            character:TakeMoney(toGive)
            //print(2)
            AddFactionMoney(uniqueID,toGive)
        end

    elseif(action==3)then
        //print("asd")
        local toSet = net.ReadUInt(20) //XD
        local FactionAccountTable
        if(FactionAccountConnectTable[uniqueID]) then
            FactionAccountTable =  FactionAccount[FactionAccountConnectTable[uniqueID]]
        else
            FactionAccountTable =  FactionAccount[uniqueID]
        end
        //print(toSet,FactionAccountTable.name)
        FactionAccountTable.nextSalaryBonus = toSet
    end
    UpdateFactionMoneyDerma(ply,uniqueID)
end)

function UpdateFactionMoneyDerma(client,factionUID)
	local FactionAccountTable
    if(FactionAccountConnectTable[factionUID]) then
    	FactionAccountTable =  FactionAccount[FactionAccountConnectTable[factionUID]]
    else
    	FactionAccountTable =  FactionAccount[factionUID]
    end
    for k,v in pairs(FactionAccount)do
		if(v.name==FactionAccountTable.name) then
			factionUID = k
			break 
		end
	end
    if(FactionAccountTable) then
		local toSend = {}
		toSend.money = FactionAccountTable.money
		toSend.nextSalaryBonus = FactionAccountTable.nextSalaryBonus
		net.Start("FactionMoneyWindowOpen")
			net.WriteTable(toSend)
			net.WriteString(factionUID)
		net.Send(client)
    end
end