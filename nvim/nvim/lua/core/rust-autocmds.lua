-- ~/.config/nvim/lua/core/rust-autocmds.lua

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Grupo para comandos relacionados ao Rust
local rust_group = augroup('RustConfig', { clear = true })

-- Auto-formatação ao salvar
autocmd('BufWritePre', {
  group = rust_group,
  pattern = '*.rs',
  callback = function()
    if #vim.lsp.get_clients { bufnr = 0 } > 0 then
      vim.lsp.buf.format { async = false }
    end
  end,
})

-- Configurações específicas para arquivos Rust
autocmd('FileType', {
  group = rust_group,
  pattern = 'rust',
  callback = function()
    -- Configurações de indentação
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true

    -- Configurações de display
    vim.opt_local.colorcolumn = '100'
    vim.opt_local.textwidth = 100

    -- Fold method
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt_local.foldenable = false

    -- Configurações específicas para rust-analyzer
    if vim.lsp.get_clients({ name = 'rust_analyzer' })[1] then
      if vim.lsp.inlay_hint then
        vim.lsp.inlay_hint(0, true)
      end
    end
  end,
})

-- Highlight ao copiar (yank)
autocmd('TextYankPost', {
  group = rust_group,
  pattern = '*.rs',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 300 }
  end,
})

-- Auto-comando para arquivos Cargo.toml
autocmd('FileType', {
  group = rust_group,
  pattern = 'toml',
  callback = function()
    if vim.fn.expand '%:t' == 'Cargo.toml' then
      vim.schedule(function()
        local ok, crates = pcall(require, 'crates')
        if ok then
          crates.show()
        else
          vim.notify('crates.nvim não carregado', vim.log.levels.WARN)
        end
      end)
    end
  end,
})

-- Configuração para mostrar warnings de clippy
autocmd('BufEnter', {
  group = rust_group,
  pattern = '*.rs',
  callback = function()
    vim.diagnostic.config {
      virtual_text = {
        prefix = '●',
        source = 'always',
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    }
  end,
})

-- Comando personalizado para executar cargo com diferentes targets
vim.api.nvim_create_user_command('CargoRun', function(opts)
  local cmd = 'cargo run'
  if opts.args and opts.args ~= '' then
    cmd = cmd .. ' ' .. opts.args
  end
  vim.cmd('!' .. cmd)
end, { nargs = '*', desc = 'Run cargo with arguments' })

-- Comando para executar tests específicos
vim.api.nvim_create_user_command('CargoTest', function(opts)
  local cmd = 'cargo test'
  if opts.args and opts.args ~= '' then
    cmd = cmd .. ' ' .. opts.args
  end
  vim.cmd('!' .. cmd)
end, { nargs = '*', desc = 'Run cargo test with arguments' })

-- Comando para check rápido
vim.api.nvim_create_user_command('CargoCheck', function()
  vim.cmd '!cargo check'
end, { desc = 'Run cargo check' })

-- Comando para clippy
vim.api.nvim_create_user_command('CargoClippy', function()
  vim.cmd '!cargo clippy -- -D warnings'
end, { desc = 'Run cargo clippy with warnings as errors' })

-- Função utilitária para encontrar o diretório raiz do projeto Rust
local function find_rust_root()
  local current_dir = vim.fn.expand '%:p:h'
  while current_dir ~= '/' do
    if vim.fn.filereadable(current_dir .. '/Cargo.toml') == 1 then
      return current_dir
    end
    current_dir = vim.fn.fnamemodify(current_dir, ':h')
  end
  return nil
end

-- Auto-comando para definir o diretório de trabalho
autocmd('BufEnter', {
  group = rust_group,
  pattern = '*.rs',
  callback = function()
    local rust_root = find_rust_root()
    if rust_root then
      vim.cmd('lcd ' .. rust_root)
    end
  end,
})
