return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = {"python", "lua", "javascript", "java", "c"},
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
