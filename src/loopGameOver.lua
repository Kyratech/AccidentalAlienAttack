function GameOverLoop()
	cls(BgColour)
	GoInput()
	GoUpdate()
	GoDraw()
end

function GameOver()
	GameState = StateGameOver

	local columnWidth = 50

	HumanDialogue = CreateDialogue("GAME OVER!", HumanSadAni, 30, 10, true, columnWidth)
	AlienDialogue = CreateDialogue("I am so sorry...", AlienSadAni, 50, 13, false, columnWidth)

	ScoreText = {
		text = "You scored " .. Score .. " points!",
		y = 80,
		draw = function (self)
			PrintCentred(self.text, 120, self.y, 12)
		end
	}

	RestartText = {
		text = "Press [A] to play again.",
		y = 90,
		draw = function (self)
			PrintCentred(self.text, 120, self.y, 12)
		end
	}
end

function GoInput()
	if btn(BtnA) then
		GameState = StatePlaying
		StartGame()
	end
end

function GoUpdate()
	HumanDialogue:update()
end

function GoDraw()
	HumanDialogue:draw()
	AlienDialogue:draw()
	ScoreText:draw()
	RestartText:draw()
end