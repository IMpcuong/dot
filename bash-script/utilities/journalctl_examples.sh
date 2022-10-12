#!/bin/bash

# This is some utility examples of `journalctl` command:
# Resource: https://www.golinuxcloud.com/view-logs-using-journalctl-filter-journald/

# Exp1: Basic view of logs type as root:
journalctl # --> With the structure is similar to one used in `/var/log/messages/`.

# Exp2: View journal logs runtime or realtime attendance:
journalctl -f # --> Same as: `tail -f`.

# Exp3: List of all Linux boot messages using numerical identifiers:
journalctl --list-boots
journalctl -b 0 # --> Based on the preceding output for Linux boot messages, we can view any opf these files by passing the offset of the file.

# Exp4: Filter `systemd` logs based on timestamp:
journalctl -S today
journalctl --since today
journalctl --since yesterday --until now

journalctl --since "2019-08-26 15:00:00"
journalctl --since "2019-08-26 15:00:00" --until "2019-08-27 15:00:00"

# Exp5: Filter messages based on unit file (eg: `systemd-journald`):
journalctl -u systemd-journald
journalctl --unit systemd-journald

journalctl -s sshd.service
journalctl _SYSTEMD_UNIT=sshd.service

# Exp6: Filter logs based on binary file:
journalctl /sbin/sshd

# Exp7: Filter logs with more detail:
journalctl -u sshd.service -x

# Exp8: Filter logs based on ProcessID/UserID (PID/UID):
journalctl _PID=23456
journalctl _UID=1001

# Exp9: Filter logs based on priority:
# Log levels matrix := `["emerg" (0), "alert" (1), "crit" (2), "err" (3), "warning" (4), "notice" (5), "info" (6), "debug" (7)]`.
journalctl -p 0
journalctl -p 0..2

# Exp10: Filter kernel messages:
journalctl -k
# `_TRANSPORT` := `["driver", "syslog", "journal", "stdout", "kernel"]`.
journalctl _TRANSPORT=kernel

# Exp11: Check the total disk or memory usage by journal logs:
journalctl --disk-usage

# Exp12: Perform journal log files cleanup:
journalctl --vacuum-size=200M

# Exp13: View logs in verbose mode:
journalctl -o verbose
