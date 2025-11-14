return {
  {
    'nvim-treesitter/nvim-treesitter',
    commit = '94ea4f4',
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
        'blade',
        'css',
        'diff',
        'gitcommit',
        'git_config',
        'git_rebase',
        'gitignore',
        'gitattributes',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'jsonc',
        'luadoc',
        'luap',
        'php',
        'php_only',
        'printf',
        'regex',
        'toml',
        'tsx',
        'typescript',
      },
    },
  },
}
