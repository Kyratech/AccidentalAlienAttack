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