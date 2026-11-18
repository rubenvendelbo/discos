set -gx EZA_CONFIG_DIR ~/.config/eza

if status is-interactive
    # Commands to run in interactive sessions can go here
	zoxide init fish | source
	set -l discos_fish ~/.config/discos/current-theme/fish.fish
	test -f $discos_fish; and source $discos_fish

	function __discos_theme_reload --on-variable discos_theme_stamp
        	source ~/.config/discos/current-theme/fish.fish
        	commandline -f repaint
    	end
end
