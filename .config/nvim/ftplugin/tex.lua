-- Soft-wrap long lines visually (at word boundaries) without inserting newlines.
vim.opt_local.wrap = true        -- visually wrap long lines
vim.opt_local.linebreak = true   -- break at word boundaries, not mid-word
vim.opt_local.breakindent = true -- keep wrapped lines visually indented
vim.opt_local.textwidth = 0      -- never hard-wrap by inserting newlines
-- Drop auto-wrap flags so typing past the edge won't insert a newline.
vim.opt_local.formatoptions:remove({ "t", "a" })

-- LaTeX-specific surrounds (nvim-surround)
-- Visual: S b -> \textbf{...} | Normal: ysiw b -> bold a word | Change: cs b ...
require("nvim-surround").buffer_setup({
  -- `b`/`B` are default aliases (b -> "(", B -> "{") that resolve before any
  -- surround lookup, so they'd shadow the `b` bold surround below. Disable them.
  aliases = {
    b = false,
    B = false,
  },
  surrounds = {
    b = { add = { "\\textbf{", "}" } }, -- bold
    i = { add = { "\\textit{", "}" } }, -- italic
    e = { add = { "\\emph{", "}" } },   -- emphasis
    t = { add = { "\\texttt{", "}" } }, -- monospace
    m = { add = { "$", "$" } },         -- inline math
  },
})
