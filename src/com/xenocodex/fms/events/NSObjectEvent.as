package com.xenocodex.fms.events{
	
	import flash.events.Event;
	
	public class NSObjectEvent extends Event{
		
		public static const METADATA:String = 'com.xenocodex.fms.events.NSObjectEvent.METADATA';
		public static const CUEPOINT:String = 'com.xenocodex.fms.events.NSObjectEvent.CUEPOINT';
		
		public var metaData:Object = new Object();
		
		public var cuePointName:String;
		public var cuePointTime:String;
		
		public function NSObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
			
		}
	}
}