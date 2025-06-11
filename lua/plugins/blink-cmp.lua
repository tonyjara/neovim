return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets',
        { 'L3MON4D3/LuaSnip',       version = 'v2.*' },
        { "echasnovski/mini.icons", opts = {} },
    },
    version = '1.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        enabled = function()
            return not vim.tbl_contains({
                "DressingInput",
            }, vim.bo.filetype) and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
        end,
        keymap = {
            preset = "enter",
            ["<S-Tab>"] = {},
            ["<Tab>"] = {},
            ["<C-l>"] = { "snippet_forward", "fallback" },
            ["<C-j>"] = { "snippet_backward", "fallback" },
        },

        appearance = {
            nerd_font_variant = 'mono'
        },

        completion = {
            -- menu = {
            --     auto_show = function(ctx)
            --         local row, column = unpack(vim.api.nvim_win_get_cursor(0))
            --         local success, node = pcall(vim.treesitter.get_node, {
            --             pos = { row - 1, math.max(0, column - 1) },
            --             ignore_injections = false
            --         })
            --         local reject = { "comment", "line_comment", "block_comment", "string_start", "string_content",
            --             "string_end" }
            --         if success and node and vim.tbl_contains(reject, node:type()) then
            --             return false;
            --         end
            --         -- whatever other logic you want beyond this
            --         return true
            --     end,
            -- },

            documentation = { auto_show = true }
        },

        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
}
