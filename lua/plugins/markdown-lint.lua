-- markdownlint-cli2 is too strict for prose notes (MD013 line-length, MD060
-- table style) and spams the buffer with diagnostics — turn linting off,
-- keep render-markdown.nvim + marksman + prettier formatting from the
-- lang.markdown extra
return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
}
