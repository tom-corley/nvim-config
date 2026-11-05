-- show hidden + gitignored files in the file picker (<leader>ff), since
-- .personal is a dotdir that git ignores but still has real working files in it
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
          exclude = { ".git", "node_modules", ".DS_Store" },
        },
        files = {
          hidden = true,
          ignored = true,
          exclude = {
            "node_modules",
            ".git",
            "dist",
            ".turbo",
            ".pnpm-store",
            "storybook-static",
            "typesense-data",
          },
        },
      },
    },
  },
}
