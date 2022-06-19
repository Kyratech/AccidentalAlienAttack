SpecialWeaponBlockConsts = {
	speed = 0.5,
	storeX = 340,
	storeY = 160,
	clrIndex = 2,
	shoveDistance = 10,
}

BlockHpColours = {
	2,
	3,
	4,
	5,
	6,
	10
}

function CreateSpecialWeaponBlockProjectile()
	return {
		x = SpecialWeaponBlockConsts.storeX,
		y = SpecialWeaponBlockConsts.storeY,
		active = false,
		speed = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = SpecialWeaponBlockProjectileAni.sprites[1]
		},
		shoot = function (self)
			if self.active == false then
				self.active = true
				self.x = Player.x - 4
				self.y = Player.y
				self.speed = -SpecialWeaponBlockConsts.speed
				self.ani.delayCounter = 0
				self.ani.currentCounter = 1
				self.ani.currentFrame = SpecialWeaponBlockProjectileAni.sprites[1]
				Player.weaponType = PlayerWeapons.none
				Player.weaponPower = 0
				sfx(soundEffects.missileMicro)
			end
		end,
		disable = function (self)
			SpecialWeaponBlock:enable(self.x + 1, self.y)
			self.active = false
			self.x = SpecialWeaponBlockConsts.storeX
			self.y = SpecialWeaponBlockConsts.storeY
			self.speed = 0
		end,
		draw = function (self)
			if self.active == true then
				spr(
					self.ani.currentFrame,
					self.x,
					self.y,
					SpecialWeaponBlockConsts.clrIndex,
					1,
					0,
					0,
					2,
					1)
			end
		end,
		update = function (self)
			self.y = self.y + self.speed

			if self.active == true then
				AnimateOneshot(self, SpecialWeaponBlockProjectileAni)
			end
		end
	}
end

function CreateSpecialWeaponBlock()
	return {
		x = SpecialWeaponBlockConsts.storeX,
		y = SpecialWeaponBlockConsts.storeY,
		targetY = SpecialWeaponBlockConsts.storeY,
		w = 14,
		h = 8,
		hp = 0,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = SpecialWeaponBlockAni.sprites[1]
		},
		draw = function (self)
			if self.hp > 0 then
				spr(
					self.ani.currentFrame,
					self.x - 1,
					self.y,
					SpecialWeaponBlockConsts.clrIndex,
					1,
					0,
					0,
					2,
					1)

				rect(self.x + 6, self.y + 3, 2, 2, BlockHpColours[self.hp])
			end
		end,
		update = function (self)
			if self.hp > 0 and self.targetY < self.y then
				self.y = self.y - SpecialWeaponBlockConsts.speed
			end
		end,
		checkCollision = function (self)
			if self.hp > 0 then
				CollideWithAliens(self, function(self, alien)
					sfx(soundEffects.explosionStandard)
					self:takeDamage(2)
				end)
			end
		end,
		enable = function (self, x, y)
			self.x = x
			self.y = y
			self.targetY = y
			self.hp = 6
		end,
		disable = function (self)
			self.x = SpecialWeaponBlockConsts.storeX
			self.y = SpecialWeaponBlockConsts.storeY
			self.targetY = SpecialWeaponBlockConsts.storeY
		end,
		takeDamage = function (self, damage)
			self.hp = self.hp - damage

			if self.hp <= 0 then
				self:disable()
			end
		end,
		shove = function (self)
			self.targetY = self.targetY - SpecialWeaponBlockConsts.shoveDistance
		end
	}
end