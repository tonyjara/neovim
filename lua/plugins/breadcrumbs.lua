return {
  --   "loctvl842/breadcrumb.nvim",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   config = function()
  --       require("breadcrumb").setup({
  --           disabled_filetype = {
  --               "",
  --               "help",
  --           },
  --           icons = {
  --               File = " ",
  --               Module = " ",
  --               Namespace = " ",
  --               Package = " ",
  --               Class = " ",
  --               Method = " ",
  --               Property = " ",
  --               Field = " ",
  --               Constructor = " ",
  --               Enum = "練",
  --               Interface = "練",
  --               Function = " ",
  --               Variable = " ",
  --               Constant = " ",
  --               String = " ",
  --               Number = " ",
  --               Boolean = "◩ ",
  --               Array = " ",
  --               Object = " ",
  --               Key = " ",
  --               Null = "ﳠ ",
  --               EnumMember = " ",
  --               Struct = " ",
  --               Event = " ",
  --               Operator = " ",
  --               TypeParameter = " ",
  --           },
  --           separator = ">",
  --           depth_limit = 1,
  --           depth_limit_indicator = "..",
  --           color_icons = true,
  --           highlight_group = {
  --               component = "BreadcrumbText",
  --               separator = "BreadcrumbSeparator",
  --           },
  --       })
		--
		-- vim.keymap.set("n", "<leader>bce", "<cmd>BreadcrumbEnable<CR>", { noremap = true, silent = true, desc = "Breadcrumb Enable" })
		-- vim.keymap.set("n", "<leader>bcd", "<cmd>BreadcrumbDisable<CR>", { noremap = true, silent = true, desc = "Breadcrumb Disable" })
  --   end
}
