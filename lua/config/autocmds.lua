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

-- New Java files: write the package declaration (derived from the path under
-- src/main/java or src/test/java) and an empty class skeleton, like an IDE does.
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  group = vim.api.nvim_create_augroup("java_skeleton", { clear = true }),
  pattern = "*.java",
  callback = function(ev)
    -- the file explorer creates the file on disk first, so also handle an empty existing file
    local existing = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
    if #existing > 1 or (existing[1] or "") ~= "" then
      return
    end
    local path = vim.fn.fnamemodify(ev.file, ":p")
    local name = vim.fn.fnamemodify(ev.file, ":t:r")
    local pkg = path:match("/src/[^/]+/java/(.*)/[^/]+%.java$")
    local lines = {}
    if pkg then
      table.insert(lines, "package " .. pkg:gsub("/", ".") .. ";")
      table.insert(lines, "")
    end
    local kind = name:match("^I[A-Z]") and "interface" or "class"
    vim.list_extend(lines, { "public " .. kind .. " " .. name .. " {", "    ", "}" })
    vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, lines)
    vim.api.nvim_win_set_cursor(0, { #lines - 1, 4 })
  end,
})
