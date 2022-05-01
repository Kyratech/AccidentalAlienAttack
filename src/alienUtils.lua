function SetUpAliens(formation)
	local alienCountX = 10
	local alienCountY = 5

	MaxAliens = 0

	-- Aliens count towards level completion, move normally, and can shoot
	Aliens = {}
	LiveAliens = 0
	-- Special aliens only count towards level completion (e.g. diving aliens)
	SpecialAliens = {}
	LiveSpecialAliens = 0

	-- These aliens can shoot normal shots
	AlienIndexesThatCanShoot = {}
	AlienIndexesThatCanShootCount = 0
	-- These aliens can shoot bombs
	AlienIndexesThatCanShootBombs = {}
	AlienIndexesThatCanShootBombsCount = 0

	for j = 1, alienCountY, 1 do
		for i = 1, alienCountX, 1 do
			local formationPosition = i + (j - 1) * alienCountX
			local alienType = formation[formationPosition]

			if alienType ~= 0 then
				local alien = CreateAlien(i, j, alienType)
				Aliens[formationPosition] = alien
				MaxAliens = MaxAliens + 1
				LiveAliens = LiveAliens + 1

				if alienType == 6 then
					table.insert( AlienIndexesThatCanShootBombs, formationPosition )
					AlienIndexesThatCanShootBombsCount = AlienIndexesThatCanShootBombsCount + 1
				else
					table.insert( AlienIndexesThatCanShoot, formationPosition )
					AlienIndexesThatCanShootCount = AlienIndexesThatCanShootCount + 1
				end
			end
		end
	end
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
		AlienGlobalSpeed = CalculateAlienSpeed(MaxAliens, LiveAliens)
		if AlienGlobalVelocity > 0 then
			AlienGlobalVelocity = AlienGlobalSpeed
		else
			AlienGlobalVelocity = -AlienGlobalSpeed
		end
	end
end