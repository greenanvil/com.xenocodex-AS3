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
	
	import flash.display.Sprite;
	
	public class SimpleFrame extends Sprite{
		
		public var borderAlpha:Number = 1;
		public var borderWidth:int = 2;
		public var borderColor:int = 0xFFFFFF;
		private var _w:Number = 320;
		private var _h:Number = 240;
		
		public function SimpleFrame(){
			super();
		}
		
		private function draw():void{
			
			this.graphics.clear();
			
			this.graphics.beginFill( this.borderColor, this.borderAlpha );
			
			this.graphics.moveTo( 0, 0 );
			this.graphics.lineTo( _w, 0 );
			this.graphics.lineTo( _w, _h );
			this.graphics.lineTo( 0, _h );
			this.graphics.lineTo( 0, 0 );
			
			this.graphics.moveTo( this.borderWidth, this.borderWidth );
			this.graphics.lineTo( _w - this.borderWidth, this.borderWidth );
			this.graphics.lineTo( _w - this.borderWidth, _h - this.borderWidth );
			this.graphics.lineTo( this.borderWidth, _h - this.borderWidth );
			this.graphics.lineTo( this.borderWidth, this.borderWidth );
			
			this.graphics.endFill();
		}
		
		public function set dims( dimsIn:Array ):void{
			
			_w = dimsIn[0];
			_h = dimsIn[1];
			
			this.draw();
			
		}
		
	}
}