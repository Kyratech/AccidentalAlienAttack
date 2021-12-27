AlienConsts = {
	speed = 0.25,
	width = 1,
	height = 1,
	clrIndex = 12
}

AlienShotConsts = {
	speed = 0.5,
	storeX = 300,
	storeY = 130,
	clrIndex = 0
}

function CreateAlien(i, j)
	return {
		x = 10 + i * 16,
		y = 10 + j * 10,
		w = AlienConsts.width * TilePx,
		h = AlienConsts.height * TilePx,
		targetY = 10 + j * 10,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = Alien1Ani.sprites[1]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.x,
				self.y,
				AlienConsts.clrIndex)
		end,
		update = function (self)
			self.x = self.x + AlienGlobalSpeed

			self.targetY = 10 + AlienGlobalRowsStepped * 10 + j * 10
			if self.y < self.targetY then
				self.y = self.y + 1
			end
			
			Animate(self, Alien1Ani)
		end,
		checkWallCollision = function (self)
			if self.x + self.w > 240 then
				if self.y == self.targetY then
					NewAlienGlobalRowsStepped = AlienGlobalRowsStepped + 1
				end
				NewAlienGlobalSpeed = -AlienConsts.speed
			elseif self.x < 0 then
				if self.y == self.targetY then
					NewAlienGlobalRowsStepped = AlienGlobalRowsStepped + 1
				end
				NewAlienGlobalSpeed = AlienConsts.speed
			end
		end
	}
end

function CreateAlienShot()
	return {
		x = AlienShotConsts.storeX,
		y = AlienShotConsts.storeY,
		w = 4,
		h = 4,
		speed = 0,
		countdown = 60,
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
			self.y = self.y + self.speed

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
			if (LiveAliens > 0) then
				-- Pick an alien
				local i = math.random(LiveAliens)
				
				-- Shoot
				if self.speed == 0 then
					self.x = Aliens[i].x + 2
					self.y = Aliens[i].y + 8
					self.speed = AlienShotConsts.speed
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
			if self.y > 120 then
				self:reset()
			end
		end
	}
end