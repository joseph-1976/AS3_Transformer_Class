package com.flashcube
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Joseph Stenhouse (Involuton Media)
	 */
	public class TransformerEvent extends Event
	{
		/**
		 * <b>Transformer Event Class</b><br /><br />
		 * Throws an set of events for the Transform class.
		 */
		public function TransformerEvent($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false):void 
		{super($type, $bubbles, $cancelable);}
		
		/**
		 * Dispatched when the Transformer class is activated.
		 */
		public static const ACTIVATE:String = "activate";
		/**
		 * Dispatched when the Transformer class is deactivated.
		 */
		public static const DEACTIVATE:String = "deactivate";
		
		/**
		 * Dispatched when the user starts scaling the object (When he first clicks the handle).
		 */
		public static const SCALE_START:String = "scaleStart";
		/**
		 * Dispatched after the user starts scaling the object, when the mouse is moving.
		 */
		public static const SCALE_ENTER_FRAME:String = "scaleEnterFrame";
		/**
		 * Dispatched after the scaling of the object, when the mouse is up.
		 */
		public static const SCALE_END:String = "scaleEnd";
		
		/**
		 * Dispatched when the user starts rotating the object (When he first clicks the rotation handle).
		 */
		public static const ROTATE_START:String = "rotateStart";
		/**
		 * Dispatched after the user starts rotating the object, when the mouse is moving.
		 */
		public static const ROTATE_ENTER_FRAME:String = "rotateEnterFrame";
		/**
		 * Dispatched after the rotation of the object, when the mouse is up.
		 */
		public static const ROTATE_END:String = "rotateEnd";
		
		/**
		 * Dispatched when the user starts dragging the object (When he first clicks the object itself).
		 */
		public static const DRAG_START:String = "dragStart";
		/**
		 * Dispatched after the user starts dragging the object, when the mouse is moving.
		 */
		public static const DRAG_MOUSE_MOVE:String = "dragMouseMove";
		/**
		 * Dispatched after the moving of the object, when the mouse is up.
		 */
		public static const DRAG_END:String = "dragEnd";
		
		/**
		 * Dispatched when the object is clicked or selected, when the handles appear.
		 */
		public static const SELECT:String = "select";
		/**
		 * Dispatched when the object is deselected, when the handles disappear.
		 */
		public static const DESELECT:String = "deselect";
		
		/**
		 * Dispatched when the object is deleted using the DELETE key of the user's keyboard.
		 */
		public static const DELETE:String = "delete";
		
	}
}