return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      show_end_of_buffer = true,
      no_italic = true, -- disable italics since they look unclear or cut off in Termux
      custom_highlights = {
        FzfLuaTitle = { link = 'Constant' },
        FzfLuaPreviewTitle = { link = 'Title' },
        FzfLuaFzfBorder = { link = 'Constant' },
        FzfLuaFzfHeader = { link = 'Title' },
        FzfLuaFzfPrompt = { link = 'Special' },
        IblIndent = { link = 'NonText' },
        MiniIndentscopeSymbol = { link = 'Special' },
      },
      auto_integrations = true,
    },
    config = function(_, opts)
      require 'catppuccin'.setup(opts)
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
