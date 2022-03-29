DialogueAlienAnis = {
	worried = {
		frameDelay = 1,
		length = 1,
		sprites = { 80 }
	},
	wince = {
		frameDelay = 1,
		length = 1,
		sprites = { 112 }
	},
	nervousLaugh = {
		frameDelay = 1,
		length = 1,
		sprites = { 144 }
	},
	relief = {
		frameDelay = 1,
		length = 1,
		sprites = { 176 }
	}
}

DialogueHumanAnis = {
	determined = {
		frameDelay = 1,
		length = 1,
		sprites = { 82 }
	},
	cocky = {
		frameDelay = 1,
		length = 1,
		sprites = { 84 }
	},
	cry = {
		frameDelay = 30,
		length = 2,
		sprites = { 114, 116 }
	}
}

DialogueTextColours = {
	alien = 13,
	human = 10
}

DialogueIconLeft = {
	alien = false,
	human = true
}

DialogueConsts = {
	lineHeight = 16,
	lineGapHeight = 8
}

function CreateDialogueScreen(script, numberOfLines, columnWidth)
	local dialogueLines = {}

	for i = 1, numberOfLines do
		local lineText = script[i].text
		local lineAni = script[i].ani
		table.insert(dialogueLines, CreateDialogueLine(
			lineText,
			lineAni,
			GetLineY(i, numberOfLines),
			DialogueTextColours[script[i].speaker],
			DialogueIconLeft[script[i].speaker],
			columnWidth
			))
	end
	
	return {
		lines = dialogueLines,
		update = function (self)
			for index, line in pairs(self.lines) do
				line:update()
			end
		end,
		draw = function (self)
			for index, line in pairs(self.lines) do
				line:draw()
			end
		end
	}
end

function GetFirstLineOffset(numberOfLines)
	local totalLineHeight = DialogueConsts.lineHeight * numberOfLines
	local totalLineGapHeight = DialogueConsts.lineGapHeight * (numberOfLines - 1)
	local totalMarginAroundLines = ScreenHeight - totalLineHeight - totalLineGapHeight
	return totalMarginAroundLines / 2 
end

function GetLineY(lineNumber, numberOfLines)
	local firstLineOffset = GetFirstLineOffset(numberOfLines)
	local heightOfPreviousLines = (DialogueConsts.lineHeight + DialogueConsts.lineGapHeight) * (lineNumber - 1)
	return firstLineOffset + heightOfPreviousLines
end

function CreateDialogueLine(str, ani, y, textColour, iconLeft, columnWidth)
	local iconX, textX;
	if iconLeft then
		iconX = columnWidth
		textX = columnWidth + 16 + 4
	else
		local strWidth = print(str, 0, -30)
		iconX = ScreenWidth - columnWidth - 16
		textX = ScreenWidth - columnWidth - 16 - 4 - strWidth
	end

	return {
		iconX = iconX,
		textX = textX,
		y = y,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = ani.sprites[1]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.iconX,
				self.y,
				-1,
				1,
				0,
				0,
				2,
				2)
			print(str, self.textX, self.y + 6, textColour)
		end,
		update = function (self)
			Animate(self, ani)
		end
	}
end