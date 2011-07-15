/**
 * Copyright (c) 2011 Xenocodex <flashdev@xenocodex.com>
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 **/

package com.xenocodex.ui{

	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	* Created: Jul 8, 2011, 12:25:04 PM
	*
	* @author		dsmith	
	* 
	*/
	public class GradientOverlayMask extends Sprite{
	
		public function GradientOverlayMask( colorIN:uint, w:int, h:int, angle:int ){
			
			super();
			
			var fType:String = GradientType.LINEAR;
			var colors:Array = [ colorIN, colorIN ];
			var alphas:Array = [ 1, 0 ];
			var ratios:Array = [ 0, 255 ];
			
			var convAngle:Number = angle * (Math.PI / 180);
			
			var matr:Matrix = new Matrix();
			matr.createGradientBox( w-10, h-10, convAngle, 0, 0 );
			
			var sprMethod:String = SpreadMethod.PAD;
			
			this.graphics.beginGradientFill(fType, colors, alphas, ratios, matr, sprMethod);
			this.graphics.drawRect(0, 0, w, h);
			
		}
		
	}
}