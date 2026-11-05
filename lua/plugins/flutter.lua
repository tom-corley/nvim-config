return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "dart" })
    end,
  },
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function(_, opts)
      require("flutter-tools").setup(opts)
      -- Pub workspace monorepo: run the app from apps/mobile, not the workspace root.
      local mobile = vim.fn.getcwd() .. "/apps/mobile"
      if vim.uv.fs_stat(mobile .. "/pubspec.yaml") then
        require("flutter-tools").setup_project({
          { name = "mobile", cwd = mobile, target = "lib/main.dart" },
        })
      end
    end,
    opts = {
      lsp = {
        color = { enabled = true },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          renameFilesWithClasses = "prompt",
          enableSnippets = true,
        },
      },
      decorations = { statusline = { app_version = true, device = true } },
      dev_log = { enabled = true, open_cmd = "tabedit" },
    },
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Flutter run" },
      { "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "Flutter hot restart" },
      { "<leader>Fh", "<cmd>FlutterReload<cr>", desc = "Flutter hot reload" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter quit" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter devices" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter outline" },
      { "<leader>Fl", "<cmd>FlutterLogToggle<cr>", desc = "Flutter log" },
    },
  },
}
