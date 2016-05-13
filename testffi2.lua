local ffi = require "ffi"
--ffi.cdef 声明了一些被 zlib 库提供的 C 函数
ffi.cdef[[
unsigned long compressBound(unsigned long sourcelen);
int compress(uint8_t *dest, unsigned long *destLen,
        const uint8_t *source, unsigned long sourceLen, int level);
int uncompress(uint8_t *dest, unsigned long *destLen,
        const uint8_t *source, unsigned long sourceLen);
]]
--ffi.load 函数会自动填补前缀和后缀，所以我们简单地使用 z 这个字母就 可以加载了
local zlib = ffi.load(ffi.os == "Windows" and "zlib1" or "z")

local function compress(txt)
    local n = zlib.compressBound(#txt)
--    分配了一个要压缩字符串长度的字节缓冲区。
    local buf = ffi.new("uint8_t[?]", n)
--    [?]意味着他是一个变长数组。它的实际长度由ffi.new函数的第二个参数指定。
    local buflen = ffi.new("unsigned long[1]", n)
    local res = zlib.compress(buf, buflen, txt, #txt, 9)
    assert(res == 0)
--    ffi.string函数需要一个指向数据起始区的指针和实际长度
    return ffi.string(buf, buflen[0])
end

local function uncompress(comp, n)
    local buf = ffi.new("uint8_t[?]",n)
    local buflen = ffi.new("unsigned long[1]", n)
    local res = zlib.uncompress(buf, buflen, comp, #comp)
    assert(res == 0)
    return ffi.string(buf, buflen[0])
end

local txt = string.rep("abcd", 1000)
print("uncompressed size:", #txt)
local c = compress(txt)
print("compressed size:", #c)
local txt2 = uncompress(c, #txt)
print(txt == txt2)


