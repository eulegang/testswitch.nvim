local stub = require("luassert.stub")
local mod = require("testswitch.registry")

local function file_exists(files)
  return function(file)
    for _, f in ipairs(files) do
      if file == f then
        return 1
      end
    end

    return 0
  end
end

describe("Registry", function()
  describe("plugin based", function()
    before_each(function()
      mod.clear()
      mod.register("ts", "testswitch-fixture.plugin")

      stub(vim.fn, "filereadable").invokes(file_exists({
        "src/xyz.ts",
        "foobar/xyz.test.ts",
      }))
    end)

    it("should expand test based on fixture plugin", function()
      assert.are.equals(mod.expand_test({ dir = "src", name = "xyz", ext = "ts" }), "foobar/xyz.test.ts")
    end)
    it("should expand code based on fixture plugin", function()
      assert.are.equals(mod.expand_origin({ dir = "foobar", name = "xyz.test", ext = "ts" }), "src/xyz.ts")
    end)
  end)
end)
