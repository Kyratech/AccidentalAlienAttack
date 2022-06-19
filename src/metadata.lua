-- title: Accidental alien attack!
-- author: KyraTech
-- desc: A clone of the atari space invaders game
-- script: lua

Version = "0.1.0"

-- Global constants
BgColour = 0
TilePx = 8

ScreenWidth = 240
HalfScreenWidth = ScreenWidth / 2
ScreenHeight = 136
HalfScreenHeight = ScreenHeight / 2

MapCols=30
MapRows=17

LeftWallX = 22
RightWallX = 218
TopY = 20
GroundY = 125

AlienCountX = 10
AlienCountY = 5

-- Button aliases
BtnUp = 0
BtnDown = 1
BtnLeft = 2
BtnRight = 3
BtnA = 4
BtnB = 5
BtnX = 6

-- Game states
StateTitle = 1
StatePlaying = 2
StateGameOver = 3
StateDialogue = 4
StateInstructions = 5
StateHighScores = 6

-- Sound constants
UiVolume = 15

HighScoreMemoryIndexes = {
	{
		name = 0,
		score = 1
	},
	{
		name = 2,
		score = 3
	},
	{
		name = 4,
		score = 5
	},
	{
		name = 6,
		score = 7
	},
	{
		name = 8,
		score = 9
	}
}

GameSettingsMemoryIndexes = {
	input = 10,
	gameplay = 11,
	video = 12
}

-- Extract part of the binary representation of a number.
-- Assign the least significant bit the index 0.
-- a is the least significant part of the substring.
-- b is the most significant part of the substring.
-- Example for a 32 bit number:
-- 00000000000000110000000000000000
-- |       ^      ^               |
-- |       b      a               |
-- 31      23     16              0
-- Returns: 00000011 (3)
function IsolateBinaryPart(binaryNumber, a, b)
	local leastSignificantPart = binaryNumber % (2 ^ (b + 1))
	return RightShift(leastSignificantPart, a)
end

function LeftShift(x, by)
	return x * 2 ^ by
end

function RightShift(x, by)
	return math.floor(x / 2 ^ by)
end

GameSettings = {
	buttonPrompts = 1,
	showBackgrounds = 1,
	alienSpeed = 4,
	alienShotSpeed = 3,
	alienDescentRate = 3,
	alienCarrierSpeed = 3,
	alienAttackRate = 3
}

function SaveGameSettings()
	local encodedInputSettings = EncodeInputSettings(GameSettings)
	local encodedVideoSettings = EncodeVideoSettings(GameSettings)
	local encodedGameplaySettings = EncodeGameplaySettings(GameSettings)

	pmem(GameSettingsMemoryIndexes.input, encodedInputSettings)
	pmem(GameSettingsMemoryIndexes.video, encodedVideoSettings)
	pmem(GameSettingsMemoryIndexes.gameplay, encodedGameplaySettings)
end

function LoadGameSettings()
	local encodedInputSettings = pmem(GameSettingsMemoryIndexes.input)
	local encodedVideoSettings = pmem(GameSettingsMemoryIndexes.video)
	local encodedGameplaySettings = pmem(GameSettingsMemoryIndexes.gameplay)

	if encodedInputSettings ~= 0 and encodedVideoSettings ~= 0 and encodedGameplaySettings ~= 0 then
		local inputSettings = DecodeInputSettings(encodedInputSettings)
		local videoSettings = DecodeVideoSettings(encodedVideoSettings)
		local gameplaySettings = DecodeGameplaySettings(encodedGameplaySettings)

		GameSettings = {
			buttonPrompts = inputSettings.buttonPrompts,
			showBackgrounds = videoSettings.showBackgrounds,
			alienSpeed = gameplaySettings.alienSpeed,
			alienShotSpeed = gameplaySettings.alienShotSpeed,
			alienDescentRate = gameplaySettings.alienDescentRate,
			alienCarrierSpeed = gameplaySettings.alienCarrierSpeed,
			alienAttackRate = gameplaySettings.alienAttackRate
		}
	end
end

function EncodeInputSettings(gameSettings)
	return gameSettings.buttonPrompts
end

function DecodeInputSettings(encodedInputSettings)
	return {
		buttonPrompts = IsolateBinaryPart(encodedInputSettings, 0, 4)
	}
end

function EncodeVideoSettings(gameSettings)
	return gameSettings.showBackgrounds
end

function DecodeVideoSettings(encodedVideoSettings)
	return {
		showBackgrounds = IsolateBinaryPart(encodedVideoSettings, 0, 4)
	}
end

function EncodeGameplaySettings(gameSettings)
	local shiftedAlienShotSpeed = LeftShift(gameSettings.alienShotSpeed, 4)
	local shiftedAlienDescentRate = LeftShift(gameSettings.alienDescentRate, 8)
	local shiftedAlienCarrierSpeed = LeftShift(gameSettings.alienCarrierSpeed, 12)
	local shiftedAlienAttackRate = LeftShift(gameSettings.alienAttackRate, 16)

	return gameSettings.alienSpeed + shiftedAlienShotSpeed + shiftedAlienDescentRate + shiftedAlienCarrierSpeed + shiftedAlienAttackRate
end

function DecodeGameplaySettings(encodedGameplaySettings)
	return {
		alienSpeed = IsolateBinaryPart(encodedGameplaySettings, 0, 3),
		alienShotSpeed = IsolateBinaryPart(encodedGameplaySettings, 4, 7),
		alienDescentRate = IsolateBinaryPart(encodedGameplaySettings, 8, 11),
		alienCarrierSpeed = IsolateBinaryPart(encodedGameplaySettings, 12, 15),
		alienAttackRate = IsolateBinaryPart(encodedGameplaySettings, 16, 19)
	}
end

ButtonPromptsOptions = {
	{
		label = "TIC-80",
		value = "tic"
	},
	{
		label = "QWERTY",
		value = "pc"
	}
}

ShowBackgroundsOptions = {
	{
		label = "Yes",
		value = 0
	},
	{
		label = "No",
		value = 1
	}
}

AlienSpeedOptions = {
	{
		label = ".00",
		value = 0
	},
	{
		label = ".25",
		value = 0.25
	},
	{
		label = ".50",
		value = 0.5
	},
	{
		label = "1.0",
		value = 1
	}
}

CarrierSpeedOptions = {
	{
		label = ".25",
		value = 0.25
	},
	{
		label = ".50",
		value = 0.5
	},
	{
		label = "1.0",
		value = 1
	}
}

AlienAttackRateOptions = {
	{
		label = ".00",
		value = 0
	},
	{
		label = ".50",
		value = 2
	},
	{
		label = "1.0",
		value = 4
	},
	{
		label = "1.5",
		value = 6
	}
}

AlienShotSpeedOptions = {
	{
		label = ".25",
		value = 0.25
	},
	{
		label = ".50",
		value = 0.5
	},
	{
		label = "1.0",
		value = 1
	},
	{
		label = "2.0",
		value = 2
	}
}

AlienDescentRateOptions = {
	{
		label = ".00",
		value = 0
	},
	{
		label = ".50",
		value = 0.5
	},
	{
		label = "1.0",
		value = 1
	},
	{
		label = "2.0",
		value = 2
	}
}

function Init()
	LoadGameSettings()
	TitleScreen()
end

function TIC()
	if GameState == StateTitle then
		TitleLoop()
	elseif GameState == StatePlaying then
		PlayingLoop()
	elseif GameState == StateGameOver then
		GameOverLoop()
	elseif GameState == StateDialogue then
		DialogueLoop()
	elseif GameState == StateInstructions then
		InstructionLoop()
	elseif GameState == StateHighScores then
		HighScoresLoop()
	end
end

function TitleLoop()
	TitleInput()
	TitleDraw()
end

OptionsMenuOpen = false

function TitleScreen()
	GameState = StateTitle

	MainMenu = CreateMenu(MainMenuOptions, MainMenuOptionsCount, MainMenuConsts, ScreenWidth / 2 - 30, 64)
	OptionsMenu = CreateMenu(OptionsMenuOptions, OptionsMenuOptionsCount, OptionsMenuConsts, 10, 20)
end

function TitleInput()
	cls(BgColour)
	if OptionsMenuOpen == true then
		OptionsMenu:input()
	else
		MainMenu:input()
	end
end

function TitleDraw()
	if OptionsMenuOpen == true then
		PrintCustomCentredDecorated("Options", ScreenWidth / 2, 5)
		DrawButtonPrompt(ButtonIcons.A, "Save + Exit", ScreenWidth - 90, ScreenHeight - 8)
		DrawButtonPrompt(ButtonIcons.B, "Back", 2, ScreenHeight - 8)

		OptionsMenu:draw()
	else
		local cols=30
		local rows=17
		map(0,0,cols,rows)
	
		MainMenu:draw()
	
		print("Developed by @KyraTech_13", 2, ScreenHeight - 8, 2)
		print(Version, ScreenWidth - 40, ScreenHeight - 8, 2, true)
	end
end

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
		CreatePlayerMortarFragment(PlayerMortarDirections.nw),
		CreatePlayerMortarFragment(PlayerMortarDirections.sw),
		CreatePlayerMortarFragment(PlayerMortarDirections.se),
		CreatePlayerMortarFragment(PlayerMortarDirections.ne)
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

	Player.canShoot = true
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

	Player.canShoot = false
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
		if Player.canShoot == true then
			PlayerShot:shoot()
		end
	elseif btnp(BtnB) then
		if Player.canShoot == true and Player.weaponPower == 4 then
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

GameOverPages = {
	{
		draw = function()
			DialogueObject:draw()

			PrintCustomCentredDecorated("incoming transmission", HalfScreenWidth, 8)
			PrintCustomCentredDecorated("end transmission", HalfScreenWidth, ScreenHeight - 16)

			DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
		end,
		update = function()
			DialogueObject:update()
		end,
		input = function()
			if btnp(BtnA) then
				GameOverPage = GameOverPage + 1
			end
		end
	},
	{
		draw = function()
			PrintCentred("Final score", HalfScreenWidth, 32, 12)
			PrintCentred(Score, HalfScreenWidth, 40, 3)

			InitialsInput:draw()

			PrintCustomCentredDecorated("performance review", HalfScreenWidth, 8)
			PrintCustomCentredDecorated("performance review", HalfScreenWidth, ScreenHeight - 16)

			DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
		end,
		update = function()
		end,
		input = function()
			InitialsInput:input()
		end
	},
	{
		draw = function()
			HighScoresTable:draw()

			PrintCustomCentredDecorated("high scores", HalfScreenWidth, 8)
			PrintCustomCentredDecorated("high scores", HalfScreenWidth, ScreenHeight - 16)

			DrawButtonPrompt(ButtonIcons.A, "Finish", ScreenWidth - 56, ScreenHeight - 8)
		end,
		update = function()
		end,
		input = function()
			if btnp(BtnA) then
				TitleScreen()
			end
		end
	}
}

function GameOverLoop()
	cls(BgColour)
	GameOverPages[GameOverPage]:input()
	GameOverPages[GameOverPage]:update()
	GameOverPages[GameOverPage]:draw()
end

function GameOver(script, numberOfLines)
	GameState = StateGameOver

	GameOverPage = 1

	DialogueObject = CreateDialogueScreen(script, numberOfLines, 20)
	InitialsInput = CreateInitialsInput(
		function ()
			local newScore = {
				name = InitialsInput:getName(),
				score = Score
			}
			HighScoresTable:updateHighScores(newScore)
			GameOverPage = GameOverPage + 1
		end)
	HighScoresTable = CreateHighScoresTable()
end

function DialogueLoop()
	cls(BgColour)
	DialogueInput()
	DialogueUpdate()
	DialogueDraw()
end

function DialogueInit(script, numberOfLines, endDialogueFunction)
	EndDialogueFunction = endDialogueFunction

	local columnWidth = 20

	DialogueObject = CreateDialogueScreen(script, numberOfLines, columnWidth)

	headerText = {
		text = "incoming transmission",
		y = 8,
		draw = function (self)
			PrintCustomCentredDecorated(self.text, 120, self.y)
		end
	}

	footerText = {
		text = "end transmission",
		y = ScreenHeight - 16,
		draw = function (self)
			PrintCustomCentredDecorated(self.text, 120, self.y)
		end
	}
end

function DialogueInput()
	if btnp(BtnA) then
		sfx(soundEffects.uiConfirm)
		EndDialogueFunction()
	end
end

function DialogueUpdate()
	DialogueObject:update()
end

function DialogueDraw()
	DialogueObject:draw()

	headerText:draw()
	footerText:draw()

	DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
end

InstructionPages = {
	{
		draw = function ()
			PrintCustomCentred("Objective", HalfScreenWidth, 8)
			
			print("An alien has come to your planet", 16, 24, 12)
			print("on holiday, but their drone swarm", 16, 32, 12)
			print("seems to have run amok!", 16, 40, 12)
	
			print("Do both of you a favour and blow", 16, 56, 12)
			print("those malfunctioning machines up", 16, 64, 12)
			print("before they do some damage!", 16, 72, 12)
	
			DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
			DrawButtonPrompt(ButtonIcons.B, "Exit", 2, ScreenHeight - 8)
		end,
		input = function ()
			if btnp(BtnA) then
				sfx(soundEffects.uiDing)
				InstructionStep = InstructionStep + 1
			end
		
			if btnp(BtnB) then
				TitleScreen()
			end
		end
	},
	{
		draw = function ()
			PrintCustomCentred("Controls", HalfScreenWidth, 8)
			
			spr(ButtonIcons.arrow[ButtonPromptsOptions[GameSettings.buttonPrompts].value], 16, 24, 0, 1, 0, 3)
			spr(ButtonIcons.arrow[ButtonPromptsOptions[GameSettings.buttonPrompts].value], 24, 24, 0, 1, 0, 1)
			print(": Move", 34, 26, 12)

			DrawButtonPrompt(ButtonIcons.A, "Shoot", 16, 40)

			DrawButtonPrompt(ButtonIcons.B, "Special weapon", 16, 56)

			DrawButtonPrompt(ButtonIcons.X, "Pause game", 16, 72)
	
			DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
			DrawButtonPrompt(ButtonIcons.B, "Back", 2, ScreenHeight - 8)
		end,
		input = function ()
			if btnp(BtnA) then
				sfx(soundEffects.uiDing)
				InstructionStep = InstructionStep + 1
			end
		
			if btnp(BtnB) then
				InstructionStep = InstructionStep - 1
			end
		end
	},
	{
		draw = function ()
			PrintCustomCentred("Special weapons", HalfScreenWidth, 8)
			
			print("Destroy 4 of the same type of drone", 16, 24, 12)
			print("in a row to unlock a special weapon!", 16, 32, 12)

			spr(288, 16, 48, 12)
			spr(288, 32, 48, 12)
			spr(288, 48, 48, 12)
			spr(288, 64, 48, 12)

			spr(11, 80, 48, 0, 1, 0, 1)

			spr(125, 96, 48, 0)

			print("Use your special weapons quickly, as", 16, 64, 12)
			print("shooting a different type of drone will", 16, 72, 12)
			print("reset your special weapon energy!", 16, 80, 12)
	
			DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
			DrawButtonPrompt(ButtonIcons.B, "Back", 2, ScreenHeight - 8)
		end,
		input = function ()
			if btnp(BtnA) then
				sfx(soundEffects.uiDing)
				InstructionStep = InstructionStep + 1
			end
		
			if btnp(BtnB) then
				InstructionStep = InstructionStep - 1
			end
		end
	},
	{
		draw = function ()
			PrintCustomCentred("Powerups", HalfScreenWidth, 8)
			
			print("Destroy a carrier drone to make it", 16, 24, 12)
			print("drop a powerup node.", 16, 32, 12)

			spr(304, 16, 48, 12)
			spr(305, 24, 48, 12)

			print("Activate a powerup by driving into it!", 16, 64, 12)
	
			DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
			DrawButtonPrompt(ButtonIcons.B, "Back", 2, ScreenHeight - 8)
		end,
		input = function ()
			if btnp(BtnA) then
				sfx(soundEffects.uiDing)
				InstructionStep = InstructionStep + 1
			end
		
			if btnp(BtnB) then
				InstructionStep = InstructionStep - 1
			end
		end
	},
	{
		draw = function ()
			PrintCustomCentred("Powerups cont", HalfScreenWidth, 8)
			
			spr(256, 16, 24, 0)
			print(": Extra life", 26, 26, 12)

			spr(257, 16, 40, 0)
			print(": Double points", 26, 42, 12)

			spr(258, 16, 56, 0)
			print(": Temporary shield", 26, 58, 12)

			spr(259, 16, 72, 0)
			print(": Freeze drones", 26, 74, 12)
	
			DrawButtonPrompt(ButtonIcons.A, "Exit", ScreenWidth - 39, ScreenHeight - 8)
			DrawButtonPrompt(ButtonIcons.B, "Back", 2, ScreenHeight - 8)
		end,
		input = function ()
			if btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				TitleScreen()
			end
		
			if btnp(BtnB) then
				InstructionStep = InstructionStep - 1
			end
		end
	}
}

function InstructionLoop()
	cls(BgColour)
	InstructionsInput()
	InstructionsDraw()
end

function InstructionsScreen()
	GameState = StateInstructions

	InstructionStep = 1
end

function InstructionsInput()
	InstructionPages[InstructionStep]:input()
end

function InstructionsDraw()
	InstructionPages[InstructionStep]:draw()
end

function HighScoresLoop()
	cls(BgColour)
	HighScoresInput()
	HighScoresDraw()
end

function HighScoresScreen()
	GameState = StateHighScores

	HighScoresTable = CreateHighScoresTable()
end

function HighScoresInput()
	if btnp(BtnA) then
		TitleScreen()
	end
end

function HighScoresDraw()
	PrintCustomCentred("High scores", HalfScreenWidth, 8)

	HighScoresTable:draw()

	DrawButtonPrompt(ButtonIcons.A, "Exit", ScreenWidth - 39, ScreenHeight - 8)
end

function ScrollOptionsH(self)
	if btnp(BtnLeft) then
		sfx(soundEffects.uiDing)
		self.selectedOption = self.selectedOption - 1

		if self.selectedOption == 0 then
			self.selectedOption = self.optionsCount
		end
	end

	if btnp(BtnRight) then
		sfx(soundEffects.uiDing)
		self.selectedOption = self.selectedOption + 1

		if self.selectedOption > self.optionsCount then
			self.selectedOption = 1
		end
	end

	if btnp(BtnA) then
		sfx(soundEffects.uiConfirm)
		for i = 1, OptionsMenuOptionsCount do
			OptionsMenuOptions[i]:save()
			SaveGameSettings()
		end
		OptionsMenuOpen = false
	end

	if btnp(BtnB) then
		OptionsMenuOpen = false
	end
end

