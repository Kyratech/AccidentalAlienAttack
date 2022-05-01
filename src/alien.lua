AlienConsts = {
	width = 1,
	height = 1
}

AlienSpeeds = {
	speedFull = 0.125,
	speedHalf = 0.25,
	speedQuarter = 0.5,
	speedFour = 1,
	speedOne = 2
}

AlienShotConsts = {
	speed = 0.5,
	storeX = 300,
	storeY = 0,
	clrIndex = 0
}

AlienFactory = {
	function(i, j)
		return CreateAlienBase(i, j, AlienRedAni, PlayerWeapons.horizontal, StandardDieFunction)
	end,
	function(i, j)
		return CreateAlienBase(i, j, AlienBlueAni, PlayerWeapons.diagonal, StandardDieFunction)
	end,
	function(i, j)
		return CreateAlienBase(i, j, AlienGreenAni, PlayerWeapons.vertical, StandardDieFunction)
	end,
	function(i, j)
		return CreateShieldAlien(i, j)
	end,
	function(i, j)
		return CreateDiveAlien(i, j)
	end,
	function (i, j)
		return CreateBombAlien(i, j)
	end,
	function (i, j)
		return CreateDodgeAlien(i, j)
	end,
	function (i, j)
		return CreateSupportAlien(i, j)
	end
}

function CreateAlien(i, j, type)
	return AlienFactory[type](i, j)
end

function StandardDieFunction(self, formationPosition)
	Explosion:enable(self.x, self.y)
	Player:getWeaponPower(self.specialWeapon)

	AlienRemove(formationPosition)
end

function CreateAlienBase(i, j, animation, specialWeapon, dieFunction)
	return {
		x = LeftWallX + 10 + (i - 1) * 16,
		y = -50 + (j - 1) * 10,
		w = AlienConsts.width * TilePx,
		h = AlienConsts.height * TilePx,
		column = i,
		row = j,
		targetY = 20 + (j - 1) * 10,
		hitWall = false,
		specialWeapon = specialWeapon,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = animation.sprites[1]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.x,
				self.y,
				animation.clrIndex)
		end,
		update = function (self)
			self.targetY = 20 + AlienGlobalRowsStepped * 10 * AlienDescentRateOptions[GameSettings.alienDescentRate].value + (self.row - 1) * 10

			if self.y > self.targetY then
				self.y = self.y - 1
			elseif self.y < self.targetY then
				self.y = self.y + 1
			elseif Player.status ~= PlayerStatuses.timestop then
				self.x = self.x + AlienGlobalVelocity
				self.hitWall = false
			end

			Animate(self, animation)
		end,
		checkCollision = function (self, i)
			if self.y + self.h >= GroundY then
				if Player.active == true and Player.status ~= PlayerStatuses.shield then
					Player:die()
				end
			elseif self.x + self.w > RightWallX then
				if self.hitWall == false then
					NewAlienGlobalRowsStepped = AlienGlobalRowsStepped + 1
					self.hitWall = true
				end
				NewAlienGlobalVelocity = -AlienGlobalSpeed
			elseif self.x < LeftWallX then
				if self.hitWall == false then
					NewAlienGlobalRowsStepped = AlienGlobalRowsStepped + 1
					self.hitWall = true
				end
				NewAlienGlobalVelocity = AlienGlobalSpeed
			end
		end,
		die = dieFunction
	}
end

function CreateAlienShot(shotParticle)
	return {
		x = AlienShotConsts.storeX,
		y = AlienShotConsts.storeY,
		w = 4,
		h = 4,
		speed = 0,
		countdown = 60,
		particle = shotParticle,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = AlienShotAni.sprites[1]
		},
		draw = function (self)
			if self.speed > 0 then
				spr(
					self.ani.currentFrame,
					self.x - 2,
					self.y - 2,
					AlienShotConsts.clrIndex)
			end
		end,
		update = function (self)
			if Player.status ~= PlayerStatuses.timestop then
				self.y = self.y + self.speed
			end

			if self.countdown > 0 then
				self.countdown = self.countdown - 1
			else
				self:shoot()
			end

			if self.speed > 0 then
				Animate(self, AlienShotAni)
			end
		end,
		shoot = function (self)
			if (AlienIndexesThatCanShootCount > 0) then
				-- Pick an alien
				local i = math.random(AlienIndexesThatCanShootCount)
				local formationPosition = AlienIndexesThatCanShoot[i]
				
				-- Shoot
				if self.speed == 0 then
					self.x = Aliens[formationPosition].x + 2
					self.y = Aliens[formationPosition].y + 8
					self.speed = AlienShotConsts.speed * AlienShotSpeedOptions[GameSettings.alienShotSpeed].value
				end
			end
		end,
		reset = function (self)
			self.x = AlienShotConsts.storeX
			self.y = AlienShotConsts.storeY
			self.speed = 0
			self.countdown = math.random(0, 180)
		end,
		collision = function (self)
			-- Check bottom of screen
			if self.y + self.h > GroundY then
				self.particle:enable(self.x, self.y)
				self:reset()
			end

			if Collide(self, SpecialWeaponBlock) then
				self.particle:enable(self.x, self.y)
				self:reset()
				SpecialWeaponBlock:takeDamage(1)
			end

			if Collide(self, Player) then
				if Player.active == true and Player.status ~= PlayerStatuses.shield then
					Player:die()
				end
				self:reset()
			end
		end
	}
end

function CreateAlienShotParticles()
	return {
		x = AlienShotConsts.storeX,
		y = AlienShotConsts.storeY,
		active = false,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = AlienShotParticleAni.sprites[1]
		},
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = AlienShotParticleAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.x = AlienShotConsts.storeX
			self.y = AlienShotConsts.storeY
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x - 2,
					self.y - 2,
					AlienShotConsts.clrIndex)
			end
		end,
		update = function (self)
			if self.active == true then
				AnimateOneshot(self, AlienShotParticleAni)
			end
		end
	}
end

function CalculateAlienSpeed(maxAliens, liveAliens)
	if liveAliens == 1 then
		return AlienSpeeds.speedOne * AlienSpeedOptions[GameSettings.alienSpeed].value
	elseif liveAliens <= 4 then
		return AlienSpeeds.speedFour * AlienSpeedOptions[GameSettings.alienSpeed].value
	elseif maxAliens // liveAliens == 1 then
		return AlienSpeeds.speedFull * AlienSpeedOptions[GameSettings.alienSpeed].value
	elseif maxAliens // liveAliens == 2 then
		return AlienSpeeds.speedHalf * AlienSpeedOptions[GameSettings.alienSpeed].value
	else
		return AlienSpeeds.speedQuarter * AlienSpeedOptions[GameSettings.alienSpeed].value
	end
end