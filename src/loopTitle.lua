function TitleLoop()
	TitleInput()
	TitleDraw()
end

OptionsMenuOpen = false

function TitleScreen()
	GameState = StateTitle

	MainMenu = CreateMenu(MainMenuOptions, MainMenuOptionsCount, MainMenuConsts, ScreenWidth / 2 - 30, 80)
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
	
		print("Developed by @KyraTech_13", 2, ScreenHeight - 8, 2)
		print(Version, ScreenWidth - 40, ScreenHeight - 8, 2, true)
	end
end