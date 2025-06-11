return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        git = { enabled = true },
        gitbrowse = { enabled = true },
        lazygit = { enabled = true },
        image = {
            enabled = true,
            animate = {
                enabled = false
            },
        },
        indent = {
            enabled = true,
            animate = {
                -- enabled = vim.fn.has("nvim-0.10") == 1,
                enabled = false,
                style = "out",
                easing = "linear",
                duration = {
                    step = 0,  -- ms per step
                    total = 0, -- maximum duration
                },
            },
        },
        notifier = { enabled = true },
        scroll = {
            enabled = true,
            animate = {
                duration = { step = 15, total = 100 },
                easing = "linear",
            },
        },
        toggle = { enabled = true },
        picker = { enabled = true },
        dashboard = {
            enabled = true,
            preset = {
                header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
            }


        },
        -- quickfile = { enabled = true },
        -- scope = { enabled = true },
        -- statuscolumn = { enabled = true },
    },
    keys = {
        -- find
        -- { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep Files" },
        -- { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },

        -- notifications
        { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification History", },

        -- Buffers
        { "∑", function() Snacks.bufdelete() end, desc = "Delete Buffer", },
        { "<leader>bk", function() Snacks.bufdelete.all() end, desc = "Delete Buffer", },
        -- -- git

        { "<leader>lg", function() Snacks.lazygit.open() end, desc = "Open Lazygit", },
        { "<leader>bt", function() Snacks.git.blame_line() end, desc = "Blame Line toggle", },
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches", },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log", },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status", },
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
