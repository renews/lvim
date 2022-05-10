-- Install Lsp server
-- :LspInstall jdtls

local global = require("core.global")
local languages_setup = require("languages.global.utils")
local nvim_lsp_util = require("lspconfig/util")
local default_debouce_time = 150

local language_configs = {}

language_configs["lsp"] = function()
    local server_setup = {
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        filetypes = { "java" },
        on_attach = function(client, bufnr)
            table.insert(global["languages"]["java"]["pid"], client.rpc.pid)
            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            languages_setup.document_highlight(client)
            languages_setup.document_formatting(client)
        end,
        capabilities = languages_setup.get_capabilities(),
        root_dir = function(fname)
            return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
    }
    languages_setup.setup_lsp("jdtls", server_setup)
end

return language_configs
