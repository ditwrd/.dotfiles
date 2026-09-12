#!/usr/bin/env bash
#/ Usage: charger-check.test.sh [--help]
#/
#/ Exercise every verdict of charger-check against a fake sysfs tree.
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
writer=''

# Keep the exit status of the run: exiting 0 here would turn a failing case into
# a passing test.
cleanup() {
    local result=$?
    rm --recursive --force -- "${tmp}" 2>/dev/null || true
    if [ -n "${writer}" ]; then kill "${writer}" 2>/dev/null || true; fi
    exit "${result}"
}
trap cleanup EXIT

cat >"${tmp}/notify" <<'STUB'
#!/bin/sh
printf '%s\n' "$*" >>"${NOTIFY_LOG}"
STUB
chmod +x "${tmp}/notify"

# fake <status> <energy_now> <capacity> [cap] [ac_online]
fake() {
    local status="${1}" energy="${2}" capacity="${3}"
    local cap="${4:-85}" ac_online="${5:-1}"
    rm --recursive --force -- "${tmp}/sys"
    mkdir --parents "${tmp}/sys/AC" "${tmp}/sys/BAT0"
    printf 'Mains\n'      >"${tmp}/sys/AC/type"
    printf '%s\n' "${ac_online}" >"${tmp}/sys/AC/online"
    printf 'Battery\n'    >"${tmp}/sys/BAT0/type"
    printf '%s\n' "${status}"    >"${tmp}/sys/BAT0/status"
    printf '%s\n' "${energy}"    >"${tmp}/sys/BAT0/energy_now"
    printf '%s\n' "${capacity}"  >"${tmp}/sys/BAT0/capacity"
    printf '%s\n' "${cap}"       >"${tmp}/sys/BAT0/charge_control_end_threshold"
}

# ramp <delta> - move the fake battery's energy by <delta> uWh every 0.2 s, so
# that a sampled trend has something to measure.  Run it in the background.
ramp() {
    local delta="${1}" v
    while :; do
        v="$(cat "${tmp}/sys/BAT0/energy_now")"
        printf '%s\n' "$((v + delta))" >"${tmp}/sys/BAT0/energy_now"
        sleep 0.2
    done
}

# check <expected exit> <substring> <description> [preexisting state]
check() {
    local want="${1}" substring="${2}" description="${3}"
    local existing="${4:-}" out rc
    rm --force -- "${tmp}/state"
    [ -z "${existing}" ] || printf '%s\n' "${existing}" >"${tmp}/state"
    set +e
    out="$(NOTIFY_LOG="${tmp}/notify.log" \
        CHARGER_CHECK_NOTIFY="${tmp}/notify" CHARGER_CHECK_STATE="${tmp}/state" \
        CHARGER_CHECK_PLUG="${tmp}/plug" \
        CHARGER_CHECK_SETTLE=1 \
        POWER_SUPPLY_SYSFS="${tmp}/sys" "${here}/charger-check" 2>&1)"
    rc=$?
    set -e
    case "${out}" in
        *"${substring}"*) ;;
        *)
            printf '[FAIL]    %s: exit=%s output=%s\n' "${description}" "${rc}" "${out}" >&2
            exit 1
            ;;
    esac
    if [ "${rc}" != "${want}" ]; then
        printf '[FAIL]    %s: exit=%s, want %s\n' "${description}" "${rc}" "${want}" >&2
        exit 1
    fi
    printf '[OK]      %s\n' "${description}"
}

# Unplugged from a cold start: no known previous state, so there is no
# transition to announce.
fake Discharging 21000000 47 85 0
check 2 "on battery" "a cold unplugged start is not reported"

# Charging: reported without sampling.
fake Charging 21000000 47
check 0 "charging" "charging is recognised"

