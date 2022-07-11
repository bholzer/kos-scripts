set east to VCRS(up:vector, north:vector).
clearscreen.

// defaults:
// maxStoppingTime: 2
// kp: 1
// ki: 0.1
// kd: 0
set steeringManager:maxStoppingTime to 2.
set steeringManager:pitchPID:kp to 3.5.
set steeringManager:pitchPID:ki to 0.01.
set steeringManager:pitchPID:kd to 0.4.
set steeringManager:yawPID:kp to 3.5.
set steeringManager:yawPID:ki to 0.01.
set steeringManager:yawPID:kd to 0.4.
set steer to north:vector + up:vector + east.
lock steering to steer.

vecdraw(
	{ return ship:position. },
	{ return steer .},
	rgb(1,0,0),
	"steer",
	5.0,
	true,
	0.2,
	true,
	true
).


until false {
  wait 0.1.
}
