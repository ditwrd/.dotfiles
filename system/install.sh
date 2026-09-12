#!/usr/bin/env bash
#/ Usage: system/install.sh [--help]
#/
#/ Install the AC power-profile automation.  Idempotent: re-run after any edit.
set -euo pipefail
IFS=$'\n\t'

usage() { grep '^#/' "${0}" | cut --characters=4-; exit 0; }

error() { printf '[ERROR]   %s\n' "${*}" >&2; }

case "${1:-}" in
    --help | -h) usage ;;
    '') ;;
    *)
        error "unexpected argument: ${1}"
        exit 2
        ;;
esac

[ "$(id --user)" -eq 0 ] || exec sudo -- "${0}" "${@}"

here="$(dirname -- "$(readlink --canonicalize -- "${0}")")"

# -D has no long form in GNU install.
install -D --mode=0755 "${here}/power-profile-auto" /usr/local/bin/power-profile-auto
install -D --mode=0644 "${here}/power-profile-auto.service" \
    /etc/systemd/system/power-profile-auto.service
install -D --mode=0644 "${here}/60-power-profile-auto.rules" \
    /etc/udev/rules.d/60-power-profile-auto.rules

systemctl daemon-reload
systemctl enable --now power-profile-auto.service
udevadm control --reload

printf 'profile: %s\n' "$(/usr/bin/powerprofilesctl get)"
