-- Bubbles config for lualine
-- Author: lokesh-krishna
local lualine = require 'lualine'


-- Config
local config = {
  options = {
    icons_enabled = true,
    component_separators = {'|', '|'},
    -- custom moonfly theme located at https://github.com/lokesh-krishna/moonfly.nvim
    theme = 'moonfly',
    }
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {
    {
        'mode',
	separator = {'', ''},
    }
    },
    lualine_b = {'filename', 'branch'},
    lualine_c = {'fileformat'},
    lualine_x = {},
    lualine_y = {
    'filetype',
    {
        'progress',
        right_padding = 2,
    }
    },
    lualine_z = {
    {
        'location',
        separator = {'', ''},
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
