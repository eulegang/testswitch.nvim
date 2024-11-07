local M = {}


function M.test_paths(path)
  local res = {}

  if path.dir:match("^src") then
    table.insert(res, {
      dir = path.dir:gsub("^src", "foobar"),
      name = path.name .. ".test",
      ext = path.ext,
    })
  end

  return res
end

function M.origin_paths(path)
  local res = {}
  if path.dir:match("^foobar") then
    table.insert(res, {
      dir = path.dir:gsub("^foobar", "src"),
      name = path.name:gsub("%.test$", ""),
      ext = path.ext,
    })
  end
  return res
end

return M
