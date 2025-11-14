return {
  {
    'stevearc/conform.nvim',
    cmd = 'ConformInfo',
    event = 'BufWritePre',
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        markdown = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        vue = { 'prettier' },
        yaml = { 'prettier' },
        blade = { 'blade-formatter' },
        php = { 'php_cs_fixer' },
      },
      format_on_save = function(bufnr)
        local disable_filetypes = {}
        if vim.g.autoformat ~= true or disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 3000,
            lsp_format = 'fallback',
          }
        end
      end,
    },
    keys = {
      { '<leader>cf', function() require 'conform'.format() end },
    },
  },
}
