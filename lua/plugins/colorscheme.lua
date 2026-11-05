-- match Cursor's "Default Dark+" theme
return {
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    opts = {
      style = "dark",
      transparent = false,
      italic_comments = true,
      color_overrides = vim.env.NVIM_WORKTREE_BG and { vscBack = vim.env.NVIM_WORKTREE_BG } or nil,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
