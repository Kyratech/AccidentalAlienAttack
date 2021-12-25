function Animate(gameObject, animation)
	gameObject.ani.delayCounter = gameObject.ani.delayCounter + 1

	if gameObject.ani.delayCounter > animation.frameDelay then
		local frame = gameObject.ani.currentCounter % animation.length
		gameObject.ani.currentCounter = frame + 1
		gameObject.ani.currentFrame = animation.sprites[gameObject.ani.currentCounter]
		gameObject.ani.delayCounter = 0
	end
end

function AnimateOneshot(gameObject, animation)
	gameObject.ani.delayCounter = gameObject.ani.delayCounter + 1

	if gameObject.ani.delayCounter > animation.frameDelay then
		gameObject.ani.currentCounter = gameObject.ani.currentCounter + 1

		if gameObject.ani.currentCounter > animation.length + 1 then
			gameObject:disable()
		else
			gameObject.ani.currentFrame = animation.sprites[gameObject.ani.currentCounter]
			gameObject.ani.delayCounter = 0
		end
	end
end