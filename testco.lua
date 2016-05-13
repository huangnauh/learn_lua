local socket = require "socket"

host = "www.w3.org"
file = "/TR/REC-html32.html"


function download()
    local c = assert(socket.connect(host, 80))
    c:send("GET " .. file .. " HTTP/1.0\r\n\r\n")
    while true do
        local s, status, partial = c:receive(2^10)
        io.write(s or partial)
        if status == 'closed' then break end
    end
    c:close()
end

function receive(c)
    c:settimeout(0)
    local s, status, partial = c:receive(2^10)
    print(#(s or partial),status)
    if status == "timeout" then
        coroutine.yield(c)
    end
    return s or partial, status
end

function down(host, file)
    local c = assert(socket.connect(host, 80))
    local count = 0
    c:send("GET " .. file .. " HTTP/1.0\r\n\r\n")
    while true do
        local s, status, partial = receive(c)
        count = count + #(s or partial)
        if status == 'closed' then break end
    end
    c:close()
    print(file,count)
end

threads = {}
function get(host, file)
    local co = coroutine.create(function ()
        down(host, file)
    end)
    table.insert(threads, co)
end

function dispatch ()
    local i = 1
    local connections = {}
    while true do
        if threads[i] == nil then
            if threads[1] == nil then
                break
            end
            i = 1
            connections = {}
        end
        local status, res = coroutine.resume(threads[i])
        if not res then
            table.remove(threads,i)
        else
            i = i+1
            connections[#connections + 1] = res
            if #connections == #threads then
                socket.select(connections)
            end
        end
    end
end

get(host, file)
get(host, file)
get(host, file)
get(host, file)
dispatch()
--download()
