agm.import('util/Statsheet')
agm.import('util/KeyCheck')
agm.import('util/Tables')

GlobalCommand = {}
setmetatable(GlobalCommand, {__index = KeyCheck})

local function tickdurations(prev_timing, curr_timing, turn)
    for _, unit in ipairs(statsheet.units) do
        if type(unit) ~= 'string' then
            local size = #unit.statuses
            for i, status in ipairs(unit.statuses) do
                if status:hastiming(prev_timing, curr_timing) and status:tickduration(turn) <= 0 then
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
    local prev_move = statsheet.move == 0 and TURN_END or statsheet.units[statsheet.move]
    local prev_turn = statsheet.turn
    repeat
        statsheet.move = statsheet.move + 1
        if statsheet.move > #statsheet.units then
            statsheet.move = 1
            statsheet.turn = statsheet.turn + 1
        end
    until type(statsheet.units[statsheet.move]) == 'table'

    if prev_turn ~= statsheet.turn then
        tickdurations(prev_move, TURN_END, prev_turn)
        tickdurations(TURN_END, statsheet.units[statsheet.move], statsheet.turn)
    else
        tickdurations(prev_move, statsheet.units[statsheet.move], statsheet.turn)
    end
    agm.bufferoutput("%s's move", statsheet.units[statsheet.move].display)
end