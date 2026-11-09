return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    keys = {
      { "<leader>M", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Toggle markdown render" },
    },
    opts = {
      heading = {
        width = "block",
        left_pad = 1,
        right_pad = 1,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        style = "full",
        width = "block",
        left_pad = 2,
        right_pad = 2,
        border = "thick",
        language_pad = 1,
      },
      bullet = { icons = { "●", "○", "◆", "◇" } },
      pipe_table = { style = "full", cell = "padded" },
      quote = { repeat_linebreak = true },
    },
  },
}
