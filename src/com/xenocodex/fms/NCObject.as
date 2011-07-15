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

package com.xenocodex.fms{
	
	import com.xenocodex.enum.NetStatusCode;
	import com.xenocodex.fms.events.FMSInterfaceEvent;
	import com.xenocodex.fms.events.NCObjectEvent;
	import com.xenocodex.video.VideoFeed;
	import com.xenocodex.video.VideoLiveOut;
	import com.xenocodex.video.VideoMediaManager;
	import com.xenocodex.video.enum.VideoMediaType;
	
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	
	public class NCObject extends EventDispatcher{
		
		protected static var EVT_DISP:EventDispatcher;
		
		public var appLoc:String;
		public var instanceID:String;
		public var mediaID:String;
		
		private var _incomingTagName:String;
		private var _outgoingTagName:String;
		
		private var _incomingMediaID:String;
		private var _outgoingMediaID:String;
		
		private var _incomingStreamID:String;
		private var _outgoingStreamID:String;
		
		public var conn:NetConnection;
		
		private var _ns:Dictionary = new Dictionary();
		
		public function NCObject(){}
		
		public function publishVideo( mediaID:String, streamID:String = 'stream', tagName:String = null ):void{
			
			if( FMSInterface.debugLevel > 1 ) trace( this + ' > publishVideo()' );
			
			if( !conn ){
				
				trace( this + ' > publishVideo() > no connection, cannot publish' );
				return;
				
			} else {
			
				conn.addEventListener( NetStatusEvent.NET_STATUS, this.handleNCStatusEvent );
				
			}
			
			if( VideoMediaManager.getEntryType( mediaID ) != VideoMediaType.LIVE_OUT ){
				
				trace( this + ' > publishVideo() > not a camera resource, cannot publish' );
				return;
				
			}
			
			if( conn.uri == 'null' ){
				
				_outgoingMediaID = mediaID;
				_outgoingStreamID = streamID;
				_outgoingTagName = tagName;
				
				conn.connect( this.appLoc + '/' + this.instanceID );
				
			} else {
				
				this.lineActiveDoPublish( streamID, mediaID, tagName );
				
			}
			
		}
		
		private function lineActiveDoPublish( streamID:String = null, mediaID:String = null, tagName:String = null  ):void{
			
			if( FMSInterface.debugLevel > 1 ) trace( this + ' > lineActiveDoPublish() > streamID: ' + streamID );
			
			this._ns[ streamID ] = new NSObject( this.conn );
			this._ns[ streamID ].tagName = tagName;
			
			this._ns[ streamID ].addEventListener( NetStatusEvent.NET_STATUS, this._handleNSStatusEvent );
			
			this._ns[ streamID ].attachCamera( VideoMediaManager.getEntryById( mediaID ).feed.vidSrc );
			this._ns[ streamID ].attachAudio( VideoMediaManager.getEntryById( mediaID ).feed.audioSrc );
			this._ns[ streamID ].publish( streamID );
			
			_outgoingMediaID = null;
			
		}
		
		public function stopPublish( streamID:String = null ):void{
			
			if( FMSInterface.debugLevel > 1 ) trace( this + ' > stopPublish() > streamID: ' + streamID );
			
			var thisStream:NSObject = this._ns[ streamID ];
			
			if( thisStream != null && thisStream.isPublishing ){
				
				_ns[ streamID ].close();
				
			}
			
		}
		
		public function subscribeToVideo( mediaID:String, streamID:String = 'stream', tagName:String = null ):void{
			
			if( FMSInterface.debugLevel > 1 )trace( this + ' > subscribeToVideo() > mediaID: ' + mediaID + ', streamID: ' + streamID );
			
			if( !conn ){
				
				return;
				
			} else {
				
				conn.addEventListener( NetStatusEvent.NET_STATUS, this.handleNCStatusEvent );
				
			}
			
			if( VideoMediaManager.getEntryType( mediaID ) != VideoMediaType.LIVE_IN ){
				
				trace( this + ' > subscribeToVideo() > not an incoming live video resource, cannot subscribe' );
				return;
				
			}
			
			if( conn.uri == 'null' || !conn.connected ){
				
				if( FMSInterface.debugLevel > 1 ) trace( this + ' > subscribeToVideo() > connecting stream with tagName ' + tagName + ' & streamID: ' + streamID + '...' );
				
				_incomingMediaID = mediaID;
				_incomingStreamID = streamID;
				_incomingTagName = tagName;
				
				conn.connect( this.appLoc + '/' + this.instanceID );
				
			} else {
				
				this.lineActiveDoSubscribe( streamID, mediaID, tagName );
				
			}
			
		}
		
		public function setIncomingVolume( mediaID:String, volume:Number ):void{
			
			VideoMediaManager.getEntryById( mediaID ).feed.setVolume( volume );
			
		}
		
		public function stopSubscribe( streamID:String = null ):void{
			
			if( FMSInterface.debugLevel > 1 ) trace( this + ' > stopSubscribe() > streamID: ' + streamID );
			
			var thisStream:NSObject = this._ns[ streamID ];
			
			if( thisStream != null && thisStream.isSubscribing ){
				
				this._ns[ streamID ].close();
				
				// nullify and delete the registered ns entry
				this._ns[ streamID ] = null;
				delete this._ns[ streamID ];
				
			}
			
		}
		
		public function getStreamClient( streamID:String ):Object{
			
			return NSObject( this._ns[ streamID ] ).client;
			
		}
		
		public function unSubscribeAllStreams():void{
			
			var thisStream:NSObject;
			
			for( var nsObject:Object in _ns ) this.stopSubscribe( NSObject( this._ns[ nsObject ] ).streamID );
			
		}
		
		private function lineActiveDoSubscribe( streamID:String = null, mediaID:String = null, tagName:String = null ):void{
			
			if( FMSInterface.debugLevel > 1 ) trace( this + ' > lineActiveDoSubscribe() > ' + arguments );
			
			this._ns[ streamID ] = new NSObject( this.conn );
			this._ns[ streamID ].addEventListener( NetStatusEvent.NET_STATUS, this._handleNSStatusEvent );
			this._ns[ streamID ].streamID = streamID;
			this._ns[ streamID ].mediaID = mediaID;
			this._ns[ streamID ].tagName = tagName;
			
			VideoMediaManager.getEntryById( mediaID ).feed.vidSrc = this._ns[ streamID ];
			
			this.dispatchEvent( new NCObjectEvent( NCObjectEvent.LIVE_IN_READY, mediaID, streamID, tagName ));
			
			NSObject( this._ns[ streamID ] ).play( streamID );
			
		}
		
		private function handleNCStatusEvent( e:NetStatusEvent ):void{
			
			if( FMSInterface.debugLevel > 1 ) trace( this + ' > handleNCStatusEvent() ' + e.info.code );
			
			switch( e.info.code ){
				 
				case NetStatusCode.NC_CONNECT_SUCCESS:
					
					if( _incomingMediaID ){
						
						this.lineActiveDoSubscribe( _incomingStreamID, _incomingMediaID, _incomingTagName );
						
						_incomingMediaID = null;
						_incomingStreamID = null;
						_incomingTagName = null;
						
					}
					
					if( _outgoingMediaID ) {
						
						this.lineActiveDoPublish( _outgoingStreamID, _outgoingMediaID, _outgoingTagName );
						
						_outgoingStreamID = null;
						_outgoingMediaID = null;
						_outgoingTagName = null;
						
					}
					
					break;
				
			}
			
			FMSInterface.dispatchEvent( e );
			
		}
							   
		private function _handleNSStatusEvent( e:NetStatusEvent ):void{
			
			if( FMSInterface.debugLevel > 1 ) trace( this + ' > handleNSStatusEvent():' + e.info.code + ' > ' + ( e.currentTarget.tagName != null ? e.currentTarget.tagName : '' ));
			
			var fmsEvt:FMSInterfaceEvent;
			
			switch( e.info.code ){
				
				case NetStatusCode.NC_CONNECT_SUCCESS:
					if( _outgoingMediaID ) this.lineActiveDoPublish( this._outgoingStreamID );
					break;
				
				case NetStatusCode.NS_PUBLISH_START:
					
					NSObject( e.currentTarget ).isPublishing = true;
					
					if( FMSInterface.debugLevel > 1 ) trace( this + ' > stream ' + NSObject( e.currentTarget ).tagName + ' isPublishing: ' + NSObject( e.currentTarget ).isPublishing );
					
					fmsEvt = new FMSInterfaceEvent( FMSInterfaceEvent.PUBLISHING );
					fmsEvt.tagName = NSObject( e.currentTarget ).tagName;
					fmsEvt.mediaID = NSObject( e.currentTarget ).mediaID;
					fmsEvt.streamID = NSObject( e.currentTarget ).streamID;
					
					FMSInterface.dispatchEvent( fmsEvt );
					break;
				
				case NetStatusCode.NS_UNPUBLISH_SUCCESS:
					
					NSObject( e.currentTarget ).isPublishing = false;
					
					if( FMSInterface.debugLevel > 1 ) trace( this + ' > stream ' + NSObject( e.currentTarget ).tagName + ' isPublishing: ' + NSObject( e.currentTarget ).isPublishing );
					
					fmsEvt = new FMSInterfaceEvent( FMSInterfaceEvent.NOT_PUBLISHING );
					fmsEvt.tagName = NSObject( e.currentTarget ).tagName;
					fmsEvt.mediaID = NSObject( e.currentTarget ).mediaID;
					fmsEvt.streamID = NSObject( e.currentTarget ).streamID;
					
					FMSInterface.dispatchEvent( fmsEvt );
					break;
				
				case NetStatusCode.NS_PLAY_UNPUBLISHNOTIFY:
				case NetStatusCode.NS_PLAY_STOP:
					
					NSObject( e.currentTarget ).isSubscribing = false;
					
					if( FMSInterface.debugLevel > 1 ) trace( this + ' > stream ' + NSObject( e.currentTarget ).tagName + ' isSubscribing: ' + NSObject( e.currentTarget ).isSubscribing );
					
					fmsEvt = new FMSInterfaceEvent( FMSInterfaceEvent.STREAM_STOPPED );
					fmsEvt.tagName = NSObject( e.currentTarget ).tagName;
					fmsEvt.mediaID = NSObject( e.currentTarget ).mediaID;
					fmsEvt.streamID = NSObject( e.currentTarget ).streamID;
					
					FMSInterface.dispatchEvent( fmsEvt );
					
					break;
				
				case NetStatusCode.NS_PLAY_START:
					
					NSObject( e.currentTarget ).isSubscribing = true;
					
					if( FMSInterface.debugLevel > 1 ) trace( this + ' > stream ' + NSObject( e.currentTarget ).tagName + ' isSubscribing: ' + NSObject( e.currentTarget ).isSubscribing );
					
					fmsEvt = new FMSInterfaceEvent( FMSInterfaceEvent.STREAM_STARTED );
					fmsEvt.tagName = NSObject( e.currentTarget ).tagName;
					fmsEvt.mediaID = NSObject( e.currentTarget ).mediaID;
					fmsEvt.streamID = NSObject( e.currentTarget ).streamID;
					
					FMSInterface.dispatchEvent( fmsEvt );
					
					break;
				
			}
			
			FMSInterface.dispatchEvent( e );
			
		}
		
	}
}