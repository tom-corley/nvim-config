-- show the buffer-name tab bar even with a single file open, so it's always
-- obvious which buffer you're looking at
return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      always_show_bufferline = true,
    },
  },
}
