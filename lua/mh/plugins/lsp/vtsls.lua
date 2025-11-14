return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        vtsls = {
          settings = {
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              preferences = {
                quoteStyle = 'single',
                useAliasesForRenames = false,
              },
              updateImportsOnFileMove = { enabled = 'always' },
            },
            javascript = {
              preferences = {
                quoteStyle = 'single',
                useAliasesForRenames = false,
              },
            },
          },
        },
      },
    },
  },
}
