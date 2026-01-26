-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/folke/lazy.nvim",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.termguicolors = true
vim.opt.background =  "dark"
vim.g.nvim_tree_respect_buf_cwd = 1
vim.cmd("highlight NvimTreeNormal guibg=nome")
vim.cmd([[
  highlight Normal       ctermbg=none guibg=none
  highlight NormalFloat  ctermbg=none guibg=none
  highlight SignColumn   ctermbg=none guibg=none
  highlight EndOfBuffer  ctermbg=none guibg=none
]])

require("lazy").setup({
  { import = "plugins" },
}, {
  ui = { border = "rounded" },
})


