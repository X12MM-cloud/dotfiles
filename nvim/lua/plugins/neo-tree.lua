return {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons', -- Optional, for file icons
            'MunifTanjim/nui.nvim',
        },
        config = function()
            require("neo-tree").setup {
                -- Add any neo-tree configuration here
                -- Example:
                close_if_last_window = true,
                use_default_mappings = true,
                enable_git_status = true,
                enable_diagnostics = true,
            }

            -- Example keymap to open neo-tree
            vim.keymap.set('n', '<leader>e', ":Neotree reveal<CR>", { desc = "NeoTree (current file)" })
            vim.keymap.set('n', '<leader>E', ":Neotree float<CR>", { desc = "NeoTree (float)" })
        end
        }