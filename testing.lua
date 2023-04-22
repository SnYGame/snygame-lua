agm.import('util/Statsheet')
agm.import('units/ControllableUnit')
agm.import('effects/Dice')
agm.import('commands/DmCommand')
agm.import('statuses/BaseStatus')

function agm.runcommand(command, ...)
    local src = statsheet:getunit(command)
    if src ~= nil then
        src:command(...)
    elseif GlobalCommand:has(command) then
        GlobalCommand[command](...)
    else
        error(string.format('Command %s not found', command))
    end
end

statsheet:addteam('Players')
statsheet:addteam('Enemies')
statsheet:addunit(ControllableUnit.new("Sample Player 1", 'p1', 60), 'Players')
statsheet:addunit(ControllableUnit.new("Sample Player 2", 'p2', 60), 'Players')
--statsheet:addunit(ControllableUnit.new("Sample Enemy 1", 'e1', 120), 'Enemies')
--statsheet:addunit(ControllableUnit.new("Sample Enemy 2", 'e2', 120), 'Enemies')
statsheet:getunit('p1'):setap(Dice.XdY(16, 2)):setgp(Dice.flat(8)):setcp(Dice.flat(7))
statsheet:getunit('p2'):setap(Dice.XdY(3, 6)):setgp(Dice.XdY(2, 10)):setcp(Dice.flat(5))

--UnitCommand.attack(statsheet:getunit('p2'), 'e2')
--UnitCommand.attack(statsheet:getunit('p1'), 'e1')

print(statsheet:repr())