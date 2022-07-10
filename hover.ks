// Hovers rocket at a specified radar altitude

parameter targetAlt is 100.

// modes
set RUNMODE_HOVER to 1.
set RUNMODE_DESCEND to 2.
set RUNMODE_END to 0.

// initialize state
sas off.
set ship:control:pilotMainThrottle to 0.
set throt to 0.
set runmode to RUNMODE_HOVER.
set steerVec to up:vector.
lock throttle to throt.
lock steering to LookDirUp(steerVec, north:vector).

// cardinal directions
set east to VCRS(up:vector, north:vector).
set south to VCRS(up:vector, east).
set west to VCRS(up:vector, south).

lock g to body:mu / (body:radius + ship:altitude)^2.
lock maxA to ship:maxThrust / ship:mass.
lock maxVertV to max(0, sqrt(abs(targetAlt - alt:radar) * g * 2)).
lock minVertV to min(0, 0 - sqrt(abs(targetAlt - alt:radar) * 2 * (maxA * 0.8 - g))).


// Controls:
// Use a casdading PID scheme to control altitude with acceleration via velocity.
// Uses ziegler-nichols-ish tuning method

// Vertical velocity PID
// Control altitude with velocity
set ku to 5.
set tu to 1.
set kp to 0.6 * ku.
set ki to 1.2 * kp / tu.
set kd to 0.075 * ku * tu.
set vertVPid to pidLoop(kp, ki, kd, minVertV, maxVertV).
set vertVPid:setpoint to targetAlt.
set targetVertV to vertVPid:update(time:seconds, alt:radar + ship:verticalSpeed).

// Acceleration PID, cascading from velocity
// control velocity with acceleration
set kp to 3.
set ki to 0.
set kd to 0.
set aPid to pidLoop(kp, ki, kd).
set aPid:setpoint to targetVertV.
set targetVertA to aPid:update(time:seconds, ship:verticalSpeed).

// Currently supports only vertical hover, accelerate straight upward
set steerVec to up:vector.
set throt to targetVertA / maxA.

until runmode = RUNMODE_END {
  if runmode = RUNMODE_HOVER {
    set vertVPid:maxoutput to maxVertV.
    set vertVPid:minoutput to minVertV.
    set targetVertV to vertVPid:update(time:seconds, alt:radar).
    set aPid:setpoint to targetVertV.
    set targetVertA to max(0, aPid:update(time:seconds, ship:verticalSpeed)).
    set throt to targetVertA / maxA.
    printHoverStats().
    print targetVertA.
  }
  wait 0.1.
}


function printHoverStats {
  parameter mode is "HOVER CONTROL".
  clearscreen.
  print "== " + mode + " ==".
  print "Target Radar (m):   " + round(targetAlt,1).
  print "Altitude MSL (m):   " + round(altitude,1).
  print "Radar (m):     " + round(alt:radar,1).
  print "Vertical velocity (m/s):   " + round(ship:verticalSpeed,1) + " (" + round(targetVertV,1) + ")    ".
}
