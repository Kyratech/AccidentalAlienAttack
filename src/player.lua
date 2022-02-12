PlayerConsts = {
	speed = 1,
	widthPx = 10,
	heightPx = 9,
	sprOffsetX = -3,
	sprOffsetY = -7,
	clrIndex = 12,
	respawnShieldLength = 120,
	powerupShieldLength = 480,
	scoreMultiplierLength = 480,
	timestopLength = 240
}

PlayerShotConsts = {
	speed = 2,
	storeX = 300,
	storeY = 150,
	clrIndex = 0
}

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

PlayerShieldConsts = {
	clrIndex = 0
}

PlayerStatuses = {
	none = 0,
	shield = 1,
	scoreMultiplier = 2,
	timestop = 3
}

PlayerWeapons = {
	none = "none",
	vertical = "vertical",
	horizontal = "horizontal",
	diagonal = "diagonal"
}

function CreatePlayer()
	return {
		x = (240/2)-(PlayerConsts.widthPx*TilePx/2),
		y = 118,
		w = PlayerConsts.widthPx,
		h = PlayerConsts.heightPx,
		active = true,
		speed = 0,
		deathTimer = 0,
		status = PlayerStatuses.none,
		statusTimer = 0,
		weaponType = PlayerWeapons.none,
		weaponPower = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerLeftAni.sprites[1]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.x + PlayerConsts.sprOffsetX,
				self.y + PlayerConsts.sprOffsetY,
				PlayerConsts.clrIndex,
				1,
				0,
				0,
				2,
				2)
		end,
		update = function (self)
			if self.active == true then
				if self.status ~= PlayerStatuses.none then
					self.statusTimer = self.statusTimer - 1

					if self.statusTimer == 70 then
						self:beginEndOfStatus()
					elseif self.statusTimer <= 0 then
						self:endStatus()
					end
				end

				self.x = self.x + self.speed
				if self.speed > 0 then
					Animate(self, PlayerRightAni)
				elseif self.speed < 0 then
					Animate(self, PlayerLeftAni)
				end
			else
				self.deathTimer = self.deathTimer - 1

				Animate(self, PlayerDeadAni)

				if self.deathTimer == 160 then
					PlayerExplosionSecondary:enable(Player.x, Player.y)
				elseif self.deathTimer <= 0 then
					Lives = Lives - 1
					if Lives > 0 then
						self:respawn()
					else
						GameOver()
					end
				end
			end
		end,
		enable = function (self)
			self.active = true
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerLeftAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerDeadAni.sprites[1]
		end,
		respawn = function (self)
			self:activateStatus(PlayerStatuses.shield, PlayerConsts.respawnShieldLength)
			self:enable()
		end,
		die = function (self)
			self.deathTimer = 180
			PlayerExplosionPrimary:enable(Player.x + 1, Player.y)
			PowerupUi:setIcon(PowerupIcons.none)
			self:disable()
		end,
		getWeaponPower = function (self, weapon)
			if (self.weaponType ~= weapon) then
				self.weaponType = weapon
				self.weaponPower = 1
			elseif (self.weaponPower < 4) then
				self.weaponPower = self.weaponPower + 1
			end
		end,
		checkCollision = function (self)
			if self.x < LeftWallX then
				self.x = LeftWallX
			elseif self.x + self.w > RightWallX then
				self.x = RightWallX - self.w
			end
		end,
		activateStatus = function (self, newStatus, duration)
			self.status = newStatus
			self.statusTimer = duration

			if newStatus == PlayerStatuses.shield then
				PlayerShield:enable()
				PowerupUi:setIcon(PowerupIcons.shield)
			elseif newStatus == PlayerStatuses.scoreMultiplier then
				PowerupUi:setIcon(PowerupIcons.scoreMultiplier)
			elseif newStatus == PlayerStatuses.timestop then
				PowerupUi:setIcon(PowerupIcons.timestop)
			end
		end,
		beginEndOfStatus = function (self)
			if self.status == PlayerStatuses.shield then
				PlayerShield:startDeactivation()
			end

			PowerupUi:setFlashing(true)
		end,
		endStatus = function (self)
			if self.status == PlayerStatuses.shield then
				PlayerShield:disable()
			end
			
			self.status = PlayerStatuses.none
			PowerupUi:setIcon(PowerupIcons.none)
			PowerupUi:setFlashing(false)
		end
	}
end

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

			-- Check aliens
			for i, alien in pairs(Aliens) do
				if Collide(self, Aliens[i]) then
					Player:getWeaponPower(Aliens[i].weaponType)
					KillAlien(i)

					if Player.status == PlayerStatuses.scoreMultiplier then
						Score = Score + 2
					else
						Score = Score + 1
					end

					PlayerShot:reset()
				end
			end

			if Collide(self, AlienCarrier) then
				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				Score = Score + 5

				PlayerShot:reset()
			end
		end,
		shoot = function (self)
			if self.speed == 0 then
				self.x = Player.x + 4
				self.y = Player.y
				self.speed = PlayerShotConsts.speed
			end
		end,
		reset = function (self)
			self.x = PlayerShotConsts.storeX
			self.y = PlayerShotConsts.storeY
			self.speed = 0
		end
	}
end

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
					Player:getWeaponPower(Aliens[i].weaponType)
					KillAlien(i)

					if Player.status == PlayerStatuses.scoreMultiplier then
						Score = Score + 2
					else
						Score = Score + 1
					end

					PlayerMissileBurstLeft:enable(self.x - 3, self.y, 0, -4)

					self:reset()
				end
			end

			if Collide(self, AlienCarrier) then
				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				Score = Score + 5

				self:reset()
			end
		end,
		shoot = function (self, weaponPayload)
			if self.speed == 0 then
				self.x = Player.x + 4
				self.y = Player.y
				self.speed = PlayerMissileConsts.speed
				Player.weaponType = PlayerWeapons.none
				Player.weaponPower = 0
			end
		end,
		reset = function (self)
			self.x = PlayerMissileConsts.storeX
			self.y = PlayerMissileConsts.storeY
			self.speed = 0

			PlayerMissileExhaust:update(self.x, self.y + 8)
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
					Player:getWeaponPower(Aliens[i].weaponType)
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
