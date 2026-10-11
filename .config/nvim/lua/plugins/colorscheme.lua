-- Theme/Colorscheme (uncomment section for whichever theme you prefer or use your own)
-- Kanagawa Theme (Custom Palette)
return {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 1000 ,
  config = function ()
    require("gruvbox").setup({
      contrast = "hard",
      palette_overrides = {
        dark0_hard = "#1f2326",
      },
    })
    vim.o.background = "dark" -- or "light" for light mode
    vim.cmd([[colorscheme gruvbox]])
  end
}
