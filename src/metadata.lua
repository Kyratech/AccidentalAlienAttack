-- title: Accidental alien attack!
-- author: KyraTech
-- desc: A clone of the atari space invaders game
-- script: lua

-- Global constants
BgColour = 0
TilePx = 8

ScreenWidth = 240
ScreenHeight = 136

LeftWallX = 22
RightWallX = 218
GroundY = 125

-- Button aliases
BtnUp = 0
BtnDown = 1
BtnLeft = 2
BtnRight = 3
BtnA = 4
BtnB = 5

-- Game states
StateTitle = 1
StatePlaying = 2
StateGameOver = 3
StateDialogue = 4

GameSettings = {
	buttonPrompts = "tic",
	baseAlienSpeed = 1,
	baseAlienShotSpeed = 1,
	baseAlienDescentRate = 1
}

function Init()
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
	end
end

function TitleLoop()
	TitleInput()
	TitleDraw()
end

OptionsMenuOpen = false

function TitleScreen()
	GameState = StateTitle

	MainMenu = CreateMenu(MainMenuOptions, MainMenuOptionsCount, MainMenuConsts, ScreenWidth / 2 - 20, 80)
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
	
		-- PrintCentred("Press A to start", 120, 70, 12)
		PrintCentred("A game by Kyratech", 120, 110, 2)
	end
end

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
	PlayerMissile = CreatePlayerMissile()
	PlayerMissileExhaust = CreatePlayerMissileExhaust()
	PlayerMissileBurstLeft = CreatePlayerMissileBurst()
	PlayerMissileBurstRight = CreatePlayerMissileBurst()

	AlienCarrier = CreateCarrier()

	CurrentStage = 1
	CurrentLevel = 1

	StartLevel(Formations[CurrentStage][CurrentLevel])

	AlienShots = {}
	local alienShotCount = 3
	for i = 0, alienShotCount, 1 do
		local alienShotParticle = CreateAlienShotParticles()
		local alienShot = CreateAlienShot(alienShotParticle)
		table.insert(AlienShots, alienShot)
	end

	Explosion = CreateExplosion()
	PlayerExplosionPrimary = CreateExplosion()
	PlayerExplosionSecondary = CreatePlayerExplosion()

	ShieldPowerup = CreateShieldPowerup()
	ExtraLifePowerup = CreateExtraLifePowerup()
	ScoreMultiplierPowerup = CreateScorePowerup()
	TimestopPowerup = CreateTimeStopPowerup()

	HeaderUi = CreateHeaderUi()
	PowerupUi = CreatePowerupUi()
	SpecialWeaponUi = CreateSpecialWeaponUi()
	LevelUi = CreateLevelUi()
end

function StartLevel(formation)
	-- Aliens
	Aliens = {}
	local alienCountX = 10
	local alienCountY = 5
	MaxAliens = 0
	LiveAliens = 0

	AlienGlobalRowsStepped = 0
	for i = 1, alienCountX, 1 do
		for j = 1, alienCountY, 1 do
			local index = i + (j - 1) * alienCountX
			local alienType = formation[index]

			if alienType ~= 0 then
				local alien = CreateAlien(i, j, alienType)
				table.insert(Aliens, alien)
				MaxAliens = MaxAliens + 1
				LiveAliens = LiveAliens + 1
			end
		end
	end
	
	-- How fast the aliens should move
	AlienGlobalSpeed = CalculateAlienSpeed(LiveAliens, LiveAliens)
	-- The actual translation of the aliens
	AlienGlobalVelocity = AlienGlobalSpeed

	AlienCarrier:prepare()
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
			PlayerMissile:shoot()
		end
	end
end

function Update()
	Player:update()
	Player:checkCollision()

	PlayerShot:update()
	PlayerShot:checkCollision()
	PlayerMissile:update()
	PlayerMissile:checkCollision()
	PlayerMissileBurstLeft:update()
	PlayerMissileBurstRight:update()
	PlayerMissileBurstLeft:checkCollision()
	PlayerMissileBurstRight:checkCollision()

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
		AlienShots[i].particle:update()
		AlienShots[i].particle:draw()
	end
