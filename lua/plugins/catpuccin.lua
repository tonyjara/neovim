return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        local macchiato = require("catppuccin.palettes").get_palette("macchiato")
        require("catppuccin").setup({
            flavour = "macchiato", -- latte, frappe, macchiato, mocha
            background = {
                -- :h background
                light = "latte",
                dark = "macchiato",
            },
            transparent_background = true,
            show_end_of_buffer = false, -- show the '~' characters after the end of buffers
            term_colors = true,
            dim_inactive = {
                enabled = false,
                shade = "dark",
                percentage = 0.95,
            },
            no_italic = false, -- Force no italic
            no_bold = false,   -- Force no bold
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            color_overrides = {},
            -- custom_highlights = function(colors)
            -- 	return {
            -- 		Comment = { fg = colors.flamingo },
            -- 		TabLineSel = { bg = colors.pink },
            -- 		CmpBorder = { fg = colors.surface2 },
            -- 		Pmenu = { bg = colors.none },
            -- 	}
            -- end,
            integrations = {
                alpha = true,
                cmp = true,
                flash = true,
                gitsigns = true,
                indent_blankline = true,
                mason = true,
                noice = true,
                notify = true,
                nvimtree = true,
                rainbow_delimiters = true,
                ts_rainbow = true,
                telescope = {
                    enabled = true,
                },
                treesitter = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                }, -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            },
        })
        vim.cmd.colorscheme("catppuccin")
    end,
}
-- setup must be called before loading
-- uncomment to load on init
