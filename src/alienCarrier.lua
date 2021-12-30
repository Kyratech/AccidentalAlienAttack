CarrierConsts = {
	width = 2,
	height = 1,
	clrIndex = 12,
	speed = 0.5,
	y = 1,
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
		countdown = 180,
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
			elseif self.countdown > 0 then
				self.countdown = self.countdown - 1

				if self.countdown == 0 then
					self:enable()
				end
			end
		end,
		checkCollision = function (self)
			if self.x > 240 then
				self.active = false
			end
		end,
		ready = function (self)
			self.countdown = math.random(180, 600)
		end,
		enable = function (self)
			self.active = true
			local direction = math.random(1, 2)
			if direction == 1 then
				self.x = -16
				self.speed = CarrierConsts.speed
			else
				self.x = 240
				self.speed = -CarrierConsts.speed
			end
		end,
		disable = function (self)
			self.active = false
			self.x = CarrierConsts.storeX
			self.speed = 0
		end
	}
end