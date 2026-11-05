-- per-folder glyphs (Nerd Font Material Design set) + colours, approximating Cursor's icon theme
local function folder(codepoint, hl)
  return { glyph = vim.fn.nr2char(codepoint), hl = hl }
end

return {
  "echasnovski/mini.icons",
  opts = {
    directory = {
      app = folder(0xf024b, "MiniIconsRed"),
      api = folder(0xf0870, "MiniIconsOrange"),
      auth = folder(0xf0250, "MiniIconsYellow"),
      components = folder(0xf0253, "MiniIconsGreen"),
      generated = folder(0xf107f, "MiniIconsRed"),
      hooks = folder(0xf0d0b, "MiniIconsPurple"),
      lib = folder(0xf10b5, "MiniIconsYellow"),
      packages = folder(0xf0253, "MiniIconsAzure"),
      services = folder(0xf0870, "MiniIconsOrange"),
      src = folder(0xf0968, "MiniIconsGreen"),
      stories = folder(0xf069d, "MiniIconsPurple"),
      tasks = folder(0xf19fa, "MiniIconsCyan"),
      tests = folder(0xf197e, "MiniIconsGreen"),
      __tests__ = folder(0xf197e, "MiniIconsGreen"),
      prisma = folder(0xf12e3, "MiniIconsBlue"),
      scripts = folder(0xf19fc, "MiniIconsGrey"),
      images = folder(0xf024f, "MiniIconsCyan"),
      public = folder(0xf024f, "MiniIconsCyan"),
      docs = folder(0xf0c82, "MiniIconsBlue"),
      config = folder(0xf107d, "MiniIconsGrey"),
      [".claude"] = folder(0xf107f, "MiniIconsOrange"),
      [".github"] = folder(0xf10ea, "MiniIconsGrey"),
      [".personal"] = folder(0xf08ac, "MiniIconsPurple"),
    },
  },
}
