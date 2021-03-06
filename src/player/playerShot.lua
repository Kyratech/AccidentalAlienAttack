PlayerShotConsts = {
	speed = 2,
	storeX = 300,
	storeY = 150,
	clrIndex = 0
}

function CreatePlayerShot()
	return {
		x = PlayerShotConsts.storeX,
		y = PlayerShotConsts.storeY,
		w = 2,
		h = 8,
		speed = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerShotAni.sprites[1]
		},
		draw = function (self)
			if PlayerShot.speed > 0 then
				spr(
					self.ani.currentFrame,
					self.x - 3,
					self.y,
					PlayerShotConsts.clrIndex)
			end
		end,
		update = function (self)
			self.y = self.y - self.speed

			if self.speed > 0 then
				Animate(self, PlayerShotAni)
			end
		end,
		checkCollision = function (self)
			-- Check off top of screen
			if self.y < 0 then
				PlayerShot:reset()
			end

			CollideWithAliens(self, function (self, alien)
				Explosion:enable(alien.x, alien.y)

				sfx(soundEffects.explosionStandard)

				PlayerShot:reset()
			end)

			if Collide(self, AlienCarrier) then
				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				ScorePoints(5)

				sfx(soundEffects.explosionBigAlt)

				PlayerShot:reset()
			end

			if Collide(self, SpecialWeaponBlock) then
				SpecialWeaponBlock:takeDamage(1)
				SpecialWeaponBlock:shove()
				PlayerShot:reset()
			end
		end,
		shoot = function (self)
			if self.speed == 0 then
				self.x = Player.x + 4
				self.y = Player.y
				self.speed = PlayerShotConsts.speed

				sfx(soundEffects.laser)

				AliensDodge()
			end
		end,
		reset = function (self)
			self.x = PlayerShotConsts.storeX
			self.y = PlayerShotConsts.storeY
			self.speed = 0
		end
	}
end