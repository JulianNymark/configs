vim.api.nvim_create_user_command("DebugIndentation", function()
  local opts = {
    "expandtab",
    "tabstop",
    "shiftwidth",
    "softtabstop",
    "smarttab",
    "autoindent",
    "smartindent",
    "cindent",
  }

  local scopes = {
    { name = "buffer", source = vim.bo },
    { name = "window", source = vim.wo },
    { name = "global", source = vim.o },
  }

  for _, opt in ipairs(opts) do
    local value = nil
    local scope_found = nil

    for _, s in ipairs(scopes) do
      local ok, v = pcall(function() return s.source[opt] end)
      if ok then
        value = v
        scope_found = s.name
        break
      end
    end

    if value ~= nil then
      print(string.format("%-14s = %-8s (from %s)", opt, vim.inspect(value), scope_found))
    else
      print(string.format("%-14s = <not found>", opt))
    end
  end
end, {})
