PlayerWeapons = {
	none = "none",
	vertical = "vertical",
	horizontal = "horizontal",
	diagonal = "diagonal",
	block = "block",
	drill = "drill"
}

SpecialWeaponPicker = {
	vertical = function ()
		PlayerMissile:shoot()
	end,
	horizontal = function ()
		PlayerMissile:shoot()
	end,
	diagonal = function ()
		PlayerMissile:shoot()
	end,
	block = function ()
		SpecialWeaponBlockProjectile:shoot()
	end,
	drill = function ()
		SpecialWeaponDrill:shoot()
	end
}