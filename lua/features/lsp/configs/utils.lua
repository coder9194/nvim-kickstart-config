local M = {}

M.use_codelens = function(client, bufnr)
  local is_codelens_supported = client.server_capabilities.codeLensProvider
  if is_codelens_supported then
    -- Initially load codelens
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.lsp.codelens.enable(true, { bufnr = bufnr })
    end

    -- Refresh codelens on the fly
    vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
      desc = 'Refresh CodeLens on the fly',
      callback = function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.lsp.codelens.enable(true, { bufnr = bufnr })
        end
      end,
    })
  end
end

return M
