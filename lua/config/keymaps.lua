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
