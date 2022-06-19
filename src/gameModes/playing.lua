function PlayingLoop()
	cls(BgColour)
	if Paused == true then
		Draw()
		PrintCustomCentred("Paused", HalfScreenWidth, 40)
		PauseMenu:input()
		PauseMenu:draw()
		InputPause()
	else
		Input()
		Update()
		Draw()
		AlienManager:updateAndDraw()
		UpdateAndDrawAlienShots()
		InputPause()
	end
end

function StartGame()
	Lives = 3
	Score = 0

	Player = CreatePlayer()
	PlayerShot = CreatePlayerShot()
	PlayerShield = CreatePlayerShield()

	PlayerMissile = CreatePlayerMissile()
	PlayerMissileExhaust = CreatePlayerMissileExhaust()
	PlayerMissileBurstVertical = CreatePlayerMissileVerticalBurst()
	PlayerMissileBurstLeft = CreatePlayerMissileHorizontalBurst(1)
	PlayerMissileBurstRight = CreatePlayerMissileHorizontalBurst(0)
	PlayerMissileBurstDiagonalLeft = CreatePlayerMissileDiagonalBurst(1)
	PlayerMissileBurstDiagonalRight = CreatePlayerMissileDiagonalBurst(0)

	PlayerMortarFragments = {
		CreatePlayerMortarFragment(PlayerMortarDirections.sw),
		CreatePlayerMortarFragment(PlayerMortarDirections.ssw),
		CreatePlayerMortarFragment(PlayerMortarDirections.s),
		CreatePlayerMortarFragment(PlayerMortarDirections.sse),
		CreatePlayerMortarFragment(PlayerMortarDirections.se)
	}
	PlayerSwarmGroup = CreateSpecialWeaponSwarmGroup()
	PlayerBubble = CreateSpecialWeaponBubble()

	SpecialWeaponBlockProjectile = CreateSpecialWeaponBlockProjectile()
	SpecialWeaponBlock = CreateSpecialWeaponBlock()
	SpecialWeaponDrill = CreateSpecialWeaponDrill()

	AlienCarrier = CreateCarrier()

	CurrentStage = 1
	CurrentLevel = 1

	ScreenTransition = CreateScreenTransition()

	AlienManager = CreateAlienManager()

	StartLevel(Formations[CurrentStage][CurrentLevel])

	AlienShots = {}
	for i = 1, AlienAttackRateOptions[GameSettings.alienAttackRate].value, 1 do
		local alienShotParticle = CreateAlienShotParticles()
		local alienShot = CreateAlienShot(alienShotParticle)
		table.insert(AlienShots, alienShot)
	end

	AlienBombBlasts = {
		CreateAlienBombBlast(),
		CreateAlienBombBlast()
	}
	AlienBomb = CreateAlienBomb(AlienBombBlasts)

	AliensDiving = {}

	Explosion = CreateExplosion()
	PlayerExplosionPrimary = CreateExplosion()
	PlayerExplosionSecondary = CreatePlayerExplosion()

	ShieldPowerup = CreateShieldPowerup()
	ExtraLifePowerup = CreateExtraLifePowerup()
	ScoreMultiplierPowerup = CreateScorePowerup()
	TimestopPowerup = CreateTimeStopPowerup()

	Paused = false

	HeaderUi = CreateHeaderUi()
	PowerupUi = CreatePowerupUi()
	SpecialWeaponUi = CreateSpecialWeaponUi()
	LevelUi = CreateLevelUi()
	PauseMenu = CreateMenu(PauseMenuOptions, PauseMenuOptionsCount, PauseMenuConsts, ScreenWidth / 2 - 44, 60)

	MapX = MapCols * CurrentStage
	MapY = MapRows * ShowBackgroundsOptions[GameSettings.showBackgrounds].value
end

function StartLevel(formation)
	ScreenTransition:reset()

	AlienManager:startLevel(formation)

	AlienCarrier:prepare()

	MapX = MapCols * CurrentStage
	MapY = MapRows * ShowBackgroundsOptions[GameSettings.showBackgrounds].value
end

function EndLevel()
	CurrentLevel = CurrentLevel + 1

	if CurrentLevel > NumberOfLevelsPerStage then
		EndStage()
	else
		StartLevel(Formations[CurrentStage][CurrentLevel])
	end
end

function EndStage()
	CurrentLevel = 1
	CurrentStage = CurrentStage + 1

	Player:activateStatus(PlayerStatuses.shield, PlayerConsts.powerupShieldLength)
	ScreenTransition:start()
end

function InputPause()
	if btnp(BtnX) then
		if Paused == true then
			sfx(soundEffects.uiUnpause)
		else
			sfx(soundEffects.uiPause)
		end

		Paused = not Paused
	end
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
	elseif btnp(BtnB) then
		if Player.active == true and Player.weaponPower == 4 then
			SpecialWeaponPicker[Player.weaponType]()
		end
	end

	ScreenTransition:input()
