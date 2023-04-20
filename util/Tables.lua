function tablecompact(table, size)
    local gap = 0
    for i=1,size do
        if table[i] == nil then
            gap = gap + 1
        elseif gap > 0 then
            table[i - gap] = table[i]
        end
    end
end