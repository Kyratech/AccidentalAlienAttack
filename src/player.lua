PlayerConsts = {
	speed = 1,
	width = 1,
	height = 1,
	clrIndex = 12
}

PlayerShotConsts = {
	speed = 2,
	storeX = 300,
	storeY = 150,
	clrIndex = 0
}

function CreatePlayer()
	return {
		x = (240/2)-(PlayerConsts.width*TilePx/2),
		y = 120,
		w = PlayerConsts.width*TilePx,
		h = PlayerConsts.height*TilePx,
		active = true,
		speed = 0,
		deathTimer = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerLeftAni.sprites[1]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.x,
				self.y,
				PlayerConsts.clrIndex)
		end,
		update = function (self)
			if self.active == true then
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
						self:enable()
					else
						GameState = StateGameOver
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
		-- Different to disable because this affects game state
		die = function (self)
			self.deathTimer = 180
			AlienGlobalRowsStepped = 0
			PlayerExplosionPrimary:enable(Player.x, Player.y)
			self:disable()
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
		end
	}
end

function PlayerShoot()
	if PlayerShot.speed == 0 then
		PlayerShot.x = Player.x + 3
		PlayerShot.y = Player.y
		PlayerShot.speed = PlayerShotConsts.speed
	end
end

function PlayerShotReset()
	PlayerShot.x = PlayerShotConsts.storeX
	PlayerShot.y = PlayerShotConsts.storeY
	PlayerShot.speed = 0
end