function CreateDodgeAlien(i, j)
	return CreateAlienBase(
		i,
		j,
		AlienDodgeAni,
		PlayerWeapons.vertical,
		StandardDieFunction
	)
end