# Falling energy with a charger attached: the silent drain this exists for.
fake "Not charging" 21000000 47
ramp -10000 &
writer=$!
sleep 0.5
rm --force -- "${tmp}/notify.log"
check 1 "DRAINING" "plugged in but draining is reported"
[ "$(wc --lines <"${tmp}/notify.log")" = 1 ] ||
    { printf '[FAIL]    draining did not alert\n' >&2; exit 1; }
printf '[OK]      draining raised one notification\n'
grep --quiet "discharging at" "${tmp}/notify.log" ||
    { printf '[FAIL]    alert body lacks the measured rate\n' >&2; exit 1; }
# The counter can only see whole steps, so the figure it yields is a floor and
# has to say so; the reading is otherwise read as the rate.
grep --quiet "W or more\\." "${tmp}/notify.log" ||
    { printf '[FAIL]    the counter reading is not labelled a floor\n' >&2; exit 1; }
printf '[OK]      alert body carries the measured rate\n'

# When the EC reports a power figure, that is the one quoted: the energy
# counter steps too coarsely to time a 10 s window accurately.
printf '12300000\n' >"${tmp}/sys/BAT0/power_now"
rm --force -- "${tmp}/notify.log"
check 1 "DRAINING" "the EC power figure is quoted"
grep --quiet "discharging at 12.30 W\\." "${tmp}/notify.log" ||
    { printf '[FAIL]    the quoted rate is not the EC power figure\n' >&2; exit 1; }
printf '[OK]      the EC power figure is quoted when there is one\n'
rm --force -- "${tmp}/sys/BAT0/power_now"

# A repeat inside the repeat window must stay quiet.
check 1 "DRAINING" "draining is still reported" "$(date +%s) 1"
[ "$(wc --lines <"${tmp}/notify.log")" = 1 ] ||
    { printf '[FAIL]    notification was not rate limited\n' >&2; exit 1; }
printf '[OK]      repeat alert is rate limited\n'
kill "${writer}" 2>/dev/null || true
writer=''

# A notification that cannot be delivered must not consume the repeat window:
# one failed send would otherwise silence the warning for the whole window.
fake "Not charging" 21000000 47
ramp -10000 &
writer=$!
sleep 0.5
printf '#!/bin/sh\nexit 1\n' >"${tmp}/notify"
rm --force -- "${tmp}/state" "${tmp}/notify.log"
set +e
NOTIFY_LOG="${tmp}/notify.log" \
    CHARGER_CHECK_NOTIFY="${tmp}/notify" CHARGER_CHECK_STATE="${tmp}/state" \
    CHARGER_CHECK_PLUG="${tmp}/plug" \
    CHARGER_CHECK_SETTLE=1 \
    POWER_SUPPLY_SYSFS="${tmp}/sys" "${here}/charger-check" >/dev/null 2>&1
rc=$?
set -e
[ "${rc}" = 1 ] ||
    { printf '[FAIL]    undeliverable alert case: exit=%s, want 1\n' "${rc}" >&2; exit 1; }
[ "$(cut --delimiter=' ' --fields=1 "${tmp}/state" 2>/dev/null)" = 0 ] ||
    { printf '[FAIL]    failed notification armed the repeat window\n' >&2; exit 1; }
printf '[OK]      failed notification leaves the repeat window open\n'
kill "${writer}" 2>/dev/null || true
writer=''

cat >"${tmp}/notify" <<'STUB'
#!/bin/sh
printf '%s\n' "$*" >>"${NOTIFY_LOG}"
STUB
chmod +x "${tmp}/notify"

# Flat energy below the cap: the charger is connected and the battery is not
# being charged - there is no "holding" it can be doing short of the cap.
fake "Not charging" 21000000 47
rm --force -- "${tmp}/notify.log"
check 1 "NOT CHARGING" "a charger holding a battery below the cap is a fault"
[ "$(wc --lines <"${tmp}/notify.log")" = 1 ] ||
    { printf '[FAIL]    not charging did not alert\n' >&2; exit 1; }
