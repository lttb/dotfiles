local wezterm = require("wezterm")

return {
	font = wezterm.font("Fira Code", { weight = 450, stretch = "Normal", style = "Normal" }),
	font_size = 14.0,
	line_height = 1.2,

	window_close_confirmation = "NeverPrompt",
	color_scheme = "OneHalfDark",

	window_decorations = "RESIZE",
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 0,
	},

	enable_scroll_bar = true,

	tab_max_width = 40,

	alternate_buffer_wheel_scroll_speed = 100,

	initial_cols = 164,
	initial_rows = 40,

	tab_bar_at_bottom = true,

	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.8,
	},
}
