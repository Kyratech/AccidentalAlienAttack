alien1Consts = {
	width = 1,
	height = 1,
	clrIndex = 12
}

function createAlien(i, j)
  return {
    x = 10 + i * 16,
    y = 10 + j * 10,
    w = alien1Consts.width * tilePx,
    h = alien1Consts.height * tilePx,
    ani = {
      delayCounter = 0,
      currentCounter = 1,
      currentFrame = alien1Ani.sprites[1]
    },
    draw = function (self)
      spr(
        self.ani.currentFrame,
        self.x,
        self.y,
        alien1Consts.clrIndex)
    end,
    update = function (self)
      animate(self, alien1Ani)
    end
  }
end