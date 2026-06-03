local branch_diff = { added = 0, modified = 0, removed = 0 }

local function refresh_branch_diff()
  vim.system({ 'git', 'merge-base', 'HEAD', 'origin/HEAD' }, { text = true }, function(base_res)
    if base_res.code ~= 0 then return end
    local base = vim.trim(base_res.stdout or '')
    if base == '' then return end
    vim.system({ 'git', 'diff', '--numstat', base }, { text = true }, function(diff_res)
      if diff_res.code ~= 0 then return end
      local added, removed = 0, 0
      for line in (diff_res.stdout or ''):gmatch('[^\n]+') do
        local a, r = line:match('^(%d+)%s+(%d+)')
        if a and r then
          added = added + tonumber(a)
          removed = removed + tonumber(r)
        end
      end
      branch_diff = { added = added, modified = 0, removed = removed }
      vim.schedule(function() pcall(require('lualine').refresh) end)
    end)
  end)
end

vim.api.nvim_create_autocmd({ 'BufWritePost', 'FocusGained', 'VimEnter' }, {
  callback = function() vim.schedule(refresh_branch_diff) end,
})

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'catppuccin-mocha',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      'branch',
      { 'diff', source = function() return branch_diff end },
      'diagnostics',
    },
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
