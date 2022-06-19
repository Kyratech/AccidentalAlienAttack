-- I'm using compass directions as a shorthand even though north isnt actually up
PlayerMortarDirections = {
	nw = { x = -0.71, y = -0.71 },
	sw = { x = -0.71, y = 0.71 },
	ssw = { x = -0.38, y = 0.92 },
	s = { x = 0, y = 1 },
	sse = { x = 0.38, y = 0.92 },
	se = { x = 0.71, y = 0.71 },
	ne = { x = 0.71, y = -0.71 }
}

function CreatePlayerMortarFragment(mortarDirection)
	return {
		x = PlayerMissileBurstConsts.storeX,
		y = PlayerMissileBurstConsts.storeY,
		w = 4,
		h = 4,
		direction = mortarDirection,
		speedX = 0,
		speedY = 0,
		sprite = PlayerMortarFragmentAni.sprites[1],
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.speedX = self.direction.x
			self.speedY = self.direction.y
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
					self.sprite,
					self.x - 2,
					self.y - 2,
					ExplosionConsts.clrIndex)
			end
		end,
		update = function (self)
			self.x = self.x + self.speedX
			self.y = self.y + self.speedY
		end,
		checkCollision = function (self)
			-- Check aliens
			CollideWithAliens(self, function (self, alien)
				self:disable()
				sfx(soundEffects.explosionStandard)
			end)

			if Collide(self, AlienCarrier) then
				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()
				self:disable()

				sfx(soundEffects.explosionBigAlt)

				Score = Score + 5
			end

			if self.y > GroundY then
				self:disable()
			end
		end
	}
end