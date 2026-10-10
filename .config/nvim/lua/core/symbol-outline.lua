local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")

local kind_map = {
  [5] = { name = "class", icon = "●" },
  [6] = { name = "method", icon = "ƒ" },
  [9] = { name = "constructor", icon = "ƒ" },
  [12] = { name = "function", icon = "ƒ" },
}

local allowed_kinds = { [5] = true, [6] = true, [9] = true, [12] = true }

local function flatten(symbols, depth, result)
  for _, sym in ipairs(symbols) do
    if allowed_kinds[sym.kind] then
      local info = kind_map[sym.kind]
      local indent = string.rep("  ", depth)
      local prefix = depth > 0 and "├ " or ""
      table.insert(result, {
        display_name = indent .. prefix .. info.icon .. " " .. sym.name,
        name = sym.name,
        kind = info.name,
        lnum = sym.range.start.line + 1,
        col = sym.range.start.character,
        depth = depth,
      })
      if sym.children then
        flatten(sym.children, depth + 1, result)
      end
    elseif sym.children then
      flatten(sym.children, depth, result)
    end
  end
end

function M.show()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)

  -- Find a client that supports documentSymbol (prefer basedpyright/pyright)
  local client
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/documentSymbol" })) do
    if c.name == "basedpyright" or c.name == "pyright" or c.name == "lua_ls" then
      client = c
      break
    end
    client = client or c
  end
  if not client then
    vim.notify("No LSP with document symbol support.", vim.log.levels.WARN)
    return
  end

  client:request("textDocument/documentSymbol", {
    textDocument = vim.lsp.util.make_text_document_params(),
  }, function(err, result)
    if err or not result or #result == 0 then
      vim.notify("No symbols found.", vim.log.levels.INFO)
      return
    end
    vim.schedule(function()
      -- vim.notify(vim.inspect(vim.tbl_map(function(s) return { name = s.name, kind = s.kind, children = s.children and #s.children or 0 } end, result)))

      local entries = {}
      flatten(result, 0, entries)

      local displayer = entry_display.create({
        separator = " ",
        items = {
          { width = 60 },
          { remaining = true },
        },
      })

      pickers.new({}, {
        prompt_title = "Symbol Outline",
        finder = finders.new_table({
          results = entries,
          entry_maker = function(e)
            return {
              value = e,
              display = function()
                return displayer({
                  { e.display_name, e.kind == "class" and "Type" or "Function" },
                  { ":" .. e.lnum, "Comment" },
                })
              end,
              ordinal = e.name,
              filename = filename,
              lnum = e.lnum,
              col = e.col,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        previewer = conf.grep_previewer({}),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            local entry = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col })
          end)
          return true
        end,
      }):find()
    end)
  end)
end

return M
