function CreateShieldAlien(i, j)
	return CreateAlienBase(
		i,
		j,
		AlienShieldAni,
		PlayerWeapons.none,
		function (self, k)
			Explosion:enable(self.x, self.y)

			local damagedShieldAlien = CreateAlienBase(i, j, AlienShieldBrokenAni, PlayerWeapons.block, StandardDieFunction)
			damagedShieldAlien.x = self.x
			damagedShieldAlien.y = self.y
			Aliens[k] = damagedShieldAlien
		end
	)
end