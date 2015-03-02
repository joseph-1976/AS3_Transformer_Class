
/**
* 
* 	 
* 
* 	@author Joseph Stenhouse (Involution Media)
* 	@version 3.8
* 	Date: 09/29/2011
* 	ActionScript Version: AS3
* 
* 
*	 			 ____________________________________________________
*   			|													 |
*   			|													 |
* 				|	QUICK CONTENT INDEX ( table of contents )        |
*	 			|	                                                 |
*	 			|	                                                 |
* 				|	1 - Imports							impIndx      |
* 				|                                                    |
* 				|	2 - Variables						varIndx      |
* 				|		2.1 - Instances					var1         |
* 				|		2.2 - Graphics					var3         |
* 				|		2.3 - Booleans					var4         |
* 				|		2.4 - Numbers					var5         |
* 				|		2.5 - Colors					var6         |
* 				|		2.6 - Arrays					var7         |
* 				|		2.7 - Other						var8         |
* 	   			|                                                    |
* 				|	3 - Constructor						conIndx      |
* 	  		  	|                                                    |
* 				|	4 - Functions						funIndx      |
* 				|		4.1 - Transform Functions		fun1         |
* 				|		4.2 - Cursor Functions			fun2         |
*    			|                                                    |
*	 			|	5 - Event Listeners					eveIndx      |
* 	 			|		5.1 - Mouse Events				eve1         |
*	 			|		5.2 - Events					eve2         |
*	 			|		5.3 - Keyboard Events			eve3         |
* 				|                                                    |
* 				|	6 - Utils							utiIndx      |
* 			    |                                                    |
* 				|	7 - Gets And Sets					gsIndx       |
* 				|		7.1 - Gets						gs1          |
* 				|		7.2 - Sets						gs2          |
* 				|	                                                 |
* 				|	                                                 |
*		 		|____________________________________________________|	
* 
* 
*/


