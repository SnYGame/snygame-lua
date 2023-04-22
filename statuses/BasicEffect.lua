agm.import('statuses/BaseStatus')

GuardEffect = {}
setmetatable(GuardEffect, {__index = PotencyStatus})

ChargeEffect = {}
setmetatable(ChargeEffect, {__index = PotencyStatus})

function GuardEffect.new(potency)
    local status = PotencyStatus.new('Guard', potency)
    status.tags = {damage_modifier = true, mitigator = true}
    setmetatable(status, {__index = GuardEffect})
    return status
end

function GuardEffect:trigger(effect)
    local highest_guard = {potency = 0}
    for _, status in ipairs(effect.target.statuses) do
        if status.name == 'Guard' and status.potency > highest_guard.potency then
            highest_guard = status
        end
    end

    if highest_guard == self then
        effect.amount = effect.amount - highest_guard.potency
        agm.bufferoutput('**[Guard]** Damage decreased by %d to %d', highest_guard.potency, effect.amount)
    end
end

function ChargeEffect.new(potency)
    local status = PotencyStatus.new('Charge', potency)
    status.tags = {roll_modifier = true}
    setmetatable(status, {__index = ChargeEffect})
    return status
end

function ChargeEffect:trigger(effect)
    effect.amount = effect.amount + self.potency
    agm.bufferoutput('**[Charge]** Roll increased by %d to %d', self.potency, effect.amount)
    return true
end
