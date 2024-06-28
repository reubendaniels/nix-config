-- boilerplate

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

local is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end

local is_macos = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'OneDark (base16)'
  else
    return 'One Light (base16)'
  end
end

function get_window_decorations()
  if is_macos() then
    return 'INTEGRATED_BUTTONS|RESIZE'
  else
    return 'RESIZE'
  end
end

function get_window_padding()
  if is_macos() then
    return {
      left = 15,
      right = 15,
      top = 50,
      bottom = 10,
    }
  else
    return {
      left = 15,
      right = 15,
      top = 10,
      bottom = 10,
    }
  end
end

-- fonts

config.font = wezterm.font("IosevkaLB", {weight="DemiBold"})
config.font_size = 12.0
config.font_rules = {
  {
    intensity = "Bold",
    font = wezterm.font("IosevkaLB", {weight="Bold"})
  }
}
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.initial_cols = 110
config.initial_rows = 35

-- window configuration
config.window_decorations = get_window_decorations()
config.window_padding = get_window_padding() 
config.color_scheme = scheme_for_appearance(get_appearance())

-- tab bar
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- cursor
config.default_cursor_style = 'SteadyBar'
config.cursor_thickness = '3px'

-- disable wayland on Linux
if is_linux() then
  config.enable_wayland = false
end

return config