printf '[OK]      holding below the cap raised one notification\n'

# That fault no longer waits on the counter, which is what made it late: a 1 W
# drain steps the 0.01 Wh counter once a minute, so waiting for a step is
# waiting on nothing.  The EC's own figure is 0 W in this state and tens of
# watts on a working charger, so the end of a short window answers it - and the
# figure is what the notice has to carry, since "0 W is going in" is the claim.
fake "Not charging" 21000000 47
printf '0\n' >"${tmp}/sys/BAT0/power_now"
printf '0 0\n' >"${tmp}/state"
rm --force -- "${tmp}/notify.log"
begun="$(date +%s%N)"
set +e
NOTIFY_LOG="${tmp}/notify.log" \
    CHARGER_CHECK_NOTIFY="${tmp}/notify" CHARGER_CHECK_STATE="${tmp}/state" \
    CHARGER_CHECK_PLUG="${tmp}/plug" CHARGER_CHECK_SETTLE=1 \
    POWER_SUPPLY_SYSFS="${tmp}/sys" "${here}/charger-check" >/dev/null 2>&1
rc=$?
set -e
elapsed_ms=$(( ($(date +%s%N) - begun) / 1000000 ))
[ "${rc}" = 1 ] ||
    { printf '[FAIL]    a charger putting nothing in: exit=%s, want 1\n' "${rc}" >&2; exit 1; }
[ "${elapsed_ms}" -lt 1500 ] ||
    { printf '[FAIL]    the flat fault waited out the window (%s ms)\n' "${elapsed_ms}" >&2; exit 1; }
grep --quiet "only 0.00 W is going in" "${tmp}/notify.log" ||
    { printf '[FAIL]    the fault does not carry what is going in\n' >&2; exit 1; }
printf '[OK]      a charger putting nothing in is answered on the EC figure (%s ms)\n' "${elapsed_ms}"
rm --force -- "${tmp}/sys/BAT0/power_now"

# Flat energy at the cap: correct behaviour, stay quiet.
fake "Not charging" 21000000 85
rm --force -- "${tmp}/notify.log"
check 0 "holding at cap" "holding at the cap is not reported"
[ ! -s "${tmp}/notify.log" ] ||
    { printf '[FAIL]    holding at the cap alerted\n' >&2; exit 1; }
printf '[OK]      holding at the cap stays quiet\n'

# A plug is the moment the verdict was asked for, so a good verdict is
# announced on it - with the rate it measured, not with the EC's status word.
fake Charging 21000000 47
ramp 500 &
writer=$!
sleep 0.5
rm --force -- "${tmp}/notify.log"
check 0 "CHARGING" "a charging plug is announced" "0 0"
# The rate comes from the sampled trend rather than the EC's word, so the plug
# is acknowledged while the sampling runs and the verdict replaces it.
[ "$(wc --lines <"${tmp}/notify.log")" = 2 ] ||
    { printf '[FAIL]    a charging plug was not acknowledged and announced\n' >&2; exit 1; }
grep --quiet "Checking the charger" "${tmp}/notify.log" ||
    { printf '[FAIL]    a charging plug was not acknowledged at once\n' >&2; exit 1; }
grep --quiet "Charging at" "${tmp}/notify.log" ||
    { printf '[FAIL]    charging announcement lacks the measured rate\n' >&2; exit 1; }
grep --quiet -- "--urgency=normal" "${tmp}/notify.log" ||
    { printf '[FAIL]    good news went out with critical urgency\n' >&2; exit 1; }
printf '[OK]      a charging plug announces the measured rate\n'
kill "${writer}" 2>/dev/null || true
writer=''

