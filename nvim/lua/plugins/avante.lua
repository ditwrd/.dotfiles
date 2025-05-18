return {
  {
    "yetone/avante.nvim",
    opts = {
      provider = "qwen",
      vendors = {
        qwen = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://127.0.0.1:11434/v1",
          model = "qwen2.5-coder:3b",
        },
        r1 = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://127.0.0.1:11434/v1",
          model = "deepseek-r1:1.5b",
        },
        gem = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://127.0.0.1:11434/v1",
          model = "codegemma:2b",
        },
        ll = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://127.0.0.1:11434/v1",
          model = "llama3.2",
        },
      },
    },
  },
}
