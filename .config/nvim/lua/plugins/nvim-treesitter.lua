-- Treesitter parser management
-- Neovim 0.12+ has built-in treesitter highlight and indent,
-- so we only use this plugin for parser installation and queries.
return {
  -- https://github.com/nvim-treesitter/nvim-treesitter
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  dependencies = {
    "neovim/nvim-lspconfig",  -- ensure lsps are started automatically
  },
  build = ':TSUpdate',
  config = function()
    local installed = require('nvim-treesitter.config').get_installed()
    local ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python" }
    local to_install = vim.tbl_filter(function(p)
      return not vim.tbl_contains(installed, p)
    end, ensure_installed)
    if #to_install > 0 then
      require('nvim-treesitter').install(to_install)
    end

    -- Auto-install parsers when opening a new filetype
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if not lang then return end
        local available = require('nvim-treesitter.config').get_available()
        if not vim.tbl_contains(available, lang) then return end
        pcall(function()
          require('nvim-treesitter').install({ lang })
        end)
      end,
    })
  end,
}
