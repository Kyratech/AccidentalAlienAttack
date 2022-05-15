PlayerShieldConsts = {
	clrIndex = 0
}

function CreatePlayerShield()
	return {
		x = 0,
		y = Player.y - 7,
		active = false,
		deactivating = false,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerShieldAni.sprites[1]
		},
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x,
					self.y,
					PlayerShieldConsts.clrIndex,
					1,
					0,
					0,
					2,
					2
				)
			end
		end,
		update = function (self)
			self.x = Player.x - 3

			if self.active == true then
				if self.deactivating == true then
					AnimateOneshot(self, PlayerShieldEndAni)
				else
					Animate(self, PlayerShieldAni)
				end
			end
		end,
		enable = function (self)
			self.active = true
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerShieldAni.sprites[1]
		end,
		startDeactivation = function (self)
			self.deactivating = true
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerShieldEndAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.deactivating = false
		end
	}
end
