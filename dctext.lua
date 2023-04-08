local PLUGIN = PLUGIN
PLUGIN.name = "Disconnect Text"
PLUGIN.author = "Lechu2375"



ix.command.Add("AddTimedText", {
	description = "Adds floating text on your position",
	arguments = {ix.type.number,ix.type.text},
    adminOnly = true,
	OnRun = function(self, client, lifeTime, text)
        net.Start("ixTimedText")
        net.WriteVector(client:GetPos()+Vector(0,0,50))
        net.WriteString(text)
        net.WriteUInt(math.Clamp( lifeTime, 1, 1023 ), 10)
        net.Broadcast()
	end
})



if(SERVER) then

    util.AddNetworkString("ixTimedText")

    function PLUGIN:OnCharacterDisconnect(client)  //preparing net msg
        net.Start("ixTimedText")
        net.WriteVector(client:GetPos()+Vector(0,0,50))
        net.WriteString(client:GetName().." has left the server")
        net.WriteUInt(50, 10)
        net.Broadcast()
    end

end

if(CLIENT) then

    PLUGIN.DeathTexts = {}

    function AddTimedText(position,text,lifetime)
        PLUGIN.DeathTexts[position.x] = {position = position,text=text or "No text",lifetime = lifetime or 10} 
        timer.Simple(lifetime or 10, function()
            PLUGIN.DeathTexts[position.x] = nil
        end)
    end

    net.Receive("ixTimedText", function(len) //we got something new, adding text
        AddTimedText(net.ReadVector(),net.ReadString(),net.ReadUInt(10))
    end)
    

    local angle
    function PLUGIN:PostDrawTranslucentRenderables() 

        angle = EyeAngles()
        angle = Angle( 0, angle.y, 0 )
        angle.y = angle.y + math.sin( CurTime() ) 
        angle:RotateAroundAxis( angle:Up(), -90 )
        angle:RotateAroundAxis( angle:Forward(), 90 )
        
        for _, v in pairs(PLUGIN.DeathTexts) do
            cam.Start3D2D( v.position , angle, .1 )
                draw.SimpleText( v.text, "ix3D2DFont", 0, 0, color_white ) //if you want change font here
            cam.End3D2D()
        end
    end


end