# Final Project Development Documentation

## First commit - Initial player movement, level blocking and pickup/hold/throw interactions
First, included assets "Starter Assets - First Person Character Controller", the new default unity character controller, to get the basis of a basic first person character controller and "Gridbox Prototype Materials", just for prototyping the level in distinct material colors.

After that, I made the initial level blocking. I'm envisioning a game where you can push, pull, hold and throw heavy objects using a "magnet hand", so I decided to start implementing a basic hold object interaction.

I implemented the "Interaction" button, which allows the player to pick up and drop objects in the "Pickable" physics layer in the level, implemented in the "PlayerInteract" script. I had to watch some tutorials, read the new Unity Input System documentation and also read the default FirstPersonController code as a base to grasp how the new input system works and how to implement a basic button click.

Then, I placed cubes with Rigidbodies to be picked up by the player in the level, and modified the Character Controller's Player Input component Behavior to "Invoke Unity Events" instead of "Send Messages" to have more control of the input phase received. Initially, when I clicked the left mouse button to pickup an object it would pick and throw the object repeatedly about ~20 times per click. I discovered that the reason was the click input was being read as "performed" every frame, and changing this behaviour gave me more control of the phase of the inputs. In the end, that didn't solve the problem fully and I ended up detecting the player input using the variable ```_input.interact```, and storing the value read at the previous frame in the variable ```isMouseDown```, using it to create logic to run the pickup code only once. I decided to keep the Player Input component Behavior in case some other situation requires this control over the input phases.

When the left mouse button is clicked, a Raycast is created to detect objects in the distance of 2 units of the center of the player camera transform. 

As it is, the "First Person Character Controller" made by Unity rotates the PlayerCameraRoot - which the MainCamera ultimately follows - in the Y axis to make the character look up and down and rotates the Capsule itself in the X axis to look left and right. This is great because it means that if a player model replaces the Capsule it will rotate the same as the camera horizontally. The problem is that because of that logic, neither Capsule rotation nor PlayerCameraRoot rotation truly represents the player forward looking direction. This is why I included a empty "PlayerRotationReference" GameObject inside the PlayerCapsule, which is always updated with the current Y rotation of the camera and X rotation of the capsule in the ```CameraRotation()``` function of the FirstPersonController.cs file. This simplifies code and makes this a Player Rotation Reference accessible for possible future uses.

With that, I now have a character controller, a basic "greybox" level and a pickup/throw interaction.

---