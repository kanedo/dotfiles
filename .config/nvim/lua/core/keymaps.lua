-- Set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap
local wk = require("which-key")

local mappings = {
    'W', 'Q', 'WQ', 'WA', 'QA',
    'Wqa', 'WqA', 'WQa', 'WQA'
}

for _, lhs in ipairs(mappings) do
  vim.api.nvim_create_user_command(lhs, lhs:lower(), {})
end

vim.cmd([[cnoreabbrev <expr> E getcmdtype() == ':' and getcmdline() == 'E' and 'e' or 'E']])

keymap.set("n", "<C-c>", ":nohlsearch<CR>", { desc = "clear search highlights"})

-- Split window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically"}) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make split windows equal width" }) -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close split window" }) -- close split window
keymap.set("n", "<leader>sj", "<C-w>-", { desc = "make split window height shorter" }) -- make split window height shorter
keymap.set("n", "<leader>sk", "<C-w>+", { desc = "make split windows height taller"}) -- make split windows height taller
keymap.set("n", "<leader>sl", "<C-w>>5", { desc = "make split winows width bigger" }) -- make split windows width bigger 
keymap.set("n", "<leader>sh", "<C-w><5", { desc = "make split windows width smaller" }) -- make split windows width smaller

-- Vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>", {desc = "toggle maximize tab" }) -- toggle maximize tab
wk.add(
  {
    { "<leader>s", group = "Splits" },
  }
)

-- Buffer management
keymap.set("n", '<Tab>', ":bnext<CR>", { desc = "Switch to next buffer" })
keymap.set("n", '<S-Tab>', ":bprevious<CR>", { desc = "switch to previous buffer" })

-- Diff keymaps
keymap.set("n", "<leader>co", ":DiffviewOpen<CR>", { desc = "open diffview" })
keymap.set("n", "<leader>cm", ":DiffviewOpen main<CR>", { desc = "open diffview comparing to main" })
keymap.set("n", "<leader>cq", ":DiffviewClose<CR>", { desc = "close diffview" })
keymap.set("n", "<leader>cc", ":diffput<CR>", { desc = "put diff from current to other during diff" })
keymap.set("n", "<leader>cj", ":diffget 1<CR>", { desc = "get diff from left (local) during merge" })
keymap.set("n", "<leader>ck", ":diffget 3<CR>", { desc = "get diff from right (remote) during merge" })
keymap.set("n", "<leader>cn", "]c", { desc = "next diff hunk" })
keymap.set("n", "<leader>cp", "[c", { desc = "previous diff hunk" })
wk.add(
  {
    { "<leader>c", group = "Diff" },
    -- Built-in Vim diff keymaps (shown here for discoverability)
    { "]c", desc = "next diff hunk" },
    { "[c", desc = "previous diff hunk" },
    { "do", desc = "diff obtain (get change from other buffer)" },
    { "dp", desc = "diff put (send change to other buffer)" },
  }
)

-- Quickfix keymaps
keymap.set("n", "<leader>qo", ":copen<CR>", { desc = "open quickfix list" }) -- open quickfix list
keymap.set("n", "<leader>qf", ":cfirst<CR>", { desc = "jump to first quickfix list item" }) -- jump to first quickfix list item
keymap.set("n", "<leader>qn", ":cnext<CR>", { desc = "jump to next quickfix list item" }) -- jump to next quickfix list item
keymap.set("n", "<leader>qp", ":cprev<CR>", { desc = "jump to prev quickfix list item" }) -- jump to prev quickfix list item
keymap.set("n", "<leader>ql", ":clast<CR>", { desc = "jump to last quickfix list item" }) -- jump to last quickfix list item
keymap.set("n", "<leader>qc", ":cclose<CR>", { desc = "close quickfix list" }) -- close quickfix list
wk.add(
  {
    { "<leader>q", group = "Quickfix" },
  }
)

-- Nvim-tree
keymap.set("n", "<leader>ee", ":NvimTreeToggle<CR>", { desc = "toggle file explorer" }) -- toggle file explorer
keymap.set("n", "<leader>er", ":NvimTreeFocus<CR>", { desc = "toggle focus to file explorer" }) -- toggle focus to file explorer
keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>", { desc = "find file in file explorer" }) -- find file in file explorer
wk.add(
  {
    { "<leader>e", group = "File Explorer" },
  }
)

