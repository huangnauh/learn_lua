local mt = {}

Set = {}

function Set.new(l)
    local set = {}
    setmetatable(set, mt)
    for _, v in ipairs(l) do
        set[v] = true
    end
    return set
end

function Set.union(a,b)
    if getmetatable(a) ~= "Set" or getmetatable(b) ~= "Set" then
        error("attempt to 'add' a set with a non-set value", 2)
    end
    local res = Set.new{}
    for k in pairs(a) do
        res[k] = true
    end
    for k in pairs(b) do
        res[k] = true
    end
    return res
end

function Set.intersection(a,b)
    local res = Set.new{}
    for k in pairs(a) do
        res[k] = b[k]
    end
    return res
end

function Set.tostring(s)
    local l = {}
    for e in pairs(s) do
        l[#l+1] = e
    end
    return "{" .. table.concat(l,",") .. "}"
end

function Set.print(s)
    print(Set.tostring(s))
end

mt.__add = Set.union
mt.__mul = Set.intersection
mt.__metatable = "Set"

mt.__le = function (a, b)
    for k in pair(a) do
        if not b[k] then
            return false
        end
    end
    return true
end

mt.__lt = function (a, b)
    return a <= b and not (b <= a)
end

mt.__eq = function (a, b)
    return a <= b and b <= a
end

mt.__tostring = Set.tostring

s1 = Set.new{1,3,4,5}
s2 = Set.new{3,5,7,89}
s3 = s1+s2
Set.print(s3)
print(s1)
print(s1 == 10)



Pic = {}
Pic.prototype = {x=0,y=0,w=100,h=100}
Pic.mt = {}
function Pic.new(o)
    setmetatable(o,Pic.mt)
    return o
end

Pic.mt.__index = function (table, key)
    return Pic.prototype[key]
end

Pic.mt.__index = Pic.prototype

p = Pic.new{x=10,y=10}
print(p.w)


t = {1,2,3,4,5}

local _t = t

t = {}

local mt = {
    __index = function (t,k)
        return _t[k]
    end,
    __newindex = function (t,k,v)
        _t[k] = v
    end
}
print('now...')
setmetatable(t, mt)
for k,v in pairs(t) do
    print(k,v)
end
for k,v in pairs(_G) do
    print(k,v)
end
