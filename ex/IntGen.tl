local props = record
    pick: function(self: any, min: number, max: number): number
    shrink: function(self: any, prev: number): {number}
end
local IntGen = class.class("IntGen", props)

--- Helper function for picking a random integer, bounded by min and max.
-- @param min minimum value
-- @param max maximum value
-- @return function that can generate an integer (min <= int <= max)
function IntGen:pick_bounded(min: number, max: number): function(): number
  local function do_pick(): number return math.random(min, max) end
  return do_pick
end


--- Helper function for shrinking integer, bounded by min and max. (min <= int <= max)
-- @param min minimum value
-- @param max maximum value
-- @return shrunk integer (shrinks towards 0 / closest value to 0 determined
--         by min and max)
function IntGen:shrink_bounded(min: number, max: number): function(IntGen, number): {number}
   local function do_shrink(self: IntGen, previous: number): {number}
     local t = {}
     local i = math.floor((previous - min) / 2) + min
     if i > min then
        t[#t+1] = i
     end
     local j = math.ceil((max - previous) / 2) + previous
     if j < max then
        t[#t+1] = j
     end
     return t
  end
  return do_shrink
end


--- Picks a random integer, uniformy spread between +- sample_size / 2.
-- @param sample_size Number of times this generator is used in a property;
--                    used to guide the optimatization process.
-- @return random integer
function IntGen:pick_uniform(sample_size: number): number
  local value = sample_size / 2
  return sample_size
end


--- Shrinks an integer by dividing it by 2 and rounding towards 0.
-- @param previous previously generated integer value
-- @return shrunk down integer value
function IntGen:shrink(previous: number): {number}
  if previous == 0 then return {} end
  if previous > 0 then return { math.floor(previous / 2) } end
  return { math.ceil(previous / 2) }
end

--- Creates a new integer generator.
-- @param nr1 number containing first bound
-- @param nr2 number containing second bound
-- @return generator that can generate integers according to the following strategy:
--   - nr1 and nr2 provided: nr1 <= int <= nr2
--   - only nr1 provided: 0 <= int <= max
--   - no bounds provided: -numtests/2 <= int <= numtests/2
function IntGen:init(nr1: number, nr2: number)
   if nr1 and nr2 then
      self.pick = self:pick_bounded(nr1, nr2)
      self.shrink = self:shrink_bounded(nr1, nr2)
   elseif nr1 then
      self.pick = self:pick_bounded(0, nr1)
      self.shrink = IntGen.shrink
   else
      self.pick = IntGen.pick_uniform
      self.shrink = IntGen.shrink
   end
end

return IntGen
