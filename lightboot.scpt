tell application "iTerm"
	tell current window
		set kisskissTab to (create tab with default profile)
	end tell

	tell current window
		set kisskissOps to (create tab with default profile)
	end tell

	tell current session of kisskissTab
		split horizontally with default profile
		split horizontally with default profile
		split vertically with default profile
	end tell

	tell current session of kisskissOps
		split vertically with default profile
	end tell

	tell first session of kisskissTab
		write text "kisskiss"
		write text "HOT_RAILS_PORT=3500 REACT_ON_RAILS_ENV=HOT rails s -b 0.0.0.0"
	end tell

	tell second session of kisskissTab
		write text "kisskiss"
		write text "zeus start"
	end tell

	tell third session of kisskissTab
		write text "kisskiss"
		write text "HOT_RAILS_PORT=3500 cd client && yarn live-assets"
	end tell

	tell fourth session of kisskissTab
		write text "kisskiss"
		write text "cd client && yarn build:dev"
	end tell

	tell first session of kisskissOps
		write text "kisskiss"
	end tell

	tell second session of kisskissOps
		write text "kisskiss"
	end tell
end tell
