package com.flashcube.core
{	
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	/**
	 *  This class is used for creating graphics inside an Sprite, it's used for less code in the main class
	 *  file, you can use this class as you want, detailed instructions in the Instructions file.
	 * 
	 *  @author Joseph Stenhouse
	 */
	
	public class EasyCursorLite
	{

		//*********************************** CONSTRUCTOR ***********************************//
		
		/*
		 *  The EasyCursorLite class only uses static functions, therefore, is Constructor throws 
		 *  an error if you try to instantiate it.
		 */
		public function EasyCursorLite()
		{throw new Error("Can't create an instance of static class EasyCursorLite."); }
		
		//************************************ FUNCTIONS ************************************//
		
		/*
		 *   This is the only method of this class, it sets the DisplayObject parameter received
		 *   as the custom mouse cursor, it hides the original cursor and adds some animation for
		 *   when the mouse leaves the screen and when it returns.
		 */
		
		public static function setCursor(target:DisplayObject):void
		{			
			// Hide mouse.
			Mouse.hide();
			// Disable the DisplayObject for not being target of any listening.
			MovieClip(target).mouseEnabled = false;
			MovieClip(target).mouseChildren = false;
			
			// Create a variable that is the main stage of the swf.
			var mainStage:DisplayObject = target.stage;
			
			// Create tweens for fade-in and fade-out:
			var mouseTweenIn:Tween = new Tween(target , "alpha" , Strong.easeOut , target.alpha, 0, .5, true);
			var mouseTweenOut:Tween = new Tween(target , "alpha" , Strong.easeOut , target.alpha, 1, .5, true);
			
			// Stop the tweens.
			mouseTweenIn.stop();
			mouseTweenOut.stop();
			
			// Creates an variable to check if the DisplayObject is invisible.
			var isInvisible:Boolean = false;
			
			// Add the stage's listeners.
			mainStage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			mainStage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			
			
			function mouseMoveListener(e:MouseEvent):void
			{
				// Uncomment this line to make the mouse hide ( when the user right clicks the mouse is shown again ).
				
					//Mouse.hide();
				
				// If it's invisible, fade out the cursor.
				if ( isInvisible )
				{
					mouseTweenIn.stop();
					mouseTweenOut.start();
					
					isInvisible = false;
				}
				
				// Reset it's stage properties.
				target.x = e.stageX;
				target.y = e.stageY;
			}
			
			function mouseLeaveHandler(e:Event):void
			{
				// Hide the mouse
				mouseTweenOut.stop();
				mouseTweenIn.start();
				
				// Set isInvisible to true.
				isInvisible = true;
			}
		}
	}
}