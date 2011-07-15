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

package com.xenocodex.audio.data{
	
	/**
	* Created: Jul 13, 2011, 3:45:37 PM
	*
	* @author		dsmith	
	* 
	*/
	public class SoundObj{
		
		public var id:String;
		public var uri:String;
		public var soundName:String;
		public var currentVol:Number;
		
		public var playing:Boolean = false;
		public var doLoop:Boolean = false;
		public var loopCount:Number = -1
		
		/**
		 * An object containing basic information about a sound object as well as some current state data for the sound this 
		 * data object represents.
		 *  
		 * @param id					An identifier that is used to reference the sound data
		 * @param uri				The uri of the sound file itself
		 * @param soundName	A human readable name for the sound. Could be used to display track name.
		 * 
		 */			
		public function SoundObj( id:String, uri:String, soundName:String = '', startVol:Number = 50){
			
			this.id = id;
			this.uri = uri;
			this.soundName = soundName;
			this.currentVol = startVol;
			
		}
		
	}
}