{ ... }:
{
  services.ssh-agent.enable = true;

  # The ThinkPad EC reports mains present even when USB-C PD negotiation fails,
  # so plugging in can silently do nothing while the battery carries the load.
  # charger-check measures what the energy actually does and notifies on that.
  systemd.user.services.charger-check = {
    Unit.Description = "Check that a connected charger is actually charging";
    # Every uevent starts this, and a person fumbling a connector produces a
    # burst of them; systemd's default rate limit is five starts per ten
    # seconds, so the check went silent with "start request repeated too
    # quickly" at the one moment the verdict was wanted.  Disabled because the
    # starts cannot pile up - one is either a no-op while a run is going or a
    # restart of it - and because the notification rate is limited where it
    # belongs, by the check's own repeat window.
    Unit.StartLimitIntervalSec = 0;
    Service = {
      Type = "oneshot";
      ExecStart = "%h/.local/bin/charger-check";
      # Exit 1 (connected, not charging) and 2 (on battery) are verdicts, not
      # unit failures.  Without this every minute of ordinary operation logs
      # "Failed to start" and leaves the unit failed, hiding real failures.
      # SIGTERM is a verdict of the same kind: the run superseded by the next
      # plug is killed by the watcher's restart, and logging that as a failure
      # defeats the point of the two exits above.
      SuccessExitStatus = [ 1 2 "SIGTERM" ];
    };
  };

  systemd.user.timers.charger-check = {
    Unit.Description = "Poll the charger state";
    Timer = {
      OnStartupSec = "10s";
      # 5 s after each run finishes, rather than a fixed cadence: a run that has
      # to sample the energy trend takes seconds and would otherwise be lapped
      # by its own next tick.  This is the standing-state poll - the plug itself
      # arrives from charger-watch in the milliseconds after the EC reports it -
      # so the cadence only has to be quick enough that a drain starting with no
      # event of its own is caught while it is still news.
      OnUnitInactiveSec = "5s";
      # systemd's default accuracy is 1 min, which smears a 5 s schedule into
      # whatever the timer feels like (measured: 15 s) - and a plug announcement
      # that can arrive a minute late is not the announcement that was asked
      # for.  Once a tick is this cheap there is nothing to coalesce.
      AccuracySec = "1s";
    };
    Install.WantedBy = [ "timers.target" ];
  };

  # The timer polls; this listens.  A plug is a hardware event, and waiting up
  # to a tick to notice it was most of the delay between the cable going in and
  # the verdict arriving, so the kernel's own uevents drive the check directly.
  # Unprivileged: the uevent socket needs no root, unlike the udev rule that
  # drives the power profile.  It is also what leaves the plug marker the check
  # reads, and that is how a cable out and back within one run is still
  # announced rather than swallowed by the state file never seeing the unplug.
  systemd.user.services.charger-watch = {
    Unit.Description = "Run the charger check when the hardware reports a change";
    Service = {
      ExecStart = "%h/.local/bin/charger-watch";
      # A watcher that dies should come back, but not in a tight loop: this one
      # sits on a socket, so a failure is a real one and retrying fast would
      # only fill the journal with it.
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
