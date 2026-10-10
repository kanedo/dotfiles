return {
  'akinsho/bufferline.nvim',
  config = function ()
    require('bufferline').setup({
      options = {
        mode = 'buffers',
        offsets = {
          {filetype = 'NvimTree'}
        },
    	numbers = "buffer_id",
      },
      highlights = {
        buffer_selected = {
          italic = false
        },
        indicator_selected = {
          fg = {attribute = 'fg', highlight = 'Function'},
          italic = false
        }
      }
    })
  end
}
