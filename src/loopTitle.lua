function TitleLoop()
	TitleInput()
	TitleDraw()
end

function TitleScreen()
	GameState = StateTitle

	local columnWidth = 25

	AlienDialogue = CreateDialogue("My drones are out of control!", AlienStartAni, 50, 13, true, columnWidth)
	HumanDialogue = CreateDialogue("Don't worry, I'll smash 'em!", HumanStartAni, 66, 10, false, columnWidth)
end

function TitleInput()
	if btn(BtnA) then
		GameState = StatePlaying
		StartGame()
	end
end

function TitleDraw()
	local cols=30
	local rows=17
	map(0,0,cols,rows)

	AlienDialogue:draw()
	HumanDialogue:draw()

	PrintCentred("Press A to start", 120, 100, 12)
	PrintCentred("A game by Kyratech", 120, 120, 2)
end