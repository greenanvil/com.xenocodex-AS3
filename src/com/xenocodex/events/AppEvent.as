package com.xenocodex.events{
	
	import flash.events.Event;
	
	
	/**
	 * Created: Jul 7, 2011, 4:40:37 PM
	 *
	 * @author		dsmith	
	 * 
	 */
	public class AppEvent extends Event{
		
		public static var REQUEST_VIEW_SWITCH:String = 'com.xenocodex.events.AppEvent.REQUEST_VIEW_SWITCH';
		public static var REPLAY:String = 'com.xenocodex.events.AppEvent.REPLAY';
		
		public var viewType:String;
		
		public function AppEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
		
	}
}