# A rise is proof too, and the rate comes from the EC's power figure while it
# reports one, so a charging plug is answered on the first counter step instead
# of at the window's end.  This is the case a plug is actually asked about.
fake Charging 21000000 47
printf '12300000\n' >"${tmp}/sys/BAT0/power_now"
ramp 500 &
writer=$!
sleep 0.5
printf '0 0\n' >"${tmp}/state"
rm --force -- "${tmp}/notify.log"
begun="$(date +%s%N)"
set +e
NOTIFY_LOG="${tmp}/notify.log" \
    CHARGER_CHECK_NOTIFY="${tmp}/notify" CHARGER_CHECK_STATE="${tmp}/state" \
    CHARGER_CHECK_PLUG="${tmp}/plug" \
    CHARGER_CHECK_SETTLE=1 \
    POWER_SUPPLY_SYSFS="${tmp}/sys" "${here}/charger-check" >/dev/null 2>&1
set -e
elapsed_ms=$(( ($(date +%s%N) - begun) / 1000000 ))
[ "${elapsed_ms}" -lt 3000 ] ||
    { printf '[FAIL]    the charge verdict waited out the window (%s ms)\n' "${elapsed_ms}" >&2; exit 1; }
grep --quiet "Charging at 12.30 W" "${tmp}/notify.log" ||
    { printf '[FAIL]    the charge rate came from the counter, not the EC figure\n' >&2; exit 1; }
printf '[OK]      a charging plug is answered on the first step (%s ms)\n' "${elapsed_ms}"
kill "${writer}" 2>/dev/null || true
writer=''
rm --force -- "${tmp}/sys/BAT0/power_now"

# ...and on the same plug, a charger that does nothing is announced at once
# rather than waiting out the repeat window.
fake "Not charging" 21000000 47
ramp -500 &
writer=$!
sleep 0.5
rm --force -- "${tmp}/notify.log"
check 1 "DRAINING" "a draining plug is announced" "0 0"
# The verdict takes a sampled second or three, so the plug is acknowledged as
# soon as it is seen and the fault replaces that notice under the same tag.
[ "$(wc --lines <"${tmp}/notify.log")" = 2 ] ||
    { printf '[FAIL]    a draining plug was not acknowledged and announced\n' >&2; exit 1; }
grep --quiet "Checking the charger" "${tmp}/notify.log" ||
    { printf '[FAIL]    a draining plug was not acknowledged at once\n' >&2; exit 1; }
grep --quiet "discharging at" "${tmp}/notify.log" ||
    { printf '[FAIL]    draining announcement lacks the measured rate\n' >&2; exit 1; }
grep --quiet -- "--urgency=critical" "${tmp}/notify.log" ||
    { printf '[FAIL]    a fault went out with normal urgency\n' >&2; exit 1; }
grep --quiet -- "-t 0" "${tmp}/notify.log" ||
    { printf '[FAIL]    a fault was sent with an expiring timeout\n' >&2; exit 1; }
printf '[OK]      a draining plug is announced as a persistent fault\n'
kill "${writer}" 2>/dev/null || true
writer=''

# Plugging in at the cap is good news too, and it replaces whatever the
# previous charger left on screen instead of stacking next to it.
fake "Not charging" 21000000 85
rm --force -- "${tmp}/notify.log"
check 0 "holding at cap" "a plug at the cap is announced" "0 0"
[ "$(wc --lines <"${tmp}/notify.log")" = 2 ] ||
    { printf '[FAIL]    a plug at the cap was not acknowledged and announced\n' >&2; exit 1; }
grep --quiet "Checking the charger" "${tmp}/notify.log" ||
    { printf '[FAIL]    a plug at the cap was not acknowledged at once\n' >&2; exit 1; }
grep --quiet "holding at" "${tmp}/notify.log" ||
    { printf '[FAIL]    cap announcement lacks the held percentage\n' >&2; exit 1; }
printf '[OK]      a plug at the cap is announced\n'

