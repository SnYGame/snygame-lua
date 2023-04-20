agm.import('util/Statsheet')
agm.import('effects/Damage')
agm.import('effects/ApplyEffect')
agm.import('statuses/BasicStatus')

local AttackEntry = {}
setmetatable(AttackEntry, {__index = agm.StackEntry})

local DefendEntry = {}
setmetatable(DefendEntry, {__index = agm.StackEntry})

local ConcentrateEntry = {}
setmetatable(ConcentrateEntry, {__index = agm.StackEntry})

UnitCommand = {}

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

function DefendEntry.new(src, roll)
    local entry = agm.StackEntry.new("Defend Command")
    entry.src = src
    entry.roll = roll
    setmetatable(entry, {__index = DefendEntry})
    return entry
end

function DefendEntry:tostring()
    return string.format("Target: %s\nGuard Potential: %s", self.src.display, self.roll:tostring())
end

function DefendEntry:execute()
    local result = self.roll:roll()
    local pos = indexof(statsheet.units, self.src)
    local entry = ApplyEffect.new(self.src, self.src, GuardStatus.new(result.sum):timingbefore(pos):setduration(1))
    agm.stack:buffereffect(entry)
    agm.bufferoutput('**[Defend]** %s', self.src.display)
    agm.bufferoutput(result.msg)
end

function UnitCommand.attack(src, targetname)
    local target = statsheet:getunit(targetname)
    local entry = AttackEntry.new(src, target, src.ap)
    agm.stack:buffereffect(entry)
    agm.bufferoutput('**[Command]** %s attacks %s', src.display, target.display)
end

function UnitCommand.defend(src)
    local entry = DefendEntry.new(src, src.gp)
    agm.stack:buffereffect(entry)
    agm.bufferoutput('**[Command]** %s Defends', src.display)
end
