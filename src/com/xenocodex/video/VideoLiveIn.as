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
	
	import com.xenocodex.support.LocalMedia;
	import com.xenocodex.video.VideoMediaManager;
	import com.xenocodex.video.VideoMediaObject;
	import com.xenocodex.video.events.VideoMediaEvent;
	
	import flash.media.Camera;
	import flash.media.SoundTransform;
	import flash.net.NetStream;
	
	public class VideoLiveIn extends VideoMediaObject{
		
		private var _vidSrc:NetStream;
		
		public function VideoLiveIn( id:String, data:Object ){
			
			super( id );
			
		}
		
		private function getFMSFeed( mediaID:String ):void{
			
			
			
		}
		
		public function set vidSrc( ns:NetStream ):void{
			
			_vidSrc = ns;
			
			this.dispatchEvent( new VideoMediaEvent( VideoMediaEvent.VID_SRC_SET, _id ));
			
		}
		
		public function get vidSrc():NetStream{
			
			return _vidSrc;
			
		}
		
		public function setVolume( volLevel:Number ):void{
			
			if( _vidSrc == null ) return;
			
			var transform:SoundTransform = _vidSrc.soundTransform
			transform.volume = volLevel;
			_vidSrc.soundTransform = transform;
			
		}
		
	}
}