HighScoreMemoryIndexes = {
	{
		name = 0,
		score = 1
	},
	{
		name = 2,
		score = 3
	},
	{
		name = 4,
		score = 5
	}
}

DefaultHighScores = {
	{
		name = "ALP",
		score = 30
	},
	{
		name = "BET",
		score = 20
	},
	{
		name = "GAM",
		score = 10
	}
}

function CreateInitialsInput(submit)
	return {
		y = 60	,
		chars = {
			"A",
			"A",
			"A"
		},
		editingCharacter = 1,
		selectedCharacter = 65,
		draw = function (self)
			PrintCentred("Please enter your name:", HalfScreenWidth, self.y, 12)

			-- The current value
			local currentValueLeftX = HalfScreenWidth - 9
			local combinedString = self.chars[1] .. self.chars[2] .. self.chars[3]
			print(combinedString, currentValueLeftX, self.y + 12, 3, true)
			line(
				currentValueLeftX + (self.editingCharacter - 1) * 6,
				self.y + 20,
				currentValueLeftX + (self.editingCharacter - 1) * 6 + 4,
				self.y + 20,
				12)

			-- Letter picker
			local halfWidth = 78
			for i = 65, 90 do
				local normalisedI = i - 65
				local charX = HalfScreenWidth - halfWidth + (normalisedI % 13) * 12
				local charY = self.y + 28 + math.floor(normalisedI / 13) * 12
				local textColour = 1
				if i == self.selectedCharacter then
					textColour = 3
				end
				print(string.char(i), charX, charY, textColour, true)
			end
		end,
		input = function (self)
			if btnp(BtnLeft) then
				self:updateSelectedCharacter(self.selectedCharacter - 1)
			elseif btnp(BtnRight) then
				self:updateSelectedCharacter(self.selectedCharacter + 1)
			elseif btnp(BtnUp) then
				self:updateSelectedCharacter(self.selectedCharacter - 13)
			elseif btnp(BtnDown) then
				self:updateSelectedCharacter(self.selectedCharacter + 13)
			end

			if btnp(BtnA) then
				if self.editingCharacter ~= 3 then
					self.editingCharacter = self.editingCharacter + 1
				else
					submit()
				end
			end

			if btnp(BtnB) and self.selectedCharacter ~= 1 then
				self.editingCharacter = self.editingCharacter - 1
			end
		end,
		getName = function (self)
			return self.chars[1] .. self.chars[2] .. self.chars[3]
		end,
		updateSelectedCharacter = function (self, newSelectedCharacter)
			if newSelectedCharacter < 65 then
				self.selectedCharacter = 65
			elseif newSelectedCharacter > 90 then
				self.selectedCharacter = 90
			else
				self.selectedCharacter = newSelectedCharacter
			end

			self.chars[self.editingCharacter] = string.char(self.selectedCharacter)
		end
	}
end

CreateHighScoresTable = function ()
	local topScores = {
		GetHighScore(1),
		GetHighScore(2),
		GetHighScore(3)
	}

	local topScoreStrings = {
		SerialiseHighScore(topScores[1]),
		SerialiseHighScore(topScores[2]),
		SerialiseHighScore(topScores[3])
	}

	return {
		y = 40,
		newScoreRanking = 4,
		newScoreString = "",
		topScores = topScores,
		topScoreStrings = topScoreStrings,
		draw = function (self)
			for i = 1, 3 do
				local colour = 12
				if i == self.newScoreRanking then
					colour = 3
				end
				PrintCentredMonospace(self.topScoreStrings[i], HalfScreenWidth, self.y + (i - 1) * 8, colour)
			end

			PrintCentredMonospace(self.newScoreString, HalfScreenWidth, self.y + 32, 3)
		end,
		updateHighScores = function (self, newScore)
			local newRanking = 4
			if newScore.score > self.topScores[1].score then
				self.topScores[1] = newScore
				newRanking = 1
				SaveHighScore(1, newScore)
			elseif newScore.score > self.topScores[2].score then
				self.topScores[2] = newScore
				newRanking = 2
				SaveHighScore(2, newScore)
			elseif newScore.score > self.topScores[3].score then
				self.topScores[3] = newScore
				newRanking = 3
				SaveHighScore(3, newScore)
			end

			self.topScoreStrings = {
				SerialiseHighScore(self.topScores[1]),
				SerialiseHighScore(self.topScores[2]),
				SerialiseHighScore(self.topScores[3])
			}
			self.newScoreRanking = newRanking
			self.newScoreString = SerialiseHighScore(newScore)
		end
	}
end

GetHighScore = function (rank)
	local highScoreValue = pmem(HighScoreMemoryIndexes[rank].score)
	local highScoreName = pmem(HighScoreMemoryIndexes[rank].name)

	if highScoreValue == 0 or highScoreName == 0 then
		return DefaultHighScores[rank]
	end

	local decodedHighScoreName = DecodeHighScoreName(highScoreName)

	return {
		name = decodedHighScoreName,
		score = highScoreValue
	}
end

function SaveHighScore (rank, highScore)
	pmem(HighScoreMemoryIndexes[rank].score, highScore.score)
	pmem(HighScoreMemoryIndexes[rank].name, EncodeHighScoreName(highScore.name))
end

EncodeHighScoreName = function(name)
	local charCodes = {
		string.byte(string.sub(name, 1, 1)),
		string.byte(string.sub(name, 2, 2)),
		string.byte(string.sub(name, 3, 3))
	}

	return 2^16 * charCodes[1] + 2^8 * charCodes[2] + charCodes[3]
end

DecodeHighScoreName = function(encodedName)
	local parts = {
		math.floor((encodedName % 2^24) / 2^16),
		math.floor((encodedName % 2^16) / 2^8),
		encodedName % 2^8
	}

	return string.char(parts[1]) .. string.char(parts[2]) .. string.char(parts[3])
end

SerialiseHighScore = function(highScore)
	local lengthOfScore = 1
	if highScore.score > 0 then
		lengthOfScore = math.floor(math.log(highScore.score, 10) + 1)
	end
	local numberOfSpaces = 13 - lengthOfScore
	local spaces = string.rep(" ", numberOfSpaces)

	return highScore.name .. spaces .. highScore.score
end