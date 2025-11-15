return {
  {
    'echasnovski/mini.ai',
    event = 'BufReadPost',
    opts = {
      n_lines = 500,
    },
  },

  {
    'echasnovski/mini.files',
    dependencies = { 'mini.icons' },
    lazy = vim.fn.argc(-1) == 0,
    opts = {
      windows = {
        width_focus = 30,
      },
    },
    keys = {
      { '<leader>e', function() require 'mini.files'.open() end },
    },
  },

  { 'echasnovski/mini.icons', opts = {} },

  {
    'echasnovski/mini.indentscope',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    opts = {
      draw = {
        animation = function()
          return 0
        end,
      },
      symbol = '│',
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'checkhealth',
          'fzf',
          'help',
          'lazy',
          'mason',
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  {
    'echasnovski/mini.pairs',
    event = { 'InsertEnter', 'CmdLineEnter' },
    opts = {
      modes = {
        command = true,
      },
    },
  },
}
