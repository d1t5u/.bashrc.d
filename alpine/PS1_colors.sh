#!/bin/sh

# To apply system-wide, place this file in /etc/profile.d/
# e.g.: /etc/profile.d/PS1_colors.sh
# It will be sourced automatically by /etc/profile for all login shells.
#
# Set PS1 colors (POSIX/ash version)

THIS_FILE="$HOME/.profile.d/PS1_colors"

#############################
# COLORS

NONE_COLOR=""

## Base colors
RED_DARK=1
RED=9
GREEN_DARK=2
GREEN=10
BLUE=4
BLUE_LIGHT=12
YELLOW=3
YELLOW_LIGHT=11
PURPLE=5
PURPLE_LIGHT=13
CYAN=6
CYAN_LIGHT=14
GREY_LIGHT=7
GREY_DARK=8
WHITE=15
WHITE_SOFT=254
BLACK=16

## Additional colors
PINK=199
MAGENTA=207
MAGENTA_LIGHT=213
ROSE=205
SALMON=211
TAFFY=212
VIOLET=141
INDIGO=105
LAVENDER=111
AZURE=39
AZURE_LIGHT=45
BLUE_PALE=117
AQUA=123
SCARLET=196
ORANGE=202
AMBER=214
GOLD=220
PISTACHIO=71
JADE=107
TEA=150
ALMOND=173
CHOCO=174

export NONE_COLOR RED_DARK RED GREEN_DARK GREEN BLUE BLUE_LIGHT YELLOW \
       YELLOW_LIGHT PURPLE PURPLE_LIGHT CYAN CYAN_LIGHT GREY_LIGHT GREY_DARK \
       WHITE WHITE_SOFT BLACK PINK MAGENTA MAGENTA_LIGHT ROSE SALMON TAFFY \
       VIOLET INDIGO LAVENDER AZURE AZURE_LIGHT BLUE_PALE AQUA SCARLET ORANGE \
       AMBER GOLD PISTACHIO JADE TEA ALMOND CHOCO

COLOR_NAMES="NONE_COLOR RED_DARK RED GREEN_DARK GREEN BLUE BLUE_LIGHT YELLOW \
YELLOW_LIGHT PURPLE PURPLE_LIGHT CYAN CYAN_LIGHT GREY_LIGHT GREY_DARK WHITE \
WHITE_SOFT BLACK PINK MAGENTA MAGENTA_LIGHT ROSE SALMON TAFFY VIOLET INDIGO \
LAVENDER AZURE AZURE_LIGHT BLUE_PALE AQUA SCARLET ORANGE AMBER GOLD PISTACHIO \
JADE TEA ALMOND CHOCO"


to_upper () { printf '%s' "$1" | tr '[:lower:]' '[:upper:]' ; }
to_lower () { printf '%s' "$1" | tr '[:upper:]' '[:lower:]' ; }

# Indirect variable expansion: get_var NAME -> value of $NAME
get_var () { eval "printf '%s' \"\${$1}\"" ; }

is_number () {
    case "$1" in
        ''|*[!0-9]*) return 1 ;;
        *) return 0 ;;
    esac
}


#############################
# DEFAULTS
LOCAL_PS1_COLORS_CONFIG="$HOME/.my_ps1_colors"

my_ps1_colors () {
    RESET=$(printf '\033[0m')
    RESET_BACKGROUND=$(printf '\033[49m')
    DEFAULT_MIDDLE_DOT="$(printf '\033[38;5;%sm' "$GREY_DARK")\$\xc2\xb7${RESET}"

    DEFAULT_LEADING_SPACE=" "
    DEFAULT_TRAILING_SPACE=""

    DEFAULT_COLOR_1=$PISTACHIO
    DEFAULT_COLOR_2=$NONE_COLOR
    DEFAULT_COLOR_3=$CYAN
    DEFAULT_COLOR_4=$NONE_COLOR
    DEFAULT_BOLD=1
}


#############################

