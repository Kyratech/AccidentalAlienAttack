function PrintCentred(str, x, y, colour)
	local w = print(str, 0, -30)
    print(str, x-(w/2), y, colour)
end

function CreateDialogue(str, ani, y, textColour, iconLeft, columnWidth)
	local iconX, textX;
	if iconLeft then
		iconX = columnWidth
		textX = columnWidth + 16 + 4
	else
		local strWidth = print(str, 0, -30)
		iconX = 240 - columnWidth - 16
		textX = 240 - columnWidth - 16 - 4 - strWidth
	end

	return {
		iconX = iconX,
		textX = textX,
		y = y,
		ani = {
			delayCounter = 0,
			currentCounter = 1,
			currentFrame = ani.sprites[1]
		},
		draw = function (self)
			spr(
				self.ani.currentFrame,
				self.iconX,
				self.y,
				-1,
				1,
				0,
				0,
				2,
				2)
			print(str, self.textX, self.y + 6, textColour)
		end,
		update = function (self)
			Animate(self, ani)
		end
	}
end