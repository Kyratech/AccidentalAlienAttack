function ScrollOptionsH(self)
	if btnp(BtnLeft) then
		sfx(soundEffects.uiDing)
		self.selectedOption = self.selectedOption - 1

		if self.selectedOption == 0 then
			self.selectedOption = self.optionsCount
		end
	end

	if btnp(BtnRight) then
		sfx(soundEffects.uiDing)
		self.selectedOption = self.selectedOption + 1

		if self.selectedOption > self.optionsCount then
			self.selectedOption = 1
		end
	end

	if btnp(BtnA) then
		sfx(soundEffects.uiConfirm)
		for i = 1, OptionsMenuOptionsCount do
			OptionsMenuOptions[i]:save()
			SaveGameSettings()
		end
		OptionsMenuOpen = false
	end

	if btnp(BtnB) then
		OptionsMenuOpen = false
	end
end

MainMenuOptionsCount = 4
MainMenuOptions = {
	{
		draw = function(self, x, y)
			print("Start", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				GameState = StateDialogue
				DialogueInit(
					ScriptIntro,
					3,
					function()
						GameState = StatePlaying
						StartGame()
					end)
			end
		end
	},
	{
		draw = function(self, x, y)
			print("High scores", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				HighScoresScreen()
			end
		end
	},
	{
		draw = function(self, x, y)
			print("How to play", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				InstructionsScreen()
			end
		end
	},
	{
		draw = function(self, x, y)
			print("Options", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				OptionsMenuOpen = true
				OptionsMenu:getCurrent()
			end
		end
	}
}
MainMenuConsts = {
	arrowHOffset = 10,
	lineHeight = 12
}

OptionsMenuOptionsCount = 7
OptionsMenuOptions = {
	{
		options = ButtonPromptsOptions,
		optionsCount = 2,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Button prompts", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 40 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.buttonPrompts
		end,
		save = function (self)
			GameSettings.buttonPrompts = self.selectedOption
		end
	},
	{
		options = ShowBackgroundsOptions,
		optionsCount = 2,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Show backgrounds", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 40 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.showBackgrounds
		end,
		save = function (self)
			GameSettings.showBackgrounds = self.selectedOption
		end
	},
	{
		options = AlienSpeedOptions,
		optionsCount = 4,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Alien speed", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 20 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.alienSpeed
		end,
		save = function (self)
			GameSettings.alienSpeed = self.selectedOption
		end
	},
	{
		options = CarrierSpeedOptions,
		optionsCount = 3,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Carrier speed", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 20 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.alienCarrierSpeed
		end,
		save = function (self)
			GameSettings.alienCarrierSpeed = self.selectedOption
		end
	},
	{
		options = AlienAttackRateOptions,
		optionsCount = 4,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Alien attack rate", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 20 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.alienAttackRate
		end,
		save = function (self)
			GameSettings.alienAttackRate = self.selectedOption
		end
	},
	{
		options = AlienShotSpeedOptions,
		optionsCount = 4,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Alien shot speed", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 20 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.alienShotSpeed
		end,
		save = function (self)
			GameSettings.alienShotSpeed = self.selectedOption
		end
	},
	{
		options = AlienDescentRateOptions,
		optionsCount = 4,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Alien descent rate", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 20 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.alienDescentRate
		end,
		save = function (self)
			GameSettings.alienDescentRate = self.selectedOption
		end
	}
}
OptionsMenuConsts = {
	arrowHOffset = 10,
	lineHeight = 12
}

PauseMenuOptionsCount = 2
PauseMenuOptions = {
	{
		draw = function(self, x, y)
			print("Resume", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
				sfx(soundEffects.uiUnpause)
				Paused = false
			end
		end
	},
	{
		draw = function(self, x, y)
			print("Return to title", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				TitleScreen()
			end
		end
	}
}
PauseMenuConsts = {
	arrowHOffset = 10,
	lineHeight = 12
}

function CreateMenu(menuOptions, menuOptionsCount, menuConsts, x, y)
	return {
		x = x,
		y = y,
		options = menuOptions,
		selectedOption = 1,
		draw = function (self)
			for i = 1, menuOptionsCount do
				self.options[i]:draw(
					self.x + menuConsts.arrowHOffset,
					self.y + menuConsts.lineHeight * (i - 1))
			end

			local additionalArrowOffset = 0
			if time() % 500 > 250 then
				additionalArrowOffset = -1
			end

			spr(
				10,
				self.x + additionalArrowOffset,
				self.y + menuConsts.lineHeight * (self.selectedOption - 1) - 2,
				0)
		end,
		input = function (self)
			if btnp(BtnUp) then
				self.selectedOption = self.selectedOption - 1

				if self.selectedOption == 0 then
					self.selectedOption = menuOptionsCount
				end

				sfx(soundEffects.uiDing)
			end

			if btnp(BtnDown) then
				self.selectedOption = self.selectedOption + 1

				if self.selectedOption > menuOptionsCount then
					self.selectedOption = 1
				end

				sfx(soundEffects.uiDing)
			end

			self.options[self.selectedOption]:input()
		end,
		getCurrent = function (self)
			for i = 1, menuOptionsCount do
				self.options[i]:getCurrent()
			end
		end
	}
end