function DialogueLoop()
	cls(BgColour)
	DialogueInput()
	DialogueUpdate()
	DialogueDraw()
end

function DialogueInit(script, numberOfLines, endDialogueFunction)
	EndDialogueFunction = endDialogueFunction

	local columnWidth = 20

	DialogueObject = CreateDialogueScreen(script, numberOfLines, columnWidth)

	headerText = {
		text = "incoming transmission",
		y = 8,
		draw = function (self)
			PrintCustomCentredDecorated(self.text, 120, self.y)
		end
	}

	footerText = {
		text = "end transmission",
		y = ScreenHeight - 16,
		draw = function (self)
			PrintCustomCentredDecorated(self.text, 120, self.y)
		end
	}
end

function DialogueInput()
	if btnp(BtnA) then
		EndDialogueFunction()
	end
end

function DialogueUpdate()
	DialogueObject:update()
end

function DialogueDraw()
	DialogueObject:draw()

	headerText:draw()
	footerText:draw()

	DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 60, ScreenHeight - 8)
end