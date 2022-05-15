PlayerWeapons = {
	none = "none",
	vertical = "vertical",
	horizontal = "horizontal",
	diagonal = "diagonal",
	block = "block",
	drill = "drill",
	mortar = "mortar",
	swarm = "swarm",
	bubble = "bubble"
}

SpecialWeaponPicker = {
	vertical = function ()
		PlayerMissile:shoot(PlayerMissileAni.sprites[1])
	end,
	horizontal = function ()
		PlayerMissile:shoot(PlayerMissileAni.sprites[1])
	end,
	diagonal = function ()
		PlayerMissile:shoot(PlayerMissileAni.sprites[1])
	end,
	block = function ()
		SpecialWeaponBlockProjectile:shoot()
	end,
	drill = function ()
		SpecialWeaponDrill:shoot()
	end,
	mortar = function ()
		PlayerMissile:shoot(PlayerMortarAni.sprites[1])
	end,
	bubble = function ()
		PlayerMissile:shoot(PlayerBubbleMissileAni.sprites[1])
	end
}