-- Telescope
keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = "find files"})
keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = "live grep in current working directory"})
keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, {desc = "find buffers"})
keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, {desc = "search help"})
keymap.set('n', '<leader>fs', require('telescope.builtin').current_buffer_fuzzy_find, { desc = "fuzzy search in current buffer"})
keymap.set('n', '<leader>fo', require('telescope.builtin').lsp_document_symbols, { desc = "find lsp document symbols"})
keymap.set('n', '<leader>fi', require('telescope.builtin').lsp_incoming_calls, { desc = "find incoming calls"})
keymap.set('n', '<leader>fm', function() require('telescope.builtin').treesitter({ symbols = { "method", "function" } }) end, { desc = "find methods/functions"})
keymap.set('n', '<leader>fa', function() require("core.symbol-outline").show() end, { desc = "symbol outline"})
wk.add(
  {
    { "<leader>f", group = "Find" },
  }
)

keymap.set('n', '<leader>p', require('telescope.builtin').commands, { desc = "command line"})

-- LSP
keymap.set('n', '<leader>gg', '<cmd>lua vim.lsp.buf.hover()<CR>', { desc = "lsp hover" })
keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = "go to definition" })
keymap.set('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { desc = "go to type definition" })
keymap.set('n', '<leader>gr', function() require('telescope.builtin').lsp_references() end, { desc = "show references" })
keymap.set('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = "show signature_help" })
keymap.set('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>', { desc = "rename" })
keymap.set('n', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>', { desc = "format" })
keymap.set('n', '<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = "show code actions" })
keymap.set('v', '<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = "show code actions" })
keymap.set('n', '<leader>gl', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = "show diagnostics" })
keymap.set('n', '<leader>gp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = "go to previous diagnostic" })
keymap.set('n', '<leader>gn', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = "go to next diagnostic" })
keymap.set('n', '<leader>ct', ':CreateTestFile<CR>', { desc = "Create a python unit test file" })
-- <C-Space> for completion is handled by blink.cmp
wk.add(
  {
    { "<leader>g", group = "LSP" },
  }
)

-- Debugging
keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", { desc = "toggle breakpoint" })
keymap.set("n", "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", { desc = "create breakpoint with condition" })
keymap.set("n", "<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", { desc = "" })
keymap.set("n", '<leader>br', "<cmd>lua require'dap'.clear_breakpoints()<cr>", { desc = "clear breakpoints" })
keymap.set("n", '<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>', { desc = "list breakpoints" })
keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", { desc = "continue" })
keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>", { desc = "step over" })
keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>", { desc = "step into" })
keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>", { desc = "step out" })
keymap.set("n", '<leader>dd', function() require('dap').disconnect(); require('dapui').close(); end, { desc = "close debugging session" })
keymap.set("n", '<leader>dt', function() require('dap').terminate(); require('dapui').close(); end, { desc = "terminate debugging session" })
keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", { desc = "toggle REPL" })
keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", { desc = "run last" })
keymap.set("n", '<leader>di', function() require "dap.ui.widgets".hover() end, { desc = "" })
keymap.set("n", '<leader>d?', function() local widgets = require "dap.ui.widgets"; widgets.centered_float(widgets.scopes) end, { desc = "" })
keymap.set("n", '<leader>df', '<cmd>Telescope dap frames<cr>', { desc = "" })
keymap.set("n", '<leader>dh', '<cmd>Telescope dap commands<cr>', { desc = "" })
keymap.set("n", '<leader>de', function() require('telescope.builtin').diagnostics({default_text=":E:"}) end, { desc = "" })
wk.add(
  {
    { "<leader>d", group = "Debug" },
    { "<leader>b", group = "Breakpoints" },
  }
)

-- Spelling
-- keymap for switching languages in a buffer is defined in the lsp section

-- Yanking
keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = "Yank to system clipboard"})


wk.add({
  -- Neotest related mappings
  {
      "<leader>t",
      group = "Test",
      nowait = true,
      remap = false,
  },
  {
      "<leader>tr",
      "<cmd>lua require('neotest').run.run()<cr>",
      desc = "Run nearest test",
  },
  {
      "<leader>tf",
      "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
      desc = "Run current file",
  },
  {
      "<leader>ta",
      "<cmd>lua require('neotest').run.run({ suite = true })<cr>",
      desc = "Run all tests",
  },
  {
      "<leader>td",
      "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
      desc = "Debug nearest test",
  },
  {
      "<leader>ts",
      "<cmd>lua require('neotest').run.stop()<cr>",
      desc = "Stop test",
  },
  {
      "<leader>tn",
      "<cmd>lua require('neotest').run.attach()<cr>",
      desc = "Attach to nearest test",
  },
  {
      "<leader>to",
      "<cmd>lua require('neotest').output.open()<cr>",
      desc = "Show test output",
  },
  {
      "<leader>tp",
      "<cmd>lua require('neotest').output_panel.toggle()<cr>",
      desc = "Toggle output panel",
  },
  {
      "<leader>tv",
      "<cmd>lua require('neotest').summary.toggle()<cr>",
      desc = "Toggle summary",
  },
})

-- Notes (obsidian.nvim)
-- obsidian.nvim is only loaded when a vault exists (see
-- lua/plugins/obsidian-nvim.lua). These wrappers avoid "Not an editor command"
-- errors when the plugin is disabled by giving a friendly message instead.
local function obsidian_available()
  return vim.fn.exists(":Obsidian") == 2
end

local function obsidian_cmd(cmd)
  return function()
    if not obsidian_available() then
      vim.notify("obsidian.nvim disabled: no notes vault found", vim.log.levels.WARN)
      return
    end
    vim.cmd("Obsidian " .. cmd)
  end
end

keymap.set("n", "<leader>nn", obsidian_cmd("new"), { desc = "New note" })
keymap.set("n", "<leader>nt", obsidian_cmd("today"), { desc = "Today's daily note" })
keymap.set("n", "<leader>ns", obsidian_cmd("quick_switch"), { desc = "Quick switch" })
keymap.set("n", "<leader>nf", obsidian_cmd("search"), { desc = "Search notes" })
keymap.set("n", "<leader>nb", obsidian_cmd("backlinks"), { desc = "Backlinks" })
keymap.set("n", "<leader>np", obsidian_cmd("paste_img"), { desc = "Paste image" })
keymap.set("n", "<leader>ne", function()
  if not obsidian_available() then
    vim.notify("obsidian.nvim disabled: no notes vault found", vim.log.levels.WARN)
    return
  end
  vim.ui.input({ prompt = "Experiment title: " }, function(title)
    if not title or title == "" then return end
    local dated_title = os.date("%Y-%m-%d") .. " " .. title
    vim.cmd("Obsidian new_from_template " .. dated_title .. " experiment")
  end)
end, { desc = "New experiment note" })

keymap.set("n", "<leader>nc", function()
  local sha = vim.fn.system("git rev-parse --short HEAD"):gsub("%s+", "")
  if vim.v.shell_error ~= 0 then
    vim.notify("Not in a git repo", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_put({ sha }, "c", true, true)
end, { desc = "Insert git commit SHA" })
keymap.set("n", "<leader>nT", function()
  -- Always open today's daily note in the global notes vault
  local vault = vim.g.obsidian_default_vault
  if not vault or vim.fn.isdirectory(vault) ~= 1 then
    vim.notify("No notes vault found. Set $OBSIDIAN_VAULT or create ~/Notes.", vim.log.levels.WARN)
    return
  end
  local path = vault .. "/" .. os.date("%Y-%m-%d") .. ".md"
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end, { desc = "Global daily note" })
wk.add(
  {
    { "<leader>n", group = "Notes" },
  }
)



-- Git: Workflow
local git_commit = require("core.git-commit")
keymap.set("n", "<leader>va", function()
  vim.fn.system({ "git", "add", "--update" })
  if vim.v.shell_error == 0 then
    vim.notify("Staged tracked files.", vim.log.levels.INFO)
  else
    vim.notify("git add --update failed.", vim.log.levels.ERROR)
  end
end, { desc = "stage tracked (add -u)" })
keymap.set("n", "<leader>vc", git_commit.commit, { desc = "AI commit" })
keymap.set("n", "<leader>vp", function()
  vim.fn.system({ "git", "push" })
  if vim.v.shell_error == 0 then
    vim.notify("Pushed.", vim.log.levels.INFO)
  else
    vim.notify("Push failed.", vim.log.levels.ERROR)
  end
end, { desc = "push" })
keymap.set("n", "<leader>vv", git_commit.add_commit_push, { desc = "add, commit & push" })
keymap.set("n", "<leader>vs", "<cmd>Git<CR>", { desc = "fugitive status" })
keymap.set("n", "<leader>vb", "<cmd>Git blame<CR>", { desc = "fugitive blame" })
keymap.set("n", "<leader>vl", "<cmd>Git log --oneline<CR>", { desc = "git log" })
wk.add(
  {
    { "<leader>v", group = "Git" },
  }
)

-- Linting
keymap.set("n", "<leader>ll", function() require("core.lint").lint() end, { desc = "lint" })
wk.add(
  {
    { "<leader>l", group = "Linting" },
  }
)
