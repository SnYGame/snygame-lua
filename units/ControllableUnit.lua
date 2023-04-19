agm.import('units/BaseUnit')
agm.import('commands/CommandBasic')

ControllableUnit = {}
setmetatable(ControllableUnit, {__index = BaseUnit})

function ControllableUnit.new(display, name, hp)
    local unit = BaseUnit.new(display, name, hp)
    unit.commands = {attack = true, defend = true, concentrate = true}
    setmetatable(unit, {__index = ControllableUnit})
    return unit
end

function ControllableUnit:repr()
    repr, _ = string.gsub(BaseUnit.repr(self), 'BaseUnit', 'ControllableUnit', 1)
    return repr
end

function ControllableUnit:command(command, ...)
    assert(self.commands[command] ~= nil, string.format("Unit %s does not have access to the command %s", self.display, command))
    return UnitCommand[command](self, ...)
end