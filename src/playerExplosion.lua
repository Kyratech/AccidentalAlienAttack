PlayerExplosionConsts = {
	storeX = 316,
	storeY = 150,
	clrIndex = 0
}

function CreatePlayerExplosion()
	return {
		active = false,
		x = PlayerExplosionConsts.storeX,
		y = PlayerExplosionConsts.storeY,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerExplosionAni.sprites[1]
		},
		enable = function (self, x, y)
			self.active = true
			self.x = x - 3
			self.y = y - 7
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerExplosionAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.x = PlayerExplosionConsts.storeX
			self.y = PlayerExplosionConsts.storeY
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x,
					self.y,
					PlayerExplosionConsts.clrIndex,
					1,
					0,
					0,
					2,
					2)
			end
		end,
		update = function (self)
			if self.active == true then
				AnimateOneshot(self, PlayerExplosionAni)
			end
		end
	}
end