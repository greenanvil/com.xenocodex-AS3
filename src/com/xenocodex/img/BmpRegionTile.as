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

package com.xenocodex.img{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BmpRegionTile extends Sprite{
		
		public function BmpRegionTile( bmpData:BitmapData, regionW:int, regionH:int, bmpRegionX:int = 0, bmpRegionY:int = 0, bmpRegionW:int = 0, bmpRegionH:int = 0, matrix:Matrix = null, doTile:Boolean = true ) {
			
			var useBmpData:BitmapData = bmpData;
			if ( !matrix ) matrix = new Matrix();
			
			if ( bmpRegionW != 0 && bmpRegionH != 0 ) {
				var regionBmp:Bitmap = new Bitmap( new BitmapData( bmpRegionW, bmpRegionH, true, 0x00000000 ));
				regionBmp.bitmapData.copyPixels( bmpData, new Rectangle( bmpRegionX, bmpRegionY, bmpRegionW, bmpRegionH), new Point( 0, 0 ), null, null, true );
				useBmpData = regionBmp.bitmapData;
			}
			
			with (this.graphics) {
				beginBitmapFill( useBmpData, matrix, doTile );
				drawRect(0, 0, regionW, regionH);
				endFill();
			}
			
		}
		
	}
}