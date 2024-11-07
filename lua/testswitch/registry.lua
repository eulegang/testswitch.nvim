local util = require("testswitch.util")
local js = require("testswitch.javascript")

--- @type Expansion
local js_expansion = { is_test = js.is_test, test_paths = js.test_paths, origin_paths = js.origin_paths }

--- @type { [string]: Expansion }
local defaults = {
  ts = js_expansion,
  tsx = js_expansion,
  js = js_expansion,
  jsx = js_expansion,
}

--- @type { [string]: Expansion }
local lookup_table = {}

--- @param file Path
--- @return boolean?
local function is_test(file)
  local conf = lookup_table[file.ext]
  local def = defaults[file.ext]

  if conf ~= nil then
    return conf.is_test(file, def) and true or false
  elseif def ~= nil then
    return def.is_test(file) and true or false
  else
    return nil
  end
end

local function expand_origin(file)
  local candidates
  local conf = lookup_table[file.ext]
  local def = defaults[file.ext]

  if conf ~= nil then
    candidates = conf.origin_paths(file, def)
  elseif def ~= nil then
    candidates = def.origin_paths(file)
  end

  for _, candidate in ipairs(candidates) do
    local path = util.reconstitute(candidate)

    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end

  return nil
end

--- @param file Path
--- @return string | nil
local function expand_test(file)
  local candidates
  local conf = lookup_table[file.ext]
  local def = defaults[file.ext]

  if conf ~= nil then
    candidates = conf.test_paths(file, def)
  elseif def ~= nil then
    candidates = def.test_paths(file)
  end

  for _, candidate in ipairs(candidates) do
    local path = util.reconstitute(candidate)

    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end

  return nil
end

--- @param ext string
--- @param exp Expansion
local function register(ext, exp)
  if type(exp) == "string" then
    lookup_table[ext] = require(exp)
  else
    lookup_table[ext] = exp
  end
end

local function clear()
  lookup_table = {}
end

--- @param ext string
local function is_registered(ext)
  local conf = lookup_table[ext]
  local def = defaults[ext]

  if conf ~= nil then
    return true
  elseif def ~= nil then
    return true
  else
    return false
  end
end

return {
  is_test = is_test,
  expand_test = expand_test,
  expand_origin = expand_origin,
  register = register,
  is_registered = is_registered,
  clear = clear,
}
