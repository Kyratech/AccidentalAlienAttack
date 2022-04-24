SpecialWeaponDrillConsts = {
	speed = 1,
	storeX = 340,
	storeY = 170,
	clrIndex = 12
}

function CreateSpecialWeaponDrill()
	return {
		x = SpecialWeaponDrillConsts.storeX,
		y = SpecialWeaponDrillConsts.storeY,
		w = 6,
		h = 8,
		active = false,
		speed = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = SpecialWeaponDrillAni.sprites[1]
		},
		checkCollision = function (self)
			if self.active == true then
				for i, alien in pairs(Aliens) do
					if Collide(self, Aliens[i]) then
						KillAlien(i)
	
						ScorePoints(1)
					end
				end
			end
		end,
		shoot = function (self)
			if self.active == false then
				self.active = true
				self.x = Player.x - 4
				self.y = Player.y
				self.speed = -SpecialWeaponDrillConsts.speed
				self.ani.delayCounter = 0
				self.ani.currentCounter = 1
				self.ani.currentFrame = SpecialWeaponDrillAni.sprites[1]
				Player.weaponType = PlayerWeapons.none
				Player.weaponPower = 0
			end
		end,
		disable = function (self)
			self.active = false
			self.x = SpecialWeaponDrillConsts.storeX
			self.y = SpecialWeaponDrillConsts.storeY
			self.speed = 0
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x - 1,
					self.y,
					SpecialWeaponDrillConsts.clrIndex)
			end
		end,
		update = function (self)
			self.y = self.y + self.speed

			if self.y < 0 then
				self:disable()
			end

			if self.active == true then
				Animate(self, SpecialWeaponDrillAni)
			end
		end
	}
end