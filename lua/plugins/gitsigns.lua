return {
  "lewis6991/gitsigns.nvim",
  tag = "v0.8.1", -- Pin to stable version
  event = "VeryLazy",
  config = function()
    require('gitsigns').setup({
      _threaded_diff = false, -- Disable threaded diffs to fix encode/decode issue with Neovim 0.12.0-dev
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┃' },
      },
      signcolumn = true,
      current_line_blame = true,
      show_deleted = true, -- Show deleted lines with virtual text
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'overlay',
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      diff_opts = {
        algorithm = 'myers',
      },
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        
        -- Keymaps
        vim.keymap.set('n', '<leader>hp', gs.preview_hunk_inline, {buffer = bufnr, desc = "Preview hunk inline"})
        vim.keymap.set('n', '<leader>hi', function()
          -- Toggle inline diff highlighting
          if vim.b.gitsigns_inline_diff_enabled then
            gs.toggle_deleted()
            vim.b.gitsigns_inline_diff_enabled = false
            print("Inline diff disabled")
          else
            gs.toggle_deleted()
            vim.b.gitsigns_inline_diff_enabled = true
            print("Inline diff enabled")
          end
        end, {buffer = bufnr, desc = "Toggle inline diff highlighting"})
        vim.keymap.set('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.nav_hunk('next') end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Next hunk"})
        
        vim.keymap.set('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.nav_hunk('prev') end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Previous hunk"})
        
        -- Actions
        vim.keymap.set('n', '<leader>hs', gs.stage_hunk, {buffer = bufnr, desc = "Stage hunk"})
        vim.keymap.set('n', '<leader>hr', gs.reset_hunk, {buffer = bufnr, desc = "Reset hunk"})
        vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, {buffer = bufnr, desc = "Toggle line blame"})
        vim.keymap.set('n', '<leader>hd', gs.diffthis, {buffer = bufnr, desc = "Diff this"})
      end
    })
  end,
}