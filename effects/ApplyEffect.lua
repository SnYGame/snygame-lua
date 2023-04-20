ApplyEffect = {}
setmetatable(ApplyEffect, {__index = agm.StackEntry})

function ApplyEffect.new(src, target, effect)
    local entry = agm.StackEntry.new('Single Target Damage')
    entry.src = src
    entry.target = target
    entry.effect = effect
    setmetatable(entry, {__index = ApplyEffect})
    return entry
end

function ApplyEffect:tostring()
    return string.format("Source: %s\nTarget: %s\nEffect: %s", self.src.display, self.target.display, self.effect:tostring())
end

function ApplyEffect:execute()
    table.insert(self.target.statuses, self.effect)
    agm.bufferoutput('**[Effect]** %s gains %s', self.target.display, self.effect:tostring())
end
