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
	import com.xenocodex.video.VideoMediaObject;
	import com.xenocodex.video.events.VideoMediaEvent;
	
	import flash.media.Camera;
	import flash.media.Microphone;
	
	public class VideoLiveOut extends VideoMediaObject{
		
		public var vidSrc:Camera;
		public var audioSrc:Microphone;
		
		public function VideoLiveOut( id:String, data:Object ){
			
			super( id );
			
			this.vidSrc = LocalMedia.CAM;
			this.audioSrc = LocalMedia.MIC;
			
			this.dispatchEvent( new VideoMediaEvent( VideoMediaEvent.VID_SRC_SET, _id ));
			
		}
		
	}
}