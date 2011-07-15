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

	public class ScrollAreaEvent extends Event{
		
		public static const CONTROL_TYPE:String = 'scrollAreaEvent';
		
		public var _name:String;
		public var _infoObj:Object;
		
		public function ScrollAreaEvent(name:String, infoObj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(CONTROL_TYPE, bubbles, cancelable);
			
			_name = name;
			_infoObj = infoObj;
		
		}
		
		override public function clone():Event{
			
			return new ScrollAreaEvent(_name, _infoObj, bubbles, cancelable);
			
		}
		
		override public function toString():String{
			
			return formatToString( "ScrollAreaEvent", "type", "bubbles", "cancelable", "eventPhase" );
			
		}
		
	}
	
}