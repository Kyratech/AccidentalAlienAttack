function PrintCentred(str, x, y, colour)
	local w = print(str, 0, -30)
    print(str, x-(w/2), y, colour)
end

function PrintCustomCentred(str, x, y)
	local stringUpper = str:upper()
	local totalWidth = string.len(str) * 5
	local firstCharX = x - totalWidth/2

	for i = 1, #str do
		local customCharIndex = stringUpper:sub(i,i):byte() - 65 + 224

		spr(
			customCharIndex,
			firstCharX + (i - 1) * 5,
			y,
			0
		)
	end

	spr(208, firstCharX - 17, y, 0, 1, 0, 0, 2, 1)
	spr(208, firstCharX + string.len(str) * 5, y, 0, 1, 1, 0, 2, 1)
end