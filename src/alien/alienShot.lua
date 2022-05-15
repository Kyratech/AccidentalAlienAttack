AlienShotConsts = {
	speed = 0.5,
	storeX = 300,
	storeY = 0,
	clrIndex = 0
}

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
					Player:die(false)
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