return {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = function()
        local keymap = vim.keymap
        local opts = { noremap = true, silent = true }

        -- flutter run -d web-server --web-port=3000

        -- '<cmd>FlutterRun -d chrome --web-browser-flag=--disable-web-security --web-port=3002<CR>',

        keymap.set({ "n", "v" }, '<leader>rf',
            '<cmd>FlutterRun -d web-server --web-port=3004<CR>',
            opts)
        opts.desc = "Flutter run chrome port 3004"
        keymap.set({ "n", "v" }, "<leader>qf", "<cmd>FlutterQuit<CR>", opts)
        opts.desc = "Flutter quit"
        local on_attach = function(_, bufnr)
            -- if client.server_capabilities.documentSymbolProvider then
            --     breadcrumb.attach(client, bufnr)
            -- end

            local line = vim.fn.line(".")
            local col = vim.fn.col(".")

            --Window that pops up when pressing leader k
            vim.diagnostic.config({
                -- underline = true,
                -- signs = true,
                update_in_insert = true,
                -- virtual_text = {
                --     spacing = 4,
                --     prefix = "",
                -- },
                float = {
                    source = true,
                    relative = "cursor",
                    row = line + 1,
                    col = col + 1,
                    width = 80,
                    height = 15,
                    style = "minimal",
                    border = "single",
                },
            })

            opts.buffer = bufnr

            opts.desc = "Format code"
            keymap.set({ "n", "v" }, "<leader>fc", vim.lsp.buf.format, opts)

            opts.desc = "Open diagnostics float"
            keymap.set("n", "<leader>k", vim.diagnostic.open_float, opts)

            opts.desc = "Go to previous diagnostic"
            keymap.set("n", "<leader>lp", vim.diagnostic.goto_prev, opts)

            opts.desc = "Go to next diagnostic"
            keymap.set("n", "<leader>ln", vim.diagnostic.goto_next, opts)

            opts.desc = "Open list of diagnostics"
            keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

            -- set keybinds
            opts.desc = "Show LSP references"
            keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

            opts.desc = "Go to declaration"
            keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

            opts.desc = "Show LSP definitions"
            keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

            opts.desc = "Show LSP implementations"
            keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

            opts.desc = "Show LSP type definitions"
            keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

            opts.desc = "See available code actions"
            keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

            opts.desc = "Smart rename"
            keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

            opts.desc = "Show buffer diagnostics"
            keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

            opts.desc = "Show documentation for what is under cursor"
            keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

            opts.desc = "Restart LSP"
            keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
        end

        local dart_capabilities = vim.lsp.protocol.make_client_capabilities()
        dart_capabilities.textDocument.codeAction = {
            dynamicRegistration = false,
            codeActionLiteralSupport = {
                codeActionKind = {
                    valueSet = {
                        -- "",
                        -- "quickfix",
                        "refactor",
                        "refactor.extract",
                        "refactor.inline",
                        "refactor.rewrite",
                        "source",
                        -- "source.organizeImports",
                    },
                },
            },
        }

        require("flutter-tools").setup({
            ui = {
                -- this will change the window layout to place logs at the bottom
                notification_window = {
                    position = "bottom",
                    border = "single",
                    width = 80,
                    height = 20,
                },
            },
            lsp = {
                on_attach = on_attach,
                capabilities = dart_capabilities, -- e.g. lsp_status capabilities
            },
            widget_guides = {
                enabled = true,
            },
        })
    end,
}
