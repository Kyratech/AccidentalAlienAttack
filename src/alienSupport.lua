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