agm.import('Statsheet')
agm.import('Damage')

local AttackEntry = {}
setmetatable(AttackEntry, {__index = agm.StackEntry})

UnitCommand = {AttackEntry = AttackEntry}

function AttackEntry.new(src, target, roll)
    local entry = agm.StackEntry.new(string.format("%s's Attack", src.display))
    entry.src = src
    entry.target = target
    entry.roll = roll
    setmetatable(entry, {__index = AttackEntry})
    return entry
end

function AttackEntry:tostring()
    return string.format("Source: %s\nTarget: %s\nDamage: %s", self.src.display, self.target.display, self.roll:tostring())
end

function AttackEntry:execute()
    local result = self.roll:roll()
    local entry = DamageSingle.new(self.src, self.target, result.sum)
    agm.stack:buffereffect(entry)
    return result.msg
end

function UnitCommand.attack(src, targetname)
    assert(src:has('ap'), string.format('Unit %s has no AP', src.display))
    local target = statsheet:getunit(targetname)
    local entry = AttackEntry.new(src, target, src.ap)
    agm.stack:buffereffect(entry)
    return string.format('%s attacked %s', src.display, target.display)
end
