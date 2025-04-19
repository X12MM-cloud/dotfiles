return {
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = 20,
                open_mapping = [[<leader>t]],
                hide_numbers = true,
                direction = 'float',
                close_on_exit = true,
                float_opts = {
                    border = 'curved',
                },
            })
        end
    },
    {
        'stevearc/overseer.nvim',
        config = function()
            require("overseer").setup({
                -- Simple floating window configuration
                task_list = {
                    direction = "float",
                    bindings = {
                        ["q"] = function() vim.cmd("OverseerClose") end,
                    },
                },
                -- Ensure output is displayed in a clean floating window
                form = {
                    border = "rounded",
                },
                -- Output window configuration
                templates = {
                    ["*"] = {
                        default_win_opts = {
                            focusable = true,
                            focus = true,
                            floating = true,
                            height = 0.8,
                            width = 0.8,
                        },
                    },
                },
            })
        end,
        priority = 100, -- Ensure it loads first
    },
    {
        'Zeioth/compiler.nvim',
        dependencies = {
            'stevearc/overseer.nvim',
        },
        cmd = { 'CompilerOpen', 'CompilerToggleResults', 'CompilerRedo' },
        config = function()

            -- Simple compiler.nvim setup
            require("compiler").setup()

            -- Language-specific compilation and execution commands
            local compilers = {
                c = {
                    cmd = function()
                        local file_name = vim.fn.expand("%:r")
                        return {
                            "gcc -o " .. file_name .. " " .. vim.fn.expand("%") .. " -Wall",
                            "./" .. file_name
                        }
                    end,
                    desc = "Compile and Run C"
                },
                cpp = {
                    cmd = function()
                        local file_name = vim.fn.expand("%:r")
                        return {
                            "g++ -o " .. file_name .. " " .. vim.fn.expand("%") .. " -Wall -std=c++17",
                            "./" .. file_name
                        }
                    end,
                    desc = "Compile and Run C++"
                },
                python = {
                    cmd = function()
                        return {
                            "python3 " .. vim.fn.expand("%")
                        }
                    end,
                    desc = "Run Python"
                }
            }

            -- Setup Shift+F5 keybinding for each language
            for ft, compiler in pairs(compilers) do
                vim.api.nvim_create_autocmd("FileType", {
                    pattern = ft,
                    callback = function()
                        vim.keymap.set("n", "<S-F5>", function()
                            -- Run the compiler
                            local task = require("overseer").new_task({
                                cmd = compiler.cmd(),
                                components = {
                                    { "on_output_quickfix", open = true },
                                    "default",
                                }
                            })
                            task:start()

                            -- Always show the output window
                            vim.defer_fn(function()
                                require("overseer").run_action(task, "open float")
                            end, 100)
                        end, { buffer = true, desc = compiler.desc })
                    end
                })
            end

            -- Basic keymaps for compiler management
            vim.keymap.set("n", "<leader>co", "<Cmd>CompilerOpen<CR>", { noremap = true, silent = true, desc = "Open Compiler" })
            vim.keymap.set("n", "<leader>cr", "<Cmd>CompilerRedo<CR>", { noremap = true, silent = true, desc = "Redo Last Compilation" })
            vim.keymap.set("n", "<leader>ct", "<Cmd>CompilerToggleResults<CR>", { noremap = true, silent = true, desc = "Toggle Compiler Results" })
        end
    }
}
