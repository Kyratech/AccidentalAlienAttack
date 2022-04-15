function ScrollOptionsH(self)
	if btnp(BtnLeft) then
		self.selectedOption = self.selectedOption - 1

		if self.selectedOption == 0 then
			self.selectedOption = self.optionsCount
		end
	end

	if btnp(BtnRight) then
		self.selectedOption = self.selectedOption + 1

		if self.selectedOption > self.optionsCount then
			self.selectedOption = 1
		end
	end

	if btnp(BtnA) then
		for i = 1, OptionsMenuOptionsCount do
			OptionsMenuOptions[i]:save()
		end
		OptionsMenuOpen = false
	end

	if btnp(BtnB) then
		OptionsMenuOpen = false
	end
end

MainMenuOptionsCount = 3
MainMenuOptions = {
	{
		draw = function(self, x, y)
			print("Start", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
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
			print("How to play", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
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

OptionsMenuOptionsCount = 6
OptionsMenuOptions = {
	{
		options = {
			{
				label = "TIC-80",
				value = "tic"
			},
			{
				label = "QWERTY",
				value = "pc"
			}
		},
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
			local currentValue = GameSettings.buttonPrompts

			for i = 1, self.optionsCount do
				if self.options[i].value == currentValue then
					self.selectedOption = i
				end
			end
		end,
		save = function (self)
			GameSettings.buttonPrompts = self.options[self.selectedOption].value
		end
	},
	{
		options = {
			{
				label = ".00",
				value = 0
			},
			{
				label = ".25",
				value = 0.25
			},
			{
				label = ".50",
				value = 0.5
			},
			{
				label = "1.0",
				value = 1
			},
		},
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
			local currentValue = GameSettings.baseAlienSpeed

			for i = 1, self.optionsCount do
				if self.options[i].value == currentValue then
					self.selectedOption = i
				end
			end
		end,
		save = function (self)
			GameSettings.baseAlienSpeed = self.options[self.selectedOption].value
		end
	},
	{
		options = {
			{
				label = ".25",
				value = 0.25
			},
			{
				label = ".50",
				value = 0.5
			},
			{
				label = "1.0",
				value = 1
			}
		},
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
			local currentValue = GameSettings.baseAlienCarrierSpeed

			for i = 1, self.optionsCount do
				if self.options[i].value == currentValue then
					self.selectedOption = i
				end
			end
		end,
		save = function (self)
			GameSettings.baseAlienCarrierSpeed = self.options[self.selectedOption].value
		end
	},
	{
		options = {
			{
				label = ".00",
				value = 0
			},
			{
				label = ".50",
				value = 2
			},
			{
				label = "1.0",
				value = 4
			},
			{
				label = "1.5",
				value = 6
			}
		},
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
			local currentValue = GameSettings.activeAlienShots

			for i = 1, self.optionsCount do
				if self.options[i].value == currentValue then
					self.selectedOption = i
				end
			end
		end,
		save = function (self)
			GameSettings.activeAlienShots = self.options[self.selectedOption].value
		end
	},
	{
		options = {
			{
				label = ".25",
				value = 0.25
			},
			{
				label = ".50",
				value = 0.5
			},
			{
				label = "1.0",
				value = 1
			},
			{
				label = "2.0",
				value = 2
			}
		},
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
			local currentValue = GameSettings.baseAlienShotSpeed

			for i = 1, self.optionsCount do
				if self.options[i].value == currentValue then
					self.selectedOption = i
				end
			end
		end,
		save = function (self)
			GameSettings.baseAlienShotSpeed = self.options[self.selectedOption].value
		end
	},
	{
		options = {
			{
				label = ".00",
				value = 0
			},
			{
				label = ".50",
				value = 0.5
			},
			{
				label = "1.0",
				value = 1
			},
			{
				label = "2.0",
				value = 2
			}
		},
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
			local currentValue = GameSettings.baseAlienDescentRate

			for i = 1, self.optionsCount do
				if self.options[i].value == currentValue then
					self.selectedOption = i
				end
			end
		end,
		save = function (self)
			GameSettings.baseAlienDescentRate = self.options[self.selectedOption].value
		end
	}
}
OptionsMenuConsts = {
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
			end

			if btnp(BtnDown) then
				self.selectedOption = self.selectedOption + 1

				if self.selectedOption > menuOptionsCount then
					self.selectedOption = 1
				end
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