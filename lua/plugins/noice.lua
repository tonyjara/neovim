return {
    "folke/noice.nvim",
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- No nvim-notify: snacks.notifier owns `vim.notify` (see `notify` below),
        -- and noice's own `notify` view already prefers the snacks backend anyway.
    },
    config = function()
        require("noice").setup({
            -- Let snacks.notifier own `vim.notify` rather than noice.
            -- Noice's wrapper builds a fresh message per call and drops
            -- `opts.id` / `opts.replace`, so plugins that animate a single toast
            -- in place (package-info's version spinner, progress bars, ...) end up
            -- emitting one notification per frame. snacks honors both, so those
            -- update in place instead of stacking up.
            -- Noice still handles cmdline, messages, popupmenu and LSP.
            notify = { enabled = false },
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true,         -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false,       -- add a border to hover docs and signature help
            },
        })

        -- Dismiss both: noice-routed messages and snacks notifications
        vim.keymap.set("n", "<Esc>", function()
            require("noice").cmd("dismiss")
            if _G.Snacks then
                Snacks.notifier.hide()
            end
        end, { desc = "Dismiss notifications" })
    end,
}
