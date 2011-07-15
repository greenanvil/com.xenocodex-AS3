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

package com.xenocodex.controls.slider.events{
	
	import flash.events.Event;
	
	public class SliderEvent extends Event{
		
		public static const LEVEL_UPDATE:String = "com.xenocodex.controls.slider.events.SliderEvent.LEVEL_UPDATE";
		public static const TAB_RELEASE:String = "com.xenocodex.controls.slider.events.SliderEvent.TAB_RELEASE";
		
		public var sliderId:String;
		public var level:Number = 0;
		
		public function SliderEvent(type:String, sliderId:String, level:Number, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
			
			this.sliderId = sliderId;
			this.level = level;
			
		}
		
		override public function clone():Event{
			
			return new SliderEvent(type, this.sliderId, this.level, bubbles, cancelable);
			
		}
		
		override public function toString():String{
			
			return formatToString( "SliderEvent", "type", "sliderID", "level", "bubbles", "cancelable", "eventPhase" );
			
		}
		
	}
}