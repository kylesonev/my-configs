-- ~/.config/nvim/lua/core/rust-keymaps.lua

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Rust específico
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function()
    -- Rust Tools
    map('n', '<leader>rr', '<cmd>RustRunnables<cr>', { desc = 'Rust Runnables' })
    map('n', '<leader>rt', '<cmd>RustTest<cr>', { desc = 'Rust Test' })
    map('n', '<leader>rd', '<cmd>RustDebuggables<cr>', { desc = 'Rust Debuggables' })
    map('n', '<leader>rh', '<cmd>RustHoverActions<cr>', { desc = 'Rust Hover Actions' })
    map('n', '<leader>rc', '<cmd>RustCodeAction<cr>', { desc = 'Rust Code Action' })
    map('n', '<leader>ro', '<cmd>RustOpenExternalDocs<cr>', { desc = 'Rust Open Docs' })

    -- Crates
    map('n', '<leader>ct', '<cmd>lua require("crates").toggle()<cr>', { desc = 'Toggle Crates' })
    map('n', '<leader>cr', '<cmd>lua require("crates").reload()<cr>', { desc = 'Reload Crates' })
    map('n', '<leader>cv', '<cmd>lua require("crates").show_versions_popup()<cr>', { desc = 'Show Versions' })
    map('n', '<leader>cf', '<cmd>lua require("crates").show_features_popup()<cr>', { desc = 'Show Features' })
    map('n', '<leader>cd', '<cmd>lua require("crates").show_dependencies_popup()<cr>', { desc = 'Show Dependencies' })
    map('n', '<leader>cu', '<cmd>lua require("crates").update_crate()<cr>', { desc = 'Update Crate' })
    map('n', '<leader>ca', '<cmd>lua require("crates").update_all_crates()<cr>', { desc = 'Update All Crates' })
    map('n', '<leader>cU', '<cmd>lua require("crates").upgrade_crate()<cr>', { desc = 'Upgrade Crate' })
    map('n', '<leader>cA', '<cmd>lua require("crates").upgrade_all_crates()<cr>', { desc = 'Upgrade All Crates' })

    -- Cargo commands
    map('n', '<leader>cc', '<cmd>!cargo check<cr>', { desc = 'Cargo Check' })
    map('n', '<leader>cb', '<cmd>!cargo build<cr>', { desc = 'Cargo Build' })
    map('n', '<leader>cr', '<cmd>!cargo run<cr>', { desc = 'Cargo Run' })
    map('n', '<leader>ct', '<cmd>!cargo test<cr>', { desc = 'Cargo Test' })
    map('n', '<leader>cl', '<cmd>!cargo clippy<cr>', { desc = 'Cargo Clippy' })
    map('n', '<leader>cf', '<cmd>!cargo fmt<cr>', { desc = 'Cargo Format' })
    map('n', '<leader>cd', '<cmd>!cargo doc --open<cr>', { desc = 'Cargo Doc' })
  end,
})

-- DAP (Debug Adapter Protocol) keymaps
map('n', '<F5>', '<cmd>lua require("dap").continue()<CR>', { desc = 'Debug Continue' })
map('n', '<F10>', '<cmd>lua require("dap").step_over()<CR>', { desc = 'Debug Step Over' })
map('n', '<F11>', '<cmd>lua require("dap").step_into()<CR>', { desc = 'Debug Step Into' })
map('n', '<F12>', '<cmd>lua require("dap").step_out()<CR>', { desc = 'Debug Step Out' })
map('n', '<leader>db', '<cmd>lua require("dap").toggle_breakpoint()<CR>', { desc = 'Toggle Breakpoint' })
map('n', '<leader>dB', '<cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
  { desc = 'Conditional Breakpoint' })
map('n', '<leader>dr', '<cmd>lua require("dap").repl.open()<CR>', { desc = 'Debug REPL' })
map('n', '<leader>dl', '<cmd>lua require("dap").run_last()<CR>', { desc = 'Debug Run Last' })
map('n', '<leader>du', '<cmd>lua require("dapui").toggle()<CR>', { desc = 'Debug UI Toggle' })
map('n', '<leader>de', '<cmd>lua require("dapui").eval()<CR>', { desc = 'Debug Eval' })

-- LSP keymaps específicos para Rust
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }

    -- Navegação
    map('n', 'gD', vim.lsp.buf.declaration, opts)
    map('n', 'gd', vim.lsp.buf.definition, opts)
    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', 'gi', vim.lsp.buf.implementation, opts)
    map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    map('n', 'gr', vim.lsp.buf.references, opts)

    -- Code actions
    map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    map('n', '<leader>rn', vim.lsp.buf.rename, opts)
    map('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    -- Diagnósticos
    map('n', '[d', vim.diagnostic.goto_prev, opts)
    map('n', ']d', vim.diagnostic.goto_next, opts)
    map('n', '<leader>e', vim.diagnostic.open_float, opts)
    map('n', '<leader>q', vim.diagnostic.setloclist, opts)
  end,
})
