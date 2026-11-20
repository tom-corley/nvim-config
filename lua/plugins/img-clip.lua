return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      dir_path = "assets",
      relative_to_current_file = true,
      prompt_for_file_name = false,
    },
  },
  keys = {
    {
      "<C-v>",
      function()
        local pasted_image = require("img-clip").paste_image()
        if not pasted_image then
          vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
        end
      end,
      mode = { "i", "n" },
      ft = "markdown",
      desc = "Paste image or text from clipboard",
    },
  },
}