display_help () {
    printf '%b\n' " \033[4mUsage:\033[0m $ set_colors [COMMAND]
    or: $ set_colors (color_1 | _ ) [color_2 | _] [color_3 | _] [color_4 | _] [classic]
    or: $ <predefined schema name> [classic]

    To set PS1 colors, provide at least one color name or number(0-256).
    _ keeps the value of the parameter.

    Defaults are specified in the 'DEFAULTS' section of the 'PS_colors' file.
    Or in the 'LOCAL_PS1_COLORS_CONFIG' file ($LOCAL_PS1_COLORS_CONFIG).
    The latter takes precedence.


    \033[4mCommands:\033[0m
        reset               reset to defaults
        reset init          reset to initial configuration
        list colors [l]     list predefined color names
        list schemas [l]    list predefined color schemas
        save                save preferences to the local config
        help                display this help
    "
}


list_colors () {
    if [ -n "$1" ]; then
        printf '%s\n' $COLOR_NAMES | tr '[:upper:]' '[:lower:]'
    else
        printf '%s\n' "$COLOR_NAMES" | tr '[:upper:]' '[:lower:]'
    fi
}


list_schemas () {
    if [ -n "$1" ]; then
        printf '%s\n' $SCHEMA_NAMES
    else
        printf '%s\n' "$SCHEMA_NAMES"
    fi
}


validate_color_name () {
    needle=$(to_upper "$1")
    for color in $COLOR_NAMES; do
        [ "$color" = "$needle" ] && return 0
    done
    printf '%b\n' "\033[01;31m[Error]\033[0m Unknown color name: $1"
    printf '%s\n' " Available colors: "
    list_colors
    return 1
}


validate_color_number () {
    if [ "$1" -gt 256 ] 2>/dev/null; then
        printf '%b\n' "\033[01;31m[Error]\033[0m Wrong parameter. The color number must be in the range 0-256"
        return 1
    fi
    return 0
}


# Lightweight git branch detection (replaces __git_ps1)
git_branch_info () {
    command -v git >/dev/null 2>&1 || return
    branch=$(git symbolic-ref --short HEAD 2>/dev/null) || \
        branch=$(git rev-parse --short HEAD 2>/dev/null) || return

    dirty=""
    if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
        dirty=" $(printf '\033[0;31m')*$(printf '\033[0m')"
    fi
    untracked=""
    if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
        untracked=" $(printf '\033[0;32m')+$(printf '\033[0m')"
    fi
    printf ' \033[38;5;8m\xe2\x8e\x87 %s%s%s \033[0m' "$branch" "$dirty" "$untracked"
}

ps1_additional_info () {
    git_branch_info
}


set_PS1_colors_classic () {
    ## If COLOR_2 or COLOR_4 aren't set, fallback to default reset code (49)
    local BG_1="${COLOR_2:+48;5;${COLOR_2}}"
    local BG_2="${COLOR_4:+48;5;${COLOR_4}}"

    STYLE_1="\[\033[38;5;${COLOR_1};${BG_1:-49}m\]"
    STYLE_2="\[\033[38;5;${COLOR_3};${BG_2:-49}m\]"

    PS1="
${STYLE_1}${LEADING_SPACE}\u@\h${TRAILING_SPACE}${RESET}:${STYLE_2}\w${RESET}\$(ps1_additional_info)
${MIDDLE_DOT} "
}


## Safe version
#set_PS1_colors () {
#    STYLE_1=$(printf '\033[%s;38;5;%s;48;5;%sm' "$BOLD" "$COLOR_2" "$COLOR_1")
#    STYLE_2=$(printf '\033[%s;38;5;%s;48;5;%sm' "$BOLD" "$COLOR_4" "$COLOR_3")
#
#    LEADING_SYMBOL=$(printf '\033[38;5;%s;49m' "$COLOR_1")
#    DELIMITER=$(printf '\033[38;5;%s;48;5;%sm' "$COLOR_1" "$COLOR_3")
#    ENDING_SYMBOL=$(printf '\033[38;5;%s;49m' "$COLOR_3")
#
#    PS1="
#${LEADING_SYMBOL}${RESET}${STYLE_1}\u@\h${DELIMITER}${RESET}${STYLE_2}\w${RESET}${ENDING_SYMBOL}${RESET}\$(ps1_additional_info)
#${MIDDLE_DOT} "
#}



set_PS1_colors () {
    ## STYLE_1 - the first part of PS1 (user@host)
    ##   COLOR_1 - background color, COLOR_2 - text color
    ## STYLE_2 - the second part of PS1 (path)
    ##   COLOR_3 - background color, COLOR_4 - text color
    ## BOLD=1
    STYLE_1="\[\033[${BOLD};38;5;${COLOR_2};48;5;${COLOR_1}m\]"
    STYLE_2="\[\033[${BOLD};38;5;${COLOR_4};48;5;${COLOR_3}m\]"

    LEADING_SYMBOL="\[\033[38;5;${COLOR_1};49m\]"          ## \uE0B6
    DELIMITER="\[\033[38;5;${COLOR_1};48;5;${COLOR_3}m\]"  ## \uE0BC
    ENDING_SYMBOL="\[\033[38;5;${COLOR_3};49m\]"           ## \uE0B0

    PS1="\n${LEADING_SYMBOL}${RESET}${STYLE_1}\u@\h${DELIMITER}${RESET}${STYLE_2}\w${RESET}${ENDING_SYMBOL}${RESET}\$(ps1_additional_info)\n${MIDDLE_DOT}"
}



save_PS1_colors () {
    {
        printf 'RESET="%s"\n'                           "$RESET"
        printf 'MIDDLE_DOT="%s"\n'                      "$MIDDLE_DOT"
        printf 'DEFAULT_LEADING_SPACE="%s"\n'           "$LEADING_SPACE"
        printf 'DEFAULT_TRAILING_SPACE="%s"\n'          "$TRAILING_SPACE"
        printf 'DEFAULT_COLOR_1=%s\n'                   "$COLOR_1"
        printf 'DEFAULT_COLOR_2=%s\n'                   "$COLOR_2"
        printf 'DEFAULT_COLOR_3=%s\n'                   "$COLOR_3"
        printf 'DEFAULT_COLOR_4=%s\n'                   "$COLOR_4"
        printf 'DEFAULT_BOLD=%s\n'                      "$BOLD"
    } > "$LOCAL_PS1_COLORS_CONFIG"
    printf '%b\n' "\033[01;32mSaved to $LOCAL_PS1_COLORS_CONFIG \033[m"
    cat "$LOCAL_PS1_COLORS_CONFIG"
}


# Resolve $1 (name|number|_|classic) into the given variable name $2
resolve_color () {
    _arg=$1
    _outvar=$2
    _default=$3

    if [ -z "$_arg" ]; then
        eval "$_outvar=\$_default"
        return 0
    fi

    _argU=$(to_upper "$_arg")

    if is_number "$_argU"; then
        validate_color_number "$_argU" || return 1
        eval "$_outvar=\$_argU"
    elif [ "$_argU" = "_" ] || [ "$_argU" = "CLASSIC" ]; then
        :
    else
        validate_color_name "$_argU" || return 1
        _val=$(get_var "$_argU")
        eval "$_outvar=\$_val"
    fi
}


set_colors () {
    # Help
    if [ -z "$1" ]; then
        display_help
        return
    fi
    case "$1" in
        *help*) display_help; return ;;
    esac

    # Reset to defaults
    if [ "$1" = "reset" ]; then
        my_ps1_colors
        if [ -f "$LOCAL_PS1_COLORS_CONFIG" ] && [ "$2" != "init" ]; then
            . "$LOCAL_PS1_COLORS_CONFIG"
        fi
        COLOR_1=$DEFAULT_COLOR_1 ; COLOR_2=$DEFAULT_COLOR_2
        COLOR_3=$DEFAULT_COLOR_3 ; COLOR_4=$DEFAULT_COLOR_4
        LEADING_SPACE=$DEFAULT_LEADING_SPACE
        TRAILING_SPACE=$DEFAULT_TRAILING_SPACE
        MIDDLE_DOT=$DEFAULT_MIDDLE_DOT
        BOLD=$DEFAULT_BOLD
        set_PS1_colors
        return
    fi

    # List
    if [ "$1" = "list" ]; then
        case "$2" in
            colors)  list_colors  "$3"; return ;;
            schemas) list_schemas "$3"; return ;;
            *)
                printf '%b\n' "\033[01;31m[Error]\033[0m Wrong option for the 'list' command ($2). Available: colors, schemas"
                return 1
                ;;
        esac
    fi

    # Save
    if [ "$1" = "save" ]; then
        save_PS1_colors
        return
    fi

    ### Color 1 (text)
    resolve_color "$1" COLOR_1 "$DEFAULT_COLOR_1" || return 1

    ### Color 2 (bg)
    if [ -n "$2" ]; then
        resolve_color "$2" COLOR_2 "$DEFAULT_COLOR_2" || return 1
        LEADING_SPACE=" "; TRAILING_SPACE=" "
        C2U=$(to_upper "$2")
        if [ "$C2U" = "256" ] || [ "$C2U" = "NONE_COLOR" ]; then
            TRAILING_SPACE=$DEFAULT_TRAILING_SPACE
        fi
    else
        COLOR_2=$DEFAULT_COLOR_2
        LEADING_SPACE=$DEFAULT_LEADING_SPACE
        TRAILING_SPACE=$DEFAULT_TRAILING_SPACE
    fi

    ### Color 3 (text)
    if [ -n "$3" ]; then
        resolve_color "$3" COLOR_3 "$DEFAULT_COLOR_3" || return 1
    else
        COLOR_3=$DEFAULT_COLOR_3
    fi

    ### Color 4 (bg)
    if [ -n "$4" ]; then
        resolve_color "$4" COLOR_4 "$DEFAULT_COLOR_4" || return 1
    else
        COLOR_4=$DEFAULT_COLOR_4
    fi

    # Last argument
    LAST=""
    for a in "$@"; do LAST=$a; done
    LAST_U=$(to_upper "$LAST")

    if [ "$LAST_U" = "CLASSIC" ]; then
        set_PS1_colors_classic
    else
        set_PS1_colors
    fi
}


