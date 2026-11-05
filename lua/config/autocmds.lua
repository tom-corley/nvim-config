-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- autosave real file buffers, same triggers Cursor/VSCode use — `update` only writes
-- when the buffer is actually modified, so this stays silent and cheap otherwise
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost" }, {
  group = vim.api.nvim_create_augroup("autosave", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "" and vim.bo.modifiable and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! update")
    end
  end,
})

-- reload buffers changed on disk (requires 'autoread', set in options.lua) whenever
-- focus returns or typing pauses, so external edits don't silently go unnoticed
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("autoreload", { clear = true }),
  pattern = "*",
  command = "checktime",
})

-- watch each open buffer's directory so external edits (incl. temp-file+rename writes) reload immediately
local directory_watchers = {}
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("fs_watch", { clear = true }),
  callback = function(args)
    local path = vim.api.nvim_buf_get_name(args.buf)
    if path == "" or vim.bo[args.buf].buftype ~= "" then
      return
    end
    local directory = vim.fs.dirname(path)
    if directory_watchers[directory] then
      return
    end
    local watcher = vim.uv.new_fs_event()
    directory_watchers[directory] = watcher
    watcher:start(
      directory,
      {},
      vim.schedule_wrap(function()
        vim.cmd("silent! checktime")
      end)
    )
  end,
})

-- personal notes, not prose for review — LazyVim's wrap_spell autocmd turns spell on, so override it (registered later, runs later)
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("markdown_no_spell", { clear = true }),
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
})
