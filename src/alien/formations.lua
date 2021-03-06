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

NumberOfStages = 6
NumberOfLevelsPerStage = 10

Formations = {
	{
		-- 1-1
		{
			0, 3, 0, 3, 0, 0, 3, 0, 3, 0,
			0, 3, 0, 3, 0, 0, 3, 0, 3, 0,
			0, 3, 0, 3, 0, 0, 3, 0, 3, 0,
			0, 3, 0, 3, 0, 0, 3, 0, 3, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 1-2
		{
			0, 0, 0, 1, 1, 1, 0, 0, 0, 0,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
			0, 0, 0, 1, 1, 1, 0, 0, 0, 0,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 1-3
		{
			2, 0, 2, 0, 2, 2, 0, 2, 0, 2,
			0, 2, 0, 2, 0, 0, 2, 0, 2, 0,
			0, 0, 2, 0, 0, 0, 0, 2, 0, 0,
			0, 0, 0, 2, 2, 2, 2, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 1-4
		{
			2, 2, 2, 0, 0, 0, 0, 2, 2, 2,
			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
			3, 3, 3, 0, 0, 0, 0, 3, 3, 3,
			0, 0, 0, 3, 3, 3, 3, 0, 0, 0,
			0, 0, 0, 0, 3, 3, 0, 0, 0, 0
		},
		-- 1-5
		{
			3, 3, 3, 2, 2, 2, 2, 3, 3, 3,
			3, 3, 3, 2, 2, 2, 2, 3, 3, 3,
			0, 0, 0, 2, 2, 2, 2, 0, 0, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
			0, 1, 0, 1, 0, 1, 0, 1, 0, 1
		},
		-- 1-6
		{
			1, 1, 1, 0, 0, 0, 0, 1, 1, 1,
			1, 1, 1, 0, 2, 2, 0, 1, 1, 1,
			1, 1, 1, 0, 2, 2, 0, 1, 1, 1,
			3, 0, 3, 0, 0, 0, 0, 3, 0, 3,
			0, 3, 0, 0, 0, 0, 0, 0, 3, 0
		},
		-- 1-7
		{
			0, 0, 2, 3, 3, 3, 3, 2, 0, 0,
			0, 0, 2, 3, 3, 3, 3, 2, 0, 0,
			0, 0, 0, 3, 3, 3, 3, 0, 0, 0,
			0, 0, 1, 1, 1, 1, 1, 1, 0, 0,
			0, 1, 1, 1, 0, 0, 1, 1, 1, 0
		},
		-- 1-8
		{
			0, 0, 3, 3, 3, 3, 3, 3, 0, 0,
			0, 0, 1, 2, 3, 3, 2, 1, 0, 0,
			0, 0, 1, 2, 3, 3, 2, 1, 0, 0,
			0, 0, 1, 2, 2, 2, 2, 1, 0, 0,
			0, 0, 1, 2, 2, 2, 2, 1, 0, 0
		},
		-- 1-9
		{
			1, 0, 3, 0, 1, 0, 3, 0, 1, 0,
			1, 0, 3, 0, 1, 0, 3, 0, 1, 0,
			1, 0, 3, 0, 1, 0, 3, 0, 1, 0,
			1, 0, 3, 0, 1, 0, 3, 0, 1, 0,
			1, 0, 3, 0, 1, 0, 3, 0, 1, 0
		},
		-- 1-10
		{
			1, 0, 1, 0, 2, 2, 0, 1, 0, 1,
			0, 1, 0, 1, 2, 2, 1, 0, 1, 0,
			0, 0, 0, 0, 2, 2, 0, 0, 0, 0,
			3, 3, 3, 3, 2, 2, 3, 3, 3, 3,
			3, 3, 3, 3, 2, 2, 3, 3, 3, 3
		}
	},
	{
		-- 2-1
		{
			0, 0, 0, 4, 4, 4, 4, 0, 0, 0,
			0, 0, 0, 4, 4, 4, 4, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-2
		{
			4, 4, 3, 3, 3, 3, 3, 3, 4, 4,
			4, 4, 1, 1, 1, 1, 1, 1, 4, 4,
			0, 0, 1, 1, 1, 1, 1, 1, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-3
		{
			3, 3, 3, 2, 2, 2, 2, 3, 3, 3,
			3, 3, 3, 4, 4, 4, 4, 3, 3, 3,
			3, 3, 3, 1, 1, 1, 1, 3, 3, 3,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-4
		{
			0, 0, 2, 2, 1, 1, 2, 2, 0, 0,
			0, 4, 2, 2, 1, 1, 2, 2, 4, 0,
			4, 0, 4, 0, 1, 1, 0, 4, 0, 4,
			0, 4, 0, 0, 0, 0, 0, 0, 4, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-5
		{
			4, 4, 0, 3, 3, 3, 3, 0, 4, 4,
			4, 4, 0, 3, 3, 3, 3, 0, 4, 4,
			4, 4, 0, 3, 3, 3, 3, 0, 4, 4,
			0, 0, 0, 3, 3, 3, 3, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-6
		{
			4, 0, 4, 0, 4, 4, 0, 4, 0, 4,
			0, 4, 0, 4, 0, 0, 4, 0, 4, 0,
			2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-7
		{
			3, 3, 0, 0, 3, 3, 0, 0, 3, 3,
			2, 2, 0, 0, 2, 2, 0, 0, 2, 2,
			1, 1, 0, 0, 1, 1, 0, 0, 1, 1,
			4, 4, 0, 0, 4, 4, 0, 0, 4, 4,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-8
		{
			4, 4, 4, 0, 0, 0, 4, 4, 4, 0,
			0, 0, 0, 4, 4, 4, 0, 0, 0, 0,
			1, 1, 1, 2, 0, 2, 1, 1, 1, 0,
			1, 1, 1, 2, 0, 2, 1, 1, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-9
		{
			4, 4, 0, 2, 3, 3, 2, 0, 4, 4,
			4, 4, 0, 2, 3, 3, 2, 0, 4, 4,
			4, 4, 0, 2, 3, 3, 2, 0, 4, 4,
			3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 2-10
		{
			3, 3, 3, 1, 1, 1, 1, 2, 2, 2,
			3, 3, 3, 1, 1, 1, 1, 2, 2, 2,
			4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
			4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		}
	},
	{
		-- 3-1
		{
			0, 0, 0, 6, 6, 6, 6, 0, 0, 0,
			0, 0, 0, 6, 6, 6, 6, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-2
		{
			0, 3, 1, 2, 2, 2, 2, 1, 3, 0,
			0, 3, 1, 2, 2, 2, 2, 1, 3, 0,
			0, 3, 6, 2, 2, 2, 2, 1, 6, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-3
		{
			3, 3, 3, 2, 2, 2, 1, 1, 1, 0,
			3, 6, 3, 2, 6, 2, 1, 6, 1, 0,
			3, 3, 3, 2, 2, 2, 1, 1, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-4
		{
			0, 6, 0, 6, 0, 0, 6, 0, 6, 0,
			0, 2, 6, 2, 0, 0, 2, 6, 2, 0,
			0, 2, 2, 2, 0, 0, 2, 2, 2, 0,
			0, 1, 1, 1, 0, 0, 1, 1, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-5
		{
			6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
			3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
			2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-6
		{
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 4, 1, 2, 3, 3, 2, 1, 4, 0,
			0, 4, 1, 2, 3, 3, 2, 1, 4, 0,
			0, 6, 0, 0, 0, 0, 0, 0, 6, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-7
		{
			0, 3, 3, 1, 2, 2, 1, 3, 3, 0,
			0, 0, 3, 1, 2, 2, 1, 3, 0, 0,
			0, 0, 0, 1, 6, 6, 1, 0, 0, 0,
			0, 0, 0, 0, 4, 4, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-8
		{
			0, 0, 1, 6, 6, 6, 6, 1, 0, 0,
			0, 0, 1, 1, 1, 1, 1, 1, 0, 0,
			0, 0, 1, 4, 4, 4, 4, 1, 0, 0,
			0, 0, 1, 1, 1, 1, 1, 1, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 3-9
		{
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			2, 0, 0, 2, 0, 0, 2, 0, 0, 2,
			2, 0, 0, 2, 0, 0, 2, 0, 0, 2,
			2, 6, 6, 2, 0, 0, 2, 6, 6, 2,
			2, 6, 6, 2, 0, 0, 2, 6, 6, 2
		},
		-- 3-10
		{
			0, 0, 0, 6, 3, 4, 1, 2, 6, 3,
			0, 0, 6, 3, 4, 1, 2, 6, 3, 0,
			0, 6, 3, 4, 1, 2, 6, 3, 0, 0,
			6, 3, 4, 1, 2, 6, 3, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		}
	},
	{
		-- 4-1
		{
			5, 0, 5, 0, 5, 0, 5, 0, 5, 0,
			0, 5, 0, 5, 0, 5, 0, 5, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-2
		{
			0, 0, 0, 3, 1, 3, 1, 0, 0, 0,
			2, 2, 2, 1, 3, 1, 3, 2, 2, 2,
			5, 5, 5, 3, 1, 3, 1, 5, 5, 5,
			0, 0, 0, 1, 3, 1, 3, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-3
		{
			0, 2, 2, 0, 1, 1, 0, 2, 2, 0,
			0, 1, 1, 0, 2, 2, 0, 1, 1, 0,
			0, 2, 2, 0, 1, 1, 0, 2, 2, 0,
			0, 1, 1, 0, 2, 2, 0, 1, 1, 0,
			0, 5, 5, 0, 5, 5, 0, 5, 5, 0
		},
		-- 4-4
		{
			0, 5, 0, 5, 0, 5, 0, 5, 0, 0,
			1, 5, 1, 5, 1, 5, 1, 5, 1, 0,
			0, 1, 0, 1, 0, 1, 0, 1, 0, 0,
			2, 2, 2, 2, 2, 2, 2, 2, 2, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-5
		{
			0, 3, 2, 1, 5, 5, 1, 2, 3, 0,
			0, 0, 2, 1, 5, 5, 1, 2, 0, 0,
			0, 0, 0, 1, 5, 5, 1, 0, 0, 0,
			0, 0, 0, 5, 5, 5, 5, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-6
		{
			0, 6, 6, 0, 0, 0, 0, 6, 6, 0,
			0, 0, 0, 5, 5, 5, 5, 0, 0, 0,
			0, 0, 0, 3, 3, 3, 3, 0, 0, 0,
			0, 1, 1, 0, 0, 0, 0, 1, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-7
		{
			0, 2, 3, 0, 1, 1, 0, 3, 2, 0,
			0, 2, 3, 0, 6, 6, 0, 3, 2, 0,
			0, 4, 4, 4, 4, 4, 4, 4, 4, 0,
			0, 2, 3, 0, 5, 5, 0, 3, 2, 0,
			0, 0, 0, 0, 5, 5, 0, 0, 0, 0
		},
		-- 4-8
		{
			5, 1, 2, 6, 6, 6, 6, 2, 1, 5,
			5, 1, 2, 4, 4, 4, 4, 2, 1, 5,
			5, 1, 0, 0, 0, 0, 0, 0, 1, 5,
			5, 0, 0, 0, 0, 0, 0, 0, 0, 5,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-9
		{
			4, 4, 5, 5, 4, 4, 5, 5, 4, 4,
			0, 0, 5, 5, 0, 0, 5, 5, 0, 0,
			2, 2, 0, 0, 2, 2, 0, 0, 2, 2,
			2, 2, 0, 0, 2, 2, 0, 0, 2, 2,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 4-10
		{
			5, 5, 5, 5, 6, 6, 5, 5, 5, 5,
			4, 4, 4, 4, 6, 6, 4, 4, 4, 4,
			3, 3, 2, 2, 3, 3, 2, 2, 3, 3,
			1, 1, 1, 1, 2, 2, 1, 1, 1, 1,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		}
	},
	{
		-- 5-1
		{
			0, 0, 0, 8, 8, 8, 8, 0, 0, 0,
			0, 0, 0, 8, 8, 8, 8, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 5-2
		{
			2, 1, 1, 3, 8, 3, 1, 1, 2, 0,
			0, 2, 1, 3, 8, 3, 1, 2, 0, 0,
			0, 0, 2, 3, 8, 3, 2, 0, 0, 0,
			0, 0, 0, 2, 8, 2, 0, 0, 0, 0,
			0, 0, 0, 0, 2, 0, 0, 0, 0, 0
		},
		-- 5-3
		{
			0, 3, 8, 3, 2, 2, 3, 8, 3, 0,
			0, 3, 8, 3, 2, 2, 3, 8, 3, 0,
			0, 1, 8, 1, 3, 3, 1, 8, 1, 0,
			0, 1, 8, 1, 3, 3, 1, 8, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 5-4
		{
			3, 0, 1, 0, 0, 0, 0, 1, 0, 3,
			3, 8, 1, 8, 2, 2, 8, 1, 8, 3,
			3, 8, 1, 8, 2, 2, 8, 1, 8, 3,
			3, 0, 1, 0, 0, 0, 0, 1, 0, 3,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 5-5
		{
			0, 0, 2, 2, 2, 2, 2, 2, 0, 0,
			0, 3, 8, 8, 3, 3, 8, 8, 3, 0,
			0, 0, 0, 1, 1, 1, 1, 0, 0, 0,
			0, 0, 8, 8, 8, 8, 8, 8, 0, 0,
			0, 0, 0, 0, 2, 2, 0, 0, 0, 0
		},
		-- 5-6
		{
			5, 1, 1, 4, 8, 4, 1, 1, 5, 0,
			0, 5, 1, 2, 8, 2, 1, 5, 0, 0,
			0, 0, 5, 2, 8, 2, 5, 0, 0, 0,
			0, 0, 0, 3, 8, 3, 0, 0, 0, 0,
			0, 0, 0, 0, 3, 0, 0, 0, 0, 0
		},
		-- 5-7
		{
			0, 0, 0, 0, 1, 1, 0, 0, 0, 0,
			0, 0, 0, 0, 1, 1, 0, 0, 0, 0,
			0, 3, 5, 3, 1, 1, 3, 5, 3, 0,
			0, 3, 8, 3, 4, 4, 3, 8, 3, 0,
			0, 3, 8, 3, 4, 4, 3, 8, 3, 0
		},
		-- 5-8
		{
			6, 6, 6, 6, 5, 5, 6, 6, 6, 6,
			0, 2, 2, 8, 6, 6, 8, 2, 2, 0,
			0, 0, 2, 8, 6, 6, 8, 2, 0, 0,
			0, 0, 0, 8, 6, 6, 8, 0, 0, 0,
			0, 0, 0, 8, 6, 6, 8, 0, 0, 0
		},
		-- 5-9
		{
			0, 3, 2, 6, 6, 6, 6, 2, 3, 0,
			0, 3, 2, 5, 8, 8, 5, 2, 3, 0,
			0, 0, 2, 5, 8, 8, 5, 2, 0, 0,
			0, 0, 0, 5, 8, 8, 5, 0, 0, 0,
			0, 0, 0, 5, 8, 8, 5, 0, 0, 0
		},
		-- 5-10
		{
			6, 8, 6, 5, 5, 5, 5, 6, 8, 6,
			4, 8, 4, 1, 1, 1, 1, 4, 8, 4,
			4, 8, 4, 1, 1, 1, 1, 4, 8, 4,
			4, 8, 4, 3, 3, 3, 3, 4, 8, 4,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		}
	},
	{
		-- 6-1
		{
			0, 0, 1, 7, 1, 1, 7, 1, 0, 0,
			0, 0, 1, 7, 1, 1, 7, 1, 0, 0,
			0, 0, 1, 7, 1, 1, 7, 1, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 6-2
		{
			3, 2, 3, 2, 3, 2, 3, 2, 3, 0,
			2, 1, 2, 1, 2, 1, 2, 1, 2, 0,
			0, 1, 0, 1, 0, 1, 0, 1, 0, 0,
			0, 7, 0, 7, 0, 7, 0, 7, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 6-3
		{
			1, 7, 3, 3, 7, 7, 3, 3, 7, 1,
			1, 7, 3, 3, 7, 7, 3, 3, 7, 1,
			1, 7, 3, 3, 7, 7, 3, 3, 7, 1,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 6-4
		{
			3, 7, 7, 7, 2, 2, 7, 7, 7, 3,
			3, 7, 7, 2, 0, 0, 2, 7, 7, 3,
			3, 7, 2, 0, 0, 0, 0, 2, 7, 3,
			3, 2, 0, 0, 0, 0, 0, 0, 2, 3,
			2, 0, 0, 0, 0, 0, 0, 0, 0, 2
		},
		-- 6-5
		{
			1, 2, 3, 7, 7, 7, 7, 3, 2, 1,
			1, 2, 3, 7, 7, 7, 7, 3, 2, 1,
			0, 0, 1, 2, 3, 3, 2, 1, 0, 0,
			0, 0, 1, 2, 3, 3, 2, 1, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 6-6
		{
			0, 0, 3, 7, 6, 6, 7, 3, 0, 0,
			0, 0, 3, 7, 3, 3, 7, 3, 0, 0,
			0, 0, 3, 7, 3, 3, 7, 3, 0, 0,
			0, 0, 3, 4, 3, 3, 4, 3, 0, 0,
			0, 0, 0, 4, 0, 0, 4, 0, 0, 0
		},
		-- 6-7
		{
			0, 6, 6, 0, 7, 7, 0, 6, 6, 0,
			0, 6, 6, 0, 7, 7, 0, 6, 6, 0,
			0, 4, 4, 8, 8, 8, 8, 4, 4, 0,
			0, 5, 5, 0, 1, 1, 0, 5, 5, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 6-8
		{
			0, 5, 7, 2, 1, 1, 2, 7, 5, 0,
			0, 5, 7, 2, 1, 1, 2, 7, 5, 0,
			0, 5, 7, 2, 1, 1, 2, 7, 5, 0,
			0, 3, 8, 8, 3, 3, 8, 8, 3, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		},
		-- 6-9
		{
			1, 2, 3, 8, 7, 7, 8, 3, 2, 1,
			1, 2, 3, 8, 7, 7, 8, 3, 2, 1,
			0, 2, 3, 8, 7, 7, 8, 3, 2, 0,
			0, 0, 3, 8, 7, 7, 8, 3, 0, 0,
			0, 0, 0, 8, 4, 4, 8, 0, 0, 0
		},
		-- 6-10
		{
			6, 6, 6, 6, 5, 5, 6, 6, 6, 6,
			5, 5, 5, 5, 7, 7, 5, 5, 5, 5,
			3, 3, 3, 3, 7, 7, 3, 3, 3, 3,
			1, 7, 7, 1, 7, 7, 1, 7, 7, 1,
			8, 4, 4, 8, 8, 8, 8, 4, 4, 8
		}
	}
}

-- Will crash if spawned - for dev use only.
Formation_Empty = {
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}