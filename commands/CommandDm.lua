agm.import('util/Statsheet')
agm.import('util/KeyCheck')
agm.import('util/Tables')

GlobalCommand = {}
setmetatable(GlobalCommand, {__index = KeyCheck})

local function tickdurations(timing)
    for _, unit in ipairs(statsheet.units) do
        if type(unit) ~= 'string' then
            local size = #unit.statuses
            for i, status in ipairs(unit.statuses) do
                if status:hastiming(timing) and status:updateduration() <= 0 then
                    agm.bufferoutput('%s expired', status:shortstr())
                    unit.statuses[i] = nil
                end
            end
            tablecompact(unit.statuses, size)
        end
    end
end

function GlobalCommand.move()
    agm.requiredm()
    repeat
        tickdurations(statsheet.move)
        statsheet.move = statsheet.move + 1
        if statsheet.move > #statsheet.units then
            tickdurations(0)
            tickdurations(TURN_END)
            statsheet.move = 1
            statsheet.turn = statsheet.turn + 1
        end
    until type(statsheet.units[statsheet.move]) ~= 'string'
    agm.bufferoutput("%s's move", statsheet.units[statsheet.move].display)
end