return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",           -- source for text in buffer
        "hrsh7th/cmp-path",             -- source for file system paths
        "L3MON4D3/LuaSnip",             -- snippet engine
        "saadparwaiz1/cmp_luasnip",     -- for autocompletion
        "rafamadriz/friendly-snippets", -- useful snippets
        "onsails/lspkind.nvim",         -- vs-code like pictograms
        -- "zbirenbaum/copilot-cmp",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            completion = {
                completeopt = "menu,menuone,preview,noselect",
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            performance = {
                max_view_entries = 100,
            },
            sources = cmp.config.sources({
                -- ORDER MATTERS HERE
                -- Other options are keyword_length and priority, length is to specify when cmp should begin

                -- { name = "copilot", group_index = 2 },
                { name = "luasnip",  max_item_count = 2 },
                { name = "nvim_lua", max_item_count = 5 },
                { name = "nvim_lsp", max_item_count = 80 },
                { name = "buffer",   max_item_count = 5 },
                { name = "path",     max_item_count = 5 },
                --[[ { name = "cmp_luasnip", max_item_count = 2 ]]
            }),
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            confirm_opts = {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
            formatting = {
                format = lspkind.cmp_format({
                    maxwidth = 50,
                    ellipsis_char = "...",
                }),
            },
        })
    end,
}
