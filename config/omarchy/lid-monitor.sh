#!/bin/bash

# User-level lid close monitor for Omarchy
# This script monitors lid events and suspends the system even when docked

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/lid-monitor.pid"

# Check if already running via PID file
if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    exit 0
fi
echo $$ > "$PIDFILE"
trap 'rm -f "$PIDFILE"' EXIT

# Function to check lid state
check_lid_state() {
    if [ -f /proc/acpi/button/lid/LID/state ]; then
        grep -q "closed" /proc/acpi/button/lid/LID/state
    elif [ -d /sys/class/power_supply ]; then
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

# Monitor lid state by polling /proc/acpi/button/lid/LID/state
while true; do
    if check_lid_state; then
        # Small delay to avoid accidental suspends
        sleep 3

        # Double-check if lid is still closed
        if check_lid_state; then
            systemctl suspend
            # After resume, wait for lid to open before re-arming
            while check_lid_state; do
                sleep 1
            done
        fi
    fi
    sleep 1
done