-- render png/pdf/etc inline (needs ghostty/kitty protocol, magick, gs)
return {
  "folke/snacks.nvim",
  opts = {
    image = { enabled = true },
  },
  init = function()
    -- snacks hides a buffer image when its tab is left and never un-hides it, so coming back shows a blank buffer
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      once = true,
      callback = function()
        local Placement = require("snacks.image.placement")
        local update = Placement.update
        Placement.update = function(self)
          if self.hidden and not self.opts.inline and #self:wins() > 0 then
            self.hidden = false
          end
          return update(self)
        end
      end,
    })
  end,
}
