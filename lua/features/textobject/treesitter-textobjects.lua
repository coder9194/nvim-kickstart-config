return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter',
      opts = {
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim

            -- For query string, see:
            -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#built-in-textobjects
            keymaps = {
              ['af'] = { query = '@function.outer', desc = 'Select outer part of a function' },
              ['if'] = { query = '@function.inner', desc = 'Select inner part of a function' },
              ['ac'] = { query = '@comment.outer', desc = 'Select outer part of a comment region' },
              ['ic'] = { query = '@comment.inner', desc = 'Select inner part of a comment region' },
            },
          },
        },
      },
    },
  },
}
