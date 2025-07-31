return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
  opts = {},
  dependencies = {
    "MunifTanjim/nui.nvim",
    -- "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          silent = true,
        },
      },
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
    })
    
    -- Set cmdline color to match your tan colorscheme
    -- Removed vim.schedule to avoid callback errors
    vim.api.nvim_set_hl(0, "NoiceCmdline", { fg = "#e1e3cb" })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePrompt", { fg = "#e1e3cb" })
    vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = "#e1e3cb" })
    vim.api.nvim_set_hl(0, "NoiceCmdlineIconCmdline", { fg = "#e1e3cb" })
    vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch", { fg = "#e1e3cb" })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { fg = "#e1e3cb" })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#e1e3cb" })
    vim.api.nvim_set_hl(0, "MsgArea", { fg = "#e1e3cb" })
    vim.api.nvim_set_hl(0, "Cmdline", { fg = "#e1e3cb" })
    -- Try overriding with force
    vim.api.nvim_set_hl(0, "NoiceCmdline", { fg = "#e1e3cb", force = true })
    
    -- Also set an autocmd to ensure it applies after colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "NoiceCmdline", { fg = "#e1e3cb" })
        vim.api.nvim_set_hl(0, "NoiceCmdlinePrompt", { fg = "#e1e3cb" })
        vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = "#e1e3cb" })
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { fg = "#e1e3cb" })
        vim.api.nvim_set_hl(0, "MsgArea", { fg = "#e1e3cb" })
      end,
    })
  end,
}