end

function ScorePoints(x)
	local scoreIncrease = x
	if Player.status == PlayerStatuses.scoreMultiplier then
		scoreIncrease = scoreIncrease * 2
	end
	Score = Score + scoreIncrease
end

function KillAlien(i)
	Explosion:enable(Aliens[i].x, Aliens[i].y)

	table.remove(Aliens, i)
	LiveAliens = LiveAliens - 1

	if LiveAliens == 0 then
		EndLevel()
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
	PlayerMissile:draw()
	PlayerMissileBurstLeft:draw()
	PlayerMissileBurstRight:draw()
	PlayerShield:draw()
	AlienCarrier:draw()
	Explosion:draw()
	PlayerExplosionSecondary:draw()
	PlayerExplosionPrimary:draw()
	ShieldPowerup:draw()
	ScoreMultiplierPowerup:draw()
	ExtraLifePowerup:draw()
	TimestopPowerup:draw()
end

function DrawUi()
	HeaderUi:draw()
	PowerupUi:draw()
	SpecialWeaponUi:draw()
	LevelUi:draw()

	-- DrawDebug("Weapon: " .. Player.weaponType .. ". power: " .. Player.weaponPower)
	-- DrawMouseDebug()
end

function DrawDebug(text)
	print(text, 5, 11, 7)
end

function DrawMouseDebug()
	local x,y,left,middle,right,scrollx,scrolly = mouse()
	print("(" .. x .. "," .. y .. ")", 5, 21, 7)
end

function GameOverLoop()
	cls(BgColour)
	GoInput()
	GoUpdate()
	GoDraw()
end

function GameOver(script, numberOfLines)
	GameState = StateGameOver

	local columnWidth = 20

	DialogueObject = CreateDialogueScreen(script, numberOfLines, columnWidth)

	ScoreText = {
		text = "You scored " .. Score .. " points!",
		y = 110,
		draw = function (self)
			PrintCentred(self.text, 120, self.y, 12)
		end
	}

	RestartText = {
		text = "Press [A] to play again.",
		y = 120,
		draw = function (self)
			PrintCentred(self.text, 120, self.y, 12)
		end
	}
end

function GoInput()
	if btn(BtnA) then
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

function GoUpdate()
	DialogueObject:update()
end

function GoDraw()
	DialogueObject:draw()
	ScoreText:draw()
	RestartText:draw()
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

	DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 60, ScreenHeight - 8)
end

function ScrollOptionsH(self)
	if btnp(BtnLeft) then
		self.selectedOption = self.selectedOption - 1

		if self.selectedOption == 0 then
			self.selectedOption = self.optionsCount
		end
	end

	if btnp(BtnRight) then
		self.selectedOption = self.selectedOption + 1

		if self.selectedOption > self.optionsCount then
			self.selectedOption = 1
		end
	end

	if btnp(BtnA) then
		for i = 1, OptionsMenuOptionsCount do
			OptionsMenuOptions[i]:save()
		end
		OptionsMenuOpen = false
	end

	if btnp(BtnB) then
		OptionsMenuOpen = false
	end
end

