ScreenTransitionConsts = {
	speed = 3
}

ScreenTransitionStates = {
	disabled = 0,
	animating = 1,
	complete = 2
}

CreateScreenTransition = function ()
	return {
		leadingPoint = 0,
		state = ScreenTransitionStates.disabled,
		textCountdown = 90,
		playingSound = {
			false,
			false,
			false
		},
		draw = function (self)
			if self.state ~= ScreenTransitionStates.disabled then
				local triangleBackX = self.leadingPoint - HalfScreenHeight

				tri(
					triangleBackX, 0,
					self.leadingPoint, HalfScreenHeight,
					triangleBackX, ScreenHeight,
					0
				)

				if triangleBackX > 0 then
					rect(
						0, 0,
						triangleBackX, ScreenHeight,
						0
					)
				end

				if self.textCountdown < 60 then
					if self.playingSound[1] == false then
						self.playingSound[1] = true
						sfx(soundEffects.uiDing)
					end
					PrintCustomCentred("zone", HalfScreenWidth, HalfScreenHeight - 8)
				end

				if self.textCountdown < 30 then
					if self.playingSound[2] == false then
						self.playingSound[2] = true
						sfx(soundEffects.uiDing)
					end
					PrintCustomCentred("cleared", HalfScreenWidth, HalfScreenHeight)
				end

				if self.textCountdown <= 0 then
					if self.playingSound[3] == false then
						self.playingSound[3] = true
						sfx(soundEffects.uiDing)
					end
					DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
				end
			end
		end,
		update = function (self)
			if self.state == ScreenTransitionStates.animating then
				self.leadingPoint = self.leadingPoint + ScreenTransitionConsts.speed

				if self.leadingPoint >= ScreenWidth + HalfScreenHeight then
					self.state = ScreenTransitionStates.complete
				end
			elseif self.state == ScreenTransitionStates.complete and self.textCountdown > 0 then
				self.textCountdown = self.textCountdown - 1
			end
		end,
		input = function (self)
			if self.state == ScreenTransitionStates.complete and btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				if CurrentStage > NumberOfStages then
					GameOver(ScriptGameOverGood, 3)
				else
					GameState = StateDialogue
					DialogueInit(
						ScriptStageInterludes[CurrentStage - 1],
						ScriptStageInterludesLengths[CurrentStage - 1],
						function()
							GameState = StatePlaying
							StartLevel(Formations[CurrentStage][CurrentLevel])
						end)
					Player:activateStatus(PlayerStatuses.shield, 180)
				end
			end
		end,
		start = function (self)
			self.state = ScreenTransitionStates.animating
			self.playingSound = {
				false,
				false,
				false
			}
		end,
		reset = function (self)
			self.state = ScreenTransitionStates.disabled
			self.leadingPoint = 0
			self.textCountdown = 90
		end
	}
end