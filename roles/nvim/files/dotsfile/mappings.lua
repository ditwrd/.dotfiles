-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    --
    ["-"] = { "<cmd>split<cr>", desc = "Horizontal Split" },
    ["\\"] = false,
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    ["<leader>b"] = { name = "Buffers" },
    ["<leader>j"] = { "<cmd>HopWord<cr>", desc = "Hop" },
    ["<leader>re"] = {
      function() require("nvim-python-repl").send_statement_definition() end,
      desc = "Send semantic unit to REPL",
    },
    ["<leader>B"] = { name = "Bounding Box" },
    ["<leader>Bb"] = {
      "<Cmd>CBccbox<CR>",
      desc = "Title box",
    },
    ["<leader>Bt"] = {
      "<Cmd>CBllline<CR>",
      desc = "Title line",
    },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
  v = {
    ["<leader>j"] = { "<cmd>HopWord<cr>", desc = "Hop" },
    ["<leader>re"] = {
      function() require("nvim-python-repl").send_visual_to_repl() end,
      desc = "Send visual selection to REPL",
    },
    ["<leader>B"] = { name = "Bounding Box" },
    ["<leader>Bb"] = {
      "<Cmd>CBccbox<CR>",
      desc = "Title box",
    },
    ["<leader>Bt"] = {
      "<Cmd>CBllline<CR>",
      desc = "Title line",
    },
  },
}
