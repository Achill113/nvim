function ColorMyPencils(color)
	color = color or "catppuccin"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

local function fallback_catppuccin()
	require("catppuccin").setup({
		flavour = "mocha", -- latte, frappe, macchiato, mocha
		transparent_background = true,
	})
	ColorMyPencils("catppuccin")
end

-- Follow the active Omarchy theme (`omarchy theme set ...`) when this machine
-- has one; otherwise (or if that theme has no known colorscheme) fall back to
-- catppuccin, this config's own default -- see lua/achill113/omarchy_theme.lua.
local omarchy_theme_name = vim.fn.expand("~/.local/state/omarchy/current/theme.name")
if vim.uv.fs_stat(omarchy_theme_name) then
	require("achill113.omarchy_theme").apply(ColorMyPencils, fallback_catppuccin)
else
	fallback_catppuccin()
end
