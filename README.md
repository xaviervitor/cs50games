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

## Second commit - Object distance controls, ground indicator, held object follow with Force, preservation of momentum and crosshair
My first idea for improvement of the player controls was to give the player control of the distance between the camera and the held object, to give more control of where the player can move a magnetic object. Thinking of that, I made the ground indicator, an object that follows the held object and raycasts below it to indicate where the nearest ground the object would fall if it is dropped.

After that, I implemented the distance controls, and wanted to make the held object be more dynamic and react to the physics in a more realistic way. To do that, I had to solve a problem that I avoided in the last commit. Previously, I was just parenting the held object to the player camera rotation object, meaning that the object didn't use any Force to move to its target position, which in turn means that when the object is released, there aren't any forces applied to its rigidbody.

My idea was to calculate the direction vector that would lead to the target position and move the object along that vector every FixedUpdate, using a force based in the current distance from the target position. This implementation only worked after I changed the Drag property of every held object to 20, in the ```HeldObject.Pickup()```, and made the gameplay finally work the way I intended, now the velocity of the object is preserved when the player releases it.

I had to learn how rigidbodies behave and the nuances of FixedUpdate, Update and LateUpdate to achieve the smooth movement of the held object following the player, as well as the Ground Indicator following the held object.

- Added a Crosshair to the center of the HUD and the UpdateCrosshairColor script, which checks if the PlayerInteract script flagged a object in range for the player to pickup and updates the color of the crosshair accordingly;
- Cleaned up code of the held object, which now lives in the HeldObject class, and the PlayerInteract script now only holds a HoldObject instance when a object is picked up, simplifying the script;
- Downloaded a new shader, "GhostlyHand", from the asset store, which is being used to render the new Held Object Ground Indicator;
- Moved the StarterAssets folder to the Thirdparty folder to be organized in the same folder as the other tools from the asset store.

---