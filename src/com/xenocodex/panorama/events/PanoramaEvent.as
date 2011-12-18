package com.xenocodex.panorama.events{
	
	import flash.events.Event;
	
	/**
	 * Created: Nov 5th, 2011, 12:57 AM
	 *
	 * @author		dsmith	
	 * 
	 */
	public class PanoramaEvent extends Event{
		
		public static var LOW_IMGS_LOADED:String = 'com.xenocodex.panorama.events.PanoramaEvent.LOW_IMGS_LOADED';
		public static var HIGH_IMGS_LOADED:String = 'com.xenocodex.panorama.events.PanoramaEvent.HIGH_IMGS_LOADED';
		
		public function PanoramaEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
			
		}
		
	}
}