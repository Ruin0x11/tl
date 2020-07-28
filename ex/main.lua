class = require("ex.class")

local IntGen = require("ex.IntGen")

local gen = IntGen:new(100, 200)
local n = gen:pick(100)
local t = gen:shrink(n)
print(t[1])
