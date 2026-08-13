-- Reads the Claude Code OAuth token for the CodeCompanion ACP adapter.
--
-- It deliberately does not come from the environment: exporting
-- CLAUDE_CODE_OAUTH_TOKEN from a shell rc file overrides whatever account the
-- `claude` CLI is logged in as, everywhere, for every process. Keeping it in
-- the OS keyring scopes it to the one Neovim process that needs it.

local M = {}

M.service = "claude-code-oauth"

local keyring = {
  Darwin = { "security", "find-generic-password", "-s", M.service, "-w" },
  Linux = { "secret-tool", "lookup", "service", M.service },
}

---@param os_name? string sysname as reported by uname; defaults to this machine
---@return string[]|nil
function M.command(os_name)
  return keyring[os_name or vim.uv.os_uname().sysname]
end

---@return string path of the chmod 600 file used where no keyring is available
function M.fallback_path()
  return vim.fs.normalize((vim.env.XDG_CONFIG_HOME or "~/.config") .. "/claude/oauth-token")
end

---@param path string
---@return string|nil
function M.read_file(path)
  local fd = io.open(path, "r")
  if not fd then
    return nil
  end

  local contents = fd:read("*a")
  fd:close()

  local token = vim.trim(contents or "")
  return token ~= "" and token or nil
end

---@return string|nil
function M.read()
  local cmd = M.command()

  if cmd and vim.fn.executable(cmd[1]) == 1 then
    local result = vim.system(cmd, { text = true }):wait()
    local token = vim.trim(result.stdout or "")
    if result.code == 0 and token ~= "" then
      return token
    end
  end

  return M.read_file(M.fallback_path())
end

return M
