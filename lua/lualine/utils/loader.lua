-- Copyright (c) 2020-2021 hoob3rt
-- MIT license, see LICENSE for more details.
local notice = require'lualine.utils.notices'
local utils = require'lualine.utils.utils'

local function lualine_load(patern, use_cache)
  assert(utils.is_valid_filename(patern[#patern]), "Invalid filename")
  local retval, cache_name = nil, nil
  local sep = package.config:sub(1,1)

  if use_cache == true then
    -- Turn {lua, lualine, module, name} -> lualine.module.name
    -- same formst that require uses
    -- then check if it's in requires cache
    local copy_patern = {}
    local start = patern[1] == 'lua' and 2 or 1
    local copy_start = 1
    for i=start, #patern do
      copy_patern[copy_start] = patern[i]
      copy_start = copy_start + 1
    end
    cache_name = table.concat(copy_patern, '.')
    if package.loaded[cache_name] then
      return package.loaded[cache_name]
    end
  end

  -- Get all the runtime files that match the patern
  local files = vim.fn.uniq(vim.api.nvim_get_runtime_file(
                  table.concat(patern, sep)..'.lua', true))
  local n_files = #files

  if n_files == 0 then
    -- No match found
    error(table.concat(patern, sep) .. " Not found")
  elseif n_files == 1 then
    -- when only one is found run that and return it's return value
    retval =  dofile(files[1])
  else
    -- More then 1 found . Use the first one that isn't in lualines repo
    local lualine_repo_pattern = table.concat({'lualine.nvim', 'lua', 'lualine'}, sep)
    local file_found = false
    for _, file in ipairs(files) do
      if not file:find(lualine_repo_pattern) then
        retval = dofile(file)
        file_found = true
        break
      end
    end
    if not file_found then
      -- This shouldn't happen but somehow we have multiple files but they
      -- apear to be in lualines repo . Just run the first one
      retval =  dofile(files[1])
    end
  end

  if use_cache == true and cache_name then
    package.loaded[cache_name] = retval
  end
  return retval
end

local component_types = {
  luaf = function(component)
    return
      lualine_load({'lua', 'lualine', 'components', 'special', 'function_component'}, true):new(component)
  end,
  mod = function(component)
    local ok, loaded_component = pcall(lualine_load,
                            {'lua', 'lualine', 'components', component[1]}, true)
    if ok then
      component.component_name = component[1]
      loaded_component = loaded_component:new(component)
      return loaded_component
    end
  end,
  stl = function(component)
    local stl_expr = component[1] -- Vim's %p %l statusline elements
    component[1] = function() return stl_expr end
    return
      lualine_load({'lua', 'lualine', 'components', 'special', 'function_component'}, true):new(component)
  end,
  var = function(component)
    return
        lualine_load({'lua', 'lualine', 'components', 'special', 'vim_var_component'}, true):new(component)
  end,
  ['_'] = function(component)
    return
        lualine_load({'lua', 'lualine', 'components', 'special', 'eval_func_component'}, true):new(component)
  end
}

local function component_loader(component)
  if type(component[1]) == 'function' then
    return component_types.luaf(component)
  end
  if type(component[1]) == 'string' then
    -- load the component
    if component.type ~= nil then
      if component_types[component.type] and component.type ~= 'luaf' then
        return component_types[component.type](component)
      elseif component.type == 'vimf' or component.type == 'luae' then
        return component_types['_'](component)
      else
        notice.add_notice(string.format([[
### component.type

component type '%s' isn't recognised. Check if spelling is correct.]], component.type))
      end
    end
    local loaded_component = component_types.mod(component)
    if loaded_component then
      return loaded_component
    elseif string.char(component[1]:byte(1)) == '%' then
      return component_types.stl(component)
    elseif component[1]:find('[gvtwb]?o?:') == 1 then
      return component_types.var(component)
    else
      return component_types['_'](component)
    end
  end
end

local function option_deprecatation_notice(component)
  local types = {
    case = function()
      local kind = component.upper ~= nil and 'upper' or 'lower'
      notice.add_notice(string.format([[
### option.%s

Option `%s` has been deprecated.
Please use `format` option if you need to change case of a component.

You have some thing like this in your config:

```lua
  %s = true,
```

You'll have to change it to this to retain old behavior:

```lua
  format = string.%s
```
]], kind, kind, kind, kind))
    end,
    padding = function()
      local kind = component.left_padding ~= nil and 'left_padding' or 'right_padding'
      notice.add_notice(string.format([[
### option.%s

Option `%s` has been deprecated.
Please use `padding` option to set left/right padding.

You have some thing like this in your config:

```lua
  %s = %d,
```

You'll have to change it to this to retain old behavior:

```lua
  padding = { %s = %d }
```
if you've set both left_padding and right_padding for a component
you'll need to have something like
```lua
  padding = { left = x, right = y }
```
When you set `padding = x` it's same as `padding = {left = x, right = x}`
]], kind, kind, kind, component[kind], kind == 'left_padding' and 'left' or 'right', component[kind]))
    if component.left_padding and component.right_padding then
      component.padding = {left = component.left_padding, right = component.right_padding}
      component.left_padding = nil
      component.right_padding = nil
    elseif component.left_padding then
      component.padding = {left = component.left_padding, right = 1}
      component.left_padding = nil
    else
      component.padding = {left = 1, right = component.right_padding}
      component.right_padding = nil
    end
  end
}
  if component.upper ~= nil or component.lower ~= nil then types.case() end
  if component.left_padding ~= nil or component.right_padding ~= nil then types.padding() end
end

local function load_sections(sections, options)
  for section_name, section in pairs(sections) do
    for index, component in pairs(section) do
      if type(component) == 'string' or type(component) == 'function' then
        component = {component}
      end
      component.self = {}
      component.self.section = section_name
      -- apply default args
      component = vim.tbl_extend('keep', component, options)
      option_deprecatation_notice(component)
      section[index] = component_loader(component)
    end
  end
end

local function load_components(config)
  load_sections(config.sections, config.options)
  load_sections(config.inactive_sections, config.options)
  load_sections(config.tabline, config.options)
end

local function load_extensions(config)
  local loaded_extensions = {}
  for _, extension in pairs(config.extensions) do
    if type(extension) == 'string' then
      local ok, local_extension = pcall(lualine_load, {'lua', 'lualine', 'extensions', extension}, true)
      if ok then
        local_extension = vim.deepcopy(local_extension)
        load_sections(local_extension.sections, config.options)
        if local_extension.inactive_sections then
          load_sections(local_extension.inactive_sections, config.options)
        end
        if type(local_extension.init) == 'function' then
          local_extension.init()
        end
        table.insert(loaded_extensions, local_extension)
      else
        notice.add_notice(string.format([[
### Extensions
Extension named `%s` was not found . Check if spelling is correct.
]], extension))
      end
    elseif type(extension) == 'table' then
      local local_extension = vim.deepcopy(extension)
      load_sections(local_extension.sections, config.options)
      if local_extension.inactive_sections then
        load_sections(local_extension.inactive_sections, config.options)
      end
      if type(local_extension.init) == 'function' then
        local_extension.init()
      end
      table.insert(loaded_extensions, local_extension)
    end
  end
  config.extensions = loaded_extensions
end

local function load_all(config)
  load_components(config)
  load_extensions(config)
end

local function load_theme(theme_name)
  return lualine_load({'lua', 'lualine', 'themes', theme_name}, false)
end

return {
  load_all = load_all,
  load_theme = load_theme
}
