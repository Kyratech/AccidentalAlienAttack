function GameOverLoop()
	cls(BgColour)
	GoInput()
	GoDraw()
end

function GoInput()
	if btn(BtnA) then
		GameState = StatePlaying
		StartGame()
	end
end

function GoDraw()
	print("GAME OVER!", 50, 60, 6)
	print("Press A to play again", 50, 70, 5)
end