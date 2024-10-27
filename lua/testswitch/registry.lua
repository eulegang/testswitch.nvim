local util = require("testswitch.util")
local js = require("testswitch.javascript")

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
  return lookup_table[file.ext].is_test(file) and true or false
end

local function expand_origin(file)
  local candidates = lookup_table[file.ext].origin_paths(file)

  for _, candidate in ipairs(candidates) do
    local path = util.reconstitute(candidate)

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
    local path = util.reconstitute(candidate)

    if vim.fn.filereadable(path) then
      return path
    end
  end

  return nil
end

--- @param ext string
--- @param exp Expansion
local function register(ext, exp)
  lookup_table[ext] = exp
end

--- @param ext string
local function is_registered(ext)
  return lookup_table[ext] and true or false
end

return {
  is_test = is_test,
  expand_test = expand_test,
  expand_origin = expand_origin,
  register = register,
  is_registered = is_registered,
}