MainMenuOptionsCount = 4
MainMenuOptions = {
	{
		draw = function(self, x, y)
			print("Start", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				GameState = StateDialogue
				DialogueInit(
					ScriptIntro,
					3,
					function()
						GameState = StatePlaying
						StartGame()
					end)
			end
		end
	},
	{
		draw = function(self, x, y)
			print("High scores", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				HighScoresScreen()
			end
		end
	},
	{
		draw = function(self, x, y)
			print("How to play", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				InstructionsScreen()
			end
		end
	},
	{
		draw = function(self, x, y)
			print("Options", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				OptionsMenuOpen = true
				OptionsMenu:getCurrent()
			end
		end
	}
}
MainMenuConsts = {
	arrowHOffset = 10,
	lineHeight = 12
}

OptionsMenuOptionsCount = 7
OptionsMenuOptions = {
	{
		options = ButtonPromptsOptions,
		optionsCount = 2,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Button prompts", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 40 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.buttonPrompts
		end,
		save = function (self)
			GameSettings.buttonPrompts = self.selectedOption
		end
	},
	{
		options = ShowBackgroundsOptions,
		optionsCount = 2,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Show backgrounds", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 40 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.showBackgrounds
		end,
		save = function (self)
			GameSettings.showBackgrounds = self.selectedOption
		end
	},
	{
		options = AlienSpeedOptions,
		optionsCount = 4,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Alien speed", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 20 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.alienSpeed
		end,
		save = function (self)
			GameSettings.alienSpeed = self.selectedOption
		end
	},
	{
		options = CarrierSpeedOptions,
		optionsCount = 3,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Carrier speed", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 20 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.alienCarrierSpeed
		end,
		save = function (self)
			GameSettings.alienCarrierSpeed = self.selectedOption
		end
	},
	{
		options = AlienAttackRateOptions,
		optionsCount = 4,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Alien attack rate", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 20 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.alienAttackRate
		end,
		save = function (self)
			GameSettings.alienAttackRate = self.selectedOption
		end
	},
	{
		options = AlienShotSpeedOptions,
		optionsCount = 4,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Alien shot speed", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 20 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.alienShotSpeed
		end,
		save = function (self)
			GameSettings.alienShotSpeed = self.selectedOption
		end
	},
	{
		options = AlienDescentRateOptions,
		optionsCount = 4,
		selectedOption = 1,
		draw = function(self, x, y)
			print("Alien descent rate", x, y, 12)

			for i = 1, self.optionsCount do
				local textColour = 1

				if i == self.selectedOption then
					textColour = 3
				end

				print(self.options[i].label, x + 120 + 20 * (i - 1), y, textColour)
			end
		end,
		input = ScrollOptionsH,
		getCurrent = function (self)
			self.selectedOption = GameSettings.alienDescentRate
		end,
		save = function (self)
			GameSettings.alienDescentRate = self.selectedOption
		end
	}
}
OptionsMenuConsts = {
	arrowHOffset = 10,
	lineHeight = 12
}

PauseMenuOptionsCount = 2
PauseMenuOptions = {
	{
		draw = function(self, x, y)
			print("Resume", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
				sfx(soundEffects.uiUnpause)
				Paused = false
			end
		end
	},
	{
		draw = function(self, x, y)
			print("Return to title", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				TitleScreen()
			end
		end
	}
}
PauseMenuConsts = {
	arrowHOffset = 10,
	lineHeight = 12
}

function CreateMenu(menuOptions, menuOptionsCount, menuConsts, x, y)
	return {
		x = x,
		y = y,
		options = menuOptions,
		selectedOption = 1,
		draw = function (self)
			for i = 1, menuOptionsCount do
				self.options[i]:draw(
					self.x + menuConsts.arrowHOffset,
					self.y + menuConsts.lineHeight * (i - 1))
			end

			local additionalArrowOffset = 0
			if time() % 500 > 250 then
				additionalArrowOffset = -1
			end

			spr(
				10,
				self.x + additionalArrowOffset,
				self.y + menuConsts.lineHeight * (self.selectedOption - 1) - 2,
				0)
		end,
		input = function (self)
			if btnp(BtnUp) then
				self.selectedOption = self.selectedOption - 1

				if self.selectedOption == 0 then
					self.selectedOption = menuOptionsCount
				end

				sfx(soundEffects.uiDing)
			end

			if btnp(BtnDown) then
				self.selectedOption = self.selectedOption + 1

				if self.selectedOption > menuOptionsCount then
					self.selectedOption = 1
				end

				sfx(soundEffects.uiDing)
			end

			self.options[self.selectedOption]:input()
		end,
		getCurrent = function (self)
			for i = 1, menuOptionsCount do
				self.options[i]:getCurrent()
			end
		end
	}
end

HighScoreMemoryIndexes = {
	{
		name = 0,
		score = 1
	},
	{
		name = 2,
		score = 3
	},
	{
		name = 4,
		score = 5
	},
	{
		name = 6,
		score = 7
	},
	{
		name = 8,
		score = 9
	}
}

DefaultHighScores = {
	{
		name = "ALP",
		score = 50
	},
	{
		name = "BET",
		score = 40
	},
	{
		name = "GAM",
		score = 30
	},
	{
		name = "DEL",
		score = 20
	},
	{
		name = "EPS",
		score = 10
	}
}

function CreateInitialsInput(submit)
	return {
		y = 60	,
		chars = {
			"A",
			"A",
			"A"
		},
		editingCharacter = 1,
		selectedCharacter = 65,
		draw = function (self)
			PrintCentred("Please enter your name:", HalfScreenWidth, self.y, 12)

			-- The current value
			local currentValueLeftX = HalfScreenWidth - 9
			local combinedString = self.chars[1] .. self.chars[2] .. self.chars[3]
			print(combinedString, currentValueLeftX, self.y + 12, 3, true)
			line(
				currentValueLeftX + (self.editingCharacter - 1) * 6,
				self.y + 20,
				currentValueLeftX + (self.editingCharacter - 1) * 6 + 4,
				self.y + 20,
				12)

			-- Letter picker
			local halfWidth = 78
			for i = 65, 90 do
				local normalisedI = i - 65
				local charX = HalfScreenWidth - halfWidth + (normalisedI % 13) * 12
				local charY = self.y + 28 + math.floor(normalisedI / 13) * 12
				local textColour = 1
				if i == self.selectedCharacter then
					textColour = 3
				end
				print(string.char(i), charX, charY, textColour, true)
			end
		end,
		input = function (self)
			if btnp(BtnLeft) then
				sfx(soundEffects.uiDing)
				self:updateSelectedCharacter(self.selectedCharacter - 1)
			elseif btnp(BtnRight) then
				sfx(soundEffects.uiDing)
				self:updateSelectedCharacter(self.selectedCharacter + 1)
			elseif btnp(BtnUp) then
				sfx(soundEffects.uiDing)
				self:updateSelectedCharacter(self.selectedCharacter - 13)
			elseif btnp(BtnDown) then
				sfx(soundEffects.uiDing)
				self:updateSelectedCharacter(self.selectedCharacter + 13)
			end

			if btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				if self.editingCharacter ~= 3 then
					self.editingCharacter = self.editingCharacter + 1
				else
					submit()
				end
			end

			if btnp(BtnB) and self.selectedCharacter ~= 1 then
				self.editingCharacter = self.editingCharacter - 1
			end
		end,
		getName = function (self)
			return self.chars[1] .. self.chars[2] .. self.chars[3]
		end,
		updateSelectedCharacter = function (self, newSelectedCharacter)
			if newSelectedCharacter < 65 then
				self.selectedCharacter = 65
			elseif newSelectedCharacter > 90 then
				self.selectedCharacter = 90
			else
				self.selectedCharacter = newSelectedCharacter
			end

			self.chars[self.editingCharacter] = string.char(self.selectedCharacter)
		end
	}
end

CreateHighScoresTable = function ()
	local topScores = {
		GetHighScore(1),
		GetHighScore(2),
		GetHighScore(3),
		GetHighScore(4),
		GetHighScore(5),
	}

	local topScoreStrings = {
		SerialiseHighScore(1, topScores[1]),
		SerialiseHighScore(2, topScores[2]),
		SerialiseHighScore(3, topScores[3]),
		SerialiseHighScore(4, topScores[4]),
		SerialiseHighScore(5, topScores[5])
	}

	return {
		y = 40,
		newScoreRanking = math.huge,
		newScoreString = "",
		topScores = topScores,
		topScoreStrings = topScoreStrings,
		draw = function (self)
			for i = 1, 5 do
				local colour = 12
				if i == self.newScoreRanking then
					colour = 3
				end
				PrintCentredMonospace(self.topScoreStrings[i], HalfScreenWidth, self.y + (i - 1) * 8, colour)
			end

			PrintCentredMonospace(self.newScoreString, HalfScreenWidth, self.y + 48, 3)
		end,
		updateHighScores = function (self, newScore)
			local newRanking = math.huge

			for i = 1, 5 do
				if newScore.score > self.topScores[i].score then
					for j = 5, i, -1 do
						self.topScores[j] = self.topScores[j - 1]
					end
					self.topScores[i] = newScore
					newRanking = i
					for j = 1, 5 do
						SaveHighScore(j, self.topScores[j])
					end
					break
				end
			end

			self.topScoreStrings = {
				SerialiseHighScore(1, self.topScores[1]),
				SerialiseHighScore(2, self.topScores[2]),
				SerialiseHighScore(3, self.topScores[3]),
				SerialiseHighScore(4, self.topScores[4]),
				SerialiseHighScore(5, self.topScores[5])
			}
			self.newScoreRanking = newRanking

			local newRankingString = "U"
			if newRanking < math.huge then
				newRankingString = tostring(newRanking)
			end

			self.newScoreString = SerialiseHighScore(newRankingString, newScore)
		end
	}
end

GetHighScore = function (rank)
	local highScoreValue = pmem(HighScoreMemoryIndexes[rank].score)
	local highScoreName = pmem(HighScoreMemoryIndexes[rank].name)

	if highScoreValue == 0 or highScoreName == 0 then
		return DefaultHighScores[rank]
	end

	local decodedHighScoreName = DecodeHighScoreName(highScoreName)

	return {
		name = decodedHighScoreName,
		score = highScoreValue
	}
end

function SaveHighScore (rank, highScore)
	pmem(HighScoreMemoryIndexes[rank].score, highScore.score)
	pmem(HighScoreMemoryIndexes[rank].name, EncodeHighScoreName(highScore.name))
end

EncodeHighScoreName = function(name)
	local charCodes = {
		string.byte(string.sub(name, 1, 1)),
		string.byte(string.sub(name, 2, 2)),
		string.byte(string.sub(name, 3, 3))
	}

	local shiftedFirstCharacter = LeftShift(charCodes[1], 16)
	local shiftedSecondCharacter = LeftShift(charCodes[2], 8)

	return shiftedFirstCharacter + shiftedSecondCharacter + charCodes[3]
end

DecodeHighScoreName = function(encodedName)
	local parts = {
		IsolateBinaryPart(encodedName, 16, 23),
		IsolateBinaryPart(encodedName, 8, 15),
		IsolateBinaryPart(encodedName, 0, 7)
	}

	return string.char(parts[1]) .. string.char(parts[2]) .. string.char(parts[3])
end

SerialiseHighScore = function(rank, highScore)
	local lengthOfScore = 1
	if highScore.score > 0 then
		lengthOfScore = math.floor(math.log(highScore.score, 10) + 1)
	end
	local numberOfSpaces = 13 - lengthOfScore
	local spaces = string.rep(" ", numberOfSpaces)

	return rank .. " " .. highScore.name .. spaces .. highScore.score
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

function CollideWithAliens(self, onCollision)
	for formationPosition, alien in pairs(Aliens) do
		if Collide(self, alien) then
			alien:die(formationPosition)

			ScorePoints(1)

			onCollision(self, alien)
		end
	end

	for i, specialAlien in pairs(SpecialAliens) do
		if Collide(self, specialAlien) then
			specialAlien:die(i)

			-- Probably bad practice
			-- Make sure not to use any non-special behaviour (like formationPosition) in the collision function
			onCollision(self, specialAlien)
		end
	end
end

PlayerConsts = {
	speed = 1,
	widthPx = 10,
	heightPx = 9,
	sprOffsetX = -3,
	sprOffsetY = -7,
	clrIndex = 12,
	respawnShieldLength = 120,
	powerupShieldLength = 480,
	scoreMultiplierLength = 480,
	timestopLength = 240
}

PlayerStatuses = {
	none = 0,
	shield = 1,
	scoreMultiplier = 2,
	timestop = 3
}

function CreatePlayer()
	return {
		x = (240/2)-(PlayerConsts.widthPx*TilePx/2),
		y = 118,
		w = PlayerConsts.widthPx,
		h = PlayerConsts.heightPx,
		active = true,
		speed = 0,
		deathTimer = 0,
		status = PlayerStatuses.none,
		statusTimer = 0,
		weaponType = PlayerWeapons.none,
		weaponPower = 0,
		canShoot = false,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerLeftAni.sprites[1]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.x + PlayerConsts.sprOffsetX,
				self.y + PlayerConsts.sprOffsetY,
				PlayerConsts.clrIndex,
				1,
				0,
				0,
				2,
				2)
		end,
		update = function (self)
			if self.active == true then
				if self.status ~= PlayerStatuses.none then
					self.statusTimer = self.statusTimer - 1

					if self.statusTimer == 70 then
						self:beginEndOfStatus()
					elseif self.statusTimer <= 0 then
						self:endStatus()
					end
				end

				self.x = self.x + self.speed
				if self.speed > 0 then
					Animate(self, PlayerRightAni)
				elseif self.speed < 0 then
					Animate(self, PlayerLeftAni)
				end
			else
				self.deathTimer = self.deathTimer - 1

				Animate(self, PlayerDeadAni)

				if self.deathTimer == 160 then
					PlayerExplosionSecondary:enable(Player.x, Player.y)
					sfx(soundEffects.explosionBigAlt)
				elseif self.deathTimer <= 0 then
					Lives = Lives - 1
					if Lives > 0 then
						self:respawn()
					else
						GameOver(ScriptGameOverBad, 2)
					end
				end
			end
		end,
		enable = function (self)
			self.active = true
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerLeftAni.sprites[1]
			self.canShoot = true
		end,
		disable = function (self)
			self.active = false
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerDeadAni.sprites[1]
			self.canShoot = false
		end,
		respawn = function (self)
			self:activateStatus(PlayerStatuses.shield, PlayerConsts.respawnShieldLength)
			self:enable()
		end,
		die = function (self, diedInAlienLoop)
			AlienManager:resetToTop(diedInAlienLoop)
			self.deathTimer = 180
			PlayerExplosionPrimary:enable(Player.x + 1, Player.y)
			PowerupUi:setIcon(PowerupIcons.none)
			sfx(soundEffects.explosionStandard)
			self:disable()
		end,
		getWeaponPower = function (self, weapon)
			if (self.weaponPower < 4) then
				if (self.weaponType ~= weapon) then
					self.weaponType = weapon
					self.weaponPower = 1
				else
					self.weaponPower = self.weaponPower + 1
				end
			end
		end,
		checkCollision = function (self)
			if self.x < LeftWallX then
				self.x = LeftWallX
			elseif self.x + self.w > RightWallX then
				self.x = RightWallX - self.w
			end
		end,
		activateStatus = function (self, newStatus, duration)
			self.status = newStatus
			self.statusTimer = duration

			if newStatus == PlayerStatuses.shield then
				PlayerShield:enable()
				PowerupUi:setIcon(PowerupIcons.shield)
			elseif newStatus == PlayerStatuses.scoreMultiplier then
				PowerupUi:setIcon(PowerupIcons.scoreMultiplier)
			elseif newStatus == PlayerStatuses.timestop then
				PowerupUi:setIcon(PowerupIcons.timestop)
			end
		end,
		beginEndOfStatus = function (self)
			if self.status == PlayerStatuses.shield then
				PlayerShield:startDeactivation()
			end

			PowerupUi:setFlashing(true)
		end,
		endStatus = function (self)
			if self.status == PlayerStatuses.shield then
				PlayerShield:disable()
			end
			
			self.status = PlayerStatuses.none
			PowerupUi:setIcon(PowerupIcons.none)
			PowerupUi:setFlashing(false)
		end
	}
end

PlayerShotConsts = {
	speed = 2,
	storeX = 300,
	storeY = 150,
	clrIndex = 0
}

function CreatePlayerShot()
	return {
		x = PlayerShotConsts.storeX,
		y = PlayerShotConsts.storeY,
		w = 2,
		h = 8,
		speed = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerShotAni.sprites[1]
		},
		draw = function (self)
			if PlayerShot.speed > 0 then
				spr(
					self.ani.currentFrame,
					self.x - 3,
					self.y,
					PlayerShotConsts.clrIndex)
			end
		end,
		update = function (self)
			self.y = self.y - self.speed

			if self.speed > 0 then
				Animate(self, PlayerShotAni)
			end
		end,
		checkCollision = function (self)
			-- Check off top of screen
			if self.y < 0 then
				PlayerShot:reset()
			end

			CollideWithAliens(self, function (self, alien)
				Explosion:enable(alien.x, alien.y)

				sfx(soundEffects.explosionStandard)

				PlayerShot:reset()
			end)

			if Collide(self, AlienCarrier) then
				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				ScorePoints(5)

				sfx(soundEffects.explosionBigAlt)

				PlayerShot:reset()
			end

			if Collide(self, SpecialWeaponBlock) then
				SpecialWeaponBlock:takeDamage(1)
				SpecialWeaponBlock:shove()
				PlayerShot:reset()
			end
		end,
		shoot = function (self)
			if self.speed == 0 then
				self.x = Player.x + 4
				self.y = Player.y
				self.speed = PlayerShotConsts.speed

				sfx(soundEffects.laser)

				AliensDodge()
			end
		end,
		reset = function (self)
			self.x = PlayerShotConsts.storeX
			self.y = PlayerShotConsts.storeY
			self.speed = 0
		end
	}
end

PlayerExplosionConsts = {
	storeX = 316,
	storeY = 150,
	clrIndex = 0
}

function CreatePlayerExplosion()
	return {
		active = false,
		x = PlayerExplosionConsts.storeX,
		y = PlayerExplosionConsts.storeY,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerExplosionAni.sprites[1]
		},
		enable = function (self, x, y)
			self.active = true
			self.x = x - 3
			self.y = y - 7
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerExplosionAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.x = PlayerExplosionConsts.storeX
			self.y = PlayerExplosionConsts.storeY
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x,
					self.y,
					PlayerExplosionConsts.clrIndex,
					1,
					0,
					0,
					2,
					2)
			end
		end,
		update = function (self)
			if self.active == true then
				AnimateOneshot(self, PlayerExplosionAni)
			end
		end
	}
end

PlayerShieldConsts = {
	clrIndex = 0
}

function CreatePlayerShield()
	return {
		x = 0,
		y = Player.y - 7,
		active = false,
		deactivating = false,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerShieldAni.sprites[1]
		},
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x,
					self.y,
					PlayerShieldConsts.clrIndex,
					1,
					0,
					0,
					2,
					2
				)
			end
		end,
		update = function (self)
			self.x = Player.x - 3

			if self.active == true then
				if self.deactivating == true then
					AnimateOneshot(self, PlayerShieldEndAni)
				else
					Animate(self, PlayerShieldAni)
				end
			end
		end,
		enable = function (self)
			self.active = true
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerShieldAni.sprites[1]
		end,
		startDeactivation = function (self)
			self.deactivating = true
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerShieldEndAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.deactivating = false
		end
	}
end

PlayerWeapons = {
	none = "none",
	vertical = "vertical",
	horizontal = "horizontal",
	diagonal = "diagonal",
	block = "block",
	drill = "drill",
	mortar = "mortar",
	swarm = "swarm",
	bubble = "bubble"
}

SpecialWeaponPicker = {
	vertical = function ()
		PlayerMissile:shoot(PlayerMissileAni.sprites[1])
	end,
	horizontal = function ()
		PlayerMissile:shoot(PlayerMissileAni.sprites[1])
	end,
	diagonal = function ()
		PlayerMissile:shoot(PlayerMissileAni.sprites[1])
	end,
	block = function ()
		SpecialWeaponBlockProjectile:shoot()
	end,
	drill = function ()
		SpecialWeaponDrill:shoot()
	end,
	mortar = function ()
		PlayerMissile:shoot(PlayerMortarAni.sprites[1])
	end,
	swarm = function ()
		PlayerSwarmGroup:shoot()
	end,
	bubble = function ()
		PlayerMissile:shoot(PlayerBubbleMissileAni.sprites[1])
	end
}

SpecialWeaponBlockConsts = {
	speed = 0.5,
	storeX = 340,
	storeY = 160,
	clrIndex = 2,
	shoveDistance = 10,
}

BlockHpColours = {
	2,
	3,
	4,
	5,
	6,
	10
}

function CreateSpecialWeaponBlockProjectile()
	return {
		x = SpecialWeaponBlockConsts.storeX,
		y = SpecialWeaponBlockConsts.storeY,
		active = false,
		speed = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = SpecialWeaponBlockProjectileAni.sprites[1]
		},
		shoot = function (self)
			if self.active == false then
				self.active = true
				self.x = Player.x - 4
				self.y = Player.y
				self.speed = -SpecialWeaponBlockConsts.speed
				self.ani.delayCounter = 0
				self.ani.currentCounter = 1
				self.ani.currentFrame = SpecialWeaponBlockProjectileAni.sprites[1]
				Player.weaponType = PlayerWeapons.none
				Player.weaponPower = 0
				sfx(soundEffects.missileMicro)
			end
		end,
		disable = function (self)
			SpecialWeaponBlock:enable(self.x + 1, self.y)
			self.active = false
			self.x = SpecialWeaponBlockConsts.storeX
			self.y = SpecialWeaponBlockConsts.storeY
			self.speed = 0
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x,
					self.y,
					SpecialWeaponBlockConsts.clrIndex,
					1,
					0,
					0,
					2,
					1)
			end
		end,
		update = function (self)
			self.y = self.y + self.speed

			if self.active == true then
				AnimateOneshot(self, SpecialWeaponBlockProjectileAni)
			end
		end
	}
end

function CreateSpecialWeaponBlock()
	return {
		x = SpecialWeaponBlockConsts.storeX,
		y = SpecialWeaponBlockConsts.storeY,
		targetY = SpecialWeaponBlockConsts.storeY,
		w = 14,
		h = 8,
		hp = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = SpecialWeaponBlockAni.sprites[1]
		},
		draw = function (self)
			if self.hp > 0 then
				spr(
					self.ani.currentFrame,
					self.x - 1,
					self.y,
					SpecialWeaponBlockConsts.clrIndex,
					1,
					0,
					0,
					2,
					1)

				rect(self.x + 6, self.y + 3, 2, 2, BlockHpColours[self.hp])
			end
		end,
		update = function (self)
			if self.hp > 0 and self.targetY < self.y then
				self.y = self.y - SpecialWeaponBlockConsts.speed
			end
		end,
		checkCollision = function (self)
			if self.hp > 0 then
				CollideWithAliens(self, function(self, alien)
					sfx(soundEffects.explosionStandard)
					self:takeDamage(2)
				end)
			end
		end,
		enable = function (self, x, y)
			self.x = x
			self.y = y
			self.targetY = y
			self.hp = 6
		end,
		disable = function (self)
			self.x = SpecialWeaponBlockConsts.storeX
			self.y = SpecialWeaponBlockConsts.storeY
			self.targetY = SpecialWeaponBlockConsts.storeY
		end,
		takeDamage = function (self, damage)
			self.hp = self.hp - damage

			if self.hp <= 0 then
				self:disable()
			end
		end,
		shove = function (self)
			self.targetY = self.targetY - SpecialWeaponBlockConsts.shoveDistance
		end
	}
end

PlayerMissileConsts = {
	speed = 2,
	storeX = 320,
	storeY = 150,
	clrIndex = 0
}

PlayerMissileBurstConsts = {
	speed = 4,
	storeX = 340,
	storeY = 150,
	clrIndex = 0
}

PlayerMissileLaunchPayload = {
	vertical = function (self, alienY)
		PlayerMissileBurstVertical:enable(self.x - 1, alienY - 20)
		sfx(soundEffects.explosionBig)
	end,
	horizontal = function (self, alienY)
		PlayerMissileBurstLeft:enable(self.x - 22, alienY + 2)
		PlayerMissileBurstRight:enable(self.x, alienY + 2)
		sfx(soundEffects.explosionBig)
	end,
	diagonal = function (self, alienY)
		PlayerMissileBurstDiagonalLeft:enable(self.x - 16, alienY - 8)
		PlayerMissileBurstDiagonalRight:enable(self.x + 10, alienY - 8)
		sfx(soundEffects.explosionBig)
	end,
	mortar = function (self, alienY)
		for i, mortarFragment in pairs(PlayerMortarFragments) do
			mortarFragment:enable(self.x -1, self.y + 2)
		end
		sfx(soundEffects.explosionBig)
	end,
	bubble = function (self, alienY)
		PlayerBubble:enable(self.x - 3, alienY)
		sfx(soundEffects.explosionEnergy)
	end
}

function CreatePlayerMissile()
	return {
		x = PlayerMissileConsts.storeX,
		y = PlayerMissileConsts.storeY,
		w = 2,
		h = 8,
		speed = 0,
		type = PlayerWeapons.none,
		sprite = PlayerMissileAni.sprites[1],
		draw = function (self)
			if self.speed > 0 then
				spr(
					self.sprite,
					self.x - 3,
					self.y,
					PlayerMissileConsts.clrIndex)

				PlayerMissileExhaust:draw()
			end
		end,
		update = function (self)
			self.y = self.y - self.speed

			if self.speed > 0 then
				PlayerMissileExhaust:update(self.x, self.y + 8)
			end
		end,
		checkCollision = function (self)
			-- Check off top of screen
			if self.y < 0 then
				self:reset()
			end
			
			CollideWithAliens(self, function (self, alien)
				local alienY = alien.y;
				self:createBursts(alienY)
				self:reset()
			end)

			if Collide(self, AlienCarrier) then
				local alienY = AlienCarrier.y;

				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				ScorePoints(5)

				self:createBursts(alienY)
				self:reset()
			end

			if Collide(self, SpecialWeaponBlock) then
				SpecialWeaponBlock:takeDamage(1)
				SpecialWeaponBlock:shove()
				self:createBursts(self.y)
				self:reset()
			end
		end,
		shoot = function (self, sprite)
			self.sprite = sprite

			if self.speed == 0 then
				self.x = Player.x + 4
				self.y = Player.y

				self.speed = PlayerMissileConsts.speed
				self.type = Player.weaponType
				
				Player.weaponType = PlayerWeapons.none
				Player.weaponPower = 0

				sfx(soundEffects.missile)
			end
		end,
		reset = function (self)
			self.x = PlayerMissileConsts.storeX
			self.y = PlayerMissileConsts.storeY
			self.speed = 0

			PlayerMissileExhaust:update(self.x, self.y + 8)
		end,
		createBursts = function (self, alienY)
			PlayerMissileLaunchPayload[self.type](self, alienY)
		end
	}
