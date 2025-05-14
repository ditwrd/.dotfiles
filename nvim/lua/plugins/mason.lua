-- -- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
--
-- -- Customize Mason plugins
--
-- ---@type LazySpec
-- return {
-- 	-- use mason-lspconfig to configure LSP installations
-- 	{
-- 		"williamboman/mason-lspconfig.nvim",
-- 		-- overrides `require("mason-lspconfig").setup(...)`
-- 		opts = function(_, opts)
-- 			-- add more things to the ensure_installed table protecting against community packs modifying it
-- 			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
-- 				"lua_ls",
-- 				-- add more arguments for adding more language servers
-- 			})
-- 		end,
-- 	},
-- 	-- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
-- 	{
-- 		"jay-babu/mason-null-ls.nvim",
-- 		-- overrides `require("mason-null-ls").setup(...)`
-- 		opts = function(_, opts)
-- 			-- add more things to the ensure_installed table protecting against community packs modifying it
-- 			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
-- 				"prettier",
-- 				"stylua",
-- 				-- add more arguments for adding more null-ls sources
-- 			})
-- 		end,
-- 	},
-- 	{
-- 		"jay-babu/mason-nvim-dap.nvim",
-- 		-- overrides `require("mason-nvim-dap").setup(...)`
-- 		opts = function(_, opts)
-- 			-- add more things to the ensure_installed table protecting against community packs modifying it
-- 			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
-- 				"python",
-- 				-- add more arguments for adding more debuggers
-- 			})
-- 		end,
-- 	},
-- }

if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",

        -- install formatters
        "stylua",

        -- install debuggers
        "debugpy",

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
}
