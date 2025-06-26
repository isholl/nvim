require 'mh.options'
require 'mh.autocmds'
require 'mh.keymaps'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require 'lazy'.setup {
  defaults = { lazy = true },
  spec = 'mh.plugins',
  change_detection = { notify = false },
  install = { colorscheme = { 'catppuccin' } },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'tarPlugin',
        'tohHtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}
