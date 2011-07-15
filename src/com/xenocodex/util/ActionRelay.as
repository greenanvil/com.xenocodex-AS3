package com.xenocodex.util{
	
	import com.xenocodex.util.events.ActionRelayEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ActionRelay{
		
		private static var SELF_REF:ActionRelay;
		protected static var EVT_DISP:EventDispatcher;
		
		public function ActionRelay(){}
		
		public static function getActionRelay():ActionRelay{
			
			if( SELF_REF == null ) SELF_REF = new ActionRelay();
			
			return SELF_REF;
			
		}
		
		public static function addEventListener(...p_args:Array):void{
			
			if(EVT_DISP == null) EVT_DISP = new EventDispatcher();
			EVT_DISP.addEventListener.apply(null, p_args);
			
		}
		
		public static function removeEventListener(...p_args:Array):void{
			
			if(EVT_DISP == null) return;
			
			EVT_DISP.removeEventListener.apply(null, p_args);
			
		}
		
		public static function dispatchEvent(...p_args:Array):void{
			
			if(EVT_DISP == null) return;
			
			EVT_DISP.dispatchEvent( new ActionRelayEvent( ActionRelayEvent.ACTION, p_args ) );
			
			EVT_DISP.dispatchEvent.apply(null, p_args);
			
		}
	}
}