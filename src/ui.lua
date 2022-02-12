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
	diagonal = 9
}

WeaponIconsSpriteIndexes = {
	none = 0,
	vertical = 124,
	horizontal = 125,
	diagonal = 140
}

CreatePowerupUi = function()
	return {
		x = 223,
		y = 98,
		currentIcon = PowerupIcons.none,
		flashing = false,
		draw = function(self)
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
		y = 20,
		draw = function(self)
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