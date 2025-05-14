-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
			"lua",
			"python",
			"terraform",
			"javascript",
			"rust",
			"dockerfile",
			"go",
			"templ",
			-- add more arguments for adding more treesitter parsers
		},
	},
}
