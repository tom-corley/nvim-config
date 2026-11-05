return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Octo",
  init = function()
    local function restart_open_review_for_current_branch()
      local octo_reviews = package.loaded["octo.reviews"]
      if not octo_reviews then
        return
      end
      -- Only restart when the tab being viewed is a live review, not merely a review Octo still tracks
      local viewed_review = octo_reviews.get_current_review()
      if viewed_review == nil or viewed_review.layout == nil or not viewed_review.layout.file_panel:is_open() then
        return
      end
      -- Octo's BufEnter handler tries to rebuild the layout while it is being closed (E242)
      local saved_eventignore = vim.o.eventignore
      vim.o.eventignore = "BufEnter"
      pcall(viewed_review.layout.close, viewed_review.layout)
      vim.o.eventignore = saved_eventignore
      vim.cmd("checktime")
      vim.notify("Switching PR review to new branch...", vim.log.levels.INFO, { title = "Octo" })
      -- Let the closed tab and the checkout's buffer reloads settle before Octo builds the new layout
      vim.defer_fn(function()
        local ok = pcall(vim.cmd, "Octo review")
        if not ok then
          vim.notify("No PR found for this branch", vim.log.levels.WARN, { title = "Octo" })
        end
      end, 100)
    end

    local function define_selected_file_highlight()
      local visual = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
      vim.api.nvim_set_hl(0, "OctoFilePanelSelectedFile", { bg = visual.bg, bold = true })
    end
    define_selected_file_highlight()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = define_selected_file_highlight })

    -- Octo's own selected-file extmark loses to the filename's background, so draw it above everything
    local first_file_row = 1
    local selected_file_namespace = vim.api.nvim_create_namespace("octo_selected_review_file")
    vim.api.nvim_set_decoration_provider(selected_file_namespace, {
      on_win = function(_, _, bufnr)
        return vim.bo[bufnr].filetype == "octo_panel"
      end,
      on_line = function(_, winid, bufnr, row)
        if row < first_file_row or row ~= vim.api.nvim_win_get_cursor(winid)[1] - 1 then
          return
        end
        vim.api.nvim_buf_set_extmark(bufnr, selected_file_namespace, row, 0, {
          ephemeral = true,
          end_row = row + 1,
          end_col = 0,
          hl_group = "OctoFilePanelSelectedFile",
          hl_eol = true,
          priority = 10000,
        })
      end,
    })

    local function current_branch()
      return vim.trim(vim.fn.system({ "git", "branch", "--show-current" }))
    end

    local git_dir = vim.trim(vim.fn.system({ "git", "rev-parse", "--absolute-git-dir" }))
    if vim.v.shell_error == 0 then
      local last_branch = current_branch()
      local debounce = vim.uv.new_timer()
      vim.uv.new_fs_event():start(git_dir, {}, function(_, filename)
        if filename ~= "HEAD" then
          return
        end
        debounce:stop()
        debounce:start(
          200,
          0,
          vim.schedule_wrap(function()
            local branch = current_branch()
            if branch == "" or branch == last_branch then
              return
            end
            last_branch = branch
            restart_open_review_for_current_branch()
          end)
        )
      end)
    end

    -- Octo marks the local right-hand file read-only; undo that so it can be edited in the review
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function(event)
        local has_props, props = pcall(vim.api.nvim_buf_get_var, event.buf, "octo_diff_props")
        local is_local_right_file = has_props
          and props.split == "RIGHT"
          and not vim.api.nvim_buf_get_name(event.buf):match("^octo://")
        if is_local_right_file then
          vim.bo[event.buf].modifiable = true
        end
      end,
    })
  end,
  keys = {
    { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "List PRs" },
    { "<leader>gC", "<cmd>Octo pr<cr>", desc = "Current PR" },
    {
      "<leader>gn",
      function()
        vim.ui.select({ "Ready for review", "Draft" }, { prompt = "Create PR as:" }, function(choice)
          if not choice then
            return
          end
          vim.cmd(choice == "Draft" and "Octo pr create draft" or "Octo pr create")
        end)
      end,
      desc = "Create PR (pick draft/ready)",
    },
    {
      "<leader>gr",
      function()
        local in_review = require("octo.reviews").get_current_review() ~= nil
        if not in_review then
          vim.notify("Loading PR review...", vim.log.levels.INFO, { title = "Octo" })
        end
        if not in_review then
          vim.cmd("Octo review")
          return
        end
        -- Octo's BufEnter handler tries to rebuild the layout while it is being closed (E242)
        local saved_eventignore = vim.o.eventignore
        vim.o.eventignore = "BufEnter"
        pcall(vim.cmd, "Octo review close")
        vim.o.eventignore = saved_eventignore
      end,
      desc = "Toggle PR review",
    },
  },
  opts = {
    use_local_fs = true,
    mappings = {
      review_diff = {
        toggle_viewed = { lhs = "<leader>v", desc = "toggle viewed" },
        add_review_comment = { lhs = "<leader>gc", desc = "add/reply to comment" },
        add_review_suggestion = { lhs = "<leader>gs", desc = "add suggestion" },
      },
      file_panel = { toggle_viewed = { lhs = "<leader>v", desc = "toggle viewed" } },
    },
  },
}
