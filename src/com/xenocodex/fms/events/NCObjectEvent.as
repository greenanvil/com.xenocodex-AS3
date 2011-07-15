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

package com.xenocodex.fms.events{
	
	import flash.events.Event;
	
	
	public class NCObjectEvent extends Event{
		
		public static const LIVE_IN_READY:String = "com.xenocodex.fms.events.NCObjectEvent.LIVE_IN_READY";
		
		public var mediaID:String;
		public var streamID:String;
		public var tagName:String;
		
		public function NCObjectEvent(type:String, mediaID:String, streamID:String = null, tagName:String = null, bubbles:Boolean = false, cancelable:Boolean = false){
			
			super(type, bubbles, cancelable);
			
			this.mediaID = mediaID;
			this.streamID = streamID;
			this.tagName = tagName;
			
		}
		
		override public function clone():Event{
			return new NCObjectEvent( type, this.mediaID, this.streamID, this.tagName, bubbles, cancelable );
		}
		
		override public function toString():String{
			return formatToString( "NCObjectEvent", "type", "bubbles", "cancelable" ); 
		}
		
	}
}