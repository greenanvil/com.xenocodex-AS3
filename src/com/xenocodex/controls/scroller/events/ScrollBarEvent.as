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

package com.xenocodex.controls.scroller.events{
	
	import flash.events.Event;
	
	import com.xenocodex.img.events.ImgLibEvent;
	
	public class ScrollBarEvent extends Event{
		
		public static const POS_UPDATE:String = "com.xenocodex.controls.scroller.events.ScrollBarEvent.POS_UPDATE";
		public static const MOUSE_UP:String = "com.xenocodex.controls.scroller.events.ScrollBarEvent.MOUSE_UP";
		public static const CENTERING:String = "com.xenocodex.controls.scroller.events.ScrollBarEvent.CENTERING";
		
		private var _pos:Number = 0;
		
		public function ScrollBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
			
		}
		
		public function get pos():Number{
			return _pos;
		}
		
		public function set pos(newPos:Number):void{
			_pos = newPos;
		}
		
		override public function clone():Event{
			
			return new ScrollBarEvent(type, bubbles, cancelable);
			
		}
		
		override public function toString():String{
			
			return formatToString( "ScrollBarEvent", "type", "bubbles", "cancelable", "eventPhase" );
			
		}
		
	}
}