function CreateBombAlien(i, j)
	return CreateAlienBase(
		i,
		j,
		AlienBombAni,
		PlayerWeapons.vertical,
		StandardDieFunction
	)
end