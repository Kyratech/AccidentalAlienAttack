HighScoreMemoryIndexes = {
	{
		name = 0,
		score = 1
	},
	{
		name = 2,
		score = 3
	},
	{
		name = 4,
		score = 5
	},
	{
		name = 6,
		score = 7
	},
	{
		name = 8,
		score = 9
	}
}

GameSettingsMemoryIndexes = {
	input = 10,
	gameplay = 11,
	video = 12
}

-- Extract part of the binary representation of a number.
-- Assign the least significant bit the index 0.
-- a is the least significant part of the substring.
-- b is the most significant part of the substring.
-- Example for a 32 bit number:
-- 00000000000000110000000000000000
-- |       ^      ^               |
-- |       b      a               |
-- 31      23     16              0
-- Returns: 00000011 (3)
function IsolateBinaryPart(binaryNumber, a, b)
	local leastSignificantPart = binaryNumber % (2 ^ (b + 1))
	return RightShift(leastSignificantPart, a)
end

function LeftShift(x, by)
	return x * 2 ^ by
end

function RightShift(x, by)
	return math.floor(x / 2 ^ by)
end