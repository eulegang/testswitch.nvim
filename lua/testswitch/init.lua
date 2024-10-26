local str = require("string")

local js = require("testswitch/javascript")

--- @class Path
--- @field dir string
--- @field name string
--- @field ext string

--- @class Expansion
--- @field is_test fun(Path): boolean
--- @field test_paths fun(Path): Path[]
--- @field origin_paths fun(Path): Path[]

--- @type Expansion
local js_expansion = { is_test = js.is_test, test_paths = js.test_paths, origin_paths = js.origin_paths }

--- @type { [string]: Expansion }
local lookup_table = {
  ts = js_expansion,
  tsx = js_expansion,
  js = js_expansion,
  jsx = js_expansion,
}

--- @param file Path
--- @return boolean
local function is_test(file)
  return lookup_table[file.ext].is_test(file)
end

--- @param file string
--- @return Path
local function parts(file)
  local _, _, dir, name, ext = str.find(file, "(.*)/([^/]*)%.(%a*)")

  return {
    dir = dir,
    name = name,
    ext = ext,
  }
end

--- @param file Path
--- @return string
local function reconstitute(file)
  return file.dir .. "/" .. file.name .. "." .. file.ext
end


local function expand_origin(file)
  local candidates = lookup_table[file.ext].origin_paths(file)

  for _, candidate in ipairs(candidates) do
    local path = reconstitute(candidate)

    if vim.fn.filereadable(path) then
      return path
    end
  end

  return nil
end

--- @param file Path
--- @return string | nil
local function expand_test(file)
  local candidates = lookup_table[file.ext].test_paths(file)

  for _, candidate in ipairs(candidates) do
    local path = reconstitute(candidate)

    if vim.fn.filereadable(path) then
      return path
    end
  end

  return nil
end


local function toggle()
  local file = parts(vim.fn.expand("%"))

  if is_test(file)
  then
    local to = expand_origin(file)
    if to then
      vim.cmd.e(to)
    else
      error("can not find origin file")
    end
  else
    local to = expand_test(file)
    if to then
      vim.cmd.e(to)
    else
      error("can not find test file")
    end
  end
end


--- Setup this plugin
--- @param opts {}
local function setup(opts)
  --options = opts
end

return {
  toggle = toggle,
  setup = setup
}
