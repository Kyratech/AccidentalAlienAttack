function HighScoresLoop()
	cls(BgColour)
	HighScoresInput()
	HighScoresDraw()
end

function HighScoresScreen()
	GameState = StateHighScores

	HighScoresTable = CreateHighScoresTable()
end

function HighScoresInput()
	if btnp(BtnA) then
		TitleScreen()
	end
end

function HighScoresDraw()
	PrintCustomCentred("High scores", HalfScreenWidth, 8)

	HighScoresTable:draw()

	DrawButtonPrompt(ButtonIcons.A, "Exit", ScreenWidth - 39, ScreenHeight - 8)
end