### Set PS1 colors
if [ "$(id -u)" -eq 0 ]; then
    set_colors RED NONE_COLOR CHOCO NONE_COLOR classic
else
    set_colors reset
fi


#############################
# PREDEFINED SCHEMAS

red       () { set_colors RED         NONE_COLOR CHOCO     NONE_COLOR "$1" ; }
gold      () { set_colors GOLD        NONE_COLOR TEA       NONE_COLOR "$1" ; }
orange    () { set_colors ORANGE      NONE_COLOR _         _          "$1" ; }
amber     () { set_colors AMBER       NONE_COLOR _         _          "$1" ; }
yellow    () { set_colors YELLOW_LIGHT NONE_COLOR _        _          "$1" ; }
green     () { set_colors GREEN       NONE_COLOR _         _          "$1" ; }
pista     () { set_colors PISTACHIO   NONE_COLOR CHOCO     NONE_COLOR "$1" ; }
jade      () { set_colors JADE        NONE_COLOR ALMOND    NONE_COLOR "$1" ; }
tea       () { set_colors TEA         NONE_COLOR _         _          "$1" ; }
azure     () { set_colors AZURE_LIGHT NONE_COLOR _         _          "$1" ; }
blue      () { set_colors BLUE_PALE   NONE_COLOR CHOCO     NONE_COLOR "$1" ; }
aqua      () { set_colors AQUA        NONE_COLOR _         _          "$1" ; }
choco     () { set_colors CHOCO       NONE_COLOR _         _          "$1" ; }
almond    () { set_colors ALMOND      NONE_COLOR BLUE_PALE NONE_COLOR "$1" ; }
lavender  () { set_colors LAVENDER    NONE_COLOR _         _          "$1" ; }
indigo    () { set_colors INDIGO      NONE_COLOR _         _          "$1" ; }
violet    () { set_colors VIOLET      NONE_COLOR _         _          "$1" ; }
pink      () { set_colors PINK        NONE_COLOR _         _          "$1" ; }
taffy     () { set_colors TAFFY       NONE_COLOR _         _          "$1" ; }
magenta   () { set_colors MAGENTA     NONE_COLOR _         _          "$1" ; }
rose      () { set_colors ROSE        NONE_COLOR _         _          "$1" ; }
salmon    () { set_colors SALMON      NONE_COLOR _         _          "$1" ; }

