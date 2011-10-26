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
	
	import flash.utils.Dictionary;
	
	/**
	* Created: Jul 13, 2011, 3:44:57 PM
	*
	* @author		dsmith	
	* 
	*/
	public class SimplePlaylist{
		
		private var _currentSoundIndex:Number = -1;
		private var _soundDict:Dictionary = new Dictionary();
		private var _soundList:Array = new Array();
		
		private static var _playListDict:Dictionary = new Dictionary();
		
		/**
		 * Creates a SimplePlaylist object and registeres it with the private static collection _playListDict.
		 * @param id		The identifier that is used to reference the playlist in _playListDict
		 * 
		 */		
		public function SimplePlaylist( id:String ){
			
			_playListDict[ id ] = this;
			
		}
		
		/**
		 * Returns a SimplePlaylist registered to the provided ID if one is present in the  _playListDict collection.
		 * @param id		The identifier that is used to reference the playlist in _playListDict
		 * @return 
		 * 
		 */		
		public static function getPlaylistByID( id:String ):SimplePlaylist{
			
			return _playListDict[ id ];
			
		}
		
		/**
		 * Destroys a SimplePlaylist registered to the provided ID if one is present in the  _playListDict collection.
		 * @param id		The identifier that is used to reference the playlist in _playListDict
		 * @return 
		 * 
		 */	
		public static function destroyPlaylistById( id:String ):void{
			
			if( _playListDict[ id ] == null ) return;
			
			_playListDict[ id ] = null;
			delete _playListDict[ id ];
			
		}
		
		/**
		 *	Creates a SoundObj from passed in values to be registered with the SimplePlaylist. 
		 * @param soundID		The ID that the sound can be referred to by
		 * @param loc				The URI of the sound file
		 * @param startVolume	The starting volume for the sound
		 * 
		 */
		public function registerSound( soundID:String, uri:String, soundName:String = '', startVolume:Number = 50 ):SoundObj{
		
			// create the sound object and call registerSoundObj
			return this.registerSoundObj( new SoundObj( soundID, uri, soundName, startVolume ));
		
		}
		
		/**
		 * Registers a SoundObj with the SimplePlaylist 
		 * @param soundObj		The SoundObj to be registered
		 * 
		 */		
		public function registerSoundObj( soundObj:SoundObj ):SoundObj{
		
			// register the sound with the dictionary
			_soundDict[ soundObj.id ] = soundObj;
			
			// push the sound onto the stack
			_soundList.push( soundObj );
			
			return _soundDict[ soundObj.id ];
		
		}
		
		/**
		 * Returns the SoundObj at the next highest index in the soundList. If the current index is the last sound in the list or 
		 * if there is no currentSoundIndex, the sound at index 0 is returned. 
		 * @return 
		 * 
		 */		
		public function get next():SoundObj{
			
			// if there are no registered sounds, return null
			if( _soundList.length == 0 ) return null;
			
			_updateSoundIndex();
			
			return _soundList[ _currentSoundIndex ];
			
		}
		
		/**
		 *  Returns the SoundObj at the previous index in the soundList. If the current index is the first sound in the list, the sound at soundList.length - 1 is returned. 
		 * @return 
		 * 
		 */		
		public function get last():SoundObj{
		
			// if there are no registered sounds, return null
			if( _soundList.length == 0 ) return null;
			
			_updateSoundIndex(-1);
			
			return _soundList[ _currentSoundIndex ];
			
		}
		
		/**
		 * Returns the SoundObject stored in _soundList at the provided index if one is present or null if one is not.  
		 * @param soundIndex	The index of the desired sound
		 * @return 
		 * 
		 */		
		public function getSoundAtIndex( soundIndex:Number ):SoundObj{
			
			return SoundObj( _soundList[ _currentSoundIndex ] );
			
		}
		
		/**
		 * Returns the first registered sound in  _soundList;
		 * @return 
		 * 
		 */		
		public function getFirstSound():SoundObj{
			
			return SoundObj( _soundList[ 0 ] );
			
		}
		
		/**
		 * Returns the SoundObj stored in _soundDict as identified by the passed in soundID if a sound is stored with that ID or null if not. 
		 * @param soundID		The ID of the desired sound
		 * @return 
		 * 
		 */		
		public function getSoundById( soundID:String ):SoundObj{
			
			return _soundDict[ soundID ];
			
		}
		
		private function _updateSoundIndex( dir:Number = 1 ):void{
			
			var rtrn:Number;
			
			// if we want to move backwards, default to to the last sound. Otherwise default to 0.
			var soundID:Number = dir < 0 ? _soundList.length - 1 : 0;
			
			// if we're moving backwards, there was a previous sound and the last sound to play was not the last sound in the list
			if( dir < 0 && ( _currentSoundIndex > -1 && _currentSoundIndex != 0 )){
				
				_currentSoundIndex--;
				
			} else if( _currentSoundIndex > -1 && _currentSoundIndex != _soundList.length - 1 ){ // otherwise, if there was a previous sound and the last sound to play was not the last sound in the list
				
				 _currentSoundIndex++;
				
			}
			
		}
		
	}
}