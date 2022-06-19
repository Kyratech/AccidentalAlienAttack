PlayerMissileConsts = {
	speed = 2,
	storeX = 320,
	storeY = 150,
	clrIndex = 0
}

PlayerMissileBurstConsts = {
	speed = 4,
	storeX = 340,
	storeY = 150,
	clrIndex = 0
}

PlayerMissileLaunchPayload = {
	vertical = function (self, alienY)
		PlayerMissileBurstVertical:enable(self.x - 1, alienY - 20)
	end,
	horizontal = function (self, alienY)
		PlayerMissileBurstLeft:enable(self.x - 22, alienY + 2)
		PlayerMissileBurstRight:enable(self.x, alienY + 2)
	end,
	diagonal = function (self, alienY)
		PlayerMissileBurstDiagonalLeft:enable(self.x - 16, alienY - 8)
		PlayerMissileBurstDiagonalRight:enable(self.x + 10, alienY - 8)
	end,
	mortar = function (self, alienY)
		for i, mortarFragment in pairs(PlayerMortarFragments) do
			mortarFragment:enable(self.x -1, self.y + 2)
		end
	end,
	bubble = function (self, alienY)
		PlayerBubble:enable(self.x - 3, alienY)
	end
}

function CreatePlayerMissile()
	return {
		x = PlayerMissileConsts.storeX,
		y = PlayerMissileConsts.storeY,
		w = 2,
		h = 8,
		speed = 0,
		type = PlayerWeapons.none,
		sprite = PlayerMissileAni.sprites[1],
		draw = function (self)
			if self.speed > 0 then
				spr(
					self.sprite,
					self.x - 3,
					self.y,
					PlayerMissileConsts.clrIndex)

				PlayerMissileExhaust:draw()
			end
		end,
		update = function (self)
			self.y = self.y - self.speed

			if self.speed > 0 then
				PlayerMissileExhaust:update(self.x, self.y + 8)
			end
		end,
		checkCollision = function (self)
			-- Check off top of screen
			if self.y < 0 then
				self:reset()
			end
			
			CollideWithAliens(self, function (self, alien)
				local alienY = alien.y;
				self:createBursts(alienY)
				self:reset()
			end)

			if Collide(self, AlienCarrier) then
				local alienY = AlienCarrier.y;

				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				ScorePoints(5)

				self:createBursts(alienY)
				self:reset()
			end

			if Collide(self, SpecialWeaponBlock) then
				SpecialWeaponBlock:takeDamage(1)
				SpecialWeaponBlock:shove()
				self:createBursts(self.y)
				self:reset()
			end
		end,
		shoot = function (self, sprite)
			self.sprite = sprite

			if self.speed == 0 then
				self.x = Player.x + 4
				self.y = Player.y

				self.speed = PlayerMissileConsts.speed
				self.type = Player.weaponType
				
				Player.weaponType = PlayerWeapons.none
				Player.weaponPower = 0
			end
		end,
		reset = function (self)
			self.x = PlayerMissileConsts.storeX
			self.y = PlayerMissileConsts.storeY
			self.speed = 0

			PlayerMissileExhaust:update(self.x, self.y + 8)
		end,
		createBursts = function (self, alienY)
			PlayerMissileLaunchPayload[self.type](self, alienY)
		end
	}
end

function CreatePlayerMissileExhaust()
	return {
		x = PlayerMissileConsts.storeX,
		y = PlayerMissileConsts.storeY,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerMissileExhaustAni.sprites[1]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.x - 3,
				self.y,
				PlayerMissileConsts.clrIndex)
		end,
		update = function (self, x, y)
			self.x = x
			self.y = y

			Animate(self, PlayerMissileExhaustAni)
		end
	}
end

PlayerMissileLinearBurstStatus = {
	disabled = 0,
	colliding = 1,
	visible = 2
}

function CreatePlayerMissileVerticalBurst()
	return {
		x = PlayerMissileBurstConsts.storeX,
		y = PlayerMissileBurstConsts.storeY,
		w = 4,
		h = 24,
		status = PlayerMissileLinearBurstStatus.disabled,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerMissileLinearBurstAni.sprites[1]
		},
		enable = function (self, x, y)
			self.status = PlayerMissileLinearBurstStatus.colliding
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerMissileLinearBurstAni.sprites[1]
		end,
		disable = function (self)
			self.status = PlayerMissileLinearBurstStatus.disabled
			self.x = ExplosionConsts.storeX
			self.y = ExplosionConsts.storeY
		end,
		draw = function (self)
			if self.status ~= PlayerMissileLinearBurstStatus.disabled then
				-- Have to rotate composite sprites by parts
				spr(
					self.ani.currentFrame,
					self.x - 2,
					self.y + 16,
					PlayerMissileLinearBurstAni.clrIndex,
					1,
					0,
					3
				)

				spr(
					self.ani.currentFrame + 1,
					self.x - 2,
					self.y + 8,
					PlayerMissileLinearBurstAni.clrIndex,
					1,
					0,
					3
				)

				spr(
					self.ani.currentFrame + 2,
					self.x - 2,
					self.y,
					PlayerMissileLinearBurstAni.clrIndex,
					1,
					0,
					3
				)
			end
		end,
		update = function (self)
			if self.status ~= PlayerMissileLinearBurstStatus.disabled then
				AnimateOneshot(self, PlayerMissileLinearBurstAni)
			end
		end,
		checkCollision = function (self)
			if self.status == PlayerMissileLinearBurstStatus.colliding then
				-- Only collide on the first frame
				self.status = PlayerMissileLinearBurstStatus.visible

				-- Check aliens
				CollideWithAliens(self, function (self, alien) end)

				if Collide(self, AlienCarrier) then
					Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
					ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
					AlienCarrier:disable()

					Score = Score + 5
				end
			end
		end
	}
