Version = "1.0.0"

-- Global constants
BgColour = 0
TilePx = 8

ScreenWidth = 240
HalfScreenWidth = ScreenWidth / 2
ScreenHeight = 136
HalfScreenHeight = ScreenHeight / 2

MapCols=30
MapRows=17

LeftWallX = 22
RightWallX = 218
TopY = 20
GroundY = 125

AlienCountX = 10
AlienCountY = 5

PointsPerLifeLeft = 100

-- Button aliases
BtnUp = 0
BtnDown = 1
BtnLeft = 2
BtnRight = 3
BtnA = 4
BtnB = 5
BtnX = 6

-- Game states
StateTitle = 1
StatePlaying = 2
StateGameOver = 3
StateDialogue = 4
StateInstructions = 5
StateHighScores = 6

-- Sound constants
UiVolume = 15

-- Gameplay settings
ExtraLifeSpecialTresholds = {
	50,
	100,
	200
}
ExtraLifeThreshold = 500