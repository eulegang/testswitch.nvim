local str = require("string")

--- @param path Path
--- @return boolean
local function is_test(path)
  return str.match(path.name, ".test$")
end

--- @param path Path
--- @return Path[]
local function test_paths(path)
  local res = {}

  table.insert(res, {
    dir = path.dir,
    name = path.name .. ".test",
    ext = path.ext,
  })

  table.insert(res, {
    dir = path.dir .. "/test",
    name = path.name .. ".test",
    ext = path.ext,
  })

  return res
end

--- @param path Path
--- @return Path[]
local function origin_paths(path)
  local res = {}

  if string.match(path.name, "%.test$") then
    table.insert(res, {
      dir = path.dir,
      name = string.gsub(path.name, ".test$", ""),
      ext = path.ext,
    })

    if string.match(path.dir, "/test$") then
      table.insert(res, {
        dir = string.gsub(path.dir, "/test$", ""),
        name = string.gsub(path.name, ".test$", ""),
        ext = path.ext,
      })
    end
  end


  return res
end

return {
  is_test = is_test,
  test_paths = test_paths,
  origin_paths = origin_paths,
}
