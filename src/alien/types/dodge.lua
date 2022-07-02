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
			if PositionsThatCanBeDodgedInto[alienIndexToTheLeft] == true then
				canDodgeLeft = true
			end
		end

		if self.column < AlienCountX then
			local alienIndexToTheRight = GetFormationPosition(self.column + 1, self.row)
			if PositionsThatCanBeDodgedInto[alienIndexToTheRight] == true then
				canDodgeRight = true
			end
		end

		if canDodgeLeft and canDodgeRight then
			local rng = math.random(2)
			self.dodgeDirection = AlienDodgeDirection.left
			if rng == 2 then
				self.dodgeDirection = AlienDodgeDirection.right
			end
			UpdatePositionsThatCanBeDodgedInto(self.column, self.row, self.dodgeDirection)
			return
		end

		if canDodgeLeft then
			self.dodgeDirection = AlienDodgeDirection.left
			UpdatePositionsThatCanBeDodgedInto(self.column, self.row, self.dodgeDirection)
			return
		end

		if canDodgeRight then
			self.dodgeDirection = AlienDodgeDirection.right
			UpdatePositionsThatCanBeDodgedInto(self.column, self.row, self.dodgeDirection)
			return
		end

		self.dodgeDirection = AlienDodgeDirection.none
	end

	dodgeAlien.dodge = function (self)
		if self.dodgeDirection ~= 0 then
			self.dodgeEffect:enable(self.x, self.y, self.dodgeDirection)

			self.column = self.column + self.dodgeDirection
		end

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

function UpdatePositionsThatCanBeDodgedInto(column, row, dodgeDirection)
	local currentIndex = GetFormationPosition(column, row)
	local newIndex = GetFormationPosition(column + dodgeDirection, row)
	PositionsThatCanBeDodgedInto[currentIndex] = true
	PositionsThatCanBeDodgedInto[newIndex] = false
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