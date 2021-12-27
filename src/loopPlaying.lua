function PlayingLoop()
	cls(BgColour)
	Input()
	Update()
	Collisions()
	Draw()
	UpdateAndDrawAliens()
	UpdateAndDrawAlienShots()
end

function StartGame()
	Lives = 3

	-- Player
	Player = CreatePlayer()
	PlayerShot = CreatePlayerShot()

	-- Aliens
	Aliens = {}
	local alienCountX = 9
	local alienCountY = 4
	LiveAliens = 50
	AlienGlobalSpeed = AlienConsts.speed
	AlienGlobalRowsStepped = 0
	for i = 0, alienCountX, 1 do
		for j = 0, alienCountY, 1 do
			local alien = CreateAlien(i, j)
			table.insert(Aliens, alien)
		end
	end

	AlienShots = {}
	local alienShotCount = 3
	for i = 0, alienShotCount, 1 do
		local alienShot = CreateAlienShot()
		table.insert(AlienShots, alienShot)
	end

	Explosion = CreateExplosion()
	PlayerExplosionPrimary = CreateExplosion()
	PlayerExplosionSecondary = CreatePlayerExplosion()
end

function Input()
	if btn(BtnLeft) then
		Player.speed = -PlayerConsts.speed
	elseif btn(BtnRight) then
		Player.speed = PlayerConsts.speed
	else
		Player.speed = 0
	end

	if btn(BtnA) then
		if Player.active == true then
			PlayerShoot()
		end
	end
end

function Update()
	Player:update()
	PlayerShot:update()
	Explosion:update()
	PlayerExplosionPrimary:update()
	PlayerExplosionSecondary:update()
end

function Collisions()
	PlayerWallCollision()
	PlayerShotCollision()
end

-- Combine alien handling so we only have to loop through once
function UpdateAndDrawAliens()
	NewAlienGlobalSpeed = AlienGlobalSpeed
	NewAlienGlobalRowsStepped = AlienGlobalRowsStepped

	for i, alien in pairs(Aliens) do
		Aliens[i]:update()
		Aliens[i]:checkWallCollision()
		Aliens[i]:draw()
	end

	AlienGlobalSpeed = NewAlienGlobalSpeed
	AlienGlobalRowsStepped = NewAlienGlobalRowsStepped
end

function UpdateAndDrawAlienShots()
	for i, alienShot in pairs(AlienShots) do
		AlienShots[i]:update()
		AlienShots[i]:collision()
		AlienShots[i]:draw()
	end
end

function PlayerWallCollision()
	if Player.x < 0 then
		Player.x = 0
	elseif Player.x + Player.w > 240 then
		Player.x = 240 - Player.w
	end
end

function PlayerShotCollision()
	-- Check off top of screen
	if PlayerShot.y < 0 then
		PlayerShotReset()
	end

	-- Check aliens
	for i, alien in pairs(Aliens) do
		if Collide(PlayerShot, Aliens[i]) then
			Explosion:enable(Aliens[i].x, Aliens[i].y)
			table.remove(Aliens, i)
			LiveAliens = LiveAliens - 1
			PlayerShotReset()
		end
	end
end

function Collide(a, b)
	if a.x < b.x + b.w and
		a.x + a.w > b.x and
		a.y < b.y + b.h and
		a.y + a.h > b.y then
		return true
	end
	return false
end

function Draw()
	DrawUi()
	DrawGameObjects()
end

function DrawGameObjects()
	Player:draw()
	PlayerShot:draw()
	Explosion:draw()
	PlayerExplosionSecondary:draw()
	PlayerExplosionPrimary:draw()
end

function DrawUi()
	print("Lives:", 5, 1, 6)
	print(Lives, 40, 1, 5)
end

function DrawDebug(text)
	print(text, 5, 1, 7)
end