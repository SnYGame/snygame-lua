agm.import('util/KeyCheck')

BaseStatus = {}
setmetatable(BaseStatus, {__index = KeyCheck})

function BaseStatus.new(name)
    local status = {name = name}
    setmetatable(status, {__index = BaseStatus})
    return status
end

function BaseStatus:tostring()
    local strbuilder = {}
    if self:has('uses') then
        table.insert(strbuilder, string.format('%d use%s', self.uses, self.uses == 1 and '' or 's'))
    end
    if self:has('duration') then
        table.insert(strbuilder, string.format('%d turn%s', self.duration, self.duration == 1 and '' or 's'))
    end
    return self.name .. (#strbuilder == 0 and '' or ' (' .. table.concat(strbuilder, ', ') .. ')')
end

function BaseStatus:repr()
    local strbuilder = {string.format('BaseStatus.new(%q)', self.name)}
    if self:has('uses') then
        table.insert(strbuilder, string.format(':setuses(%d)', self.uses))
    end
    if self:has('duration') then
        table.insert(strbuilder, string.format(':setduration(%d)', self.duration))
    end
    return table.concat(strbuilder)
end

function BaseStatus:setduration(duration)
    self.duration = duration
    return self
end

function BaseStatus:setuses(uses)
    self.uses = uses
    return self
end