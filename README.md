# Project 9: Dreadhalls

This is a Dreadhalls clone developed using the [Unity](https://unity.com/) game engine and written in [C#](https://dotnet.microsoft.com/en-us/languages/csharp) by Colton Ogden and edited by me.

---

### Specification

*   _Spawn holes in the floor of the maze that the player can fall through (but not too many; just three or four per maze is probably sufficient, depending on maze size)._ This should be very easy and only a few lines of code. The `LevelGenerator` script will be the place to look here; we aren’t keeping track of floors or ceilings in the actual maze data being generated, so best to take a look at where the blocks are being insantiated (using the comments to help find!).
*   _When the player falls through any holes, transition to a “Game Over” screen similar to the Title Screen, implemented as a separate scene. When the player presses “Enter” in the “Game Over” scene, they should be brought back to the title._ Recall which part of a Unity GameObject maintains control over its position, rotation, and scale? This will be the key to testing for a game over; identify which axis in Unity is up and down in our game world, and then simply check whether our character controller has gone below some given amount (lower than the ceiling block, presumably). Another fairly easy piece to put together, though you should probably create a `MonoBehaviour` for this one (something like `DespawnOnHeight`)! The “Game Over” scene that you should transition to can effectively be a copy of the Title scene, just with different wording for the `Text` labels. Do note that transitioning from the Play to the Game Over and then to the Title will result in the Play scene’s music overlapping with the Title scene’s music, since the Play scene’s music is set to never destroy on load; therefore, how can we go about destroying the audio source object (named `WhisperSource`) at the right time to avoid the overlap?
*   _Add a Text label to the Play scene that keeps track of which maze they’re in, incrementing each time they progress to the next maze. This can be implemented as a static variable, but it should be reset to 0 if they get a Game Over._ This one should be fairly easy and can be accomplished using static variables; recall that they don’t reset on scene reload. Where might be a good place to store it?

---

A video demonstration can be found in this [link](https://youtu.be/QL00d85GpO0).
