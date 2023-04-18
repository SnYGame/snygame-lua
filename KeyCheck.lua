KeyCheck = {}
setmetatable(KeyCheck, {__index = function(_, key) error(string.format('Table has no key %s', key))  end})

function KeyCheck:has(key)
    return rawget(self, key) ~= nil
end