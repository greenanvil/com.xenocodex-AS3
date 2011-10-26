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

package com.xenocodex.audio{
	
	import com.xenocodex.audio.data.SoundObj;
	import com.xenocodex.audio.events.SimpleSoundEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	/**
	* Created: Jul 13, 2011, 3:43:39 PM
	*
	* @author		dsmith	
	* 
	*/
	public class SimpleSoundPlayer{
		
		protected static var EVT_DISP:EventDispatcher;
		
		private var _playlist:SimplePlaylist;
		private var _lastRequestedID:String;
		private var _lastPlayedID:String;
		private var _currentlyPlayingID:String;
		
		private var _sound:Sound;
		private var _soundChannel:SoundChannel = new SoundChannel();
		
		private var _currSoundObj:SoundObj;
		
		private var _playing:Boolean = false;
		
		/**
		 * SimpleSound is a simple headless sound player mechanism. It has a SoundObjPlaylist assigned to it 
		 * which is an iterator model data object containing a listing of SoundObj objects. SoundObj objects contain 
		 * information about sounds. SimpleSound listenes to ActionRelay for SimpleSoundEvent events as well as 
		 * dispatches SimpleSoundEvent events via ActionRelay.
		 * 
		 */
		public function SimpleSoundPlayer( pList:SimplePlaylist = null ){
			
			_playlist = pList;
			
		}
		
		/**
		 * Plays a sound stored in the player's SimplePlaylist instance. If no soundID is passed in, the player will play
		 * the first registered sound in the playlist. you may optionally pass in a second argument for the volume at which
		 * the sound should be played.
		 * 
		 * @param soundID		The id in the SimplePlaylist of the sound that should be played
		 * @param playVol			The volume that the sound should be played at
		 * 
		 */		
		public function playSound( soundID:String = null, playVol:Number = -1, tstamp:Number = 0 ):void{
			
			// dont do anything if there is no playlist
			if( !_playlist ) return;
			
			// if something is playing, stop it
			if( _playing ){
				this.stop();
			}
			
			// get the first registered sound if none is passed in by calling next
			if( !soundID ) soundID = _playlist.getFirstSound().id;
			
			_currSoundObj = _playlist.getSoundById( soundID );
			
			if( _currSoundObj.id != _currentlyPlayingID ){
				
				_lastRequestedID = soundID;
				
				_sound = new Sound();
				_sound.load( new URLRequest( _currSoundObj.uri ));
				
				_currentlyPlayingID = _currSoundObj.id;
				
			}
			
			_lastPlayedID = soundID;
			
			_soundChannel = _sound.play( tstamp );
			_soundChannel.addEventListener( Event.SOUND_COMPLETE, _handleSoundEvent );
			
			_playing = true;
			
			SimpleSoundPlayer.dispatchEvent( new SimpleSoundEvent( SimpleSoundEvent.PLAYING, _currSoundObj ));
			
		}
		
		/**
		 * Stops the current sound that the SimpleSoundPlayer is currently playing. 
		 * 
		 */		
		public function stop():void{
			
			_soundChannel.stop();
			_playing = false;
			
			SimpleSoundPlayer.dispatchEvent( new SimpleSoundEvent( SimpleSoundEvent.STOPPED, _currSoundObj ));
			
		}
		
		/**
		 * NOT IMPLEMENTED. Stops the currently playing sound and plays the next sound in the SimplePlaylist. If there is only one sound 
		 * registered with the playlist, it restarts the sound. 
		 * 
		 */		
		public function playNext():void{
			
		}
		
		/**
		 * NOT IMPLEMENTED. Stops the currently playing sound and plays the previous sound in the SimplePlaylist. If there is only one sound 
		 * registered with the playlist, it restarts the sound. 
		 * 
		 */		
		public function playPrevious():void{
			
		}
		
		/**
		 * NOT IMPLEMENTED. Restarts the currently playing sound. If no sound is playing, it will play the sound that is registered in the 
		 * SimplePlaylist that was played last. If no sound has been played yet, the first registered sound will begin playback 
		 * 
		 */		
		public function restartSound():void{
			
		}
		
		public function set playlist( pList:SimplePlaylist ):void{
			
			_playlist = pList;
			
		}
		
		public function get playlist():SimplePlaylist{
			
			return _playlist;
			
		}
		
		private function _handleSoundEvent( evt:Event ):void{
			
			switch( evt.type ){
				
				case Event.SOUND_COMPLETE:
					
					_playing = false;
					
					_soundChannel.removeEventListener( Event.SOUND_COMPLETE, _handleSoundEvent );
					SimpleSoundPlayer.dispatchEvent( new SimpleSoundEvent( SimpleSoundEvent.STOPPED, _currSoundObj ));
					break;
				
			}
			
		}
		
		public function get playing():Boolean{
			
			return _playing;
			
		}
		
		public function get currentlyPlayingID():String{
			
			return _currentlyPlayingID;
			
		}
		
		public function get timestamp():Number{
			
			return _soundChannel.position;
			
		}
		
		public function get lastRequestedID():String{
			
			return _lastRequestedID;
			
		}
		
		public function get lastPlayedID():String{
			
			return _lastPlayedID;
			
		}
		
		public static function addEventListener(...p_args:Array):void{
			
			if(EVT_DISP == null) EVT_DISP = new EventDispatcher();
			EVT_DISP.addEventListener.apply(null, p_args);
			
		}
		
		public static function removeEventListener(...p_args:Array):void{
			
			if(EVT_DISP == null) return;
			EVT_DISP.removeEventListener.apply(null, p_args);
			
		}
		
		public static function dispatchEvent(...p_args:Array):void{
			
			if(EVT_DISP == null) return;
			EVT_DISP.dispatchEvent.apply(null, p_args);
			
		}
		
	}
}