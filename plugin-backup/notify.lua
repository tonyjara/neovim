return {
        "rcarriga/nvim-notify",
        config = function()
                local notify = require("notify")
                notify.setup({
                        background_colour = "#1a1b26",
                        timeout = 1000,

                        max_height = function()
                                return math.floor(vim.o.lines * 0.75)
                        end,
                        max_width = function()
                                return math.floor(vim.o.columns * 0.75)
                        end,
                        render = "compact",
                })
                require("notify").history()

                local map = vim.api.nvim_set_keymap
                local opts = { noremap = true, silent = true }

                map("n", "<leader>fn", "<cmd>Telescope notify<CR>", opts)

                vim.notify = notify

                vim.keymap.set("n", "<esc>", function()
                        notify.dismiss()
                        vim.cmd.noh()
                end)
                vim.lsp.handlers["window/showMessage"] = function(_, method, params, _)
                        vim.notify(method.message, params.type)
                end
        end,
}

