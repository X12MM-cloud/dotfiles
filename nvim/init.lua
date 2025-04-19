vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    print("Cloning lazy.nvim...")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
    print("Lazy.nvim cloned.")
else
    print("Lazy.nvim already exists.")
end

vim.opt.rtp:prepend(lazypath)

local opts = {}

-- Create a function for opening a floating terminal
vim.api.nvim_create_user_command("TermFloat", function()
    -- Calculate window size (80% of editor width/height)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    
    -- Calculate starting position to center the window
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)
    
    -- Create buffer for terminal
    local buf = vim.api.nvim_create_buf(false, true)
    
    -- Set up window options
    local win_opts = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
    }
    
    -- Create window with the buffer
    local win = vim.api.nvim_open_win(buf, true, win_opts)
    
    -- Open terminal in the new buffer
    vim.fn.termopen(vim.o.shell)
    
    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, "filetype", "terminal")
    vim.api.nvim_buf_set_option(buf, "buflisted", false)
    
    -- Start in insert mode
    vim.cmd("startinsert")
end, {})

-- Set keybinding to open floating terminal
vim.keymap.set("n", "<leader>t", ":TermFloat<CR>", { noremap = true, silent = true, desc = "Open floating terminal" })

print("Runtime path after prepending lazy.nvim:")
print(vim.inspect(vim.o.runtimepath))


require("lazy").setup("plugins") -- Pass the plugins table to lazy.setup()

print("lazy.setup() finished.")
