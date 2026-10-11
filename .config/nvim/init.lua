-- Ensure ~/.local/bin is on PATH (needed on Linux servers for tree-sitter CLI etc.)
local home_local_bin = vim.fn.expand("$HOME/.local/bin")
if vim.fn.isdirectory(home_local_bin) == 1 and not vim.env.PATH:find(home_local_bin, 1, true) then
  vim.env.PATH = home_local_bin .. ":" .. vim.env.PATH
end

-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- This has to be set before initializing lazy
vim.g.mapleader = " "

-- Treat all .tex files as LaTeX (filetype=tex) so ftplugin/tex.lua surrounds load.
-- Without this, files lacking a \documentclass marker are detected as `plaintex`.
vim.g.tex_flavor = "latex"

-- Load options before lazy.setup: plugin specs may evaluate their `cond`
-- during setup (e.g. obsidian.nvim checks vim.g.obsidian_default_vault).
require("core.options")

-- Initialize lazy with dynamic loading of anything in the plugins directory
require("lazy").setup("plugins", {
   change_detection = {
    enabled = true, -- automatically check for config file changes and reload the ui
    notify = false, -- turn off notifications whenever plugin changes are made
  },
})

-- These modules are not loaded by lazy
require("core.keymaps")
require("core.python-create-test")
require("core.lint")
