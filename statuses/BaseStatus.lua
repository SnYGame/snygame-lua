agm.import('util/KeyCheck')

BaseStatus = {}
setmetatable(BaseStatus, {__index = KeyCheck})

TURN_END = 0

function BaseStatus.new(name)
    local status = {name = name, tags = {}, tick_start = 0}
    setmetatable(status, {__index = BaseStatus})
    return status
end

function BaseStatus:shortstr()
    return self.name
end

function BaseStatus:tostring()
    local strbuilder = {}
    if self:has('uses') then
        table.insert(strbuilder, string.format('%d use%s', self.uses, self.uses == 1 and '' or 's'))
    end
    if self:has('duration') then
        table.insert(strbuilder, string.format('%d turn%s', self.duration, self.duration == 1 and '' or 's'))
    end
    return self:shortstr() .. (#strbuilder == 0 and '' or ' (' .. table.concat(strbuilder, ', ') .. ')')
end

function BaseStatus:repr()
    local strbuilder = {string.format('BaseStatus.new(%q)', self.name)}
    if self:has('uses') then
        table.insert(strbuilder, string.format(':setuses(%d)', self.uses))
    end
    if self:has('duration') then
        table.insert(strbuilder, string.format(':setduration(%d)', self.duration))
    end
    if self:has('timing_before') then
        if type(self.timing_before) == 'number' then
            table.insert(strbuilder, string.format(':timingbefore(%d)', self.timing_before))
        else
            local index = indexof(statsheet.units, self.timing_before)
            table.insert(strbuilder, string.format(':timingbefore(%d)', index))
        end
    end
    if self:has('timing_after') then
        if type(self.timing_after) == 'number' then
            table.insert(strbuilder, string.format(':timingafter(%d)', self.timing_after))
        else
            local index = indexof(statsheet.units, self.timing_after)
            table.insert(strbuilder, string.format(':timingafter(%d)', index))
        end
    end
    if self.tick_start ~= 0 then
        table.insert(strbuilder, string.format(':settickstart(%d)', self.tick_start))
    end
    return table.concat(strbuilder)
end

function BaseStatus:setduration(duration)
    self.duration = duration
    return self
end

function BaseStatus:tickduration(turn)
    if (turn > self.tick_start) then
        self.duration = self.duration - 1
    end
    return self.duration
end

function BaseStatus:setuses(uses)
    self.uses = uses
    return self
end

function BaseStatus:tickuse()
    self.use = self.use - 1
    return self.use
end

function BaseStatus:timingbefore(timing)
    self.timing_before = timing
    return self
end

function BaseStatus:timingafter(timing)
    self.timing_after = timing
    return self
end

function BaseStatus:settickstart(tick_start)
    self.tick_start = tick_start
    return self
end

function BaseStatus:hastiming(prev_move, curr_move)
    print(prev_move, curr_move)
    return rawget(self, 'timing_before') == curr_move or rawget(self, 'timing_after') == prev_move
end

function BaseStatus:trigger()
    error(string.format('%s has no effect defined', self:shortstr()))
end

PotencyStatus = {}
setmetatable(PotencyStatus, {__index = BaseStatus})

function PotencyStatus.new(name, potency)
    local status = BaseStatus.new(name)
    status.potency = potency
    setmetatable(status, {__index = PotencyStatus})
    return status
end

function BaseStatus:shortstr()
    return string.format('%s [%d]', self.name, self.potency)
end