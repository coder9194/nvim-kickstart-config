-- Keep visual selection after shifting indentation left/right
vim.keymap.set('x', '<', '<gv', { desc = 'Shift indentation left' })
vim.keymap.set('x', '>', '>gv', { desc = 'Shift indentation right' })

return {}
