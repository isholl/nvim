local autocmd = vim.api.nvim_create_autocmd

autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd('FileType', {
  pattern = {
    'checkhealth',
    'help',
    'qf',
  },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd 'close'
        pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
      end, { buffer = args.buf, silent = true })
    end)
  end,
})
