-- Markdown notes workflow with obsidian.nvim
-- https://github.com/obsidian-nvim/obsidian.nvim
return {
  "obsidian-nvim/obsidian.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  -- Only load when there is a usable vault. Without this the plugin raises
  -- "At least one workspace is required!" on machines that lack the vault
  -- (e.g. the macOS iCloud Notes dir).
  cond = function()
    if vim.fn.isdirectory(vim.fn.getcwd() .. "/notes") == 1 then
      return true
    end
    local vault = vim.g.obsidian_default_vault
    return vault ~= nil and vim.fn.isdirectory(vault) == 1
  end,
  opts = function()
    -- Configure via vim.g.obsidian_default_vault, defaults to iCloud Notes.
    local default_vault = vim.g.obsidian_default_vault

    -- Use a project-local notes/ dir if it exists, otherwise fall back.
    local cwd = vim.fn.getcwd()
    local local_vault = cwd .. "/notes"

    local vault_path
    if vim.fn.isdirectory(local_vault) == 1 then
      vault_path = local_vault
    else
      vault_path = default_vault
    end

    return {
      workspaces = {
        { name = "notes", path = vault_path },
      },
      daily_notes = {
        date_format = "YYYY-MM-DD",
      },
      templates = {
        folder = "templates",
        date_format = "YYYY-MM-DD",
        time_format = "HH:mm",
        customizations = {
          experiment = {
            notes_subdir = "experiments",
            note_id_func = function(title)
              return require("obsidian.builtin").title_to_slug(title)
            end,
          },
        },
      },
      note_id_func = require("obsidian.builtin").title_id,
      note = {
        template = (function()
          local project_template = vim.fn.getcwd() .. "/notes/templates/note.md"
          if vim.fn.filereadable(project_template) == 1 then
            return project_template
          end
          return vault_path .. "/templates/note.md"
        end)(),
      },
      picker = { name = "telescope.nvim" },
      link = { style = "wiki" },
      frontmatter = { enabled = true },
      attachments = {
        folder = "../assets",
      },
      legacy_commands = false,
      -- Disable built-in UI in favor of markview.nvim
      ui = { enable = false },
    }
  end,
}
