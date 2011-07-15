package com.xenocodex.audio.volumeSlider.events{

	import flash.events.Event;
	
	/**
	* Created: May 28, 2011, 4:47:03 PM
	* @author		dsmith	
	* 
	*/
	public class VolumeSliderEvent extends Event{
		
		public static var LAYOUT_UPDATE:String = 'com.xenocodex.audio.volumeSlider.events.VolumeSliderEvent.LAYOUT_UPDATE';
		
		public static var LEVEL_CHANGE:String = 'com.xenocodex.audio.volumeSlider.events.VolumeSliderEvent.LEVEL_CHANGE';
		public static var MUTED:String = 'com.xenocodex.audio.volumeSlider.events.VolumeSliderEvent.MUTED';
		
		public var id:String;
		
		public function VolumeSliderEvent(type:String, id:String, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
			
			this.id = id;
			
		}
		
	}
}