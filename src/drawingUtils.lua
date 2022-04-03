function PrintCentred(str, x, y, colour)
	local w = print(str, 0, -30)
    print(str, x-(w/2), y, colour)
end

function PrintRightAligned(str, x, y, colour)
	local w = print(str, 0, -30)
	print(str, x-w, y, colour)
end

function PrintCustom(str, x, y)
	PrintCustomInternal(str, x, y)
end

function PrintCustomCentred(str, x, y)
	local totalWidth = string.len(str) * 5
	local firstCharX = x - totalWidth/2

	PrintCustomInternal(str, firstCharX, y)
end

function PrintCustomRightAligned(str, x, y)
	local totalWidth = string.len(str) * 5
	local firstCharX = x - totalWidth

	PrintCustomInternal(str, firstCharX, y)
end

function PrintCustomCentredDecorated(str, x, y)
	local totalWidth = string.len(str) * 5
	local firstCharX = x - totalWidth/2

	PrintCustomInternal(str, firstCharX, y)

	PrintCustomDecorationInternal(str, firstCharX, y)
end

function PrintCustomInternal(str, firstCharX, y)
	local stringUpper = str:upper()
	for i = 1, #str do
		local customCharIndex = stringUpper:sub(i,i):byte() - 65 + 224

		spr(
			customCharIndex,
			firstCharX + (i - 1) * 5,
			y,
			0
		)
	end
end

function PrintCustomDecorationInternal(str, firstCharX, y)
	spr(208, firstCharX - 17, y, 0, 1, 0, 0, 2, 1)
	spr(208, firstCharX + string.len(str) * 5, y, 0, 1, 1, 0, 2, 1)
end