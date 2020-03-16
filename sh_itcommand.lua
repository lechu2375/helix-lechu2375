PLUGIN.name = "IT color"
PLUGIN.desc = "New color and  syntax  for /it command"
PLUGIN.license =  "MIT not for use on Kaktusownia opensource.org/licenses/MIT"

function PLUGIN:InitializedChatClasses()
	timer.Simple(.1, function()
		ix.chat.Register("it", {
			OnChatAdd = function(self, speaker, text)
						
				chat.AddText(Color(142, 68, 173), "(("..speaker:GetName().."))".."** "..text)
			end,
			CanHear = ix.config.Get("chatRange", 280) * 2,
			prefix = {"/It","/Do"},
			description = "@cmdIt",
			indicator = "chatPerforming",
			deadCanChat = true
		})
	end)
end
