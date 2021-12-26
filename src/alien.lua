AlienConsts = {
	speed = 0.25,
	width = 1,
	height = 1,
	clrIndex = 12
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