-----------------
-- Config file --
-----------------

cfg = {}

cfg.hashVeh = {
	[GetHashKey('POLICE')] = {1 --[[Extra left orange lights]], 2 --[[Extra middle orange lights]], nil --[[Extra right orange lights]], nil --[[Extra light projector]]},
	[GetHashKey('POLICE2')] = {1, 12, nil, 8},
	-- ect ...
}

cfg.keys = {
	124, -- Numpad 4 (Orange lights left)
	126, -- Numpad 6 (Orange lights middle)
	125, -- Numpad 5 (Orange lights right)
	118, -- Numpad 9 (Projectors)
}

cfg.lang = {
	panelStateChanged = "Panel showing state changed",
}

cfg.togglePanelCommand = 'panel' -- Command to toggle the panel