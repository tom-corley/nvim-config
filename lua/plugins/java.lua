-- jdtls (the Java language server) needs Java 25+ to *run*, but the projects
-- still compile for Java 21. Point the launcher at JDK 25 and register both
-- runtimes so jdtls picks the right one from each pom.xml.
local jdk_21_home = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
local jdk_25_home = "/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home"

-- the Homebrew JDKs only exist on the Macs, so leave jdtls on its defaults elsewhere
if not (vim.uv.fs_stat(jdk_21_home) and vim.uv.fs_stat(jdk_25_home)) then
  return {}
end

return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts.cmd = opts.cmd or { vim.fn.exepath("jdtls") }
      table.insert(opts.cmd, "--java-executable=" .. jdk_25_home .. "/bin/java")

      opts.settings = opts.settings or {}
      opts.settings.java = opts.settings.java or {}
      opts.settings.java.configuration = {
        runtimes = {
          { name = "JavaSE-21", path = jdk_21_home, default = true },
          { name = "JavaSE-25", path = jdk_25_home },
        },
      }
    end,
  },
}
