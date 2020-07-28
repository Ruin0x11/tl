global class = require("ex.class")

local IntGen = require("ex.IntGen")

local gen: IntGen = IntGen:new(100, 200)
local n: number = gen:pick(100)
local t: {number} = gen:shrink(n)
print(t[1])
