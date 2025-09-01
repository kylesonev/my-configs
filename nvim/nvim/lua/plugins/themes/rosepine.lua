return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup({
        variant = 'main', -- ou 'moon' ou 'dawn'
        disable_background = true, -- Isso remove o fundo colorido
        disable_float_background = true, -- Remove fundo de janelas flutuantes
      })

      vim.cmd('colorscheme rose-pine')
    end
  }
}