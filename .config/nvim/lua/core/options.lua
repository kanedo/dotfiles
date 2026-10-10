local opt = vim.opt

-- Session Management
opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Line Numbers
opt.relativenumber = true
opt.number = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
vim.bo.softtabstop = 2

-- Line Wrapping
opt.wrap = false

-- Search Settings
opt.ignorecase = true
opt.smartcase = true

-- Cursor Line
opt.cursorline = true

-- Cursor in insert mode
vim.opt.guicursor = "n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20,i:block-blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
vim.diagnostic.config {
  float = { border = "rounded" }, -- add border to diagnostic popups
}

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
-- opt.clipboard:append("unnamedplus")

-- Split Windows
opt.splitright = true
opt.splitbelow = true

-- Consider - as part of keyword
opt.iskeyword:append("-")

-- Disable the mouse while in nvim
-- opt.mouse = ""

-- Folding
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Spelling
opt.spelllang = { "en", "de" }
opt.spell = false
opt.conceallevel = 0

-- Notes vault.
-- Resolve cross-platform so the config doesn't error on machines that lack
-- the macOS iCloud vault. Precedence: $OBSIDIAN_VAULT, the macOS iCloud Notes
-- folder, then a plain ~/Notes directory. When none exists the value stays nil
-- and obsidian.nvim is skipped entirely (see lua/plugins/obsidian-nvim.lua).
local function resolve_notes_vault()
  local candidates = {
    vim.env.OBSIDIAN_VAULT,
    vim.fn.expand("~/Library/Mobile Documents/com~apple~CloudDocs/Notes"),
    vim.fn.expand("~/Notes"),
  }
  for _, path in ipairs(candidates) do
    if path and path ~= "" and vim.fn.isdirectory(path) == 1 then
      return path
    end
  end
  return nil
end

vim.g.obsidian_default_vault = resolve_notes_vault()

-- Tell the user once when notes are unavailable instead of failing at startup.
if not vim.g.obsidian_default_vault
  and vim.fn.isdirectory(vim.fn.getcwd() .. "/notes") ~= 1 then
  vim.schedule(function()
    vim.notify(
      "obsidian.nvim disabled: no notes vault found. Set $OBSIDIAN_VAULT or create ~/Notes.",
      vim.log.levels.INFO
    )
  end)
end
