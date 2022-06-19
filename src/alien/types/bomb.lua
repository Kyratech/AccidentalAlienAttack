function CreateBombAlien(i, j)
	return CreateAlienBase(
		i,
		j,
		AlienBombAni,
		PlayerWeapons.mortar,
		StandardDieFunction
	)
end

function CreateAlienBomb(alienBombBlasts)
	return {
		x = AlienShotConsts.storeX,
		y = AlienShotConsts.storeY,
		w = 4,
		h = 4,
		speed = 0,
		countdown = 60,
		alienBombBlasts = alienBombBlasts,
		draw = function (self)
			if self.speed > 0 then
				spr(
					AlienBombShotAni.sprites[1],
					self.x - 2,
					self.y - 2,
					AlienBombShotAni.clrIndex)
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
		end,
		shoot = function (self)
			if AlienIndexesThatCanShootBombsCount > 0 then
				-- Pick an alien
				local i = math.random(AlienIndexesThatCanShootBombsCount)
				local formationPosition = AlienIndexesThatCanShootBombs[i]
				
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
			self.countdown = math.random(180, 600)
		end,
		collision = function (self)
			-- Check bottom of screen
			if self.y + self.h > GroundY then
				self.alienBombBlasts[1]:enable(self.x - 8, self.y - 10)
				self.alienBombBlasts[2]:enable(self.x + 8, self.y - 10)
				sfx(soundEffects.explosionBig)
				self:reset()
			end

			if Collide(self, SpecialWeaponBlock) then
				self.alienBombBlasts[1]:enable(self.x - 8, self.y - 10)
				self.alienBombBlasts[2]:enable(self.x + 8, self.y - 10)
				sfx(soundEffects.explosionBig)
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

function CreateAlienBombBlast()
	return {
		x = AlienShotConsts.storeX,
		y = AlienShotConsts.storeY,
		w = 4,
		h = 16,
		active = false,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = AlienBombBlastAni.sprites[1]
		},
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = AlienBombBlastAni.sprites[1]
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
					self.y,
					AlienBombBlastAni.clrIndex,
					1,
					0,
					0,
					1,
					2)
			end
		end,
		update = function (self)
			if self.active == true then
				AnimateOneshot(self, AlienBombBlastAni)
			end
		end,
		collision = function (self)
			if self.active == true then
				if Collide(self, Player) then
					if Player.active == true and Player.status ~= PlayerStatuses.shield then
						Player:die(false)
					end
				end
			end
		end
	}
end