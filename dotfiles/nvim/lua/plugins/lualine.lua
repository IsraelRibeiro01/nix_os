return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "papercolor_dark",
        section_separators = { left = "", right = "" },
	component_separators = { left = "", right = "" },
       },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" }, -- shows language
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}

