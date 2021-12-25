function Init()
	-- Player
	Player = CreatePlayer()
	PlayerShot = CreatePlayerShot()

	-- Aliens
	Aliens = {}
	local alienCountX = 9
	local alienCountY = 4

	for i = 0, alienCountX, 1 do
		for j = 0, alienCountY, 1 do
			local alien = CreateAlien(i, j)
			table.insert(Aliens, alien)
		end
	end

	Explosion = CreateExplosion()
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
		PlayerShoot()
	end
end

function Update()
	Player:update()
	PlayerShot:update()

	for i, alien in pairs(Aliens) do
		Aliens[i]:update()
	end

	Explosion:update()
end

function Collisions()
	PlayerWallCollision()
	PlayerShotCollision()
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
	DrawGameObjects()
end

function DrawGameObjects()
	Player:draw()
	PlayerShot:draw()

	for i, alien in pairs(Aliens) do
		Aliens[i]:draw()
	end

	Explosion:draw()
end

function DrawDebug(text)
	print(text, 5, 1, 7)
end