-- title: speshInvoders
-- author: kyratech
-- description: A clone of the atari space invaders game
-- script: lua

-- Global constants
bgColour = 0
tilePx = 8

-- Player constants
playerConsts = {
 speed = 1,
 width = 1,
 height = 1,
 clrIndex = 12
}

playerRightAni = {
 frameDelay = 5,
 length = 3,
 sprites = { 256, 257, 258 }
}

playerLeftAni = {
 frameDelay = 5,
 length = 3,
 sprites = { 258, 257, 256 }
}

playerShotConsts = {
	speed = 2,
	storeX = 300,
	storeY = 150,
	clrIndex = 0
}

playerShotAni = {
 frameDelay = 5,
 length = 2,
 sprites = { 272, 273 }
}

-- Alien constants
alien1Consts = {
	width = 1,
	height = 1,
	clrIndex = 12
}

alien1Ani = {
  frameDelay = 10,
  length = 4,
  sprites = { 288, 289, 290, 291 }
}

-- Other constants
explosionConsts = {
	storeX = 316,
	storeY = 150,
	clrIndex = 0
}

explosionAni = {
	frameDelay = 5,
	length = 5,
	sprites = { 274, 275, 276, 277, 278 }
}

-- Button aliases
btnLeft  = 2
btnRight = 3
btnA					= 4

function init()
	-- Player
	player = {
		x = (240/2)-(playerConsts.width*tilePx/2),
		y = 120,
		speed = 0,
		w = playerConsts.width*tilePx,
		h = playerConsts.height*tilePx,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = playerLeftAni.sprites[1]
		}
	}
	
	playerShot = {
		x = playerShotConsts.storeX,
		y = playerShotConsts.storeY,
		speed = 0,
		w = 2,
		h = 8,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = playerShotAni.sprites[1]
		}
	}
	
	-- Aliens
	aliens = {}
	alienCountX = 9
	alienCountY = 4
	
	for i = 0, alienCountX, 1 do
		for j = 0, alienCountY, 1 do
			local alien = {
				x = 10 + i * 16,
				y = 10 + j * 10,
				w = alien1Consts.width * tilePx,
				h = alien1Consts.height * tilePx,
				ani = {
					delayCounter = 0,
					currentCounter = 1,
					currentFrame = alien1Ani.sprites[1]
				}
			}
			table.insert(aliens, alien)
		end
	end
	
	explosion = {
		active = false,
		x = explosionConsts.storeX,
		y = explosionConsts.storeY,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = explosionAni.sprites[1]
		},
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = explosionAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.x = explosionConsts.storeX
			self.y = explosionConsts.storeY
		end
	}
end

function TIC()
 cls(bgColour)
	input()
	update()
	collisions()
	draw()
end

function input()
	if btn(btnLeft) then
		player.speed = -playerConsts.speed
	elseif btn(btnRight) then
		player.speed = playerConsts.speed
	else
		player.speed = 0
	end
	
	if btn(btnA) then
		playerShoot()
	end	
end

function update()
	player.x = player.x + player.speed
	playerShot.y = playerShot.y - playerShot.speed
	
	if player.speed > 0 then
		animate(player, playerRightAni)
	elseif player.speed < 0 then
		animate(player, playerLeftAni)
	end
	
	if playerShot.speed > 0 then
		animate(playerShot, playerShotAni)
	end
	
	if explosion.active == true then
		animateOneshot(explosion, explosionAni)
	end
	
	for i, alien in pairs(aliens) do
		animate(aliens[i], alien1Ani)
	end
end

function collisions()
 playerWallCollision()
 playerShotCollision()
end

function playerWallCollision()
 if player.x < 0 then
 	player.x = 0
 elseif player.x + player.w > 240 then
  player.x = 240 - player.w
 end
end

function playerShotCollision()
	-- Check off top of screen
	if playerShot.y < 0 then
		playerShotReset()
	end
	
	-- Check aliens
	for i, alien in pairs(aliens) do
		if collide(playerShot, aliens[i]) then
			table.remove(aliens, i)
			explosion:enable(playerShot.x, playerShot.y)
			playerShotReset()
		end
	end
end

function collide(a, b)
	if a.x < b.x + b.w and
				a.x + a.w > b.x and
				a.y < b.y + b.h and
				a.y + a.h > b.y then
		return true
	end
	
	return false
end

function draw()
	drawGameObjects()
end

function drawGameObjects()
	spr(
	 player.ani.currentFrame,
		player.x,
		player.y,
		playerConsts.clrIndex)
		
	if playerShot.speed > 0 then
		spr(
			playerShot.ani.currentFrame,
			playerShot.x,
			playerShot.y,
			playerShotConsts.clrIndex)
	end
		
	for i, alien in pairs(aliens) do
		spr(
			aliens[i].ani.currentFrame,
			aliens[i].x,
			aliens[i].y,
			alien1Consts.clrIndex)
	end
	
	if explosion.active == true then
		spr(
			explosion.ani.currentFrame,
			explosion.x,
			explosion.y,
			explosionConsts.clrIndex)
	end
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

function drawDebug(text)
	print(text, 5, 1, 7)
end

init()
-- <TILES>
-- 001:eccccccccc888888c0000000c0000000c0000000c0000000c0000000c0000000
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <SPRITES>
-- 000:c23bb32c99b11b9999abba99888aa88882322328211111121d0000d1c111111c
-- 001:c22bb23c99b11b9999abba99888aa88882232238311111121d0000d1c111111c
-- 002:c32bb22c99b11b9999abba99888aa88883223228211111131d0000d1c111111c
-- 016:000330000003300000033000000440000004000000004000000c00000000c000
-- 017:0003300000033000000330000004400000004000000400000000c000000c0000
-- 018:0000000000000000000000000002200000022000000000000000000000000000
-- 019:0000000000222200022333200233332002333220022322000022200000000000
-- 020:0033330003344333334444433444444334444433344444303344433003333300
-- 021:0333030034430340343003303300000000000033330003433430343033303330
-- 022:0020000002200020200000000000000000000000000000002000002202000220
-- 032:c333333c4333333442222224222002222220022212211221c21cc12c2cccccc2
-- 033:c333333c4333333442222224222002222220022212211221c21cc12cc2cccc2c
-- 034:c333333c4333333442222224222002222220022212211221c21cc12ccc2cc2cc
-- 035:c333333c4333333442222224222002222220022212211221c21cc12cc2cccc2c
-- </SPRITES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

function animate(gameObject, animation)
	gameObject.ani.delayCounter = gameObject.ani.delayCounter + 1
	
	if gameObject.ani.delayCounter > animation.frameDelay then
		local frame = gameObject.ani.currentCounter % animation.length
		gameObject.ani.currentCounter = frame + 1
		gameObject.ani.currentFrame = animation.sprites[gameObject.ani.currentCounter]
		gameObject.ani.delayCounter = 0
	end
end

function animateOneshot(gameObject, animation)
	gameObject.ani.delayCounter = gameObject.ani.delayCounter + 1
	
	if gameObject.ani.delayCounter > animation.frameDelay then
		gameObject.ani.currentCounter = gameObject.ani.currentCounter + 1
		
		if gameObject.ani.currentCounter > animation.length + 1 then
			gameObject:disable()
		else
			gameObject.ani.currentFrame = animation.sprites[gameObject.ani.currentCounter]
			gameObject.ani.delayCounter = 0
		end
	end
end