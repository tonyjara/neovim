return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        git = { enabled = true },
        gitbrowse = { enabled = true },
        -- lazygit = { enabled = true },
        indent = {
            enabled = true,
            animate = {
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
        -- picker = {
        --     enabled = true,
        --     matcher = { frecency = true },
        --     ---@class snacks.picker.formatters.Config
        --     formatters = {
        --         file = {
        --             filename_first = false,
        --             truncate = 100,
        --         }
        --     },
        --     sources = {
        --
        --         colorschemes = {
        --             prompt = "󱥚 ",
        --             layout = {
        --                 preview = 'main',
        --                 layout = {
        --                     backdrop = false,
        --                     row = 1,
        --                     width = 0.4,
        --                     min_width = 80,
        --                     height = 0.8,
        --                     border = "none",
        --                     box = "vertical",
        --                     {
        --                         win = "input",
        --                         height = 1,
        --                         border = "single",
        --                         title = "{title} {live} {flags}",
        --                         title_pos = "center",
        --                     },
        --                     { win = "list",    border = "single" },
        --                     { win = "preview", title = "{preview}", border = "single" },
        --                 },
        --             },
        --         },
        --     },
        -- },
        dashboard = {
            enabled = true,
            preset = {
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
                    -- { icon = " ", key = "f", desc = "Find File", action = ":Telescope frecency workspace=CWD" },
                    -- { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "b", desc = "Open tree", action = ":NvimTreeToggle" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                    -- { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                },
                header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
            }


        },
    },
    keys = {
        -- find
        -- { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        -- { "<leader>fb", function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
        -- { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        -- { "<leader>ff", function() Snacks.picker.files() end,                                   desc = "Find Files" },
        -- { "<leader>fg", function() Snacks.picker.grep() end,                                    desc = "Grep Files" },
        -- { "<leader>fp", function() Snacks.picker.projects() end,                                desc = "Projects" },
        -- { "<leader>fr", function() Snacks.picker.recent() end,                                  desc = "Recent" },

        -- notifications
        { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification History", },
        -- { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification History", },

        -- { "<leader>lg", function() Snacks.lazygit.open() end,         desc = "Open Lazygit", },
        { "<leader>bt", function() Snacks.git.blame_line() end,       desc = "Blame Line toggle", },
        { "<leader>gb", function() Snacks.picker.git_branches() end,  desc = "Git Branches", },
        { "<leader>gl", function() Snacks.picker.git_log() end,       desc = "Git Log", },
        { "<leader>gs", function() Snacks.picker.git_status() end,    desc = "Git Status", },
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
