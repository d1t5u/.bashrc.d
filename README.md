## .bashrc.d

    cd
    git clone https://github.com/d1t5u/.bashrc.d

    bash ~/.bashrc.d/setup.sh
    . .bashrc

<br>

### PS1 colors

Preview color options

    bash ~/.bashrc.d/preview_colors.sh
<br>

Display help

    set_colors help


Set colors

    set_colors red
    set_colors black gold 16 white
    set_colors _ _ black yellow_light

    # Or using a predefined schema
    gold
    dir_almond


Reset to defaults

    # Reset to saved defaults
    set_colors reset

    # Reset to initial configuration
    set_colors reset init
    # or
    my_ps1_colors


List of specified colors/schemas

    set_colors list colors
    set_colors list schemas l


To change the initial color schema, edit the "DEFAULTS" section in the `PS1_colors` file

    # .bashrc.d/PS1_colors

    DEFAULT_TEXT_COLOR_1=$BLACK
    DEFAULT_BACKGROUND_COLOR_1=$GOLD

Save current settings as local defaults

    set_colors save


Get a color number

    get_color_number green

<br>

### LS_COLORS

Display help

    set_ls_colors help


Modify LS_COLORS

    set_ls_colors ln cyan
    set_ls_colors di 16 yellow_light
    set_ls_colors di black _


Save current settings as local defaults

    set_ls_colors save


Reset to defaults

    # Initial user cofiguration
    set_ls_colors reset init
    # or
    my_ls_colors

    # Saved user configuration
    set_ls_colors reset

    # System defaluts (`dircolors`)
    set_ls_colors reset system
