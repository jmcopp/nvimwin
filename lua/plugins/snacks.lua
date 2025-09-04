return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { 
      enabled = true,
      -- Configure explorer window
      win = {
        width = 50,  -- Try a fixed wider width first
        position = "left",
        keys = {
          ["<Esc>"] = "close",  -- Easy close with Escape
          ["q"] = "close",      -- Quick close with q
        },
      },
    },
    picker = { 
      enabled = true,
      -- Let Snacks auto-detect fd now that it's in PATH
    },
    indent = { enabled = false },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
    },
  },
  keys = {
    -- Use buffer picker and oldfiles which don't need external tools
    {
      "<leader>f",
      function()
        -- Use Snacks' buffers picker as it doesn't need external tools
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>ff",
      function()
        -- Use Vim's built-in file completion
        vim.ui.input({ prompt = "File pattern: ", default = "**/*" }, function(pattern)
          if pattern then
            local files = vim.fn.globpath(vim.fn.getcwd(), pattern, 0, 1)
            if #files > 0 then
              vim.ui.select(files, {
                prompt = "Select file:",
                format_item = function(item)
                  return vim.fn.fnamemodify(item, ":.")
                end,
              }, function(choice)
                if choice then
                  vim.cmd("edit " .. vim.fn.fnameescape(choice))
                end
              end)
            else
              vim.notify("No files found", vim.log.levels.WARN)
            end
          end
        end)
      end,
      desc = "Find Files (Native)",
    },
    {
      "<leader><leader>",
      function()
        -- Use the explorer for actual file browsing
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
    {
      "<leader>fd",
      function()
        -- Debug: test fd directly
        local fd_path = vim.fn.expand("~") .. "\\AppData\\Local\\nvim\\bin\\fd.exe"
        local result = vim.fn.system(fd_path .. " --type f")
        local files = vim.split(result, "\n")
        vim.notify("Found " .. #files .. " files with fd", vim.log.levels.INFO)
        -- Show first 5 files as a test
        for i = 1, math.min(5, #files) do
          if files[i] and files[i] ~= "" then
            print(files[i])
          end
        end
      end,
      desc = "Test fd",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep Files",
    },
    -- Explorer (non-picker)
    {
      "<leader>e",
      function()
        Snacks.explorer()
        -- Force resize using vim commands
        vim.cmd([[
          autocmd BufEnter * ++once execute 'vertical resize 100'
        ]])
      end,
      desc = "File Explorer",
    },
    -- Manual resize if needed
    {
      "<leader>E",
      function()
        -- Find the leftmost window (likely the explorer)
        local leftmost_win = nil
        local leftmost_col = 999999
        
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local pos = vim.api.nvim_win_get_position(win)
          if pos[2] < leftmost_col then
            leftmost_col = pos[2]
            leftmost_win = win
          end
        end
        
        if leftmost_win then
          local new_width = 100  -- Adjust this value as needed
          vim.api.nvim_win_set_width(leftmost_win, new_width)
          vim.notify("Resized explorer to width " .. new_width, vim.log.levels.INFO)
        end
      end,
      desc = "Resize Explorer Wider",
    },
    -- Other
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>Z",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Toggle Zoom",
    },
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "Q",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
      mode = { "n", "v" },
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
    {
      "<c-/>",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
    {
      "<c-_>",
      function()
        Snacks.terminal()
      end,
      desc = "which_key_ignore",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
  init = function()
    -- Add fd to PATH for this Neovim session
    local fd_path = vim.fn.expand("~") .. "\\AppData\\Local\\nvim\\bin"
    vim.env.PATH = fd_path .. ";" .. vim.env.PATH
    
    -- Polyfill for string.buffer compatibility
    if not pcall(require, "string.buffer") then
      package.preload["string.buffer"] = function()
        return {
          new = function() return {} end
        }
      end
    end
    
    -- Files app integration: Open Files app in directory of current file
    _G.open_in_files = function()
      local current_file = vim.fn.expand('%:p')
      local dir
      
      if current_file and current_file ~= '' then
        dir = vim.fn.fnamemodify(current_file, ':h')
        vim.notify("Opening Files app in: " .. dir, vim.log.levels.INFO)
      else
        dir = vim.fn.getcwd()
        vim.notify("No current file, using working directory: " .. dir, vim.log.levels.INFO)
      end
      
      -- Launch Files app using your exact command pattern
      vim.schedule(function()
        -- Convert forward slashes to backslashes for Windows
        dir = dir:gsub('/', '\\')
        -- Remove any trailing backslash to avoid double backslashes
        dir = dir:gsub('\\+$', '')
        
        local cmd = 'powershell -Command "start shell:AppsFolder\\Files_1y0xx7n9077q4!App \\"' .. dir .. '\\""'
        vim.fn.jobstart(cmd, { detach = true })
      end)
    end
    
    -- Files app integration with file closing: Open Files app for current file, then close it
    _G.open_file_and_files_app = function()
      local current_file = vim.fn.expand('%:p')
      local dir
      
      if current_file and current_file ~= '' then
        dir = vim.fn.fnamemodify(current_file, ':h')
        
        -- Convert forward slashes to backslashes for Windows
        dir = dir:gsub('/', '\\')
        -- Remove any trailing backslash to avoid double backslashes
        dir = dir:gsub('\\+$', '')
        
        -- Launch Files app
        local cmd = 'powershell -Command "start shell:AppsFolder\\Files_1y0xx7n9077q4!App \\"' .. dir .. '\\""'
        vim.fn.jobstart(cmd, { detach = true })
        
        -- Close the current file
        vim.cmd('q')
      else
        -- Fallback to current working directory
        dir = vim.fn.getcwd()
        dir = dir:gsub('/', '\\')
        dir = dir:gsub('\\+$', '')
        
        local cmd = 'powershell -Command "start shell:AppsFolder\\Files_1y0xx7n9077q4!App \\"' .. dir .. '\\""'
        vim.fn.jobstart(cmd, { detach = true })
        
        vim.notify("No current file, opened Files in working directory: " .. dir, vim.log.levels.INFO)
      end
    end
    
    -- Global keymap to open Files app for current file's directory
    vim.keymap.set("n", "<leader>\\", _G.open_file_and_files_app, { desc = "Open file and Files app, then close file" })
    
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command
        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
}
