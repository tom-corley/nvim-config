-- snacks can't write list-of-table yaml (customCommands), so lazygit reads this repo-tracked file;
-- snacks appends its theme file to LG_CONFIG_FILE rather than replacing it
vim.env.LG_CONFIG_FILE = vim.fn.stdpath("config") .. "/lazygit.yml"

return {}
