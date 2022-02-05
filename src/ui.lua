PowerupIcons = {
	none = 0,
	scoreMultiplier = 94,
	shield = 95,
	timestop = 110
}

CreatePowerupUi = function()
	return {
		x = 1,
		y = 98,
		currentIcon = PowerupIcons.none,
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
			spr(
				self.currentIcon,
				self.x + 4,
				self.y + 4,
				0
			)
		end,
		setIcon = function(self, spriteIndex)
			self.currentIcon = spriteIndex
		end
	}
end