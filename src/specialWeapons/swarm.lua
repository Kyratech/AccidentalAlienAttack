SpecialWeaponSwarmConsts = {
	acceleration = 0.1,
	speed = 3,
	storeX = 300,
	storeY = 150,
	clrIndex = 0,
	missilesInSwarm = 5
}

function CreateSpecialWeaponSwarmGroup()
	return {
		counter = 0,
		missilesFired = 0,
		active = false,
		swarmMissiles = {
			CreateSpecialWeaponSwarmMissile(),
			CreateSpecialWeaponSwarmMissile(),
			CreateSpecialWeaponSwarmMissile(),
			CreateSpecialWeaponSwarmMissile(),
			CreateSpecialWeaponSwarmMissile()
		},
		shoot = function (self)
			self.active = true

			self.swarmMissiles[1]:shoot()

			self.counter = 0
			self.missilesFired = 1

			Player.weaponType = PlayerWeapons.none
			Player.weaponPower = 0
		end,
		disable = function (self)
			self.active = false
		end,
		update = function (self)
			if self.active == true then
				self.counter = self.counter + 1

				if self.counter >= 20 then
					self.counter = 0
					self.missilesFired = self.missilesFired + 1
					self.swarmMissiles[self.missilesFired]:shoot()
					
					if self.missilesFired == SpecialWeaponSwarmConsts.missilesInSwarm then
						self:disable()
					end
				end
			end

			for i, swarmMissile in pairs(self.swarmMissiles) do
				swarmMissile:update()
			end
		end,
		draw = function (self)
			for i, swarmMissile in pairs(self.swarmMissiles) do
				swarmMissile:draw()
			end
		end,
		checkCollision = function (self)
			for i, swarmMissile in pairs(self.swarmMissiles) do
				swarmMissile:checkCollision()
			end
		end
	}
end

function CreateSpecialWeaponSwarmMissile()
	return {
		x = SpecialWeaponSwarmConsts.storeX,
		y = SpecialWeaponSwarmConsts.storeY,
		w = 3,
		h = 4,
		speed = 0,
		sprite = SpecialWeaponSwarmAni.sprites[1],
		launchX = SpecialWeaponSwarmConsts.storeX,
		launchY = SpecialWeaponSwarmConsts.storeY,
		draw = function (self)
			if self.speed ~= 0 then
				spr(
					self.sprite,
					self.x,
					self.y,
					SpecialWeaponSwarmConsts.clrIndex)

				line(
					self.launchX + 1, self.launchY + 4,
					self.x + 1, self.y + 4,
					10
				)
			end
		end,
		update = function (self)
			if self.speed ~= 0 and self.speed < SpecialWeaponSwarmConsts.speed then
				self.speed = self.speed + SpecialWeaponSwarmConsts.acceleration
			end

			self.y = self.y - self.speed
		end,
		checkCollision = function (self)
			-- Check off top of screen
			if self.y < 0 then
				self:reset()
			end

			CollideWithAliens(self, function (self, alien)
				self:reset()
			end)

			if Collide(self, AlienCarrier) then
				Explosion:enable(AlienCarrier.x + 4, AlienCarrier.y)
				ActivateRandomPowerup(AlienCarrier.x + 4, AlienCarrier.y)
				AlienCarrier:disable()

				ScorePoints(5)

				self:reset()
			end

			if Collide(self, SpecialWeaponBlock) then
				SpecialWeaponBlock:takeDamage(1)
				SpecialWeaponBlock:shove()
				self:reset()
			end
		end,
		shoot = function (self)
			self.x = Player.x + 3
			self.y = Player.y

			self.launchX = self.x
			self.launchY = self.y

			self.speed = SpecialWeaponSwarmConsts.acceleration
		end,
		reset = function (self)
			self.x = SpecialWeaponSwarmConsts.storeX
			self.y = SpecialWeaponSwarmConsts.storeY
			self.speed = 0
		end
	}
end