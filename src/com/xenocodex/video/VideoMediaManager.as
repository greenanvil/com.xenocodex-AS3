/**
 * Copyright (c) 2011 Xenocodex <flashdev@xenocodex.com>
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 **/

package com.xenocodex.video{
	
	import com.xenocodex.video.VideoLiveIn;
	import com.xenocodex.video.VideoLiveOut;
	import com.xenocodex.video.enum.VideoMediaType;
	import com.xenocodex.video.events.VideoMediaEvent;
	
	import flash.events.EventDispatcher;
	import flash.media.Microphone;
	import flash.utils.Dictionary;
	
	public class VideoMediaManager{
		
		protected static var EVT_DISP:EventDispatcher;
		
		private static var MEDIA_DICT:Dictionary;
		
		public static function createEntry( entryID:String, type:String, data:Object = null, audioSrc:Microphone = null ):void{
			
			if( !MEDIA_DICT ) MEDIA_DICT =  new Dictionary();
			
			switch( type ){
				 
				case VideoMediaType.LIVE_OUT:
					 MEDIA_DICT[ entryID ] = new VideoFeed( entryID, type, new VideoLiveOut( entryID, data ));
					 break;
				
				case VideoMediaType.LIVE_IN:
					MEDIA_DICT[ entryID ] = new VideoFeed( entryID, type, new VideoLiveIn( entryID, data ));
					VideoLiveIn( MEDIA_DICT[ entryID ].feed ).addEventListener( VideoMediaEvent.VID_SRC_SET, VideoMediaManager.handleVideoMediaEvent );
					break;
			}
			
		}
		
		public static function getEntryById( entryID:String ):*{
			
			if( !MEDIA_DICT ) MEDIA_DICT =  new Dictionary();
			
			return MEDIA_DICT[ entryID ];
		}
		
		public static function getEntryType( entryID:String ):String{
			
			if( !MEDIA_DICT ) MEDIA_DICT =  new Dictionary();
			
			return MEDIA_DICT[ entryID ].type;
		}
		
		public static function showOverlay():void{
			
		}
		
		private static function handleVideoMediaEvent( e:VideoMediaEvent ):void{
			
			VideoMediaManager.dispatchEvent( e.clone());
			
		}
		
		public static function addEventListener( ...p_args:Array ):void{
			if( EVT_DISP == null ) EVT_DISP = new EventDispatcher();
			EVT_DISP.addEventListener.apply( null, p_args );
		}
		
		public static function removeEventListener( ...p_args:Array ):void{
			if( EVT_DISP == null ) EVT_DISP = new EventDispatcher();
			EVT_DISP.removeEventListener.apply( null, p_args );
		}
		
		public static function dispatchEvent( ...p_args:Array ):void{
			if( EVT_DISP == null ) EVT_DISP = new EventDispatcher();
			EVT_DISP.dispatchEvent.apply( null, p_args );
		}
		
	}
}