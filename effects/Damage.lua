DamageSingle = {}
setmetatable(DamageSingle, {__index = agm.StackEntry})

function DamageSingle.new(src, target, amount)
    local entry = agm.StackEntry.new('Single Target Damage')
    entry.src = src
    entry.target = target
    entry.amount = amount
    setmetatable(entry, {__index = DamageSingle})
    return entry
end

function DamageSingle:tostring()
    return string.format("Source: %s\nTarget: %s\nAmount: %d", self.src.display, self.target.display, self.amount)
end

function DamageSingle:execute()
    self.target:trigger(self, 'damage_modifier')
    self.amount = math.max(self.amount, 0)
    self.target.hp = self.target.hp - self.amount
    agm.bufferoutput('**[Damage]** %s takes %d damage.', self.target.display, self.amount)
    agm.bufferoutput('%s now has %d HP.', self.target.display, self.target.hp)
end
