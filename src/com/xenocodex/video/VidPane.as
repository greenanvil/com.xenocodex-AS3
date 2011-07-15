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
	
	import com.xenocodex.ui.SimpleFrame;
	import com.xenocodex.video.VideoLiveIn;
	import com.xenocodex.video.VideoLiveOut;
	import com.xenocodex.video.VideoMediaManager;
	import com.xenocodex.video.VideoMediaObject;
	import com.xenocodex.video.enum.VideoMediaType;
	import com.xenocodex.video.vidPaneSupport.VidpaneBackground;
	import com.xenocodex.video.vidPaneSupport.VidpaneUI;
	import com.xenocodex.video.vidPaneSupport.data.VidpaneSkinData;
	import com.xenocodex.video.vidPaneSupport.events.VidPaneEvent;
	import com.xenocodex.video.vidPaneSupport.events.VidPaneUIEvent;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.getTimer;
	
	/**
	 * A video player element intended to be used with VideoMediaManager.
	 * @author dsmith
	 * 
	 */
	public class VidPane extends Sprite{
		
		public static var debugLevel:Number = 0;
		
		private var _id:String;
		private var _w:int = 320;
		private var _h:int = 240;
		private var _mediaID:String;
		
		private var _skinDataID:String;
		
		private var _bg:VidpaneBackground;
		private var _underlayHldr:Sprite = new Sprite();
		private var _stillImageHldr:Sprite = new Sprite();
		private var _vid:Video;
		private var _overlayHldr:Sprite = new Sprite();
		private var _uiHldr:Sprite = new Sprite();
		private var _frame:SimpleFrame = new SimpleFrame();
		
		private var _vidMediaObject:VideoMediaObject;
		
		public function VidPane( id:String ){
			
			super();
			
			_id = id != null ? id : 'vidPane' + getTimer();
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage );
			
			this.build();
			
		}
		
		/**
		 * Creates a new internal Video object, initializes display objects.. 
		 * 
		 */
		public function build():void{
			
			_vid = new Video( _w, _h);
			
			_bg = new VidpaneBackground( this );
			
			this.addChild( _bg );
			this.addChild( _underlayHldr );
			this.addChild( _stillImageHldr );
			this.addChild( _vid );
			this.addChild( _overlayHldr );
			this.addChild( _uiHldr );
			this.addChild( _frame );
			
			this.refresh();
			
		}
		
		public function layout():void{
			
			if( !_vid ) return;
			
			// TODO: Add vidpane overlay support. 
			
			_vid.width = _w;
			_vid.height = _h;
			
			_frame.dims = [ _w, _h ];
			
			if( _skinDataID ) _bg.render( VidpaneSkinData.getSkinDataById( _skinDataID ));
			
			_updateOverlayDims( _w, _h );
			_updateStillImageDims( _w, _h );
			
			var evt:VidPaneEvent = new VidPaneEvent( VidPaneEvent.UPDATE_LAYOUT );
			evt.width = _w;
			evt.height = _h;
			// TODO: Remove this data object, it is only here for backwards compatability with the original test harness
			evt.dataObj = { width: _w, height: _h };
			
			this.dispatchEvent( evt );
			
		}
		
		public function render():void{
			
			this.layout();
			
		}
		
		public function refresh():void{
			
			if( debugLevel > 0 ) trace( this + ' > refresh()' );
			
			if( _vid && _mediaID ){
				
				switch( VideoMediaManager.getEntryType( _mediaID )){
					
					case VideoMediaType.LIVE_OUT:
						
						_vidMediaObject = VideoMediaManager.getEntryById( _mediaID ).feed;
						
						if( _vidMediaObject ){
							
							_vid.attachCamera( VideoLiveOut( _vidMediaObject ).vidSrc );
							
						}
						break;
					
					case VideoMediaType.LIVE_IN:
						
						if( debugLevel > 0 ) trace( this + ' > type: ' + VideoMediaType.LIVE_IN );
						
						this.showVideo();
						
						_vidMediaObject = VideoMediaManager.getEntryById( _mediaID ).feed;
						
						if( _vidMediaObject ){
							_vid.attachNetStream( VideoLiveIn( _vidMediaObject ).vidSrc );
						} else {
							trace( '> no video media object  named ' + _vidMediaObject );
						}
						
						break;
					
				}
				
			}
			
			this.layout();
			
		}
		
		public function clearOverlay():void{
			
			while( _overlayHldr.numChildren > 0 ){
				_overlayHldr.removeChildAt( 0 );
			}
			
		}
		
		public function clearUnderlay():void{
			
			while( _underlayHldr.numChildren > 0 ){
				_underlayHldr.removeChildAt( 0 );
			}
			
		}
		
		public function clearStillImage():void{
			
			while( _stillImageHldr.numChildren > 0 ){
				_stillImageHldr.removeChildAt( 0 );
			}
			
		}
		
		public function get vid():Video{
			return _vid;
		}
		
		public function hideVideo():void{
			
			if( debugLevel > 0 ) trace( this + ' > hideVideo()' );
			
			_vid.visible = false;
			
		}
		
		public function showVideo():void{
			
			if( debugLevel > 0 ) trace( this + ' > showVideo()' );
			
			_vid.clear();
			_vid.visible = true;
			
		}
		
		public function set dims( dimsIn:Array ):void{
			
			_w = Math.floor( dimsIn[0] );
			_h = Math.floor( dimsIn[1] );
			
			_updateOverlayDims( _w, _h );
			_updateStillImageDims( _w, _h );
			
			this.layout();
			
		}
		
		private function _updateOverlayDims( newW:Number, newH:Number ):void{
			
			var overlayIndex:Number = _overlayHldr.numChildren;
			var underlayIndex:Number = _underlayHldr.numChildren;
			
			while( --overlayIndex > -1 ){
				
				VidPaneLayer( _overlayHldr.getChildAt( overlayIndex )).resizeTo( newW, newH );
				
			}
			
			while( --underlayIndex > -1 ){
				
				VidPaneLayer( _underlayHldr.getChildAt( underlayIndex )).resizeTo( newW, newH );
				
			}
			
		}
		
		private function _updateStillImageDims( newW:Number, newH:Number ):void{
			
			var stillImageIndex:Number = _stillImageHldr.numChildren;
			
			while( --stillImageIndex > -1 ){
				
				VidPaneLayer( _stillImageHldr.getChildAt( stillImageIndex )).resizeTo( newW, newH );
				
			}
			
		}
		
		public function set ui( ui:VidpaneUI ):void{
			
			while( _uiHldr.numChildren > 0 ){
				
				VidpaneUI( _uiHldr.getChildAt( 0 )).cleanUp();
				_uiHldr.removeChildAt( 0 );
				
			}
			
			_uiHldr.addChild( ui );
			
		}
		
		public function set videoMediaID( mId:String ):void{
			
			_mediaID = mId;
			
		}
		
		public function set skinDataID( skinDataID:String ):void{
			
			_skinDataID = skinDataID;
			
		}
		
		public function get overlay():Sprite{
			return _overlayHldr;
		}
		
		public function get underlay():Sprite{
			return _underlayHldr;
		}
		
		public function get stillImage():Sprite{
			return _stillImageHldr;
		}
		
		override public function get width():Number{
			return _vid.width;
		}
		
		override public function get height():Number{
			return _vid.height;
		}
		
		public function get id():String{
			return _id;
		}
		
		private function handleRemovedFromStage(e:Event = null):void{
			
			this.removeEventListener( Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage );
			
		}
		
	}
}