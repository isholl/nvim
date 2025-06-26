local map = vim.keymap.set

map('n', '<leader>uf', function ()
  vim.g.autoformat = vim.g.autoformat or false
  vim.g.autoformat = not vim.g.autoformat
  local message = vim.g.autoformat and 'Auto format enabled' or 'Auto format disabled'
  print(message)
end)

map({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd 'noh'
  if vim.snippet then
    vim.snippet.stop()
  end
  return '<esc>'
end, { expr = true })

map('n', '<leader>l', '<cmd>Lazy<cr>')

map('n', '<c-a>', 'gg<S-V>G')

map('n', '<leader>bd', '<cmd>bd<cr>')
map('n', '<s-h>', '<cmd>bp<cr>')
map('n', '<s-l>', '<cmd>bn<cr>')
