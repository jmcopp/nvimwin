return {
  "robitx/gp.nvim",
  name = "gp",
  event = "BufEnter",
  config = function()
    require("gp").setup({
      providers = {
        ollama = {
          endpoint = "http://localhost:11434/v1/chat/completions",
        },
        openrouter = {
          endpoint = "https://openrouter.ai/api/v1/chat/completions",
          secret = os.getenv("OPENROUTER_API_KEY"),
        },
      },
      whisper = {
        -- you can disable whisper completely by whisper = {disable = true}
        disable = false,

        -- OpenAI audio/transcriptions api endpoint to transcribe audio to text
        endpoint = "https://api.openai.com/v1/audio/transcriptions",
        -- directory for storing whisper files
        store_dir = (os.getenv("TMPDIR") or os.getenv("TEMP") or "/tmp") .. "/gp_whisper",
        -- multiplier of RMS level dB for threshold used by sox to detect silence vs speech
        -- decibels are negative, the recording is normalized to -3dB =>
        -- increase this number to pick up more (weaker) sounds as possible speech
        -- decrease this number to pick up only louder sounds as possible speech
        -- you can disable silence trimming by setting this a very high number (like 1000.0)
        silence = "1.75",
        -- whisper tempo (1.0 is normal speed)
        tempo = "1.75",
        -- The language of the input audio, in ISO-639-1 format.
        language = "en",
        -- command to use for recording can be nil (unset) for automatic selection
        -- string ("sox", "arecord", "ffmpeg") or table with command and arguments:
        -- sox is the most universal, but can have start/end cropping issues caused by latency
        -- arecord is linux only, but has no cropping issues and is faster
        -- ffmpeg in the default configuration is macos only, but can be used on any platform
        -- (see https://trac.ffmpeg.org/wiki/Capture/Desktop for more info)
        -- below is the default configuration for all three commands:
        -- whisper_rec_cmd = {"sox", "-c", "1", "--buffer", "32", "-d", "rec.wav", "trim", "0", "60:00"},
        -- whisper_rec_cmd = {"arecord", "-c", "1", "-f", "S16_LE", "-r", "48000", "-d", "3600", "rec.wav"},
        -- whisper_rec_cmd = {"ffmpeg", "-y", "-f", "avfoundation", "-i", ":0", "-t", "3600", "rec.wav"},
        rec_cmd = nil,
      },
      agents = {
        -- Disable ALL default agents
        { name = "ExampleDisabledAgent", disable = true },
        { name = "ChatGPT4o", disable = true },
        { name = "ChatGPT4o-mini", disable = true },
        { name = "ChatGPT-o3-mini", disable = true },
        { name = "ChatCopilot", disable = true },
        { name = "ChatGemini", disable = true },
        { name = "ChatPerplexityLlama3.1-8B", disable = true },
        { name = "ChatClaude-3-7-Sonnet", disable = true },
        { name = "ChatClaude-3-5-Haiku", disable = true },
        { name = "ChatOllamaLlama3.1-8B", disable = true },
        { name = "ChatLMStudio", disable = true },
        { name = "CodeGPT4o", disable = true },
        { name = "CodeGPT-o3-mini", disable = true },
        { name = "CodeGPT4o-mini", disable = true },
        { name = "CodeCopilot", disable = true },
        { name = "CodeGemini", disable = true },
        { name = "CodePerplexityLlama3.1-8B", disable = true },
        { name = "CodeClaude-3-7-Sonnet", disable = true },
        { name = "CodeClaude-3-5-Haiku", disable = true },
        { name = "CodeOllamaLlama3.1-8B", disable = true },

        -- Your custom agents
        {
          name = "Qwen2.5:3b",
          chat = true,
          command = true,
          provider = "ollama",
          model = { model = "qwen2.5:3b" },
          system_prompt = "I am an AI meticulously crafted to provide programming guidance and code assistance. "
            .. "To best serve you as a computer programmer, please provide detailed inquiries and code snippets when necessary, "
            .. "and expect precise, technical responses tailored to your development needs.\n",
        },
        {
          name = "Claude Sonnet 4",
          chat = true,
          command = true,
          provider = "openrouter",
          model = { 
            model = "anthropic/claude-sonnet-4",
            temperature = 0.7,
            max_tokens = 60000
          },
          system_prompt = "You are a general AI assistant.\n\n"
            .. "The user provided the additional info about how they would like you to respond:\n\n"
            .. "- If you're unsure don't guess and say you don't know instead.\n"
            .. "- Ask question if you need clarification to provide better answer.\n"
            .. "- Think deeply and carefully from first principles step by step.\n"
            .. "- Zoom out first to see the big picture and then zoom in to details.\n"
            .. "- Use Socratic method to improve your thinking and coding skills.\n"
            .. "- Don't elide any code from your output if the answer requires coding.\n"
            .. "- Take a deep breath; You've got this!\n",
        },
      },
      hooks = {
        -- example of usig enew as a function specifying type for the new buffer
        CodeReview = function(gp, params)
          local template = "I have the following code from nvim/lua/plugins/gp.lua:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please analyze for code smells and suggest improvements."
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
        end,
        -- example of making :%GpChatNew a dedicated command which
        -- opens new chat with the entire current buffer as a context
        BufferChatNew = function(gp, _)
          -- call GpChatNew command in range mode on whole buffer
          vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
        end,
        ReactIconSvg = function(gp, params)
          local buf = vim.api.nvim_get_current_buf()
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          local content = table.concat(lines, "\n")
          local template = "The following SVG code needs to be converted into a valid React component:\n\n"
            .. "INPUT:\n"
            .. "```tsx\n"
            .. content
            .. "```\n\n"
            .. "  - Remove the `width` and `height` props from the `<svg>` element\n"
            .. "  - Add `{...props}` to the bottom of the `<svg>` element\n"
            .. "  - Replace all `fill` values with `currentColor`\n"
            .. "  - Replace all props that are dash-separated (ex: `fill-rule`) with camelCase (ex: `fillRule`)\n"
            .. "  - Don't remove any other props or attributes\n"
            .. "  - Preserve the indentation rules\n"
            .. "  - Only include the code snippet, no additional context or explanation is needed."
          local agent = gp.get_command_agent()
          gp.logger.info("Updating React SVG: " .. agent.name)
          gp.Prompt(params, gp.Target.rewrite, agent, template, nil)
        end,
        UiIconExport = function(gp, params)
          local template = "The following React modules need to be refactored and properly exported:\n\n"
            .. "```tsx\n{{selection}}\n```\n\n"
            .. "  - Take the unused import at the bottom of the file and move it up to the other imports in the alphabetical orrder\n"
            .. "  - Export the unsed import in the `icons` array in alphabetical order\n"
            .. "  - Export the unsed import in the `export {` object in alphabetical order\n"
            .. "  - Only include the code snippet, no additional context or explanation is needed."
          local agent = gp.get_command_agent()
          gp.logger.info("Updating React SVG: " .. agent.name)
          gp.Prompt(params, gp.Target.rewrite, agent, template, nil)
        end,
      },
    })
  end,

  keys = function()
    require("which-key").add({
      -- VISUAL mode mappings
      {
        mode = { "v" },
        nowait = true,
        remap = false,
        { "<leader>gpr", ":<C-u>'<,'>GpRewrite<cr>", desc = "Visual Rewrite", icon = "󰗋" },
        { "<leader>gpn", "<cmd>GpNextAgent<cr>", desc = "Next Agent", icon = "󰗋" },
      },

      -- NORMAL mode mappings
      {
        mode = { "n" },
        nowait = true,
        remap = false,
        { "<leader>gpr", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
        { "<leader>gpn", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
      },

      -- INSERT mode mappings
      {
        mode = { "i" },
        nowait = true,
        remap = false,
        { "<leader>gpr", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
        { "<leader>gpn", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
      },
    })
  end,
}
  -- how to clear cache adding more llms: rm ~/.local/share/nvim/gp/persisted/
