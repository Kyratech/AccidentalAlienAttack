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

function CreateDialogueScreen(script, numberOfLines, columnWidth)
	local dialogueLines = {}
	local verticalGapBetweenLines = GetVerticalGapBetweenLines(numberOfLines)

	for i = 1, numberOfLines do
		local lineText = script[i].text
		local lineAni = script[i].ani
		table.insert(dialogueLines, CreateDialogueLine(
			lineText,
			lineAni,
			GetLineY(verticalGapBetweenLines, i),
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

function GetVerticalGapBetweenLines(numberOfLines)
	local emptyVerticalSpace = ScreenHeight - numberOfLines * 16
	return emptyVerticalSpace / (numberOfLines + 1)
end

function GetLineY(verticalGap, lineNumber)
	return verticalGap * lineNumber + 16 * (lineNumber - 1)
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