MainMenuOptionsCount = 2
MainMenuOptions = {
	{
		draw = function(self, x, y)
			print("Start", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
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
			print("Options", x, y, 12)
		end,
		input = function(self)
			if btnp(BtnA) then
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

OptionsMenuOptionsCount = 4
OptionsMenuOptions = {
	{
		options = {
			{
				label = "TIC-80",
				value = "tic"
			},
			{
				label = "QWERTY",
				value = "pc"
			}
		},
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
			local currentValue = GameSettings.buttonPrompts

			for i = 1, self.optionsCount do
				if self.options[i].value == currentValue then
					self.selectedOption = i
				end
			end
		end,
		save = function (self)
			GameSettings.buttonPrompts = self.options[self.selectedOption].value
		end
	},
	{
		options = {
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
			},
		},
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
			local currentValue = GameSettings.baseAlienSpeed

			for i = 1, self.optionsCount do
				if self.options[i].value == currentValue then
					self.selectedOption = i
				end
			end
		end,
		save = function (self)
			GameSettings.baseAlienSpeed = self.options[self.selectedOption].value
		end
	},
	{
		options = {
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
		},
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
			local currentValue = GameSettings.baseAlienShotSpeed

			for i = 1, self.optionsCount do
				if self.options[i].value == currentValue then
					self.selectedOption = i
				end
			end
		end,
		save = function (self)
			GameSettings.baseAlienShotSpeed = self.options[self.selectedOption].value
		end
	},
	{
		options = {
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
		},
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
			local currentValue = GameSettings.baseAlienDescentRate

			for i = 1, self.optionsCount do
				if self.options[i].value == currentValue then
					self.selectedOption = i
				end
			end
		end,
		save = function (self)
			GameSettings.baseAlienDescentRate = self.options[self.selectedOption].value
		end
	}
}
OptionsMenuConsts = {
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
			end

			if btnp(BtnDown) then
				self.selectedOption = self.selectedOption + 1

				if self.selectedOption > menuOptionsCount then
					self.selectedOption = 1
				end
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

PlayerWeapons = {
	none = "none",
	vertical = "vertical",
	horizontal = "horizontal",
	diagonal = "diagonal"
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
		end,
		disable = function (self)
			self.active = false
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerDeadAni.sprites[1]
		end,
		respawn = function (self)
			self:activateStatus(PlayerStatuses.shield, PlayerConsts.respawnShieldLength)
			self:enable()
		end,
		die = function (self)
			self.deathTimer = 180
			PlayerExplosionPrimary:enable(Player.x + 1, Player.y)
			PowerupUi:setIcon(PowerupIcons.none)
			self:disable()
		end,
		getWeaponPower = function (self, weapon)
			if (self.weaponType ~= weapon) then
				self.weaponType = weapon
				self.weaponPower = 1
			elseif (self.weaponPower < 4) then
				self.weaponPower = self.weaponPower + 1
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

			-- Check aliens
			for i, alien in pairs(Aliens) do
				if Collide(self, Aliens[i]) then
					Player:getWeaponPower(Aliens[i].weaponType)
					KillAlien(i)

					ScorePoints(1)

					PlayerShot:reset()
				end
			end

			if Collide(self, AlienCarrier) then
				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				ScorePoints(5)

				PlayerShot:reset()
			end
		end,
		shoot = function (self)
			if self.speed == 0 then
				self.x = Player.x + 4
				self.y = Player.y
				self.speed = PlayerShotConsts.speed
			end
		end,
		reset = function (self)
			self.x = PlayerShotConsts.storeX
			self.y = PlayerShotConsts.storeY
			self.speed = 0
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

function CreatePlayerMissile()
	return {
		x = PlayerMissileConsts.storeX,
		y = PlayerMissileConsts.storeY,
		w = 2,
		h = 8,
		speed = 0,
		type = PlayerWeapons.none,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerMissileAni.sprites[1]
		},
		draw = function (self)
			if self.speed > 0 then
				spr(
					self.ani.currentFrame,
					self.x - 3,
					self.y,
					PlayerMissileConsts.clrIndex)

				PlayerMissileExhaust:draw()
			end
		end,
		update = function (self)
			self.y = self.y - self.speed

			if self.speed > 0 then
				Animate(self, PlayerMissileAni)

				PlayerMissileExhaust:update(self.x, self.y + 8)
			end
		end,
		checkCollision = function (self)
			-- Check off top of screen
			if self.y < 0 then
				self:reset()
			end

			-- Check aliens
			for i, alien in pairs(Aliens) do
				if Collide(self, Aliens[i]) then
					local alienY = Aliens[i].y;

					Player:getWeaponPower(Aliens[i].weaponType)
					KillAlien(i)

					ScorePoints(1)

					self:createBursts(alienY)
					self:reset()
				end
			end

			if Collide(self, AlienCarrier) then
				local alienY = AlienCarrier.y;

				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				ScorePoints(5)

				self:createBursts(alienY)
				self:reset()
			end
		end,
		shoot = function (self)
			if self.speed == 0 then
				self.x = Player.x + 4
				self.y = Player.y
				self.speed = PlayerMissileConsts.speed
				self.type = Player.weaponType
				Player.weaponType = PlayerWeapons.none
				Player.weaponPower = 0
			end
		end,
		reset = function (self)
			self.x = PlayerMissileConsts.storeX
			self.y = PlayerMissileConsts.storeY
			self.speed = 0

			PlayerMissileExhaust:update(self.x, self.y + 8)
		end,
		createBursts = function (self, alienY)
			if self.type == PlayerWeapons.vertical then
				PlayerMissileBurstLeft:enable(self.x - 3, alienY, 0, -2)
			elseif self.type == PlayerWeapons.horizontal then
				PlayerMissileBurstLeft:enable(self.x - 3, alienY, -2, 0)
				PlayerMissileBurstRight:enable(self.x - 3, alienY, 2, 0)
			elseif self.type == PlayerWeapons.diagonal then
				PlayerMissileBurstLeft:enable(self.x - 3, alienY, -1.4, -1.4)
				PlayerMissileBurstRight:enable(self.x - 3, alienY, 1.4, -1.4)
			end
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

function CreatePlayerMissileBurst()
	return {
		x = PlayerMissileBurstConsts.storeX,
		y = PlayerMissileBurstConsts.storeY,
		w = 8,
		h = 8,
		speedX = 0,
		speedY = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerMissileBurstAni.sprites[1]
		},
		enable = function (self, x, y, speedX, speedY)
			self.active = true
			self.x = x
			self.y = y
			self.speedX = speedX
			self.speedY = speedY
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerMissileBurstAni.sprites[1]
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
				AnimateOneshot(self, PlayerMissileBurstAni)
			end
		end,
		checkCollision = function (self)
			-- Check aliens
			for i, alien in pairs(Aliens) do
				if Collide(self, Aliens[i]) then
					Player:getWeaponPower(Aliens[i].weaponType)
					KillAlien(i)

					if Player.status == PlayerStatuses.scoreMultiplier then
						Score = Score + 2
					else
						Score = Score + 1
					end
				end
			end

			if Collide(self, AlienCarrier) then
				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				Score = Score + 5
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
			if self.y + self.h >= GroundY then
				if self.bounces < PowerupConsts.bounces then
					self.speed = -self.speed
					self.bounces = self.bounces + 1
				else
					self.speed = 0
				end

				self.y = GroundY - self.h
			end

			if Collide(self, Player) then
				collectionFunction()
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

AlienConsts = {
	width = 1,
	height = 1,
	clrIndex = 12
}

AlienSpeeds = {
	speedFull = 0.125,
	speedHalf = 0.25,
	speedQuarter = 0.5,
	speedFour = 1,
	speedOne = 2
}

AlienShotConsts = {
	speed = 0.5,
	storeX = 300,
	storeY = 0,
	clrIndex = 0
}

function CreateAlien(i, j, type)
	if type == 1 then
		return CreateBasicAlien(i, j, AlienRedAni, PlayerWeapons.horizontal)
	elseif type == 2 then
		return CreateBasicAlien(i, j, AlienBlueAni, PlayerWeapons.diagonal)
	elseif type == 3 then
		return CreateBasicAlien(i, j, AlienGreenAni, PlayerWeapons.vertical)
	end
end

function CreateBasicAlien(i, j, animation, specialWeapon)
	return {
		x = LeftWallX + 10 + (i - 1) * 16,
		y = -50 + (j - 1) * 10,
		w = AlienConsts.width * TilePx,
		h = AlienConsts.height * TilePx,
		weaponType = specialWeapon,
		column = i,
		row = j,
		targetY = 20 + (j - 1) * 10,
		hitWall = false,
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
				AlienConsts.clrIndex)
		end,
		update = function (self)
			self.targetY = 20 + AlienGlobalRowsStepped * 10 * GameSettings.baseAlienDescentRate + (self.row - 1) * 10

			if self.y > self.targetY then
				self.y = self.y - 1
			elseif self.y < self.targetY then
				self.y = self.y + 1
			elseif Player.status ~= PlayerStatuses.timestop then
				self.x = self.x + AlienGlobalVelocity
				self.hitWall = false
			end

			Animate(self, animation)
		end,
		checkCollision = function (self)
			if self.y + self.h >= GroundY then
				if Player.active == true and Player.status ~= PlayerStatuses.shield then
					Player:die()
					NewAlienGlobalRowsStepped = 0
				end
			elseif self.x + self.w > RightWallX then
				if self.hitWall == false then
					NewAlienGlobalRowsStepped = AlienGlobalRowsStepped + 1
					self.hitWall = true
				end
				NewAlienGlobalVelocity = -AlienGlobalSpeed
			elseif self.x < LeftWallX then
				if self.hitWall == false then
					NewAlienGlobalRowsStepped = AlienGlobalRowsStepped + 1
					self.hitWall = true
				end
				NewAlienGlobalVelocity = AlienGlobalSpeed
			end
		end
	}
end

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
			if (LiveAliens > 0) then
				-- Pick an alien
				local i = math.random(LiveAliens)
				
				-- Shoot
				if self.speed == 0 then
					self.x = Aliens[i].x + 2
					self.y = Aliens[i].y + 8
					self.speed = AlienShotConsts.speed * GameSettings.baseAlienShotSpeed
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

			if Collide(self, Player) then
				if Player.active == true and Player.status ~= PlayerStatuses.shield then
					Player:die()
					AlienGlobalRowsStepped = 0
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

function CalculateAlienSpeed(maxAliens, liveAliens)
	if liveAliens == 1 then
		return AlienSpeeds.speedOne * GameSettings.baseAlienSpeed
	elseif liveAliens <= 4 then
		return AlienSpeeds.speedFour * GameSettings.baseAlienSpeed
	elseif maxAliens // liveAliens == 1 then
		return AlienSpeeds.speedFull * GameSettings.baseAlienSpeed
	elseif maxAliens // liveAliens == 2 then
		return AlienSpeeds.speedHalf * GameSettings.baseAlienSpeed
	else
		return AlienSpeeds.speedQuarter * GameSettings.baseAlienSpeed
	end
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
				self.speed = CarrierConsts.speed
			else
				self.x = 240
				self.speed = -CarrierConsts.speed
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

NumberOfStages = 5
NumberOfLevelsPerStage = 2

Formations = {
	{
		{
			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
			0, 0, 0, 3, 3, 3, 3, 0, 0, 0
		},
		{
			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
			0, 0, 1, 1, 1, 1, 1, 0, 0, 0
		}
	},
	{
		{
			0, 2, 0, 2, 0, 0, 2, 0, 2, 0,
			2, 0, 2, 0, 2, 2, 0, 2, 0, 2,
			2, 0, 0, 2, 0, 0, 2, 0, 0, 2,
			2, 0, 0, 0, 0, 0, 0, 0, 0, 2,
			2, 0, 0, 0, 0, 0, 0, 0, 0, 2
		},
		{
			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		}
	},
	{
		{
			2, 0, 3, 3, 3, 3, 3, 0, 2, 0,
			2, 0, 3, 3, 3, 3, 0, 0, 2, 0,
			2, 0, 3, 3, 3, 0, 0, 0, 2, 0,
			2, 0, 3, 3, 0, 0, 0, 0, 2, 0,
			2, 0, 3, 0, 0, 0, 0, 0, 2, 0
		},
		{
			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
			0, 0, 1, 1, 3, 1, 1, 0, 0, 0
		}
	},
	{
		{
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			1, 2, 2, 2, 2, 2, 2, 2, 2, 1,
			1, 2, 2, 2, 2, 2, 2, 2, 2, 1,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		{
			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1, 0
		}
	},
	{
		{
			3, 2, 0, 0, 1, 1, 0, 0, 2, 3,
			3, 2, 2, 0, 1, 1, 0, 2, 2, 3,
			3, 0, 2, 2, 1, 1, 2, 2, 0, 3,
			3, 0, 0, 2, 2, 2, 2, 0, 0, 3,
			3, 0, 0, 0, 2, 2, 0, 0, 0, 3
		},
		{
			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
			1, 2, 3, 2, 1, 1, 2, 3, 2, 1
		}
	}
}

-- Will softlock if spawned - for dev use only.
Formation_Empty = {
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}

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
			text = "Less than you would fear.",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		},
		{
			text = "...More than you would hope.",
			ani = DialogueAlienAnis.wince,
			speaker = "alien"
		}
	},
	{
		{
			text = "These guys are getting stronger...",
			ani = DialogueHumanAnis.determined,
			speaker = "human"
		},
		{
			text = "It's part of their routines,",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		},
		{
			text = "To evolve when under threat.",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		}
	},
	{
		{
			text = "Are you holding up ok?",
			ani = DialogueAlienAnis.worried,
			speaker = "alien"
		},
		{
			text = "Never...better!",
			ani = DialogueHumanAnis.determined,
			speaker = "human"
		},
		{
			text = "I think I detect sarcasm...",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		}
	},
	{
		{
			text = "I think they're running out!",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		},
		{
			text = "When this is over...",
			ani = DialogueHumanAnis.determined,
			speaker = "human"
		},
		{
			text = "We're having a chat about this.",
			ani = DialogueHumanAnis.pout,
			speaker = "human"
		},
		{
			text = "Are you asking me on a date?",
			ani = DialogueAlienAnis.relief,
			speaker = "alien"
		}
	}
}

ScriptStageInterludesLengths = {
	4,
	3,
	3,
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
	},
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
	diagonal = 9
}

