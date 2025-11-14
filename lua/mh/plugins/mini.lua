return {
  {
    'echasnovski/mini.ai',
    version = '0.16.0',
    event = 'BufReadPost',
    opts = {
      n_lines = 500,
    },
  },

  {
    'echasnovski/mini.files',
    version = '0.16.0',
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

  { 'echasnovski/mini.icons', version = '0.16.0', opts = {} },

  {
    'echasnovski/mini.indentscope',
    version = '0.16.0',
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
    version = '0.16.0',
    event = { 'InsertEnter', 'CmdLineEnter' },
    opts = {
      modes = {
        command = true,
      },
    },
  },
}
