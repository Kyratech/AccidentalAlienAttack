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