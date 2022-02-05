-- Each subsequent powerup should have a higher score
PowerupFrequency = {
	shield = 4,
	extraLife = 5
}
MaxFrequencyScore = 5

ActivateRandomPowerup = function(x, y)
	local powerupIndex = math.random(MaxFrequencyScore)
	DrawDebug(powerupIndex)
	if powerupIndex <= PowerupFrequency.shield then
		ShieldPowerup:enable(x, y)
	elseif powerupIndex <= PowerupFrequency.extraLife then
		ExtraLifePowerup:enable(x, y)
	end
end

PowerupConsts = {
	width = 1,
	height = 1,
	acceleration = 0.2,
	maxSpeed = 2,
	bounces = 1,
	lifetime = 180,
	lifetimeFlash = 60,
	clrIndex = 0
}

CreateExtraLifePowerup = function ()
	return {
		x = -20,
		y = -20,
		w = PowerupConsts.width * TilePx,
		h = PowerupConsts.height * TilePx,
		active = false,
		speed = 0,
		bounces = 0,
		countdown = 0,
		update = function (self)
			if self.active == true then
				if self.y + self.h ~= GroundY and self.speed <= PowerupConsts.maxSpeed then
					self.speed = self.speed + PowerupConsts.acceleration
				end

				self.countdown = self.countdown - 1
				
				if self.countdown <= 0 then
					self:disable()
				end

				self.y = self.y + self.speed
			end
		end,
		draw = function (self)
			if self.active == true then
				if self.countdown > PowerupConsts.lifetimeFlash or self.countdown % 4 < 2 then
					spr(
						256,
						self.x,
						self.y,
						PowerupConsts.clrIndex
					)
				end
			end
		end,
		checkCollision = function (self)
			if self.y + self.h >= GroundY then
				if self.bounces < PowerupConsts.bounces then
					self.speed = -self.speed
					self.bounces = self.bounces + 1
				else
					self.speed = 0
				end

				self.y = GroundY - self.h
			end

			if Collide(self, Player) then
				Lives = Lives + 1
				self:disable()
			end
		end,
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.speed = 0
			self.bounces = 0
			self.countdown = PowerupConsts.lifetime
		end,
		disable = function (self)
			self.active = false
			self.x = -20
			self.y = -20
			self.speed = 0
		end
	}
end

CreateShieldPowerup = function ()
	return {
		x = -20,
		y = -20,
		w = PowerupConsts.width * TilePx,
		h = PowerupConsts.height * TilePx,
		active = false,
		speed = 0,
		bounces = 0,
		countdown = 0,
		update = function (self)
			if self.active == true then
				if self.y + self.h ~= GroundY and self.speed <= PowerupConsts.maxSpeed then
					self.speed = self.speed + PowerupConsts.acceleration
				end

				self.countdown = self.countdown - 1
				
				if self.countdown <= 0 then
					self:disable()
				end

				self.y = self.y + self.speed
			end
		end,
		draw = function (self)
			if self.active == true then
				if self.countdown > PowerupConsts.lifetimeFlash or self.countdown % 4 < 2 then
					spr(
						258,
						self.x,
						self.y,
						PowerupConsts.clrIndex
					)
				end
			end
		end,
		checkCollision = function (self)
			if self.y + self.h >= GroundY then
				if self.bounces < PowerupConsts.bounces then
					self.speed = -self.speed
					self.bounces = self.bounces + 1
				else
					self.speed = 0
				end

				self.y = GroundY - self.h
			end

			if Collide(self, Player) then
				Player:activateShield(PlayerConsts.powerupShieldLength)
				self:disable()
			end
		end,
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.speed = 0
			self.bounces = 0
			self.countdown = PowerupConsts.lifetime
		end,
		disable = function (self)
			self.active = false
			self.x = -20
			self.y = -20
			self.speed = 0
		end
	}
end