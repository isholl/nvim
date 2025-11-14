return {
  {
    'neovim/nvim-lspconfig',
    commit = '4bc481b',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    dependencies = {
      { 'mason-org/mason.nvim', version = '1.11.0' },
      { 'mason-org/mason-lspconfig.nvim', version = '1.32.0' },
      'saghen/blink.cmp',
    },
    opts = {
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = 'Replace',
              },
              doc = {
                privateName = { '^_' },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = 'Disable',
                semicolon = 'Disable',
                arrayIndex = 'Disable',
              },
            },
          },
        },
        cssls = { mason = false },
        html = {
          mason = false,
          filetypes = { 'blade', 'html', 'templ' },
          settings = {
            html = {
              format = {
                indentInnerHtml = true,
              },
            },
          },
        },
        eslint = { mason = false },
        laravel_ls = { mason = false },
        phpactor = {},
      },
    },
    config = function(_, opts)
      local supports_method = {}

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          local function map(lhs, rhs, mode)
            mode = mode or 'n'
            return vim.keymap.set(mode, lhs, rhs, { buffer = true })
          end

          map('gd', vim.lsp.buf.definition)
          map('gr', vim.lsp.buf.references)
          map('gI', vim.lsp.buf.implementation)
          map('gy', vim.lsp.buf.type_definition)
          map('K', function() vim.lsp.buf.hover() end)
          map('gk', function() vim.lsp.buf.signature_help() end)
          map('<c-k>', function() vim.lsp.buf.signature_help() end, 'i')
          map('<leader>ca', vim.lsp.buf.code_action, { 'n', 'v' })
          map('<leader>cr', vim.lsp.buf.rename)

          if
            not vim.api.nvim_buf_is_valid(buffer)
            and not vim.bo[buffer].buflisted
            and vim.bo[buffer].buftype == 'nofile'
          then
            return
          end

          if not client then
            return
          end

          for method, clients in pairs(supports_method) do
            clients[client] = clients[client] or {}
            if not clients[client][buffer] then
              clients[client][buffer] = true
              vim.api.nvim_exec_autocmds('User', {
                pattern = 'LspSupportsMethod',
                data = { client_id = client.id, buffer = buffer, method = method },
              })
            end
          end
        end,
      })

      local register_capability = vim.lsp.handlers['client/registerCapability']

      vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)

        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client then
          for buffer in pairs(client.attached_buffers) do
            vim.api.nvim_exec_autocmds('User', {
              pattern = 'LspDynamicCapability',
              data = { client_id = client.id, buffer = buffer },
            })
          end
        end

        return ret
      end

      local method = 'textDocument/inlayHint'

      supports_method[method] = supports_method[method] or setmetatable({}, { __mode = 'k' })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'LspSupportsMethod',
        callback = function(args)
          local buffer = args.data.buffer
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client and method == args.data.method then
            if vim.api.nvim_buf_is_valid(buffer) then
              vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
            end
          end
        end,
      })

      vim.diagnostic.config {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 2,
          source = 'if_many',
        },
        severity_sort = true,
      }

      local servers = opts.servers
      local blink = require 'blink.cmp'
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        blink.get_lsp_capabilities(),
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend(
          'force',
          {},
          { capabilities = capabilities },
          servers[server] or {}
        )

        if server_opts.enabled == false then
          return
        end

        require 'lspconfig'[server].setup(server_opts)
      end

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts.enabled ~= false then
          if server_opts.mason == false then
            setup(server)
          else
            table.insert(ensure_installed, server)
          end
        end
      end

      require 'mason-lspconfig'.setup {
        ensure_installed = ensure_installed,
        automatic_installation = false,
        handlers = { setup },
      }
    end,
  },

  {
    'mason-org/mason.nvim',
    build = ':MasonUpdate',
    cmd = 'Mason',
    opts = {},
    keys = {
      { '<leader>cm', '<cmd>Mason<cr>' },
    },
  },

  { import = 'mh.plugins.lsp' },
}
