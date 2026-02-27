#!/bin/bash

# User-level lid close monitor for Omarchy
# This script monitors lid events and suspends the system even when docked

# Check if we're already running
if pgrep -f "lid-monitor.sh" | grep -v $$ > /dev/null; then
    exit 0
fi

# Function to check lid state
check_lid_state() {
    # Try different lid state detection methods
    if [ -f /proc/acpi/button/lid/LID/state ]; then
        grep -q "closed" /proc/acpi/button/lid/LID/state
    elif [ -d /sys/class/power_supply ]; then
        # Look for lid device in power_supply
        for device in /sys/class/power_supply/*/type; do
            if [ -f "$device" ] && grep -q "Lid" "$device" 2>/dev/null; then
                state_file="${device%/type}/state"
                if [ -f "$state_file" ]; then
                    grep -q "closed" "$state_file"
                    return $?
                fi
            fi
        done
        return 1
    else
        return 1
    fi
}

# Monitor lid events using systemd-logind
journalctl -f -u systemd-logind | while read line; do
    if echo "$line" | grep -q "Lid closed"; then
        # Small delay to avoid accidental suspends
        sleep 3
        
        # Double-check if lid is still closed
        if check_lid_state; then
            # Suspend regardless of external monitor state
            systemctl suspend
        fi
    fi
done