GameSettings = {
	buttonPrompts = 1,
	alienSpeed = 4,
	alienShotSpeed = 3,
	alienDescentRate = 3,
	alienCarrierSpeed = 3,
	alienAttackRate = 3
}

function SaveGameSettings()
	local encodedInputSettings = EncodeInputSettings(GameSettings)
	local encodedGameplaySettings = EncodeGameplaySettings(GameSettings)

	pmem(GameSettingsMemoryIndexes.input, encodedInputSettings)
	pmem(GameSettingsMemoryIndexes.gameplay, encodedGameplaySettings)
end

function LoadGameSettings()
	local encodedInputSettings = pmem(GameSettingsMemoryIndexes.input)
	local encodedGameplaySettings = pmem(GameSettingsMemoryIndexes.gameplay)

	if encodedInputSettings ~= 0 and encodedGameplaySettings ~= 0 then
		local inputSettings = DecodeInputSettings(encodedInputSettings)
		local gameplaySettings = DecodeGameplaySettings(encodedGameplaySettings)

		GameSettings = {
			buttonPrompts = inputSettings.buttonPrompts,
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