end

function CreatePlayerMissileExhaust()
	return {
		x = PlayerMissileConsts.storeX,
		y = PlayerMissileConsts.storeY,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerMissileExhaustAni.sprites[1]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.x - 3,
				self.y,
				PlayerMissileConsts.clrIndex)
		end,
		update = function (self, x, y)
			self.x = x
			self.y = y

			Animate(self, PlayerMissileExhaustAni)
		end
	}
end

PlayerMissileLinearBurstStatus = {
	disabled = 0,
	colliding = 1,
	visible = 2
}

function CreatePlayerMissileVerticalBurst()
	return {
		x = PlayerMissileBurstConsts.storeX,
		y = PlayerMissileBurstConsts.storeY,
		w = 4,
		h = 24,
		status = PlayerMissileLinearBurstStatus.disabled,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerMissileLinearBurstAni.sprites[1]
		},
		enable = function (self, x, y)
			self.status = PlayerMissileLinearBurstStatus.colliding
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerMissileLinearBurstAni.sprites[1]
		end,
		disable = function (self)
			self.status = PlayerMissileLinearBurstStatus.disabled
			self.x = ExplosionConsts.storeX
			self.y = ExplosionConsts.storeY
		end,
		draw = function (self)
			if self.status ~= PlayerMissileLinearBurstStatus.disabled then
				-- Have to rotate composite sprites by parts
				spr(
					self.ani.currentFrame,
					self.x - 2,
					self.y + 16,
					PlayerMissileLinearBurstAni.clrIndex,
					1,
					0,
					3
				)

				spr(
					self.ani.currentFrame + 1,
					self.x - 2,
					self.y + 8,
					PlayerMissileLinearBurstAni.clrIndex,
					1,
					0,
					3
				)

				spr(
					self.ani.currentFrame + 2,
					self.x - 2,
					self.y,
					PlayerMissileLinearBurstAni.clrIndex,
					1,
					0,
					3
				)
			end
		end,
		update = function (self)
			if self.status ~= PlayerMissileLinearBurstStatus.disabled then
				AnimateOneshot(self, PlayerMissileLinearBurstAni)
			end
		end,
		checkCollision = function (self)
			if self.status == PlayerMissileLinearBurstStatus.colliding then
				-- Only collide on the first frame
				self.status = PlayerMissileLinearBurstStatus.visible

				-- Check aliens
				CollideWithAliens(self, function (self, alien) end)

				if Collide(self, AlienCarrier) then
					Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
					ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
					AlienCarrier:disable()

					Score = Score + 5
				end
			end
		end
	}
end

function CreatePlayerMissileHorizontalBurst(spriteFlip)
	return {
		x = PlayerMissileBurstConsts.storeX,
		y = PlayerMissileBurstConsts.storeY,
		w = 24,
		h = 4,
		status = PlayerMissileLinearBurstStatus.disabled,
		spriteFlip = spriteFlip,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerMissileLinearBurstAni.sprites[1]
		},
		enable = function (self, x, y)
			self.status = PlayerMissileLinearBurstStatus.colliding
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerMissileLinearBurstAni.sprites[1]
		end,
		disable = function (self)
			self.status = PlayerMissileLinearBurstStatus.disabled
			self.x = ExplosionConsts.storeX
			self.y = ExplosionConsts.storeY
		end,
		draw = function (self)
			if self.status ~= PlayerMissileLinearBurstStatus.disabled then
				-- Have to flip composite sprites by parts
				spr(
					self.ani.currentFrame,
					self.x + 16 * self.spriteFlip,
					self.y - 2,
					PlayerMissileLinearBurstAni.clrIndex,
					1,
					self.spriteFlip
				)

				spr(
					self.ani.currentFrame + 1,
					self.x + 8,
					self.y - 2,
					PlayerMissileLinearBurstAni.clrIndex,
					1,
					self.spriteFlip
				)

				spr(
					self.ani.currentFrame + 2,
					self.x + 16 - 16 * self.spriteFlip,
					self.y - 2,
					PlayerMissileLinearBurstAni.clrIndex,
					1,
					self.spriteFlip
				)
			end
		end,
		update = function (self)
			if self.status ~= PlayerMissileLinearBurstStatus.disabled then
				AnimateOneshot(self, PlayerMissileLinearBurstAni)
			end
		end,
		checkCollision = function (self)
			if self.status == PlayerMissileLinearBurstStatus.colliding then
				-- Only collide on the first frame
				self.status = PlayerMissileLinearBurstStatus.visible

				-- Check aliens
				CollideWithAliens(self, function (self, alien) end)

				if Collide(self, AlienCarrier) then
					Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
					ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
					AlienCarrier:disable()

					Score = Score + 5
				end
			end
		end
	}
end

function CreatePlayerMissileDiagonalBurst(spriteFlip)
	return {
		x = PlayerMissileBurstConsts.storeX,
		y = PlayerMissileBurstConsts.storeY,
		w = 8,
		h = 4,
		status = PlayerMissileLinearBurstStatus.disabled,
		spriteFlip = spriteFlip,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerMissileDiagonalBurstAni.sprites[1]
		},
		enable = function (self, x, y)
			self.status = PlayerMissileLinearBurstStatus.colliding
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerMissileDiagonalBurstAni.sprites[1]
		end,
		disable = function (self)
			self.status = PlayerMissileLinearBurstStatus.disabled
			self.x = ExplosionConsts.storeX
			self.y = ExplosionConsts.storeY
		end,
		draw = function (self)
			if self.status ~= PlayerMissileLinearBurstStatus.disabled then
				-- Have to flip composite sprites by parts
				spr(
					self.ani.currentFrame,
					self.x - 8 + 16 * self.spriteFlip,
					self.y - 2,
					PlayerMissileDiagonalBurstAni.clrIndex,
					1,
					self.spriteFlip
				)

				spr(
					self.ani.currentFrame + 1,
					self.x,
					self.y - 2,
					PlayerMissileDiagonalBurstAni.clrIndex,
					1,
					self.spriteFlip
				)

				spr(
					self.ani.currentFrame + 16,
					self.x - 8 + 16 * self.spriteFlip,
					self.y + 6,
					PlayerMissileDiagonalBurstAni.clrIndex,
					1,
					self.spriteFlip
				)

				spr(
					self.ani.currentFrame + 17,
					self.x,
					self.y + 6,
					PlayerMissileDiagonalBurstAni.clrIndex,
					1,
					self.spriteFlip
				)
			end
		end,
		update = function (self)
			if self.status ~= PlayerMissileLinearBurstStatus.disabled then
				AnimateOneshot(self, PlayerMissileDiagonalBurstAni)
			end
		end,
		checkCollision = function (self)
			if self.status == PlayerMissileLinearBurstStatus.colliding then
				-- Only collide on the first frame
				self.status = PlayerMissileLinearBurstStatus.visible

				-- Check aliens
				CollideWithAliens(self, function (self, alien) end)

				if Collide(self, AlienCarrier) then
					Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
					ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
					AlienCarrier:disable()

					Score = Score + 5
				end
			end
		end
	}
end

-- I'm using compass directions as a shorthand even though north isnt actually up
PlayerMortarDirections = {
	nw = { x = -0.71, y = -0.71 },
	sw = { x = -0.71, y = 0.71 },
	ssw = { x = -0.38, y = 0.92 },
	s = { x = 0, y = 1 },
	sse = { x = 0.38, y = 0.92 },
	se = { x = 0.71, y = 0.71 },
	ne = { x = 0.71, y = -0.71 }
}

function CreatePlayerMortarFragment(mortarDirection)
	return {
		x = PlayerMissileBurstConsts.storeX,
		y = PlayerMissileBurstConsts.storeY,
		w = 4,
		h = 4,
		direction = mortarDirection,
		speedX = 0,
		speedY = 0,
		sprite = PlayerMortarFragmentAni.sprites[1],
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.speedX = self.direction.x
			self.speedY = self.direction.y
		end,
		disable = function (self)
			self.active = false
			self.x = ExplosionConsts.storeX
			self.y = ExplosionConsts.storeY
			self.speedX = 0
			self.speedY = 0
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.sprite,
					self.x - 2,
					self.y - 2,
					ExplosionConsts.clrIndex)
			end
		end,
		update = function (self)
			self.x = self.x + self.speedX
			self.y = self.y + self.speedY
		end,
		checkCollision = function (self)
			-- Check aliens
			CollideWithAliens(self, function (self, alien)
				self:disable()
				sfx(soundEffects.explosionStandard)
			end)

			if Collide(self, AlienCarrier) then
				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()
				self:disable()

				sfx(soundEffects.explosionBigAlt)

				Score = Score + 5
			end

			if self.y > GroundY then
				self:disable()
			end
		end
	}
end

SpecialWeaponDrillConsts = {
	speed = 1,
	storeX = 340,
	storeY = 170,
	clrIndex = 12
}

function CreateSpecialWeaponDrill()
	return {
		x = SpecialWeaponDrillConsts.storeX,
		y = SpecialWeaponDrillConsts.storeY,
		w = 6,
		h = 8,
		active = false,
		speed = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = SpecialWeaponDrillAni.sprites[1]
		},
		checkCollision = function (self)
			if self.active == true then
				CollideWithAliens(self, function (self, alien)
					sfx(soundEffects.explosionStandard)
				end)
			end
		end,
		shoot = function (self)
			if self.active == false then
				self.active = true
				self.x = Player.x + 2
				self.y = Player.y
				self.speed = -SpecialWeaponDrillConsts.speed
				self.ani.delayCounter = 0
				self.ani.currentCounter = 1
				self.ani.currentFrame = SpecialWeaponDrillAni.sprites[1]
				Player.weaponType = PlayerWeapons.none
				Player.weaponPower = 0
				sfx(soundEffects.missile)
			end
		end,
		disable = function (self)
			self.active = false
			self.x = SpecialWeaponDrillConsts.storeX
			self.y = SpecialWeaponDrillConsts.storeY
			self.speed = 0
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x - 1,
					self.y,
					SpecialWeaponDrillConsts.clrIndex)
			end
		end,
		update = function (self)
			self.y = self.y + self.speed

			if self.y < 0 then
				self:disable()
			end

			if self.active == true then
				Animate(self, SpecialWeaponDrillAni)
			end
		end
	}
end

function CreateSpecialWeaponBubble()
	return {
		x = PlayerMissileBurstConsts.storeX,
		y = PlayerMissileBurstConsts.storeY,
		w = 8,
		h = 8,
		speedX = 0,
		speedY = 0,
		counter = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = SpecialWeaponBubbleAni.sprites[1]
		},
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.speedX = 0
			self.speedY = -0.05
			self.counter = 120

			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = SpecialWeaponBubbleAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.x = ExplosionConsts.storeX
			self.y = ExplosionConsts.storeY
			self.speedX = 0
			self.speedY = 0
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x,
					self.y,
					ExplosionConsts.clrIndex)
			end
		end,
		update = function (self)
			self.x = self.x + self.speedX
			self.y = self.y + self.speedY

			if self.active == true then
				self.counter = self.counter - 1

				if self.counter == 3 then
					self.ani.delayCounter = 0
					self.ani.currentCounter = 1
					self.ani.currentFrame = SpecialWeaponBubblePopAni.sprites[1]
				elseif self.counter < 3 then
					AnimateOneshot(self, SpecialWeaponBubblePopAni)
				else
					Animate(self, SpecialWeaponBubbleAni)
				end
			end
		end,
		checkCollision = function (self)
			-- Check aliens
			CollideWithAliens(self, function (self, alien)
				sfx(soundEffects.explosionEnergy)
			end)

			if Collide(self, AlienCarrier) then
				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				sfx(soundEffects.explosionEnergy)

				ScorePoints(5)
			end
		end
	}
end

SpecialWeaponSwarmConsts = {
	acceleration = 0.1,
	speed = 3,
	storeX = 300,
	storeY = 150,
	clrIndex = 0,
	missilesInSwarm = 5
}

function CreateSpecialWeaponSwarmGroup()
	return {
		counter = 0,
		missilesFired = 0,
		active = false,
		swarmMissiles = {
			CreateSpecialWeaponSwarmMissile(),
			CreateSpecialWeaponSwarmMissile(),
			CreateSpecialWeaponSwarmMissile(),
			CreateSpecialWeaponSwarmMissile(),
			CreateSpecialWeaponSwarmMissile()
		},
		shoot = function (self)
			self.active = true

			self.swarmMissiles[1]:shoot()

			self.counter = 0
			self.missilesFired = 1

			Player.weaponType = PlayerWeapons.none
			Player.weaponPower = 0
		end,
		disable = function (self)
			self.active = false
		end,
		update = function (self)
			if self.active == true then
				self.counter = self.counter + 1

				if self.counter >= 20 then
					self.counter = 0
					self.missilesFired = self.missilesFired + 1
					self.swarmMissiles[self.missilesFired]:shoot()
					
					if self.missilesFired == SpecialWeaponSwarmConsts.missilesInSwarm then
						self:disable()
					end
				end
			end

			for i, swarmMissile in pairs(self.swarmMissiles) do
				swarmMissile:update()
			end
		end,
		draw = function (self)
			for i, swarmMissile in pairs(self.swarmMissiles) do
				swarmMissile:draw()
			end
		end,
		checkCollision = function (self)
			for i, swarmMissile in pairs(self.swarmMissiles) do
				swarmMissile:checkCollision()
			end
		end
	}
end

function CreateSpecialWeaponSwarmMissile()
	return {
		x = SpecialWeaponSwarmConsts.storeX,
		y = SpecialWeaponSwarmConsts.storeY,
		w = 3,
		h = 4,
		speed = 0,
		sprite = SpecialWeaponSwarmAni.sprites[1],
		launchX = SpecialWeaponSwarmConsts.storeX,
		launchY = SpecialWeaponSwarmConsts.storeY,
		draw = function (self)
			if self.speed ~= 0 then
				spr(
					self.sprite,
					self.x,
					self.y,
					SpecialWeaponSwarmConsts.clrIndex)

				line(
					self.launchX + 1, self.launchY + 4,
					self.x + 1, self.y + 4,
					10
				)
			end
		end,
		update = function (self)
			if self.speed ~= 0 and self.speed < SpecialWeaponSwarmConsts.speed then
				self.speed = self.speed + SpecialWeaponSwarmConsts.acceleration
			end

			self.y = self.y - self.speed
		end,
		checkCollision = function (self)
			-- Check off top of screen
			if self.y < 0 then
				self:reset()
			end

			CollideWithAliens(self, function (self, alien)
				sfx(soundEffects.explosionStandard)

				self:reset()
			end)

			if Collide(self, AlienCarrier) then
				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				ScorePoints(5)

				sfx(soundEffects.explosionStandard)

				self:reset()
			end

			if Collide(self, SpecialWeaponBlock) then
				SpecialWeaponBlock:takeDamage(1)
				SpecialWeaponBlock:shove()

				sfx(soundEffects.explosionStandard)

				self:reset()
			end
		end,
		shoot = function (self)
			self.x = Player.x + 3
			self.y = Player.y

			self.launchX = self.x
			self.launchY = self.y

			self.speed = SpecialWeaponSwarmConsts.acceleration

			sfx(soundEffects.missileMicro)
		end,
		reset = function (self)
			self.x = SpecialWeaponSwarmConsts.storeX
			self.y = SpecialWeaponSwarmConsts.storeY
			self.speed = 0
		end
	}
end

ExplosionConsts = {
	storeX = 316,
	storeY = 150,
	clrIndex = 0
}

function CreateExplosion()
	return {
		active = false,
		x = ExplosionConsts.storeX,
		y = ExplosionConsts.storeY,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = ExplosionAni.sprites[1]
		},
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = ExplosionAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.x = ExplosionConsts.storeX
			self.y = ExplosionConsts.storeY
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x,
					self.y,
					ExplosionConsts.clrIndex)
			end
		end,
		update = function (self)
			if self.active == true then
				AnimateOneshot(self, ExplosionAni)
			end
		end
	}
end

-- Each subsequent powerup should have a higher score
PowerupFrequency = {
	shield = 4,
	scoreMultiplier = 8,
	extraLife = 9,
	timestop = 11
}
MaxFrequencyScore = 11

ActivateRandomPowerup = function(x, y)
	local powerupIndex = math.random(MaxFrequencyScore)
	if powerupIndex <= PowerupFrequency.shield then
		ShieldPowerup:enable(x, y)
	elseif powerupIndex <= PowerupFrequency.scoreMultiplier then
		ScoreMultiplierPowerup:enable(x, y)
	elseif powerupIndex <= PowerupFrequency.extraLife then
		ExtraLifePowerup:enable(x, y)
	elseif powerupIndex <= PowerupFrequency.timestop then
		TimestopPowerup:enable(x, y)
	end
end

PowerupConsts = {
	width = 1,
	height = 1,
	acceleration = 0.2,
	maxSpeed = 2,
	bounces = 1,
	lifetime = 180,
	lifetimeFlash = 60,
	clrIndex = 0
}

CreateExtraLifePowerup = function ()
	return CreatePowerup(256, function()
		Lives = Lives + 1
	end)
end

CreateShieldPowerup = function ()
	return CreatePowerup(258, function()
		Player:activateStatus(PlayerStatuses.shield, PlayerConsts.powerupShieldLength)
	end)
end

CreateScorePowerup = function ()
	return CreatePowerup(257, function()
		Player:activateStatus(PlayerStatuses.scoreMultiplier, PlayerConsts.scoreMultiplierLength)
	end)
end

CreateTimeStopPowerup = function ()
	return CreatePowerup(259, function()
		Player:activateStatus(PlayerStatuses.timestop, PlayerConsts.timestopLength)
	end)
end

CreatePowerup = function (spriteIndex, collectionFunction)
	return {
		x = -20,
		y = -20,
		w = PowerupConsts.width * TilePx,
		h = PowerupConsts.height * TilePx,
		active = false,
		speed = 0,
		bounces = 0,
		countdown = 0,
		update = function (self)
			if self.active == true then
				if self.y + self.h ~= GroundY and self.speed <= PowerupConsts.maxSpeed then
					self.speed = self.speed + PowerupConsts.acceleration
				end

				self.countdown = self.countdown - 1
				
				if self.countdown <= 0 then
					self:disable()
				end

				self.y = self.y + self.speed
			end
		end,
		draw = function (self)
			if self.active == true then
				if self.countdown > PowerupConsts.lifetimeFlash or self.countdown % 4 < 2 then
					spr(
						spriteIndex,
						self.x,
						self.y,
						PowerupConsts.clrIndex
					)
				end
			end
		end,
		checkCollision = function (self)
			if self.speed ~= 0 and self.y + self.h >= GroundY then
				if self.bounces < PowerupConsts.bounces then
					self.speed = -self.speed
					self.bounces = self.bounces + 1
				else
					self.speed = 0
				end

				sfx(soundEffects.powerupTink)
				self.y = GroundY - self.h
			end

			if Collide(self, Player) then
				collectionFunction()
				sfx(soundEffects.powerup)
				self:disable()
			end
		end,
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.speed = 0
			self.bounces = 0
			self.countdown = PowerupConsts.lifetime
		end,
		disable = function (self)
			self.active = false
			self.x = -20
			self.y = -20
			self.speed = 0
		end
	}
end

function CreateBombAlien(i, j)
	return CreateAlienBase(
		i,
		j,
		AlienBombAni,
		PlayerWeapons.mortar,
		StandardDieFunction
	)
end

function CreateAlienBomb(alienBombBlasts)
	return {
		x = AlienShotConsts.storeX,
		y = AlienShotConsts.storeY,
		w = 4,
		h = 4,
		speed = 0,
		countdown = 60,
		alienBombBlasts = alienBombBlasts,
		draw = function (self)
			if self.speed > 0 then
				spr(
					AlienBombShotAni.sprites[1],
					self.x - 2,
					self.y - 2,
					AlienBombShotAni.clrIndex)
			end
		end,
		update = function (self)
			if Player.status ~= PlayerStatuses.timestop then
				self.y = self.y + self.speed
			end

			if self.countdown > 0 then
				self.countdown = self.countdown - 1
			else
				self:shoot()
			end
		end,
		shoot = function (self)
			if AlienIndexesThatCanShootBombsCount > 0 then
				-- Pick an alien
				local i = math.random(AlienIndexesThatCanShootBombsCount)
				local formationPosition = AlienIndexesThatCanShootBombs[i]
				
				-- Shoot
				if self.speed == 0 then
					self.x = Aliens[formationPosition].x + 2
					self.y = Aliens[formationPosition].y + 8
					self.speed = AlienShotConsts.speed * AlienShotSpeedOptions[GameSettings.alienShotSpeed].value
				end
			end
		end,
		reset = function (self)
			self.x = AlienShotConsts.storeX
			self.y = AlienShotConsts.storeY
			self.speed = 0
			self.countdown = math.random(180, 600)
		end,
		collision = function (self)
			-- Check bottom of screen
			if self.y + self.h > GroundY then
				self.alienBombBlasts[1]:enable(self.x - 8, self.y - 10)
				self.alienBombBlasts[2]:enable(self.x + 8, self.y - 10)
				sfx(soundEffects.explosionBig)
				self:reset()
			end

			if Collide(self, SpecialWeaponBlock) then
				self.alienBombBlasts[1]:enable(self.x - 8, self.y - 10)
				self.alienBombBlasts[2]:enable(self.x + 8, self.y - 10)
				sfx(soundEffects.explosionBig)
				self:reset()
				SpecialWeaponBlock:takeDamage(1)
			end

			if Collide(self, Player) then
				if Player.active == true and Player.status ~= PlayerStatuses.shield then
					Player:die(false)
				end
				self:reset()
			end
		end
	}
end

