#!/usr/bin/env bash
#/ Usage: charger-watch.test.sh [--help]
#/
#/ Exercise charger-watch against a fake uevent stream.
set -euo pipefail
IFS=$'\n\t'

usage() { grep '^#/' "${0}" | cut --characters=4-; exit 0; }
case "${1:-}" in
    --help | -h) usage ;;
    '') ;;
    *)
        printf '[ERROR]   unexpected argument: %s\n' "${1}" >&2
        exit 2
        ;;
esac

here="$(dirname -- "$(readlink --canonicalize -- "${0}")")"
tmp="$(mktemp --directory)"
cleanup() {
    local result=$?
    rm --recursive --force -- "${tmp}" 2>/dev/null || true
    exit "${result}"
}
trap cleanup EXIT

# The stream udevadm --property prints: the adapter reporting itself online (a
# plug, the one event that restarts the check), a battery change (a nudge), and
# the adapter reporting itself offline (a nudge too - the unplug is the check's
# to notice, and it needs no marker to see it).
cat >"${tmp}/udevadm" <<'STUB'
#!/bin/sh
printf 'KERNEL[1.0] change   /devices/pci0000:00/ACPI0003:00/power_supply/AC (power_supply)\n'
printf 'ACTION=change\nDEVTYPE=power_supply\nPOWER_SUPPLY_NAME=AC\n'
printf 'POWER_SUPPLY_TYPE=Mains\nPOWER_SUPPLY_ONLINE=1\n\n'
printf 'KERNEL[2.0] change   /devices/pci0000:00/PNP0C0A:00/power_supply/BAT0 (power_supply)\n'
printf 'ACTION=change\nDEVTYPE=power_supply\nPOWER_SUPPLY_NAME=BAT0\n'
printf 'POWER_SUPPLY_TYPE=Battery\nPOWER_SUPPLY_STATUS=Charging\n\n'
printf 'KERNEL[3.0] change   /devices/pci0000:00/ACPI0003:00/power_supply/AC (power_supply)\n'
printf 'ACTION=change\nDEVTYPE=power_supply\nPOWER_SUPPLY_NAME=AC\n'
printf 'POWER_SUPPLY_TYPE=Mains\nPOWER_SUPPLY_ONLINE=0\n\n'
STUB
chmod +x "${tmp}/udevadm"

cat >"${tmp}/systemctl" <<'STUB'
#!/bin/sh
printf '%s\n' "$*" >>"${SYSTEMCTL_LOG}"
STUB
chmod +x "${tmp}/systemctl"

SYSTEMCTL_LOG="${tmp}/systemctl.log"
export SYSTEMCTL_LOG
: >"${SYSTEMCTL_LOG}"

CHARGER_WATCH_UDEVADM="${tmp}/udevadm" \
    CHARGER_WATCH_SYSTEMCTL="${tmp}/systemctl" \
    CHARGER_WATCH_UNIT=charger-check.service \
    CHARGER_WATCH_PLUG="${tmp}/plug" \
    "${here}/charger-watch"

# A plug supersedes whatever run is in flight; every other event only nudges,
# which is a no-op while a run is already going and so folds a burst into it.
[ "$(grep --count -- '^--user restart --no-block charger-check.service$' \
    "${SYSTEMCTL_LOG}")" = 1 ] ||
    { printf '[FAIL]    the plug did not restart the check\n' >&2; exit 1; }
printf '[OK]      a plug restarts the check\n'

[ "$(grep --count -- '^--user start --no-block charger-check.service$' \
    "${SYSTEMCTL_LOG}")" = 2 ] ||
    { printf '[FAIL]    a battery change and an unplug did not start the check\n' >&2; exit 1; }
printf '[OK]      a battery change and an unplug start it\n'

# The marker is what stops a cable that was out and back within one run from
# going unannounced.
[ -e "${tmp}/plug" ] ||
    { printf '[FAIL]    the plug left no marker\n' >&2; exit 1; }
printf '[OK]      the plug is recorded for the check to read\n'

printf 'all charger-watch cases pass\n'
