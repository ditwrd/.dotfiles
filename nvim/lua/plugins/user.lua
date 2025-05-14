-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function() require("lsp_signature").setup() end,
	},

	-- customize dashboard options
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				preset = {

					header = table.concat({
						"                                                                        ",
						"                                       ,,                               ",
						"                                     `7MM                               ",
						"                                       MM                               ",
						"`7M'   `MF',6\"Yb.  `7MMpMMMb.pMMMb.    MM                               ",
						"  VA   ,V 8)   MM    MM    MM    MM    MM                               ",
						"   VA ,V   ,pm9MM    MM    MM    MM    MM                               ",
						"    VVV   8M   MM    MM    MM    MM    MM                               ",
						"    ,V    `Moo9^Yo..JMML  JMML  JMML..JMML.                             ",
						"   ,V                                                                   ",
						'OOb"                                                                    ',
						"                               ,,                                       ",
						"                               db                                       ",
						"                                                                        ",
						' .gP"Ya `7MMpMMMb.  .P"Ybmmm `7MM  `7MMpMMMb.  .gP"Ya   .gP"Ya `7Mb,od8',
						",M'   Yb  MM    MM :MI  I8     MM    MM    MM ,M'   Yb ,M'   Yb  MM' \"' ",
						'8M""""""  MM    MM  WmmmP"     MM    MM    MM 8M"""""" 8M""""""  MM     ',
						"YM.    ,  MM    MM 8M          MM    MM    MM YM.    , YM.    ,  MM     ",
						" `Mbmmd'.JMML  JMML.YMMMMMb  .JMML..JMML  JMML.`Mbmmd'  `Mbmmd'.JMML.   ",
						"                   6'     dP                                            ",
						"                   Ybmmmd'                                              ",
					}, "\n"),
				},
			},
		},
	},

	-- You can disable default plugins as follows:
	-- { "max397574/better-escape.nvim", enabled = false },

	-- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
	{
		"L3MON4D3/LuaSnip",
		config = function(plugin, opts)
			require "astronvim.plugins.configs.luasnip" (plugin, opts) -- include the default astronvim config that calls the setup call
			-- add more custom luasnip configuration such as filetype extend or custom snippets
			local luasnip = require "luasnip"
			luasnip.filetype_extend("javascript", { "javascriptreact" })
		end,
	},

	{
		"windwp/nvim-autopairs",
		config = function(plugin, opts)
			require "astronvim.plugins.configs.nvim-autopairs" (plugin, opts) -- include the default astronvim config that calls the setup call
			-- add more custom autopairs configuration such as custom rules
			local npairs = require "nvim-autopairs"
			local Rule = require "nvim-autopairs.rule"
			local cond = require "nvim-autopairs.conds"
			npairs.add_rules(
				{
					Rule("$", "$", { "tex", "latex" })
					-- don't add a pair if the next character is %
							:with_pair(cond.not_after_regex "%%")
					-- don't add a pair if  the previous character is xxx
							:with_pair(
								cond.not_before_regex("xxx", 3)
							)
					-- don't move right when repeat character
							:with_move(cond.none())
					-- don't delete if the next character is xx
							:with_del(cond.not_after_regex "xx")
					-- disable adding a newline when you press <cr>
							:with_cr(cond.none()),
				},
				-- disable for .vim files, but it work for another filetypes
				Rule("a", "a", "-vim")
			)
		end,
	},
	{ "wakatime/vim-wakatime",   lazy = false },
	{ "pearofducks/ansible-vim", event = "User Astrofile" },
	{
		"phaazon/hop.nvim",
		branch = "v2", -- optional but strongly recommended
		opts = {
			keys = "wersdfuiojklcmvn",
		},
		cmd = "HopWord",
	},
	{
		"danymat/neogen",
		opts = { languages = { python = { template = { annotation_convention = "google_docstrings" } } } },
	},
	{ "andweeb/presence.nvim", lazy = false },
	{
		"geg2102/nvim-python-repl",
		dependencies = "nvim-treesitter",
		ft = { "python", "lua", "scala" },
		config = function()
			require("nvim-python-repl").setup {
				execute_on_send = true,
				vsplit = true,
			}
		end,
	},
	{ "joerdav/templ.vim" },
}
