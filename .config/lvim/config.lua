-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

lvim.plugins = {
    {
        "Mofiqul/adwaita.nvim",
        lazy = false,
        priority = 1000
    },
    "askfiy/visual_studio_code"
}

lvim.use_icons = false
lvim.colorscheme = "adwaita"
lvim.format_on_save.enabled = true
lvim.builtin.project = {
    detection_methods = { "lsp", "pattern" }
}

local lspconfig = require('lspconfig')
local configs = require('lspconfig/configs')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.emmet_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug",
        "typescriptreact", "vue" },
    init_options = {}
})

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup {
    { name = "black" }
}

local linters = require("lvim.lsp.null-ls.linters")
linters.setup {
    { name = "flake8" },
    { name = "shellcheck" }
}
