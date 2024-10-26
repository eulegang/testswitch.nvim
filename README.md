
# TestSwitch

easily switch between code and it's tests in neovim

## Installation

it's recommended to use Lazy. 

```
return {
  {
    "eulegang/testswitch",
    keys = {
      {
        "<c-n>",
        function()
          require("testswitch").toggle()
        end,
        desc = "switch code and test file"
      }
    }
  }
}
```

