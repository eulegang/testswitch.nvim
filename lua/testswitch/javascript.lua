--- @param path Path
--- @return boolean
local function is_test(path)
  return path.name:match(".test$")
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
    dir = path.dir .. "/tests",
    name = path.name .. ".test",
    ext = path.ext,
  })

  table.insert(res, {
    dir = path.dir .. "/tests",
    name = path.name,
    ext = path.ext,
  })

  table.insert(res, {
    dir = path.dir .. "/__tests__",
    name = path.name .. ".test",
    ext = path.ext,
  })

  table.insert(res, {
    dir = path.dir .. "/__tests__",
    name = path.name,
    ext = path.ext,
  })

  if path.dir:match("^src/") then
    table.insert(res, {
      dir = path.dir:gsub("^src/", "test/"),
      name = path.name .. ".test",
      ext = path.ext,
    })
  end

  return res
end

--- @param path Path
--- @return Path[]
local function origin_paths(path)
  local res = {}

  if path.name:match("%.test$") then
    table.insert(res, {
      dir = path.dir,
      name = path.name:gsub(".test$", ""),
      ext = path.ext,
    })

    if path.dir:match("/tests$") then
      table.insert(res, {
        dir = path.dir:gsub("/tests$", ""),
        name = path.name:gsub(".test$", ""),
        ext = path.ext,
      })
    end

    if path.dir:match("/__tests__$") then
      table.insert(res, {
        dir = path.dir:gsub("/__tests__$", ""),
        name = path.name:gsub(".test$", ""),
        ext = path.ext,
      })
    end
  end

  if path.dir:match("^test/") then
    table.insert(res, {
      dir = path.dir:gsub("^test/", "src/"),
      name = path.name:gsub(".test$", ""),
      ext = path.ext,
    })
  end

  return res
end

return {
  is_test = is_test,
  test_paths = test_paths,
  origin_paths = origin_paths,
}