# Backgrounds
red_b      () { set_colors WHITE  RED          _ _ "$1" ; }
orange_b   () { set_colors BLACK  ORANGE       _ _ "$1" ; }
orange_w   () { set_colors WHITE  ORANGE       _ _ "$1" ; }
gold_b     () { set_colors BLACK  GOLD         _ _ "$1" ; }
amber_b    () { set_colors BLACK  AMBER        _ _ "$1" ; }
yellow_b   () { set_colors BLACK  YELLOW_LIGHT _ _ "$1" ; }
green_b    () { set_colors BLACK  PISTACHIO    _ _ "$1" ; }
jade_b     () { set_colors BLACK  JADE         _ _ "$1" ; }
tea_b      () { set_colors BLACK  TEA          _ _ "$1" ; }
choco_w    () { set_colors 253    CHOCO        _ _ "$1" ; }
choco_b    () { set_colors BLACK  CHOCO        _ _ "$1" ; }
almond_w   () { set_colors 253    ALMOND       _ _ "$1" ; }
almond_b   () { set_colors BLACK  ALMOND       _ _ "$1" ; }
violet_b   () { set_colors BLACK  VIOLET       _ _ "$1" ; }
violet_w   () { set_colors 254    99           _ _ "$1" ; }
indigo_b   () { set_colors BLACK  INDIGO       _ _ "$1" ; }
lavender_b () { set_colors BLACK  LAVENDER     _ _ "$1" ; }
azure_b    () { set_colors BLACK  AZURE_LIGHT  _ _ "$1" ; }
cyan_w     () { set_colors 255    CYAN         _ _ "$1" ; }
blue_b     () { set_colors BLACK  BLUE_PALE    _ _ "$1" ; }
aqua_b     () { set_colors BLACK  AQUA         _ _ "$1" ; }
purple_w   () { set_colors 254    PURPLE       _ _ "$1" ; }
taffy_b    () { set_colors BLACK  TAFFY        _ _ "$1" ; }
pink_b     () { set_colors BLACK  PINK         _ _ "$1" ; }
pink_w     () { set_colors 255    PINK         _ _ "$1" ; }
magenta_b  () { set_colors BLACK  MAGENTA_LIGHT _ _ "$1" ; }
rose_b     () { set_colors BLACK  ROSE         _ _ "$1" ; }
rose_w     () { set_colors 255    ROSE         _ _ "$1" ; }
salmon_b   () { set_colors BLACK  SALMON       _ _ "$1" ; }

