agm.import('util/KeyCheck')

BaseUnit = {}
setmetatable(BaseUnit, {__index = KeyCheck})

function BaseUnit.new(display, name, hp)
    local unit = {display = display, name = name, hp = hp, maxhp = hp, statuses = {}}
    setmetatable(unit, {__index = BaseUnit})
    return unit
end

function BaseUnit:sethp(hp)
    self.hp = hp
    return self
end

function BaseUnit:setap(ap)
    self.ap = ap
    return self
end

function BaseUnit:setgp(gp)
    self.gp = gp
    return self
end

function BaseUnit:setcp(cp)
    self.cp = cp
    return self
end

local function pottostring(unit, pot, strbuilder)
    if unit:has(pot) then
        table.insert(strbuilder, string.format('%s: %s', string.upper(pot), unit[pot]:tostring()))
    end
end

local function statustostring(statuses)
    local strbuilder = {}
    for _, status in ipairs(statuses) do
        table.insert(strbuilder, status:tostring())
    end
    return table.concat(strbuilder, ', ')
end

function BaseUnit:tostring()
    local unitrepr = string.format('%s - %d/%d HP', self.display, self.hp, self.maxhp)
    local statusrepr = '\nStatus: ' .. statustostring(self.statuses)

    local strbuilder = {}
    pottostring(self, 'ap', strbuilder)
    pottostring(self, 'gp', strbuilder)
    pottostring(self, 'cp', strbuilder)

    return unitrepr .. (#strbuilder > 0 and '\n' .. table.concat(strbuilder, ' | ') .. ' |' or '') .. statusrepr
end

local function potrepr(unit, pot, strbuilder)
    if unit:has(pot) then
        table.insert(strbuilder, string.format(':set%s(%s)', pot, unit[pot]:repr()))
    end
end

function BaseUnit:repr()
    local strbuilder = {string.format('BaseUnit.new(%q, %q, %d)', self.display, self.name, self.maxhp)}
    if self.hp ~= self.maxhp then
        table.insert(strbuilder, string.format(':sethp(%d)', self.hp))
    end
    potrepr(self, 'ap', strbuilder)
    potrepr(self, 'gp', strbuilder)
    potrepr(self, 'cp', strbuilder)

    for _, status in ipairs(self.statuses) do
        table.insert(strbuilder, string.format(':addstatus(%s)', status:repr()))
    end

    return table.concat(strbuilder)
end

function BaseUnit:addstatus(status)
    table.insert(self.statuses, status)
    return self
end

function BaseUnit:trigger(effect, tag)
    local size = #self.statuses
    for i, status in ipairs(self.statuses) do
        if status.tags[tag] and status:trigger(effect) then
            self.statuses[i] = nil
            agm.bufferoutput('%s consumed', status:shortstr())
        end
    end
    tablecompact(self.statuses, size)
end

function BaseUnit:applyrollmod(roll)
    if roll.flat then
        return roll.sum
    end

    local effect = {amount = roll.sum}
    self:trigger(effect, 'roll_modifier')
    return effect.amount
end