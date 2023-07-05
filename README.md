# CS50’s Introduction to Game Development Projects
This repository contains all the 11 exercises I did in the [CS50’s Introduction to Game Development](https://cs50.harvard.edu/games/2018/) course. Each game/exercise lives in a separate branch, following the pattern ```games50/projects/2018/x/{name}```, as the course demanded that naming convention and organization. 

The game/exercises weren't entirely developed by me. Colton Ogden, the course instructor made an initial framework for all the exercises and I had to make changes and additions to the game as specified in the Project page. An exception is the course's final project, which I developed from concept to launch. As such, I decided to move it to another repo: [biomagnetic](https://github.com/xaviervitor/biomagnetic/). For the sake of preservation and keeping all of the relevant information in this repo, each branch has the specification of the exercise in the ```README.md``` file. 

# Project 0: Pong

This is a pong clone developed using the [Löve2D](https://love2d.org/) game engine and written in [Lua](https://www.lua.org/) by Colton Ogden. More details in the ```main.lua``` file.

---

### Specification

* Implement an AI-controlled paddle (either the left or the right will do) such that it will try to deflect the ball at all times. Since the paddle can move on only one axis (the Y axis), you will need to determine how to keep the paddle moving in relation to the ball. Currently, each paddle has its own chunk of code where input is detected by the keyboard; this feels like an excellent place to put the code we need! Once either the left or right paddle (or both, if desired) try to deflect the paddle on their own, you’ve done it!
