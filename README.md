# Project 10: Portal

This is a Portal clone developed using the [Unity](https://unity.com/) game engine and written in [C#](https://dotnet.microsoft.com/en-us/languages/csharp) by Colton Ogden and edited by me.

Instead of building on the game foundation, this exercise was designed to get the students acquainted to the, at the time, new Unity level design tools, **ProBuilder** and **ProGrids**. More details below.

---

### Specification

*   _Create your own level in a new scene using ProBuilder and ProGrids!_ The distro should already have ProBuilder and ProGrids imported and ready for use, but just in case they aren’t, you can easily find them by searching in the Asset Store (where they are now free, thanks to Unity having acquired them!). There are many resources for learning how to use ProGrids effectively, but two resources in particular that are worth checking out are [here](https://www.youtube.com/watch?v=PUSOg5YEflM) and [here](https://procore3d.github.io/probuilder2/), which should more than prepare you for creating a simple level.
*   _Ensure that the level has an `FPSController` to navigate with in the scene._ This part’s probably the easiest; just import an FPSController from the Standard Assets! It should already be imported into the project in the distro, where you can find the prefabs under `Assets > Standard Assets > Characters > FirstPersonCharacter > Prefabs`!
*   _Ensure that there is an object or region with a trigger at the very end that will trigger the end of the level (some zone with an invisible `BoxCollider` will work)._ This one should be easy as well, just relying on the creation of an empty GameObject and giving it a `BoxCollider` component, which you can then resize via its resize button in the component inspector!
*   _When the level ends, display “You Won!” on the screen with a `Text` object._ Recall that `OnTriggerEnter` is the function you’ll need to write in a script you also associate with the `BoxCollider` trigger, and ensure that the `BoxCollider` is set to a trigger in the inspector as well! Then simply program the appropriate logic to toggle on the display of a `Text` object that you also include in your scene (for an example on how to do this, just see the Helicopter Game 3D project, specifically the `GameOverText` script)!

---

A video demonstration can be found in this [link](https://youtu.be/5Cu88aiwpsA).
