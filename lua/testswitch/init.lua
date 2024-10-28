--- @class Path
--- @field dir string
--- @field name string
--- @field ext string

--- @class Expansion
--- @field is_test fun(Path): boolean
--- @field test_paths fun(Path): Path[]
--- @field origin_paths fun(Path): Path[]

local reg = require("testswitch.registry")
local util = require("testswitch.util")

local function toggle()
  local file = util.parts(vim.fn.expand("%"))

  if not reg.is_registered(file.ext) then
    return
  end

  if reg.is_test(file)
  then
    local to = reg.expand_origin(file)
    if to then
      vim.cmd.e(to)
    else
      error("can not find origin file")
    end
  else
    local to = reg.expand_test(file)
    if to then
      vim.cmd.e(to)
    else
      error("can not find test file")
    end
  end
end

--- Setup this plugin
--- @param opts {ext?: {[string]: Expansion }}
local function setup(opts)
  for ext, expansion in pairs(opts.ext or {}) do
    reg.register(ext, expansion)
  end
end

--- @param path string
--- @return boolean | nil
local function is_test(path)
  local file = util.parts(path)

  if file == "" then
    return nil
  end

  if not reg.is_registered(file.ext) then
    return nil
  end

  return reg.is_test(file)
end

--- @param path string
--- @return string | nil
local function counterpart(path)
  local file = util.parts(path)

  if not reg.is_registered(file.ext) then
    return nil
  end

  if reg.is_test(file)
  then
    return reg.expand_origin(file)
  else
    return reg.expand_test(file)
  end
end

return {
  toggle = toggle,
  setup = setup,
  is_test = is_test,
  counterpart = counterpart,
}