function CreateAlienBombBlast()
	return {
		x = AlienShotConsts.storeX,
		y = AlienShotConsts.storeY,
		w = 4,
		h = 16,
		active = false,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = AlienBombBlastAni.sprites[1]
		},
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = AlienBombBlastAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.x = AlienShotConsts.storeX
			self.y = AlienShotConsts.storeY
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x - 2,
					self.y,
					AlienBombBlastAni.clrIndex,
					1,
					0,
					0,
					1,
					2)
			end
		end,
		update = function (self)
			if self.active == true then
				AnimateOneshot(self, AlienBombBlastAni)
			end
		end,
		collision = function (self)
			if self.active == true then
				if Collide(self, Player) then
					if Player.active == true and Player.status ~= PlayerStatuses.shield then
						Player:die(false)
					end
				end
			end
		end
	}
end

DiveAlienConsts = {
	diveSpeed = 2
}

function CreateDiveAlien(i, j)
	return CreateAlienBase(
		i,
		j,
		AlienDiveAni,
		PlayerWeapons.drill,
		function(self, formationPosition)
			Explosion:enable(self.x, self.y)
			Player:getWeaponPower(self.specialWeapon)
			
			local divingAlien = CreateDiveAlienDiving(self.x + 1, self.y)
			AddSpecialAlien(divingAlien)

			AlienRemove(formationPosition)
		end
	)
end

function CreateDiveAlienDiving(x, y)
	return {
		x = x,
		y = y,
		w = 6,
		h = 8,
		speed = DiveAlienConsts.diveSpeed * AlienShotSpeedOptions[GameSettings.alienShotSpeed].value,
		draw = function (self)
			spr(423, self.x - 1, self.y, 12)
		end,
		update = function (self)
			self.y = self.y + self.speed
		end,
		checkCollision = function (self, i)
			-- Check bottom of screen
			if self.y + self.h > GroundY then
				sfx(soundEffects.explosionStandard)
				self:die(i)
			end

			if Collide(self, SpecialWeaponBlock) then
				sfx(soundEffects.explosionStandard)
				SpecialWeaponBlock:takeDamage(1)
				self:die(i)
			end

			if Collide(self, Player) then
				if Player.active == true and Player.status ~= PlayerStatuses.shield then
					Player:die(false)
				end
				self:die(i)
			end
		end,
		die = function (self, i)
			Explosion:enable(self.x - 1, self.y)
		
			SpecialAlienRemove(i)
		end
	}
end

AlienDodgeDirection = {
	left = -1,
	right = 1,
	none = 0
}

function CreateDodgeAlien(i, j)
	local dodgeAlien = CreateAlienBase(
		i,
		j,
		AlienDodgeAni,
		PlayerWeapons.swarm,
		StandardDieFunction
	)

	dodgeAlien.dodgeEffect = CreateDodgeEffect()

	dodgeAlien.dodgeDirection = AlienDodgeDirection.none
	dodgeAlien.calculateNextDodge = function (self)
		local canDodgeLeft = false
		local canDodgeRight = false

		if self.column > 1 then
			local alienIndexToTheLeft = GetFormationPosition(self.column - 1, self.row)
			if Aliens[alienIndexToTheLeft] == nil then
				canDodgeLeft = true
			end
		end

		if self.column < AlienCountX then
			local alienIndexToTheRight = GetFormationPosition(self.column + 1, self.row)
			if Aliens[alienIndexToTheRight] == nil then
				canDodgeRight = true
			end
		end

		if canDodgeLeft and canDodgeRight then
			local rng = math.random(2)
			self.dodgeDirection = AlienDodgeDirection.left
			if rng == 2 then
				self.dodgeDirection = AlienDodgeDirection.right
			end
			return
		end

		if canDodgeLeft then
			self.dodgeDirection = AlienDodgeDirection.left
			return
		end

		if canDodgeRight then
			self.dodgeDirection = AlienDodgeDirection.right
			return
		end

		self.dodgeDirection = AlienDodgeDirection.none
	end

	dodgeAlien.dodge = function (self)
		if self.dodgeDirection ~= 0 then
			self.dodgeEffect:enable(self.x, self.y, self.dodgeDirection)
		end
		
		self.column = self.column + self.dodgeDirection
		self:calculateNextDodge()
	end

	dodgeAlien.update = function (self)
		self.dodgeEffect:update()

		local formationOffsetX = (self.column - 1) * 16
		local formationOffsetY = (self.row - 1) * 10

		self.x = formationOffsetX + AlienManager.translationX
		self.y = formationOffsetY + AlienManager.translationY

		local animation = AlienDodgeAni
		if self.dodgeDirection ~= AlienDodgeDirection.none then
			animation = AlienDodgeReadyAni
		end
		Animate(self, animation)
	end

	dodgeAlien.draw = function (self)
		self.dodgeEffect:draw()

		local spriteFlip = 0
		if self.dodgeDirection == AlienDodgeDirection.left then
			spriteFlip = 1
		end

		spr(
			self.ani.currentFrame,
			self.x,
			self.y,
			AlienDodgeAni.clrIndex,
			1,
			spriteFlip)
	end

	return dodgeAlien;
end

function AliensDodge()
	for i = 1, AlienIndexesThatCanDodgeCount, 1 do
		Aliens[AlienIndexesThatCanDodge[i]]:dodge()
	end
end

function CreateDodgeEffect()
	return {
		active = false,
		x = ExplosionConsts.storeX,
		y = ExplosionConsts.storeY,
		spriteFlip = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = AlienDodgeEffectAni.sprites[1]
		},
		enable = function (self, x, y, direction)
			self.active = true
			self.x = x
			self.y = y

			self.spriteFlip = 0
			if direction == AlienDodgeDirection.left then
				self.spriteFlip = 1
			end

			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = AlienDodgeEffectAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.x = ExplosionConsts.storeX
			self.y = ExplosionConsts.storeY
		end,
		draw = function (self)
			if self.active == true then
				-- Have to flip composite sprites by parts
				spr(
					self.ani.currentFrame,
					self.x,
					self.y,
					AlienDodgeEffectAni.clrIndex,
					1,
					self.spriteFlip
				)

				spr(
					self.ani.currentFrame + 1,
					self.x + 8 - 16 * self.spriteFlip,
					self.y,
					AlienDodgeEffectAni.clrIndex,
					1,
					self.spriteFlip
				)

				spr(
					self.ani.currentFrame + 2,
					self.x + 16 - 32 * self.spriteFlip,
					self.y,
					AlienDodgeEffectAni.clrIndex,
					1,
					self.spriteFlip
				)
			end
		end,
		update = function (self)
			if self.active == true then
				AnimateOneshot(self, AlienDodgeEffectAni)
			end
		end
	}
end

AlienConsts = {
	width = 1,
	height = 1
}

function StandardDieFunction(self, formationPosition)
	Player:getWeaponPower(self.specialWeapon)

	AlienRemove(formationPosition)
end

function CreateAlienBase(i, j, animation, specialWeapon, dieFunction)
	return {
		x = LeftWallX + 10 + (i - 1) * 16,
		y = -50 + (j - 1) * 10,
		w = AlienConsts.width * TilePx,
		h = AlienConsts.height * TilePx,
		column = i,
		row = j,
		hitWall = false,
		specialWeapon = specialWeapon,
		shielded = false,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = animation.sprites[1]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.x,
				self.y,
				animation.clrIndex)

			if self.shielded == true then
				spr(
					468,
					self.x - 2,
					self.y - 2,
					0,
					1,
					0,
					0,
					2,
					2
				)
			end
		end,
		update = function (self)
			local formationOffsetX = (self.column - 1) * 16
			local formationOffsetY = (self.row - 1) * 10

			self.x = formationOffsetX + AlienManager.translationX
			self.y = formationOffsetY + AlienManager.translationY

			Animate(self, animation)
		end,
		checkCollision = function (self, i)
			if self.y + self.h >= GroundY then
				if Player.active == true and Player.status ~= PlayerStatuses.shield then
					Player:die(true)
				end
			elseif self.x + self.w >= RightWallX and AlienManager.direction == AlienDirection.right then
				AlienManager:reachRightWall()
			elseif self.x <= LeftWallX and AlienManager.direction == AlienDirection.left then
				AlienManager:reachLeftWall()
			end
		end,
		die = function(self, formationPosition)
			if self.shielded == true then
				self.shielded = false
			else
				dieFunction(self, formationPosition)
			end
		end
	}
end

function CreateShieldAlien(i, j)
	return CreateAlienBase(
		i,
		j,
		AlienShieldAni,
		PlayerWeapons.none,
		function (self, k)
			Explosion:enable(self.x, self.y)

			local damagedShieldAlien = CreateAlienBase(i, j, AlienShieldBrokenAni, PlayerWeapons.block, StandardDieFunction)
			damagedShieldAlien.x = self.x
			damagedShieldAlien.y = self.y
			Aliens[k] = damagedShieldAlien
		end
	)
end

function CreateSupportAlien(i, j)
	local supportAlien = CreateAlienBase(
		i,
		j,
		AlienSupportAni,
		PlayerWeapons.bubble,
		function (self, k)
			if self.column > 1 then
				local alienIndexToTheLeft = GetFormationPosition(self.column - 1, self.row)
				if Aliens[alienIndexToTheLeft] ~= nil then
					Aliens[alienIndexToTheLeft].shielded = true
				end
			end

			if self.column < AlienCountX then
				local alienIndexToTheRight = GetFormationPosition(self.column + 1, self.row)
				if Aliens[alienIndexToTheRight] ~= nil then
					Aliens[alienIndexToTheRight].shielded = true
				end
			end

			self.leftSkill:enable(self.x - 8, self.y)
			self.rightSkill:enable(self.x + 8, self.y)

			StandardDieFunction(self, k)
		end
	)

	local leftSkill = CreateAlienSupportParticle(1)
	local rightSkill = CreateAlienSupportParticle(0)

	table.insert(SupportAlienSkills, leftSkill)
	table.insert(SupportAlienSkills, rightSkill)
	SupportAlienSkillsCount = SupportAlienSkillsCount + 2

	supportAlien.leftSkill = leftSkill
	supportAlien.rightSkill = rightSkill

	return supportAlien
end

function CreateAlienSupportParticle(direction)
	return {
		active = false,
		x = ExplosionConsts.storeX,
		y = ExplosionConsts.storeY,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = AlienSupportSkillAni.sprites[1]
		},
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = AlienSupportSkillAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.x = ExplosionConsts.storeX
			self.y = ExplosionConsts.storeY
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x,
					self.y,
					ExplosionConsts.clrIndex,
					1,
					direction)
			end
		end,
		update = function (self)
			if self.active == true then
				AnimateOneshot(self, AlienSupportSkillAni)
			end
		end
	}
end

function AddSpecialAlien(specialAlien)
	table.insert( SpecialAliens, specialAlien )
	LiveSpecialAliens = LiveSpecialAliens + 1
end

function AlienRemove(formationPosition)
	Aliens[formationPosition] = nil
	LiveAliens = LiveAliens - 1

	if AlienIndexesThatCanShootCount > 0 then
		for i = 1, AlienIndexesThatCanShootCount do
			if AlienIndexesThatCanShoot[i] == formationPosition then
				AlienIndexesThatCanShootCount = AlienIndexesThatCanShootCount - 1
				table.remove( AlienIndexesThatCanShoot, i )
				break;
			end
		end
	end

	if AlienIndexesThatCanShootBombsCount > 0 then
		for i = 1, AlienIndexesThatCanShootBombsCount do
			if AlienIndexesThatCanShootBombs[i] == formationPosition then
				AlienIndexesThatCanShootBombsCount = AlienIndexesThatCanShootBombsCount - 1
				table.remove( AlienIndexesThatCanShootBombs, i )
				break;
			end
		end
	end

	if AlienIndexesThatCanDodgeCount > 0 then
		for i = 1, AlienIndexesThatCanDodgeCount do
			if AlienIndexesThatCanDodge[i] == formationPosition then
				AlienIndexesThatCanDodgeCount = AlienIndexesThatCanDodgeCount - 1
				table.remove( AlienIndexesThatCanDodge, i )
				break;
			end
		end
	end

	CheckEndOfLevel()
end

-- Simpler function because special aliens cannot shoot
function SpecialAlienRemove(i)
	table.remove( SpecialAliens, i )
	LiveSpecialAliens = LiveSpecialAliens - 1

	CheckEndOfLevel()
end

function CheckEndOfLevel()
	if LiveAliens + LiveSpecialAliens == 0 then
		EndLevel()
	else
		AlienManager.speed = CalculateAlienSpeed(MaxAliens, LiveAliens)
	end
end

function GetFormationPosition(column, row)
	return column + (row - 1) * AlienCountX
end

AlienSpeeds = {
	speedFull = 0.125,
	speedHalf = 0.25,
	speedQuarter = 0.5,
	speedFour = 1,
	speedOne = 2
}

function CalculateAlienSpeed(maxAliens, liveAliens)
	if liveAliens == 1 then
		return AlienSpeeds.speedOne * AlienSpeedOptions[GameSettings.alienSpeed].value
	elseif liveAliens <= 4 then
		return AlienSpeeds.speedFour * AlienSpeedOptions[GameSettings.alienSpeed].value
	elseif maxAliens // liveAliens == 1 then
		return AlienSpeeds.speedFull * AlienSpeedOptions[GameSettings.alienSpeed].value
	elseif maxAliens // liveAliens == 2 then
		return AlienSpeeds.speedHalf * AlienSpeedOptions[GameSettings.alienSpeed].value
	else
		return AlienSpeeds.speedQuarter * AlienSpeedOptions[GameSettings.alienSpeed].value
	end
end

AlienDirection = {
	left = { x = -1, y = 0 },
	right = { x = 1, y = 0 },
	up = { x = 0, y = -1 },
	down = { x = 0, y = 1 }
}

function CreateAlienManager()
	return {
		speed = 0,
		translationX = LeftWallX,
		translationY = -50,

		-- Settings that apply to the current alien loop
		rowsStepped = 0,
		direction = AlienDirection.right,
		
		-- Settings to apply after for the next alien loop
		newRowsStepped = 0,
		newDirection = AlienDirection.right,
		
		nextDirectionH = AlienDirection.left,
		hasChangedDirectionThisStep = false,
		
		startLevel = function(self, formation)
			self.translationX = LeftWallX
			self.translationY = -50

			self.rowsStepped = 0
			self.direction = AlienDirection.down
			self.newRowsStepped = 0
			self.newDirection = AlienDirection.down
			
			self.nextDirectionH = AlienDirection.right

			MaxAliens = 0

			-- Aliens count towards level completion, move normally, and can shoot
			Aliens = {}
			LiveAliens = 0
			-- Special aliens only count towards level completion (e.g. diving aliens)
			SpecialAliens = {}
			LiveSpecialAliens = 0

			-- Particles for support aliens
			-- The support alien creator will handle populating this
			-- Yes its inconsistent, I just want to finish this darn game
			SupportAlienSkills = {}
			SupportAlienSkillsCount = 0

			-- These aliens can shoot normal shots
			AlienIndexesThatCanShoot = {}
			AlienIndexesThatCanShootCount = 0
			-- These aliens can shoot bombs
			AlienIndexesThatCanShootBombs = {}
			AlienIndexesThatCanShootBombsCount = 0
			-- These aliens can dodge
			AlienIndexesThatCanDodge = {}
			AlienIndexesThatCanDodgeCount = 0

			for j = 1, AlienCountY, 1 do
				for i = 1, AlienCountX, 1 do
					local formationPosition = GetFormationPosition(i, j)
					local alienType = formation[formationPosition]

					if alienType ~= 0 then
						local alien = CreateAlien(i, j, alienType)
						Aliens[formationPosition] = alien
						MaxAliens = MaxAliens + 1
						LiveAliens = LiveAliens + 1

						if alienType == 6 then
							table.insert( AlienIndexesThatCanShootBombs, formationPosition )
							AlienIndexesThatCanShootBombsCount = AlienIndexesThatCanShootBombsCount + 1
						elseif alienType == 7 then
							table.insert( AlienIndexesThatCanDodge, formationPosition )
							AlienIndexesThatCanDodgeCount = AlienIndexesThatCanDodgeCount + 1
						else
							table.insert( AlienIndexesThatCanShoot, formationPosition )
							AlienIndexesThatCanShootCount = AlienIndexesThatCanShootCount + 1
						end
					end
				end
			end

			self.speed = CalculateAlienSpeed(LiveAliens, LiveAliens)
		end,

		updateAndDraw = function(self)
			self:calculateTranslation()

			self.hasChangedDirectionThisStep = false

			self:initNewSettings()

			for formationPosition, alien in pairs(Aliens) do
				alien:update()
				alien:checkCollision(formationPosition)
				alien:draw()
			end

			self:applyNewSettings()

			self:checkReachedTargetY()

			for i, specialAlien in pairs(SpecialAliens) do
				specialAlien:update()
				specialAlien:checkCollision(i)
				specialAlien:draw()
			end

			for i, supportAlienSkill in pairs(SupportAlienSkills) do
				supportAlienSkill:update()
				supportAlienSkill:draw()
			end
		end,

		initNewSettings = function (self)
			self.newDirection = self.direction
			self.newRowsStepped = self.rowsStepped
		end,
		applyNewSettings = function (self)
			self.direction = self.newDirection
			self.rowsStepped = self.newRowsStepped
		end,
		calculateTranslation = function (self)
			local speedX = self.direction.x * self.speed
			local speedY = self.direction.y

			self.translationX = self.translationX + speedX
			self.translationY = self.translationY + speedY
		end,

		reachRightWall = function (self)
			self:reachWall(AlienDirection.left)
		end,
		reachLeftWall = function (self)
			self:reachWall(AlienDirection.right)
		end,
		reachWall = function (self, nextDirection)
			if self.hasChangedDirectionThisStep ~= true then
				self.hasChangedDirectionThisStep = true
				self.newRowsStepped = self.rowsStepped + 1
				self.newDirection = AlienDirection.down
				self.nextDirectionH = nextDirection
			end
		end,

		resetToTop = function (self, diedInAlienLoop)
			if self.translationY > TopY then
				if diedInAlienLoop == true then
					self.newRowsStepped = 0
					self.newDirection = AlienDirection.up
				else
					self.rowsStepped = 0
					self.direction = AlienDirection.up
				end
			end
		end,

		-- Only works if vertical speed is 1
		checkReachedTargetY = function (self)
			if self.direction == AlienDirection.up or self.direction == AlienDirection.down then
				local targetY = TopY + (self.rowsStepped * 10 * AlienDescentRateOptions[GameSettings.alienDescentRate].value)
			
				if self.translationY == targetY then
					self.direction = self.nextDirectionH
				end
			end
		end
	}
end

CarrierConsts = {
	width = 2,
	height = 1,
	clrIndex = 12,
	speed = 0.5,
	y = 10,
	storeX = -16
}

function CreateCarrier()
	return {
		x = CarrierConsts.storeX,
		y = CarrierConsts.y,
		w = CarrierConsts.width * TilePx,
		h = CarrierConsts.height * TilePx,
		speed = 0,
		active = false,
		-- After what percentage of ships destroyed should the carrier spawn
		spawnWhenAliensRemaining = -1,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = CarrierAni.sprites[i]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.x,
				self.y,
				CarrierConsts.clrIndex,
				1,
				0,
				0,
				CarrierConsts.width,
				CarrierConsts.height)
		end,
		update = function (self)
			if self.active == true then
				self.x = self.x + self.speed

				Animate(self, CarrierAni)
			elseif LiveAliens <= self.spawnWhenAliensRemaining then
				self:enable()
			end
		end,
		checkCollision = function (self)
			if self.speed > 0 and self.x > 240 then
				self:disable()
			elseif self.speed < 0 and self.x < 0 - self.w then
				self:disable()
			end
		end,
		prepare = function (self)
			self.spawnWhenAliensRemaining = math.random(1, MaxAliens)
		end,
		enable = function (self)
			self.active = true
			self.spawnWhenAliensRemaining = -1
			local direction = math.random(1, 2)
			if direction == 1 then
				self.x = -16
				self.speed = CarrierConsts.speed * CarrierSpeedOptions[GameSettings.alienCarrierSpeed].value
			else
				self.x = 240
				self.speed = -CarrierConsts.speed * CarrierSpeedOptions[GameSettings.alienCarrierSpeed].value
			end
		end,
		disable = function (self)
			self.active = false
			self.x = CarrierConsts.storeX
			self.speed = 0
		end
	}
end

-- Alien types:
-- 0 - no alien
-- 1 - red alien
-- 2 - blue alien
-- 3 - green alien
-- 4 - shield alien
-- 5 - dive alien
-- 6 - bomb alien
-- 7 - dodge alien
-- 8 - support alien

-- NumberOfStages = 1
-- NumberOfLevelsPerStage = 10

-- Formations = {
-- 	{
-- 		{
-- 			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
-- 			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
-- 			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
-- 			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
-- 			0, 0, 0, 3, 3, 3, 3, 0, 0, 0
-- 		},
-- 		{
-- 			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
-- 			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
-- 			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
-- 			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
-- 			0, 0, 1, 1, 1, 1, 1, 0, 0, 0
-- 		},
-- 		{
-- 			0, 2, 0, 2, 0, 0, 2, 0, 2, 0,
-- 			2, 0, 2, 0, 2, 2, 0, 2, 0, 2,
-- 			2, 0, 0, 2, 0, 0, 2, 0, 0, 2,
-- 			2, 0, 0, 0, 0, 0, 0, 0, 0, 2,
-- 			2, 0, 0, 0, 0, 0, 0, 0, 0, 2
-- 		},
-- 		{
-- 			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
-- 			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
-- 			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
-- 			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
-- 			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
-- 		},
-- 		{
-- 			2, 0, 3, 3, 3, 3, 3, 0, 2, 0,
-- 			2, 0, 3, 3, 3, 3, 0, 0, 2, 0,
-- 			2, 0, 3, 3, 3, 0, 0, 0, 2, 0,
-- 			2, 0, 3, 3, 0, 0, 0, 0, 2, 0,
-- 			2, 0, 3, 0, 0, 0, 0, 0, 2, 0
-- 		},
-- 		{
-- 			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
-- 			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
-- 			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
-- 			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
-- 			0, 0, 1, 1, 3, 1, 1, 0, 0, 0
-- 		},
-- 		{
-- 			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
-- 			1, 2, 2, 2, 2, 2, 2, 2, 2, 1,
-- 			1, 2, 2, 2, 2, 2, 2, 2, 2, 1,
-- 			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
-- 			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
-- 		},
-- 		{
-- 			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
-- 			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
-- 			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
-- 			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
-- 			1, 0, 1, 0, 1, 0, 1, 0, 1, 0
-- 		},
-- 		{
-- 			3, 2, 0, 0, 1, 1, 0, 0, 2, 3,
-- 			3, 2, 2, 0, 1, 1, 0, 2, 2, 3,
-- 			3, 0, 2, 2, 1, 1, 2, 2, 0, 3,
-- 			3, 0, 0, 2, 2, 2, 2, 0, 0, 3,
-- 			3, 0, 0, 0, 2, 2, 0, 0, 0, 3
-- 		},
-- 		{
-- 			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
-- 			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
-- 			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
-- 			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
-- 			1, 2, 3, 2, 1, 1, 2, 3, 2, 1
-- 		}
-- 	}
-- }

