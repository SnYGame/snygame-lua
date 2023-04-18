agm.import('KeyCheck')

Dice = {}
setmetatable(Dice, {__index = KeyCheck})

local FLAT = 0
local XDY = 1

function Dice.flat(value)
    local dice = {type = FLAT, value = value}
    setmetatable(dice, {__index = Dice})
    return dice
end

function Dice.XdY(count, faces)
    local dice = {type = XDY, count = count, faces = faces}
    setmetatable(dice, {__index = Dice})
    return dice
end

function Dice:tostring()
    if self.type == FLAT then
        return tostring(self.value)
    elseif self.type == XDY then
        return string.format('%dd%d', self.count, self.faces)
    end
end

function Dice:repr()
    if self.type == FLAT then
        return string.format('Dice.value(%d)', self.value)
    elseif self.type == XDY then
        return string.format('Dice.XdY(%d, %d)', self.count, self.faces)
    end
end

function Dice:roll()
    if self.type == FLAT then
        return self.value
    elseif self.type == XDY then
        return agm.rolldice(string.format('%dd%d', self.count, self.faces)).sum
    end
end