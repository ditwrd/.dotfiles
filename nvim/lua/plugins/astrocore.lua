-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 4096 * 256 * 2, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      n = {
        -- second key is the lefthand side of the map
        -- mappings seen under group name "Buffer"
        --
        ["-"] = { "<cmd>split<cr>", desc = "Horizontal Split" },
        ["\\"] = false,
        ["<Leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
        ["<Leader>bD"] = {
          function()
            require("astronvim.utils.status").heirline.buffer_picker(
              function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        ["<Leader>b"] = { name = "Buffers" },
        ["<Leader>j"] = { "<cmd>HopWord<cr>", desc = "Hop" },
        ["<Leader>re"] = {
          function() require("nvim-python-repl").send_statement_definition() end,
          desc = "Send semantic unit to REPL",
        },
        ["<Leader>B"] = { name = "Bounding Box" },
        ["<Leader>Bb"] = {
          "<Cmd>CBccbox<CR>",
          desc = "Title box",
        },
        ["<Leader>Bt"] = {
          "<Cmd>CBllline<CR>",
          desc = "Title line",
        },
        ["<Leader>Bl"] = {
          "<Cmd>CBline<CR>",
          desc = "Comment line",
        },
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },
      v = {
        ["<Leader>j"] = { "<cmd>HopWord<cr>", desc = "Hop" },
        ["<Leader>re"] = {
          function() require("nvim-python-repl").send_visual_to_repl() end,
          desc = "Send visual selection to REPL",
        },
        ["<Leader>B"] = { name = "Bounding Box" },
        ["<Leader>Bb"] = {
          "<Cmd>CBccbox<CR>",
          desc = "Title box",
        },
        ["<Leader>Bt"] = {
          "<Cmd>CBllline<CR>",
          desc = "Title line",
        },
        ["<Leader>Bl"] = {
          "<Cmd>CBline<CR>",
          desc = "Comment line",
        },
      },
    },
  },
}
