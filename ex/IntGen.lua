local IntGen = class.class("IntGen", props)





function IntGen:pick_bounded(min, max)
   local function do_pick()       return math.random(min, max) end
   return do_pick
end







function IntGen:shrink_bounded(min, max)
   local function do_shrink(self, previous)
      local t = {}
      local i = math.floor((previous - min) / 2) + min
      if i > min then
         t[#t + 1] = i
      end
      local j = math.ceil((max - previous) / 2) + previous
      if j < max then
         t[#t + 1] = j
      end
      return t
   end
   return do_shrink
end






function IntGen:pick_uniform(sample_size)
   local value = sample_size / 2
   return sample_size
end





function IntGen:shrink(previous)
   if previous == 0 then       return {} end
   if previous > 0 then       return { math.floor(previous / 2) } end
   return { math.ceil(previous / 2) }
end








function IntGen:init(nr1, nr2)
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
