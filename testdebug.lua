function foo()
    traceback()
    return 100
end
function traceback()
    for level = 1,30 do
        local info = debug.getinfo(level, 'S')
        if not info then
            break
        end
        for k,v in pairs(info) do
            print(k,v)
        end
        print("............")
    end
end

function bar(a, b)
    local a = 1
    do 
        local c = a
    end

    while true do
        local name, value = debug.getlocal(1, a)
        if not name then
            break
        end
        print(name, value)
        a = a+1
    end
end

bar('a', 'b')