WeaponIconsSpriteIndexes = {
	none = 0,
	vertical = 124,
	horizontal = 125,
	diagonal = 140
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
	Y= {
		tic = 15,
		pc = 253
	}
}

function DrawButtonPrompt(buttonSpr, str, x, y)
	spr(buttonSpr[(GameSettings.buttonPrompts)], x, y, 0)
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

PlayerMissileBurstAni = {
	frameDelay = 2,
	length = 5,
	sprites = { 345, 346, 347, 348, 349 }
}

AlienRedAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 288, 289, 290, 291 }
}

AlienBlueAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 322, 323, 324, 325 }
}

AlienGreenAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 326, 327, 328, 329 }
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

CarrierAni = {
	frameDelay = 10,
	length = 4,
	sprites = { 304, 306, 320, 306 }
}

ExplosionAni = {
	frameDelay = 5,
	length = 5,
	sprites = { 274, 275, 276, 277, 278 }
}

PlayerExplosionAni = {
	frameDelay = 10,
	length = 5,
	sprites = { 292, 294, 296, 298, 300 }
}

function PrintCentred(str, x, y, colour)
	local w = print(str, 0, -30)
    print(str, x-(w/2), y, colour)
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
-- 108:6000000060000000600000006000000066666666000000000000000000000000
-- 109:0000000600000006000000060000000666666666000000000000000000000000
-- 110:0044440004032040400400044204002442003024400000040402204000444400
-- 112:222f22222f2ffffd222fffddfffffddd2ffffddd2ffffdd12ffff1d12ffffe11
-- 113:2222f222dddff2f2ddddd222ddddddffddddddf2ddddddf2d1d11df2d11eddf2
-- 114:666666666ccc6cc6666666666000000060000111600120116011120160111201
-- 115:66666666660606066666666600000006110000061110aaa61111aaa61111aaa6
-- 116:666666666ccc6cc6666666666000000060000111600120116011120160111201
-- 117:6666666666060606666666660000000611000006111000061111000611110006
-- 124:000cc00000cccc000cc00cc00c0cc0c0000cc000000cc00000000000000cc000
-- 125:0000000000c00c000cc00cc0cc0cc0cccc0cc0cc0cc00cc000c00c0000000000
-- 128:2ffffdee2fffffdd2fffffdd2ffffffdffffffff222fffff2f2fffff222f2222
-- 129:deeddff2dddddff2dddd1ff2cccd1ff2ddd111fff11112221111d2f22222f222
-- 130:601112016011120160111201601aa01161aaaa0061aaaa1161aaa11166666666
-- 131:11110aa611110116111101161110011600021116222111161221110666666666
-- 132:601112016011120160111201601aa01161aaaa0061aaaa1161aaa11166666666
-- 133:1111000611110006111100061110aa06000aaaa6222aaaa61222aaa666666666
-- 140:ccc00ccccc0000ccc00cc00c000cc000000cc000000cc00000000000000cc000
-- 144:222f22222f2ffffd222fffddfffffddd2ffffdd12ffff11d2ffff0cd2ffff00d
-- 145:2222f222ddddf2f2ddddd222ddddddffd1ddddf2dd11ddf2d00cddf2d00eddf2
-- 146:666666666ccc6cc6666666666020111161120111611201106110aaaa611a000a
-- 147:666666666606060666666666111000061110000601100006a000000600000006
-- 160:2ffffeed2ffffddd2fffffdd2fffffddfffffffd222fffff2f2fffff222f2222
-- 161:deeddff2dddddff2cccdfff2ccddfff2ddd11ffff1111222d111d2f22222f222
-- 162:612a0c99620aa999620aaaaa6120aa8860010000602221116222111166666666
-- 163:0c20a906aa00aa96aa0aaaa6a02aaa9601111a06111110061111100666666666
-- 176:222f22222f2ffffd222fffddfffff11d2ffffddd2ffff0dd2ffff0cd2ffff00d
-- 177:2222f222dddff2f21dddd222d111ddffddddddf2dd00ddf2d0c0ddf2d00eddf2
-- 192:2ffffeed2ffffddd2fffffdd2fffffddfffffffd222fffff2f2fffff222f2222
-- 193:deeddff2dddddff2ddcd1ff2ccd11ff2dd111ffff11112221111d2f22222f222
-- 208:6600766076600766076600760076600760076600660076607770077700000000
-- 209:0766060000760600600706006600060076600600076606000077070000000000
-- 210:6000000060000000600000006000000060000000600000007000000000000000
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
-- 080:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc2322b
-- 081:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccb2322ccc
-- 082:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc2232b
-- 083:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccb2232ccc
-- 084:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc3223b
-- 085:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccb3223ccc
-- 086:ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc1cccd
-- 087:ccccccccccccccccccccccccccccccccccccccccccccccccdccccccc0dc11ccc
-- 088:0003200000022000000cc000000cc000000cc0000ddccdd000dccd00000cc000
-- 089:000000000000000000000000000cc000000cc000000000000000000000000000
-- 090:0000000000040000004c400004ccc400044cc400004c40000000400000000000
-- 091:0003330003344430034444303344443033444443034444430333443000033000
-- 092:0220022022000022220000002203300000033300200330022200022202200020
-- 093:0100000100000000000000000000000000001100000010001000000000000001
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
-- 128:0b000000b0000000b0000000b0000000b0000000b00000000aa00000000aaaaa
-- 129:000000b00000000b0000000b0000000b0000000b0000000b00000aa0aaaaa000
-- 130:0b000000b0000000b0000000b0000000b0000000b00000000aa00000000aaaa0
-- 131:000000b00000000b0000000b0000000b0000000b0000000b00000aa00aaaa000
-- 132:0b000000b0000000b0000000b0000000b0000000b00000000aa00000000a0000
-- 133:000000b00000000b0000000b0000000b0000000b0000000b00000aa00000a000
-- 134:0b000000b0000000b0000000b0000000b0000000000000000000000000000000
-- 135:000000b00000000b0000000b0000000b0000000b000000000000000000000000
-- </SPRITES>

-- <MAP>
-- 005:000000000000000000000010203040506070800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:000000000000011121314151610000718191a1b1c1d1e1f1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:000000000000021222324252620000728292a2b2c2d2e2f2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:000000000000000000000000000000000000000000000000000000000000838393a30000000000000000000000000000000000000000000063738383000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:000000000000000000000000000000000000000000000000000000000000848494a40313435323334353435343435343534323335343031364748484000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:000000000000000000000000000000000000000000000000000000000000858595a50414445424344454445444445444544424345444041465758585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f4d67db6ba2495302c34
-- </PALETTE>

