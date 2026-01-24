return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      view = { width = 30, side = "left" },
      renderer = { highlight_git = true, icons = { show = { file = true, folder = true, git = true } } },
    })
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
  end,
}

