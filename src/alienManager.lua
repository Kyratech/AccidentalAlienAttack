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

			-- These aliens can shoot normal shots
			AlienIndexesThatCanShoot = {}
			AlienIndexesThatCanShootCount = 0
			-- These aliens can shoot bombs
			AlienIndexesThatCanShootBombs = {}
			AlienIndexesThatCanShootBombsCount = 0

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

		resetToTop = function (self)
			if self.translationY > TopY then
				self.rowsStepped = 0
				self.direction = AlienDirection.up
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