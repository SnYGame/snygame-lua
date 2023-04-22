agm.import('util/Statsheet')
agm.import('effects/Damage')
agm.import('effects/ApplyEffect')
agm.import('statuses/BasicEffect')

local AttackEntry = {}
setmetatable(AttackEntry, {__index = agm.StackEntry})

local DefendEntry = {}
setmetatable(DefendEntry, {__index = agm.StackEntry})

local ConcentrateEntry = {}
setmetatable(ConcentrateEntry, {__index = agm.StackEntry})

UnitCommand = {}

function AttackEntry.new(src, target)
    local entry = agm.StackEntry.new("Attack Command")
    entry.src = src
    entry.target = target
    setmetatable(entry, {__index = AttackEntry})
    return entry
end

function AttackEntry:tostring()
    return string.format("%s --> %s\nAttack Potential: %s", self.src.display, self.target.display, self.src.ap:tostring())
end

function AttackEntry:execute()
    local result = self.src.ap:roll()
    agm.bufferoutput('**[Attack]** %s --> %s', self.src.display, self.target.display)
    agm.bufferoutput(result.msg)
    local amount = self.src:applyrollmod(result)
    local entry = DamageSingle.new(self.src, self.target, amount)
    agm.stack:buffereffect(entry)
end

function DefendEntry.new(src)
    local entry = agm.StackEntry.new("Defend Command")
    entry.src = src
    setmetatable(entry, {__index = DefendEntry})
    return entry
end

function DefendEntry:tostring()
    return string.format("Target: %s\nGuard Potential: %s", self.src.display, self.src.gp:tostring())
end

function DefendEntry:execute()
    local result = self.src.gp:roll()
    local pos = indexof(statsheet.units, self.src)
    agm.bufferoutput("**[Defend]** %s's roll", self.src.display)
    agm.bufferoutput(result.msg)
    local amount = self.src:applyrollmod(result)
    local entry = ApplyEffect.new(self.src, self.src, GuardEffect.new(amount):timingbefore(pos):setduration(1))
    agm.stack:buffereffect(entry)
end

function ConcentrateEntry.new(src)
    local entry = agm.StackEntry.new("Concentrate Command")
    entry.src = src
    setmetatable(entry, {__index = ConcentrateEntry})
    return entry
end

function ConcentrateEntry:tostring()
    return string.format("Target: %s\nCharge Potential: %s", self.src.display, self.src.gp:tostring())
end

function ConcentrateEntry:execute()
    local result = self.src.cp:roll()
    agm.bufferoutput("**[Concentrate]** %s's roll", self.src.display)
    agm.bufferoutput(result.msg)
    local amount = self.src:applyrollmod(result)
    local entry = ApplyEffect.new(self.src, self.src, ChargeEffect.new(amount))
    agm.stack:buffereffect(entry)
end

function UnitCommand.attack(src, targetname)
    local target = statsheet:getunit(targetname)
    local entry = AttackEntry.new(src, target)
    agm.stack:buffereffect(entry)
    agm.bufferoutput('**[Command]** %s attacks %s', src.display, target.display)
end

function UnitCommand.defend(src)
    local entry = DefendEntry.new(src)
    agm.stack:buffereffect(entry)
    agm.bufferoutput('**[Command]** %s defends', src.display)
end

function UnitCommand.concentrate(src)
    local entry = ConcentrateEntry.new(src)
    agm.stack:buffereffect(entry)
    agm.bufferoutput('**[Command]** %s concentrates', src.display)
end
