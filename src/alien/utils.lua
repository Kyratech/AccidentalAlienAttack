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

	PositionsThatCanBeDodgedInto[formationPosition] = true

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