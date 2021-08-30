-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

require'lualine'.setup {
  options = {
    theme = 'moonfly',
    component_separators = '|',
    section_separators = {'', ''},
  },
  sections = {
    lualine_a = {
      {'mode',
       separator = {'', ''},
       right_padding = 2,
      }
    },
    lualine_b = {
      {'filename', padding = 2},
      {'branch', padding = 2,}
    },
    lualine_c = {'fileformat'},
    lualine_x = {},
    lualine_y = {
      {'filetype', padding = 2},
      {'progress', padding = 2}
    },
    lualine_z = {
      {'location',
       separator = {'', ''},
       left_padding = 2,
      }
    },
  },
  inactive_sections = {
    lualine_a = {'filename'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {'location'}
  },
  tabline = {},
  extensions = {}
}