# A warning is retracted by evidence, and the EC's status word is not evidence:
# it reports Charging while the battery drains, which is the claim that had to
# be checked in the first place.  With no power figure behind it the warning
# stands and stays quiet, inside the window or out of it.
fake Charging 21000000 47
rm --force -- "${tmp}/notify.log"
check 0 "charging" "the status word alone does not retract the warning" "$(date +%s) 1"
[ ! -s "${tmp}/notify.log" ] ||
    { printf '[FAIL]    the status word retracted the warning\n' >&2; exit 1; }
printf '[OK]      the status word alone does not retract\n'

rm --force -- "${tmp}/notify.log"
check 0 "charging" "an elapsed window alone still does not retract it" "100 1"
[ ! -s "${tmp}/notify.log" ] ||
    { printf '[FAIL]    the window retracted the warning without evidence\n' >&2; exit 1; }
printf '[OK]      an elapsed window alone does not retract\n'

# A power figure is the charger actually being taken, and that is the news
# whoever is staring at the warning is waiting for, so it is not held back: the
# run that sees power is the run that retracts.  Held back by the window, it
# once left the warning on screen through a charge that had already started.
printf '12300000\n' >"${tmp}/sys/BAT0/power_now"
rm --force -- "${tmp}/notify.log"
check 0 "charging" "a power figure retracts the warning at once" "$(date +%s) 1"
[ "$(wc --lines <"${tmp}/notify.log")" = 1 ] ||
    { printf '[FAIL]    a charger being taken left the warning standing\n' >&2; exit 1; }
grep --quiet "Charging again" "${tmp}/notify.log" ||
    { printf '[FAIL]    the retraction does not say what changed\n' >&2; exit 1; }
printf '[OK]      a power figure retracts the warning at once\n'

# A retraction clears the epoch it retracted.  If it left the warning standing,
# every later timer run would find a warning to retract and say so, forever.
printf '12300000\n' >"${tmp}/sys/BAT0/power_now"
printf '%s 1\n' "$(date +%s)" >"${tmp}/state"
rm --force -- "${tmp}/notify.log"
timer_run() {
    NOTIFY_LOG="${tmp}/notify.log" \
        CHARGER_CHECK_NOTIFY="${tmp}/notify" CHARGER_CHECK_STATE="${tmp}/state" \
        CHARGER_CHECK_PLUG="${tmp}/plug" \
        CHARGER_CHECK_SETTLE=1 \
        POWER_SUPPLY_SYSFS="${tmp}/sys" "${here}/charger-check" >/dev/null 2>&1 || true
}
timer_run
timer_run
[ "$(wc --lines <"${tmp}/notify.log")" = 1 ] ||
    { printf '[FAIL]    the retraction repeated (%s notices)\n' \
        "$(wc --lines <"${tmp}/notify.log")" >&2; exit 1; }
grep --quiet '^0 1$' "${tmp}/state" ||
    { printf '[FAIL]    the retracted epoch was left standing in the state\n' >&2; exit 1; }
printf '[OK]      a retraction does not repeat\n'
rm --force -- "${tmp}/sys/BAT0/power_now"

# A fault that appears while the charger stays plugged in - the contract
# collapsing after a good verdict - is news, so it is not held back.
fake "Not charging" 21000000 47
ramp -500 &
writer=$!
sleep 0.5
rm --force -- "${tmp}/notify.log"
check 1 "DRAINING" "a fault after a good verdict is announced" "0 1"
[ "$(wc --lines <"${tmp}/notify.log")" = 1 ] ||
    { printf '[FAIL]    a fresh fault was held back\n' >&2; exit 1; }
printf '[OK]      a fresh fault is announced without waiting\n'

# The same fault, still standing, stays quiet inside the window and repeats
# once it is out.
rm --force -- "${tmp}/notify.log"
check 1 "DRAINING" "a standing fault stays quiet inside the window" "$(date +%s) 1"
[ ! -s "${tmp}/notify.log" ] ||
    { printf '[FAIL]    a standing fault repeated inside the window\n' >&2; exit 1; }
printf '[OK]      a standing fault stays quiet inside the window\n'

