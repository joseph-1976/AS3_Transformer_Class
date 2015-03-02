# AS3_Transformer_Class_v2
Transformer Class written in AS 3.0. I hope one may find use of this nifty script.
Instructions for Transformer Class
By: Joseph Stenhouse (Involution Media)

Introduction
Have you ever wanted to showcase your products with real interaction or
simply wanted to create an application that the user could drag, drop,
resize and rotate an object?
The transformer class is the perfect solution for scaling, rotating and
moving objects on runtime.

Using intuitive iterations, this class allows the programmer to have more
flexibility and write less code to perform simple transformation tasks.
The first tool of this kind on ActiveDen capable of resizing, moving and
rotating an object, it can transform textFields, MovieClips, Vector and
Bitmap Graphics (Inside the MovieClip), sliders, buttons, colorPickers,
labels, comboBoxes, textInputs and much more.
Using the transformer class, you can easily select, deselect and iterate
with objects. You can also listen for a list of events to get the most of this
incredible tool.

Making an object transformable

To make an object the target of transformation, you need first to copy the
‘com’ folder to your project’s main folder, open Flash and type the
following code:
Import com.flashcube.Transformer;
var myTransformer:Transformer = new Transformer(myDisplayObject);
Then, you need to copy the cursor movieClip, since it’s not dynamically
created, select it in the “Transformer.fla” file’s library, copy it and paste it
into your project.

Setting properties

If you imported the class, you should see all the properties when you type
your instance name followed by a ‘.’
myTransformer.showCenterCircle = true;
myTransformer.allowDrag = false;

Below there’s a list of all properties the class offers:
showCenterCircle (Boolean) – Shows / Hide the center handle when the
user selects the object target of the transformation.
allowScaleProportion (Boolean) – Allows the user to hold the SHIFT key
and scale the object proportionally.
allowRotateProportion (Boolean) – Allows the user to hold the SHIFT
key and rotate the object in increments of 45º.
forceScaleProportion (Boolean) – Forces the object to be scaled
proportionally, the SHIFT key in this case won’t make any difference.

forceRotateProportion (Boolean) – Forces the object to be rotated in
increments of 45º, the SHIFT key in this case won’t make any difference.
allowDrag (Boolean) – Allows the object to be dragged by the user.
allowScale (Boolean) – Allows the object to be scaled by the user.
allowRotate (Boolean) – Allows the object to be rotated by the user.
allowDelete (Boolean) – Allows the object to be deleted by the user,
pressing the DELETE key.
hideSideHandles (Boolean) – Hides the side handles: up, down, left,right.
hideCornerHandles (Boolean) – Hides the corner handles: Upper-right,
Upper-left, lower-right and lower-left.
hideBorder (Boolean) – Hides the border around the object (The
rectangle with no fill around it).
size (Number) – Size of the handles, please select a value higher than 5, if
it’s set to lower than 5, the hit test detection will be harder.
selectedAlpha (Number) – The alpha value of the cropping mode
background.
minWidth (Number) – The minimum width that the object can get,
measured in pixels.
minHeight (Number) – The minimum height that the object can get,
measured in pixels.
maxWidth (Number) – The maximum width that the object can get,
measured in pixels.
maxHeight (Number) – The maximum height that the object can get,
measured in pixels.
color (Number) – The color of the lines around the handles and the color
of the border.

rotation13
rotation31
rotation33
rotation11
box11
box21
box31
box32
box33
box23
box13
box12
box22
selectedColor (Number) – The color of the cropping mode background.
hideBoxesObject (Object) – An object containing Boolean values for the
boxes you can show / hide:
myTransformer.hideBoxesObject = { box11:true , box13:true , box33:true }
This will hide the boxes number 11, 13 and 33.
The boxes’ names are arranged this way:
box (Sprite) (read-only) : The actual handles sprites that appear in the
object, you can get all their basic properties, such as: x,y,width,height,…

Usage:
trace(myTransformer.box31.x);
rotationBox (Sprite) (read-only) : Same as above, but for the invisible
rotation handles.

NEW*
allowIncrements (Boolean): Allows the user to move the object using
the arrow keys.
keysIncrement (Number): Changes how much the object will move
using the keyboard increments above.
x: This is the target’s x value, you can access it through the Transformer
instance.
y: This is the target’s y value.
rotation: This is the target’s rotation value.
width: This is the target’s width value.
height: This is the target’s height value.

Functions

Functions can be accessed by the main timeline using the instance of the
created Transformer class.
MyTransformer.destruct();
MyTransformer.deselect();
destruct - Clean the transformer, delete the object and dispatch a
DEACTIVATE event.
deselect – Deselect the target object, if it’s selected.
select – Select the object target of the Transform instance.
removeTransform – Deletes the object inside of the container.

Events

The TransformerEvent Class dispatches all events needed for custom-
handling the actions of the Transformer Class, to use them; you need to
add the following code to your main TimeLine:
import com.flashcube.TransformerEvent;
import com.flashcube.Transformer;
var myTransformer:Transformer = new Transformer(myObject);
myTransformer.addEventListener( TransformEvent.ROTATE_END , doSomething );
function doSomething( e:TransformEvent ):void
{ trace(“Rotation ended”); }
ACTIVATE – Dispatched when the class is loaded.
DEACTIVATE – Dispatched when the class is unloaded / deactivated.
SCALE_START – Dispatched when the user clicks on one of the resize
handles.
SCALE_ENTER_FRAME – Dispatched on ENTER_FRAME when the user is
resizing the object.
SCALE_END – When the user let go of the mouse button.
ROTATE_START - Dispatched when the user clicks on one of the rotation
handles.
ROTATE_ENTER_FRAME – Dispatched on ENTER_FRAME when the user is
rotating the object.
SCALE_END – When the user let go of the mouse button.
DRAG_START - Dispatched when the user clicks on the object itself,
starting to drag it.
DRAG_MOUSE_MOVE – Dispatched on MOUSE_MOVE when the user is
dragging the object.
DRAG _END – When the user let go of the mouse button.
SELECT – When the object is selected.
DESELECT – When the object is deselected.
DELETE – When the user deletes the object by pressing the DELETE key.
