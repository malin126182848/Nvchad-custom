local M = {}

M.setup_lsp = function(attach, capabilities)
  local lspconfig = require "lspconfig"

  local servers = { "html", "cmake", "bashls", "emmet_ls", "clangd", "pyright" }

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = function (client, bufnr)
        attach(client, bufnr)

        if lsp == "gopls" then
          client.resolved_capabilities.document_formatting = true
          client.resolved_capabilities.document_range_formatting = true
        end
      end,
      capabilities = capabilities,
      root_dir = vim.loop.cwd,
    }
  end

  -- temporarily disable tsserver suggestions
  require("lspconfig").tsserver.setup {
    init_options = {
      preferences = {
        disableSuggestions = true,
      },
    },

    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>", {})
    end,
  }
end

return M
