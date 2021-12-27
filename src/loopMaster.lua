function Init()
	GameState = StatePlaying
	StartGame()
end

function TIC()
	if GameState == StatePlaying then
		PlayingLoop()
	elseif GameState == StateGameOver then
		GameOverLoop()
	end
end
