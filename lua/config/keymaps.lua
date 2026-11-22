-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local agent_terminal_opts = {
  win = { position = "right", width = 0.4 },
}

local agent_commands = {
  claude = true,
  codex = true,
}

-- only one agent is visible at a time; hiding the other keeps its terminal session alive
local function toggle_agent(command)
  for _, terminal in ipairs(Snacks.terminal.list()) do
    if terminal.cmd ~= command and agent_commands[terminal.cmd] and terminal:win_valid() then
      terminal:hide()
    end
  end

  Snacks.terminal.toggle(command, agent_terminal_opts)
end

vim.keymap.set("n", "<leader>m", function()
  toggle_agent("claude")
end, { desc = "Toggle Claude Code" })

-- intentionally replaces LazyVim's Notification History mapping
vim.keymap.set("n", "<leader>n", function()
  toggle_agent("codex")
end, { desc = "Toggle Codex" })

-- toggle a persistent shell in a short split along the bottom; hiding it leaves the process running
vim.keymap.set("n", "<leader>t", function()
  Snacks.terminal.toggle(nil, { win = { position = "bottom", height = 0.25 } })
end, { desc = "Toggle terminal" })

-- plain Esc is forwarded straight to whatever's running in the terminal (e.g. Claude
-- Code uses it to cancel/clear) — jk (typed quickly) reliably drops to Normal mode instead
vim.keymap.set("t", "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- lua modules are cached so a live re-source is unreliable — a full restart picks up every config change
vim.keymap.set("n", "<leader>R", "<cmd>silent! wall<cr><cmd>restart<cr>", { desc = "Restart Neovim" })

-- load every file changed since the last commit (staged, unstaged, untracked) as buffers
vim.keymap.set("n", "<leader>j", function()
  local changed_files = vim.fn.systemlist(
    "{ git diff --name-only --relative --diff-filter=d HEAD; git ls-files --others --exclude-standard; } | sort -u"
  )
  if #changed_files == 0 then
    vim.notify("No changed files", vim.log.levels.INFO)
    return
  end
  for _, changed_file in ipairs(changed_files) do
    vim.cmd.badd(vim.fn.fnameescape(changed_file))
  end
  vim.cmd.edit(vim.fn.fnameescape(changed_files[1]))
end, { desc = "Open changed files" })

-- LazyVim's root lookup resolves symlinks, so buffers under a worktree's .personal symlink point lazygit at the primary checkout
local cwd_git_root = function() return Snacks.git.get_root(vim.fn.getcwd()) end
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit({ cwd = cwd_git_root() }) end, { desc = "Lazygit (cwd root)" })
vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = cwd_git_root() }) end, { desc = "Git Log (cwd root)" })

-- load every file changed on this branch since it diverged from main, plus uncommitted work, as buffers
vim.keymap.set("n", "<leader>gj", function()
  local changed_files = vim.fn.systemlist(
    "{ git diff --name-only --relative --diff-filter=d main...HEAD; git diff --name-only --relative --diff-filter=d HEAD; git ls-files --others --exclude-standard; } | sort -u"
  )
  if #changed_files == 0 then
    vim.notify("No changed files", vim.log.levels.INFO)
    return
  end
  for _, changed_file in ipairs(changed_files) do
    vim.cmd.badd(vim.fn.fnameescape(changed_file))
  end
  vim.cmd.edit(vim.fn.fnameescape(changed_files[1]))
end, { desc = "Open branch diff files" })

-- picker of tracked files changed vs HEAD (staged + unstaged), with M/A/D/R status markers; untracked files hidden
vim.keymap.set("n", "<leader>gS", function()
  Snacks.picker.git_status({
    cwd = cwd_git_root(),
    filter = { filter = function(item) return item.status ~= "??" end },
  })
end, { desc = "Git Status (tracked changes vs HEAD)" })
