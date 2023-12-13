-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status")
          .heirline.buffer_picker(
            function(bufnr)
              require("astronvim.utils.buffer").close(bufnr)
            end
          )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
    --
    ['<leader>c'] = { ':w | below split | terminal C "%"<cr>', desc = 'Save and compile' },
    ['q'] = { '<esc>:q<cr>', silent = true },
    ['Q'] = { '<esc>:wq<cr>', silent = true },
    ['<C-s>'] = { ':w<cr>', desc = 'Save in normal mode' },

    ['H'] = { '0', silent = true },
    ['L'] = { '$', silent = true },
    -- TODO: theses throw an error: unknown variable: gj
    -- ['j'] = { 'gj', silent = true },
    -- ['k'] = { 'gk', silent = true },
    ['n'] = { 'nzzzv', silent = true, desc = 'recenter screen after selection' },
    ['N'] = { 'Nzzzv', silent = true, desc = 'recenter screen after selection' },
    ['Y'] = { 'y$', desc = 'make Y behave like the other capitals'},
    ['<space>'] = { ':' },
    ['<C-h>'] = { '<C-w>h', desc = 'shortcut split navigation' },
    ['<C-j>'] = { '<C-w>j', desc = 'shortcut split navigation' },
    ['<C-k>'] = { '<C-w>k', desc = 'shortcut split navigation' },
    ['<C-l>'] = { '<C-w>l', desc = 'shortcut split navigation' },
    ['<C-d>'] = { '<C-d>zz' },
    ['<C-u>'] = { '<C-u>zz' },
    ['J'] = { 'mzJ`z' },

    ---------- TODO add old bindings
    -- nmap('0', ":call ToggleMovement('^', '0')<cr>", { silent = true })
    -- -- TODO: use ToggleMovement for new bindings
    -- -- map.n('H', ":call ToggleMovement('H', 'L')<cr>", { silent = true })
    -- -- map.n('L', ":call ToggleMovement('L', 'H')<cr>", { silent = true })
    -- -- nmap('H', [[:call ToggleMovement('^', '0')<cr>]], { silent = true })
    -- map({'n', 'v'}, 'H', [[:call ToggleMovement('^', '0')<cr>]], { silent = true })
    -- nmap('<F9>', 'za', { silent = true })
    -- nmap('S', ':%s//g<left><left>')
    -- nmap('<leader>ff', [[:lua require'telescope.builtin'.find_files()<cr>]], { silent = true })
    -- nmap('<leader>fb', [[:lua require'telescope.builtin'.buffers()<cr>]], { silent = true })
    -- nmap('<leader>fg', [[:lua require'telescope.builtin'.live_grep()<cr>]], { silent = true })
    -- nmap('<leader>fh', [[:lua require'telescope.builtin'.help_tags()<cr>]], { silent = true })
    -- nmap('<leader>r', ':vsp<cr>', { silent = true })
    -- -- nmap('<leader>c', ':w | !C <c-r>%<cr>')
    -- nmap('<leader>c', ':w | !C "%"<cr>')
    -- nmap('<leader>j', ':Buffers<cr>', { silent = true })
    -- nmap('<leader>t', ':FZF<cr>', { silent = true })
    -- nmap('<leader>g', ':Ranger<cr>', { silent = true })
    -- nmap('<leader>m', ':MarkdownPreview<cr>', { silent = true })
    -- nmap('<leader>ve', ':e $MYVIMRC<cr>', { silent = true })
    -- nmap('<leader>vs', ':so $MYVIMRC<cr>:call UltiSnips#RefreshSnippets()<cr>', { silent = true })
    -- nmap('<leader>h', ':lua toggleHiddenAll()<cr>', { silent = true })
    -- nmap('<leader>i', ':VimwikiIndex<cr>', { silent = true })
    -- nmap('<leader>I', ':VimwikiMakeDiaryNote<cr>', { silent = true })
    -- nmap([['c]], [["_c]])
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
  v = {
    ['<'] = { '<gv', desc = 'Reselect visual selection after indenting' },
    ['>'] = { '>gv', desc = 'Reselect visual selection after indenting' },
    ['<space>'] = { ':' },
    -- move around selections
    -- vmap('J', [[:m '>+1<CR>gv=gv]])
    -- vmap('K', [[:m '<-2<CR>gv=gv]])
  },
  i = {
    ['<C-s>'] = { '<c-o>:w<cr>', desc = 'save in insert mode' },
    ['<C-v>'] = { '<c-o>p', desc = 'paste in insert mode' },
  },
  c = {
    ['w!!'] = { "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!", desc = 'force save' },
  }
}
