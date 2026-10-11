local M = {}

local prompt = [[
Below is a diff of all staged changes, coming from the command:

```
git diff --cached
```

Please generate a concise, commit message for these changes. Follow the conventions for Conventional Commits. Just print the commit message, no extra characters]]

local buf, win, push_after

local function close()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  buf, win = nil, nil
end

local function do_commit()
  local msg = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
  msg = vim.trim(msg)
  if msg == "" then
    vim.notify("Empty commit message, aborting.", vim.log.levels.WARN)
    return
  end
  close()
  vim.fn.system({ "git", "commit", "-m", msg })
  if vim.v.shell_error ~= 0 then
    vim.notify("Commit failed.", vim.log.levels.ERROR)
    return
  end
  vim.notify("Committed: " .. vim.split(msg, "\n")[1], vim.log.levels.INFO)
  if push_after then
    vim.fn.system({ "git", "push" })
    if vim.v.shell_error == 0 then
      vim.notify("Pushed.", vim.log.levels.INFO)
    else
      vim.notify("Push failed.", vim.log.levels.ERROR)
    end
  end
end

local function open_float(lines)
  close()

  buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "gitcommit"
  vim.bo[buf].bufhidden = "wipe"

  local width = math.min(80, vim.o.columns - 4)
  local height = math.max(#lines + 2, 8)
  local footer = push_after
    and " [<CR> commit & push] [r regenerate] [q cancel] "
    or " [<CR> commit] [r regenerate] [q cancel] "

  win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " Commit Message ",
    title_pos = "center",
    footer = footer,
    footer_pos = "center",
  })

  local kopts = { buffer = buf, nowait = true }
  vim.keymap.set("n", "<CR>", do_commit, kopts)
  vim.keymap.set("n", "r", function() M._generate() end, kopts)
  vim.keymap.set("n", "q", function()
    close()
    vim.notify("Commit cancelled.", vim.log.levels.INFO)
  end, kopts)
end

function M._generate()
  local diff = vim.fn.system({ "git", "diff", "--cached", ":(exclude)uv.lock" })
  if vim.v.shell_error ~= 0 or vim.trim(diff) == "" then
    vim.notify("No staged changes.", vim.log.levels.WARN)
    return
  end

  open_float({ "Generating commit message..." })
  vim.bo[buf].modifiable = false

  vim.system(
    { "llm", prompt },
    { stdin = diff },
    vim.schedule_wrap(function(result)
      if not buf or not vim.api.nvim_buf_is_valid(buf) then return end
      vim.bo[buf].modifiable = true
      if result.code ~= 0 then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Error generating message. Press r to retry." })
        return
      end
      local msg = vim.trim(result.stdout or "")
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(msg, "\n"))
    end)
  )
end

function M.commit()
  push_after = false
  M._generate()
end

function M.add_commit_push()
  vim.fn.system({ "git", "add", "--update" })
  if vim.v.shell_error ~= 0 then
    vim.notify("git add --update failed.", vim.log.levels.ERROR)
    return
  end
  vim.notify("Staged tracked files.", vim.log.levels.INFO)
  push_after = true
  M._generate()
end

return M
