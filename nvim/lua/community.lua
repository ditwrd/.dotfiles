-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
	"AstroNvim/astrocommunity",
	{ import = "astrocommunity.pack.ansible" },
	{ import = "astrocommunity.pack.terraform" },
	{ import = "astrocommunity.pack.python" },
	{ import = "astrocommunity.pack.go" },
	{ import = "astrocommunity.pack.rust" },
	{ import = "astrocommunity.pack.typescript" },
	{ import = "astrocommunity.pack.yaml" },
	{ import = "astrocommunity.pack.markdown" },
	{ import = "astrocommunity.pack.json" },
	{ import = "astrocommunity.pack.bash" },
	{ import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.pack.docker" },
	{ import = "astrocommunity.pack.html-css" },
	{ import = "astrocommunity.pack.nix" },
	{ import = "astrocommunity.pack.tailwindcss" },
	{ import = "astrocommunity.syntax.hlargs-nvim" },
	{ import = "astrocommunity.syntax.vim-sandwich" },
	{ import = "astrocommunity.colorscheme.tokyonight-nvim" },
	--          ╭─────────────────────────────────────────────────────────╮
	--          │                     EDITING SUPPORT                     │
	--          ╰─────────────────────────────────────────────────────────╯
	{ import = "astrocommunity.editing-support.mini-splitjoin" },
	{ import = "astrocommunity.editing-support.nvim-devdocs" },
	{
		"luckasRanarison/nvim-devdocs",
		opts = {
			ensure_installed = {
				"terraform",
				"ansible",
				"go",
				"bash",
			},
		},
	},
	{ import = "astrocommunity.editing-support.neogen" },
	{ import = "astrocommunity.editing-support.todo-comments-nvim" },
	{ import = "astrocommunity.editing-support.refactoring-nvim" },
	{ import = "astrocommunity.editing-support.comment-box-nvim" },
	{ import = "astrocommunity.editing-support.ultimate-autopair-nvim" },
	--          ╭─────────────────────────────────────────────────────────╮
	--          │                           GIT                           │
	--          ╰─────────────────────────────────────────────────────────╯
	{ import = "astrocommunity.git.git-blame-nvim" },
	--          ╭─────────────────────────────────────────────────────────╮
	--          │                           LSP                           │
	--          ╰─────────────────────────────────────────────────────────╯
	{ import = "astrocommunity.lsp.garbage-day-nvim" },
	--          ╭─────────────────────────────────────────────────────────╮
	--          │                        WORKFLOW                         │
	--          ╰─────────────────────────────────────────────────────────╯
	{ import = "astrocommunity.workflow.bad-practices-nvim" },
	{ import = "astrocommunity.workflow.hardtime-nvim" },
	--          ╭─────────────────────────────────────────────────────────╮
	--          │                         MOTION                          │
	--          ╰─────────────────────────────────────────────────────────╯
	{ import = "astrocommunity.motion.harpoon" },
	{ import = "astrocommunity.docker.lazydocker" },
	{
		import = "astrocommunity.completion.avante-nvim",
	},
}