# Path
dir_choco    () { set_colors _ _ CHOCO        NONE_COLOR "$1" ; }
dir_almond   () { set_colors _ _ ALMOND       NONE_COLOR "$1" ; }
dir_salmon   () { set_colors _ _ SALMON       NONE_COLOR "$1" ; }
dir_violet   () { set_colors _ _ VIOLET       NONE_COLOR "$1" ; }
dir_indigo   () { set_colors _ _ INDIGO       NONE_COLOR "$1" ; }
dir_lavender () { set_colors _ _ LAVENDER     NONE_COLOR "$1" ; }
dir_blue     () { set_colors _ _ BLUE_PALE    NONE_COLOR "$1" ; }
dir_aqua     () { set_colors _ _ AQUA         NONE_COLOR "$1" ; }
dir_gold     () { set_colors _ _ GOLD         NONE_COLOR "$1" ; }
dir_yellow   () { set_colors _ _ YELLOW_LIGHT NONE_COLOR "$1" ; }
dir_pista    () { set_colors _ _ PISTACHIO    NONE_COLOR "$1" ; }
dir_jade     () { set_colors _ _ JADE         NONE_COLOR "$1" ; }
dir_tea      () { set_colors _ _ TEA          NONE_COLOR "$1" ; }

SCHEMA_NAMES="red gold orange amber yellow green pista jade tea azure blue aqua \
choco almond lavender indigo violet pink taffy magenta rose salmon \
red_b orange_b orange_w gold_b amber_b yellow_b green_b jade_b tea_b choco_w \
choco_b almond_w almond_b violet_b violet_w indigo_b lavender_b azure_b cyan_w \
blue_b aqua_b purple_w taffy_b pink_b pink_w magenta_b rose_b rose_w salmon_b \
dir_choco dir_almond dir_salmon dir_violet dir_indigo dir_lavender dir_blue \
dir_aqua dir_gold dir_yellow dir_pista dir_jade dir_tea"