rm --force -- "${tmp}/notify.log"
check 1 "DRAINING" "a standing fault repeats after the window" "100 1"
[ "$(wc --lines <"${tmp}/notify.log")" = 1 ] ||
    { printf '[FAIL]    a standing fault never repeated\n' >&2; exit 1; }
printf '[OK]      a standing fault repeats after the window\n'
kill "${writer}" 2>/dev/null || true
writer=''

# The trend finding the charge is how a warning is retracted in the ordinary
# case, and it does not wait for the window either: a warning left standing
# through a charge that has started is a warning that lies.
fake "Not charging" 21000000 47
ramp 500 &
writer=$!
sleep 0.5
rm --force -- "${tmp}/notify.log"
check 0 "CHARGING" "the trend retracts the warning at once" "$(date +%s) 1"
[ "$(wc --lines <"${tmp}/notify.log")" = 1 ] ||
    { printf '[FAIL]    the trend did not retract the warning\n' >&2; exit 1; }
grep --quiet "Charging at" "${tmp}/notify.log" ||
    { printf '[FAIL]    the retraction lacks the measured rate\n' >&2; exit 1; }
printf '[OK]      the trend retracts the warning at once\n'
kill "${writer}" 2>/dev/null || true
writer=''

# The third state: unplugging is announced.  The notice carries the same tag as
# the verdicts, so mako replaces a standing critical fault with it rather than
# stacking the two - the adapter it complained about is gone.
fake Discharging 21000000 47 85 0
rm --force -- "${tmp}/notify.log"
check 2 "on battery" "unplugging is announced" "0 1"
[ "$(wc --lines <"${tmp}/notify.log")" = 1 ] ||
    { printf '[FAIL]    unplugging did not alert\n' >&2; exit 1; }
grep --quiet "running on battery" "${tmp}/notify.log" ||
    { printf '[FAIL]    the unplug notice lacks the state\n' >&2; exit 1; }
grep --quiet -- "--urgency=normal" "${tmp}/notify.log" ||
    { printf '[FAIL]    the unplug notice went out critical\n' >&2; exit 1; }
grep --quiet "x-canonical-private-synchronous:charger-check" "${tmp}/notify.log" ||
    { printf '[FAIL]    the unplug notice does not replace the fault\n' >&2; exit 1; }
grep --quiet '^0 0$' "${tmp}/state" ||
    { printf '[FAIL]    the fault epoch survived the unplug\n' >&2; exit 1; }
printf '[OK]      unplugging is announced and retracts the fault\n'

# The transition is over: the runs that follow stay quiet, however long the
# laptop is left unplugged.
rm --force -- "${tmp}/notify.log"
check 2 "on battery" "staying unplugged still prints the verdict" "0 0"
[ ! -s "${tmp}/notify.log" ] ||
    { printf '[FAIL]    a standing unplug repeated\n' >&2; exit 1; }
printf '[OK]      staying unplugged stays quiet\n'

# A cable fumbled back in faster than a run: the state file never saw the
# unplug, so the plug exists only in the marker charger-watch left behind.
fake "Not charging" 21000000 47
ramp -500 &
writer=$!
sleep 0.5
touch "${tmp}/plug"
rm --force -- "${tmp}/notify.log"
check 1 "DRAINING" "a plug the state never saw is announced" "0 1"
[ "$(wc --lines <"${tmp}/notify.log")" = 2 ] ||
    { printf '[FAIL]    a plug the state never saw went unannounced\n' >&2; exit 1; }
[ ! -e "${tmp}/plug" ] ||
    { printf '[FAIL]    the marker outlived the run that read it\n' >&2; exit 1; }
printf '[OK]      a plug the state never saw is announced\n'
kill "${writer}" 2>/dev/null || true
writer=''

