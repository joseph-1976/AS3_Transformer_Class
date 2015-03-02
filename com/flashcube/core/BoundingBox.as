package com.flashcube.core
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 *  This class is used for creating graphics inside an Sprite, it's used for less code in the main class
	 *  file, you can use this class as you want, detailed instructions in the Instructions file.
	 * 
	 *  @author Joseph Stenhouse
	 */
	public class BoundingBox
	{
		/*
		 *  The BoundingBox class only uses static functions, therefore, its Constructor throws an
		 *  error if you try to instantiate it.
		 */
		public function BoundingBox()
		{throw new Error("Can't create an instance of static class BoundingBox."); }
		
		/*
		 *   The drawSmallSquare function receives five parameters: the graphic that the graphics will reside,
		 *   the x position of the graphics, the y position, the size of the square and the color of the line,
		 *   you can also change the fill property, but you must add your own parameter to the function.
		 *
		 *   Make sure you copy this class before changing it, the Transformer class uses this class to draw the
		 *   handles and graphics.
		 */
		public static function drawSmallSquare(graphic:Sprite , x:uint , y:uint , size:uint , color:Number):void
		{
			// Creates an empty matrix to hold the color gradient.
			var mat:Matrix = new Matrix();
			// Creates an array of two colors for the gradient.
			var colors:Array = [0xFFFFFF, 0xCFDBE5];
			// Alpha values used for the gradient.
			var alphas:Array = [1, 1];
			// Ratios are the actual x and y positions of each color of the the gradient, range from 0-255. 
			var ratios:Array = [0, 255];
			
			// Create an gradientBox with the specified size and turn it 90º negative ( non-clockwise ).
			mat.createGradientBox(size, size, Utils.toRad( -90));
			// Set the color and the size of the line.
			graphic.graphics.lineStyle(1, color);
			// Create the gradient fill, using as parameters the colors, alphas and ratios described above.
			graphic.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, mat);
			// Draw an rectangle with the gradient above.
			graphic.graphics.drawRect(0, 0, size, size);
			// Stop filling it with the selected color gradient.
			graphic.graphics.endFill();
			
			// Create the graphic based on the middle point of the Sprite.
			graphic.x = x - size / 2;
			graphic.y = y - size / 2;
		}
		
		
		public static function drawSmallCircle(graphic:Sprite , x:uint , y:uint , size:uint , color:Number):void
		{
			// Same as above, but creates a circle graphic.
			
			var mat:Matrix = new Matrix();
			var colors:Array = [0xFFFFFF,0xCFDBE5];
			var alphas:Array = [1,1];
			var ratios:Array = [0, 255];
			
			mat.createGradientBox(size, size, Utils.toRad( -90));
			
			graphic.graphics.lineStyle(1,color);
			graphic.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,mat);
			graphic.graphics.drawCircle(0,0,size / 2);
			graphic.graphics.endFill();
			
			graphic.x = x;
			graphic.y = y;
		}
		
		// This function draws a square without a fill, only with the color specified.
		public static function drawBigSquare(graphic:Sprite , x:Number , y:Number , sizeX:Number , sizeY:Number , color:Number):void
		{
			// Create a 1px line size with the received color.
			graphic.graphics.lineStyle(1, color);
			// Draws an rectangle with the specified size.
			graphic.graphics.drawRect(0, 0, sizeX, sizeY);
			// Place it in the specified x and y positions.
			graphic.x = x;
			graphic.y = y;
		}
		
		// Same function as above, but draws an invisible square.
		public static function drawInvisibleSquare(graphic:Sprite , x:uint , y:uint , size:uint):void
		{
			graphic.graphics.lineStyle(0,0x000000,0);
			graphic.graphics.beginFill(0x000000,0);
			graphic.graphics.drawRect(0,0,size,size);
			graphic.graphics.endFill();
			// Create the graphic based on the middle point of the Sprite.
			graphic.x = x - size / 2;
			graphic.y = y - size / 2;
		}
		
		// Same as above, but the square can have a fill property and will appear based on the alpha value given.
		public static function drawInvisibleStage(graphic:Sprite , x:uint , y:uint , sizeX:uint , sizeY:uint , color:Number , alpha:Number):void
		{
			graphic.graphics.lineStyle(0,0x000000,0);
			graphic.graphics.beginFill(color,alpha);
			graphic.graphics.drawRect(0,0,sizeX,sizeY);
			graphic.graphics.endFill();
			graphic.x = x;
			graphic.y = y;
		}
		
	}	
}