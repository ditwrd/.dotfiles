#!/usr/bin/env bash
#/ Usage: power-profile-auto.test.sh [--help]
#/
#/ Exercise both branches of power-profile-auto against a fake sysfs tree and a
#/ stub powerprofilesctl, so that no profile on the running system is touched.
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

# Records every call, and fails on demand, so that "was not called at all" is as
# observable as "was called with this profile".
cat >"${tmp}/powerprofilesctl" <<'STUB'
#!/bin/sh
printf '%s\n' "$*" >>"${PROFILECTL_LOG}"
[ -z "${PROFILECTL_FAIL:-}" ] || exit 1
STUB
chmod +x "${tmp}/powerprofilesctl"

# sys <ac_online>|"" - rebuild the fake tree.  Without an AC adapter argument the
# tree holds only the battery, as on a machine with no mains supply.
sys() {
    local ac_online="${1:-}"
    rm --recursive --force -- "${tmp}/sys"
    mkdir --parents "${tmp}/sys/BAT0"
    printf 'Battery\n' >"${tmp}/sys/BAT0/type"
    printf '52\n'      >"${tmp}/sys/BAT0/capacity"
    [ -n "${ac_online}" ] || return 0
    mkdir --parents "${tmp}/sys/AC"
    printf 'Mains\n'             >"${tmp}/sys/AC/type"
    printf '%s\n' "${ac_online}" >"${tmp}/sys/AC/online"
}

# run [preexisting state] [fail] - invoke the subject; leaves rc and out set.
run() {
    local existing="${1:-}" fail="${2:-}"
    rm --force -- "${tmp}/ctl.log" "${tmp}/state"
    : >"${tmp}/ctl.log"
    [ -z "${existing}" ] || printf '%s\n' "${existing}" >"${tmp}/state"
    set +e
    out="$(PROFILECTL_LOG="${tmp}/ctl.log" PROFILECTL_FAIL="${fail}" \
        POWER_PROFILECTL="${tmp}/powerprofilesctl" \
        POWER_PROFILE_STATE="${tmp}/state" POWER_SUPPLY_SYSFS="${tmp}/sys" \
        "${here}/power-profile-auto" 2>&1)"
    rc=$?
    set -e
}

# check <exit> <calls, one per line> <state> <substring> <description>
check() {
    local want_rc="${1}" want_ctl="${2}" want_state="${3}" substring="${4}"
    local description="${5}" got_ctl got_state='absent'
    got_ctl="$(cat "${tmp}/ctl.log")"
    [ ! -e "${tmp}/state" ] || got_state="$(cat "${tmp}/state")"
    case "${out}" in
        *"${substring}"*) ;;
        *)
            printf '[FAIL]    %s: output=%s\n' "${description}" "${out}" >&2
            exit 1
            ;;
    esac
    if [ "${rc}" != "${want_rc}" ] || [ "${got_ctl}" != "${want_ctl}" ] ||
        [ "${got_state}" != "${want_state}" ]; then
        printf '[FAIL]    %s: exit=%s want %s; calls=[%s] want [%s]; state=%s want %s\n' \
            "${description}" "${rc}" "${want_rc}" "${got_ctl}" "${want_ctl}" \
            "${got_state}" "${want_state}" >&2
        exit 1
    fi
    printf '[OK]      %s\n' "${description}"
}

sys 1
run
check 0 "set performance" 1 "" "plugged in selects performance"

sys 0
run
check 0 "set power-saver" 0 "" "on battery selects power-saver"

# The profile is set once per adapter change, so a profile chosen by hand
# survives every later event for the same state.
sys 1
run 1
check 0 "" 1 "" "a repeat for the same AC state calls nothing"

sys 0
run '' 1
check 1 "set power-saver" absent "powerprofilesctl set power-saver failed" \
    "a failed set is an error, and is not remembered"

sys
run
check 0 "" absent "" "a machine with no AC adapter is left alone"

printf 'all power-profile-auto cases pass\n'
