-- Alpha-nvim 3D Rotating Cube Configuration
-- Save this as ~/.config/nvim/lua/alpha-cube.lua

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Configuration constants
local CUBE_WIDTH = 27
local DISTANCE_FROM_CAM = 80
local K1 = 16
local INCREMENT_SPEED = 0.6
local ROTATION_SPEED = 0.05
local ANIMATION_FPS = 15 -- Lower FPS for smoother neovim performance

-- Animation state
local rotation = { A = 0, B = 0, C = 0 }
local animation_timer = nil
local current_frame = {}

-- Math helper functions
local function calculate_x(i, j, k, A, B, C)
    local sin_A, cos_A = math.sin(A), math.cos(A)
    local sin_B, cos_B = math.sin(B), math.cos(B)
    local sin_C, cos_C = math.sin(C), math.cos(C)
    
    return (j * sin_A * sin_B * cos_C - k * cos_A * sin_B * cos_C +
            j * cos_A * sin_C + k * sin_A * sin_C + i * cos_B * cos_C)
end

local function calculate_y(i, j, k, A, B, C)
    local sin_A, cos_A = math.sin(A), math.cos(A)
    local sin_B, cos_B = math.sin(B), math.cos(B)
    local sin_C, cos_C = math.sin(C), math.cos(C)
    
    return (j * cos_A * cos_C + k * sin_A * cos_C -
            j * sin_A * sin_B * sin_C + k * cos_A * sin_B * sin_C -
            i * cos_B * sin_C)
end

local function calculate_z(i, j, k, A, B, C)
    local sin_A, cos_A = math.sin(A), math.cos(A)
    local sin_B, cos_B = math.sin(B), math.cos(B)
    
    return k * cos_A * cos_B - j * sin_A * cos_B + i * sin_B
end

-- Render a single cube frame
local function render_cube_frame(A, B, C)
    local width, height = vim.o.columns, 25 -- Cube rendering area
    local buffer = {}
    local z_buffer = {}
    
    -- Initialize buffers
    for i = 1, height do
        buffer[i] = {}
        z_buffer[i] = {}
        for j = 1, width do
            buffer[i][j] = ' '
            z_buffer[i][j] = 0
        end
    end
    
    -- Function to plot a point on the cube
    local function calculate_for_surface(cube_x, cube_y, cube_z, ch)
        local x = calculate_x(cube_x, cube_y, cube_z, A, B, C)
        local y = calculate_y(cube_x, cube_y, cube_z, A, B, C)
        local z = calculate_z(cube_x, cube_y, cube_z, A, B, C) + DISTANCE_FROM_CAM
        
        if z <= 0 then return end
        
        local ooz = 1 / z
        local xp = math.floor(width / 2 + K1 * ooz * x * 2)
        local yp = math.floor(height / 2 + K1 * ooz * y * 0.95)
        
        if xp > 0 and xp <= width and yp > 0 and yp <= height then
            if ooz > z_buffer[yp][xp] then
                z_buffer[yp][xp] = ooz
                buffer[yp][xp] = ch
            end
        end
    end
    
    -- Render all faces of the cube
    local step = math.max(1, math.floor(INCREMENT_SPEED))
    for cube_x = -CUBE_WIDTH, CUBE_WIDTH, step do
        for cube_y = -CUBE_WIDTH, CUBE_WIDTH, step do
            calculate_for_surface(cube_x, cube_y, -CUBE_WIDTH, '@')  -- Front face
            calculate_for_surface(CUBE_WIDTH, cube_y, cube_x, ')')   -- Right face
            calculate_for_surface(-CUBE_WIDTH, cube_y, -cube_x, '~') -- Left face
            calculate_for_surface(-cube_x, cube_y, CUBE_WIDTH, '#')  -- Back face
            calculate_for_surface(cube_x, -CUBE_WIDTH, -cube_y, ';') -- Bottom face
            calculate_for_surface(cube_x, CUBE_WIDTH, cube_y, '+')   -- Top face
        end
    end
    
    -- Convert buffer to string array
    local frame_lines = {}
    for i = 1, height do
        frame_lines[i] = table.concat(buffer[i])
    end
    
    return frame_lines
