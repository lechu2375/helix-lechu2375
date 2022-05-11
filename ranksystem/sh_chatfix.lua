
function PLUGIN:InitializedChatClasses()

		ix.chat.Register("ooc", {
			CanSay = function(self, speaker, text)
				if (!ix.config.Get("allowGlobalOOC")) then
					speaker:NotifyLocalized("Global OOC is disabled on this server.")
					return false
				else
					local delay = ix.config.Get("oocDelay", 10)

					-- Only need to check the time if they have spoken in OOC chat before.
					if (delay > 0 and speaker.ixLastOOC) then
						local lastOOC = CurTime() - speaker.ixLastOOC

						-- Use this method of checking time in case the oocDelay config changes.
						if (lastOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
							speaker:NotifyLocalized("oocDelay", delay - math.ceil(lastOOC))

							return false
						end
					end

					-- Save the last time they spoke in OOC.
					speaker.ixLastOOC = CurTime()
				end
			end,
			OnChatAdd = function(self, speaker, text)
                self.format = self.format or "[OOC] %s: \"%s\""
				-- @todo remove and fix actual cause of speaker being nil
				if (!IsValid(speaker)) then
					return
				end
                			local name = hook.Run("GetCharacterName", speaker, chatType) or
				(IsValid(speaker) and speaker:Name() or "Console")

				local icon = "icon16/user.png"

				if (speaker:IsSuperAdmin()) then
					icon = "icon16/shield.png"
				elseif (speaker:IsAdmin()) then
					icon = "icon16/star.png"
				elseif (speaker:IsUserGroup("moderator") or speaker:IsUserGroup("operator")) then
					icon = "icon16/wrench.png"
				elseif (speaker:IsUserGroup("vip") or speaker:IsUserGroup("donator") or speaker:IsUserGroup("donor")) then
					icon = "icon16/heart.png"
				end

				icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

                chat.AddText(icon,Color(255, 50, 50),string.format(self.format, name, text))


			end,
			prefix = {"//", "/OOC"},
			description = "@cmdOOC",
			noSpaceAfter = true
		})

ix.chat.Register("looc", {
			CanSay = function(self, speaker, text)
				local delay = ix.config.Get("loocDelay", 0)

				-- Only need to check the time if they have spoken in OOC chat before.
				if (delay > 0 and speaker.ixLastLOOC) then
					local lastLOOC = CurTime() - speaker.ixLastLOOC

					-- Use this method of checking time in case the oocDelay config changes.
					if (lastLOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
						speaker:NotifyLocalized("loocDelay", delay - math.ceil(lastLOOC))

						return false
					end
				end

				-- Save the last time they spoke in OOC.
				speaker.ixLastLOOC = CurTime()
			end,
			OnChatAdd = function(self, speaker, text)
			local name = hook.Run("GetCharacterName", speaker, chatType) or
				(IsValid(speaker) and speaker:Name() or "Console")

				chat.AddText(Color(255, 50, 50), "[LOOC] ", ix.config.Get("chatColor"), name..": "..text)
			end,
			CanHear = ix.config.Get("chatRange", 280),
			prefix = {".//", "[[", "/LOOC"},
			description = "@cmdLOOC",
			noSpaceAfter = true
		})

	do
		local COMMAND = {}
		COMMAND.arguments = ix.type.text

		function COMMAND:OnRun(client, message)
			if (!client:IsRestricted()) then
				ix.chat.Send(client, "broadcast", message)
			else
				return "@notNow"
			end
		end

		ix.command.Add("Broadcast", COMMAND)
	end

	do
		local CLASS = {}
		CLASS.color = Color(150, 125, 175)
		CLASS.format = "%s broadcasts \"%s\""

		function CLASS:CanSay(speaker, text)
			return true
		end

		function CLASS:OnChatAdd(speaker, text)
						local name = hook.Run("GetCharacterName", speaker, chatType) or
				(IsValid(speaker) and speaker:Name() or "Console")
			chat.AddText(self.color, string.format(self.format, name, text))
		end

		ix.chat.Register("broadcast", CLASS)
	end

end

