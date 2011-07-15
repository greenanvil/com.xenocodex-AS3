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

package com.xenocodex.ui.controlGroup{
	
	import flash.display.Sprite;
	
	public class NavBg extends Sprite{
		
		private var _w:int;
		private var _h:int;
		
		private var _bgColor:int;
		
		public function NavBg( w:Number = 100, h:Number = 30, bgColor:int = 0x000000, alphaIN:Number = .4 ){
			
			super();
			
			this.draw( w, h, bgColor, alphaIN );
			
		}
		
		public function draw( w:Number = -1, h:Number = -1, bgColor:int = -1, alphaIN:Number = -1 ):void{
			
			if( w > -1 ) _w = w;
			if( h > -1 ) _h = h;
			if( bgColor > -1 ) _bgColor = bgColor;
			if( alphaIN > -1 ) this.alpha = alphaIN;
			
			this.graphics.clear();
			this.graphics.beginFill( _bgColor );
			this.graphics.drawRect( 0, 0, _w, _h );
			this.graphics.endFill();
			
		}
		
	}
}