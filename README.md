# Project 2: Match-3

This is a match-3 game developed using the [Löve2D](https://love2d.org/) game engine and written in [Lua](https://www.lua.org/) by Colton Ogden and edited by me. More details in the ```main.lua``` file.

---

### Specification

*   _Implement time addition on matches, such that scoring a match extends the timer by 1 second per tile in a match._ This one will probably be the easiest! Currently, there’s code that calculates the amount of points you’ll want to award the player when it calculates any matches in `PlayState:calculateMatches`, so start there!
*   _Ensure Level 1 starts just with simple flat blocks (the first of each color in the sprite sheet), with only later levels generating the blocks with patterns on them (like the triangle, cross, etc.). These should be worth more points, at your discretion._ This one will be a little trickier than the last step (but only slightly); right now, random colors and varieties are chosen in `Board:initializeTiles`, but perhaps we could pass in the `level` variable from the `PlayState` when a `Board` is created (specifically in `PlayState:enter`), and then let that influence what `variety` is chosen?
*   _Create random shiny versions of blocks that will destroy an entire row on match, granting points for each block in the row._ This one will require a little more work! We’ll need to modify the `Tile` class most likely to hold some kind of flag to let us know whether it’s shiny and then test for its presence in `Board:calculateMatches`! Shiny blocks, note, should not be their own unique entity, but should be “special” versions of the colors already in the game that override the basic rules of what happens when you match three of that color.
*   _Only allow swapping when it results in a match. If there are no matches available to perform, reset the board._ There are multiple ways to try and tackle this problem; choose whatever way you think is best! The simplest is probably just to try and test for `Board:calculateMatches` after a swap and just revert back if there is no match! The harder part is ensuring that potential matches exist; for this, the simplest way is most likely to pretend swap everything left, right, up, and down, using essentially the same reverting code as just above! However, be mindful that the current implementation uses all of the blocks in the sprite sheet, which mathematically makes it highly unlikely we’ll get a board with any viable matches in the first place; in order to fix this, be sure to instead only choose a subset of tile colors to spawn in the `Board` (8 seems like a good number, though tweak to taste!) before implementing this algorithm!
*   _(_Optional_) Implement matching using the mouse. (Hint: you’ll need `push:toGame(x,y)`; see the `push` library’s documentation [here](https://github.com/Ulydev/push) for details!_ This one’s fairly self-explanatory; feel free to implement click-based, drag-based, or both for your application! This one’s only if you’re feeling up for a bonus challenge :) Have fun!


---

A video demonstration can be found in this [link](https://youtu.be/uSksmIuyjXI).
