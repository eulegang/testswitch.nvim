local stub = require("luassert.stub")
local mod = require("testswitch.init")

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

describe("#toggle", function()
  local e = stub(vim.cmd, "e")
  local notify = stub(vim, "notify")

  before_each(function()
    e:clear()
    notify:clear()
  end)


  describe("(with basic folder structure)", function()
    before_each(function()
      stub(vim.fn, "filereadable").invokes(file_exists({
        "src/xyz.ts",
        "src/xyz.test.ts",
      }))
    end)

    it("should toggle to test when toggling from code", function()
      stub(vim.fn, "expand").returns("src/xyz.ts")

      mod.toggle()

      assert.spy(e).was.called_with("src/xyz.test.ts")
    end)

    it("should toggle to code when toggling from test", function()
      stub(vim.fn, "expand").returns("src/xyz.test.ts")

      mod.toggle()

      assert.spy(e).was.called_with("src/xyz.ts")
    end)
  end)

  describe("(with missing test)", function()
    before_each(function()
      stub(vim.fn, "filereadable").invokes(file_exists({
        "src/xyz.ts",
      }))
    end)

    it("should not toggle to test but notify instead", function()
      stub(vim.fn, "expand").returns("src/xyz.ts")

      mod.toggle()

      assert.spy(e).was.not_called_with("src/xyz.test.ts")
      assert.spy(notify).was.called_with("can not find test file", vim.log.levels.ERROR)
    end)
  end)
end)

describe("#is_test", function()
  it("should check for test file", function()
    assert.is_true(mod.is_test("src/xyz.test.ts"))
  end)
  it("should check for test file", function()
    assert.is_not_true(mod.is_test("src/xyz.ts"))
  end)
end)

describe("#counterpart", function()
  before_each(function()
    stub(vim.fn, "filereadable").invokes(file_exists({
      "src/xyz.ts",
      "src/xyz.test.ts",
    }))
  end)

  it("should show the test", function()
    assert.are.equals(mod.counterpart("src/xyz.test.ts"), "src/xyz.ts")
  end)

  it("should show the code", function()
    assert.are.equals(mod.counterpart("src/xyz.ts"), "src/xyz.test.ts")
  end)
end)
