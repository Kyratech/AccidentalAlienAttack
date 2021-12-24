playerConsts = {
 speed = 1,
 width = 1,
 height = 1,
 clrIndex = 12
}

playerShotConsts = {
	speed = 2,
	storeX = 300,
	storeY = 150,
	clrIndex = 0
}

function createPlayer()
  return {
		x = (240/2)-(playerConsts.width*tilePx/2),
		y = 120,
		w = playerConsts.width*tilePx,
		h = playerConsts.height*tilePx,
    speed = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = playerLeftAni.sprites[1]
		},
    draw = function (self)
      spr(
        self.ani.currentFrame,
        self.x,
        self.y,
        playerConsts.clrIndex)
    end,
    update = function (self)
      self.x = self.x + self.speed
      if self.speed > 0 then
        animate(self, playerRightAni)
      elseif self.speed < 0 then
        animate(self, playerLeftAni)
      end
    end
	}
end

function createPlayerShot()
  return {
		x = playerShotConsts.storeX,
		y = playerShotConsts.storeY,
		w = 2,
		h = 8,
    speed = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = playerShotAni.sprites[1]
		},
    draw = function (self)
      if playerShot.speed > 0 then
        spr(
          self.ani.currentFrame,
          self.x,
          self.y,
          playerShotConsts.clrIndex)
      end
    end,
    update = function (self)
      self.y = self.y - self.speed
      
      if self.speed > 0 then
        animate(self, playerShotAni)
      end
    end
	}
end

function playerShoot()
	if playerShot.speed == 0 then
		playerShot.x = player.x
		playerShot.y = player.y
		playerShot.speed = playerShotConsts.speed
	end
end

function playerShotReset()
	playerShot.x = playerShotConsts.storeX
	playerShot.y = playerShotConsts.storeY
	playerShot.speed = 0
end