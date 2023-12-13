-- set vim options here (vim.<first_key>.<second_key> = value)
return {
  opt = {
    -- set to true or false etc.
    relativenumber = true, -- sets vim.opt.relativenumber
    number = true, -- sets vim.opt.number
    spell = false, -- sets vim.opt.spell
    signcolumn = "auto", -- sets vim.opt.signcolumn to auto
    wrap = false, -- sets vim.opt.wrap
    tabstop = 2,
    softtabstop = 2,
    shiftwidth = 2,
    expandtab = true,

    laststatus = 0,
    showmode = false,
    ruler = false,
    wrap = false, -- set wrap
    showcmd = false,
    -- background = 'light',
    go = 'a',
    mouse = 'a',
    hlsearch = false,
    clipboard = 'unnamedplus',
    encoding = 'utf-8',
    tabstop = 2,
    softtabstop = 2,
    shiftwidth = 2,
    expandtab = true,
    hidden = true,
    cmdheight = 1,
    splitbelow = true,
    splitright = true,
    shortmess = 'IaWFT',
    ignorecase = true,
    smartcase = true,
    incsearch = true,
    showmode = false,
    breakindent = true, -- make word wrapping look nicer
    breakindentopt = 'sbr',
    showbreak = '↪> ',
    scrolloff = 8, -- make scrolling nicer
    sidescroll = 1,
    sidescrolloff = 8,
    cursorline = true,
    foldlevel = 99,
    -- foldlevelstart = 0,
    foldlevelstart = 99,
    colorcolumn = "70",
    -- foldcolumn = 0 TODO: find out what does not work
    -- foldclose = 'all'
    -- foldtext = 'getline(v:foldstart)',
    -- foldmethod = 'expr', -- treesitter code folding
    -- foldexpr = 'nvim_treesitter#foldexpr()',
    listchars = 'eol:¬,tab:↹ ,trail:~,extends:>,precedes:<,space:·', -- ¬␣
    list = false,
    pumheight = 10,
    -- termguicolors = true,
    number = true,
    relativenumber = true,
    numberwidth = 1,
    -- number = 'relativenumber'
  },

  g = {
    mapleader = " ", -- sets vim.g.mapleader
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = true, -- enable completion at start
    autopairs_enabled = true, -- enable autopairs at start
    diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
    ranger_replace_netrw = 1,
    highlightedyank_highlight_duration = 100,
    mkdp_auto_close = 1,
    mkdp_auto_start = 0,
    mkdp_browser = 'firefox',
    mkdp_theme = 'light',
    UltiSnipsExpandTrigger = '<tab>',
    UltiSnipsJumpBackwardTrigger = '<s-tab>',
    UltiSnipsJumpForwardTrigger = '<tab>',
    vimwiki_folding='expr',
    python_recommended_style = 0,
  },
}

-- If you need more control, you can use the function()...end notation
-- return function(local_vim)
--   local_vim.opt.relativenumber = true
--   local_vim.g.mapleader = " "
--   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
--   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
--
--   return local_vim
-- end
