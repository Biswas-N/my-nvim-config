return {
  "mistweaverco/kulala.nvim",
  ft = "http",
  opts = {
    debug = true,
    contenttypes = {
      ["application/json"] = {
        ft = "json",
        formatter = { "jq", "." },
        -- pathresolver = require("kulala.parser.jsonpath").parse,
        pathresolver = {},
      },
      ["text/html"] = {
        ft = "html",
        formatter = { "xmllint", "--format", "--html", "-" },
        pathresolver = {},
      },
    },
    winbar = true,
  },
  keys = {
    {
      "<leader>kr",
      function()
        require("kulala").run()
      end,
      desc = "Kulala: Run",
      mode = "n",
    },
    {
      "<leader>ka",
      function()
        require("kulala").run_all()
      end,
      desc = "Kulala: Run all",
      mode = "n",
    },
    {
      "<leader>kx",
      function()
        require("kulala").close()
      end,
      desc = "Kulala: Close",
      mode = "n",
    },
    {
      "<leader>ks",
      function()
        require("kulala").scratchpad()
      end,
      desc = "Kulala: Scratchpad",
      mode = "n",
    },
    {
      "<leader>k[",
      function()
        require("kulala").jump_prev()
      end,
      desc = "Kulala: Prev Request",
      mode = "n",
    },
    {
      "<leader>k]",
      function()
        require("kulala").jump_next()
      end,
      desc = "Kulala: Next Request",
      mode = "n",
    },
  },
}
