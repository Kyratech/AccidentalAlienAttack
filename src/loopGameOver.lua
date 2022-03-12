function GameOverLoop()
	cls(BgColour)
	GoInput()
	GoUpdate()
	GoDraw()
end

function GameOver(script, numberOfLines)
	GameState = StateGameOver

	local columnWidth = 20

	DialogueObject = CreateDialogueScreen(script, numberOfLines, columnWidth)

	ScoreText = {
		text = "You scored " .. Score .. " points!",
		y = 110,
		draw = function (self)
			PrintCentred(self.text, 120, self.y, 12)
		end
	}

	RestartText = {
		text = "Press [A] to play again.",
		y = 120,
		draw = function (self)
			PrintCentred(self.text, 120, self.y, 12)
		end
	}
end

function GoInput()
	if btn(BtnA) then
		GameState = StateDialogue
		DialogueInit(ScriptIntro, 3)
	end
end

function GoUpdate()
	DialogueObject:update()
end

function GoDraw()
	DialogueObject:draw()
	ScoreText:draw()
	RestartText:draw()
end