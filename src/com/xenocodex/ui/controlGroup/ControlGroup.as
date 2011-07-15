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
	
	import com.xenocodex.ui.controlGroup.data.ControlGroupData;
	
	import flash.display.Sprite;
	
	
	public class ControlGroup extends Sprite{
		
		private var _data:ControlGroupData;
		
		public var margin:int = 5;
		
		private var _bgHldr:Sprite = new Sprite();
		private var _ctrlsHldr:Sprite = new Sprite();
		
		public var _bg:NavBg;
		
		public function ControlGroup( data:ControlGroupData = null ){
			
			super();
			
			if( data ) _data = data;
			
			_data = data ? data : new ControlGroupData(); 
			
			this.build();
			
		}
		
		private function build():void{
			
			this.addChild( _bgHldr );
			this.addChild( _ctrlsHldr );
			
		}
		
		public function set bg( bgIN:NavBg ):void{
			
			_bg = bgIN;
			
			while( _bgHldr.numChildren > 0 ){
				_bgHldr.removeChildAt( 0 );	
			}
			
			_bgHldr.addChild( _bg );
			
		}
		
		public function get bg():NavBg{
			return _bg;
		}
		
		public function get data():ControlGroupData{
			return _data;
		}
		
		public function get groupHeight():Number{
			return _data.minHeight;
		}
		
	}
}