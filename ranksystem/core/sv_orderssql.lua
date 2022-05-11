util.AddNetworkString("requestOrders")
local query
query = mysql:Create("orders")
    query:Create("entryid", "INT UNSIGNED NOT NULL AUTO_INCREMENT")
	query:Create("charid", "INT UNSIGNED NOT NULL")
	query:Create("orderid", "INT UNSIGNED NOT NULL")
    query:PrimaryKey("entryid")
query:Execute()

local char = ix.meta.character
function char:getOrders()
    //if !(ix.faction.Get(self:GetFaction()).orders) then return false end
    local toReturn = {}
    local id = self:GetID()
    local query = mysql:Select("orders")

	query:Select("orderid")
	query:Where("charid", id)

    query:Callback(function(result)
        if (istable(result) and #result > 0) then
            toReturn =  result         
        end
    end)
    query:Execute()
    return toReturn
end

function char:hasOrder(orderid)
    local toReturn = false
    local query = mysql:Select("orders")
	query:Select("orderid")
    query:Select("entryid")
	query:Where("charid", self:GetID())
    query:Where("orderid", orderid)
    query:Callback(function(result)
        if result then toReturn = true end
    end)
    query:Execute()
    return toReturn
end

function char:giveOrder(orderid)
    if self:hasOrder(orderid) then return false end
    local query = mysql:Insert("orders")
    query:Insert("charid", self:GetID())
    query:Insert("orderid",orderid)
    query:Execute() 
    return true
end

function char:removeOrder(orderid)
    local query = mysql:Delete("orders")
    query:Where("charid", self:GetID())
    query:Where("orderid", orderid)
    query:Execute() 
end

function char:clearOrders()
    local query = mysql:Delete("orders")
    query:Where("charid", self:GetID())
    query:Execute() 
end

net.Receive("requestOrders", function(len,ply)
    //if (ply.nextOrderRequest or CurTime())>CurTime() then return end
    //ply.nextOrderRequest = CurTime()+.5
    local id = net.ReadInt(10)
    local char = Player(id):GetCharacter()
    local toReturn = char:getOrders()
    id = char:GetID()
    if not toReturn then 
        toReturn = {}
    end
    net.Start("requestOrders")
        net.WriteTable(toReturn)
        net.WriteInt(id,10)
    net.Send(ply)
    //print("[DEBUG] Wysłano do gracza info o orderach.")
end)

 