package com.flashcube
{
	//************************************ impIndx - IMPORTS ************************************//
	
	
	import com.flashcube.core.*;
	import com.flashcube.TransformerEvent;
	
	import flash.accessibility.AccessibilityProperties;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	
	public class Transformer extends EventDispatcher
	{
		
		//************************************ varIndx - VARIABLES ************************************//
		
		
		/*****************************/
		/*                           */
		/* 	   var1 - INSTANCES      */
		/*                           */
		/*****************************/
		
		
		//This variable is used to track the number of instances for this class.
		private static var instances:uint = 0;
		
		
		/*****************************/
		/*                           */
		/* 	   var2 - GRAPHICS       */
		/*                           */
		/*****************************/
		
		
		// The target of the transformation, it can't be accessed from outside of the class.
		private var _obj:DisplayObject;
		
		// Target's stage reference.
		private var stage:DisplayObjectContainer;
		// The container that will hold the target [obj].
		private var container:MovieClip = new MovieClip();
		
		// The small line that connects all 8 handles.
		private var border:Sprite = new Sprite();
		
		/*
		 * 	Rotation handles for the mouseOver functions, they're simply invisible squares placed
		 * 	inside of container MovieClip.
		 * 
		 *  The boxes' names are their x / y position, for example, the rotate11 is the handle on
		 *  the upper-left corner, rotate13 is the one in the lower-left, rotate31 is the one in 
		 *  the upper-right, rotate33 is the one in the lower-right.
		 */
		private var _rotate11:Sprite = new Sprite();
		private var _rotate13:Sprite = new Sprite();
		private var _rotate31:Sprite = new Sprite();
		private var _rotate33:Sprite = new Sprite();
		
		//The backStage is an invisible Sprite that will be placed behind all DisplayObjects.
		private var backStage:Sprite = new Sprite();
		
		/*
		 * 	The box variables are the actual handles that appear, you can get all their 
		 *  properties, but you can't change any of them.
		 * 
		 * 		Example:
		 * 
		 * 			|  var MyTransformer:Transformer = new Transformer( myMovieClip );
		 * 			|  trace( MyTransformer.box11.x );
		 * 
		 *  The boxes' names are chosen to represent their x and y position:
		 * 
		 *  box11:				box13:				box32:
		 * 
		 *		O	-	-			-	-	-			-	-	-
		 * 		-	-	-			-	-	-			-	-	O
		 * 		-	-	-			O	-	-			-	-	-
		 * 
		 */
		private var _box11:Sprite = new Sprite();
		private var _box12:Sprite = new Sprite();
		private var _box13:Sprite = new Sprite();
		private var _box21:Sprite = new Sprite();
		private var _box22:Sprite = new Sprite();
		private var _box23:Sprite = new Sprite();
		private var _box31:Sprite = new Sprite();
		private var _box32:Sprite = new Sprite();
		private var _box33:Sprite = new Sprite();
		
		
		/*****************************/
		/*                           */
		/* 	   var3 - BOOLEANS       */
		/*                           */
		/*****************************/
		
		/**
		 * Show or hides the center handle (The circle).
		 */
		public var showCenterCircle:Boolean = true;
		
		/**
		 * Can the object be scaled with proportion? ( holding the SHIFT key ).
		 */
		public var allowScaleProportion:Boolean = true;
		/**
		 * Can the object be rotated with proportion? ( holding the SHIFT key ).
		 */
		public var allowRotateProportion:Boolean = true;
		
		/**
		 * Forces the scaling of the object to be proportional, holding the SHIFT key will
		 * have no effect on the object, since it's already forced to resize equaly.
		 */
		public var forceScaleProportion:Boolean = false;
		/**
		 * Forces the rotation of the object to be proportional in increments of 45º, 
		 * holding the SHIFT key will have no effect on the object, since it's already
		 * forced to resize equaly.
		 */
		public var forceRotateProportion:Boolean = false;
		
		// If the shift key is pressed, this variable is set to true.
		private var constrain:Boolean = false;
		
		private var _allowDrag:Boolean = true;		// Allow the object to be dragged.
		/**
		 * Allows the object to be scaled, if set to false, the handles in the object's
		 * sides and corners will be invisible, not allowing the user to resize the object.
		 */
		public var allowScale:Boolean = true;		// Allow the object to be scaled.
		/**
		 * Allows the object to be rotated, if set to false, the invisible handles in the 
		 * object's corners will be deleted, not allowing the user to rotate the object.
		 */
		public var allowRotate:Boolean = true;		// Allow the object to be rotated.
		/**
		 * Allows the object to be deleted by the user pressing the <b>DELETE</b> key,
		 * the object can't return inside of this class, you will need to listen for the 
		 * <b>DELETED</b> event and then create another instance of the object.
		 */
		public var allowDelete:Boolean = false;		// Allow the object to be deleted.
		
		/**
		 * Hides the north, west, south and east handles of the object ( left, right, up and down handles).
		 */
		public var hideSideHandles:Boolean = false;		// Hide the handles on the side ( N/S/E/W ).
		/**
		 * Hides the upper-right, upper-left, lower-right and lower-left handles of the object.
		 */
		public var hideCornerHandles:Boolean = false;	// Hide the handles on the corners ( UL/UR/LL/LR ).
		/**
		 * Hides the border ( the small line that connects the handles ).
		 */
		public var hideBorder:Boolean = false;			// Hide the border ( the small line that connects the handles ).
		
		/**************************************** NEW *********************************************/
		// Allows keyboard increments using the arrow keys. //
		public var allowIncrements:Boolean = false;
		
		
		/*****************************/
		/*                           */
		/* 	    var4 - NUMBERS       */
		/*                           */
		/*****************************/
		
		public var keysIncrement:Number = 1;
		
		private var iWidth:Number;		// Initial width of the object.
		private var iHeight:Number;		// Initial height of the object.
		private var conRot:Number;		// Container's rotation.
		
		private var _size:Number;		// Size of the handles.
		
		private var _rotationDistance:Number;		// Distance for the hitTest to work in the rotation handles (Don't set it to a value lower than the size above, this will cause the hit detection not to work).
		
		private var _selectedAlpha:Number = 0;		// The alpha value of the crop background.
		
		/**
		 * Object's minimum Width.
		 */
		public var minWidth:Number;
		/**
		 * Object's minimum Height.
		 */
		public var minHeight:Number;
		/**
		 * Object's maximum Width.
		 */
		public var maxWidth:Number;
		/**
		 * Object's maximum Height.
		 */
		public var maxHeight:Number;
		
		
		/*****************************/
		/*                           */
		/* 	     var5 - COLORS       */
		/*                           */
		/*****************************/
		
		
		private var _color:Number = 0x000000;				// Color of the lines ( Border and handles ).
		private var _selectedColor:Number = 0x000000;		// Color of the background square ( crop Background ).
		
		
		/*****************************/
		/*                           */
		/* 	     var6 - ARRAYS       */
		/*                           */
		/*****************************/
		
		
		private var boxes:Array = [];					// An array of objects that will contain all boxes ( box22 not included ).
		private var allBoxes:Array = [];				// An array of objects that will contain all boxes ( No exception ).
		private var rotationBoxes:Array = [];			// An array of objects that will contain all rotation boxes.
		
		
		/*****************************/
		/*                           */
		/* 	    var7 - OTHER         */
		/*                           */
		/*****************************/
		
		
		private var deselectArea:Point = new Point(590 , 300);
		
		// The cursor movieClip.
		private var myCursor:MouseArrow = new MouseArrow();
		//private var myCursor:MovieClip = new MovieClip();
		
		/**
		 *  <p>An object containing the handles NOT to be shown on screen.
		 *  For example:
		 * 		<code> myObj.hideBoxesObject = { box11:true , box12:true , box33:true }; </code>
		 * </p>
		 */
		public var hideBoxesObject:Object = {};
		
		// Holds an reference to the selected handle.
		private var selected:DisplayObject;
		
		private var _x:Number;
		private var _y:Number;
		private var _rotation:Number;
		private var _width:Number;
		private var _height:Number;
		
		
		//************************************ conIndx - CONSTRUCTOR ************************************//
		
		/**
		 * <b>Transformer Class</b><br /><br />
		 * 
		 * The transform class receives only one parameter, the <b>obj</b> is a DisplayObject
		 * that is the target of the transformation, create an instance of this class using the following code: <br /><br /><code>
		 * 
		 *		var myVar:Transformer = new Transformer(myMovieClip);</code>
		 *
		 * @param	obj DisplayObject target for the transformation.
		 */
		
		public function Transformer(obj:DisplayObject):void
		{
			// Activate event dispatched.
			dispatchEvent( new TransformerEvent( TransformerEvent.ACTIVATE ));
			
			// Increase the number of instances.
			instances++;
			
			// Initialize the hideHandlesObject.
			initializeObject();
			
			_size ||= 10;							// Set size.
			_rotationDistance ||= 25;				// Set rotationDistance.
			minWidth ||= 0;							// Set minWidth.
			minHeight ||= 0;						// Set minHeight.
			maxWidth ||= Number.MAX_VALUE - 1;		// Set maxWidth.
			maxHeight ||= Number.MAX_VALUE - 1;		// Set maxHeight.
			
			this._obj = obj;	// Set this obj's reference to the one passed in the Constructor.
			stage = obj.stage;	// Set this stage to the one passed by the obj.
			
			deselectArea = new Point(obj.stage.stageWidth , obj.stage.stageHeight);
			
			// Here the object's actual rotation value is stored into a temp variable and set to 0.
			{
				var tempRotation:Number = obj.rotation;
				obj.rotation = 0;
				container.rotation = tempRotation;
			}
			
			// Set container's spacial properties equal to the object.
			container.x = obj.x;
			container.y = obj.y;
			
			// Add the object to the container.
			container.addChild( obj );
			
			// Set the object's spacial properties equal to 0.
			obj.x = 0;
			obj.y = 0;
			
			// Add the container to the stage.
			stage.addChild( container );
			// Send it to front.
			Utils.sendToFront( container );
			
			// Create all the handles and graphics.
			createBoxes();
			
			// Add the event listeners for all the boxes and to the stage.
			Utils.addMultipleListeners( MouseEvent.MOUSE_DOWN , resizeClicked , boxes );
			Utils.addMultipleListeners( MouseEvent.MOUSE_DOWN , rotationClicked , rotationBoxes );
			Utils.addMultipleListeners( MouseEvent.MOUSE_DOWN , startMoving , [_box22] );
			Utils.addMultipleListeners( MouseEvent.MOUSE_UP , unClick , [stage] );
			Utils.addMultipleListeners( MouseEvent.MOUSE_UP , stopMoving , [_box22] );
			
			// Insert the listeners for the mouse cursor.
			insertCursorListeners();
			
			// Create the background stage.
			createStage();
			
			// If there's only 1 instance of the class, set the cursor.
			if ( instances == 1 )		setCursor();
			
			// Set iWidth and iHeight to the initial width and height of the object.
			iWidth = obj.width / obj.scaleX;
			iHeight = obj.height / obj.scaleY;
			
			// Shift Key down
			stage.addEventListener(KeyboardEvent.KEY_DOWN , pressKey);
			// Shift Key up
			stage.addEventListener(KeyboardEvent.KEY_UP , releaseKey);
			
			// Deselect the object.
			deselect();
		}
		
		//************************************ funIndx - FUNCTIONS ************************************//
		
		
		/********************************/
		/*                              */
		/*  fun1 - TRANSFORM FUNCTIONS  */
		/*                              */
		/********************************/
		
		/**
		 * <b>hideBoxes</b> function initializes the object given, setting it to the default object
		 * given t the function: <br /><br />
		 *
		 * @param	boxes The Object received that will be initialized.
		 */
		private function hideBoxes( boxes:Object ):void
		{
			initializeObject();
			hideBoxesObject = boxes;
		}
		
		/**
		 * <b>initializeObject</b> function initializes the hideBoxesObject, changing it's properties
		 * to the default values, that is, set the values of each of the boxes to false if it's undefined
		 * or leave it unchanged if it's true.
		 */
		private function initializeObject():void 
		{
			hideBoxesObject.box11 ||= false;
			hideBoxesObject.box12 ||= false;
			hideBoxesObject.box13 ||= false;
			hideBoxesObject.box21 ||= false;
			hideBoxesObject.box22 ||= false;
			hideBoxesObject.box23 ||= false;
			hideBoxesObject.box31 ||= false;
			hideBoxesObject.box32 ||= false;
			hideBoxesObject.box33 ||= false;
		}
		
		/**
		 * <b>destruct</b> function deletes the object, removes all it's event listeners,
		 * removes the stage's listeners and dispatchs an <code>TransformerEvent.DEACTIVATE</code>.
		 * 
		 * This will not save your object, if you want to restore your object, you need to do it in
		 * manual, this goes beyond of the scope of these instructions.
		 */
		public function destruct():void
		{
			// Deselect the object.
			deselect(false);
			// Remove mouse's event listeners
			removeCursorListeners();
			
			// Block user from selecting the object.
			_obj.removeEventListener(MouseEvent.MOUSE_UP , select_listener);
			stage.removeEventListener( MouseEvent.MOUSE_UP , unClick );
			
			// Dispatch deactivate event
			dispatchEvent( new TransformerEvent( TransformerEvent.DEACTIVATE ));
		}
		
		/**
		 * createStage function creates the backStage ( even if it's insvisible ), the stage
		 * created will serve for click listeners and if you want, you can show it via the property 
		 * of this class.
		 */
		private function createStage():void
		{
			// Clear the backStage' graphics.
			backStage.graphics.clear();
			
			/*
			 * Draws an invisible line, if the selectedAlpha property is set to higher than 0, the
			 * background will be shown, or else it will be hiden.
			 */
			BoundingBox.drawInvisibleStage(backStage , 0 , 0 , deselectArea.x , deselectArea.y , _selectedColor , _selectedAlpha);
			stage.addChild(backStage);
			
			Utils.sendToBack(backStage);
			
			backStage.addEventListener(MouseEvent.MOUSE_DOWN , startDeselect);
			_obj.addEventListener(MouseEvent.MOUSE_UP , select_listener);
		}
		
		/**
		 * <b>deselect</b> function deselects the currently selected object, if it's
		 * already deselected, the function will not have any effect.
		 * 
		 * @param dispatch Boolean value that determines if the <i>DESELECT</i> event 
		 * will be dispatched.
		 */
		public function deselect(dispatch:Boolean = true):void
		{
			// Temp variable used for checking arrays.
			var i:uint = 0;
			
			// Set everything to invisible.
			for ( i = 0 ; i < allBoxes.length ; i++ )				allBoxes[i].visible = false;
			for ( i = 0 ; i < rotationBoxes.length ; i++ )			rotationBoxes[i].visible = false;
			
			border.visible = false;
			backStage.visible = false;
			myCursor.visible = false;
			
			// Hide the mouse.
			Mouse.show();
			
			// Add event listeners for selecting the object and deleting it.
			_obj.addEventListener(MouseEvent.MOUSE_UP , select_listener);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN , deleteObj);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN , moveObjArrowKeys);
			
			// Dispatch the event:
			if ( dispatch )			dispatchEvent( new TransformerEvent( TransformerEvent.DESELECT ));
		}
		
		/**
		 * <b>select</b> function selects the object (creates border around it).
		 */
		public function select():void { select_listener(null); }
		
		/*
		 * 	This function creates all handles, the border and clear all unused graphics
		 *  using garbage collector and recycling the items by using the again in the
		 *  code.
		 */
		private function createBoxes():void
		{
			// Creates allBoxes array.
			allBoxes = [ _box11 , _box12 , _box13 , _box21 , _box22 , _box23 , _box31 , _box32 , _box33 ];
			// Same as above, but not including the box22 Sprite.
			boxes = [ _box11 , _box12 , _box13 , _box21 , _box23 , _box31 , _box32 , _box33 ];
			// The rotation boxes.
			rotationBoxes = [ rotate11 , rotate13 , rotate31 , rotate33 ];
			
			container.addChild( _obj );
			
			// Add them all again.
			Utils.addMultipleChild( container , rotationBoxes );
			Utils.addMultipleChild( container , [ border ] );
			Utils.addMultipleChild( container , allBoxes );
			
			// Garbage collection:
			clearGraphics();
			
			// Draws the border:
			BoundingBox.drawBigSquare( border , _obj.x , _obj.y , _obj.width , _obj.height , _color );
			
			// Draws all handles:
			BoundingBox.drawSmallSquare( _box11 , _obj.x , _obj.y , _size , _color );
			BoundingBox.drawSmallSquare( _box12 , _obj.x , _obj.y + _obj.height / 2 , _size , _color );
			BoundingBox.drawSmallSquare( _box13 , _obj.x , _obj.y + _obj.height , _size , _color );
			BoundingBox.drawSmallSquare( _box21 , _obj.x + _obj.width / 2 , _obj.y , _size , _color );
			BoundingBox.drawSmallCircle( _box22 , _obj.x + _obj.width / 2 , _obj.y + _obj.height / 2 , _size , _color );
			BoundingBox.drawSmallSquare( _box23 , _obj.x + _obj.width / 2 , _obj.y + _obj.height, _size , _color );
			BoundingBox.drawSmallSquare( _box31 , _obj.x + _obj.width , _obj.y , _size , _color );
			BoundingBox.drawSmallSquare( _box32 , _obj.x + _obj.width , _obj.y + _obj.height / 2 , _size , _color );
			BoundingBox.drawSmallSquare( _box33 , _obj.x + _obj.width , _obj.y + _obj.height , _size , _color );
			
			// Draws all squared invisible handles (rotation handles):
			BoundingBox.drawInvisibleSquare( rotate11 , _obj.x , _obj.y , _rotationDistance );
			BoundingBox.drawInvisibleSquare( rotate13 , _obj.x , _obj.y + _obj.height , _rotationDistance );
			BoundingBox.drawInvisibleSquare( rotate31 , _obj.x + _obj.width , _obj.y , _rotationDistance );
			BoundingBox.drawInvisibleSquare( rotate33 , _obj.x + _obj.width , _obj.y + _obj.height , _rotationDistance );
		}
		
		// Clear all graphics / Sprites:
		private function clearGraphics():void 
		{
			for ( var i:uint = 0 ; i < boxes.length ; i++ )				boxes[i].graphics.clear();
			for ( i = 0 ; i < rotationBoxes.length ; i++ )				rotationBoxes[i].graphics.clear();
			
			_box22.graphics.clear();
		}
		
		// This function updates all handles and reset their graphics.
		private function updateHandlers():void
		{
			// Try to delete the border, if operation failed, abort it.
			try				{container.removeChild(border);}
			catch (e:Error) {}
			
			// Create a new border sprite.
			border = new Sprite();
			
			// Draw border's graphics.
			BoundingBox.drawBigSquare( border , _obj.x , _obj.y , _obj.scaleX * iWidth , _obj.scaleY * iHeight , _color );
			
			// Add it to the container.
			container.addChild(border);
			
			// If hideBorder equals to true, hide the border.
			if ( hideBorder )				border.visible = false;
			
			// Send everything to back:
			Utils.sendToBack(border);
			Utils.sendToBack(_obj);
			
			Utils.sendToBack(rotate11);
			Utils.sendToBack(rotate13);
			Utils.sendToBack(rotate31);
			Utils.sendToBack(rotate33);
			
			// If it's not selected, hide the border.
			if ( !selected )				border.visible = false;
			
			/*
			 * Place all the handles in the screen, using as guide the object:
			 * 
			 * 
				 * Column = X
				 * Line = Y
			 * 
			 * 
			 * 	   _____________________________
			 * 	  |								X
			 * 	  | 	box11	box21	box31
			 * 	  | 	box12	box22	box32
			 *    | 	box13	box23	box33
			 * 	  |	Y
			 * 
			 * 
			 * Obs.: The >> operator is used for making the calculations faster
			 * (Because >> is a bitwise operator, it's faster than the normal
			 * division operator).
			 */
			_box31.x = ( _obj.scaleX * iWidth ) + _obj.x;
			_box32.x = ( _obj.scaleX * iWidth ) + _obj.x;
			_box33.x = ( _obj.scaleX * iWidth ) + _obj.x;
			
			_box21.x = ( _obj.scaleX * iWidth >> 1 ) + _obj.x;
			_box22.x = ( _obj.scaleX * iWidth >> 1 ) + _obj.x;
			_box23.x = ( _obj.scaleX * iWidth >> 1 ) + _obj.x;
			
			box11.x = _obj.x;
			box12.x = _obj.x;
			_box13.x = _obj.x;
			
			box11.y = _obj.y;
			_box21.y = _obj.y;
			_box31.y = _obj.y;
			
			box12.y = ( _obj.scaleY * iHeight >> 1 ) + _obj.y;
			_box22.y = ( _obj.scaleY * iHeight >> 1 ) + _obj.y;
			_box32.y = ( _obj.scaleY * iHeight >> 1 ) + _obj.y;
			
			_box13.y = ( _obj.scaleY * iHeight ) + _obj.y;
			_box23.y = ( _obj.scaleY * iHeight ) + _obj.y;
			_box33.y = ( _obj.scaleY * iHeight ) + _obj.y;
			
			/*
			 * Place all the rotation handles in the screen, using as guide the object:
			 * 
			 * 
				 * Column = X
				 * Line = Y
			 * 
			 * 
			 * 	   _____________________________
			 * 	  |								X
			 * 	  | 	rotate11	rotate31
			 * 	  | 						
			 *    | 	rotate13	rotate33
			 * 	  |	Y
			 * 
			 * 
			 */
			
			rotate11.x = box11.x - rotate11.width;
			rotate11.y = box11.y - rotate11.height;
			
			rotate13.x = _box13.x - rotate13.width;
			rotate13.y = _box13.y;
			
			rotate31.x = _box31.x;
			rotate31.y = _box31.y - rotate31.height;
			
			rotate33.x = _box33.x;
			rotate33.y = _box33.y;
			
			Utils.alignToCenter( boxes );
		}
		
		
		
		/*****************************/
		/*                           */
		/*  fun2 - CURSOR FUNCTIONS  */
		/*                           */
		/*****************************/
		
		
		/**
		 * setCursor function adds the cursor to the stage, send it to the actual mouseX and
		 * mouseY, after, it initializes the EasyCursorLite© class.
		 */
		private function setCursor():void
		{
			myCursor.x = stage.mouseX;
			myCursor.y = stage.mouseY;
			
			stage.addChild(myCursor);
			
			Utils.sendToFront(myCursor);
			EasyCursorLite.setCursor( myCursor );
		}
		
		// Insert cursor's listeners for changing keyframe.
		private function insertCursorListeners():void
		{
			Utils.addMultipleListeners( MouseEvent.ROLL_OVER , changeCursor , allBoxes );
			_obj.addEventListener( MouseEvent.ROLL_OVER , changeCursor );
			Utils.addMultipleListeners( MouseEvent.ROLL_OVER , changeCursor , rotationBoxes );
			
			Utils.addMultipleListeners( MouseEvent.ROLL_OUT , resetCursor , allBoxes );
			_obj.addEventListener( MouseEvent.ROLL_OUT , resetCursor );
			Utils.addMultipleListeners( MouseEvent.ROLL_OUT , resetCursor , rotationBoxes );
		}
		
		// Remove cursor's listeners.
		private function removeCursorListeners():void
		{
			Utils.removeMultipleListeners( MouseEvent.ROLL_OVER , changeCursor , allBoxes );
			_obj.removeEventListener( MouseEvent.ROLL_OVER , changeCursor );
			Utils.removeMultipleListeners( MouseEvent.ROLL_OVER , changeCursor , rotationBoxes );
			
			Utils.removeMultipleListeners( MouseEvent.ROLL_OUT , resetCursor , allBoxes );
			_obj.removeEventListener( MouseEvent.ROLL_OUT , resetCursor );
			Utils.removeMultipleListeners( MouseEvent.ROLL_OUT , resetCursor , rotationBoxes );
		}
		
		public function removeTransform():void 
		{
			try				{ container.parent.removeChild(container); }
			catch (e:Error) {}
		}
		
		//************************************ eveIndx - LISTENERS ************************************//
		
		
		
		/*****************************/
		/*                           */
		/* 	  eve1 - MOUSE_EVENTS    */
		/*                           */
		/*****************************/
		
		
		/*
		 * Listener for start drag of the object:
		 * 
		 * 		- First, remove eventListener for stage mouse up;
		 * 		- Add an event listener for object move;
		 * 		- Start drag of the object;
		 * 		- Dispatch a new DRAG_START event;
		 */
		private function startMoving(e:MouseEvent):void 
		{
			stage.removeEventListener( MouseEvent.MOUSE_UP , unClick );
			stage.removeEventListener(KeyboardEvent.KEY_DOWN , moveObjArrowKeys);
			stage.addEventListener( MouseEvent.MOUSE_MOVE , moving );
			stage.addEventListener( Event.MOUSE_LEAVE , stopMoving );
			
			container.startDrag();
			dispatchEvent( new TransformerEvent( TransformerEvent.DRAG_START ));
		}
		
		// Only dispatchs an DRAG_MOUSE_MOVE event:
		private function moving(e:MouseEvent):void 
		{dispatchEvent( new TransformerEvent( TransformerEvent.DRAG_MOUSE_MOVE ));}
		
		/*
		 * This function is responsible for changing the current frame of the
		 * mouse MovieClip and rotate it as needed.
		 */
		private function changeCursor(e:MouseEvent):void
		{
			// If handle is selected, apply certain rotation to the mouse cursor:
			if ( e.target == rotate11 )						myCursor.rotation = -90;
			else if ( e.target == rotate13 )				myCursor.rotation = 180;
			else if ( e.target == rotate33 )				myCursor.rotation = 90;
			
			// Add the container's rotation to the cursor.
			myCursor.rotation += container.rotation;
			
			// If object is inverted (360º)
			if ( _obj.width * _obj.scaleX < 0 && ( e.target != box12 && e.target != _box21 && e.target != _box32 && e.target != _box23 ) )
				myCursor.rotation += 90;
			if ( _obj.height * _obj.scaleY < 0 && ( e.target != box12 && e.target != _box21 && e.target != _box32 && e.target != _box23 )  )
				myCursor.rotation += 90;
			
			// Now set the actual keyFrame of the mouse Cursor:
			if ( e.target == box11 || e.target == _box33 )				myCursor.gotoAndStop(4);
			else if ( e.target == _box13 || e.target == _box31 )		myCursor.gotoAndStop(3);
			else if ( e.target == box12 || e.target == _box32 )			myCursor.gotoAndStop(2);
			else if ( e.target == _box21 || e.target == _box23 )		myCursor.gotoAndStop(5);
			else if ( e.target == _obj || e.target == _box22 )
			{
				myCursor.rotation = 0;
				myCursor.gotoAndStop(6);
			}
			else if ( e.target == rotate11 || e.target == rotate13 || e.target == rotate31 || e.target == rotate33 )
				myCursor.gotoAndStop(7);
		}
		
		/*
		 * Select the actual object, to use this function outside the class, use the select() function,
		 * the select() function will call this listener with an 'e' value of null.
		 */
		private function select_listener(e:MouseEvent):void 
		{
			// Return the cursor to it's default:
			setCursor();
			
			// Create a counter variable
			var i:uint = 0;
			
			// If the object can be scaled, create the scale handles.
			if ( allowScale )
			{
				for ( i = 0 ; i < allBoxes.length ; i++ )
					allBoxes[i].visible = true;
				
				if ( hideCornerHandles )
				{
					_box11.visible = false;
					_box13.visible = false;
					_box31.visible = false;
					_box33.visible = false;
				}
				
				if ( hideSideHandles )
				{
					_box12.visible = false;
					_box21.visible = false;
					_box23.visible = false;
					_box32.visible = false;
				}
			}
			
			if ( hideBoxesObject.box11 )	_box11.visible = false;
			if ( hideBoxesObject.box12 )	_box12.visible = false;
			if ( hideBoxesObject.box13 )	_box13.visible = false;
			if ( hideBoxesObject.box21 )	_box21.visible = false;
			if ( hideBoxesObject.box22 )	_box22.visible = false;
			if ( hideBoxesObject.box23 )	_box23.visible = false;
			if ( hideBoxesObject.box31 )	_box31.visible = false;
			if ( hideBoxesObject.box32 )	_box32.visible = false;
			if ( hideBoxesObject.box33 )	_box33.visible = false;
			
			// Hide the center circle if wanted.
			if ( !showCenterCircle )
				_box22.visible = false;
			
			// If rotating is not allowed, hide the rotation handles.
			if ( allowRotate )
			{
				for ( i = 0 ; i < rotationBoxes.length ; i++ )
					rotationBoxes[i].visible = true;
			}
			
			// Hide border
			if ( hideBorder )
				border.visible = false;
			else
				border.visible = true;
			
			// Show the background ( backStage object ).
			backStage.visible = true;
			
			// Send everything to the front:
			Utils.sendToFront( backStage );
			Utils.sendToFront( container );
			Utils.sendToFront( myCursor );
			
			// Show cursor
			myCursor.visible = true;
			
			// set selected object to actual obj.
			selected = _obj;
			
			// If object is draggable, add the listeners.
			if ( _allowDrag )
			{
				_obj.addEventListener( MouseEvent.MOUSE_DOWN , startMoving );
				_obj.addEventListener( MouseEvent.MOUSE_UP , stopMoving );
			}
			
			// Update handles graphics
			updateHandlers();
			
			// Add stage listener for deleting object ( press DELETE key ).
			stage.addEventListener(KeyboardEvent.KEY_DOWN , deleteObj);
			stage.addEventListener(KeyboardEvent.KEY_DOWN , moveObjArrowKeys);
			// Removes the listener for selecting the obj, since it's already selected.
			_obj.removeEventListener(MouseEvent.MOUSE_UP , select_listener);
			
			// Dispatch an SELECT event.
			dispatchEvent( new TransformerEvent( TransformerEvent.SELECT ));
		}
		
		// Reset the cursor keyFrame and it's rotation.
		private function resetCursor(e:MouseEvent):void
		{
			myCursor.rotation = 0;
			myCursor.gotoAndStop(1);
		}
		
		// Listener to be called when the user clicks in one of the scale handles.
		private function resizeClicked(e:MouseEvent):void
		{
			// Add again the event listener for "unclicking"
			stage.addEventListener( MouseEvent.MOUSE_UP , unClick );
			stage.removeEventListener(KeyboardEvent.KEY_DOWN , moveObjArrowKeys);
			
			// Set the selected object as the target of the event.
			selected = DisplayObject(e.target);
			// Set conRot to the container's rotation
			conRot = container.rotation;
			
			// If the selected object is one of the first column, add the actual inside obj's width
			// and x values into the container.
			if ( selected == box12 || selected == _box13 || selected == box11 )
			{
				container.x += iWidth * _obj.scaleX * Math.cos(toRad(container.rotation));
				container.y += iWidth * _obj.scaleX * Math.sin(toRad(container.rotation));
			}
			// Same as above, but using the height property and inverting sin and cos.
			if ( selected == _box21 || selected == _box31 || selected == box11 )
			{
				container.x -= iHeight * _obj.scaleY * Math.sin(toRad(container.rotation));
				container.y += iHeight * _obj.scaleY * Math.cos(toRad(container.rotation));
			}
			
			// Dispatch an SCALE_START event.
			dispatchEvent( new TransformerEvent( TransformerEvent.SCALE_START ));
			
			// Remove all mouse's listeners
			removeCursorListeners();
			
			// Add an listener on ENTER_FRAME for the stage.
			stage.addEventListener(Event.ENTER_FRAME , resizeListener);
			
			// Update all handles
			updateHandlers();
		}
		
		/*
		 * 
		 * Listener to be called when the user clicks on any of the rotation handles
		 * around the object. 
		 * 
		 * The trigonometrical functions and math explanation is beyond the scope of 
		 * these instructions.
		 */
		private function rotationClicked(e:MouseEvent):void
		{
			// Add the event for finishing the click.
			stage.addEventListener( MouseEvent.MOUSE_UP , unClick );
			stage.removeEventListener(KeyboardEvent.KEY_DOWN , moveObjArrowKeys);
			
			// Set the selected target as the selected object.
			selected = DisplayObject(e.target);
			
			// if obj's scaleX is higher than 0
			if ( _obj.scaleX > 0 )
			{
				/* Decrease it's values in half, that means it will take the obj inside
				 * the container and set it to half it's width and half it's height.
				 *
				 *
				 *    ___________            ________
				 *   | container |          |     ___|_________
				 *   |  ______   |          | obj|   |         |
				 *   | |      |  |  --->    |____|___|         |
				 *   | | obj  |  |          	 |  container  |
				 *   | |______|  |               |_____________|
				 *   |___________|          
				 * 
				 * 
				 * 	- Center of the object is aligned with the upper-left point of the 
				 *    container (where it's x and y values are 0).
				 */
				_obj.x -= _obj.width / 2;
				_obj.y -= _obj.height / 2;
				
				/*
				 * 
				 * The increase the container's x and y values to look like the object 
				 * didn't move at all, but the inside was changed for the rotation.
				 * 
				 *    ___________            ________
				 *   | container |          |     ___|_________
				 *   |  ______   |          | obj|   |         |             ________
				 *   | |      |  |  --->    |____|___|         |   --->		|     ___|_________
				 *   | | obj  |  |          	 |  container  |            | obj|   |         |
				 *   | |______|  |               |_____________|            |____|___|         | 
				 *   |___________|                                               |  container  |
				 *                                                               |_____________|  
				 * 
				 *  obj.x = 0;					obj.x = -50;					obj.x = -50;
				 *  container.x = 100;			container.x = 100;				container.x = 50;
				 * 
				 */
				container.x += ( _obj.width * Math.cos(toRad(container.rotation)) - _obj.height * Math.sin(toRad(container.rotation)) ) / 2;
				container.y += ( _obj.height * Math.cos(toRad(container.rotation)) + _obj.width * Math.sin(toRad(container.rotation)) ) / 2;
			}
			else
			{
				// If object's scaleX is lower than 0, make it flip around and do the
				// same thing as above.
				_obj.x += _obj.width / 2;
				_obj.y -= _obj.height / 2;
				
				container.x -= ( _obj.width * Math.cos(toRad(container.rotation)) - _obj.height * Math.sin(toRad(container.rotation)) ) / 2;
				container.y += ( _obj.height * Math.cos(toRad(container.rotation)) + _obj.width * Math.sin(toRad(container.rotation)) ) / 2;
			}
			
			// Dispatch an ROTATE_START event
			dispatchEvent( new TransformerEvent( TransformerEvent.ROTATE_START ));
			
			// Add the enterframe listener for the stage.
			stage.addEventListener(Event.ENTER_FRAME , rotateListener);
			
			removeCursorListeners();
			
			myCursor.gotoAndStop(7);
			updateHandlers();
		}
		
		// Listener for when the mouse is up anywhere in the stage.
		private function unClick(e:MouseEvent):void
		{
			// If you selected one of the rotation handles . . .
			if ( selected == rotate11 || selected == rotate13 || selected == rotate31 || selected == rotate33 )
			{
				// Return the object to it's initial position
				_obj.x += _obj.width / 2;
				_obj.y += _obj.height / 2;
				
				// Return the container to it's initial position
				container.x -= ( _obj.width * Math.cos(toRad(container.rotation)) - _obj.height * Math.sin(toRad(container.rotation)) ) / 2;
				container.y -= ( _obj.height * Math.cos(toRad(container.rotation)) + _obj.width * Math.sin(toRad(container.rotation)) ) / 2;
				
				// Restart the mouse's graphics
				myCursor.gotoAndStop(1);
				myCursor.rotation = 0;
				
				updateHandlers();
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN , moveObjArrowKeys);
				
				// Dispatch an ROTATE_END listener
				dispatchEvent( new TransformerEvent( TransformerEvent.ROTATE_END ));
			}
			else
			{
				// . . . Or else reset it's properties.
				_obj.x = 0;
				_obj.y = 0;
			}
			
			/*
			 * 
			 *  If the user is selecting one of the left handles ( 11 || 12 || 13 ), the object is
			 *  placed on the left of the container to be resized, after that, it's returned to it's 
			 *  original position without the user noticing:
			 * 
			 * 
			 *    ___________           							     ___________
			 *   | container |                 ____________		        | container |
			 *   |  ______   |         ______ |            |            |  ______   |
			 *   | |      |  |  --->  |      ||            |   --->		| |      |  |
			 *   | | obj  |  |        | obj  || container  |            | | obj  |  |
			 *   | |______|  |        |______||____________|            | |______|  |
			 *   |___________|                                          |___________|
			 * 
			 * 
			 * 
			 *  If the user is selecting one of the up handles ( 11 || 21 || 31 ), the object is
			 *  placed above of the container to be resized, after that, it's returned to it's 
			 *  original position without the user noticing:
			 * 
			 *                                 _____
			 *    ___________                 |		|			     	 ___________
			 *   | container |            	  | obj |                   | container |
			 *   |  ______   |                |_____|                   |  ______   |
			 *   | |      |  |  --->       ____________	       --->	    | |      |  |
			 *   | | obj  |  |            |            |                | | obj  |  |
			 *   | |______|  |            |            |                | |______|  |
			 *   |___________|            | container  |                |___________|
			 *                            |____________|
			 * 
			 * 
			 * 
			 */
			if ( selected == box12 || selected == _box13 || selected == box11 )
			{
				container.x -= iWidth * _obj.scaleX * Math.cos(toRad(container.rotation));
				container.y -= iWidth * _obj.scaleX * Math.sin(toRad(container.rotation));
				
				updateHandlers();
			}
			if ( selected == _box21 || selected == _box31 || selected == box11 )
			{
				container.x += iHeight * _obj.scaleY * Math.sin(toRad(container.rotation));
				container.y -= iHeight * _obj.scaleY * Math.cos(toRad(container.rotation));
				
				updateHandlers();
			}
			
			// If selected is one of the resizing boxes, dispatch an SCALE_END event.
			if ( selected == box11 || selected == box12 || selected == _box13 || selected == _box21 || selected == _box23 || selected == _box31 || selected == _box32 || selected == _box33  )
			{
				myCursor.rotation = 0;
				myCursor.gotoAndStop(1);
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN , moveObjArrowKeys);
				
				dispatchEvent( new TransformerEvent( TransformerEvent.SCALE_END ));
			}
			
			// If the target is not the stage, update the handles, this is used for when the 
			// user selects another object on stage that isn't an transformer object, this
			// will make the object to update and if the user clicked out, deselect the
			// object and add the listeners needed for returning. ( causing bugs, uncomment
			// will cause the borders of the object to disapear.
			//if ( e.target != stage )
				//updateHandlers();
			
			insertCursorListeners();	
			
			// Stop rotating or stop resizing
			stage.removeEventListener(Event.ENTER_FRAME , resizeListener);
			stage.removeEventListener(Event.ENTER_FRAME , rotateListener);
			
			// There isn't an selected object anymore.
			selected = null;
		}
		
		// Deselects the main object target of the transformation.
		private function startDeselect(e:MouseEvent):void {deselect();}
		
		/*****************************/
		/*                           */
		/* 	     eve2 - EVENTS       */
		/*                           */
		/*****************************/
		
		// This function is for when the user releases the object and stop dragging it.
		private function stopMoving(e:Event):void 
		{
			// Remove listener for throwing the event
			stage.removeEventListener( MouseEvent.MOUSE_MOVE , moving );
			stage.removeEventListener( Event.MOUSE_LEAVE , stopMoving );
			stage.addEventListener(KeyboardEvent.KEY_DOWN , moveObjArrowKeys);
			
			// Stop drag.
			container.stopDrag();
			
			// Dispatch the DRAG_END event, it can be manipulated by the MainTimeline.
			dispatchEvent( new TransformerEvent( TransformerEvent.DRAG_END ));
		}
		
		/*
		 * 
		 * This is the most complex function in the class, it's responsible for resizing the object
		 * on enterFrame, please, read all the information above before trying to understand this.
		 * 
		 * Most part of this function is simple trigonometry and simple mathematical functions, such
		 * as SIN, COS, TAN, ATAN and some boolean.
		 * 
		 */
		private function resizeListener(e:Event):void
		{
			// Create instances for where is the mouse.
			var mouseX:Number = stage.mouseX;
			var mouseY:Number = stage.mouseY;
			
			/*
			 * 
			 *  The variable 'a' will hold the value for the object to resize on the horizontal(right), 
			 *  the 'b' variable is for resizing vertical(down), 'c' is for resizing horizontal(left),
			 *  'd' is for resizing vertical(up).
			 * 
			 *  First, it subtracts a value to find out the position of the box relative to the mouse 
			 *  position, then it multiplies by the actual cos of the rotation of the object, then it
			 *  adds or subtracts the same value but for the sin of the object.
			 * 
			 *  If the object is on 0º (no rotation), the sin will be 0 and the cos will be 1, this 
			 *  means that the object will follow the mouse directly.
			 * 
			 */
			var a:Number = ( mouseX - container.x ) * Math.cos(toRad(conRot)) + ( mouseY - container.y ) * Math.sin(toRad(conRot));
			var b:Number = ( mouseY - container.y ) * Math.cos(toRad(conRot)) - ( mouseX - container.x ) * Math.sin(toRad(conRot));
			var c:Number = ( container.x - mouseX ) * Math.cos(toRad(conRot)) + ( container.y - mouseY ) * Math.sin(toRad(conRot));
			var d:Number = ( container.y - mouseY ) * Math.cos(toRad(conRot)) - ( container.x - mouseX ) * Math.sin(toRad(conRot));
			
			// Apply the variables using obj.scaleX to have more later control of the obj's width and
			// height without having to store them in a variable.
			if ( selected == _box32 || selected == _box33 || selected == _box31 )
				_obj.scaleX = a / iWidth;
			if ( selected == _box23 || selected == _box33 || selected == _box13 )
				_obj.scaleY = b / iHeight;
			
			// NOTE: if you're confused about this next part, read the unClick method and see the drawings
			// for what happens when the user resizes the object to the left or up.
			
			if ( selected == box12 || selected == _box13 || selected == box11 )
			{
				_obj.scaleX = ( c / iWidth );
				_obj.x = -( _obj.scaleX * iWidth );
			}
			if ( selected == _box21 || selected == _box31 || selected == box11 )
			{
				_obj.scaleY = ( d / iHeight );
				_obj.y = -( _obj.scaleY * iHeight );
			}
			
			// If the user is holding the shift key or you want the object to be resized proportionally,
			// make the scaleY equals to the scaleX of the object.
			
			if ( forceScaleProportion || ( allowScaleProportion && constrain &&  ( selected != box12 && selected != _box21 && selected != _box32 && selected != _box23 ) ) )
				_obj.scaleY = _obj.scaleX;
			if ( ( forceScaleProportion || ( allowScaleProportion && constrain ) ) && ( selected == box11 || selected == _box31 ) )
				_obj.y = -( _obj.scaleY * iHeight );
			
			
			// The minimum width and height the object can be, if it's lower than the defined, make it
			// as the defined.
			
			if ( _obj.scaleX < 0 )
			{
				_obj.scaleX = 0;
				
				if ( selected == box11 || selected == box12 || selected == _box13 )
					_obj.x = -iWidth * _obj.scaleX;
				else
					_obj.x = 0;
			}
			if ( _obj.scaleY < 0 )
			{
				_obj.scaleY = 0;
				
				if ( selected == box11 || selected == _box21 || selected == _box31 )
					_obj.y = -iHeight * _obj.scaleY;
				else
					_obj.y = 0;
			}
			
			if ( _obj.width < minWidth )
			{
				_obj.width = minWidth;
				
				if ( selected == box11 || selected == box12 || selected == _box13 )
					_obj.x = -iWidth * _obj.scaleX;
				else
					_obj.x = 0;
			}
			if ( _obj.height < minHeight )
			{
				_obj.height = minHeight;
				
				if ( selected == box11 || selected == _box21 || selected == _box31 )
					_obj.y = -iHeight * _obj.scaleY;
				else
					_obj.y = 0;
			}
			
			// Same thing but for the maximum width and height values.
			if ( _obj.width > maxWidth )
			{
				_obj.width = maxWidth;
				
				if ( selected == box11 || selected == box12 || selected == _box13 )
					_obj.x = -iWidth * _obj.scaleX;
				else
					_obj.x = 0;
			}
			if ( _obj.height > maxHeight )
			{
				_obj.height = maxHeight;
				
				if ( selected == box11 || selected == _box21 || selected == _box31 )
					_obj.y = -iHeight * _obj.scaleY;
				else
					_obj.y = 0;
			}
			
			// Finally update the handles for their x/y positions relative to the new position
			// of the object.
			updateHandlers();
			
			// Dispatch the SCALE_ENTER_FRAME event.
			dispatchEvent( new TransformerEvent( TransformerEvent.SCALE_ENTER_FRAME ));
		}
		
		/*
		 * 
		 *  This function is for when the object is being rotated, if you're confused on how the 
		 *  rotation works, read the rotationClicked function (line 968).
		 * 
		 */
		private function rotateListener(e:Event):void 
		{
			// First, set the angle variables to the atan2 of the object's height divided by 2 and the
			// negative of the obj's width divided by 2, the bitwise operators are used just for faster 
			// overall performance of the function.
			var angle00:Number =  toDegrees( Math.atan2( ( _obj.height << 1 ) , ( ~_obj.width + 1 << 1 ) ) );
			var angle01:Number =  toDegrees( Math.atan2( ( ~_obj.height + 1 << 1 ) , ( ~_obj.width + 1 << 1 ) ) );
			var angle10:Number =  toDegrees( Math.atan2( ( _obj.height << 1 ) , ( _obj.width << 1 ) ) );
			var angle11:Number =  toDegrees( Math.atan2( ( ~_obj.height + 1 << 1 ) , ( _obj.width << 1 ) ) );
			
			// Rotate the obj following the mouse.
			if ( selected == rotate11 )
				container.rotation = angle00 + toDegrees( Math.atan2( stage.mouseY - container.y , stage.mouseX - container.x ));
			if ( selected == rotate13 )
				container.rotation = angle01 + toDegrees( Math.atan2( stage.mouseY - container.y , stage.mouseX - container.x ));
			if ( selected == rotate31 )
				container.rotation = angle10 + toDegrees( Math.atan2( stage.mouseY - container.y , stage.mouseX - container.x ));
			if ( selected == rotate33 )
				container.rotation = angle11 + toDegrees( Math.atan2( stage.mouseY - container.y , stage.mouseX - container.x ));
			
			// If the shift key is pressed or the forceRotateProportion property is set to true, rotate
			// the object in increments of 45 degrees.
			if ( forceRotateProportion || ( allowRotateProportion && constrain ) )
			{
				if ( container.rotation >= -22.5 && container.rotation <= 22.5 )			container.rotation = 0;
				else if ( container.rotation >= 22.5 && container.rotation <= 67.5 )		container.rotation = 45;
				else if ( container.rotation >= 67.5 && container.rotation <= 112.5 )		container.rotation = 90;
				else if ( container.rotation >= 112.5 && container.rotation <= 157.5 )		container.rotation = 135;
				else if ( container.rotation >= 157.5 || container.rotation <= -157.5 )		container.rotation = 180;
				else if ( container.rotation >= -157.5 && container.rotation <= -112.5 )	container.rotation = 225;
				else if ( container.rotation >= -112.5 && container.rotation <= -67.5 )		container.rotation = 270;
				else if ( container.rotation >= -67.5 && container.rotation <= -22.5 )		container.rotation = 315;
			}
			
			// Set cursor's rotation equals to the obj's container rotation.
			myCursor.rotation = container.rotation;
			
			// Update the cursor basedon the selected handle.
			if ( selected == rotate11 )						myCursor.rotation += -90;
			else if ( selected == rotate13 )				myCursor.rotation += 180;
			else if ( selected == rotate33 )				myCursor.rotation += 90;
			
			// Dispatch the ROTATE_ENTER_FRAME event.
			dispatchEvent( new TransformerEvent( TransformerEvent.ROTATE_ENTER_FRAME ));
		}
		
		
		/*****************************/
		/*                           */
		/* 	eve3 - KEYBOARD_EVENTS   */
		/*                           */
		/*****************************/
		
		// If the user presses the SHIFT key, set the constrain to true.
		private function pressKey( e:KeyboardEvent ):void
		{
			if ( e.keyCode == 16 )
				constrain = true;
		}
		
		// When any key is released, set constrain to false.
		private function releaseKey( e:KeyboardEvent ):void
		{
			if ( e.keyCode == 16 )
				constrain = false;
		}
		
		// If the key pressed is 46 ( DELETE ), dispatch an event and destroy the object.
		private function deleteObj(e:KeyboardEvent):void 
		{
			if ( e.keyCode == 46 && allowDelete )
			{
				dispatchEvent( new TransformerEvent( TransformerEvent.DELETE ));
				container.parent.removeChild(container);
			}
		}
		
		private function moveObjArrowKeys(e:KeyboardEvent):void
		{
			if ( allowIncrements )
			{
				if ( e.keyCode == 39 )
				{
					if ( constrain )
						container.x += keysIncrement * 10;
					else
						container.x += keysIncrement;
				}
				else if ( e.keyCode == 37 )
				{
					if ( constrain )
						container.x -= keysIncrement * 10;
					else
						container.x -= keysIncrement;
				}
				else if ( e.keyCode == 40 )
				{
					if ( constrain )
						container.y += keysIncrement * 10;
					else
						container.y += keysIncrement;
				}
				else if ( e.keyCode == 38 )
				{
					if ( constrain )
						container.y -= keysIncrement * 10;
					else
						container.y -= keysIncrement;
				}
			}
		}
		
		//************************************ utiIndx - UTILS ************************************//
		
		// Convert from degrees to Radians.
		private function toRad(a:Number):Number			{ return a * Math.PI / 180; }
		// The oposite as above, convert radians to degrees.
		private function toDegrees(a:Number):Number		{return a * 180 / Math.PI;}
		
		//********************************** gsIndx - GETS AND SETS **********************************//
		
		
		/*****************************/
		/*                           */
		/* 	      gs1 - GETS         */
		/*                           */
		/*****************************/
		
		/**
		 * 	The box variables are the actual handles that appear, you can get all their 
		 *  properties, but you can't change any of them.
		 */
		public function get box11():Sprite 				{return _box11;}
		public function get box12():Sprite 				{return _box12; }
		public function get box13():Sprite 				{return _box13; }
		public function get box21():Sprite				{return _box21; }
		public function get box22():Sprite				{return _box22; }
		public function get box23():Sprite				{return _box23; }
		public function get box31():Sprite				{return _box31; }
		public function get box32():Sprite				{return _box32; }
		public function get box33():Sprite				{ return _box33; }
		/**
		 * 	The rotate variables are the actual invisible rotation handles, you can get 
		 *  all their properties, but you can't change any of them.
		 */
		public function get rotate11():Sprite 			{return _rotate11;}
		public function get rotate13():Sprite		 	{return _rotate13;}
		public function get rotate31():Sprite		 	{return _rotate31;}
		public function get rotate33():Sprite 			{ return _rotate33; }
		/**
		 * Allows the object to be dragged, set it to true if you want the user to be able to drage the object.
		 */
		public function get allowDrag():Boolean 		{ return _allowDrag; }
		/**
		 * Size of the handles, please set it to a value higher than 5, since it gets really difficult to the
		 * user to drag a handle smaller than that.
		 */
		public function get size():Number 				{ return _size; }
		/**
		 * The area of the hittest for the rotation handle, it's basically how far does the user need to point 
		 * the mouse to rotate the object.
		 */
		public function get rotationDistance():Number 	{ return _rotationDistance; }
		/**
		 * <b>Colors</b> of the lines around the handles, you can change this anytime you want, but the object 
		 * will only be updated when it's deselected and selected again.
		 */
		public function get color():Number 				{ return _color; }
		/**
		 * <b>Color</b> of the background behind the object, it can only be seen by changing setting selectedAlpha
		 * to higher than 0.
		 */
		public function get selectedColor():Number 		{ return _selectedColor; }
		/**
		 * <b>Alpha</b> value of the background behind the object, changing it, will appear that the object entered
		 * 'cropping mode'.
		 */
		public function get selectedAlpha():Number 		{ return _selectedAlpha; }
		/**
		 * The actual <b>target</b> of the transformation.
		 */
		public function get obj():DisplayObject 		{ return _obj; }
		
		public function get x():Number 
		{return container.x;}
		
		public function get y():Number 
		{return container.y;}
		
		public function get rotation():Number 
		{return container.rotation; }
		
		public function get width():Number 
		{return obj.width; }
		
		public function get height():Number 
		{return obj.height;}
		
		
		
		/*****************************/
		/*                           */
		/* 	      gs2 - SETS         */
		/*                           */
		/*****************************/
		
		public function set x(value:Number):void 			{ container.x = value; }
		public function set y(value:Number):void 			{ container.y = value; }
		public function set rotation(value:Number):void 	{ container.rotation = value; }
		public function set width(value:Number):void 		{ container.width = value; }
		public function set height(value:Number):void 		{ container.height = value; }
		
		
		public function set size(value:Number):void 
		{
			_size = value;
			createBoxes();
		}
		
		public function set color(value:Number):void 
		{
			_color = value;
			createBoxes();
		}
		
		public function set selectedColor(value:Number):void 
		{
			_selectedColor = value;
			createStage();
		}
		
		public function set selectedAlpha(value:Number):void 
		{
			_selectedAlpha = value;
			createStage();
		}
		
		public function set rotationDistance(value:Number):void 
		{
			_rotationDistance = value;
			createBoxes();
		}
		
		public function set allowDrag(value:Boolean):void 
		{
			_allowDrag = value;
			
			_box22.removeEventListener( MouseEvent.MOUSE_DOWN , startMoving );
			_box22.removeEventListener( MouseEvent.MOUSE_UP , stopMoving );
			obj.removeEventListener( MouseEvent.MOUSE_DOWN , startMoving );
			//obj.removeEventListener( MouseEvent.MOUSE_UP , stopMoving );
			
			//obj.removeEventListener( MouseEvent.MOUSE_UP , unClick );
			//stage.removeEventListener( MouseEvent.MOUSE_UP , unClick );
		}
		
		
		
		
	}
}