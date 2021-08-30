-- Bubbles config for lualine
-- Author: lokesh-krishna
local lualine = require 'lualine'


-- Config
local config = {
	options = {
        icons_enabled = true,
		disabled_filetypes = {'NvimTree'},
		theme = 'moonfly',
		component_separators = {'|', '|'},
		section_separators = {'', ''},
  },
	sections = {
		lualine_a = {
			{
			'mode',
			separator = {'', ''},
			right_padding = 2,
			left_padding = 1,
			}
		},
            lualine_b = {
			{
			'filename',
			right_padding = 2,
			left_padding = 2,
		},
			{ 
			'branch',
			right_padding = 2,
			left_padding = 2,
			}
		},
		lualine_c = {'fileformat'},
		lualine_x = {},
		lualine_y = {
			{
			'filetype',
			right_padding = 2,
			left_padding = 2,
			},
			{
			'progress',
			right_padding = 2,
			left_padding = 2,
			} 
		},
    		lualine_z = {
	    		{
	    		'location',
	    		separator = {'', ''},
            		left_padding = 2,
            		right_padding = 1,
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
