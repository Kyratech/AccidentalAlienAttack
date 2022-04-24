DiveAlienConsts = {
	diveSpeed = 2
}

function CreateDiveAlien(i, j)
	return CreateAlienBase(
		i,
		j,
		AlienDiveAni,
		PlayerWeapons.drill,
		function(self, k)
			Explosion:enable(self.x, self.y)
			Player:getWeaponPower(self.specialWeapon)
			
			local divingAlien = CreateDiveAlienDiving(self.x + 1, self.y)
			Aliens[k] = divingAlien
		end
	)
end

function CreateDiveAlienDiving(x, y)
	return {
		x = x,
		y = y,
		w = 6,
		h = 8,
		draw = function (self)
			spr(423, self.x - 1, self.y, 12)
		end,
		update = function (self)
			self.y = self.y + DiveAlienConsts.diveSpeed
		end,
		checkCollision = function (self, i)
			-- Check bottom of screen
			if self.y + self.h > GroundY then
				KillAlien(i)
			end

			if Collide(self, SpecialWeaponBlock) then
				KillAlien(i)
				SpecialWeaponBlock:takeDamage(1)
			end

			if Collide(self, Player) then
				if Player.active == true and Player.status ~= PlayerStatuses.shield then
					Player:die()
					AlienGlobalRowsStepped = 0
				end
				KillAlien(i)
			end
		end,
		die = function (self, i)
			Explosion:enable(self.x, self.y)
		
			table.remove(Aliens, i)
			LiveAliens = LiveAliens - 1
		end
	}
end