PowerupIcons = {
	none = 0,
	scoreMultiplier = 94,
	shield = 95,
	timestop = 110
}

WeaponColours = {
	none = 0,
	vertical = 6,
	horizontal = 2,
	diagonal = 9,
	block = 13
}

WeaponIconsSpriteIndexes = {
	none = 0,
	vertical = 124,
	horizontal = 125,
	diagonal = 140,
	block = 141
}

ButtonIcons = {
	A = {
		tic = 12,
		pc = 250
	},
	B = {
		tic = 13,
		pc = 251
	},
	X = {
		tic = 14,
		pc = 252
	},
	Y = {
		tic = 15,
		pc = 253
	},
	arrow = {
		tic = 11,
		pc = 11
	}
}

function DrawButtonPrompt(buttonSpr, str, x, y)
	spr(buttonSpr[ButtonPromptsOptions[GameSettings.buttonPrompts].value], x, y, 0)
	print(": " .. str, x + 10, y + 2, 12)
end

CreateHeaderUi = function()
	return {
		y = 1,
		draw = function(self)
			spr(208, 1, self.y, 0, 1, 0, 0, 2, 1)
			PrintCustom("LIVES", 16, self.y)
			spr(210, 41, self.y, 0)
			print(Lives, 44, self.y + 1, 12)

			spr(208, ScreenWidth - 17, self.y, 0, 1, 1, 0, 2, 1)
			PrintCustomRightAligned("SCORE", ScreenWidth - 15, self.y)
			spr(210, ScreenWidth - 42, self.y, 0)
			PrintRightAligned(Score, ScreenWidth - 43, self.y + 1, 12)
		end
	}
end

CreatePowerupUi = function()
	return {
		x = 223,
		y = 98,
		currentIcon = PowerupIcons.none,
		flashing = false,
		draw = function(self)
			PrintCustom("PWR", self.x + 1, self.y - 8)

			spr(
				62,
				self.x,
				self.y,
				-1,
				1,
				0,
				0,
				2,
				2)

			if not self.flashing or time()%250>125 then
				spr(
					self.currentIcon,
					self.x + 4,
					self.y + 4,
					0
				)
			end
		end,
		setIcon = function(self, spriteIndex)
			self.currentIcon = spriteIndex
		end,
		setFlashing = function(self, isFlashing)
			self.flashing = isFlashing
		end
	}
end

CreateSpecialWeaponUi = function()
	return {
		x = 223,
		y = 42,
		draw = function(self)
			PrintCustom("SPW", self.x + 1, self.y - 8)

			spr(
				60,
				self.x,
				self.y,
				0,
				1,
				0,
				0,
				2,
				2
			)

			spr(
				92,
				self.x,
				self.y + 16,
				0,
				1,
				0,
				0,
				2,
				2
			)

			spr(
				62,
				self.x,
				self.y + 30,
				-1,
				1,
				0,
				0,
				2,
				2)

			if (Player.weaponPower > 0) then
				for i=1, Player.weaponPower do
					self:drawBlock(i)
				end

				if (Player.weaponPower == 4) then
					spr(
						WeaponIconsSpriteIndexes[Player.weaponType],
						self.x + 4,
						self.y + 35,
						0
					)
				end
			end
		end,
		drawBlock = function(self, i)
			local rectX = self.x + 2
			local rectY = self.y - 2 + i * 6
			rect(
				rectX,
				rectY,
				12,
				5,
				WeaponColours[Player.weaponType]
			)
		end
	}
end

CreateLevelUi = function()
	return {
		x = 1,
		y = 72,
		draw = function(self)
			-- Stage
			PrintCustom("ZNE", self.x + 1, self.y - 8)

			spr(
				62,
				self.x,
				self.y,
				-1,
				1,
				0,
				0,
				2,
				2)

			print(string.format("%02d", CurrentStage), self.x + 3, self.y + 6, 12)

			-- Level
			PrintCustom("WAV", self.x + 1, self.y + 18)

			spr(
				62,
				self.x,
				self.y + 26,
				-1,
				1,
				0,
				0,
				2,
				2)

			print(string.format("%02d", CurrentLevel), self.x + 3, self.y + 32, 12)
		end
	}
end