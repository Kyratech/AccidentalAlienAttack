function TitleLoop()
	TitleInput()
	TitleDraw()
end

OptionsMenuOpen = false

function TitleScreen()
	GameState = StateTitle

	MainMenu = CreateMenu(MainMenuOptions, MainMenuOptionsCount, MainMenuConsts, ScreenWidth / 2 - 20, 80)
	OptionsMenu = CreateMenu(OptionsMenuOptions, OptionsMenuOptionsCount, OptionsMenuConsts, 10, 20)
end

function TitleInput()
	cls(BgColour)
	if OptionsMenuOpen == true then
		OptionsMenu:input()
	else
		MainMenu:input()
	end
end

function TitleDraw()
	if OptionsMenuOpen == true then
		PrintCustomCentredDecorated("Options", ScreenWidth / 2, 5)
		DrawButtonPrompt(ButtonIcons.A, "Save + Exit", ScreenWidth - 90, ScreenHeight - 8)
		DrawButtonPrompt(ButtonIcons.B, "Back", 2, ScreenHeight - 8)

		OptionsMenu:draw()
	else
		local cols=30
		local rows=17
		map(0,0,cols,rows)
	
		MainMenu:draw()
	
		-- PrintCentred("Press A to start", 120, 70, 12)
		PrintCentred("A game by Kyratech", 120, 110, 2)
	end
end