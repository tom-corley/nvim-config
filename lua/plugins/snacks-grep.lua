-- grep is literal by default so `funcname(` works; <leader>sx opts back into regex
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        grep = {
          regex = false,
        },
      },
    },
  },
  keys = {
    {
      "<leader>sx",
      function()
        Snacks.picker.grep({ regex = true })
      end,
      desc = "Grep (regex)",
    },
  },
}
