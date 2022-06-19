function CreateSpecialWeaponBubble()
	return {
		x = PlayerMissileBurstConsts.storeX,
		y = PlayerMissileBurstConsts.storeY,
		w = 8,
		h = 8,
		speedX = 0,
		speedY = 0,
		counter = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = SpecialWeaponBubbleAni.sprites[1]
		},
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.speedX = 0
			self.speedY = -0.05
			self.counter = 120

			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = SpecialWeaponBubbleAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.x = ExplosionConsts.storeX
			self.y = ExplosionConsts.storeY
			self.speedX = 0
			self.speedY = 0
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
			self.x = self.x + self.speedX
			self.y = self.y + self.speedY

			if self.active == true then
				self.counter = self.counter - 1

				if self.counter == 3 then
					self.ani.delayCounter = 0
					self.ani.currentCounter = 1
					self.ani.currentFrame = SpecialWeaponBubblePopAni.sprites[1]
				elseif self.counter < 3 then
					AnimateOneshot(self, SpecialWeaponBubblePopAni)
				else
					Animate(self, SpecialWeaponBubbleAni)
				end
			end
		end,
		checkCollision = function (self)
			-- Check aliens
			CollideWithAliens(self, function (self, alien)
				sfx(soundEffects.explosionEnergy)
			end)

			if Collide(self, AlienCarrier) then
				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				sfx(soundEffects.explosionEnergy)

				ScorePoints(5)
			end
		end
	}
end