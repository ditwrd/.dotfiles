return {
  { "wakatime/vim-wakatime", lazy = false },
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
}
