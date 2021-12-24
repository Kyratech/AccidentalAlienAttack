function init()
	-- Player
	player = createPlayer()
	playerShot = createPlayerShot()
	
	-- Aliens
	aliens = {}
	alienCountX = 9
	alienCountY = 4
	
	for i = 0, alienCountX, 1 do
		for j = 0, alienCountY, 1 do
			local alien = createAlien(i, j)
			table.insert(aliens, alien)
		end
	end
	
	explosion = createExplosion()
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
  player:update()
  playerShot:update()
	
	for i, alien in pairs(aliens) do
		aliens[i]:update()
	end
  
  explosion:update()
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
	if  a.x < b.x + b.w and
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
	player:draw()
	playerShot:draw()
		
	for i, alien in pairs(aliens) do
		aliens[i]:draw()
	end
	
	explosion:draw()
end

function drawDebug(text)
	print(text, 5, 1, 7)
end