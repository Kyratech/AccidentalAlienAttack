function DialogueLoop()
	cls(BgColour)
	DialogueInput()
	DialogueUpdate()
	DialogueDraw()
end

function DialogueInit(script, numberOfLines)
	local columnWidth = 20

	DialogueObject = CreateDialogueScreen(script, numberOfLines, columnWidth)

	headerText = {
		text = "incoming transmission",
		y = 16,
		draw = function (self)
			PrintCustomCentred(self.text, 120, self.y)
		end
	}

	footerText = {
		text = "press a to close transmission",
		y = 112,
		draw = function (self)
			PrintCustomCentred(self.text, 120, self.y)
		end
	}
end

function DialogueInput()
	if btnp(BtnA) then
		GameState = StatePlaying
		StartGame()
	end
end

function DialogueUpdate()
	DialogueObject:update()
end

function DialogueDraw()
	DialogueObject:draw()

	headerText:draw()
	footerText:draw()
end