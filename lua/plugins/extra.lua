return {
  -- Autotags
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },

  -- comments
  {
    "numToStr/Comment.nvim",
    opts = {},
    lazy = false,
  },

  -- Neovim plugin to improve the default vim.ui interfaces
  {
    "stevearc/dressing.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    config = function()
      require("dressing").setup()
    end,
  },

  -- Neovim notifications and LSP progress messages
  {
    "j-hui/fidget.nvim",
  },

  -- Heuristically set buffer options
  {
    "tpope/vim-sleuth",
  },

  -- editor config support
  {
    "editorconfig/editorconfig-vim",
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },

  -- {
  --   "utilyre/barbecue.nvim",
  --   name = "barbecue",
  --   version = "*",
  --   dependencies = {
  --     "SmiteshP/nvim-navic",
  --     "nvim-tree/nvim-web-devicons", -- optional dependency
  --   },
  --   opts = {
  --     -- configurations go here
  --   },
  --   config = function()
  --     require("barbecue").setup({
  --       create_autocmd = false, -- prevent barbecue from updating itself automatically
  --     })
  --
  --     vim.api.nvim_create_autocmd({
  --       "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
  --       "BufWinEnter",
  --       "CursorHold",
  --       "InsertLeave",
  --
  --       -- include this if you have set `show_modified` to `true`
  --       -- "BufModifiedSet",
  --     }, {
  --       group = vim.api.nvim_create_augroup("barbecue.updater", {}),
  --       callback = function()
  --         require("barbecue.ui").update()
  --       end,
  --     })
  --   end,
  -- },
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()

      require("mini.pairs").setup()

      -- local statusline = require("mini.statusline")
      -- statusline.setup({
      --   use_icons = vim.g.have_nerd_font,
      -- })
      -- ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      --   return "%2l:%-2v"
      -- end
    end,
  },

  {
    "fladson/vim-kitty",
    "MunifTanjim/nui.nvim",
  },
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = {
      startVisible = false,
    },
    keys = {
      {
        "<leader>up",
        function()
          require("precognition").toggle()
        end,
        desc = "Toggle Precognition",
      },
    },
  },

  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
      easing_function = "sine",
      performance_mode = false,
    },
  },

  {
    "folke/twilight.nvim",
    event = "VeryLazy",
    opts = {
      dimming = {
        alpha = 0.25,
        color = { "Normal", "#ffffff" },
        term_bg = "#000000",
        inactive = false,
      },
      context = 10,
      treesitter = true,
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
      },
    },
    keys = {
      {
        "<leader>uT",
        "<cmd>Twilight<cr>",
        desc = "Toggle Twilight",
      },
    },
  },

  -- Alpha.nvim dashboard with rotating cube
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      require("alpha-cube").setup()
      
      -- Handle directory opening and auto-open file explorer
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local argv = vim.fn.argv()
          if #argv == 1 and vim.fn.isdirectory(argv[1]) == 1 then
            vim.cmd("cd " .. vim.fn.fnameescape(argv[1]))
            -- Close the directory buffer first
            vim.cmd("bdelete")
            -- Open alpha only (removed explorer to avoid scheduling errors)
            vim.cmd("Alpha")
          elseif #argv == 0 then
            -- For plain 'nvim', do nothing to avoid scheduling errors
            -- User can manually open explorer with :Snacks explorer
          end
        end,
      })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "jbyuki/venn.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>uv",
        function()
          local venn_enabled = vim.inspect(vim.b.venn_enabled)
          if venn_enabled == "nil" then
            vim.b.venn_enabled = true
            vim.cmd([[setlocal ve=all]])
            vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
            print("Venn mode enabled")
          else
            vim.cmd([[setlocal ve=]])
            vim.cmd([[mapclear <buffer>]])
            vim.b.venn_enabled = nil
            print("Venn mode disabled")
          end
        end,
        desc = "Toggle Venn Drawing Mode",
      },
    },
  },

  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({
        groups = {
          'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
          'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
          'EndOfBuffer',
        },
        extra_groups = {},
        exclude_groups = {},
      })
      require("transparent").clear_prefix("BufferLine")
      require("transparent").clear_prefix("NeoTree")
    end
  },
}
