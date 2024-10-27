local str = require("string")

--- @param file Path
--- @return string
local function reconstitute(file)
  return file.dir .. "/" .. file.name .. "." .. file.ext
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

return {
  reconstitute = reconstitute,
  parts = parts
}
