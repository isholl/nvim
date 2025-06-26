return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    cmd = { 'TSInstall', 'TSUpdate', 'TSUpdateSync' },
    main = 'nvim-treesitter.configs',
    init = function(plugin)
      require 'lazy.core.loader'.add_to_rtp(plugin)
      require 'nvim-treesitter.query_predicates'
    end,
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        'bash',
        'diff',
        'gitcommit',
        'git_config',
        'git_rebase',
        'gitignore',
        'gitattributes',
        'luadoc',
        'luap',
        'printf',
        'regex',
        'toml',
      },
    },
  },
}
