function Collide(a, b)
	if a.x < b.x + b.w and
		a.x + a.w > b.x and
		a.y < b.y + b.h and
		a.y + a.h > b.y then
		return true
	end
	return false
end

function CollideWithAliens(self, onCollision)
	for formationPosition, alien in pairs(Aliens) do
		if Collide(self, alien) then
			alien:die(formationPosition)

			ScorePoints(1)

			onCollision(self, alien)
		end
	end

	for i, specialAlien in pairs(SpecialAliens) do
		if Collide(self, specialAlien) then
			specialAlien:die(i)

			-- Probably bad practice
			-- Make sure not to use any non-special behaviour (like formationPosition) in the collision function
			onCollision(self, specialAlien)
		end
	end
end