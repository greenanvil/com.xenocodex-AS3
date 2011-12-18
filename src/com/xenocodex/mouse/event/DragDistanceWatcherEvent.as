package com.xenocodex.mouse.event{
	
	import flash.events.Event;
	
	public class DragDistanceWatcherEvent extends Event{
		
		public static var UPDATE:String = 'com.xenocodex.mouse.event.DragDistanceWatcherEvent.UPDATE';
		
		public var xDiff:Number;
		public var yDiff:Number;
		
		public var xAmt:Number;
		public var yAmt:Number;
		
		public function DragDistanceWatcherEvent(type:String, xDiff:Number, yDiff:Number, xAmt:Number, yAmt:Number, bubbles:Boolean=false, cancelable:Boolean=false){
			
			super(type, bubbles, cancelable);
			
			this.xDiff = xDiff;
			this.yDiff = yDiff;
			
			this.xAmt = xAmt;
			this.yAmt = yAmt;
			
		}
	}
}