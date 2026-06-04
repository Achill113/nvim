require('claude-code').setup({
  window = {
    split_ratio = 0.4,
    position = 'botright vsplit',
    enter_insert = true,
    hide_numbers = true,
    hide_signcolumn = true,
  },
  refresh = {
    enable = true,
    updatetime = 100,
    timer_interval = 1000,
    show_notifications = true,
  },
  git = {
    use_git_root = true,
  },
  shell = {
    separator = '&&',
    pushd_cmd = 'pushd',
    popd_cmd = 'popd',
  },
  command = 'claude --dangerously-skip-permissions',
  command_variants = {
    continue = '--continue',
    resume = '--resume',
    verbose = '--verbose',
  },
  keymaps = {
    toggle = {
      normal = '<leader>ic',
      terminal = '<C-,>',
      variants = {
        continue = '<leader>iC',
        resume = '<leader>ir',
        verbose = '<leader>iv',
      },
    },
    window_navigation = true,
    scrolling = true,
  },
})
