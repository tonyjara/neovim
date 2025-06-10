return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- dashboard = require("custom.dashboard"),
        -- explorer = { enabled = true },
        -- picker = { enabled = true },
        bigfile = { enabled = true },
        git = { enabled = true },
        gitbrowse = { enabled = true },
        lazygit = { enabled = true },
        image = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = {
            enabled = true,
            animate = {
                duration = { step = 15, total = 100 },
                easing = "linear",
            },
        },
        statuscolumn = { enabled = true },
        toggle = { enabled = true },
        words = { enabled = true },
    },
    keys = {

        { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification History", },
        -- Buffers
        { "∑", function() Snacks.bufdelete() end, desc = "Delete Buffer", },
        { "<leader>bk", function() Snacks.bufdelete.all() end, desc = "Delete Buffer", },
        -- -- git

        { "<leader>bt", function() Snacks.git.blame_line() end, desc = "Blame Line toggle", },
        { "<leader>lg", function() Snacks.lazygit.open() end, desc = "Open Lazygit", },
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches", },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log", },
        --    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status", },
        --    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
        --    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
        --    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.line_number():map("<leader>ul")
                Snacks.toggle
                    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                    :map("<leader>uc")
                Snacks.toggle.treesitter():map("<leader>uT")
                Snacks.toggle
                    .option("background", { off = "light", on = "dark", name = "Dark Background" })
                    :map("<leader>ub")
                Snacks.toggle.inlay_hints():map("<leader>uh")
                Snacks.toggle.indent():map("<leader>ug")
                Snacks.toggle.dim():map("<leader>uD")
            end,
        })
    end,
}
