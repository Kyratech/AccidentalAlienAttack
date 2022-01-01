function PlayingLoop()
	cls(BgColour)
	Input()
	Update()
	Draw()
	UpdateAndDrawAliens()
	UpdateAndDrawAlienShots()
end

function StartGame()
	Lives = 3
	Score = 0

	-- Player
	Player = CreatePlayer()
	PlayerShot = CreatePlayerShot()
	PlayerShield = CreatePlayerShield()

	AlienCarrier = CreateCarrier()

	StartLevel(Formation1)

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

function StartLevel(formation)
	-- Aliens
	Aliens = {}
	MaxAliens = 50
	local alienCountX = 10
	local alienCountY = 5
	LiveAliens = 0

	AlienGlobalRowsStepped = 0
	for i = 1, alienCountX, 1 do
		for j = 1, alienCountY, 1 do
			local index = i + (j - 1) * alienCountX
			local alienType = formation[index]

			if alienType ~= 0 then
				local alien = CreateAlien(i, j, alienType)
				table.insert(Aliens, alien)
				LiveAliens = LiveAliens + 1
			end
		end
	end
	
	-- How fast the aliens should move
	AlienGlobalSpeed = CalculateAlienSpeed(LiveAliens, LiveAliens)
	-- The actual translation of the aliens
	AlienGlobalVelocity = AlienGlobalSpeed

	AlienCarrier:ready()
end

function Input()
	if btn(BtnLeft) then
		Player.speed = -PlayerConsts.speed
	elseif btn(BtnRight) then
		Player.speed = PlayerConsts.speed
	else
		Player.speed = 0
	end

	if btnp(BtnA) then
		if Player.active == true then
			PlayerShot:shoot()
		end
	end
end

function Update()
	Player:update()
	Player:checkCollision()

	PlayerShot:update()
	PlayerShot:checkCollision()

	PlayerShield:update()

	AlienCarrier:update()
	AlienCarrier:checkCollision()

	Explosion:update()

	PlayerExplosionPrimary:update()

	PlayerExplosionSecondary:update()
end

-- Combine alien handling so we only have to loop through once
function UpdateAndDrawAliens()
	NewAlienGlobalVelocity = AlienGlobalVelocity
	NewAlienGlobalRowsStepped = AlienGlobalRowsStepped

	for i, alien in pairs(Aliens) do
		Aliens[i]:update()
		Aliens[i]:checkCollision()
		Aliens[i]:draw()
	end

	AlienGlobalVelocity = NewAlienGlobalVelocity
	AlienGlobalRowsStepped = NewAlienGlobalRowsStepped
end

function UpdateAndDrawAlienShots()
	for i, alienShot in pairs(AlienShots) do
		AlienShots[i]:update()
		AlienShots[i]:collision()
		AlienShots[i]:draw()
	end
end

function KillAlien(i)
	Explosion:enable(Aliens[i].x, Aliens[i].y)
	
	Score = Score + 1
	table.remove(Aliens, i)
	LiveAliens = LiveAliens - 1

	if LiveAliens == 0 then
		StartLevel(Formation2)
	else
		AlienGlobalSpeed = CalculateAlienSpeed(MaxAliens, LiveAliens)
		if AlienGlobalVelocity > 0 then
			AlienGlobalVelocity = AlienGlobalSpeed
		else
			AlienGlobalVelocity = -AlienGlobalSpeed
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
	DrawBg()
	DrawUi()
	DrawGameObjects()
end

function DrawBg()
	local cols=30
	local rows=17
	map(30,0,cols,rows)
end

function DrawGameObjects()
	Player:draw()
	PlayerShot:draw()
	PlayerShield:draw()
	AlienCarrier:draw()
	Explosion:draw()
	PlayerExplosionSecondary:draw()
	PlayerExplosionPrimary:draw()
end

function DrawUi()
	print("Lives:", 5, 1, 6)
	print(Lives, 40, 1, 5)

	print("Score:", 70, 1, 6)
	print(Score, 105, 1, 5)

	-- DrawDebug(AlienGlobalRowsStepped)
	-- DrawMouseDebug()
end

function DrawDebug(text)
	print(text, 5, 11, 7)
end

function DrawMouseDebug()
	local x,y,left,middle,right,scrollx,scrolly = mouse()
	print("(" .. x .. "," .. y .. ")", 5, 21, 7)
end