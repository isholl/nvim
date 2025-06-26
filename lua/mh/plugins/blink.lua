return {
  {
    'saghen/blink.cmp',
    build = 'cargo build --release',
    event = 'InsertEnter',
    dependencies = { 'rafamadriz/friendly-snippets' },
    opts = {
      keymap = {
        preset = 'enter',
        ['<c-y>'] = { 'select_and_accept' },
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        menu = {
          draw = {
            treesitter = { 'lsp' },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      sources = {
        default = { 'lsp', 'buffer', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },
      cmdline = { enabled = false },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },
}
