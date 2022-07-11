set targetNorth to 2100.
set targetEast to -120.
set east to VCRS(up:vector, north:vector).
set steeringManager:maxStoppingTime to 2.
set steeringManager:pitchPID:kp to 3.5.
set steeringManager:pitchPID:ki to 0.01.
set steeringManager:pitchPID:kd to 0.4.
set steeringManager:yawPID:kp to 3.5.
set steeringManager:yawPID:ki to 0.01.
set steeringManager:yawPID:kd to 0.4.

set relativeTargetPos to (north:vector * targetNorth) + (east * targetEast).

lock shipPos to (ship:position - body:position).
set targetPos to (shipPos + relativeTargetPos).

lock distance to targetPos - shipPos.

//set offset to distance.

lock steering to targetPos + body:position	.

vecdraw(
	{ return ship:position. },
	{ return targetPos + body:position .},
	rgb(1,0,0),
	"offset",
	1.0,
	true,
	0.1,
	true,
	true
).

until false {
  clearscreen.
  print ship:facing.
  print targetPos.
  print shipPos.
  print distance.
  wait 0.1.
}
