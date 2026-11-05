return {
  "isakbm/gitgraph.nvim",
  dependencies = { "sindrets/diffview.nvim" },
  opts = {
    format = {
      timestamp = "%H:%M:%S %d-%m-%Y",
      fields = { "hash", "timestamp", "author", "branch_name", "tag" },
    },
    hooks = {
      on_select_commit = function(commit)
        vim.cmd("DiffviewOpen " .. commit.hash .. "^!")
      end,
      on_select_range_commit = function(from, to)
        vim.cmd("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
      end,
    },
  },
  keys = {
    {
      "<leader>gG",
      function()
        require("gitgraph").draw({}, { all = true, max_count = 5000 })
      end,
      desc = "Git graph (all branches)",
    },
    {
      "<leader>gF",
      function()
        local out = vim.fn.systemlist({
          "git", "for-each-ref", "--sort=-committerdate",
          "--format=%(refname:short)", "refs/heads", "refs/remotes",
        })
        local items = {}
        for _, name in ipairs(out) do
          if not name:match("/HEAD$") then
            items[#items + 1] = { text = name, name = name }
          end
        end
        Snacks.picker.pick({
          title = "Graph branches (Tab = multi-select, Enter = show)",
          items = items,
          format = "text",
          preview = "none",
          confirm = function(picker)
            local sel = picker:selected({ fallback = true })
            picker:close()
            local names = vim.tbl_map(function(i) return i.name end, sel)
            if #names == 0 then return end
            require("gitgraph").draw({}, {
              revision_range = table.concat(names, " "),
              max_count = 5000,
            })
          end,
        })
      end,
      desc = "Git graph (filter branches)",
    },
  },
}
