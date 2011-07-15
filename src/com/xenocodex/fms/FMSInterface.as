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
	
	import com.xenocodex.fms.data.NCData;
	import com.xenocodex.fms.events.FMSInterfaceEvent;
	import com.xenocodex.fms.events.NCObjectEvent;
	import com.xenocodex.video.VideoMediaManager;
	
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	
	public class FMSInterface{
		
		protected static var EVT_DISP:EventDispatcher;
		
		private static var NC:Dictionary = new Dictionary();
		
		private static var _ncConnPool:Dictionary = new Dictionary();
		
		public static var debugLevel:int = 0;
		
		public function FMSInterface(){}
		
		public static function createConnection( connID:String, appLoc:String = null, instanceID:String = null ):void{
			
			if( FMSInterface.debugLevel > 0 ) trace( '[object FMSInterface] > createConnection():' + connID + '\n> app loc:' + appLoc + ', instance ID' + instanceID ); 
			
			var nco:NCObject = new NCObject();
			
			if( appLoc && instanceID ){
				nco.conn = FMSInterface.getConnByID( FMSInterface.getConnID( appLoc, instanceID ));
				nco.appLoc = appLoc;
				nco.instanceID = instanceID;
			}
			
			NC[ connID ] = nco;
			
			NCObject( NC[ connID ] ).addEventListener( NCObjectEvent.LIVE_IN_READY, FMSInterface.handleNCObjectEvent );
			
		}
		
		public static function setAppLoc( connID:String, appLoc:String, instanceID:String = null ):void{
			
			if( FMSInterface.debugLevel > 0 ) trace( '[object FMSInterface] > setAppLoc():' + connID + ' > appLoc: ' + appLoc + ', instanceID: ' + instanceID );
			
			if( !NC[ connID ] ){
				
				trace( '[object FMSInterface] > setAppLoc() > no connection named ' + connID );
				return;
				
			}
			
			NC[ connID ].conn = FMSInterface.getConnByID( FMSInterface.getConnID( appLoc, instanceID ));
			NC[ connID ].appLoc = appLoc;
			NC[ connID ].instanceID = instanceID;
			
		}
		
		public static function setStreamID( connID:String, streamID:String ):void{
			
			NC[ connID ].streamID = streamID;
			
		}
		
		private static function handleNetStatusEvent( e:NetStatusEvent ):void {
			
			//trace( 'FMSInterface > handleNetStatusEvent() > code: ' + e.info.code );
			
			switch ( e.info.code ) {
				
				case "NetConnection.Connect.Success":
					//connectStream();
					break;
				
				case "NetStream.Play.StreamNotFound":
					//trace("Stream not found: " + videoURL);
					break;
			}
			
		}
		
		private static function handleNCObjectEvent( e:NCObjectEvent ):void{
			
			switch( e.type ){
				
				case NCObjectEvent.LIVE_IN_READY:
					
					var evt:FMSInterfaceEvent = new FMSInterfaceEvent( FMSInterfaceEvent.LIVE_IN_READY );
					evt.mediaID = e.mediaID;
					evt.streamID = e.streamID;
					evt.tagName = e.tagName;
					
					FMSInterface.dispatchEvent( evt );
					break;
				
			}
			
		}
		
		private static function handleSecurityError( e:SecurityErrorEvent ):void{
			trace( '[object FMSInterface] > handleSecurityError() > event: ' + e );
		}
		
		private static function handleIOError( e:IOErrorEvent ):void{
			trace( '[object FMSInterface] > handleIOError() > event: ' + e );
		}
		
		private static function onBWDone(... rest):Boolean {
			return true;
		}
		
		private static function onBWCheck(... rest):Number {
			return 0;
		}
		
		private static function getConnByID( connID:String ):NetConnection{
			
			if( !_ncConnPool[ connID ] ){
				
				_ncConnPool[ connID ] = new NetConnection();
				_ncConnPool[ connID ].addEventListener( NetStatusEvent.NET_STATUS, FMSInterface.handleNetStatusEvent );
				_ncConnPool[ connID ].addEventListener( SecurityErrorEvent.SECURITY_ERROR, FMSInterface.handleSecurityError );
				_ncConnPool[ connID ].addEventListener( IOErrorEvent.IO_ERROR, FMSInterface.handleIOError );
				
				_ncConnPool[ connID ].client = { onBWDone: FMSInterface.onBWDone, onBWCheck: FMSInterface.onBWCheck };
				
				NetConnection( _ncConnPool[ connID ] ).connect( null );
				
			}
			
			return _ncConnPool[ connID ];
			
		}
		
		private static function getConnID( appLoc:String, instanceID:String ):String{
			
			return String( appLoc + instanceID ).replace( /\W+/g, '' ).replace( /_/g, '' );
			
		}
		
		public static function get connections():Dictionary{
			return NC;
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