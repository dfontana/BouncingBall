# Bouncing Ball
A small simulation of a bouncing ball with pseudo physics in a level. 
Utilize the Left, Right, and Space keys to apply energy to the ball. 

### About this Project
Using the GOSU Gem, a minigame was made to control a bouncing ball using pseudo-physics. This project was designed as a 'prompt' for learning and expanding my knowledge on Ruby. After I grew comfortable with simple syntax, I left the project be to focus on other tasks. What was accomplished is as follows:

- Simple Pseudo ball physics, for velocity and bouncing.
- Ability to give the ball pushes/somewhat directional control.
- The starting of adding platforms to the level, albeit the collision logic is faulty.

After returning to the project sometime later, the faulty collisions have been resolved by using a vector based approach. The physics also recieved a little TLC, gaining an acceleration and deceleration dimension that was previously missing.

## Current TODO / Fixes
- [X] Ball ignores collisions with platforms sporadically
 - [X] Rework collision detection based on segment intersection
 - [X] Account for level walls
 - [X] Determine which face of a platform has been hit
 - [ ] Potential collision miss after correcting a first collision (Under low velocities, this defect is masked)
- [X] Player loses control of ball after MaxSpeed is hit.
- [X] Ball can start inside a box. Need to alter balls initial point to check for collision with box, generating positions until not colliding.
- [ ] Introduce stronger physics, involving acceleration and velocity decay
 - [X] Will lead into potential collision misses if position of ball is not updated to be above the collision point. This must still be fixed for the game window check (already handled in platform check)
 - [ ] Amount of adjustment after collision is tied to a scaler of the distance the ball travels, which varies under new physics. This makes the net adjustment a product of the speed (higher speed = greater distance traveled = ball placed further from the platforms). Will need a better way to normalize the adjustment independent of the current speed (can also be viewed as the current rx or ry)

