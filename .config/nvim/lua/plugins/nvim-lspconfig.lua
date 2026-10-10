-- LSP Support
return {
  -- LSP Configuration
  -- https://github.com/neovim/nvim-lspconfig
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    -- LSP Management
    -- https://github.com/mason-org/mason.nvim
    { 'mason-org/mason.nvim' },
    -- https://github.com/mason-org/mason-lspconfig.nvim
    { 'mason-org/mason-lspconfig.nvim' },

    -- Useful status updates for LSP
    -- https://github.com/j-hui/fidget.nvim
    { 'j-hui/fidget.nvim', opts = {} },

    -- Neovim Lua API completions
    -- https://github.com/folke/lazydev.nvim
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {},
    },

    -- Completion engine — declared as a dependency so it's loaded
    -- BEFORE this file's config() runs, guaranteeing get_lsp_capabilities()
    -- is callable when we build `capabilities` below.
    { 'saghen/blink.cmp' },
  },
  config = function ()
    require('mason').setup()

    -- Build capabilities once, merging Neovim's defaults with blink.cmp's
    -- enhanced set (completionItem/resolve, additionalTextEdits for
    -- auto-imports, snippets, etc).
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local on_attach = function(client, bufnr)
      -- Your custom on_attach function
    end

    -- Only request servers whose install prerequisites exist on this machine.
    -- Mason's installers need npm (npm packages), unzip (GitHub .zip assets)
    -- and a python3 able to build venvs (PyPI packages). Requesting servers we
    -- cannot install makes mason-lspconfig spam startup with install errors.
    local function has_exe(exe)
      return vim.fn.executable(exe) == 1
    end

    local function python_venv_ok()
      if not has_exe("python3") then
        return false
      end
      -- Mason's PyPI installer creates a venv; ensurepip may be missing even
      -- when python3 itself is present.
      vim.fn.system({ "python3", "-c", "import ensurepip, venv" })
      return vim.v.shell_error == 0
    end

    local has_tar = has_exe("tar")
    local has_unzip = has_exe("unzip")
    local has_npm = has_exe("npm")
    local has_pyvenv = python_venv_ok()

    local candidates = {
      { "lua_ls", has_tar },
      { "marksman", true }, -- ships as a standalone binary, no archive tooling
      { "ruff", has_tar },
      { "texlab", has_tar },
      { "lemminx", has_unzip },
      { "yamlls", has_npm },
      { "basedpyright", has_pyvenv },
      { "esbonio", has_pyvenv },
    }

    local ensure_installed, skipped = {}, {}
    for _, server in ipairs(candidates) do
      if server[2] then
        table.insert(ensure_installed, server[1])
      else
        table.insert(skipped, server[1])
      end
    end

    if #skipped > 0 then
      vim.schedule(function()
        vim.notify(
          "mason: skipping uninstallable LSP servers (missing tools): " .. table.concat(skipped, ", "),
          vim.log.levels.INFO
        )
      end)
    end

    require('mason-lspconfig').setup({
      ensure_installed = ensure_installed,
      automatic_enable = true,
    })

    -- Python: auto-detect uv .venv
    local function get_python_path()
      local cwd = vim.fn.getcwd()
      local venv = cwd .. "/.venv/bin/python"
      if vim.fn.executable(venv) == 1 then
        return venv
      end
      return "python3"
    end

    vim.lsp.config('basedpyright', {
      capabilities = capabilities,
      settings = {
        python = {
          pythonPath = get_python_path(),
        },
        basedpyright = {
          analysis = {
            autoImportCompletions = true,
            indexing = true,
            -- Index the whole workspace so auto-import suggests symbols
            -- from files you haven't opened yet. Slower cold start, but
            -- essential for "type a name, get the import for free".
            diagnosticMode = "workspace",
            -- Uncomment if the default "all" strictness is too noisy
            -- and you'd rather not silence individual reportUnknown* rules:
            -- typeCheckingMode = "standard",
            diagnosticSeverityOverrides = {
              reportUnusedImport = "information",
              reportUnusedVariable = "information",
              reportUnknownVariableType = false,
              reportMissingTypeStubs = false,
            },
          },
        },
      },
    })

    vim.lsp.config('ruff', {
      capabilities = capabilities,
      init_options = {
        settings = {
          interpreter = { get_python_path() },
          organizeImports = true,
          fixAll = true,
        },
      },
      on_attach = function(client, bufnr)
        -- Disable ruff hover in favor of basedpyright
        client.server_capabilities.hoverProvider = false
      end,
    })

    -- Format and fix imports on save for Python
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.py",
      callback = function()
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply = true,
        })
        vim.lsp.buf.format({ async = false })
      end,
    })

    -- YAML: auto-detect local schemas and enable SchemaStore
    local function find_local_schemas()
      local cwd = vim.fn.getcwd()
      local schemas = {}
      -- Look for *.schema.json and schema.json files in project root
      local schema_files = vim.fn.glob(cwd .. "/*.schema.json", false, true)
      vim.list_extend(schema_files, vim.fn.glob(cwd .. "/schemas/*.json", false, true))
      vim.list_extend(schema_files, vim.fn.glob(cwd .. "/.schemas/*.json", false, true))
      for _, schema_path in ipairs(schema_files) do
        -- Map schema to all YAML files in the project
        schemas[schema_path] = "*.{yaml,yml}"
      end
      return schemas
    end

    vim.lsp.config('yamlls', {
      capabilities = capabilities,
      settings = {
        yaml = {
          schemaStore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json",
          },
          schemas = find_local_schemas(),
          validate = true,
          completion = true,
          hover = true,
        },
      },
    })

    -- Lua LSP settings
    vim.lsp.config('lua_ls', {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
        },
      },
    })
    vim.lsp.config('ltex', {
      capabilities = capabilities,
      settings = {
        ltex = {
          language = "en-US"
        }
      },
      on_attach = function ()
        vim.keymap.set("n", "<leader>mse", function ()
          vim.opt.spelllang = "en"
          local client = vim.lsp.get_clients({ name = "ltex", bufnr = 0 })[1]
          if client then
            client.config.settings.ltex.language = "en-US"
            client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
        end)
        vim.keymap.set("n", "<leader>msd", function ()
          vim.opt.spelllang = "de"
          local client = vim.lsp.get_clients({ name = "ltex", bufnr = 0 })[1]
          if client then
            client.config.settings.ltex.language = "de-DE"
            client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
        end)
        vim.keymap.set("n", "<leader>msb", function ()
          vim.opt.spelllang = "en,de"
        end)
      end
    })

    -- Globally configure all LSP floating preview popups (hover, signature, etc)
    vim.diagnostic.config({
      float = { border = "rounded" },
    })
    -- Apply capabilities + on_attach to every server as a fallback, so any
    -- LSP not configured explicitly above still gets blink.cmp's capabilities.
    vim.lsp.config('*', {
      capabilities = capabilities,
      on_attach = on_attach,
    })

  end,
}