end

-- Update the animation frame
local function update_animation()
    -- Update rotation angles
    rotation.A = rotation.A + ROTATION_SPEED
    rotation.B = rotation.B + ROTATION_SPEED
    rotation.C = rotation.C + ROTATION_SPEED / 5
    
    -- Generate new frame
    current_frame = render_cube_frame(rotation.A, rotation.B, rotation.C)
    
    -- Update the alpha display if it's currently visible
    if vim.bo.filetype == "alpha" then
        alpha.redraw()
    end
end

-- Start the animation timer
local function start_animation()
    if animation_timer then
        animation_timer:close()
    end
    
    animation_timer = vim.loop.new_timer()
    animation_timer:start(0, math.floor(1000 / ANIMATION_FPS), function()
        vim.schedule(update_animation)
    end)
end

-- Stop the animation timer
local function stop_animation()
    if animation_timer then
        animation_timer:close()
        animation_timer = nil
    end
end

-- No header needed - removed graffiti header function

-- Custom header function that returns the current frame
local function get_animated_header()
    if #current_frame == 0 then
        -- Generate initial frame
        current_frame = render_cube_frame(rotation.A, rotation.B, rotation.C)
    end
    return current_frame
end

-- Set up the dashboard sections
dashboard.section.header.val = function()
    -- Return only the cube animation
    if #current_frame == 0 then
        -- Generate initial frame
        current_frame = render_cube_frame(rotation.A, rotation.B, rotation.C)
    end
    return current_frame
end
dashboard.section.header.opts.hl = "AlphaHeader"

-- Remove visible buttons but keep functionality through key mappings
dashboard.section.buttons.val = {}

-- Add key mappings for functionality without visible buttons
vim.api.nvim_create_autocmd("FileType", {
    pattern = "alpha",
    callback = function()
        vim.keymap.set("n", "e", ":ene <BAR> startinsert<CR>", { buffer = true, silent = true })
        vim.keymap.set("n", "f", ":lua Snacks.picker.files()<CR>", { buffer = true, silent = true })
        vim.keymap.set("n", "r", ":lua Snacks.picker.recent()<CR>", { buffer = true, silent = true })
        vim.keymap.set("n", "p", ":lua Snacks.picker.projects()<CR>", { buffer = true, silent = true })
        vim.keymap.set("n", "s", ":e $MYVIMRC<CR>", { buffer = true, silent = true })
        vim.keymap.set("n", "L", ":Lazy<CR>", { buffer = true, silent = true })
        vim.keymap.set("n", "q", ":qa<CR>", { buffer = true, silent = true })
    end,
})

-- Add footer
dashboard.section.footer.val = {
  "",
  "⚡ Neovim loaded",
}

-- Calculate dynamic padding for vertical centering
local function get_vertical_padding()
    local terminal_height = vim.o.lines
    local cube_height = 25 -- cube rendering area
    local footer_height = 2 -- footer lines
    local total_content_height = cube_height + footer_height + 1 -- +1 for padding between sections
    
    local available_space = terminal_height - total_content_height
    return math.max(1, math.floor(available_space / 2))
end

-- Set up the layout with dynamic vertical centering
dashboard.config.layout = {
    { type = "padding", val = function() return get_vertical_padding() end },
    dashboard.section.header,
    { type = "padding", val = 1 },
    dashboard.section.footer,
}

-- Auto commands to start/stop animation
vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaReady",
    callback = start_animation,
})

vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "alpha" then
            -- Don't stop animation if we're opening/closing snacks explorer
            local next_filetype = vim.schedule_wrap(function()
                if vim.bo.filetype ~= "snacks_explorer" then
                    stop_animation()
                end
            end)
            next_filetype()
        end
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "alpha" and not animation_timer then
            start_animation()
        end
    end,
})

-- Set up alpha
alpha.setup(dashboard.config)

-- Export the module
return {
    setup = function()
        alpha.setup(dashboard.config)
    end,
    start_animation = start_animation,
    stop_animation = stop_animation,
}
