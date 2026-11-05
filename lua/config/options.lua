-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- pick up files changed on disk by another process (e.g. Claude Code) instead of
-- editing a stale buffer; paired with the `checktime` autocmd in autocmds.lua
vim.o.autoread = true
