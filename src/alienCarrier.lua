CarrierConsts = {
	width = 2,
	height = 1,
	clrIndex = 12,
	speed = 0.5,
	y = 10,
	storeX = -16
}

function CreateCarrier()
	return {
		x = CarrierConsts.storeX,
		y = CarrierConsts.y,
		w = CarrierConsts.width * TilePx,
		h = CarrierConsts.height * TilePx,
		speed = 0,
		active = false,
		-- After what percentage of ships destroyed should the carrier spawn
		spawnWhenAliensRemaining = -1,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = CarrierAni.sprites[i]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.x,
				self.y,
				CarrierConsts.clrIndex,
				1,
				0,
				0,
				CarrierConsts.width,
				CarrierConsts.height)
		end,
		update = function (self)
			if self.active == true then
				self.x = self.x + self.speed

				Animate(self, CarrierAni)
			elseif LiveAliens <= self.spawnWhenAliensRemaining then
				self:enable()
			end
		end,
		checkCollision = function (self)
			if self.speed > 0 and self.x > 240 then
				self:disable()
			elseif self.speed < 0 and self.x < 0 - self.w then
				self:disable()
			end
		end,
		prepare = function (self)
			self.spawnWhenAliensRemaining = math.random(1, MaxAliens)
		end,
		enable = function (self)
			self.active = true
			self.spawnWhenAliensRemaining = -1
			local direction = math.random(1, 2)
			if direction == 1 then
				self.x = -16
				self.speed = CarrierConsts.speed * GameSettings.baseAlienCarrierSpeed
			else
				self.x = 240
				self.speed = -CarrierConsts.speed * GameSettings.baseAlienCarrierSpeed
			end
		end,
		disable = function (self)
			self.active = false
			self.x = CarrierConsts.storeX
			self.speed = 0
		end
	}
end