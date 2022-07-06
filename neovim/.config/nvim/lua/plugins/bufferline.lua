-- Configure bufferline
require('bufferline').setup{
  options = {
    offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "center"}},
    separator_style = "thin",
    always_show_bufferline = false,
    show_close_icon = false,
  }
}
