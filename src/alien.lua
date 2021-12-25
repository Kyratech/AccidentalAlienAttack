Alien1Consts = {
	speed = 0.5,
	width = 1,
	height = 1,
	clrIndex = 12
}

function CreateAlien(i, j)
	return {
		x = 10 + i * 16,
		y = 10 + j * 10,
		w = Alien1Consts.width * TilePx,
		h = Alien1Consts.height * TilePx,
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
				Alien1Consts.clrIndex)
		end,
		update = function (self)
			Animate(self, Alien1Ani)
		end
	}
end