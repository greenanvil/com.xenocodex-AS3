package com.xenocodex.events{

	import flash.events.Event;
	
	
	/**
	* Created: Jul 7, 2011, 5:17:51 PM
	*
	* @author		dsmith	
	* 
	*/
	public class TimelineEvent extends Event{
		
		public static var CUEPOINT:String = 'com.xenocodex.events.TimelineEvent.CUEPOINT';
		public static var CLICK:String = 'com.xenocodex.events.TimelineEvent.CLICK';
		
		public var cuepointID:String;
		
		public function TimelineEvent(type:String, cuepointID:String = null, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
		
	}
}