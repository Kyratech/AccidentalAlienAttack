ScriptIntro = {
	{
		text = "Help! Can anyone hear me?",
		ani = DialogueAlienAnis.worried,
		speaker = "alien"
	},
	{
		text = "Our drones are out of control!",
		ani = DialogueAlienAnis.worried,
		speaker = "alien"
	},
	{
		text = "Hah! They're no match for me!",
		ani = DialogueHumanAnis.cocky,
		speaker = "human"
	}
}

ScriptStageInterludes = {
	{
		{
			text = "So, uh.",
			ani = DialogueHumanAnis.pout,
			speaker = "human"
		},
		{
			text = "How many drones do you have?",
			ani = DialogueHumanAnis.pout,
			speaker = "human"
		},
		{
			text = "Less than you would fear.",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		},
		{
			text = "...More than you would hope.",
			ani = DialogueAlienAnis.wince,
			speaker = "alien"
		}
	},
	{
		{
			text = "These guys are getting stronger...",
			ani = DialogueHumanAnis.determined,
			speaker = "human"
		},
		{
			text = "It's part of their routines,",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		},
		{
			text = "To evolve when under threat.",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		}
	},
	{
		{
			text = "Are you holding up ok?",
			ani = DialogueAlienAnis.worried,
			speaker = "alien"
		},
		{
			text = "Never...better!",
			ani = DialogueHumanAnis.determined,
			speaker = "human"
		},
		{
			text = "I think I detect sarcasm...",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		}
	},
	{
		{
			text = "I think they're running out!",
			ani = DialogueAlienAnis.nervousLaugh,
			speaker = "alien"
		},
		{
			text = "When this is over...",
			ani = DialogueHumanAnis.determined,
			speaker = "human"
		},
		{
			text = "We're having a chat about this.",
			ani = DialogueHumanAnis.pout,
			speaker = "human"
		},
		{
			text = "Are you asking me on a date?",
			ani = DialogueAlienAnis.relief,
			speaker = "alien"
		}
	}
}

ScriptStageInterludesLengths = {
	4,
	3,
	3,
	4
}

ScriptGameOverGood = {
	{
		text = "I think that was the last of them.",
		ani = DialogueAlienAnis.relief,
		speaker = "alien"
	},
	{
		text = "As if there was any doubt.",
		ani = DialogueHumanAnis.cocky,
		speaker = "human"
	},
	{
		text = "Thank you, overly cocky human.",
		ani = DialogueAlienAnis.nervousLaugh,
		speaker = "alien"
	},
}

ScriptGameOverBad = {
	{
		text = "We're done! We've got nothing left!",
		ani = DialogueHumanAnis.cry,
		speaker = "human"
	},
	{
		text = "I'm sorry, this is all my fault...",
		ani = DialogueAlienAnis.wince,
		speaker = "alien"
	}
}