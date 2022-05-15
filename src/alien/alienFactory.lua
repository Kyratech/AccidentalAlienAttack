AlienFactory = {
	function(i, j)
		return CreateAlienBase(i, j, AlienRedAni, PlayerWeapons.horizontal, StandardDieFunction)
	end,
	function(i, j)
		return CreateAlienBase(i, j, AlienBlueAni, PlayerWeapons.diagonal, StandardDieFunction)
	end,
	function(i, j)
		return CreateAlienBase(i, j, AlienGreenAni, PlayerWeapons.vertical, StandardDieFunction)
	end,
	function(i, j)
		return CreateShieldAlien(i, j)
	end,
	function(i, j)
		return CreateDiveAlien(i, j)
	end,
	function (i, j)
		return CreateBombAlien(i, j)
	end,
	function (i, j)
		return CreateDodgeAlien(i, j)
	end,
	function (i, j)
		return CreateSupportAlien(i, j)
	end
}

function CreateAlien(i, j, type)
	return AlienFactory[type](i, j)
end