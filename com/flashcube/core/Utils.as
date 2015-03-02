package com.flashcube.core
{	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	public class Utils extends MovieClip
	{
		
		//*********************************** CONSTRUCTOR ***********************************//
		
		/*
		 *  The Utils class only uses static functions, therefore, its Constructor throws 
		 *  an error if you try to instantiate it.
		 * 
		 *  The class contains useful functions to organize your code, adding multiple child,
		 *  adding multiple listeners at once, align object to it's center, convert from radians
		 *  to degrees and from degrees to radians, it can also round the position of all objects
		 *  in the main stage, making them less blurry.
		 */
		
		public function Utils()
		{throw new Error("Can't create an instance of static class Utils."); }
		
		//************************************ FUNCTIONS ************************************//
		
		// Sends the DisplayObject received to the top of DisplayObjects pile.
		public static function sendToFront( target:DisplayObject ):void
		{target.parent.setChildIndex(target, target.parent.numChildren - 1);}
		
		// Sends the DisplayObject received to the bottom of DisplayObjects pile.
		public static function sendToBack( target:DisplayObject ):void
		{target.parent.setChildIndex(target, 0);}
		
		// Adds multiple child, us it this way:
		// 		
		//		addMultipleChild( stage , [ myObj , myObj2 ] );
		//
		// Or if you don't want to add it to the stage, you can cast the DisplayObjectContainer
		// type to avoid compiling errors.
		//
		//		addMultipleChild( DisplayObjectContainer(myContainer) , [ myObj , myObj2 ] );
		//
		public static function addMultipleChild( target:DisplayObjectContainer , params:Array ):void
		{
			for ( var i:uint = 0 ; i < params.length ; i ++ )
				target.addChild(params[i]);
		}
		
		// Adds an event to multiple objects, use it this way:
		//
		//		addMultipleListeners( MouseEvent.CLICK , myFunction , [ myObj , myObj2 ] );
		//
		// You can also store an array of objects to recicle the use of this function and
		// write less code:
		//
		// 		var myObjArray:Array = [ myObj , myObj2 , myObj3 ];
		//
		//		addMultipleListeners( MouseEvent.CLICK , myFunction , myObjArray );
		//		addMultipleListeners( MouseEvent.MOUSE_DOWN , myFunction , myObjArray );
		//		addMultipleListeners( MouseEvent.MOUSE_UP , myFunction , myObjArray );
		//
		public static function addMultipleListeners( event:* , func:Function , params:Array ):void
		{
			for ( var i:uint = 0 ; i < params.length ; i ++ )
				params[i].addEventListener( event , func );
		}
		
		// Same as above, but removes the event listeners.
		public static function removeMultipleListeners( event:* , func:Function , params:Array ):void
		{
			for ( var i:uint = 0 ; i < params.length ; i ++ )
				params[i].removeEventListener( event , func );
		}
		
		/*
		 *   Aligns an object to its center:
		 * 
		 * 
		 *       obj              obj
		 *    +_______          _______
		 *    |       |        |       |          
		 *    |       |        |       |
		 *    |       |        |   +   |
		 *    |       |        |       |
		 *    |_______|        |_______|
		 * 
		 *   
		 *    +  ->  Center Point
		 * 
		 * 
		 */
		
		public static function alignToCenter( targets:Array ):void
		{
			for ( var i:uint = 0 ; i < targets.length ; i ++ )
			{
				targets[i].x -= targets[i].width >> 1;
				targets[i].y -= targets[i].height >> 1;
			}
		}
		
		// Convert from degrees to radians.
		public static function toRad(a:Number):Number
		{return a * Math.PI / 180;}
		
		// Convert from radians to degrees.
		public static function toDegrees(a:Number):Number
		{return a * 180 / Math.PI; }
		
		/*
		 * 
		 * This function rounds the value of x and y properties of all the objects in
		 * the stage or inside an movieClip.
		 * 
		 * Usage:
		 * 
		 * 		roundAllPosition( stage );
		 * 
		 * If you don't want to show any log, use:
		 * 
		 * 		roundAllPosition( stage , false );
		 * 
		 * The message log shows important information about the objects that were moved,
		 * how much were they moved and some other useful information.
		 * 
		 */
		public static function roundAllPosition(e:* , showMessageLog:Boolean = true):void
		{
			for ( var i:uint = 0 ; i < e.numChildren ; i ++ )
			{
				var tempObj:DisplayObject = e.getChildAt(i);
				
				if ( showMessageLog ) trace( "[" , tempObj.name , "] Old Coordinates: \t\t\tx:" , tempObj.x , "\t\t\ty:" , tempObj.y );
				
				tempObj.x = Math.round(e.getChildAt(i).x);
				tempObj.y = Math.round(e.getChildAt(i).y);
				
				if ( showMessageLog ) trace( "[" , tempObj.name , "] New Coordinates: \t\t\tx:" , tempObj.x , "\t\t\t\ty:" , tempObj.y , "\n" );
			}
		}
	}
}