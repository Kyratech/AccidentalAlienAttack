-- Alien types:
-- 0 - no alien
-- 1 - red alien
-- 2 - blue alien
-- 3 - green alien
-- 4 - shield alien
-- 5 - dive alien
-- 6 - bomb alien
-- 7 - dodge alien
-- 8 - support alien

-- NumberOfStages = 1
-- NumberOfLevelsPerStage = 10

-- Formations = {
-- 	{
-- 		{
-- 			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
-- 			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
-- 			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
-- 			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
-- 			0, 0, 0, 3, 3, 3, 3, 0, 0, 0
-- 		},
-- 		{
-- 			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
-- 			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
-- 			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
-- 			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
-- 			0, 0, 1, 1, 1, 1, 1, 0, 0, 0
-- 		},
-- 		{
-- 			0, 2, 0, 2, 0, 0, 2, 0, 2, 0,
-- 			2, 0, 2, 0, 2, 2, 0, 2, 0, 2,
-- 			2, 0, 0, 2, 0, 0, 2, 0, 0, 2,
-- 			2, 0, 0, 0, 0, 0, 0, 0, 0, 2,
-- 			2, 0, 0, 0, 0, 0, 0, 0, 0, 2
-- 		},
-- 		{
-- 			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
-- 			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
-- 			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
-- 			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
-- 			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
-- 		},
-- 		{
-- 			2, 0, 3, 3, 3, 3, 3, 0, 2, 0,
-- 			2, 0, 3, 3, 3, 3, 0, 0, 2, 0,
-- 			2, 0, 3, 3, 3, 0, 0, 0, 2, 0,
-- 			2, 0, 3, 3, 0, 0, 0, 0, 2, 0,
-- 			2, 0, 3, 0, 0, 0, 0, 0, 2, 0
-- 		},
-- 		{
-- 			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
-- 			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
-- 			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
-- 			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
-- 			0, 0, 1, 1, 3, 1, 1, 0, 0, 0
-- 		},
-- 		{
-- 			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
-- 			1, 2, 2, 2, 2, 2, 2, 2, 2, 1,
-- 			1, 2, 2, 2, 2, 2, 2, 2, 2, 1,
-- 			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
-- 			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
-- 		},
-- 		{
-- 			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
-- 			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
-- 			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
-- 			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
-- 			1, 0, 1, 0, 1, 0, 1, 0, 1, 0
-- 		},
-- 		{
-- 			3, 2, 0, 0, 1, 1, 0, 0, 2, 3,
-- 			3, 2, 2, 0, 1, 1, 0, 2, 2, 3,
-- 			3, 0, 2, 2, 1, 1, 2, 2, 0, 3,
-- 			3, 0, 0, 2, 2, 2, 2, 0, 0, 3,
-- 			3, 0, 0, 0, 2, 2, 0, 0, 0, 3
-- 		},
-- 		{
-- 			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
-- 			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
-- 			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
-- 			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
-- 			1, 2, 3, 2, 1, 1, 2, 3, 2, 1
-- 		}
-- 	}
-- }

-- For testing end-of-stage behaviour

NumberOfStages = 5
NumberOfLevelsPerStage = 2

Formations = {
	{
		{
			3, 7, 3, 0, 0, 0, 0, 3, 7, 3,
			3, 7, 3, 0, 0, 0, 0, 3, 7, 3,
			3, 7, 3, 0, 0, 0, 0, 3, 7, 3,
			3, 7, 3, 0, 0, 0, 0, 3, 7, 3,
			0, 0, 0, 7, 0, 0, 7, 0, 0, 0
		},
		{
			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
			1, 0, 1, 1, 1, 1, 1, 0, 1, 0,
			0, 0, 1, 1, 1, 1, 1, 0, 0, 0
		}
	},
	{
		{
			0, 2, 0, 2, 0, 0, 2, 0, 2, 0,
			2, 0, 2, 0, 2, 2, 0, 2, 0, 2,
			2, 0, 0, 2, 0, 0, 2, 0, 0, 2,
			2, 0, 0, 0, 0, 0, 0, 0, 0, 2,
			2, 0, 0, 0, 0, 0, 0, 0, 0, 2
		},
		{
			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
			3, 0, 0, 1, 1, 1, 1, 0, 0, 3,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		}
	},
	{
		{
			2, 0, 3, 3, 3, 3, 3, 0, 2, 0,
			2, 0, 3, 3, 3, 3, 0, 0, 2, 0,
			2, 0, 3, 3, 3, 0, 0, 0, 2, 0,
			2, 0, 3, 3, 0, 0, 0, 0, 2, 0,
			2, 0, 3, 0, 0, 0, 0, 0, 2, 0
		},
		{
			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
			3, 0, 1, 1, 3, 1, 1, 0, 3, 0,
			0, 0, 1, 1, 3, 1, 1, 0, 0, 0
		}
	},
	{
		{
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			1, 2, 2, 2, 2, 2, 2, 2, 2, 1,
			1, 2, 2, 2, 2, 2, 2, 2, 2, 1,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		{
			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1, 0
		}
	},
	{
		{
			3, 2, 0, 0, 1, 1, 0, 0, 2, 3,
			3, 2, 2, 0, 1, 1, 0, 2, 2, 3,
			3, 0, 2, 2, 1, 1, 2, 2, 0, 3,
			3, 0, 0, 2, 2, 2, 2, 0, 0, 3,
			3, 0, 0, 0, 2, 2, 0, 0, 0, 3
		},
		{
			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
			1, 2, 3, 2, 1, 1, 2, 3, 2, 1,
			1, 2, 3, 2, 1, 1, 2, 3, 2, 1
		}
	}
}

-- Will softlock if spawned - for dev use only.
Formation_Empty = {
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}