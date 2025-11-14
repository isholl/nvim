return {
  {
    'lukas-reineke/indent-blankline.nvim',
    version = '3.9.0',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          'help',
          'lazy',
        },
      },
    },
  },
}
