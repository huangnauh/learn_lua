local Account = {balance=100}

function Account:new(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

local Ac = {balance=50}

local mt = {__index = Ac}

function Ac:new(o)
    o = o or {}
    print("Ac",mt.__index.balance)
    return setmetatable(o,mt)
end

AA = Ac
Ac = nil

local x = AA:new{y=10}
print(x.balance)

local x = Account:new{y=10}
 print(x.balance)
