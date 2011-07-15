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

package com.xenocodex.support.events{

	import flash.events.Event;
	
	/**
	* Created: Jun 4, 2011, 11:33:04 AM
	*
	* @author		dsmith	
	* 
	*/
	public class LocalMediaEvent extends Event{
	
		public static var CAM_ACQUIRED:String = 'com.xenocodex.support.events.LocalMediaEvent.CAM_ACQUIRED';
		
		public static var START_CAM:String = 'com.xenocodex.support.events.LocalMediaEvent.START_CAM';
		public static var STOP_CAM:String = 'com.xenocodex.support.events.LocalMediaEvent.STOP_CAM';
		
		public static var CAMERA_MUTED:String = 'com.xenocodex.support.events.LocalMediaEvent.CAMERA_MUTED';
		public static var CAMERA_UNMUTED:String = 'com.xenocodex.support.events.LocalMediaEvent.CAMERA_UNMUTED';
		
		public static var CAM_SETTINGS_CHANGED:String = 'com.xenocodex.support.events.LocalMediaEvent.CAM_SETTINGS_CHANGED';
		
		public function LocalMediaEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
			
		}
		
	}
}