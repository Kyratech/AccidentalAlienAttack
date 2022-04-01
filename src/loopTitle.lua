function TitleLoop()
	TitleInput()
	TitleDraw()
end

function TitleScreen()
	GameState = StateTitle

	local columnWidth = 25
end

function TitleInput()
	if btnp(BtnA) then
		GameState = StateDialogue
		DialogueInit(
			ScriptIntro,
			3,
			function()
				GameState = StatePlaying
				StartGame()
			end)
	end
end

function TitleDraw()
	local cols=30
	local rows=17
	map(0,0,cols,rows)

	PrintCentred("Press A to start", 120, 70, 12)
	PrintCentred("A game by Kyratech", 120, 110, 2)
end