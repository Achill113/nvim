-- Maps the active Omarchy theme (~/.local/state/omarchy/current/theme.name)
-- to the actual colorscheme plugin Omarchy itself ships for that theme, so
-- Neovim's colors track `omarchy theme set` on this machine. Themes Omarchy
-- has no colorscheme for (and non-Omarchy machines) fall back to whatever
-- colors.lua does by default -- see its `fallback` argument to M.apply.
--
-- Source of truth for this mapping: each theme's neovim.lua under
-- /usr/share/omarchy/themes/<slug>/neovim.lua (LazyVim plugin specs).
-- Rather than declaring these as lazy.nvim plugins (which would pull them
-- into :Lazy sync/install machinery), they're loaded straight off the local
-- checkouts Omarchy's own nvim setup already downloaded under
-- ~/.local/share/nvim/lazy/, by extending 'runtimepath' directly -- the
-- same thing `:packadd` does under the hood. No network, no lazy.nvim
-- involvement, works identically headless or interactive.
local M = {}

local plugin_root = vim.fn.expand("~/.local/share/nvim/lazy")

local themes = {
	catppuccin = {
		setup = function()
			require("catppuccin").setup({ flavour = "mocha", transparent_background = true })
		end,
		colorscheme = "catppuccin",
	},
	["catppuccin-latte"] = {
		setup = function()
			require("catppuccin").setup({ flavour = "latte", transparent_background = true })
		end,
		colorscheme = "catppuccin-latte",
	},
	everforest = {
		plugins = { "everforest-nvim" },
		setup = function()
			require("everforest").setup({ background = "soft", transparent_background_enabled = true })
		end,
		colorscheme = "everforest",
	},
	["flexoki-light"] = {
		plugins = { "flexoki-neovim" },
		colorscheme = "flexoki-light",
	},
	gruvbox = {
		plugins = { "gruvbox.nvim" },
		colorscheme = "gruvbox",
	},
	hackerman = {
		-- aether.nvim must load first: hackerman's colorscheme requires it.
		plugins = { "aether.nvim", "hackerman.nvim" },
		colorscheme = "hackerman",
	},
	kanagawa = {
		plugins = { "kanagawa.nvim" },
		colorscheme = "kanagawa",
	},
	lumon = {
		plugins = { "lumon.nvim" },
		colorscheme = "lumon",
	},
	["matte-black"] = {
		plugins = { "matteblack.nvim" },
		colorscheme = "matteblack",
	},
	nord = {
		plugins = { "nightfox.nvim" },
		colorscheme = "nordfox",
	},
	["osaka-jade"] = {
		plugins = { "bamboo.nvim" },
		colorscheme = "bamboo",
	},
	["retro-82"] = {
		plugins = { "retro-82.nvim" },
		colorscheme = "retro-82",
	},
	["rose-pine"] = {
		plugins = { "rose-pine" },
		colorscheme = "rose-pine-dawn",
	},
	solitude = {
		plugins = { "ashen.nvim" },
		colorscheme = "ashen",
	},
	["tokyo-night"] = {
		plugins = { "tokyonight.nvim" },
		colorscheme = "tokyonight-night",
	},
}

local function load_plugin(name)
	local dir = plugin_root .. "/" .. name
	if vim.fn.isdirectory(dir) == 0 then
		error("missing Omarchy colorscheme plugin checkout: " .. dir)
	end
	vim.opt.rtp:append(dir)
end

--- @param set_colorscheme fun(name: string) applies a colorscheme by name (and any post-processing, e.g. transparency)
--- @param fallback fun() applied when there's no entry for the active theme, or loading it fails
function M.apply(set_colorscheme, fallback)
	local theme_name_path = vim.fn.expand("~/.local/state/omarchy/current/theme.name")
	local ok, lines = pcall(vim.fn.readfile, theme_name_path)
	local slug = ok and lines[1]
	local entry = slug and themes[slug]

	if not entry then
		fallback()
		return
	end

	local applied = pcall(function()
		for _, plugin in ipairs(entry.plugins or {}) do
			load_plugin(plugin)
		end
		if entry.setup then
			entry.setup()
		end
		set_colorscheme(entry.colorscheme)
	end)

	if not applied then
		fallback()
	end
end

return M
