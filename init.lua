-- require("core.mason-path")
require("core.lsp")
require("config.options")
require("config.keymaps")
require("config.autocmds")
-- require("config.mason-verify")
require("config.health-check")
require("core.lazy")

-- TEST: This should show on startup if this config is being used
vim.defer_fn(function()
  vim.notify("*** TEST: C:/Users/jcoppick/Appdata/Local/nvim/init.lua IS BEING LOADED! ***", vim.log.levels.WARN)
end, 1000)
