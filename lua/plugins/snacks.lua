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
          ["<CR>"] = {
            desc = "Edit file and close explorer",
            callback = function(self, item)
              if not item or not item.file then return end
              
              local file = item.file
              local ext = vim.fn.fnamemodify(file, ":e"):lower()
              
              -- Text/code files that should open in Neovim
              local neovim_exts = {
                -- Text formats
                txt = true, md = true, markdown = true,
                -- Programming languages
                lua = true, vim = true, py = true, js = true, ts = true,
                jsx = true, tsx = true, c = true, cpp = true, h = true,
                hpp = true, rs = true, go = true, java = true, sh = true,
                bash = true, zsh = true, fish = true,
                -- Config files
                json = true, yaml = true, yml = true, toml = true, ini = true,
                conf = true, config = true, xml = true, html = true, css = true,
                scss = true, sass = true,
                -- Other text files
                log = true, csv = true, sql = true, diff = true, patch = true,
                gitignore = true, env = true,
              }
              
              -- Check if it's a text file or has no extension (likely text)
              if neovim_exts[ext] or ext == "" then
                -- Close explorer first
                self:close()
                -- Then open the file
                vim.schedule(function()
                  vim.cmd("edit " .. vim.fn.fnameescape(file))
                end)
              else
                -- For non-text files, use system open but keep explorer open
                self.keys["<C-o>"].callback(self, item)
              end
            end,
          },
          ["<C-o>"] = {
            desc = "Open with system default",
            callback = function(self, item)
              vim.notify("*** CTRL+O pressed - our config IS working! ***", vim.log.levels.WARN)
              if not item or not item.file then return end
              
              local file = item.file
              local ext = vim.fn.fnamemodify(file, ":e"):lower()
              
              vim.schedule(function()
                -- Convert to absolute path and escape properly for Windows
                local absolute_file = vim.fn.fnamemodify(file, ":p")
                
                -- Windows commands - using cmd /c for better compatibility
                local commands = {
                  -- Browser for PDFs
                  ["pdf"] = function(path)
                    return string.format('cmd /c start "" "%s"', path)
                  end,
                  
                  -- Microsoft Office
                  ["xlsx"] = function(path)
                    return string.format('cmd /c start "" "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\EXCEL.EXE" "%s"', path)
                  end,
                  ["xls"] = function(path)
                    return string.format('cmd /c start "" "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\EXCEL.EXE" "%s"', path)
                  end,
                  ["docx"] = function(path)
                    return string.format('cmd /c start "" "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\WINWORD.EXE" "%s"', path)
                  end,
                  ["doc"] = function(path)
                    return string.format('cmd /c start "" "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\WINWORD.EXE" "%s"', path)
                  end,
                  
                  -- SOLIDWORKS files
                  ["sldprt"] = function(path)
                    return string.format('cmd /c start "" "C:\\Program Files\\SOLIDWORKS Corp\\SOLIDWORKS\\SLDWORKS.exe" "%s"', path)
                  end,
                  ["sldasm"] = function(path)
                    return string.format('cmd /c start "" "C:\\Program Files\\SOLIDWORKS Corp\\SOLIDWORKS\\SLDWORKS.exe" "%s"', path)
                  end,
                  ["slddrw"] = function(path)
                    return string.format('cmd /c start "" "C:\\Program Files\\SOLIDWORKS Corp\\SOLIDWORKS\\SLDWORKS.exe" "%s"', path)
                  end,
                  
                  -- Additional common formats
                  ["png"] = function(path)
                    return string.format('cmd /c start "" "%s"', path)
                  end,
                  ["jpg"] = function(path)
                    return string.format('cmd /c start "" "%s"', path)
                  end,
                  ["jpeg"] = function(path)
                    return string.format('cmd /c start "" "%s"', path)
                  end,
                  ["html"] = function(path)
                    return string.format('cmd /c start "" "%s"', path)
                  end,
                }
                
                local cmd_func = commands[ext]
                if cmd_func then
                  local cmd = cmd_func(absolute_file)
                  
                  -- Debug output
                  vim.notify("Opening: " .. absolute_file, vim.log.levels.INFO)
                  
                  -- Check if file exists
                  if vim.fn.filereadable(absolute_file) ~= 1 then
                    vim.notify("File not found: " .. absolute_file, vim.log.levels.ERROR)
                    return
                  end
                  
                  -- Execute the command using job for better async handling
                  local job_id = vim.fn.jobstart(cmd, {
                    detach = true,
                    on_exit = function(_, exit_code)
                      if exit_code ~= 0 then
                        vim.notify("Failed to open file (exit code: " .. exit_code .. ")", vim.log.levels.ERROR)
                      end
                    end,
                    on_stderr = function(_, data)
                      if data and #data > 0 and data[1] ~= "" then
                        vim.notify("Error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
                      end
                    end,
                  })
                  
                  if job_id <= 0 then
                    vim.notify("Failed to start external program", vim.log.levels.ERROR)
                  end
                else
                  -- Default action for text files (open in nvim)
                  vim.cmd("edit " .. vim.fn.fnameescape(file))
                end
              end)
            end,
          },
          ["\\"] = {
            desc = "Open folder in muCommander",
            callback = function(self, item)
              vim.notify("Backslash pressed - opening muCommander!", vim.log.levels.INFO)
              
              if not item or not item.file then 
                vim.notify("No item or file!", vim.log.levels.ERROR)
                return 
              end
              
              local file = item.file
              local absolute_file = vim.fn.fnamemodify(file, ":p")
              local dir = vim.fn.fnamemodify(absolute_file, ":h")
              
              vim.schedule(function()
                local cmd = string.format('cmd /c start "" mucommander "%s"', dir)
                
                local job_id = vim.fn.jobstart(cmd, {
                  detach = true,
                  on_exit = function(_, exit_code)
                    if exit_code ~= 0 then
                      vim.notify("Failed to open muCommander (exit code: " .. exit_code .. ")", vim.log.levels.ERROR)
                    end
                  end,
                })
                
                if job_id <= 0 then
                  vim.notify("Failed to start muCommander", vim.log.levels.ERROR)
                end
              end)
            end,
          },
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
