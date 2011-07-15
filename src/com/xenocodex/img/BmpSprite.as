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
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class BmpSprite extends Sprite{
		
		private var _bmp:Bitmap;
		private var _bmpMask:Shape = new Shape();
		
		public function BmpSprite( bmpData:BitmapData, maskW:int, maskH:int, regionX:int = 0, regionY:int = 0 ) {
			
			_bmp = new Bitmap( bmpData );
			if( regionX != 0 ) regionX = Math.abs( regionX ) * -1;
			if ( regionY != 0 ) regionY = Math.abs( regionY ) * -1;
			_bmp.x = regionX;
			_bmp.y = regionY;
			this.addChild( _bmp );
			
			_bmpMask.graphics.beginFill( 0x000000 );
			_bmpMask.graphics.drawRect( 0, 0, maskW, maskH );
			this.addChild( _bmpMask );
			
			_bmp.mask = _bmpMask;
			
		}
		
		override public function get width():Number {
			return ( _bmpMask ) ? _bmpMask.width : 0;
		}
		
		override public function get height():Number {
			return ( _bmpMask ) ? _bmpMask.height : 0;
		}
		
	}

}