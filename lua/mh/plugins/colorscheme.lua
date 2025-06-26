return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true,
      no_italic = true,
      custom_highlights = {
        FzfLuaTitle = { link = 'Constant' },
        FzfLuaPreviewTitle = { link = 'Title' },
        FzfLuaFzfBorder = { link = 'Constant' },
        FzfLuaFzfHeader = { link = 'Title' },
        FzfLuaFzfPrompt = { link = 'Special' },
        IblIndent = { link = 'NonText' },
        MiniIndentscopeSymbol = { link = 'Special' },
      },
      integrations = {
        mason = true,
      },
    },
    config = function(_, opts)
      require 'catppuccin'.setup(opts)
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
