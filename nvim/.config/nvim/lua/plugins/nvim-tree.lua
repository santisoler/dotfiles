local function config()
    require("nvim-tree").setup {}
    vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
    -- vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>")
end

return {
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = config,
    }
}
