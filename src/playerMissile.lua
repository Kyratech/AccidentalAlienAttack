PlayerMissileConsts = {
	speed = 2,
	storeX = 320,
	storeY = 150,
	clrIndex = 0
}

PlayerMissileBurstConsts = {
	speed = 4,
	storeX = 340,
	storeY = 150,
	clrIndex = 0
}

function CreatePlayerMissile()
	return {
		x = PlayerMissileConsts.storeX,
		y = PlayerMissileConsts.storeY,
		w = 2,
		h = 8,
		speed = 0,
		type = PlayerWeapons.none,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerMissileAni.sprites[1]
		},
		draw = function (self)
			if self.speed > 0 then
				spr(
					self.ani.currentFrame,
					self.x - 3,
					self.y,
					PlayerMissileConsts.clrIndex)

				PlayerMissileExhaust:draw()
			end
		end,
		update = function (self)
			self.y = self.y - self.speed

			if self.speed > 0 then
				Animate(self, PlayerMissileAni)

				PlayerMissileExhaust:update(self.x, self.y + 8)
			end
		end,
		checkCollision = function (self)
			-- Check off top of screen
			if self.y < 0 then
				self:reset()
			end

			-- Check aliens
			for i, alien in pairs(Aliens) do
				if Collide(self, Aliens[i]) then
					local alienY = Aliens[i].y;

					KillAlien(i)

					ScorePoints(1)

					self:createBursts(alienY)
					self:reset()
				end
			end

			if Collide(self, AlienCarrier) then
				local alienY = AlienCarrier.y;

				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				ScorePoints(5)

				self:createBursts(alienY)
				self:reset()
			end
		end,
		shoot = function (self)
			if self.speed == 0 then
				self.x = Player.x + 4
				self.y = Player.y
				self.speed = PlayerMissileConsts.speed
				self.type = Player.weaponType
				Player.weaponType = PlayerWeapons.none
				Player.weaponPower = 0
			end
		end,
		reset = function (self)
			self.x = PlayerMissileConsts.storeX
			self.y = PlayerMissileConsts.storeY
			self.speed = 0

			PlayerMissileExhaust:update(self.x, self.y + 8)
		end,
		createBursts = function (self, alienY)
			if self.type == PlayerWeapons.vertical then
				PlayerMissileBurstLeft:enable(self.x - 3, alienY, 0, -2)
			elseif self.type == PlayerWeapons.horizontal then
				PlayerMissileBurstLeft:enable(self.x - 3, alienY, -2, 0)
				PlayerMissileBurstRight:enable(self.x - 3, alienY, 2, 0)
			elseif self.type == PlayerWeapons.diagonal then
				PlayerMissileBurstLeft:enable(self.x - 3, alienY, -1.4, -1.4)
				PlayerMissileBurstRight:enable(self.x - 3, alienY, 1.4, -1.4)
			end
		end
	}
end

function CreatePlayerMissileExhaust()
	return {
		x = PlayerMissileConsts.storeX,
		y = PlayerMissileConsts.storeY,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerMissileExhaustAni.sprites[1]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.x - 3,
				self.y,
				PlayerMissileConsts.clrIndex)
		end,
		update = function (self, x, y)
			self.x = x
			self.y = y

			Animate(self, PlayerMissileExhaustAni)
		end
	}
end

function CreatePlayerMissileBurst()
	return {
		x = PlayerMissileBurstConsts.storeX,
		y = PlayerMissileBurstConsts.storeY,
		w = 8,
		h = 8,
		speedX = 0,
		speedY = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerMissileBurstAni.sprites[1]
		},
		enable = function (self, x, y, speedX, speedY)
			self.active = true
			self.x = x
			self.y = y
			self.speedX = speedX
			self.speedY = speedY
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerMissileBurstAni.sprites[1]
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
				AnimateOneshot(self, PlayerMissileBurstAni)
			end
		end,
		checkCollision = function (self)
			-- Check aliens
			for i, alien in pairs(Aliens) do
				if Collide(self, Aliens[i]) then
					KillAlien(i)

					if Player.status == PlayerStatuses.scoreMultiplier then
						Score = Score + 2
					else
						Score = Score + 1
					end
				end
			end

			if Collide(self, AlienCarrier) then
				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				Score = Score + 5
			end
		end
	}
end