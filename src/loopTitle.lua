function TitleLoop()
	TitleInput()
	TitleDraw()
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

	print ("Press A to start", 76, 80, 12)
	print ("A game by Kyratech", 70, 120, 2)
end