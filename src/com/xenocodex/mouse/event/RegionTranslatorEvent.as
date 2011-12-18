package com.xenocodex.mouse.event{
	
	import flash.events.Event;
	
	public class RegionTranslatorEvent extends Event{
		
		public static const UPDATE:String = 'com.xenocodex.mouse.event.RegionTranslatorEvent.UPDATE';
		
		public var xMod:Number;
		public var yMod:Number;
		
		public function RegionTranslatorEvent( type:String, xMod:Number, yMod:Number, bubbles:Boolean=false, cancelable:Boolean=false ){
			
			super(type, bubbles, cancelable);
			
			this.xMod = xMod;
			this.yMod = yMod;
			
		}
	}
}