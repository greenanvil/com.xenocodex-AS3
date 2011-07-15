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

package com.xenocodex.controls.slider.thumbTab{
	
	import com.xenocodex.controls.slider.enum.TabMode;
	import com.xenocodex.ui.BmpBtn;
	
	import flash.display.Sprite;
	
	public class ThumbTab extends Sprite{
		
		private var _mode:String;
		private var _spriteTab:Sprite;
		private var _bmpBtnTab:BmpBtn;
		
		public function ThumbTab(){
			super();
		}
		
		public function set bmpBtnTab( bmpBtn:BmpBtn ):void{
			
			_mode = TabMode.BMP_BTN;
			_bmpBtnTab = bmpBtn;
			
			this.addChild( _bmpBtnTab );
			
		}
		
		public function get bmpBtnTab():BmpBtn{
			return _bmpBtnTab;
		}
		
		override public function get width():Number{
			
			var w:Number = 0;
			
			switch( _mode ){
				
				case TabMode.BMP_BTN:
					w = _bmpBtnTab.width;
					break;
				
			}
			
			return w;
			
		}
		
	}
}