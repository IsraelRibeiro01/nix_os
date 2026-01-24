return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      integrations = {
        alpha = true,
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        lualine = true,
        which_key = true,
      },
    })
    vim.cmd("colorscheme catppuccin")
  end,
}

