# Bouncing Ball
A small simulation of a bouncing ball with pseudo physics in a level. 
Utilize the Left, Right, and Down keys to apply energy to the ball. 

### About this Project
Using the GOSU Gem, a minigame was made to control a bouncing ball using pseudo-physics. This project was designed as a 'prompt' for learning and expanding my knowledge on Ruby. After I grew comfortable with simple syntax, I left the project be to focus on other tasks. What was accomplished is as follows:

- Simple Pseudo ball physics, for acceleration and bouncing.
- Ability to give the ball pushes/somewhat directional control.
- The starting of adding platforms to the level, albeit the collision logic is faulty.

The project laid dormant for some time, yet the messy collisions and poor physics left me disgruntled. This project has now resumed development, slowly being repaired for better collision detection and perhaps a little more convincing physics. Just becuase the job can't go undone.

## Current TODO / Fixes
- [ ] Ball ignores collisions with platforms sporadically
 - [ ] Rework collision detection based on segment intersection
 - [ ] Account for level walls
 - [ ] Determine which face of a platform has been hit
- [ ] General velocity oddities. Options:
 - [ ] Reintroduce Friction in a more controlled manner
 - [ ] Introduce a Decay each update
 - [ ] Reduce Vy multiplicatively as a factor of height

