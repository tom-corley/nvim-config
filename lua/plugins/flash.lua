return {
  "folke/flash.nvim",
  opts = {
    modes = {
      char = {
        highlight = { backdrop = false },
      },
    },
  },
  init = function()
    local function set_flash_highlights()
      vim.api.nvim_set_hl(0, "FlashMatch", { fg = "#1a1b26", bg = "#ff9e64" })
    end
    set_flash_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_flash_highlights })
  end,
}
