return {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        -- local breadcrumb = function()
        --     local breadcrumb_status_ok, breadcrumb = pcall(require, "breadcrumb")
        --     if not breadcrumb_status_ok then
        --         return
        --     end
        --     return breadcrumb.get_breadcrumb()
        -- end

        local lualine = require("lualine")

        lualine.setup({
            options = {
                icons_enabled = true,
                -- theme = "catppuccin",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },
                lualine_c = {"location", "filename" },
                -- lualine_c = { breadcrumb },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {"location", "filename" },
                -- lualine_c = { breadcrumb },
                -- lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        })
    end,
}
