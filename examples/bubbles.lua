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
EOF

" treesitter configuration
lua << EOF
require("nvim-treesitter.configs").setup {
	ensure_installed = "maintained", 
  	highlight = {
		enable = true,
	},
    indent = {
        enable = true
        }
}
EOF

" telescope configuration
lua << EOF
require("telescope").setup{
	defaults = {
		prompt_prefix = "❯ ",
    		selection_caret = "❯ ",
    		sorting_strategy = "ascending",
    		layout_config = {
      			horizontal = {
        			mirror = false,
				prompt_position = 'top',
				preview_width = 100,
		        },
		    },
	    },
    }
EOF

" gitsigns configuration
lua << EOF
require("gitsigns").setup()
EOF

" nvim-web-devicons setup
lua << EOF
require("nvim-web-devicons").setup()
EOF
