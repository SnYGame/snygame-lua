agm.import('util/Statsheet')
agm.import('effects/Damage')

local AttackEntry = {}
setmetatable(AttackEntry, {__index = agm.StackEntry})

UnitCommand = {AttackEntry = AttackEntry}

function AttackEntry.new(src, target, roll)
    local entry = agm.StackEntry.new("Attack Command")
    entry.src = src
    entry.target = target
    entry.roll = roll
    setmetatable(entry, {__index = AttackEntry})
    return entry
end

function AttackEntry:tostring()
    return string.format("%s --> %s\nAttack Potential: %s", self.src.display, self.target.display, self.roll:tostring())
end

function AttackEntry:execute()
    local result = self.roll:roll()
    local entry = DamageSingle.new(self.src, self.target, result.sum)
    agm.stack:buffereffect(entry)
    agm.bufferoutput('**[Attack]** %s --> %s', self.src.display, self.target.display)
    agm.bufferoutput(result.msg)
end

function UnitCommand.attack(src, targetname)
    local target = statsheet:getunit(targetname)
    local entry = AttackEntry.new(src, target, src.ap)
    agm.stack:buffereffect(entry)
    agm.bufferoutput('**[Command]** %s attacks %s', src.display, target.display)
end
