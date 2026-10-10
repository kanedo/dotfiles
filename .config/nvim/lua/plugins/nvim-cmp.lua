-- Auto-completion / Snippets
return {
  -- https://github.com/saghen/blink.cmp
  'saghen/blink.cmp',
  version = '1.*',
  -- Load on InsertEnter for normal completion, CmdlineEnter so the cmdline
  -- popup is available the first time you type `:` or `/`.
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    -- Additional user-friendly snippets
    -- https://github.com/rafamadriz/friendly-snippets
    'rafamadriz/friendly-snippets',
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-space>'] = { 'show', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
    },
    completion = {
      menu = { border = 'rounded' },
      documentation = {
        auto_show = true,
        window = { border = 'rounded' },
      },
    },
    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },
    signature = {
      enabled = true,
      window = { border = 'rounded' },
    },

    -- Cmdline fuzzy completion (`:`, `/`, `?`, `@`).
    -- Uses the same Rust fuzzy matcher as insert-mode completion, so typos
    -- are tolerated and matching is consistent across modes.
    cmdline = {
      enabled = true,
      -- 'cmdline' preset: <Tab>/<S-Tab> select, <CR> accepts, <C-e> cancels.
      -- Your insert-mode keymap above doesn't apply here; cmdline has its own.
      keymap = {
        preset = 'cmdline',
        ['<CR>'] = { 'accept', 'fallback' },
      },
      completion = {
        menu = {
          auto_show = true,   -- show popup as you type, not just on <Tab>
        },
        list = {
          selection = {
            -- Don't auto-select the first item; keeps `:w<CR>` etc. working
            -- exactly as you'd expect without the popup hijacking input.
            preselect = false,
            auto_insert = false,
          },
        },
        ghost_text = { enabled = false },
      },
      -- Skip cmdline completion when running shell via `:!cmd` — otherwise
      -- blink tries to fuzzy-complete shell commands, which is noisy.
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == ':' then
          if vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!") then
            return {}
          end
          return { 'cmdline' }
        end
        if type == '/' or type == '?' then
          return { 'buffer' }
        end
        return {}
      end,
    },
  },
}
