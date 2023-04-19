agm.import('util/Statsheet')
agm.import('util/KeyCheck')

GlobalCommand = {}
setmetatable(GlobalCommand, {__index = KeyCheck})

function GlobalCommand.move()
    agm.requiredm()
    repeat
        statsheet.move = statsheet.move + 1
        if statsheet.move > #statsheet.units then
            statsheet.move = 1
            statsheet.turn = statsheet.turn + 1
        end
    until type(statsheet.units[statsheet.move]) ~= 'string'
    agm.bufferoutput("%s's move", statsheet.units[statsheet.move].display)
end