return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { buffer = buffer })
      end

      map('n', ']h', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gs.nav_hunk 'next'
        end
      end)
      map('n', '[h', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gs.nav_hunk 'prev'
        end
      end)
      map('n', ']H', function() gs.nav_hunk 'last' end)
      map('n', '[H', function() gs.nav_hunk 'first' end)
      map({ 'n', 'v' }, '<leader>ghs', '<cmd>Gitsigns stage_hunk<cr>')
      map({ 'n', 'v' }, '<leader>ghr', '<cmd>Gitsigns reset_hunk<cr>')
      map('n', '<leader>ghS', gs.stage_buffer)
      map('n', '<leader>ghu', gs.undo_stage_hunk)
      map('n', '<leader>ghR', gs.reset_buffer)
      map('n', '<leader>ghp', gs.preview_hunk_inline)
      map('n', '<leader>ghb', function() gs.blame_line { full = true } end)
      map('n', '<leader>ghB', function() gs.blame() end)
      map('n', '<leader>ghd', gs.diffthis)
      map('n', '<leader>ghD', function() gs.diffthis '~' end)
      map({ 'o', 'x' }, 'ih', '<cmd><c-u>Gitsigns select_hunk<cr>')
    end,
  },
}
