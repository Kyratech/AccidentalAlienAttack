ExplosionConsts = {
	storeX = 316,
	storeY = 150,
	clrIndex = 0
}

function CreateExplosion()
	return {
		active = false,
		x = ExplosionConsts.storeX,
		y = ExplosionConsts.storeY,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = ExplosionAni.sprites[1]
		},
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = ExplosionAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.x = ExplosionConsts.storeX
			self.y = ExplosionConsts.storeY
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x,
					self.y,
					ExplosionConsts.clrIndex)
			end
		end,
		update = function (self)
			if self.active == true then
				AnimateOneshot(self, ExplosionAni)
			end
		end
	}
end