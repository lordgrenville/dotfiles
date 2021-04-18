#!/bin/bash

# Get percentage. (The +0 makes awk convert the string 95% into the int 95!!)
VALUE=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | awk '/percentage/ {print $2+0}')

# Get charging state
STATE=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | awk '/state/ {print $2}')

# Calculate colour
if [[ "$STATE" == "charging" ]]; then
    COLOUR="orange"
else
    if [[ "$VALUE" -gt "10" ]]; then
        COLOUR="green"
    else
        COLOUR="red"
    fi
fi

# Format and print
echo "Battery: <fc=$COLOUR>$VALUE</fc>%"
exit 0
