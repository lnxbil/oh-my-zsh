function battery_prompt_echo
{
    echo "${ZSH_THEME_BATTERY_PROMPT_PREFIX}$1${ZSH_THEME_BATTERY_PROMPT_SUFFIX}"
}

function battery_set_no_battery_present_prompt
{
    error_msg='no battery'
    function battery_pct_remaining() { battery_prompt_echo $error_msg }
    function battery_time_remaining() { battery_prompt_echo $error_msg }
    function battery_pct_prompt() { battery_prompt_echo '' }
}

function battery_present_prompt_common
{
    function battery_pct_prompt() {
        b=$(battery_pct_remaining)
        if [ $b -gt 50 ] ; then
            color='green'
        elif [ $b -gt 20 ] ; then
            color='yellow'
        else
            color='red'
        fi
        battery_prompt_echo "%{$fg[$color]%}[$(battery_pct_remaining)%%]%{$reset_color%}"
    }
}

case $OSTYPE in

    linux*)
        # Output of 'acpi'
        # Discharching Output :  'Battery 0: Discharging, 97%, 06:40:02 remaining'
        # Charging Output     :  'Battery 0: Charging, 97%, 02:00:00 until charged'
        # No Battery Output   :  ''

        if [[ $(LANG=C acpi 2&>/dev/null | grep -c '^Battery.*harging') -gt 0 ]] ; then
            function battery_pct_remaining() { battery_prompt_echo "$(acpi | cut -f2 -d ',' | tr -cd '[:digit:]')" }
            function battery_time_remaining() { battery_prompt_echo $(acpi | cut -f3 -d ',') }
            function battery_discharging() { battery_prompt_echo $(LANG=C acpi 2&>/dev/null | grep -c 'Discharging') }
            battery_present_prompt_common
        else
            battery_set_no_battery_present_prompt
        fi
        ;;

    darwin*)
        # Output of 'pmset -g batt'
        # Discharching Output :  'Currently drawing from 'Battery Power'
        #                         -InternalBattery-0     53%; discharging; 2:24 remaining'
        # Charging Output     :  'Currently drawing from 'AC Power'
        #                         -InternalBattery-0     52%; charging; 1:45 remaining'
        # No Battery Output   :  'Currently drawing from 'AC Power''
        #
        if [ $(pmset -g batt | grep -c InternalBatt) -gt 0 ]; then
            # using pmset for this, maybe there is a more intelligent way, but this works
            function battery_pct_remaining() { battery_prompt_echo "${$(LANG=C pmset -g batt | grep InternalBattery | cut -d'%' -f 1)##*[\!0-9]}"}
            function battery_time_remaining() { battery_prompt_echo $(LANG=C pmset -g batt | grep InternalBattery | cut -d';' -f 3 | cut -d' ' -f2) }
            function battery_discharging() { battery_prompt_echo $(LANG=C pmset -g batt | grep InternalBattery | grep -c discharging) }
            battery_present_prompt_common
        else
            battery_set_no_battery_present_prompt
        fi
        ;;

    *)
        echo "Your system is not yet supported by the plugin battery."
        echo "Please disable this plugin"
        ;;
esac
