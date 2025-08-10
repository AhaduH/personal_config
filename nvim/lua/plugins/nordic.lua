return {
  "AlexvZyl/nordic.nvim",
  name = "nordic",
  config = function()
    require('nordic').setup({
      bold_keywords = false,
      italic_comments = true,
      transparent = {
        bg = true,
        float = true,
      },
      bright_border = false,
      reduced_blue = true,
      swap_backgrounds = false,
      cursorline = {
        bold = false,
        bold_number = true,
        theme = 'dark',
        blend = 0.85,
      },
      noice = {
        style = 'classic',
      },
      telescope = {
        style = 'flat',
      },
      leap = {
        dim_backdrop = false,
      },
      ts_context = {
        dark_background = true,
      },
      on_palette = function(palette) end,
      after_palette = function(palette) end,
      on_highlight = function(highlights, palette) end,
    })

    vim.cmd("colorscheme nordic")
  end,
}

