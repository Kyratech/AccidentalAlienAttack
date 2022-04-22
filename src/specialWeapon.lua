PlayerWeapons = {
	none = "none",
	vertical = "vertical",
	horizontal = "horizontal",
	diagonal = "diagonal",
	block = "block"
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
	end
}