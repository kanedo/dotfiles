return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",

    "nvim-neotest/neotest-python",
    "nvim-treesitter/nvim-treesitter"
  },
  config = function()
    -- Required for neotest-python to find the test files
    require("neotest").setup({
      adapters = {
        require("neotest-python")({}),
      },
    })
  end,
  opts = {
    adapters = {
      ["neotest-python"] = {
        -- Here you can specify the settings for the adapter, i.e.
        runner = "pytest",
        -- python = ".venv/bin/python",
      },
    },
  },
}
