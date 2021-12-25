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
		speed = 0,
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
			self.x = self.x + self.speed
			if self.speed > 0 then
				Animate(self, PlayerRightAni)
			elseif self.speed < 0 then
				Animate(self, PlayerLeftAni)
			end
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
		PlayerShot.x = Player.x
		PlayerShot.y = Player.y
		PlayerShot.speed = PlayerShotConsts.speed
	end
end

function PlayerShotReset()
	PlayerShot.x = PlayerShotConsts.storeX
	PlayerShot.y = PlayerShotConsts.storeY
	PlayerShot.speed = 0
end