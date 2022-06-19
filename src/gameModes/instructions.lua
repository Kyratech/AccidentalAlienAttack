InstructionPages = {
	{
		draw = function ()
			PrintCustomCentred("Objective", HalfScreenWidth, 8)
			
			print("An alien has come to your planet", 16, 24, 12)
			print("on holiday, but their drone swarm", 16, 32, 12)
			print("seems to have run amok!", 16, 40, 12)
	
			print("Do both of you a favour and blow", 16, 56, 12)
			print("those malfunctioning machines up", 16, 64, 12)
			print("before they do some damage!", 16, 72, 12)
	
			DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
			DrawButtonPrompt(ButtonIcons.B, "Exit", 2, ScreenHeight - 8)
		end,
		input = function ()
			if btnp(BtnA) then
				sfx(soundEffects.uiDing)
				InstructionStep = InstructionStep + 1
			end
		
			if btnp(BtnB) then
				TitleScreen()
			end
		end
	},
	{
		draw = function ()
			PrintCustomCentred("Controls", HalfScreenWidth, 8)
			
			spr(ButtonIcons.arrow[ButtonPromptsOptions[GameSettings.buttonPrompts].value], 16, 24, 0, 1, 0, 3)
			spr(ButtonIcons.arrow[ButtonPromptsOptions[GameSettings.buttonPrompts].value], 24, 24, 0, 1, 0, 1)
			print(": Move", 34, 26, 12)

			DrawButtonPrompt(ButtonIcons.A, "Shoot", 16, 40)

			DrawButtonPrompt(ButtonIcons.B, "Special weapon", 16, 56)

			DrawButtonPrompt(ButtonIcons.X, "Pause game", 16, 72)
	
			DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
			DrawButtonPrompt(ButtonIcons.B, "Back", 2, ScreenHeight - 8)
		end,
		input = function ()
			if btnp(BtnA) then
				sfx(soundEffects.uiDing)
				InstructionStep = InstructionStep + 1
			end
		
			if btnp(BtnB) then
				InstructionStep = InstructionStep - 1
			end
		end
	},
	{
		draw = function ()
			PrintCustomCentred("Special weapons", HalfScreenWidth, 8)
			
			print("Destroy 4 of the same type of drone", 16, 24, 12)
			print("in a row to unlock a special weapon!", 16, 32, 12)

			spr(288, 16, 48, 12)
			spr(288, 32, 48, 12)
			spr(288, 48, 48, 12)
			spr(288, 64, 48, 12)

			spr(11, 80, 48, 0, 1, 0, 1)

			spr(125, 96, 48, 0)

			print("Use your special weapons quickly, as", 16, 64, 12)
			print("shooting a different type of drone will", 16, 72, 12)
			print("reset your special weapon energy!", 16, 80, 12)
	
			DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
			DrawButtonPrompt(ButtonIcons.B, "Back", 2, ScreenHeight - 8)
		end,
		input = function ()
			if btnp(BtnA) then
				sfx(soundEffects.uiDing)
				InstructionStep = InstructionStep + 1
			end
		
			if btnp(BtnB) then
				InstructionStep = InstructionStep - 1
			end
		end
	},
	{
		draw = function ()
			PrintCustomCentred("Powerups", HalfScreenWidth, 8)
			
			print("Destroy a carrier drone to make it", 16, 24, 12)
			print("drop a powerup node.", 16, 32, 12)

			spr(304, 16, 48, 12)
			spr(305, 24, 48, 12)

			print("Activate a powerup by driving into it!", 16, 64, 12)
	
			DrawButtonPrompt(ButtonIcons.A, "Continue", ScreenWidth - 63, ScreenHeight - 8)
			DrawButtonPrompt(ButtonIcons.B, "Back", 2, ScreenHeight - 8)
		end,
		input = function ()
			if btnp(BtnA) then
				sfx(soundEffects.uiDing)
				InstructionStep = InstructionStep + 1
			end
		
			if btnp(BtnB) then
				InstructionStep = InstructionStep - 1
			end
		end
	},
	{
		draw = function ()
			PrintCustomCentred("Powerups cont", HalfScreenWidth, 8)
			
			spr(256, 16, 24, 0)
			print(": Extra life", 26, 26, 12)

			spr(257, 16, 40, 0)
			print(": Double points", 26, 42, 12)

			spr(258, 16, 56, 0)
			print(": Temporary shield", 26, 58, 12)

			spr(259, 16, 72, 0)
			print(": Freeze drones", 26, 74, 12)
	
			DrawButtonPrompt(ButtonIcons.A, "Exit", ScreenWidth - 39, ScreenHeight - 8)
			DrawButtonPrompt(ButtonIcons.B, "Back", 2, ScreenHeight - 8)
		end,
		input = function ()
			if btnp(BtnA) then
				sfx(soundEffects.uiConfirm)
				TitleScreen()
			end
		
			if btnp(BtnB) then
				InstructionStep = InstructionStep - 1
			end
		end
	}
}

function InstructionLoop()
	cls(BgColour)
	InstructionsInput()
	InstructionsDraw()
end

function InstructionsScreen()
	GameState = StateInstructions

	InstructionStep = 1
end

function InstructionsInput()
	InstructionPages[InstructionStep]:input()
end

function InstructionsDraw()
	InstructionPages[InstructionStep]:draw()
end