agm.import('statuses/BaseStatus')

GuardStatus = {}
setmetatable(GuardStatus, {__index = BaseStatus})

function GuardStatus.new(potency)
    local status = BaseStatus.new('Guard')
    status.potency = potency
    status.tags = {damage_modifier = true, damage_mitigator = true}
    setmetatable(status, {__index = GuardStatus})
    return status
end

function GuardStatus:shortstr()
    return string.format('%s [%d]', self.name, self.potency)
end

