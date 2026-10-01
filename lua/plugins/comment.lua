-- Commenting uses Neovim's built-in `gc`/`gcc` (0.10+). This plugin only makes
-- 'commentstring' context-aware (e.g. JSX inside tsx files).
return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("ts_context_commentstring").setup({
      enable_autocmd = false,
    })

    local get_option = vim.filetype.get_option
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.filetype.get_option = function(filetype, option)
      return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
        or get_option(filetype, option)
    end
  end,
}
