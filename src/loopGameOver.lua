GameOverPages = {
	{
		draw = function()
			DialogueObject:draw()

			PrintCustomCentredDecorated("incoming transmission", HalfScreenWidth, 8)
			PrintCustomCentredDecorated("end transmission", HalfScreenWidth, ScreenHeight - 16)

			DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
		end,
		update = function()
			DialogueObject:update()
		end,
		input = function()
			if btnp(BtnA) then
				GameOverPage = GameOverPage + 1
			end
		end
	},
	{
		draw = function()
			PrintCentred("Final score", HalfScreenWidth, 60, 12)
			PrintCentred(Score, HalfScreenWidth, 68, 3)

			PrintCustomCentredDecorated("performance review", HalfScreenWidth, 8)
			PrintCustomCentredDecorated("performance review", HalfScreenWidth, ScreenHeight - 16)

			DrawButtonPrompt(ButtonIcons.A, "Finish", ScreenWidth - 56, ScreenHeight - 8)
		end,
		update = function()
		end,
		input = function()
			if btnp(BtnA) then
				TitleScreen()
			end
		end
	}
}

function GameOverLoop()
	cls(BgColour)
	GameOverPages[GameOverPage]:input()
	GameOverPages[GameOverPage]:update()
	GameOverPages[GameOverPage]:draw()
end

function GameOver(script, numberOfLines)
	GameState = StateGameOver

	GameOverPage = 1

	DialogueObject = CreateDialogueScreen(script, numberOfLines, 20)
end