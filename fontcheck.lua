if CLIENT then
    local asccistring = ""
    for i=48,122 do
        asccistring=asccistring..string.char(i) 
    end
    function AddLabelPanel(font)
        local label = FONTCHECK.scrollpanel:Add("DLabel")
        label:SetText(font)
        //label:SetText(font..asccistring) - uncomment this if you want to see other characters
        label:SetFont(font)
        label:Dock(TOP)
        label:SizeToContents()
     end
    concommand.Add("fontcheck", function()
        //print(asccistring)
        if(FONTCHECK) then
            FONTCHECK:Remove()
            FONTCHECK=nil
        else
            
            FONTCHECK = vgui.Create("DFrame")
            FONTCHECK:SetSize(ScrW()*.7,ScrH()*.95)
            FONTCHECK:Center()
            FONTCHECK:MakePopup()
            FONTCHECK.scrollpanel = FONTCHECK:Add("DScrollPanel")
            FONTCHECK.scrollpanel:Dock(FILL)

            AddLabelPanel("ix3D2DFont")
            AddLabelPanel("ix3D2DMediumFont")
            AddLabelPanel("ix3D2DSmallFont")
            AddLabelPanel("ixTitleFont")
            AddLabelPanel("ixSubTitleFont")
            AddLabelPanel("ixMenuMiniFont")
            AddLabelPanel("ixMenuButtonFont")
            AddLabelPanel("ixMenuButtonFontSmall")
            AddLabelPanel("ixMenuButtonFontThick")
            AddLabelPanel("ixMenuButtonLabelFont")
            AddLabelPanel("ixMenuButtonHugeFont")
            AddLabelPanel("ixToolTipText")
            AddLabelPanel("ixMonoSmallFont")
            AddLabelPanel("ixMonoMediumFont")
            AddLabelPanel("ixBigFont")
            AddLabelPanel("ixMediumFont")
            AddLabelPanel("ixNoticeFont")
            AddLabelPanel("ixMediumLightFont")
            AddLabelPanel("ixMediumLightBlurFont")
            AddLabelPanel("ixGenericFont")
            AddLabelPanel("ixChatFont")
            AddLabelPanel("ixChatFontItalics")
            AddLabelPanel("ixSmallTitleFont")
            AddLabelPanel("ixMinimalTitleFont")
            AddLabelPanel("ixSmallFont")
            AddLabelPanel("ixItemDescFont")
            AddLabelPanel("ixSmallBoldFont")
            AddLabelPanel("ixItemBoldFont")
            AddLabelPanel("ixIntroTitleFont")
            AddLabelPanel("ixIntroTitleBlurFont")
            AddLabelPanel("ixIntroSubtitleFont")
            AddLabelPanel("ixIntroSmallFont")
            AddLabelPanel("ixIconsSmall")
            AddLabelPanel("ixSmallTitleIcons")
            AddLabelPanel("ixIconsMedium")
            AddLabelPanel("ixIconsMenuButton")
            AddLabelPanel("ixIconsBig")
        end
    end)
    
end