end

function CreatePlayerMissileHorizontalBurst(spriteFlip)
	return {
		x = PlayerMissileBurstConsts.storeX,
		y = PlayerMissileBurstConsts.storeY,
		w = 24,
		h = 4,
		status = PlayerMissileLinearBurstStatus.disabled,
		spriteFlip = spriteFlip,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerMissileLinearBurstAni.sprites[1]
		},
		enable = function (self, x, y)
			self.status = PlayerMissileLinearBurstStatus.colliding
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerMissileLinearBurstAni.sprites[1]
		end,
		disable = function (self)
			self.status = PlayerMissileLinearBurstStatus.disabled
			self.x = ExplosionConsts.storeX
			self.y = ExplosionConsts.storeY
		end,
		draw = function (self)
			if self.status ~= PlayerMissileLinearBurstStatus.disabled then
				-- Have to flip composite sprites by parts
				spr(
					self.ani.currentFrame,
					self.x + 16 * self.spriteFlip,
					self.y - 2,
					PlayerMissileLinearBurstAni.clrIndex,
					1,
					self.spriteFlip
				)

				spr(
					self.ani.currentFrame + 1,
					self.x + 8,
					self.y - 2,
					PlayerMissileLinearBurstAni.clrIndex,
					1,
					self.spriteFlip
				)

				spr(
					self.ani.currentFrame + 2,
					self.x + 16 - 16 * self.spriteFlip,
					self.y - 2,
					PlayerMissileLinearBurstAni.clrIndex,
					1,
					self.spriteFlip
				)
			end
		end,
		update = function (self)
			if self.status ~= PlayerMissileLinearBurstStatus.disabled then
				AnimateOneshot(self, PlayerMissileLinearBurstAni)
			end
		end,
		checkCollision = function (self)
			if self.status == PlayerMissileLinearBurstStatus.colliding then
				-- Only collide on the first frame
				self.status = PlayerMissileLinearBurstStatus.visible

				-- Check aliens
				CollideWithAliens(self, function (self, alien) end)

				if Collide(self, AlienCarrier) then
					Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
					ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
					AlienCarrier:disable()

					Score = Score + 5
				end
			end
		end
	}
end

function CreatePlayerMissileDiagonalBurst(spriteFlip)
	return {
		x = PlayerMissileBurstConsts.storeX,
		y = PlayerMissileBurstConsts.storeY,
		w = 8,
		h = 4,
		status = PlayerMissileLinearBurstStatus.disabled,
		spriteFlip = spriteFlip,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = PlayerMissileDiagonalBurstAni.sprites[1]
		},
		enable = function (self, x, y)
			self.status = PlayerMissileLinearBurstStatus.colliding
			self.x = x
			self.y = y
			self.ani.delayCounter = 0
			self.ani.currentCounter = 1
			self.ani.currentFrame = PlayerMissileDiagonalBurstAni.sprites[1]
		end,
		disable = function (self)
			self.status = PlayerMissileLinearBurstStatus.disabled
			self.x = ExplosionConsts.storeX
			self.y = ExplosionConsts.storeY
		end,
		draw = function (self)
			if self.status ~= PlayerMissileLinearBurstStatus.disabled then
				-- Have to flip composite sprites by parts
				spr(
					self.ani.currentFrame,
					self.x - 8 + 16 * self.spriteFlip,
					self.y - 2,
					PlayerMissileDiagonalBurstAni.clrIndex,
					1,
					self.spriteFlip
				)

				spr(
					self.ani.currentFrame + 1,
					self.x,
					self.y - 2,
					PlayerMissileDiagonalBurstAni.clrIndex,
					1,
					self.spriteFlip
				)

				spr(
					self.ani.currentFrame + 16,
					self.x - 8 + 16 * self.spriteFlip,
					self.y + 6,
					PlayerMissileDiagonalBurstAni.clrIndex,
					1,
					self.spriteFlip
				)

				spr(
					self.ani.currentFrame + 17,
					self.x,
					self.y + 6,
					PlayerMissileDiagonalBurstAni.clrIndex,
					1,
					self.spriteFlip
				)
			end
		end,
		update = function (self)
			if self.status ~= PlayerMissileLinearBurstStatus.disabled then
				AnimateOneshot(self, PlayerMissileDiagonalBurstAni)
			end
		end,
		checkCollision = function (self)
			if self.status == PlayerMissileLinearBurstStatus.colliding then
				-- Only collide on the first frame
				self.status = PlayerMissileLinearBurstStatus.visible

				-- Check aliens
				CollideWithAliens(self, function (self, alien) end)

				if Collide(self, AlienCarrier) then
					Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
					ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
					AlienCarrier:disable()

					Score = Score + 5
				end
			end
		end
	}
end