end

function Update()
	Player:update()
	Player:checkCollision()

	PlayerShot:update()
	PlayerShot:checkCollision()

	PlayerMissile:update()
	PlayerMissile:checkCollision()
	PlayerMissileBurstVertical:update()
	PlayerMissileBurstLeft:update()
	PlayerMissileBurstRight:update()
	PlayerMissileBurstDiagonalLeft:update()
	PlayerMissileBurstDiagonalRight:update()
	PlayerMissileBurstVertical:checkCollision()
	PlayerMissileBurstLeft:checkCollision()
	PlayerMissileBurstRight:checkCollision()
	PlayerMissileBurstDiagonalLeft:checkCollision()
	PlayerMissileBurstDiagonalRight:checkCollision()

	for i, mortarFragment in pairs(PlayerMortarFragments) do
		mortarFragment:update()
		mortarFragment:checkCollision()
	end
	PlayerSwarmGroup:update()
	PlayerSwarmGroup:checkCollision()
	PlayerBubble:update()
	PlayerBubble:checkCollision()

	SpecialWeaponBlockProjectile:update()
	SpecialWeaponBlock:update()
	SpecialWeaponBlock:checkCollision()
	SpecialWeaponDrill:update()
	SpecialWeaponDrill:checkCollision()

	PlayerShield:update()

	AlienCarrier:update()
	AlienCarrier:checkCollision()

	Explosion:update()

	PlayerExplosionPrimary:update()

	PlayerExplosionSecondary:update()

	ShieldPowerup:update()
	ShieldPowerup:checkCollision()
	ScoreMultiplierPowerup:update()
	ScoreMultiplierPowerup:checkCollision()
	ExtraLifePowerup:update()
	ExtraLifePowerup:checkCollision()
	TimestopPowerup:update()
	TimestopPowerup:checkCollision()

	ScreenTransition:update()
end

function UpdateAndDrawAlienShots()
	for i, alienShot in pairs(AlienShots) do
		AlienShots[i]:update()
		AlienShots[i]:collision()
		AlienShots[i]:draw()
		AlienShots[i].particle:update()
		AlienShots[i].particle:draw()
	end

	AlienBomb:update()
	AlienBomb:collision()
	AlienBomb:draw()
	for i, alienBombBlast in pairs(AlienBombBlasts) do
		AlienBombBlasts[i]:update()
		AlienBombBlasts[i]:collision()
		AlienBombBlasts[i]:draw()
	end
end

function ScorePoints(x)
	local scoreIncrease = x
	if Player.status == PlayerStatuses.scoreMultiplier then
		scoreIncrease = scoreIncrease * 2
	end
	Score = Score + scoreIncrease
end

function Draw()
	DrawBg()
	DrawUi()
	DrawGameObjects()
end

function DrawBg()
	map(MapX, MapY, MapCols, MapRows)
end

function DrawGameObjects()
	Player:draw()

	PlayerShot:draw()
	PlayerMissile:draw()
	PlayerMissileBurstVertical:draw()
	PlayerMissileBurstLeft:draw()
	PlayerMissileBurstRight:draw()
	PlayerMissileBurstDiagonalLeft:draw()
	PlayerMissileBurstDiagonalRight:draw()

	for i, mortarFragment in pairs(PlayerMortarFragments) do
		mortarFragment:draw()
	end
	PlayerSwarmGroup:draw()
	PlayerBubble:draw()

	SpecialWeaponBlockProjectile:draw()
	SpecialWeaponBlock:draw()
	SpecialWeaponDrill:draw()
	PlayerShield:draw()

	AlienCarrier:draw()

	Explosion:draw()
	PlayerExplosionSecondary:draw()
	PlayerExplosionPrimary:draw()

	ShieldPowerup:draw()
	ScoreMultiplierPowerup:draw()
	ExtraLifePowerup:draw()
	TimestopPowerup:draw()

	ScreenTransition:draw()

	-- DrawAimingDebug()
end

function DrawUi()
	HeaderUi:draw()
	PowerupUi:draw()
	SpecialWeaponUi:draw()
	LevelUi:draw()

	-- DrawDebug("displacement Y: " .. AlienManager.translationY)
	-- DrawMouseDebug()
end

function DrawDebug(text)
	print(text, 5, 11, 7)
end

function DrawMouseDebug()
	local x,y,left,middle,right,scrollx,scrolly = mouse()
	print("(" .. x .. "," .. y .. ")", 5, 21, 7)
end

function DrawAimingDebug()
	rect(Player.x + 4, 0, 2, ScreenHeight, 12)
end