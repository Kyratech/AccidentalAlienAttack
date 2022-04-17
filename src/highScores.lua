function GetInitialsInput(submit)
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