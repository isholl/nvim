return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile', 'BufWritePre' },
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
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
        stylua = { enabled = false },
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
        tailwindcss = {},
        laravel_ls = {},
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

      local mason_all = vim.tbl_keys(require 'mason-lspconfig.mappings'.get_mason_map().lspconfig_to_package) or {}
      local mason_exclude = {}

      local function configure(server)
        local sopts = opts.servers[server]

        sopts = sopts ==  true and {} or (not sopts) and { enabled = false } or sopts
        if sopts.enabled == false then
          mason_exclude[#mason_exclude+1] = server
          return
        end

        sopts.capabilities = vim.tbl_deep_extend(
          'force',
          sopts.capabilities or {},
          opts.capabilities or {}
        )

        local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)

        vim.lsp.config(server, sopts)
        if not use_mason then
          vim.lsp.enable(server)
        end

        return use_mason
      end

      local ensure_installed = vim.tbl_filter(configure, vim.tbl_keys(opts.servers)) or {}
      require 'mason-lspconfig'.setup {
        ensure_installed = ensure_installed,
        automatic_enable = { exclude = mason_exclude },
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