-- For testing end-of-stage behaviour

NumberOfStages = 6
NumberOfLevelsPerStage = 1

Formations = {
	{
		-- 1-1
		{
			-- 0, 3, 0, 3, 0, 0, 3, 0, 3, 0,
			-- 0, 3, 0, 3, 0, 0, 3, 0, 3, 0,
			-- 0, 3, 0, 3, 0, 0, 3, 0, 3, 0,
			-- 0, 3, 0, 3, 0, 0, 3, 0, 3, 0,
			-- 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			0, 0, 0, 6, 6, 6, 6, 0, 0, 0,
			0, 0, 0, 6, 6, 6, 6, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 1-2
		{
			0, 0, 0, 1, 1, 1, 0, 0, 0, 0,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
			0, 0, 0, 1, 1, 1, 0, 0, 0, 0,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 1-3
		{
			2, 0, 2, 0, 2, 2, 0, 2, 0, 2,
			0, 2, 0, 2, 0, 0, 2, 0, 2, 0,
			0, 0, 2, 0, 0, 0, 0, 2, 0, 0,
			0, 0, 0, 2, 2, 2, 2, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 1-4
		{
			2, 2, 2, 0, 0, 0, 0, 2, 2, 2,
			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
			0, 0, 0, 3, 3, 3, 3, 0, 0, 0,
			0, 0, 0, 0, 3, 3, 0, 0, 0, 0
		},
		-- 1-5
		{
			3, 3, 3, 2, 2, 2, 2, 3, 3, 3,
			3, 3, 3, 2, 2, 2, 2, 3, 3, 3,
			0, 0, 0, 2, 2, 2, 2, 0, 0, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
			0, 1, 0, 1, 0, 1, 0, 1, 0, 1
		},
		-- 1-6
		{
			1, 1, 1, 0, 0, 0, 0, 1, 1, 1,
			1, 1, 1, 0, 2, 2, 0, 1, 1, 1,
			1, 1, 1, 0, 2, 2, 0, 1, 1, 1,
			3, 0, 3, 0, 0, 0, 0, 3, 0, 3,
			0, 3, 0, 0, 0, 0, 0, 0, 3, 0
		},
		-- 1-7
		{
			0, 0, 2, 3, 3, 3, 3, 2, 0, 0,
			0, 0, 2, 3, 3, 3, 3, 2, 0, 0,
			0, 0, 0, 3, 3, 3, 3, 0, 0, 0,
			0, 0, 1, 1, 1, 1, 1, 1, 0, 0,
			0, 1, 1, 1, 0, 0, 1, 1, 1, 0
		},
		-- 1-8
		{
			0, 0, 3, 3, 3, 3, 3, 3, 0, 0,
			0, 0, 1, 2, 3, 3, 2, 1, 0, 0,
			0, 0, 1, 2, 3, 3, 2, 1, 0, 0,
			0, 0, 1, 2, 2, 2, 2, 1, 0, 0,
			0, 0, 1, 2, 2, 2, 2, 1, 0, 0
		},
		-- 1-9
		{
			1, 0, 3, 0, 1, 0, 3, 0, 1, 0,
			1, 0, 3, 0, 1, 0, 3, 0, 1, 0,
			1, 0, 3, 0, 1, 0, 3, 0, 1, 0,
			1, 0, 3, 0, 1, 0, 3, 0, 1, 0,
			1, 0, 3, 0, 1, 0, 3, 0, 1, 0
		},
		-- 1-10
		{
			1, 0, 1, 0, 2, 2, 0, 1, 0, 1,
			0, 1, 0, 1, 2, 2, 1, 0, 1, 0,
			0, 0, 0, 0, 2, 2, 0, 0, 0, 0,
			3, 3, 3, 3, 2, 2, 3, 3, 3, 3,
			3, 3, 3, 3, 2, 2, 3, 3, 3, 3
		}
	},
	{
		-- 2-1
		{
			0, 0, 0, 4, 4, 4, 4, 0, 0, 0,
			0, 0, 0, 4, 4, 4, 4, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-2
		{
			4, 4, 3, 3, 3, 3, 3, 3, 4, 4,
			4, 4, 1, 1, 1, 1, 1, 1, 4, 4,
			0, 0, 1, 1, 1, 1, 1, 1, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-3
		{
			3, 3, 3, 2, 2, 2, 2, 3, 3, 3,
			3, 3, 3, 4, 4, 4, 4, 3, 3, 3,
			3, 3, 3, 1, 1, 1, 1, 3, 3, 3,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-4
		{
			0, 0, 2, 2, 1, 1, 2, 2, 0, 0,
			0, 4, 2, 2, 1, 1, 2, 2, 4, 0,
			4, 0, 4, 0, 1, 1, 0, 4, 0, 4,
			0, 4, 0, 0, 0, 0, 0, 0, 4, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-5
		{
			4, 4, 0, 3, 3, 3, 3, 0, 4, 4,
			4, 4, 0, 3, 3, 3, 3, 0, 4, 4,
			4, 4, 0, 3, 3, 3, 3, 0, 4, 4,
			0, 0, 0, 3, 3, 3, 3, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-6
		{
			4, 0, 4, 0, 4, 4, 0, 4, 0, 4,
			0, 4, 0, 4, 0, 0, 4, 0, 4, 0,
			2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-7
		{
			3, 3, 0, 0, 3, 3, 0, 0, 3, 3,
			2, 2, 0, 0, 2, 2, 0, 0, 2, 2,
			1, 1, 0, 0, 1, 1, 0, 0, 1, 1,
			4, 4, 0, 0, 4, 4, 0, 0, 4, 4,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-8
		{
			4, 4, 4, 0, 0, 0, 4, 4, 4, 0,
			0, 0, 0, 4, 4, 4, 0, 0, 0, 0,
			1, 1, 1, 2, 0, 2, 1, 1, 1, 0,
			1, 1, 1, 2, 0, 2, 1, 1, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-9
		{
			4, 4, 0, 2, 3, 3, 2, 0, 4, 4,
			4, 4, 0, 2, 3, 3, 2, 0, 4, 4,
			4, 4, 0, 2, 3, 3, 2, 0, 4, 4,
			3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-10
		{
			3, 3, 3, 1, 1, 1, 1, 2, 2, 2,
			3, 3, 3, 1, 1, 1, 1, 2, 2, 2,
			4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
			4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
	},
	{
		-- 3-1
		{
			0, 0, 0, 6, 6, 6, 6, 0, 0, 0,
			0, 0, 0, 6, 6, 6, 6, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-2
		{
			0, 3, 1, 2, 2, 2, 2, 1, 3, 0,
			0, 3, 1, 2, 2, 2, 2, 1, 3, 0,
			0, 3, 6, 2, 2, 2, 2, 1, 6, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-3
		{
			3, 3, 3, 2, 2, 2, 1, 1, 1, 0,
			3, 6, 3, 2, 6, 2, 1, 6, 1, 0,
			3, 3, 3, 2, 2, 2, 1, 1, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-4
		{
			0, 6, 0, 6, 0, 0, 6, 0, 6, 0,
			0, 2, 6, 2, 0, 0, 2, 6, 2, 0,
			0, 2, 2, 2, 0, 0, 2, 2, 2, 0,
			0, 1, 1, 1, 0, 0, 1, 1, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-5
		{
			6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
			3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
			2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-6
		{
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 4, 1, 2, 3, 3, 2, 1, 4, 0,
			0, 4, 1, 2, 3, 3, 2, 1, 4, 0,
			0, 6, 0, 0, 0, 0, 0, 0, 6, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-7
		{
			0, 3, 3, 1, 2, 2, 1, 3, 3, 0,
			0, 0, 3, 1, 2, 2, 1, 3, 0, 0,
			0, 0, 0, 1, 6, 6, 1, 0, 0, 0,
			0, 0, 0, 0, 4, 4, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-8
		{
			0, 0, 1, 6, 6, 6, 6, 1, 0, 0,
			0, 0, 1, 1, 1, 1, 1, 1, 0, 0,
			0, 0, 1, 4, 4, 4, 4, 1, 0, 0,
			0, 0, 1, 1, 1, 1, 1, 1, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-9
		{
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			2, 0, 0, 2, 0, 0, 2, 0, 0, 2,
			2, 0, 0, 2, 0, 0, 2, 0, 0, 2,
			2, 6, 6, 2, 0, 0, 2, 6, 6, 2,
			2, 6, 6, 2, 0, 0, 2, 6, 6, 2
		},
		-- 3-10
		{
			0, 0, 0, 6, 3, 4, 1, 2, 6, 3,
			0, 0, 6, 3, 4, 1, 2, 6, 3, 0,
			0, 6, 3, 4, 1, 2, 6, 3, 0, 0,
			6, 3, 4, 1, 2, 6, 3, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		}
	},
	{
		-- 4-1
		{
			5, 0, 5, 0, 5, 0, 5, 0, 5, 0,
			0, 5, 0, 5, 0, 5, 0, 5, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-2
		{
			0, 0, 0, 3, 1, 3, 1, 0, 0, 0,
			2, 2, 2, 1, 3, 1, 3, 2, 2, 2,
			5, 5, 5, 3, 1, 3, 1, 5, 5, 5,
			0, 0, 0, 1, 3, 1, 3, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-3
		{
			0, 2, 2, 0, 1, 1, 0, 2, 2, 0,
			0, 1, 1, 0, 2, 2, 0, 1, 1, 0,
			0, 2, 2, 0, 1, 1, 0, 2, 2, 0,
			0, 1, 1, 0, 2, 2, 0, 1, 1, 0,
			0, 5, 5, 0, 5, 5, 0, 5, 5, 0
		},
		-- 4-4
		{
			0, 5, 0, 5, 0, 5, 0, 5, 0, 0,
			1, 5, 1, 5, 1, 5, 1, 5, 1, 0,
			0, 1, 0, 1, 0, 1, 0, 1, 0, 0,
			2, 2, 2, 2, 2, 2, 2, 2, 2, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-5
		{
			0, 3, 2, 1, 5, 5, 1, 2, 3, 0,
			0, 0, 2, 1, 5, 5, 1, 2, 0, 0,
			0, 0, 0, 1, 5, 5, 1, 0, 0, 0,
			0, 0, 0, 5, 5, 5, 5, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-6
		{
			0, 6, 6, 0, 0, 0, 0, 6, 6, 0,
			0, 0, 0, 5, 5, 5, 5, 0, 0, 0,
			0, 0, 0, 3, 3, 3, 3, 0, 0, 0,
			0, 1, 1, 0, 0, 0, 0, 1, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-7
		{
			0, 2, 3, 0, 1, 1, 0, 3, 2, 0,
			0, 2, 3, 0, 6, 6, 0, 3, 2, 0,
			0, 4, 4, 4, 4, 4, 4, 4, 4, 0,
			0, 2, 3, 0, 5, 5, 0, 3, 2, 0,
			0, 0, 0, 0, 5, 5, 0, 0, 0, 0
		},
		-- 4-8
		{
			5, 1, 2, 6, 6, 6, 6, 2, 1, 5,
			5, 1, 2, 4, 4, 4, 4, 2, 1, 5,
			5, 1, 0, 0, 0, 0, 0, 0, 1, 5,
			5, 0, 0, 0, 0, 0, 0, 0, 0, 5,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-9
		{
			4, 4, 5, 5, 4, 4, 5, 5, 4, 4,
			0, 0, 5, 5, 0, 0, 5, 5, 0, 0,
			2, 2, 0, 0, 2, 2, 0, 0, 2, 2,
			2, 2, 0, 0, 2, 2, 0, 0, 2, 2,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-10
		{
			5, 5, 5, 5, 6, 6, 5, 5, 5, 5,
			4, 4, 4, 4, 6, 6, 4, 4, 4, 4,
			3, 3, 2, 2, 3, 3, 2, 2, 3, 3,
			1, 1, 1, 1, 2, 2, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		}
	},
	{
		-- 5-1
		{
			0, 0, 0, 8, 8, 8, 8, 0, 0, 0,
			0, 0, 0, 8, 8, 8, 8, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 5-2
		{
			2, 1, 1, 3, 8, 3, 1, 1, 2, 0,
			0, 2, 1, 3, 8, 3, 1, 2, 0, 0,
			0, 0, 2, 3, 8, 3, 2, 0, 0, 0,
			0, 0, 0, 2, 8, 2, 0, 0, 0, 0,
			0, 0, 0, 0, 2, 0, 0, 0, 0, 0
		},
		-- 5-3
		{
			0, 3, 8, 3, 2, 2, 3, 8, 3, 0,
			0, 3, 8, 3, 2, 2, 3, 8, 3, 0,
			0, 1, 8, 1, 3, 3, 1, 8, 1, 0,
			0, 1, 8, 1, 3, 3, 1, 8, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 5-4
		{
			3, 0, 1, 0, 0, 0, 0, 1, 0, 3,
			3, 8, 1, 8, 2, 2, 8, 1, 8, 3,
			3, 8, 1, 8, 2, 2, 8, 1, 8, 3,
			3, 0, 1, 0, 0, 0, 0, 1, 0, 3,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 5-5
		{
			0, 0, 2, 2, 2, 2, 2, 2, 0, 0,
			0, 3, 8, 8, 3, 3, 8, 8, 3, 0,
			0, 0, 0, 1, 1, 1, 1, 0, 0, 0,
			0, 0, 8, 8, 8, 8, 8, 8, 0, 0,
			0, 0, 0, 0, 2, 2, 0, 0, 0, 0
		},
		-- 5-6
		{
			5, 1, 1, 4, 8, 4, 1, 1, 5, 0,
			0, 5, 1, 2, 8, 2, 1, 5, 0, 0,
			0, 0, 5, 2, 8, 2, 5, 0, 0, 0,
			0, 0, 0, 3, 8, 3, 0, 0, 0, 0,
			0, 0, 0, 0, 3, 0, 0, 0, 0, 0
		},
		-- 5-7
		{
			0, 0, 0, 0, 1, 1, 0, 0, 0, 0,
			0, 0, 0, 0, 1, 1, 0, 0, 0, 0,
			0, 3, 5, 3, 1, 1, 3, 5, 3, 0,
			0, 3, 8, 3, 4, 4, 3, 8, 3, 0,
			0, 3, 8, 3, 4, 4, 3, 8, 3, 0
		},
		-- 5-8
		{
			6, 6, 6, 6, 5, 5, 6, 6, 6, 6,
			0, 2, 2, 8, 6, 6, 8, 2, 2, 0,
			0, 0, 2, 8, 6, 6, 8, 2, 0, 0,
			0, 0, 0, 8, 6, 6, 8, 0, 0, 0,
			0, 0, 0, 8, 6, 6, 8, 0, 0, 0
		},
		-- 5-9
		{
			0, 3, 2, 6, 6, 6, 6, 2, 3, 0,
			0, 3, 2, 5, 8, 8, 5, 2, 3, 0,
			0, 0, 2, 5, 8, 8, 5, 2, 0, 0,
			0, 0, 0, 5, 8, 8, 5, 0, 0, 0,
			0, 0, 0, 5, 8, 8, 5, 0, 0, 0
		},
		-- 5-10
		{
			6, 8, 6, 5, 5, 5, 5, 6, 8, 6,
			4, 8, 4, 1, 1, 1, 1, 4, 8, 4,
			4, 8, 4, 1, 1, 1, 1, 4, 8, 4,
			4, 8, 4, 3, 3, 3, 3, 4, 8, 4,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		}
	},
	{
		-- 6-1
		{
			0, 0, 1, 7, 1, 1, 7, 1, 0, 0,
			0, 0, 1, 7, 1, 1, 7, 1, 0, 0,
			0, 0, 1, 7, 1, 1, 7, 1, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 6-2
		{
			3, 2, 3, 2, 3, 2, 3, 2, 3, 0,
			2, 1, 2, 1, 2, 1, 2, 1, 2, 0,
			0, 1, 0, 1, 0, 1, 0, 1, 0, 0,
			0, 7, 0, 7, 0, 7, 0, 7, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 6-3
		{
			1, 7, 3, 3, 7, 7, 3, 3, 7, 1,
			1, 7, 3, 3, 7, 7, 3, 3, 7, 1,
			1, 7, 3, 3, 7, 7, 3, 3, 7, 1,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 6-4
		{
			3, 7, 7, 7, 2, 2, 7, 7, 7, 3,
			3, 7, 7, 2, 0, 0, 2, 7, 7, 3,
			3, 7, 2, 0, 0, 0, 0, 2, 7, 3,
			3, 2, 0, 0, 0, 0, 0, 0, 2, 3,
			2, 0, 0, 0, 0, 0, 0, 0, 0, 2
		},
		-- 6-5
		{
			1, 2, 3, 7, 7, 7, 7, 3, 2, 1,
			1, 2, 3, 7, 7, 7, 7, 3, 2, 1,
			0, 0, 1, 2, 3, 3, 2, 1, 0, 0,
			0, 0, 1, 2, 3, 3, 2, 1, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 6-6
		{
			0, 0, 3, 7, 6, 6, 7, 3, 0, 0,
			0, 0, 3, 7, 3, 3, 7, 3, 0, 0,
			0, 0, 3, 7, 3, 3, 7, 3, 0, 0,
			0, 0, 3, 4, 3, 3, 4, 3, 0, 0,
			0, 0, 0, 4, 0, 0, 4, 0, 0, 0
		},
		-- 6-7
		{
			0, 6, 6, 0, 7, 7, 0, 6, 6, 0,
			0, 6, 6, 0, 7, 7, 0, 6, 6, 0,
			0, 4, 4, 8, 8, 8, 8, 4, 4, 0,
			0, 5, 5, 0, 1, 1, 0, 5, 5, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 6-8
		{
			0, 5, 7, 2, 1, 1, 2, 7, 5, 0,
			0, 5, 7, 2, 1, 1, 2, 7, 5, 0,
			0, 5, 7, 2, 1, 1, 2, 7, 5, 0,
			0, 3, 8, 8, 3, 3, 8, 8, 3, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 6-9
		{
			1, 2, 3, 8, 7, 7, 8, 3, 2, 1,
			1, 2, 3, 8, 7, 7, 8, 3, 2, 1,
			0, 2, 3, 8, 7, 7, 8, 3, 2, 0,
			0, 0, 3, 8, 7, 7, 8, 3, 0, 0,
			0, 0, 0, 8, 4, 4, 8, 0, 0, 0
		},
		-- 6-10
		{
			6, 6, 6, 6, 5, 5, 6, 6, 6, 6,
			5, 5, 5, 5, 7, 7, 5, 5, 5, 5,
			3, 3, 3, 3, 7, 7, 3, 3, 3, 3,
			1, 7, 7, 1, 7, 7, 1, 7, 7, 1,
			8, 4, 4, 8, 8, 8, 8, 4, 4, 8
		},
	}
}

-- Will crash if spawned - for dev use only.
Formation_Empty = {
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}

AlienShotConsts = {
	speed = 0.5,
	storeX = 300,
	storeY = 0,
	clrIndex = 0
}

function CreateAlienShot(shotParticle)
	return {
		x = AlienShotConsts.storeX,
		y = AlienShotConsts.storeY,
		w = 4,
		h = 4,
		speed = 0,
		countdown = 60,
		particle = shotParticle,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = AlienShotAni.sprites[1]
		},
		draw = function (self)
			if self.speed > 0 then
				spr(
					self.ani.currentFrame,
					self.x - 2,
					self.y - 2,
					AlienShotConsts.clrIndex)
			end
		end,
		update = function (self)
			if Player.status ~= PlayerStatuses.timestop then
				self.y = self.y + self.speed
			end

			if self.countdown > 0 then
				self.countdown = self.countdown - 1
			else
				self:shoot()
			end

			if self.speed > 0 then
				Animate(self, AlienShotAni)
			end
		end,
		shoot = function (self)
			if (AlienIndexesThatCanShootCount > 0) then
				-- Pick an alien
				local i = math.random(AlienIndexesThatCanShootCount)
				local formationPosition = AlienIndexesThatCanShoot[i]
				
				-- Shoot
				if self.speed == 0 then
					self.x = Aliens[formationPosition].x + 2
					self.y = Aliens[formationPosition].y + 8
					self.speed = AlienShotConsts.speed * AlienShotSpeedOptions[GameSettings.alienShotSpeed].value
				end
			end
		end,
		reset = function (self)
			self.x = AlienShotConsts.storeX
			self.y = AlienShotConsts.storeY
			self.speed = 0
			self.countdown = math.random(0, 180)
		end,
		collision = function (self)
			-- Check bottom of screen
			if self.y + self.h > GroundY then
				self.particle:enable(self.x, self.y)
				self:reset()
			end

			if Collide(self, SpecialWeaponBlock) then
				self.particle:enable(self.x, self.y)
				self:reset()
				SpecialWeaponBlock:takeDamage(1)
			end

			if Collide(self, Player) then
				if Player.active == true and Player.status ~= PlayerStatuses.shield then
					Player:die(false)
				end
				self:reset()
			end
		end
	}
end

function CreateAlienShotParticles()
	return {
		x = AlienShotConsts.storeX,
		y = AlienShotConsts.storeY,
		active = false,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = AlienShotParticleAni.sprites[1]
		},
		enable = function (self, x, y)
			self.active = true
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = AlienShotParticleAni.sprites[1]
		end,
		disable = function (self)
			self.active = false
			self.x = AlienShotConsts.storeX
			self.y = AlienShotConsts.storeY
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x - 2,
					self.y - 2,
					AlienShotConsts.clrIndex)
			end
		end,
		update = function (self)
			if self.active == true then
				AnimateOneshot(self, AlienShotParticleAni)
			end
		end
	}
end

AlienFactory = {
	function(i, j)
		return CreateAlienBase(i, j, AlienRedAni, PlayerWeapons.horizontal, StandardDieFunction)
	end,
	function(i, j)
		return CreateAlienBase(i, j, AlienBlueAni, PlayerWeapons.diagonal, StandardDieFunction)
	end,
	function(i, j)
		return CreateAlienBase(i, j, AlienGreenAni, PlayerWeapons.vertical, StandardDieFunction)
	end,
	function(i, j)
		return CreateShieldAlien(i, j)
	end,
	function(i, j)
		return CreateDiveAlien(i, j)
	end,
	function (i, j)
		return CreateBombAlien(i, j)
	end,
	function (i, j)
		return CreateDodgeAlien(i, j)
	end,
	function (i, j)
		return CreateSupportAlien(i, j)
	end
}

function CreateAlien(i, j, type)
	return AlienFactory[type](i, j)
end

ScreenTransitionConsts = {
	speed = 3
}

ScreenTransitionStates = {
	disabled = 0,
	animating = 1,
	complete = 2
}

CreateScreenTransition = function ()
	return {
		leadingPoint = 0,
		state = ScreenTransitionStates.disabled,
		textCountdown = 90,
		playingSound = {
			false,
			false,
			false
		},
		draw = function (self)
			if self.state ~= ScreenTransitionStates.disabled then
				local triangleBackX = self.leadingPoint - HalfScreenHeight

				tri(
					triangleBackX, 0,
					self.leadingPoint, HalfScreenHeight,
					triangleBackX, ScreenHeight,
					0
				)

				if triangleBackX > 0 then
					rect(
						0, 0,
						triangleBackX, ScreenHeight,
						0
					)
				end

				if self.textCountdown < 60 then
					if self.playingSound[1] == false then
						self.playingSound[1] = true
						sfx(soundEffects.uiDing)
					end
					PrintCustomCentred("zone", HalfScreenWidth, HalfScreenHeight - 8)
				end

				if self.textCountdown < 30 then
					if self.playingSound[2] == false then
						self.playingSound[2] = true
						sfx(soundEffects.uiDing)
					end
					PrintCustomCentred("cleared", HalfScreenWidth, HalfScreenHeight)
				end

				if self.textCountdown <= 0 then
					if self.playingSound[3] == false then
						self.playingSound[3] = true
						sfx(soundEffects.uiDing)
					end
					DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
				end
			end
		end,
		update = function (self)
			if self.state == ScreenTransitionStates.animating then
				self.leadingPoint = self.leadingPoint + ScreenTransitionConsts.speed

				if self.leadingPoint >= ScreenWidth + HalfScreenHeight then
					self.state = ScreenTransitionStates.complete
				end
			elseif self.state == ScreenTransitionStates.complete and self.textCountdown > 0 then
				self.textCountdown = self.textCountdown - 1
			end
		end,
		input = function (self)
			if self.state == ScreenTransitionStates.complete and btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				if CurrentStage > NumberOfStages then
					GameOver(ScriptGameOverGood, 3)
				else
					GameState = StateDialogue
					DialogueInit(
						ScriptStageInterludes[CurrentStage - 1],
						ScriptStageInterludesLengths[CurrentStage - 1],
						function()
							GameState = StatePlaying
							StartLevel(Formations[CurrentStage][CurrentLevel])
						end)
					Player:activateStatus(PlayerStatuses.shield, 180)
				end
			end
		end,
		start = function (self)
			self.state = ScreenTransitionStates.animating
			self.playingSound = {
				false,
				false,
				false
			}
		end,
		reset = function (self)
			self.state = ScreenTransitionStates.disabled
			self.leadingPoint = 0
			self.textCountdown = 90
		end
	}
end

DialogueAlienAnis = {
	worried = {
		frameDelay = 1,
		length = 1,
		sprites = { 80 }
	},
	wince = {
		frameDelay = 1,
		length = 1,
		sprites = { 112 }
	},
	nervousLaugh = {
		frameDelay = 1,
		length = 1,
		sprites = { 144 }
	},
	relief = {
		frameDelay = 1,
		length = 1,
		sprites = { 176 }
	}
}

DialogueHumanAnis = {
	determined = {
		frameDelay = 1,
		length = 1,
		sprites = { 82 }
	},
	cocky = {
		frameDelay = 1,
		length = 1,
		sprites = { 84 }
	},
	cry = {
		frameDelay = 30,
		length = 2,
		sprites = { 114, 116 }
	},
	pout = {
		frameDelay = 1,
		length = 1,
		sprites = { 146 }
	}
}

DialogueTextColours = {
	alien = 13,
	human = 10
}

DialogueIconLeft = {
	alien = false,
	human = true
}

DialogueConsts = {
	lineHeight = 16,
	lineGapHeight = 8
}

function CreateDialogueScreen(script, numberOfLines, columnWidth)
	local dialogueLines = {}

	for i = 1, numberOfLines do
		local lineText = script[i].text
		local lineAni = script[i].ani
		table.insert(dialogueLines, CreateDialogueLine(
			lineText,
			lineAni,
			GetLineY(i, numberOfLines),
			DialogueTextColours[script[i].speaker],
			DialogueIconLeft[script[i].speaker],
			columnWidth
			))
	end
	
	return {
		lines = dialogueLines,
		update = function (self)
			for index, line in pairs(self.lines) do
				line:update()
			end
		end,
		draw = function (self)
			for index, line in pairs(self.lines) do
				line:draw()
			end
		end
	}
end

function GetFirstLineOffset(numberOfLines)
	local totalLineHeight = DialogueConsts.lineHeight * numberOfLines
	local totalLineGapHeight = DialogueConsts.lineGapHeight * (numberOfLines - 1)
	local totalMarginAroundLines = ScreenHeight - totalLineHeight - totalLineGapHeight
	return totalMarginAroundLines / 2 
end

function GetLineY(lineNumber, numberOfLines)
	local firstLineOffset = GetFirstLineOffset(numberOfLines)
	local heightOfPreviousLines = (DialogueConsts.lineHeight + DialogueConsts.lineGapHeight) * (lineNumber - 1)
	return firstLineOffset + heightOfPreviousLines
end

function CreateDialogueLine(str, ani, y, textColour, iconLeft, columnWidth)
	local iconX, textX;
	if iconLeft then
		iconX = columnWidth
		textX = columnWidth + 16 + 4
	else
		local strWidth = print(str, 0, -30)
		iconX = ScreenWidth - columnWidth - 16
		textX = ScreenWidth - columnWidth - 16 - 4 - strWidth
	end

	return {
		iconX = iconX,
		textX = textX,
		y = y,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = ani.sprites[1]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.iconX,
				self.y,
				-1,
				1,
				0,
				0,
				2,
				2)
			print(str, self.textX, self.y + 6, textColour)
		end,
		update = function (self)
			Animate(self, ani)
		end
	}
end

ScriptIntro = {
	{
		text = "Help! Can anyone hear me?",
		ani = DialogueAlienAnis.worried,
		speaker = "alien"
	},
	{
		text = "Our drones are out of control!",
		ani = DialogueAlienAnis.worried,
		speaker = "alien"
	},
	{
		text = "Hah! They're no match for me!",
		ani = DialogueHumanAnis.cocky,
		speaker = "human"
	}
}

ScriptStageInterludes = {
	{
		{
			text = "So, uh.",
			ani = DialogueHumanAnis.pout,
			speaker = "human"
		},
		{
			text = "How many drones do you have?",
			ani = DialogueHumanAnis.pout,
			speaker = "human"
		},
		{
			text = "How would you feel if I said...",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		},
		{
			text = "...that they self replicate?",
			ani = DialogueAlienAnis.wince,
			speaker = "alien"
		}
	},
	{
		{
			text = "Whew, those ones are tough!",
			ani = DialogueHumanAnis.determined,
			speaker = "human"
		},
		{
			text = "They evolve when in danger!",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		},
		{
			text = "...You don't say.",
			ani = DialogueHumanAnis.pout,
			speaker = "human"
		}
	},
	{
		{
			text = "Are you holding up ok?",
			ani = DialogueAlienAnis.worried,
			speaker = "alien"
		},
		{
			text = "BOMBS!? REALLY!?",
			ani = DialogueHumanAnis.determined,
			speaker = "human"
		},
		{
			text = "I'll take that as a no.",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		}
	},
	{
		{
			text = "They're becoming desperate!",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		},
		{
			text = "You think?",
			ani = DialogueHumanAnis.determined,
			speaker = "human"
		},
		{
			text = "Cos I'm feeling the same!",
			ani = DialogueHumanAnis.pout,
			speaker = "human"
		},
		{
			text = "I believe in you!",
			ani = DialogueAlienAnis.relief,
			speaker = "alien"
		}
	},
	{
		{
			text = "Shields! How novel!",
			ani = DialogueAlienAnis.relief,
			speaker = "alien"
		},
		{
			text = "HEY! Don't congratulate them!",
			ani = DialogueHumanAnis.pout,
			speaker = "human"
		},
		{
			text = "They're definitely haywire.",
			ani = DialogueAlienAnis.worried,
			speaker = "alien"
		},
		{
			text = "But I'm still proud of them.",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		}
	}
}

ScriptStageInterludesLengths = {
	4,
	3,
	3,
	4,
	4
}

ScriptGameOverGood = {
	{
		text = "I think that was the last of them.",
		ani = DialogueAlienAnis.relief,
		speaker = "alien"
	},
	{
		text = "As if there was any doubt.",
		ani = DialogueHumanAnis.cocky,
		speaker = "human"
	},
	{
		text = "Thank you, overly cocky human.",
		ani = DialogueAlienAnis.nervousLaugh,
		speaker = "alien"
	}
}

ScriptGameOverBad = {
	{
		text = "We're done! We've got nothing left!",
		ani = DialogueHumanAnis.cry,
		speaker = "human"
	},
	{
		text = "I'm sorry, this is all my fault...",
		ani = DialogueAlienAnis.wince,
		speaker = "alien"
	}
}

PowerupIcons = {
	none = 0,
	scoreMultiplier = 94,
	shield = 95,
	timestop = 110
}

WeaponColours = {
	none = 0,
	vertical = 6,
	horizontal = 2,
	diagonal = 9,
	block = 13,
	drill = 7,
	mortar = 3,
	swarm = 14,
	bubble = 11
}

WeaponIconsSpriteIndexes = {
	none = 0,
	vertical = 124,
	horizontal = 125,
	diagonal = 140,
	block = 141,
	drill = 156,
	mortar = 157,
	swarm = 172,
	bubble = 173
}

ButtonIcons = {
	A = {
		tic = 12,
		pc = 250
	},
	B = {
		tic = 13,
		pc = 251
	},
	X = {
		tic = 14,
		pc = 252
	},
	Y = {
		tic = 15,
		pc = 253
	},
	arrow = {
		tic = 11,
		pc = 11
	}
}

function DrawButtonPrompt(buttonSpr, str, x, y)
	spr(buttonSpr[ButtonPromptsOptions[GameSettings.buttonPrompts].value], x, y, 0)
	print(": " .. str, x + 10, y + 2, 12)
end

CreateHeaderUi = function()
	return {
		y = 1,
		draw = function(self)
			spr(208, 1, self.y, 0, 1, 0, 0, 2, 1)
			PrintCustom("LIVES", 16, self.y)
			spr(210, 41, self.y, 0)
			print(Lives, 44, self.y + 1, 12)

			spr(208, ScreenWidth - 17, self.y, 0, 1, 1, 0, 2, 1)
			PrintCustomRightAligned("SCORE", ScreenWidth - 15, self.y)
			spr(210, ScreenWidth - 42, self.y, 0)
			PrintRightAligned(Score, ScreenWidth - 43, self.y + 1, 12)
		end
	}
end

CreatePowerupUi = function()
	return {
		x = 223,
		y = 98,
		currentIcon = PowerupIcons.none,
		flashing = false,
		draw = function(self)
			PrintCustom("PWR", self.x + 1, self.y - 8)

			spr(
				62,
				self.x,
				self.y,
				-1,
				1,
				0,
				0,
				2,
				2)

			if not self.flashing or time()%250>125 then
				spr(
					self.currentIcon,
					self.x + 4,
					self.y + 4,
					0
				)
			end
		end,
		setIcon = function(self, spriteIndex)
			self.currentIcon = spriteIndex
		end,
		setFlashing = function(self, isFlashing)
			self.flashing = isFlashing
		end
	}
end

CreateSpecialWeaponUi = function()
	return {
		x = 223,
		y = 42,
		draw = function(self)
			PrintCustom("SPW", self.x + 1, self.y - 8)

			spr(
				60,
				self.x,
				self.y,
				0,
				1,
				0,
				0,
				2,
				2
			)

			spr(
				92,
				self.x,
				self.y + 16,
				0,
				1,
				0,
				0,
				2,
				2
			)

			spr(
				62,
				self.x,
				self.y + 30,
				-1,
				1,
				0,
				0,
				2,
				2)

			if (Player.weaponPower > 0) then
				for i=1, Player.weaponPower do
					self:drawBlock(i)
				end

				if (Player.weaponPower == 4) then
					spr(
						WeaponIconsSpriteIndexes[Player.weaponType],
						self.x + 4,
						self.y + 35,
						0
					)
				end
			end
		end,
		drawBlock = function(self, i)
			local rectX = self.x + 2
			local rectY = self.y - 2 + i * 6
			rect(
				rectX,
				rectY,
				12,
				5,
				WeaponColours[Player.weaponType]
			)
		end
	}
end

CreateLevelUi = function()
	return {
		x = 1,
		y = 72,
		draw = function(self)
			-- Stage
			PrintCustom("ZNE", self.x + 1, self.y - 8)

			spr(
				62,
				self.x,
				self.y,
				-1,
				1,
				0,
				0,
				2,
				2)

			print(string.format("%02d", CurrentStage), self.x + 3, self.y + 6, 12)

			-- Level
			PrintCustom("WAV", self.x + 1, self.y + 18)

			spr(
				62,
				self.x,
				self.y + 26,
				-1,
				1,
				0,
				0,
				2,
				2)

			print(string.format("%02d", CurrentLevel), self.x + 3, self.y + 32, 12)
		end
	}
end

soundEffects = {
	explosionStandard = 0,
	laser = 1,
	missile = 2,
	explosionBig = 3,
	explosionBigAlt = 4,
	explosionEnergy = 5,
	missileMicro = 6,
	powerupTink = 7,
	powerup = 9,
	uiConfirm = 16,
	uiDing = 17,
	uiPause = 20,
	uiUnpause = 21
}

AlienRedAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 288, 289, 290, 291 },
	clrIndex = 12
}

AlienBlueAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 322, 323, 324, 325 },
	clrIndex = 12
}

AlienGreenAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 326, 327, 328, 329 },
	clrIndex = 12
}

AlienBombAni = {
	frameDelay = 20,
	length = 2,
	sprites = { 432, 433 },
	clrIndex = 12
}

AlienDiveAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 419, 420, 421, 422 },
	clrIndex = 12
}

AlienDodgeAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 448, 449, 450, 449 },
	clrIndex = 12
}

AlienDodgeReadyAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 457, 458, 459, 458 },
	clrIndex = 12
}

AlienDodgeEffectAni = {
	frameDelay = 5,
	length = 5,
	sprites = { 413, 429, 445, 461, 397 },
	clrIndex = 0
}

AlienShieldAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 400, 401, 402, 401 },
	clrIndex = 2
}

AlienShieldBrokenAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 416, 417, 418, 417 },
	clrIndex = 2
}

AlienSupportAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 464, 465, 466, 467 },
	clrIndex = 2
}

AlienSupportSkillAni = {
	frameDelay = 5,
	length = 5,
	sprites = { 470, 471, 472, 473, 474 }
}

AlienShotAni = {
	frameDelay = 5,
	length = 6,
	sprites = { 279, 280, 281, 282, 283, 284 }
}

AlienShotParticleAni = {
	frameDelay = 5,
	length = 3,
	sprites = { 285, 286, 287 }
}

AlienBombShotAni = {
	frameDelay = 1,
	length = 1,
	sprites = { 434 },
	clrIndex = 0
}

AlienBombBlastAni = {
	frameDelay = 5,
	length = 6,
	sprites = { 435, 436, 437, 438, 439, 440 },
	clrIndex = 0
}

CarrierAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 304, 306, 320, 306 }
}

SpecialWeaponBlockProjectileAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 411, 409, 407, 405}
}

SpecialWeaponBlockAni = {
	frameDelay = 1,
	length = 1,
	sprites = { 403 }
}

PlayerBubbleMissileAni = {
	frameDelay = 1,
	length = 1,
	sprites = { 475 }
}

SpecialWeaponBubbleAni = {
	frameDelay = 5,
	length = 2,
	sprites = { 476, 477 }
}

SpecialWeaponBubblePopAni = {
	frameDelay = 5,
	length = 3,
	sprites = { 492, 493, 494 }
}

SpecialWeaponDrillAni = {
	frameDelay = 5,
	length = 4,
	sprites = { 424, 425, 426, 427 }
}

PlayerMissileAni = {
	frameDelay = 1,
	length = 1,
	sprites = { 344 }
}

PlayerMissileExhaustAni = {
	frameDelay = 5,
	length = 2,
	sprites = { 360, 361 }
}

PlayerMissileLinearBurstAni = {
	frameDelay = 2,
	length = 6,
	sprites = { 480, 496, 499, 502, 505, 508 }
}

PlayerMissileDiagonalBurstAni = {
	frameDelay = 3,
	length = 5,
	sprites = { 330, 332, 334, 366, 302 }
}

PlayerMortarAni = {
	frameDelay = 1,
	length = 1,
	sprites = { 441 }
}

PlayerMortarFragmentAni = {
	frameDelay = 1,
	length = 1,
	sprites = { 442 }
}

SpecialWeaponSwarmAni = {
	frameDelay = 1,
	length = 1,
	sprites = { 460 }
}

ExplosionAni = {
	frameDelay = 5,
	length = 5,
	sprites = { 274, 275, 276, 277, 278 }
}

PlayerExplosionAni = {
	frameDelay = 5,
	length = 5,
	sprites = { 292, 294, 296, 298, 300 }
}

PlayerRightAni = {
	frameDelay = 5,
	length = 3,
	sprites = { 336, 338, 340 }
}

PlayerLeftAni = {
	frameDelay = 5,
	length = 3,
	sprites = { 340, 338, 336 }
}

PlayerDeadAni = {
	frameDelay = 1,
	length = 1,
	sprites = { 342 }
}

PlayerShieldAni = {
	frameDelay = 1,
	length = 1,
	sprites = { 368 }
}

PlayerShieldEndAni = {
	frameDelay = 10,
	length = 7,
	sprites = { 368, 370, 372, 374, 376, 378, 380 }
}

PlayerShotAni = {
	frameDelay = 5,
	length = 2,
	sprites = { 272, 273 }
}

function PrintCentred(str, x, y, colour)
	local w = print(str, 0, -30)
    print(str, x-(w/2), y, colour)
end

function PrintCentredMonospace(str, x, y, colour)
	print(str, x - string.len(str) * 3, y, colour, true)
end

function PrintRightAligned(str, x, y, colour)
	local w = print(str, 0, -30)
	print(str, x-w, y, colour)
end

function PrintCustom(str, x, y)
	PrintCustomInternal(str, x, y)
end

function PrintCustomCentred(str, x, y)
	local totalWidth = string.len(str) * 5
	local firstCharX = x - totalWidth/2

	PrintCustomInternal(str, firstCharX, y)
end

function PrintCustomRightAligned(str, x, y)
	local totalWidth = string.len(str) * 5
	local firstCharX = x - totalWidth

	PrintCustomInternal(str, firstCharX, y)
end

function PrintCustomCentredDecorated(str, x, y)
	local totalWidth = string.len(str) * 5
	local firstCharX = x - totalWidth/2

	PrintCustomInternal(str, firstCharX, y)

	PrintCustomDecorationInternal(str, firstCharX, y)
end

function PrintCustomInternal(str, firstCharX, y)
	local stringUpper = str:upper()
	for i = 1, #str do
		local customCharIndex = stringUpper:sub(i,i):byte() - 65 + 224

		spr(
			customCharIndex,
			firstCharX + (i - 1) * 5,
			y,
			0
		)
	end
end

function PrintCustomDecorationInternal(str, firstCharX, y)
	spr(208, firstCharX - 17, y, 0, 1, 0, 0, 2, 1)
	spr(208, firstCharX + string.len(str) * 5, y, 0, 1, 1, 0, 2, 1)
end

function Animate(gameObject, animation)
	gameObject.ani.delayCounter = gameObject.ani.delayCounter + 1

	if gameObject.ani.delayCounter > animation.frameDelay then
		local frame = gameObject.ani.currentCounter % animation.length
		gameObject.ani.currentCounter = frame + 1
		gameObject.ani.currentFrame = animation.sprites[gameObject.ani.currentCounter]
		gameObject.ani.delayCounter = 0
	end
end

function AnimateOneshot(gameObject, animation)
	gameObject.ani.delayCounter = gameObject.ani.delayCounter + 1

	if gameObject.ani.delayCounter > animation.frameDelay then
		gameObject.ani.currentCounter = gameObject.ani.currentCounter + 1

		if gameObject.ani.currentCounter > animation.length then
			gameObject:disable()
		else
			gameObject.ani.currentFrame = animation.sprites[gameObject.ani.currentCounter]
			gameObject.ani.delayCounter = 0
		end
	end
end

-- Anything needed to actually execute the game
Init()

-- <TILES>
-- 001:0000000000002200000221020002200200022002000220020001220200001101
-- 002:0000000022200222222022222120221122202200212022002020222210101111
-- 003:0000000000222022022220220221101202200002022000020222202201111011
-- 004:0000000022022200220222202102212020022020200220202202221011011100
-- 005:0000000022220222222202222211022122220220221102202222022011110110
-- 006:0000000000222200202222022012210220022002200220022002200210011001
-- 007:0000000022202200222022002120220022202200212022002020222210101111
-- 008:0000000002200000012200000022000000220000002200000221000001100000
-- 010:000000000cccc0000ccccc000cccccc00cccccc00cccccd00ccccd000dddd000
-- 011:00000000000cc00000cccc000cccccc0000cc000000cc000000cc00000000000
-- 012:0000000000777770077777700660006006666660066000600660006000000000
-- 013:0000000001111100011111100220002002222200022000200222220000000000
-- 014:000000000990009000990900000aa00000aa0a000aa000a00aa000a000000000
-- 015:0000000003300030003303000004400000044000000440000004400000000000
-- 016:0000222200022222002222220222221103333100022220000333333303333111
-- 017:2220222222202222222022221220222203303333022022223330333313303333
-- 018:0000000200000002000000020000000100000000000000000000000000000000
-- 019:2222222222222222222222221122221100333300002222000033330000333300
-- 020:2000022220002222200222221022222100333310002222000033333300333311
-- 021:2222022222220222222202221111022200000333000002223333033311110333
-- 022:2222000022222000222222002112222030013330200012203000033030000330
-- 023:0000222200022222002222220222221103333100022220000333333303333111
-- 024:2220222222202222222022221220111203300003022000023330000313300003
-- 025:2222220222222202222222022221110133300000222000003330000033300000
-- 026:2222222222222222222222221122221100333300002222000033330000333300
-- 027:2000022220002222200222221022222100333310002222000033333300333311
-- 028:2222000022220002222200221122022200330333002202223333033311330333
-- 029:2222222022222220222222202111111030000000200000003000000030000000
-- 030:2222000022220000222200002222000033330003222200223333333333331111
-- 031:2202222022022220220222202202222033033330210222201003333030033330
-- 032:0333300003333000033330000333300003333000033330000111100000000000
-- 033:0330333303303333033033330330333303303333033033330110111100000000
-- 034:0000000000000000000000000000000033333303333333031111110100000000
-- 035:0033330000333300003333000033330033333333333333331111111100000000
-- 036:0033330000333300003333000033330030333333303333331011111100000000
-- 037:0000033300000333000003330000033333330333333303331111011100000000
-- 038:3000033030000330300003303000033030000330300003301000011000000000
-- 039:0333300003333000033330000333300003333000033330000111100000000000
-- 040:0330000303300003033000030330000303300003033000030110000100000000
-- 041:3330000033300000333000003330000033300000333000001110000000000000
-- 042:0033330000333300003333000033330000333300003333000011110000000000
-- 043:0033330000333300003333000033330000333300003333000011110000000000
-- 044:0033033300330333003303330033033300330333003303330011011100000000
-- 045:3000000030000000300000003000000033333330333333301111111000000000
-- 046:3333000033330000333300003333000033330000333300001111000000000000
-- 047:3303333033011110330000003300000033033330330333301101111000000000
-- 048:6666666677777777f1f1f1f17777777777777777777777777777777777777777
-- 049:6666666677777777f1f1f1f17777777777777777777777777777777777777777
-- 050:6666666677777777f1f1f1f17777777777777777777777777777777777777777
-- 051:6666666677777777f1f1f1f17777777777777777777777777777777777777777
-- 052:6666666677777777f1f1f1f17777777777777777777777777777777777777777
-- 053:6666666677777777f1f1f1f17777777777777777777777777777777777777777
-- 055:0000000000000000000000000002222200022222000222220002222200022222
-- 056:0000000000000000000000002222222222222222222222222222222222222222
-- 057:0000000000000000000000002222200022222000222220002222200022222000
-- 059:00000000000bb000099999900222222021111112021111200022220000000000
-- 060:666666666cc6ccc6666666666000000060000000600000006000000060000000
-- 061:6666666666060606666666660000000600000006000000060000000600000006
-- 062:666666666ccccccc666666666000000060000000600000006000000060000000
-- 063:6666666666060606666666660000000600000006000000060000000600000006
-- 064:f1f1f1f177777777666666667777777700440044044004407777777777777777
-- 065:f1f1f1f177777777666666667777777700440044044004407777777777777777
-- 066:f1f1f1f177777777666666667777777777ffff77760000f7760220f7760110f7
-- 067:f1f1f1f177777777666666667777777777ffff77760000f7760220f7760110f7
-- 068:f1f1f1f177777777666666667777777777777777777777777777777777777777
-- 069:f1f1f1f177777777666666667777777777777777777777777777777777777777
-- 070:6666666677777777f1f1f1f17777777777777777777777777777777777777777
-- 071:6662222277622222f762222217622222f762222217622222f761111117611111
-- 072:2222222222222222222222222222222222222222222222221111111111111111
-- 073:2222266622222677222226712222267f222226712222267f111116711111167f
-- 074:6666666677777777f1f1f1f17777777777777777777777777777777777777777
-- 075:0000200000001000000010000000100000011000000010000001100000001000
-- 076:6000000060000000600000006000000060000000600000006000000060000000
-- 077:0000000600000006000000060000000600000006000000060000000600000006
-- 078:6000000060000000600000006000000060000000600000006000000066666666
-- 079:0000000600000006000000060000000600000006000000060000000666666666
-- 080:222f22222f2ffffd222fffddfffffddd2ffff11d2ffff0dd2ffff0cd2ffffe0d
-- 081:2222f222dddff2f2ddddd2221dddddffd111ddf2dd00ddf2dc00ddf2d00eadf2
-- 082:666666666ccc6cc6666666666000201160011201600111206001111f6001110c
-- 083:666666666606060666666666111110061111100611001006faaa00060fa00006
-- 084:666666666ccc6cc6666666666002011160112011601120116011000a6011a0c0
-- 085:666666666606060666666666111100061111000600110006aa000006a0c00006
-- 086:f1f1f1f177777777666666667777777700440044044004407777777777777777
-- 087:f761100077611200666011207776011200776011044776017777776077777776
-- 088:0000000000000000000000000000000022222222111111111111111100000000
-- 089:0001167100211677021106662110677711067744106774400677777767777777
-- 090:f1f1f1f177777777666666667777777700440044044004407777777777777777
-- 091:001111000001100000011000001111000011010000101100001f010000100100
-- 092:6000000060000000600000006000000060000000600000006000000060000000
-- 093:0000000600000006000000060000000600000006000000060000000600000006
-- 094:0000ccc00000ccccc0c0777c7c7000c7c7c00c707070cccc0000cccc00007777
-- 095:0000000000cccc000b0000b00b0000b0b000000bb000000bb000000b0aaaaaa0
-- 096:2ffffded2ffffddd2fffffdd2fffffdcfffffffd222fffff2f2fffff222f2222
-- 097:deedaff2dddabaf2ddd1aff2cd111ff2d1111dffff111222fd11d2f22222f222
-- 098:601112ac601120aa601120aa6001120c60000010602222116222222166666666
-- 099:09900006999a2006aaaa2006caa2000600000006112220061112220666666666
-- 100:6112a0c96120aa996120aa8a61120aa860001000622211126222211166666666
-- 101:90c2000699a02006aaa02a068a020aa600000aa622200aa62222011666666666
-- 102:0001111100111111011111111110000011000000100111111011111111111111
-- 103:1111111111111111111111110000000000000000111111111111111111111111
-- 104:1111100011111100111111100000011100000011111110011111110111111111
-- 105:0000000010000100111111111111111111111111111001000001101100011011
-- 106:0000000000100000111011101110111111101111111000110000110100001100
-- 107:01010f1001001010010f01100110001001010f1001001010010f011001100010
-- 108:6000000060000000600000006000000066666666000000000000000000000000
-- 109:0000000600000006000000060000000666666666000000000000000000000000
-- 110:0044440004032040400400044204002442003024400000040402204000444400
-- 112:222f22222f2ffffd222fffddfffffddd2ffffddd2ffffdd12ffff1d12ffffe11
-- 113:2222f222dddff2f2ddddd222ddddddffddddddf2ddddddf2d1d11df2d11eddf2
-- 114:666666666ccc6cc6666666666000000060000111600120116011120160111201
-- 115:66666666660606066666666600000006110000061110aaa61111aaa61111aaa6
-- 116:666666666ccc6cc6666666666000000060000111600120116011120160111201
-- 117:6666666666060606666666660000000611000006111000061111000611110006
-- 118:1110000011000000100000001000000010011000101001001010010010100100
-- 119:0000000000000000011111111000000011111111100000001111111110000000
-- 120:0000011100000011111100010000100111111001000010011111100100001001
-- 121:0000000100000001000011010000001100111111000011110000001100000001
-- 122:0000000000000000011000001000000011111000111000001000000000000000
-- 123:1f010f0110001001110f0101101000111f010f0110001001110f010110100011
-- 124:000000000cccccc0000000000cccccc000000000000cc000000cc00000000000
-- 125:000000000c0000c00c0000c00c0cc0c00c0cc0c00c0000c00c0000c000000000
-- 126:ddddddddeeed1eeeeeeed111eeeeedddeeeeeeeeeeeeeeeeeeeeeeeeeee1eeee
-- 127:dddddddddeeeeeeedeeeeeeeeeeeeeeeeeeeeeeeeeee1deeeee1deee111deeee
-- 128:2ffffdee2fffffdd2fffffdd2ffffffdffffffff222fffff2f2fffff222f2222
-- 129:deeddff2dddddff2dddd1ff2cccd1ff2ddd111fff11112221111d2f22222f222
-- 130:601112016011120160111201601aa01161aaaa0061aaaa1161aaa11166666666
-- 131:11110aa611110116111101161110011600021116222111161221110666666666
-- 132:601112016011120160111201601aa01161aaaa0061aaaa1161aaa11166666666
-- 133:1111000611110006111100061110aa06000aaaa6222aaaa61222aaa666666666
-- 134:0000011100011100001100000110000101000011110021111002211110022111
-- 135:1110000000111000111111001111111011111110111111111111111111111111
-- 136:0000000000000000eeeeeeee010101010101010101010101eeeeeeee01010101
-- 140:000000000cc00cc00c0000c00c0000c00c0000c0000cc000000cc00000000000
-- 141:000000000ccc0cc00cc00cc00cc0ccc00cc0ccc00cc00cc00ccc0cc000000000
-- 142:eeed1ee1eeeed11d11111111ffffffffff2002ff0ff22ff000ffff00111ff111
-- 143:dddeeeeeeeeeeeee11111111ffffffffff2002ff0ff22ff000ffff00111ff111
-- 144:222f22222f2ffffd222fffddfffffddd2ffffdd12ffff11d2ffff0cd2ffff00d
-- 145:2222f222ddddf2f2ddddd222ddddddffd1ddddf2dd11ddf2d00cddf2d00eddf2
-- 146:666666666ccc6cc6666666666020111161120111611201106110aaaa611a000a
-- 147:666666666606060666666666111000061110000601100006a000000600000006
-- 148:0000000100000111000eeeee00ee111100e1e11101e11e1101e111e111e11111
-- 149:1110000011110000e11100001111f0001111f0001110f000111ff000110f0000
-- 150:1002111110001111010011110011111101000111e1111000ee11111100eee111
-- 151:11111111111111111111111011111100111000100001111e111111ee111eee00
-- 152:1111111111111111111111111111111111111111111111111111111111111111
-- 153:1111111111111111111111111111111111111111111111111111111111111111
-- 154:0000000011100000111111001111111111111111111111111111111111111111
-- 156:00000000000cc000000cc00000cc0c000000cc000cccc0c000000cc000000000
-- 157:000000000cc00cc00c0000c0000cc000000cc0000c0000c00cc00cc000000000
-- 158:ddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 159:ddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee1eeeeee1e1eeeeed1de
-- 160:2ffffeed2ffffddd2fffffdd2fffffddfffffffd222fffff2f2fffff222f2222
-- 161:deeddff2dddddff2cccdfff2ccddfff2ddd11ffff1111222d111d2f22222f222
-- 162:612a0c99620aa999620aaaaa6120aa8860010000602221116222111166666666
-- 163:0c20a906aa00aa96aa0aaaa6a02aaa9601111a06111110061111100666666666
-- 164:11e111111111111111111110011110ff000fff00000000010000001000000111
-- 165:10ff00000ff0f000ff0ff000f0ff00000fff0000fff000000100000011100000
-- 166:01000eee01111000011111110111111101111111011111110011111100000111
-- 167:eee0001000011110111111101111111011111110111111101111110011100000
-- 168:1111111110000000100000001000000010000000100000001011022010110000
-- 169:1111111100000000000000000000000000000000000000002202202200000000
-- 170:1111111111111111000111110000001100000001000000010220220100000001
-- 172:00000000000cc000000cc000000cc0000c0cc0c00c0cc0c00c0cc0c000000000
-- 173:00000000000cc00000c00c000c0cc0c00c0cc0c000c00c00000cc00000000000
-- 174:eeeeeeeeeeeeeeee11111111ffffffffff2002ff0ff22ff000ffff00111ff111
-- 175:1eeeedeedeeeeeee11111111ffffffffff2002ff0ff22ff000ffff00111ff111
-- 176:222f22222f2ffffd222fffddfffff11d2ffffddd2ffff0dd2ffff0cd2ffff00d
-- 177:2222f222dddff2f21dddd222d111ddffddddddf2dd00ddf2d0c0ddf2d00eddf2
-- 178:0000011100111000010000001000000011000000111110001111111111111111
-- 179:1110000000011100000000100000000100000011000111111111111111111111
-- 180:0111111010000001100000011111111111111111111111111111111111111111
-- 181:1111111110011001100110011001100110011001100110011001100110011001
-- 182:1111111111111111111111111111111111100111110000111100001111000011
-- 183:1100001111000011110000111100001111000011110000111100001111000011
-- 184:0000000000001111000100000010eee000101110010010100100111001001010
-- 185:00000000111100000000100000000100eee001001000001010eee01010111010
-- 186:dddddddddddddddd888888888999989989999899899988998999899988888888
-- 187:22222ddd22222ddd222228882222299922222999222228991111189911111888
-- 188:ddd22222ddd22222888222229992222299922222999222229981111188811111
-- 189:22222ddd22222dee22222eee22222eee22222eee222221ee11111d1e11111e1e
-- 190:ddddddddee1deeeeeedeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee1
-- 192:2ffffeed2ffffddd2fffffdd2fffffddfffffffd222fffff2f2fffff222f2222
-- 193:deeddff2dddddff2ddcd1ff2ccd11ff2dd111ffff11112221111d2f22222f222
-- 195:1000000010000000100000001100000011000000110000001110000011100000
-- 196:0000000100000001000000010000001100000011000000110000011100000111
-- 197:00000fff111111111111111100f0000011111111ffff00000000ffff00000000
-- 198:ffffffff1111111111111111000000001111111100000ffffffff00000000000
-- 199:1f1f1f1f1f1f1f1f111111111f1f1f1f1f1f1f1f111111111f1f1f1f10101010
-- 200:100011101000000010eeeeee1011111110100000010000000011100000000111
-- 201:1010100100111001e01010011011100110101001000000100001110011100000
-- 202:dddddddddddddddd11111111eeefeee11ff1f111e1eee1eef11111f1eeefeee1
-- 203:00011ddd00211ddd02110ff12110fee1110f111110feefee0ff1f111fee1eeef
-- 204:ddd11000ddd1120011f01120eeef0112ff11f011efeeef0111f1fff0eee1eeef
-- 205:00011e1e00211e1e021101112110ffff110ffff010ffff000ffff000ffff1111
-- 206:eeeeee1deeeee1de11111111ffffffffff2002ff0ff22ff000ffff00111ff111
-- 207:dde11000eee1120011101120ffff01120ffff01100ffff01000ffff01111ffff
-- 208:6600766076600766076600760076600760076600660076607770077700000000
-- 209:0766060000760600600706006600060076600600076606000077070000000000
-- 210:6000000060000000600000006000000060000000600000007000000000000000
-- 211:1111000011110000111110001111100011111100111111001111111011111110
-- 212:0000111100001111000111110001111100111111001111110111111101111111
-- 213:0000000000000000100000001000000011000000110000001110000011100000
-- 214:0000000000000000000000010000000100000011000000110000011100000111
-- 215:111111111001100110011001111111111ee11111100110011001100110011111
-- 223:ddd22222d1e22222ed122222eed22222eee22222eee22222ee11111111d11111
-- 224:0666000066660000667600006666000066760000660600007707000000000000
-- 225:6660000066660000667600006666000066760000666600007777000000000000
-- 226:0666000066660000667700006600000066000000666600007777000000000000
-- 227:6660000066660000667600006606000066060000666700007770000000000000
-- 228:6666000066660000667700006666000066770000666600007777000000000000
-- 229:6666000066660000667700006666000066770000660000007700000000000000
-- 230:0666000066660000667700006600000066060000666600007777000000000000
-- 231:6606000066060000666600006676000066060000660600007707000000000000
-- 232:6666000066660000766700000660000006600000666600007777000000000000
-- 233:6666000066660000777600000006000000060000666700007770000000000000
-- 234:6606000066060000666700006676000066060000660600007707000000000000
-- 235:6600000066000000660000006600000066000000666600007777000000000000
-- 236:6660000066660000666600006666000066660000667600007707000000000000
-- 237:6660000066660000667600006606000066060000660600007707000000000000
-- 238:0660000066660000667600006606000066060000666700007770000000000000
-- 239:6666000066660000667600006667000066700000660000007700000000000000
-- 240:0666000066660000667600006606000066060000666600007776000000000000
-- 241:6666000066660000667600006666000066670000667600007707000000000000
-- 242:0666000066660000667700006666000077760000666700007770000000000000
-- 243:6666000066660000766700000660000006600000066000000770000000000000
-- 244:6606000066060000660600006606000066060000766700000770000000000000
-- 245:6606000066060000660600006606000066060000666700007770000000000000
-- 246:6606000066660000666600006666000066660000666700007770000000000000
-- 247:6606000066060000766700000660000066760000660600007707000000000000
-- 248:6606000066060000666600007667000006600000066000000770000000000000
-- 249:6666000066660000777600000067000006700000666600007777000000000000
-- 250:000000000cccccc00cccccc00000cc00000cc00000cc00000cccccc000000000
-- 251:000000000cc000c000cc0c00000cc00000cc0c000cc000c00cc000c000000000
-- 252:0000000000ccccc00cccccc00cc000c00cccccc00cc000c00cc000c000000000
-- 253:0000000000ccccc00cccccc00cc000000cccccc0000000c00ccccc0000000000
-- </TILES>

-- <SPRITES>
-- 000:0076670007ffff707ffccff76ffccff66fccccf67cffffc707cccc7000766700
-- 001:00edde000e1111e0e11cc11ed1c11c1dd1c11c1de11cc11e0e1111e000edde00
-- 002:009aa90009888890988cc889a8c88c8aa8c88c8a9888888909888890009aa900
-- 003:004cc40004333340433cc334c3c33c3cc3cccc3c43cccc3404333340004cc400
-- 016:000330000003300000033000000440000004000000004000000c00000000c000
-- 017:0003300000033000000330000004400000004000000400000000c000000c0000
-- 018:0000000000000000000000000002200000022000000000000000000000000000
-- 019:0000000000222200022333200233332002333220022322000022200000000000
-- 020:0033330003344333334444433444444334444433344444303344433003333300
-- 021:0333030034430340343003303300000000000033330003433430343033303330
-- 022:0020000002200020200000000000000000000000000000002000002202000220
-- 023:000000000000000000000b000009a000000a900000b000000000000000000000
-- 024:000000000000000000000000000a9b0000b9a000000000000000000000000000
-- 025:00000000000000000000000000b9a000000a9b00000000000000000000000000
-- 026:000000000000000000b00000000a90000009a00000000b000000000000000000
-- 027:0000000000000000000b00000009a000000a90000000b0000000000000000000
-- 028:00000000000000000000b000000a90000009a000000b00000000000000000000
-- 029:00000000000000000000000000000000000aa000000000000000000000000000
-- 030:000000000000000000000000000aa00000a00a00000000000000000000000000
-- 031:00000000000b000000000a000a0000b000000000000000000000000000000000
-- 032:c333333c4333333442222224222002222220022212211221c21cc12c2cccccc2
-- 033:c333333c4333333442222224222002222220022212211221c21cc12cc2cccc2c
-- 034:c333333c4333333442222224222002222220022212211221c21cc12ccc2cc2cc
-- 035:c333333c4333333442222224222002222220022212211221c21cc12cc2cccc2c
-- 038:000000000000000000000000000000000000000000000aaa0000abbb000abbba
-- 039:000000000000000000000000000000000000000000000000a0000000a00aa000
-- 040:000000000000000000000aaa000aabbb00aabbbb00abbbba0abbbbaa0abbbbaa
-- 041:00000000000aaa0000abbba0a0abbbbaa0aabbbaa00abbbaa08aabbaa8a8aaaa
-- 042:00099900009aa99009aa99909aa998009a998000999800000990000000000a90
-- 043:000099900009aaa900009aa9090089a99a900999998008900900000000800000
-- 044:0099000009a990000a9000009900000090000000000000000000009000000a00
-- 045:000009a00000009a00a000090990000000000000000080000000000000000000
-- 046:0000000000000002000000230000002300000020000000000000000000000000
-- 047:2220022032000032300000022002200000002000000000000000000000222000
-- 048:333ccc33c2111322cccc3203ccc31220cc322c22c321ccc831cccccccccccccc
-- 049:33ccc3332231112c4023cccc02213ccc22c223cc8ccc123ccccccc13cccccccc
-- 050:c333cc33cc211322ccc13204ccc31220cc322c22cc21ccc8c31cccccc1cccccc
-- 051:33cc333c223112cc30231ccc02213ccc22c223cc8ccc12ccccccc13ccccccc1c
-- 052:0000000000000000000000aa00000abb00000aba00000aaa000000aa00000000
-- 053:000000000000000000000000aa000000abba0000aaba0000aaa0000000000000
-- 054:000abbaa000abaaa000aaaaa000aaabb08a0abbb0abbaabb0abaaaaa008aaaaa
-- 055:a0abba00a0abbba008aabba08aaaaba0baaaaaa0baaba000a8abba0080aa8000
-- 056:0abbbaaa00aaaaba0a8aabbaaba8a8aaabba8abbabaa8aab0aaa0aaa00a000aa
-- 057:8ab00aa08ab008008aa8abaa8a8abbbaa88abbbaa88aabaaa8aaaaa0000aa000
-- 058:0000aa800000a900090090099a90009a99800099090000080000000000000000
-- 059:08000090000009a90000099a9000999080000900008800000008000000000000
-- 060:0000a9000000000a9a0000000900000000000000000000000000000000000000
-- 061:000000a000000990900009000008000000000000000000000000000000000000
-- 062:0010000201000000000000000000000000002000000200000000000110000001
-- 063:0223320002332000000200000000000000000000100000001000000000000000
-- 064:cc333c33ccc21322ccc13203ccc31220cc322c22cc321cc8cc22ccccccc1cccc
-- 065:33c333cc22312ccc40231ccc02213ccc22c223cc8cc123cccccc22cccccc1ccc
-- 066:aaccccaa99aaaa99cc9009ccca9009aca989989a99c88c9989cccc98c8cccc8c
-- 067:aaccccaa99aaaa99cc9009cccca00accca9889acc998899cc89cc98ccc8cc8cc
-- 068:aaccccaa99aaaa99cca00accca9009acc998899cc898898ccc8cc8cccccccccc
-- 069:aaccccaa99aaaa99ca9009aca990099a9989989989c88c98c8cccc8ccccccccc
-- 070:ccc55ccccc5665cccc6006cccc6006cc5567765555f66f5555f77f5555c77c55
-- 071:ccc55ccccc5665cccc6006cccc6006ccc667755cc6f6655cc6fcc55cc6ccc55c
-- 072:ccc55ccccc5665cccc6006cccc6006ccc765567cc775577cc775577cc775577c
-- 073:ccc55ccccc5665cccc6006cccc6006ccc557766cc5566f6cc55ccf6cc55ccc6c
-- 077:00000000000000000000000000000000000000000000000000000000c0000000
-- 078:0000000000000000000000000000000000000000000000000000000000000004
-- 079:00000000000000000044400000ccc40004ccc400044c44004404400040000000
-- 080:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc2322b
-- 081:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccb2322ccc
-- 082:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc2232b
-- 083:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccb2232ccc
-- 084:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc3223b
-- 085:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccb3223ccc
-- 086:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1cccd
-- 087:ccccccccccccccccccccccccccccccccccccccccccccccccdccccccc0dc11ccc
-- 088:0003200000022000000cc000000cc000000cc0000ddccdd000dccd00000cc000
-- 090:0000000000000000000000000000000000cc000000cc00000000000000000000
-- 092:0000000c00000040000004400044440004cc000004c440000040000000000000
-- 094:0000004300000330003333300344330004444300344430000343300003300000
-- 096:cc2999b0cc1999abccc8888accc23223cc211111cc170000ccc1d0d0cccc1111
-- 097:0b9993ccba9991cca8888ccc22322ccc111113cc000071cc0d0d1ccc1111cccc
-- 098:cc3999b0cc1999abccc8888accc22322cc311111cc170000ccc1d0d0cccc1111
-- 099:0b9992ccba9991cca8888ccc32232ccc111112cc000071cc0d0d1ccc1111cccc
-- 100:cc2999b0cc1999abccc8888accc32232cc211111cc170000ccc1d0d0cccc1111
-- 101:0b9992ccba9991cca8888ccc23223ccc111112cc000071cc0d0d1ccc1111cccc
-- 102:cc1899d0cc188897ccc22889cc211288cc100122cc170011ccc1d070cccc1111
-- 103:777991cc778881cc78988ccc88882ccc822212cc211171cc17071ccc1111cccc
-- 104:0002200000234200002432000003200000020000000020000002000000002000
-- 105:0022220002243220022342200022320000002000000200000000200000020000
-- 110:0000000000000000000000000000000000000003000000030000000000000003
-- 111:0000000003333300344343004433443043333430334433303444433033444300
-- 112:000000000000000000000000000000000000cccc000c000000b000000b000000
-- 113:00000000000000000000000000000000cccc00000000c00000000b00000000b0
-- 114:000000000000000000000000000000000000cccc000c000000b000000b000000
-- 115:00000000000000000000000000000000cccc00000000c00000000b00000000b0
-- 116:000000000000000000000000000000000000cccc000c000000b000000b000000
-- 117:00000000000000000000000000000000cccc00000000c00000000b00000000b0
-- 118:000000000000000000000000000000000000cccc000c000000b000000b000000
-- 119:00000000000000000000000000000000cccc00000000c00000000b00000000b0
-- 120:000000000000000000000000000000000000cccc000c000000b0000000000000
-- 121:00000000000000000000000000000000cccc00000000c00000000b0000000000
-- 122:0000000000000000000000000000000000000ccc000000000000000000000000
-- 123:00000000000000000000000000000000ccc00000000000000000000000000000
-- 124:000000000000000000000000000000000000000c000000000000000000000000
-- 125:00000000000000000000000000000000c0000000000000000000000000000000
-- 126:0000000300220030020000000000300000033020203300222033022002000000
-- 127:0033300000000000000000000000000000000000000000000000000000000000
-- 128:0b000000b0000000b0000000b0000000b0000000b00000000aa00000000aaaaa
-- 129:000000b00000000b0000000b0000000b0000000b0000000b00000aa0aaaaa000
-- 130:0b000000b0000000b0000000b0000000b0000000b00000000aa00000000aaaa0
-- 131:000000b00000000b0000000b0000000b0000000b0000000b00000aa00aaaa000
-- 132:0b000000b0000000b0000000b0000000b0000000b00000000aa00000000a0000
-- 133:000000b00000000b0000000b0000000b0000000b0000000b00000aa00000a000
-- 134:0b000000b0000000b0000000b0000000b0000000000000000000000000000000
-- 135:000000b00000000b0000000b0000000b0000000b000000000000000000000000
-- 143:0100100001101100011111100111111001111110111111111111111101000010
-- 144:22dddd222dcdddd2dd88ddddd8008ddd8c00cdd888cc88882888888222888822
-- 145:22dddd222dcdddd2ddd88ddddd8008dd8dc00cd8888cc8882888888222888822
-- 146:22dddd222dcdddd2dddd88ddddd8008d8ddc00c88888cc882888888222888822
-- 147:244ccc99244ccc88233ddd00233dd800233d8800233dc800233ddc88233ddd22
-- 148:9999c4428888c442008cd33200cdd33200ddd33200ddd332888dd3322222d332
-- 149:44ccc99944ccc88833ddd80033dd880033d8880033dc880033ddc88833ddd222
-- 150:99999c4488888c440088cd33008cdd33008ddd33008ddd338888dd3322222d33
-- 151:222244cc222244cc222233dd222233dd222233dd222233dd222233dd222233dd
-- 152:cc442222cc442222dd332222dd332222dd332222dd332222dd332222dd332222
-- 153:2222244c2222244c2222233d2222233d2222233d2222233d2222233d2222233d
-- 154:c4422222c4422222d3322222d3322222d3322222d3322222d3322222d3322222
-- 155:2222224422222244222222332222223322222233222222332222223322222233
-- 156:4422222244222222332222223322222233222222332222223322222233222222
-- 157:0ddddddd0ddddddd0ddddddd0ddddddd0ddddddddddddddddddddddd0ddddddd
-- 158:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 159:dcddc000dccdcc00dcccccc0dcccccc0dcccccc0ccccccccccccccccdcddddc0
-- 160:22dddd222dcdddd2ddd88ddd288008dd28c00c8d228cc8222828882222222822
-- 161:22dddd222dcdddd2ddd88ddddd8008d228c00c82228cc8222288882228222282
-- 162:22dddd222dcdddd2ddd88dd2dd800822ddc00c82d28cc8822228822822282222
-- 163:cccccccc5cccccc55ccaacc565a00a566650056676688667c769967ccc7cc7cc
-- 164:5cccccc55cccccc565caac566650056676600667c768867ccc7997cccccccccc
-- 165:cc5cc5ccc65cc56c7665566776655667c766667cc768867cccc99ccccccccccc
-- 166:cccccccccc5cc5ccc65aa56c7665566776655667c766667cc769967ccccccccc
-- 167:ccccccccc5cccc5cc5caac5cc650056cc665566cc766667ccc7667ccccc77ccc
-- 168:cccaacccccc99ccccca99accc599995cc659956cc669966cc768867ccc7cc7cc
-- 169:cccaacccccc995ccc5a99accc59999ccc69955ccc68966ccc7c866cccccc77cc
-- 170:cccaaccccc5995ccc5a99a5cc699996cc695596cc786687cccc66cccccc77ccc
-- 171:cccaaccccc599ccccca99a5ccc99995ccc55996ccc66986ccc668c7ccc77cccc
-- 173:01dddddd00111ddd0111dddd011ddddd00111ddd000111dd111ddddd00111ddd
-- 174:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 175:dcddc000dccdcc00dcccccc0dcccccc0dcccccc0ccccccccccccccccdcddddc0
-- 176:ccc44ccccc4334cccc3003cc4c3003c431333313313223132c2112c2ccc22ccc
-- 177:ccc44ccccc4334cccc3003ccc530035cc333333cc332233cc221122cccc22ccc
-- 178:000000000001100000133100013c331001322310001221000001100000000000
-- 181:0000000000003000000330000003400000034300000443000004430000344300
-- 182:0003300000043000000440000004430000344300003443000034430000334300
-- 183:0002200000023000002332000023320000233200002232000020220000200220
-- 184:0002200000222000002022000020020000200200002000000000000000000000
-- 185:000220000023220000232200002222000001100000cddc0000cddc0000c00c00
-- 186:000000000000000000011000001c310000132100000110000000000000000000
-- 189:0000111100000011000001110000111100000011000000010000111100000011
-- 190:1ddddddd11111d11111ddddd1111d1dd11d1111d1111dddd111111dd1111dddd
-- 191:dcddc000dccdcc00dcccccc0dcccccc0dcccccc0ccccccccccccccccdcddddc0
-- 192:ccc33ccccc3333cccd3223dccd2dd2dcdee00eedeee00eeecee11eeccccccccc
-- 193:cc3cc3cccc3cc3cccd2dd2dccd2dd2dccee00eecdee00eede1e11e1ececcccec
-- 194:c3cccc3cc33cc33cc23dd32ccd2dd2dccee00eeccee00eecc1e11e1cceecceec
-- 195:0000000000000000000000000000000000000000000000000002200000022000
-- 196:0002200000032000000322000023220000233200002332000023320000233200
-- 197:0034430000344400034444000344443003444430034443300344433000343300
-- 198:0033430003433330033033300330033003000330030000300000000000000000
-- 199:0200002002000020020000000000000000000000000000000000000000000000
-- 201:ccccccccc33c33ccc33d33dcc22d22dcdeeee00deeeee00eceeee11ccccccccc
-- 202:c3cc3cccc33c33ccc23d23dccd2dd2dcceeee00cdeeee00de1eee11ececcccec
-- 203:cc3cc3cccc3cc3cccd2dd2dccd2dd2dcceeee00cceeee00cc1eee11cceecceec
-- 204:030000000c000000ccc000000d00000000000000000000000000000000000000
-- 206:0000111100000001000001110011111100000001000000000001111100000001
-- 207:1d11d0001dd1dd001dddddd01dddddd01dddddd0dddddddddddddddd1d1111d0
-- 208:222bb222c2bbbb2ccabbbbacc9abba9c299999922a9009a22980089228288282
-- 209:222bb2c222bbbbc22cbbbba22cabba922c999992a890098a9280082982288228
-- 210:222bb22222bbbb222abbcba229abca922999c9922a9009a22980089228288282
-- 211:2c2bb2222cbbbb222abbbbc229abbac2299999c2a890098a9280082982288228
-- 212:00aaaaaa0a000000a0000000a0000000b0000000b0000000b0000000b0000000
-- 213:aa00000000a00000000a0000000a0000000b0000000b0000000b0000000b0000
-- 214:00000000000000000b000000b0b00000b0b000000b0000000000000000000000
-- 215:000000000aa00000a00a0000a00a0000a00a0000a00a00000aa0000000000000
-- 216:09900000900900000aa00000aaaaaa00aaaaa0000a0000009009000009900000
-- 217:0000000000000000000000009999999099000000000000000000000000000000
-- 218:0000000000000000000000000000880800000000000000000000000000000000
-- 219:000aa00000acba0000acba0000abba00000aa000000cc00000dccd00000cc000
-- 220:00cccb000cbbaba0cbccbabacbccba9acabbaa9abbaaa9ac0ab99ac000aaac00
-- 221:00ccba000cbbaba0cbccba9acbccaa9acbccaa9ccbaaa9ac0bb99ac000aaaa00
-- 224:000000000000000000044000444cc400444cc400000440000000000000000000
-- 228:b0000000b00000000b00000000bccccc00000000000000000000000000000000
-- 229:000b0000000b000000b00000cb00000000000000000000000000000000000000
-- 236:00ccca000ca000a0ca00000accb0000accca00caabcbac9b0abbb9b000aaab00
-- 237:0000cc000c0000b0c000000ac0000000bb000000ab00000c0abc00b000aaa000
-- 238:00000c00000000b00000000000000000c0000000b00000000b00000000aa0000
-- 240:0000000000000000044444444ccccccc4ccccccc044444440000000000000000
-- 241:000000000000000040000440ccccccc4ccccccc4400004400000000000000000
-- 243:00000000000044400444ccc44ccccccc4ccccccc044444440000000000000000
-- 244:000000040000004c444444cccccccccccccccccc4444444c0000000400000000
-- 245:44400000ccc40000cccc4000cccc4000cccc4000cccc4000cccc400044440000
-- 246:0000000000000333033334433444443433444444003440030000000000000000
-- 247:00000004300000440003444c444444cc444444cc3344444c0000000400000000
-- 248:44444000ccccc400cccccc40cccccc40cccccc40cccccc40cccccc4044444400
-- 249:0000000000000000000022300022330000233333000020000000000000000000
-- 250:0330000033000000000333332333344433334003334400000000000000000000
-- 251:0333333034444333444444334444444344444443344444433444443303333330
-- 252:0000000000000002000000000000222000022222000000000000002200000002
-- 253:0000000000022200002022200220000200000000000200000220000022000000
-- 254:0220022022000022220000002203300002033300200330022200022202200020
-- </SPRITES>

-- <MAP>
-- 000:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005d00000000000000000000000000000000000000000000004c3d0000004c3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000893c000000000000000000000000000000000000000000004d895d00004d3d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000893d00004c3c00000000000000000000000000000000006d89893d006d89895d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:00000000000000000000001020304050607080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000089895d004d3d00000000000000000000000000000000004d8989895d4d89893d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:000000000000011121314151610000718191a1b1c1d1e1f100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002b3b00002b3b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000089893d8b9b895d0000000000000000000000000000006d89898b9b6d898989895d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:000000000000021222324252620000728292a2b2c2d2e2f20000000000000000000000b4000000000000000000000000000000000000000000000000000000004b004b00000000000000000000000000898900008989000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008c9c0000000000004c000000000000000000000000008c9c4d898989894c3c000000000000000000000000000000000000000000b400000000000000000000000000000000000000000000000000000000000000000000
-- 006:0000000000000000000000000000000000000000000000000000000000000000000000b5000000000000000000000000000000000000000000000000000000008900890000000000000000000000004c89893c4c89893c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004d3c000000003c0000008b9b0000000000000000004d3d000000000000000000000000000000000000000000b500000000000000000000000000000000000000000000000000000000000000000000
-- 007:0000000000000000000000000000000000000000000000000000000000000000000000b6000000000000000000000000000000000000000000000000004b00008900890000002b3b000000000000004d89893d4d89893d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008989008b9b6d893d000000003d0000008c9c0000000000000000000000000000000000000000000000000000000000000000b600000000000000000000000000000000000000000000000000000000000000000000
-- 008:0000000000000000000000000000000000000000000000000000000000000000000000b70000000000000000000000000000000000000000000000000089008989898989000089890000000000006d89898989898989895d00000000008989898989898900000000000000000000006878000000000000000000000000000000000000000000000000000000b400000000000000000000000089005b5b008c9c4d89895d00004c895d000000000000000000000000000000000000000000000000000000000000000000000000b700000000000000000000000000000000000000000000000000000000000000000000
-- 009:0000000000000000000000000000000000000000000000000000000000000000000000b70000000000000000000000000000000000000000000000000089005b5b895b5b5c6c5c6c5c6c5c6c5c6c89898989898989898999a900000000895b5b5b5b6b5b00000000000000000000006979000000000000000000008989008989000000000000000000000000b50000008900000000000000005b005b5b0000000000000000004d893d00000000000000000000000000000000000000007c0000007c00000000007c7c7c7c008999a9000000000000000000000000000000000000000000000000000000000000000000
-- 010:0000000000000000000000000000000000000000000000000000000000000000000066768600667686000000000000000000000000000000000000000089005b5b6b5b5b5c6c5c6c5c6c5c6c5c6c5b5b5b5b000000008a9aaa000000008989895b5b7b5b00495900004959000000896a7a898888888888888888885b5b885b5b888888888888888888888888b68889896b89898888888888885b885b5b88888888888888888889898988888888888988898888888888888888888888886b7c7c7c6b00008989005b5b5b5b008a9aaa000000000000000000000000000000000000000000000000000000000000000000
-- 011:00000000000000000000000000000000000000000000000000000000000000000000677787006777870096a60000000097a797a797a797a7000000000000005b5b7b5b5b0000000000000000000000000000000000000000000000000089998900000000004a5a00004a5a000000898989890000000000000000005b5b005b5b008999a90000000000000000b7005b5b7b5b5b0000000000005b005b5b00000000000000004c8989893d000000005b895b0000000000000000000000007b5b5b5b7b00005b5b000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:0000000000000000000000000000000000000000000000000000000000000000000066768600667686000000000000000097a797a797a7000000000000000000007b00000000000000000000000000000000000000000000000000000089998999a9000000000049590000495900898999999999a90000006c5c6c5b5b005b5b008a9aaa0000000000000000b70000000000000000000000005b005b5b00000000000000004d898989895d0000005b6b5b00000000000000007c7c7c00000000000000005b5b7c7c7c007c7c7c7c7c000000000000000000000000000000000000000000000000000000000000000000
-- 013:00000000000000000000000000000000000000000000000000000000000000000000677787006777870096a60000000097a797a797a797a7000000000000000000000000000000000000000000000000000000000000000000000000008a9a9a9aaa00000000004a5a00004a5a008a9a9a9a9a9aaa0000000000000000000000000000000000000000000000000000000000000000000000005b005b5b00000000000000000000000000000000005b7b5b00000000000000007d7d7d000000000096a6005b5b7b7b7b007d7d7d7d7d000000000000000000000000000000000000000000000000000000000000000000
-- 014:000000000000000000000000000000000000000000000000000000000000838393a300000000000000000000000000000000000000000000637383838383930000000000000000000000000000000000000000000000007383838383930000000000000000000000000000000000000000000000007383838383930000000000000000000000000000000000000000000000007383838383930000000000000000000000000000000000000000000000007383838383937c7c7c000000000000000000000000000000000000000000738383000000000000000000000000000000000000000000000000000000000000
-- 015:000000000000000000000000000000000000000000000000000000000000848494a403134353233343534353434353435343233353430313647484848484940313435343534353233343534353233343534353435303137484848484dbf9e9e9e9e9e7f7e9e9ebe9e9e9e9f9e9e9ebe9e9e9e9e9f9fd84848484dbe7f7e9e9f9e7f7e9e9e9e9e9e9ebe9e7f7f9e9e9e9e9e9e9fd84848484bbababababababababababababababababababababababababcb84848484bbababababababababababababababababababababababababcb8484000000000000000000000000000000000000000000000000000000000000
-- 016:000000000000000000000000000000000000000000000000000000000000858595a504144454243444544454444454445444243454440414657585858585950414445444544454243444544454243444544454445404147585858585dcfaeaeaeaeae8f8eaeaeceaeaeaeafaeaeaeceaeaeaeaeafafc85858585dce8f8eaeafae8f8eaeaeaeaeaeaeceae8f8faeaeaeaeaeaeafc85858585bcacacacacacacacacacacacacacacacacacacacacacacacaccc85858585bcacacacacacacacacacacacacacacacacacacacacacacacaccc8585000000000000000000000000000000000000000000000000000000000000
-- 031:000000000000000000000000000000000000000000000000000000000000838393a30000000000000000000000000000000000000000000063738383838393000000000000000000000000000000000000000000000000738383838393000000000000000000000000000000000000000000000000738383838393000000000000000000000000000000000000000000000000738383838393000000000000000000000000000000000000000000000000738383838393000000000000000000000000000000000000000000000000738383000000000000000000000000000000000000000000000000000000000000
-- 032:000000000000000000000000000000000000000000000000000000000000848494a403134353233343534353434353435343233353430313647484848484940313435343534353233343534353233343534353435303137484848484dbf9e9e9e9e9e7f7e9e9ebe9e9e9e9f9e9e9ebe9e9e9e9e9f9fd84848484dbe7f7e9e9f9e7f7e9e9e9e9e9e9ebe9e7f7f9e9e9e9e9e9e9fd84848484bbababababababababababababababababababababababababcb84848484bbababababababababababababababababababababababababcb8484000000000000000000000000000000000000000000000000000000000000
-- 033:000000000000000000000000000000000000000000000000000000000000858595a504144454243444544454444454445444243454440414657585858585950414445444544454243444544454243444544454445404147585858585dcfaeaeaeaeae8f8eaeaeceaeaeaeafaeaeaeceaeaeaeaeafafc85858585dce8f8eaeafae8f8eaeaeaeaeaeaeceae8f8faeaeaeaeaeaeafc85858585bcacacacacacacacacacacacacacacacacacacacacacacacaccc85858585bcacacacacacacacacacacacacacacacacacacacacacacacaccc8585000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:030003b00390030003000300336083d0b360d300d30063008300a300b300b300c300c300d300d300d300d300d300e300e300e300e300e300e300f300185000004500
-- 001:0230129042508300b300c300d300d300d300e300e300e300e300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300300000000000
-- 002:83c0739063705350434043304320431043105310530063007300830093009300a300b300c300d300d300d300e300e300e300e300f300f300f300f300404000000000
-- 003:03f003b0037003500320031013101310134023d02310330033004300430053006300730083009300a300b300c300d300d300e300e300e300e300f300280000007400
-- 004:03f003c003a003800360035003401350135023603370439053c063e073f083f093f0a3f0b3f0c3f0d3f0d3f0e3f0e3f0e3f0e3f0e3f0f3f0f3f0f3f018b000000000
-- 005:029002f002500220030003000320136023a033004300630073009300a300b300c300c300d300d300d300e300e300e300f300f300f300f300f300f300207000005400
-- 006:93d07380634063206310730083009300a300b300c300c300d300d300e300e300f300f300f300f300f300f300f300f300f300f300f300f300f300f300484000000000
-- 007:6000b000d000e000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000408000000000
-- 008:50108020a040b090c0f0d0f0e0f0e0f0f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000400000000000
-- 009:40209030d050407090b0d0e0e0e0f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000305000000000
-- 016:5210a220d240e270e2a0c24052408270b2f0d240e200e200e200e200e200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200300000005400
-- 017:6230a240c250d260e280e2a0f2c0f2d0f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200300000000000
-- 020:72f072f072e072e072d082c082b092a0a280c260e230e200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200205000000000
-- 021:82008200821082208230824092609290a2d0c2f0d2f0e200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200205000000000
-- </SFX>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f4d67db6ba2495302c34
-- </PALETTE>

