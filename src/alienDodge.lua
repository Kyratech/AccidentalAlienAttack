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
		PlayerWeapons.vertical,
		StandardDieFunction
	)

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
		self.column = self.column + self.dodgeDirection
		self:calculateNextDodge()
	end

	dodgeAlien.update = function (self)
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