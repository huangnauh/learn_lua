local ffi = require("ffi")
--cdata 类型用来将任意 C 数据保存在 Lua 变量中。
--cdata 不能在 Lua 中创建出来，也不能在 Lua 中修改。

ffi.cdef[[
int printf(const char *fmt, ...);
typedef struct {double x,y;} point_t;
]]
ffi.C.printf("hello %s!\n", "world")
local point
--通过使用 metatable （元表） ，可以为 cdata 自定义一组操作。
local mt = {
    __add = function (a, b)
        return point(a.x + b.x, a.y + b.y)
    end,
    __len = function (a)
        return math.sqrt(a.x * a.x + a.y * a.y)
    end,
    __index = {
        area = function (p)
            return p.x * p.x + p.y + p.y
        end
    },
}

--ffi.metatype会返回一个该类型的构造函数。
--metatable 与 C 类型的关联是永久的，而且不允许被修改，__index 元方法也是。
point = ffi.metatype("point_t", mt)

local a = point(3, 4)
print(a.x, a.y)
print(#a)



