return {
  {
    "sainnhe/gruvbox-material",
    enabled = true,
    priority = 1000,
    config = function()
      -- Gruvbox-material settings
      vim.g.gruvbox_material_transparent_background = 1
      vim.g.gruvbox_material_foreground = "mix"
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_float_style = "bright"
      vim.g.gruvbox_material_statusline_style = "mix"
      vim.g.gruvbox_material_cursor = "auto"

      -- Apply gruvbox-material as base
      vim.cmd.colorscheme("gruvbox-material")

      -- Your custom color palette
      local custom_colors = {
        -- Your original color scheme
        bg = "#1e2127",        -- Very dark gray, almost black
        fg = "#e1e3cb",        -- Light beige (general text)
        comment = "#6a6c6b",   -- Dark gray (comments)
        keyword = "#ff3333",   -- Bright red (keywords)
        func = "#adbc50",      -- Lime green (functions)
        string = "#b28d2a",    -- Golden yellow (strings)
        type = "#899c98",      -- Grayish teal (types)
        operator = "#929e8c",  -- Grayish green (operators)
        punctuation = "#989b9a", -- Light gray (punctuation)
        constant = "#b28d2a",  -- Golden yellow (constants)
        property = "#899c98",  -- Grayish teal (properties)
        
        -- Gruvbox-inspired UI colors (from your catppuccin mocha overrides)
        text = "#ebdbb2",
        subtext1 = "#d5c4a1",
        subtext0 = "#bdae93",
        overlay2 = "#a89984",
        overlay1 = "#928374",
        overlay0 = "#595959",
        surface2 = "#4d4d4d",
        surface1 = "#404040",
        surface0 = "#292929",
        base = "#1d2021",
        mantle = "#191b1c",
        crust = "#141617",
        
        -- Gruvbox accent colors
        red = "#ea6962",
        orange = "#e78a4e",
        yellow = "#d8a657",
        green = "#a9b665",
        teal = "#89b482",
        blue = "#7daea3",
        mauve = "#d3869b",
        peach = "#e78a4e",
      }

      -- Comprehensive highlight overrides combining your colors with catppuccin-style theming
      local highlights = {
        -- Basic editor colors with your custom palette
        Normal = { fg = custom_colors.fg },
        NormalFloat = { bg = custom_colors.mantle },
        
        -- Your custom syntax highlighting
        Comment = { fg = custom_colors.comment, italic = true },
        Keyword = { fg = custom_colors.keyword },
        Function = { fg = custom_colors.func, bold = true },
        String = { fg = custom_colors.string },
        Type = { fg = custom_colors.type, bold = true },
        Operator = { fg = custom_colors.operator },
        Delimiter = { fg = custom_colors.punctuation },
        Constant = { fg = custom_colors.constant },
        
        -- Statements and conditionals
        Statement = { fg = custom_colors.keyword },
        Conditional = { fg = custom_colors.keyword },
        Repeat = { fg = custom_colors.keyword },
        Exception = { fg = custom_colors.keyword },
        
        -- Identifiers and variables
        Identifier = { fg = custom_colors.fg },
        
        -- Completion menu styling (from catppuccin)
        Pmenu = { bg = custom_colors.mantle, fg = custom_colors.text },
        PmenuSel = { bg = custom_colors.surface0, fg = custom_colors.text },
        PmenuSbar = { bg = custom_colors.surface0 },
        PmenuThumb = { bg = custom_colors.surface2 },
        PmenuExtra = { bg = custom_colors.mantle, fg = custom_colors.subtext1 },

        -- Floating windows
        FloatBorder = { bg = custom_colors.mantle, fg = custom_colors.surface2 },
        FloatTitle = { bg = custom_colors.mantle, fg = custom_colors.text },

        -- Blink.cmp specific highlighting
        BlinkCmpMenu = { bg = custom_colors.mantle, fg = custom_colors.text },
        BlinkCmpMenuBorder = { bg = custom_colors.mantle, fg = custom_colors.surface2 },
        BlinkCmpMenuSelection = { bg = custom_colors.surface0, fg = custom_colors.text },
        BlinkCmpScrollBarThumb = { bg = custom_colors.surface2 },
        BlinkCmpScrollBarGutter = { bg = custom_colors.surface0 },
        BlinkCmpLabel = { bg = custom_colors.mantle, fg = custom_colors.text },
        BlinkCmpLabelDeprecated = { bg = custom_colors.mantle, fg = custom_colors.overlay0, strikethrough = true },
        BlinkCmpLabelDetail = { bg = custom_colors.mantle, fg = custom_colors.subtext1 },
        BlinkCmpLabelDescription = { bg = custom_colors.mantle, fg = custom_colors.subtext1 },
        BlinkCmpKind = { bg = custom_colors.mantle, fg = custom_colors.peach },
        BlinkCmpSource = { bg = custom_colors.mantle, fg = custom_colors.overlay1 },
        BlinkCmpGhostText = { fg = custom_colors.overlay0, italic = true },
        BlinkCmpDoc = { bg = custom_colors.mantle, fg = custom_colors.text },
        BlinkCmpDocBorder = { bg = custom_colors.mantle, fg = custom_colors.surface2 },
        BlinkCmpDocSeparator = { bg = custom_colors.mantle, fg = custom_colors.surface1 },
        BlinkCmpDocCursorLine = { bg = custom_colors.surface0 },
        BlinkCmpSignatureHelp = { bg = custom_colors.mantle, fg = custom_colors.text },
        BlinkCmpSignatureHelpBorder = { bg = custom_colors.mantle, fg = custom_colors.surface2 },
        BlinkCmpSignatureHelpActiveParameter = { bg = custom_colors.surface0, fg = custom_colors.peach, bold = true },

        -- Snacks.nvim picker styling
        SnacksPicker = {},
        SnacksPickerBorder = { fg = custom_colors.surface0 },
        SnacksPickerPreview = {},
        SnacksPickerPreviewBorder = { fg = custom_colors.surface0 },
        SnacksPickerPreviewTitle = { fg = custom_colors.green },
        SnacksPickerBoxBorder = { fg = custom_colors.surface0 },
        SnacksPickerInputBorder = { fg = custom_colors.surface2 },
        SnacksPickerInputSearch = { fg = custom_colors.text },
        SnacksPickerList = {},
        SnacksPickerListBorder = { fg = custom_colors.surface0 },
        SnacksPickerListTitle = { fg = custom_colors.text },
        SnacksPickerDir = { fg = custom_colors.blue },
        SnacksPickerFile = { fg = custom_colors.text },
        SnacksPickerMatch = { fg = custom_colors.peach, bold = true },
        SnacksPickerCursor = { bg = custom_colors.surface0, fg = custom_colors.text },
        SnacksPickerSelected = { bg = custom_colors.surface0, fg = custom_colors.text },
        SnacksPickerIcon = { fg = custom_colors.blue },
        SnacksPickerSource = { fg = custom_colors.overlay1 },
        SnacksPickerCount = { fg = custom_colors.overlay1 },
        SnacksPickerFooter = { fg = custom_colors.overlay1 },
        SnacksPickerHeader = { fg = custom_colors.text, bold = true },
        SnacksPickerSpecial = { fg = custom_colors.peach },
        SnacksPickerIndent = { fg = custom_colors.surface1 },
        SnacksPickerMulti = { fg = custom_colors.peach },
        SnacksPickerTitle = { fg = custom_colors.text, bold = true },
        SnacksPickerPrompt = { fg = custom_colors.text },

        -- Snacks notifications
        SnacksNotifierNormal = { bg = custom_colors.mantle, fg = custom_colors.text },
        SnacksNotifierBorder = { bg = custom_colors.mantle, fg = custom_colors.surface2 },
        SnacksNotifierTitle = { bg = custom_colors.mantle, fg = custom_colors.text, bold = true },
        SnacksNotifierIcon = { bg = custom_colors.mantle, fg = custom_colors.blue },
        SnacksNotifierIconInfo = { bg = custom_colors.mantle, fg = custom_colors.blue },
        SnacksNotifierIconWarn = { bg = custom_colors.mantle, fg = custom_colors.yellow },
        SnacksNotifierIconError = { bg = custom_colors.mantle, fg = custom_colors.red },

        -- Snacks Dashboard
        SnacksDashboardNormal = { fg = custom_colors.text },
        SnacksDashboardDesc = { fg = custom_colors.subtext1 },
        SnacksDashboardFile = { fg = custom_colors.text },
        SnacksDashboardDir = { fg = custom_colors.blue },
        SnacksDashboardFooter = { fg = custom_colors.overlay1 },
        SnacksDashboardHeader = { fg = custom_colors.text, bold = true },
        SnacksDashboardIcon = { fg = custom_colors.blue },
        SnacksDashboardKey = { fg = custom_colors.peach },
        SnacksDashboardTerminal = { fg = custom_colors.text },
        SnacksDashboardSpecial = { fg = custom_colors.peach },

        -- Alpha dashboard transparency
        AlphaHeader = { fg = custom_colors.text },
        AlphaHeaderLabel = { fg = custom_colors.blue },
        AlphaButtons = { fg = custom_colors.text },
        AlphaShortcut = { fg = custom_colors.peach },
        AlphaFooter = { fg = custom_colors.overlay1 },

        -- Snacks Terminal
        SnacksTerminalNormal = { bg = custom_colors.mantle, fg = custom_colors.text },
        SnacksTerminalBorder = { bg = custom_colors.mantle, fg = custom_colors.surface2 },
        SnacksTerminalTitle = { bg = custom_colors.mantle, fg = custom_colors.text, bold = true },

        -- General UI elements
        CmpItemMenu = { fg = custom_colors.surface2 },
        CursorLineNr = { fg = custom_colors.text },
        GitSignsChange = { fg = custom_colors.peach },
        LineNr = { fg = custom_colors.overlay0 },
        LspInfoBorder = { link = "FloatBorder" },
        VertSplit = { bg = custom_colors.base, fg = custom_colors.surface0 },
        WhichKeyFloat = { bg = custom_colors.mantle },
        YankHighlight = { bg = custom_colors.surface2 },
        FidgetTask = { fg = custom_colors.subtext1 },
        FidgetTitle = { fg = custom_colors.peach },

        -- Indent guides
        IblIndent = { fg = custom_colors.surface0 },
        IblScope = { fg = custom_colors.overlay0 },

        -- Additional syntax highlighting
        Boolean = { fg = custom_colors.constant },
        Number = { fg = custom_colors.constant },
        Float = { fg = custom_colors.constant },
        PreProc = { fg = custom_colors.keyword },
        PreCondit = { fg = custom_colors.keyword },
        Include = { fg = custom_colors.keyword },
        Define = { fg = custom_colors.keyword },
        Error = { fg = custom_colors.red },
        StorageClass = { fg = custom_colors.type },
        Tag = { fg = custom_colors.keyword },
        Label = { fg = custom_colors.keyword },
        Structure = { fg = custom_colors.type },
        Title = { fg = custom_colors.func },
        Special = { fg = custom_colors.operator },
        SpecialChar = { fg = custom_colors.operator },
        Ignore = { fg = custom_colors.subtext1 },
        Macro = { fg = custom_colors.teal },

        -- Tree-sitter highlights with your custom colors
        ["@variable"] = { fg = custom_colors.fg },
        ["@variable.builtin"] = { fg = custom_colors.fg },
        ["@variable.parameter"] = { fg = custom_colors.fg },
        ["@variable.member"] = { fg = custom_colors.property },
        ["@property"] = { fg = custom_colors.property },
        ["@field"] = { fg = custom_colors.property },
        
        ["@function"] = { fg = custom_colors.func, bold = true },
        ["@function.builtin"] = { fg = custom_colors.func, bold = true },
        ["@function.call"] = { fg = custom_colors.func },
        ["@method"] = { fg = custom_colors.func },
        ["@method.call"] = { fg = custom_colors.func },
        ["@constructor"] = { fg = custom_colors.func },
        
        ["@keyword"] = { fg = custom_colors.keyword },
        ["@keyword.function"] = { fg = custom_colors.keyword },
        ["@keyword.return"] = { fg = custom_colors.keyword },
        ["@keyword.conditional"] = { fg = custom_colors.keyword },
        ["@keyword.repeat"] = { fg = custom_colors.keyword },
        ["@keyword.exception"] = { fg = custom_colors.keyword },
        ["@conditional"] = { fg = custom_colors.keyword },
        ["@repeat"] = { fg = custom_colors.keyword },
        ["@exception"] = { fg = custom_colors.keyword },
        
        ["@string"] = { fg = custom_colors.string },
        ["@string.escape"] = { fg = custom_colors.operator },
        ["@string.special"] = { fg = custom_colors.operator },
        ["@character"] = { fg = custom_colors.string },
        ["@character.special"] = { fg = custom_colors.operator },
        
        ["@type"] = { fg = custom_colors.type, bold = true },
        ["@type.builtin"] = { fg = custom_colors.type, bold = true },
        ["@type.definition"] = { fg = custom_colors.type, bold = true },
        ["@type.qualifier"] = { fg = custom_colors.type },
        
        ["@constant"] = { fg = custom_colors.constant },
        ["@constant.builtin"] = { fg = custom_colors.constant },
        ["@constant.macro"] = { fg = custom_colors.constant },
        ["@number"] = { fg = custom_colors.constant },
        ["@boolean"] = { fg = custom_colors.constant },
        ["@float"] = { fg = custom_colors.constant },
        
        ["@operator"] = { fg = custom_colors.operator },
        ["@keyword.operator"] = { fg = custom_colors.operator },
        
        ["@punctuation.delimiter"] = { fg = custom_colors.punctuation },
        ["@punctuation.bracket"] = { fg = custom_colors.punctuation },
        ["@punctuation.special"] = { fg = custom_colors.punctuation },
        
        ["@comment"] = { fg = custom_colors.comment, italic = true },
        ["@comment.documentation"] = { fg = custom_colors.comment, italic = true },
        
        ["@tag"] = { fg = custom_colors.keyword },
        ["@tag.attribute"] = { fg = custom_colors.property },
        ["@tag.delimiter"] = { fg = custom_colors.punctuation },
        
        ["@namespace"] = { fg = custom_colors.type },
        ["@include"] = { fg = custom_colors.keyword },
        ["@preproc"] = { fg = custom_colors.keyword },
        ["@define"] = { fg = custom_colors.keyword },
        ["@macro"] = { fg = custom_colors.teal },
        
        -- LSP semantic tokens
        ["@lsp.type.class"] = { fg = custom_colors.type, bold = true },
        ["@lsp.type.comment"] = { fg = custom_colors.comment, italic = true },
        ["@lsp.type.decorator"] = { fg = custom_colors.func },
        ["@lsp.type.enum"] = { fg = custom_colors.type },
        ["@lsp.type.enumMember"] = { fg = custom_colors.property },
        ["@lsp.type.function"] = { fg = custom_colors.func },
        ["@lsp.type.interface"] = { fg = custom_colors.type },
        ["@lsp.type.keyword"] = { fg = custom_colors.keyword },
        ["@lsp.type.macro"] = { fg = custom_colors.constant },
        ["@lsp.type.method"] = { fg = custom_colors.func },
        ["@lsp.type.namespace"] = { fg = custom_colors.type },
        ["@lsp.type.number"] = { fg = custom_colors.constant },
        ["@lsp.type.operator"] = { fg = custom_colors.operator },
        ["@lsp.type.parameter"] = { fg = custom_colors.fg },
        ["@lsp.type.property"] = { fg = custom_colors.property },
        ["@lsp.type.string"] = { fg = custom_colors.string },
        ["@lsp.type.struct"] = { fg = custom_colors.type },
        ["@lsp.type.type"] = { fg = custom_colors.type },
        ["@lsp.type.variable"] = { fg = custom_colors.fg },
      }

      -- Apply all custom highlights
      for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
      end
    end,
  },
}
