function RemoveAlien(indexToRemove)
	local nextKeptIndex = 1
	
	for i = 1, LiveAliens do
		if i == indexToRemove then
			if i ~= nextKeptIndex then
				Aliens[nextKeptIndex] = Aliens[i]
				Aliens[i] = nil;
			end

			nextKeptIndex = nextKeptIndex + 1
		else
			Aliens[i] = nil;
		end
	end
end