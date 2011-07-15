package com.xenocodex.video{

	
	/**
	* Created: Jun 18, 2011, 9:54:51 AM
	*
	* @author		dsmith	
	* 
	*/
	public class VideoFeed{
	
		public var id:String;
		public var type:String;
		public var feed:VideoMediaObject;
		
		public function VideoFeed( id:String, type:String, feed:VideoMediaObject ){
		
			this.id = id;
			this.type = type;
			this.feed = feed;
			
		}
		
	}
}