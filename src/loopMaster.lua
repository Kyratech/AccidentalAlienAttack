function Init()
	TitleScreen()
end

function TIC()
	if GameState == StateTitle then
		TitleLoop()
	elseif GameState == StatePlaying then
		PlayingLoop()
	elseif GameState == StateGameOver then
		GameOverLoop()
	elseif GameState == StateDialogue then
		DialogueLoop()
	end
end
