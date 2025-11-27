local M = {}

M.use_codelens = function(client, bufnr)
  local is_codelens_supported = client.server_capabilities.codeLensProvider
  if is_codelens_supported then
    -- Initially load codelens
    vim.lsp.codelens.refresh { bufnr = bufnr }

    -- Refresh codelens on the fly
    vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
      desc = 'Refresh CodeLens on the fly',
      callback = function()
        vim.lsp.codelens.refresh { bufnr = bufnr }
      end,
    })
  end
end

return M
