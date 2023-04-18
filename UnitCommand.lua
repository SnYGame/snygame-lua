agm.import('Statsheet')

UnitCommand = {}

function UnitCommand.attack(src, targetname)
    assert(src:has('ap'), string.format('Unit %s has no AP', src.display))
    local target = statsheet:getunit(targetname)
    local ap = src.ap
    local result = ap:roll()
    return string.format('%s attacked %s', src.display, target.display)
end