# The fault is proven the moment a counter step lands, so the verdict must not
# wait out the window: waiting after the battery has already been seen losing
# charge is the answer being withheld for nothing.
fake "Not charging" 21000000 47
ramp -10000 &
writer=$!
sleep 0.5
rm --force -- "${tmp}/notify.log"
begun="$(date +%s%N)"
set +e
NOTIFY_LOG="${tmp}/notify.log" \
    CHARGER_CHECK_NOTIFY="${tmp}/notify" CHARGER_CHECK_STATE="${tmp}/state" \
    CHARGER_CHECK_PLUG="${tmp}/plug" \
    CHARGER_CHECK_SETTLE=1 \
    POWER_SUPPLY_SYSFS="${tmp}/sys" "${here}/charger-check" >/dev/null 2>&1
set -e
elapsed_ms=$(( ($(date +%s%N) - begun) / 1000000 ))
[ "${elapsed_ms}" -lt 3000 ] ||
    { printf '[FAIL]    the fault waited out the window (%s ms)\n' "${elapsed_ms}" >&2; exit 1; }
printf '[OK]      the fault is reported on the first step (%s ms)\n' "${elapsed_ms}"
kill "${writer}" 2>/dev/null || true
writer=''

# A plug that does nothing shows itself the other way round: the counter never
# moves and the figure never rises, so neither of the two signals arrives and
# the verdict used to be the window running out - five seconds of the user
# staring at a charger that is not charging.  Silence is the signal, and it is
# read at the floor's own cadence: a couple of seconds, not the window.
fake "Not charging" 21000000 47
rm --force -- "${tmp}/notify.log"
begun="$(date +%s%N)"
set +e
NOTIFY_LOG="${tmp}/notify.log" \
    CHARGER_CHECK_NOTIFY="${tmp}/notify" CHARGER_CHECK_STATE="${tmp}/state" \
    CHARGER_CHECK_PLUG="${tmp}/plug" \
    POWER_SUPPLY_SYSFS="${tmp}/sys" "${here}/charger-check" >/dev/null 2>&1
rc=$?
set -e
elapsed_ms=$(( ($(date +%s%N) - begun) / 1000000 ))
[ "${rc}" = 1 ] ||
    { printf '[FAIL]    a flat sub-floor plug was not called a fault (exit=%s)\n' \
        "${rc}" >&2; exit 1; }
[ "${elapsed_ms}" -lt 3000 ] ||
    { printf '[FAIL]    the silent fault waited out the window (%s ms)\n' \
        "${elapsed_ms}" >&2; exit 1; }
printf '[OK]      an absent figure alone reports the fault (%s ms)\n' "${elapsed_ms}"

# The other side of the same line: a figure that is small but real.  2.82 W was
# measured on a plug that went on to charge normally, and a single threshold
# called that "not charging" - a fault announced against a charger doing its
# job.  Below the floor and above the idle line the counter has to be the one
# to answer, and a flat counter over a window this short does not contradict a
# slow charge, so the verdict is the good one and no critical warning is raised.
fake "Not charging" 21000000 47
printf '2820000\n' >"${tmp}/sys/BAT0/power_now"
rm --force -- "${tmp}/notify.log"
check 0 "CHARGING SLOWLY" "a small figure is a slow charge, not a fault" "$(date +%s) 1"
[ "$(wc --lines <"${tmp}/notify.log")" = 1 ] ||
    { printf '[FAIL]    a slow charge went without a verdict\n' >&2; exit 1; }
if grep --quiet -- '--urgency=critical' "${tmp}/notify.log"; then
    printf '[FAIL]    a slow charge was announced as a fault\n' >&2
    exit 1
fi
grep --quiet 'Charging slowly' "${tmp}/notify.log" ||
    { printf '[FAIL]    the slow charge verdict does not say what it measured\n' >&2; exit 1; }
printf '[OK]      a small figure is a slow charge, not a fault\n'
rm --force -- "${tmp}/sys/BAT0/power_now"

printf 'all charger-check cases pass\n'
