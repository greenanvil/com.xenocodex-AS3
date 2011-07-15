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

package com.xenocodex.support{
	
	import com.xenocodex.support.events.LocalMediaEvent;
	import com.xenocodex.util.ActionRelay;
	
	import flash.events.*;
	import flash.media.Camera;
	import flash.media.Microphone;
	
	public class LocalMedia{
		
		private static var _cam:Camera;
		private static var _mic:Microphone;
		
		private static var _accessPreGranted:Boolean = false;
		
		public function LocalMedia(){
		}
		
		public static function hasCam():Boolean{
			
			return ( Camera.names.length > 0 );
			
		}
		
		public static function get CAM():Camera{
			
			if( !_cam ){
				
				_cam = Camera.getCamera();	
				
				if( !_cam.muted ) _accessPreGranted = true;
				
				if( _cam ){
					
					_cam.addEventListener( StatusEvent.STATUS, _handleCamStatusEvent );
					
					ActionRelay.dispatchEvent( new LocalMediaEvent( LocalMediaEvent.CAM_ACQUIRED ));
					
					if( _accessPreGranted ) _handleCamStatusEvent({ value: 'Camera.Unmuted' });
					
				}
				
			}
			
			return _cam;
			
		}
		
		public static function hasMic():Boolean{
			
			return ( Microphone.names.length > 0 );
			
		}
		
		public static function get MIC():Microphone{
			
			if( !_mic ) _mic = Microphone.getMicrophone();
			
			return _mic;
			
		}
		
		public static function setCamQuality( w:Number, h:Number, fps:Number, bw:int, qual:int ):void{
			
			CAM.setMode( w, h, fps );
			CAM.setQuality( bw, qual );
			
		}
		
		private static function _handleCamStatusEvent( evt:* ):void{
			
			switch( evt.code ){
				
				case 'Camera.Muted':
					ActionRelay.dispatchEvent( new LocalMediaEvent( LocalMediaEvent.CAMERA_MUTED ));
					break;
				
				case 'Camera.Unmuted':
					ActionRelay.dispatchEvent( new LocalMediaEvent( LocalMediaEvent.CAMERA_UNMUTED ));
					break;
				
			}
			
		}
		
	}
}