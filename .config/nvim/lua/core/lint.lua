
local M = {}

function M.lint()
  -- First, run the formatter unconditionally
  vim.fn.system("uvx ruff format .")

  -- Then, run the linter and capture its output and exit code
  local linter_command = "uvx ruff check --fix src tests"
  local output = vim.fn.system(linter_command)
  local exit_code = vim.v.shell_error

  -- Only show a message if the linter command failed (found errors)
  if exit_code ~= 0 then
    -- Display the linter output in a notification
    vim.api.nvim_echo({{"Linter found issues:", "ErrorMsg"}, {output, "None"}}, true, {})
  end
end

return M
