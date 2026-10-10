local function create_test_file()
  if vim.bo.filetype ~= 'python' then
    print('This command only works for Python files.')
    return
  end

  local file_path = vim.fn.expand('%:p')
  local project_root = vim.fn.getcwd()
  local relative_path = vim.fn.fnamemodify(file_path, ':~:.')
  local test_file_path = relative_path:gsub('^src/', 'tests/'):gsub('%.py$', '')

  local path_parts = vim.split(test_file_path, '/')
  table.remove(path_parts, 2)
  test_file_path = table.concat(path_parts, '/')

  local filename = vim.fn.fnamemodify(test_file_path, ':t')
  local dirname = vim.fn.fnamemodify(test_file_path, ':h')
  test_file_path = dirname .. '/test_' .. filename .. '.py'

  test_file_path = project_root .. '/' .. test_file_path

  if vim.fn.filereadable(test_file_path) == 0 then
    vim.fn.mkdir(vim.fn.fnamemodify(test_file_path, ':h'), 'p')
    vim.fn.writefile({}, test_file_path)
  else
  end

  local function_name = nil
  local node = vim.treesitter.get_node()
  while node do
    if node:type() == 'function_definition' then
      function_name = node:child(1):get_text()
      break
    end
    node = node:parent()
  end

  if function_name then
    local test_function_name = string.format("test_%s", function_name)
    local test_file_content = vim.fn.readfile(test_file_path)
    local test_function_exists = false

    for _, line in ipairs(test_file_content) do
      if line:match("^def " .. test_function_name .. "%(") then
        test_function_exists = true
        break
      end
    end

    if not test_function_exists then
      local test_function = {"", "", string.format("def %s():", test_function_name), "", "    assert False", ""}
      for _, v in ipairs(test_function) do
        table.insert(test_file_content, v)
      end
      vim.fn.writefile(test_file_content, test_file_path)
      vim.cmd('edit ' .. test_file_path)
      return
    else
      for i, line in ipairs(test_file_content) do
        if line:match("^def " .. test_function_name .. "%(") then
          vim.cmd('edit +' .. i .. ' ' .. test_file_path)
          return
        end
      end
    end
  end

end

vim.api.nvim_create_user_command('CreateTestFile', create_test_file, {})
