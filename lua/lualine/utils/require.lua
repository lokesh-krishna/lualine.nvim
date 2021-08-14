-- local sep = package.config:sub(1,1)

-- local root = debug.getinfo(1, "S").source
-- if root:sub(1,1) ~= '@' then return require end

-- local base_start = root:find(table.concat({'lualine.nvim', 'lua', 'lualine', 'utils', 'require.lua'}, sep))

-- if not base_start then return require end

-- root = root:sub(2, base_start + 12 + 1 + 3) -- #lualine.nvim = 12 , #lua = 3.
-- if not root then return require end

local root = '/data/data/com.termux/files/home/.local/share/nvim/site/pack/packer/start/lualine.nvim/lua/'
local function custom_require(module)
  if package.loaded[module] then return package.loaded[module] end
  -- local mod_path = root .. module:gsub('%.', sep)..'.lua'
  local mod_path = root .. module:gsub('%.', '/')..'.lua'
  local retval = dofile(mod_path)
  package.loaded[module] = retval
  return retval
end

return custom_require
