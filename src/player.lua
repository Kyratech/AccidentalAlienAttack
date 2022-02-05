PlayerConsts = {
	speed = 1,
	widthPx = 10,
	heightPx = 9,
	sprOffsetX = -3,
	sprOffsetY = -7,
	clrIndex = 12,
	respawnShieldLength = 120,
	powerupShieldLength = 480
}

PlayerShotConsts = {
	speed = 2,
	storeX = 300,
	storeY = 150,
	clrIndex = 0
}

PlayerShieldConsts = {
	clrIndex = 0
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
		shielded = false,
		shieldTimer = 0,
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
				if self.shielded == true then
					self.shieldTimer = self.shieldTimer - 1

					if self.shieldTimer == 70 then
						PlayerShield:startDeactivation()
					elseif self.shieldTimer <= 0 then
						self.shielded = false
						PlayerShield:disable()
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
			self:activateShield(PlayerConsts.respawnShieldLength)
			self:enable()
		end,
		die = function (self)
			self.deathTimer = 180
			PlayerExplosionPrimary:enable(Player.x + 1, Player.y)
			PowerupUi:setIcon(PowerupIcons.none)
			self:disable()
		end,
		checkCollision = function (self)
			if self.x < LeftWallX then
				self.x = LeftWallX
			elseif self.x + self.w > RightWallX then
				self.x = RightWallX - self.w
			end
		end,
		activateShield = function (self, duration)
			self.shielded = true
			self.shieldTimer = duration
			PlayerShield:enable()
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
					KillAlien(i)
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
			PowerupUi:setIcon(PowerupIcons.shield)
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
			PowerupUi:setIcon(PowerupIcons.none)
		end
	}
end
