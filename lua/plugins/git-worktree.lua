return {
  "ThePrimeagen/git-worktree.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  lazy = false,  -- Load immediately
  config = function()
    local worktree = require("git-worktree")
    local telescope = require("telescope")
    
    -- Setup git-worktree
    worktree.setup({
      change_directory_command = "cd",
      update_on_change = true,
      update_on_change_command = "e .",
      clearjumps_on_change = true,
      autopush = false,
    })

    -- Setup telescope extension
    telescope.load_extension("git_worktree")

    -- Hooks for automatic neovim directory switching
    worktree.on_tree_change = function(op, metadata)
      if op == worktree.Operations.Switch then
        print("Switched to worktree: " .. metadata.path)
        -- Trigger file refresh
        vim.cmd("checktime")
        -- Update working directory
        vim.cmd("cd " .. metadata.path)
        -- Refresh files for new context
        vim.cmd("checktime")
      elseif op == worktree.Operations.Create then
        print("Created worktree: " .. metadata.path)
        -- Auto-switch to new worktree
        vim.cmd("cd " .. metadata.path)
        -- Initialize files in new worktree
        vim.cmd("checktime")
      elseif op == worktree.Operations.Delete then
        print("Deleted worktree: " .. metadata.path)
        -- If we're in the deleted worktree, go back to main
        local current_dir = vim.fn.getcwd()
        if string.find(current_dir, metadata.path) then
          -- Find git root and switch to main
          local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
          if git_root and git_root ~= "" then
            vim.cmd("cd " .. git_root)
            vim.cmd("checktime")
          end
        end
      end
    end

    -- Custom keymaps
    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { desc = desc })
    end

    -- Telescope git worktree commands
    map("n", "<leader>cw", function()
      telescope.extensions.git_worktree.git_worktrees()
    end, "Switch Git Worktree")

    map("n", "<leader>cwc", function()
      telescope.extensions.git_worktree.create_git_worktree()
    end, "Create Git Worktree")

    -- Quick commands for claude workflow
    map("n", "<leader>cs", function()
      -- Create new claude session worktree
      local session_name = vim.fn.input("Claude session name: ")
      if session_name and session_name ~= "" then
        -- Use the AI_WORKTREE_PREFIX from environment
        local prefix = vim.env.AI_WORKTREE_PREFIX or "claude-session-"
        local full_name = prefix .. session_name
        
        -- Get current branch for base
        local current_branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
        if current_branch == "" then
          current_branch = "main"
        end
        
        -- Create worktree
        worktree.create_worktree(full_name, current_branch)
      end
    end, "Start New Claude Session")

    -- Status line integration
    vim.api.nvim_create_autocmd({ "DirChanged", "BufEnter" }, {
      pattern = "*",
      callback = function()
        -- Update status line with current worktree info
        local cwd = vim.fn.getcwd()
        local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
        
        if git_root and git_root ~= "" then
          local worktree_name = vim.fn.fnamemodify(cwd, ":t")
          -- Check if we're in a claude session worktree
          local prefix = vim.env.AI_WORKTREE_PREFIX or "claude-session-"
          if string.match(worktree_name, "^" .. prefix) then
            vim.g.worktree_status = "🤖 " .. worktree_name:gsub("^" .. prefix, "")
          elseif cwd ~= git_root then
            vim.g.worktree_status = "🌿 " .. worktree_name
          else
            vim.g.worktree_status = "🌿 main"
          end
        else
          vim.g.worktree_status = ""
        end
      end,
    })
  end,

  keys = {
    { "<leader>cw", desc = "Switch Git Worktree" },
    { "<leader>cwc", desc = "Create Git Worktree" },
    { "<leader>cs", desc = "Start Claude Session" },
  },
}