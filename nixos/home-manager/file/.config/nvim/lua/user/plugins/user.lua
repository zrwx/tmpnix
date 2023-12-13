return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
  },

  {
    'iamcco/markdown-preview.nvim',
    config = function() vim.fn['mkdp#util#install']() end,
    ft = 'markdown'
  }
}
