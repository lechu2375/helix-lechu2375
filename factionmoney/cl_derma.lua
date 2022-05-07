local PANEL = {}
function PANEL:Init()
    local function CreateRequestWindow(value,actionid,windowname)
        local panel = vgui.Create("DFrame")
        panel:MakePopup()
        panel:SetSize(ScrW()*.2,ScrH()*.2)
        panel:Center()
        panel:MakePopup()
        panel:ShowCloseButton(true)
        if(windowname)then
            panel:SetTitle(windowname)
        end
        local entry = panel:Add("DTextEntry")
        entry:SetValue(value)
        entry:Dock(TOP)
        entry:SetNumeric(true)
        local send = panel:Add("DButton")
        send:SetText("Send")
        send:SetFont("ixMenuButtonFont")
        send:Dock(TOP)
        send:SizeToContents()
        send.DoClick = function()
            panel:Remove()
            net.Start("FactionMoneyAction")
            net.WriteUInt(actionid,2)
            net.WriteString(ix.gui.factionmoney.factionuid)
            local gsub = string.gsub(entry:GetValue(),"[%a%p]","") 
            print(gsub,tonumber(gsub))
            net.WriteUInt(gsub,20) 
            net.SendToServer()
        end
        panel:InvalidateLayout(true)
        panel:SizeToChildren(false,true)
    end
    ix.gui.factionmoney = self
    self:MakePopup()
    self:SetSize(ScrW()*.5,ScrH()*.7)
    self:Center()
    self.contentholder = {}
    self.infolabel = self:Add("DLabel")
    self.infolabel:SetFont("ixTitleFont")
    self.infolabel:SetText("Information:")
    self.infolabel:Dock(TOP)
    self.infolabel:SizeToContentsY()
    self.line = self:Add("DLabel")
    self.line:SetFont("ixTitleFont")
    self.line:SetText("")
    self.line:Dock(TOP)
    self.line:SizeToContentsY()
    self.line.Paint = function(self,w,h)
        surface.SetDrawColor(color_white)
        surface.DrawLine(0,h/2,w,h/2)
    end
    self.buttonholder = self:Add("DPanel")
    self.buttonholder:Dock(TOP)
    self.buttonholder:SetZPos(10)
    self.withdrawbttn = self.buttonholder:Add("DButton")
    self.withdrawbttn:SetFont("ixMenuButtonFont")
    self.withdrawbttn:SetText("Withdraw")//0
    self.withdrawbttn:Dock(LEFT)
    self.withdrawbttn:SizeToContents()
    self.withdrawbttn.DoClick = function()
        CreateRequestWindow("",0)
    end



    self.editmoneybttn = self.buttonholder:Add("DButton")
    self.editmoneybttn:SetFont("ixMenuButtonFont")
    self.editmoneybttn:SetText("Edit Money")//1
    self.editmoneybttn:Dock(LEFT)
    self.editmoneybttn:SizeToContents()
    self.editmoneybttn.DoClick = function()
        CreateRequestWindow(self.contentholder.moneyLabel:GetText(),1)
    end


    self.depositbttn = self.buttonholder:Add("DButton")
    self.depositbttn:SetFont("ixMenuButtonFont")
    self.depositbttn:SetText("Deposit Money")//2
    self.depositbttn:Dock(LEFT)
    self.depositbttn:SizeToContents()
    self.depositbttn.DoClick = function()
        CreateRequestWindow("",2)
    end


    self.editbonus = self.buttonholder:Add("DButton")
    self.editbonus:SetFont("ixMenuButtonFont")
    self.editbonus:SetText("Edit Bonus")//3
    self.editbonus:Dock(LEFT)
    self.editbonus:SizeToContents()
    self.editbonus.DoClick = function()
        CreateRequestWindow(self.contentholder.bonusLabel:GetText(),3)
    end
    

    self.buttonholder:SizeToContents()
    self.buttonholder:SetDrawBackground(false)
    self.buttonholder:SetHeight(self.editmoneybttn:GetWide()/2)
end


function PANEL:Populate(infoTable)
    for k,v in pairs(self.contentholder) do
        v:Remove()

    end
    PrintTable(infoTable)
    self.contentholder.moneyLabel = self:Add("DLabel")
    self.contentholder.moneyLabel:SetText(string.format("Balance: %s",infoTable.money))
    self.contentholder.moneyLabel:Dock(TOP)
    self.contentholder.moneyLabel:SetFont("ixSubTitleFont")
    self.contentholder.moneyLabel:SizeToContentsY()
    self.contentholder.bonusLabel = self:Add("DLabel")
    self.contentholder.bonusLabel:SetText(string.format("Next salary bonus: %s",tonumber(infoTable.nextSalaryBonus)))
    self.contentholder.bonusLabel:SetFont("ixSubTitleFont")
    self.contentholder.bonusLabel:SizeToContentsY()
    self.contentholder.bonusLabel:Dock(TOP)
end
vgui.Register("FactionMoneyWindow",PANEL,"DFrame")
net.Receive("FactionMoneyWindowOpen", function()
    local infoTable = net.ReadTable()
    local uid = net.ReadString()
    local window
    if(IsValid(ix.gui.factionmoney)) then
        window = ix.gui.factionmoney
    else
        window = vgui.Create("FactionMoneyWindow")
    end
    window.factionuid = uid
    window:Populate(infoTable)
    //print("przyszło")
end)