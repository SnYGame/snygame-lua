agm.import('util/KeyCheck')

BaseStatus = {}
setmetatable(BaseStatus, {__index = KeyCheck})

TURN_END = -1

function BaseStatus.new(name)
    local status = {name = name, tags = {}}
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
    if self:has('timing') then
        table.insert(strbuilder, string.format(':settiming(%d)', self.timing))
    end
    return table.concat(strbuilder)
end

function BaseStatus:setduration(duration)
    self.duration = duration
    return self
end

function BaseStatus:updateduration(offset)
    offset = offset or -1
    self.duration = self.duration + offset
    return self.duration
end

function BaseStatus:setuses(uses)
    self.uses = uses
    return self
end

function BaseStatus:updateuse(offset)
    offset = offset or -1
    self.use = self.use + offset
    return self.use
end

function BaseStatus:settiming(timing)
    self.timing = timing
    return self
end

function BaseStatus:hastiming(timing)
    return rawget(self, 'timing') == timing
end