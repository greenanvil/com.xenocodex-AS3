package com.xenocodex.fms{
	
	import com.xenocodex.fms.events.NSObjectEvent;
	import com.xenocodex.util.ActionRelay;
	
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class NSObject extends NetStream{
		
		public var tagName:String;
		public var streamID:String;
		public var mediaID:String;
		
		public var isPublishing :Boolean = false;
		public var isSubscribing:Boolean = false;
		
		public function NSObject(connection:NetConnection, peerID:String="connectToFMS"){
			
			super(connection, peerID);
			
			this.client = new Object();
			this.client.onMetaData = _handleMetaDataEvent;
			this.client.onCuePoint = _handleCuePointEvent;
			
		}
		
		private function _handleMetaDataEvent( metaDataObject:Object ):void{
			
			var evt:NSObjectEvent = new NSObjectEvent( NSObjectEvent.METADATA );
			
			for( var i:String in metaDataObject ){
				
				evt.metaData[i] = metaDataObject[i];
				
			}
			
			FMSInterface.dispatchEvent( evt );
			
		}
		
		private function _handleCuePointEvent( cuepointObject:Object ):void{
			
			var evt:NSObjectEvent = new NSObjectEvent( NSObjectEvent.CUEPOINT );
			evt.cuePointName = cuepointObject.name;
			evt.cuePointTime = cuepointObject.time;
			
			FMSInterface.dispatchEvent( evt );
			
		}
		
	}
}