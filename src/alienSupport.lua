function CreateSupportAlien(i, j)
	return CreateAlienBase(
		i,
		j,
		AlienSupportAni,
		PlayerWeapons.vertical,
		StandardDieFunction
	)
end