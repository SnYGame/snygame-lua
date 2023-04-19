agm.import('util/KeyCheck')

statsheet = {name = 'Incident name', turn = 1, units = {}, move = 0}
setmetatable(statsheet, {__index = KeyCheck})
setmetatable(statsheet.units, {__index = KeyCheck})

function statsheet:tostring()
    return string.format('```\n%s\nTurn %d\n\n%s```%s', self.name, self.turn, self.units:tostring(),
            self.move == 0 and '' or self.units[self.move].display .. "'s move")
end

function statsheet.units:tostring()
    local strbuilder = {}
    for _, unit in ipairs(self) do
        if type(unit) == 'string' then
            table.insert(strbuilder, string.format("> %s <\n", unit))
        else
            table.insert(strbuilder, string.format("%s\n", unit:tostring()))
        end
    end
    return table.concat(strbuilder, '\n')
end

function statsheet:setname(name)
    self.name = name
end

function statsheet:incrementturn()
    self.turn = self.turn + 1
end

function statsheet:addunit(newunit, team)
    local currteam = nil
    for i, unit in ipairs(self.units) do
        if type(unit) == 'string' then
            if currteam == team then
                table.insert(self.units, i, newunit)
                return
            else
                currteam = unit
            end
        end
    end
    if currteam == team then
        table.insert(self.units, newunit)
        return
    end
    error(string.format('Team %s not found', team))
end

function statsheet:getunit(name)
    for _, unit in ipairs(self.units) do
        if type(unit) ~= 'string' and unit.name == name then
            return unit
        end
    end
end

function statsheet:addteam(name)
    for _, unit in ipairs(self.units) do
        if unit == name then
            error(string.format('Team %s already exists', name))
        end
    end
    table.insert(self.units, name)
end

function statsheet:repr()
    return string.format('{\n  name = %q,\n  turn = %d,\n  units = %s\n}',
            self.name, self.turn, string.gsub(self.units:repr(), '\n', '\n  '))
end

function statsheet.units:repr()
    if #self == 0 then
        return '{}'
    end

    local strbuilder = {}
    for _, unit in ipairs(self) do
        if type(unit) == 'string' then
            table.insert(strbuilder, string.format('%q', unit))
        else
            table.insert(strbuilder, unit:repr())
        end
    end
    return '{\n  ' .. table.concat(strbuilder, ',\n  ') .. '\n}'
end

function agm.displaysheet()
    return statsheet:tostring()
end