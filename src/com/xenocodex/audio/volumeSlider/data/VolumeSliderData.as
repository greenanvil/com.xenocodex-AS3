package com.xenocodex.audio.volumeSlider.data{
	import flash.utils.Dictionary;
	
	/**
	* Created: May 28, 2011, 4:46:29 PM
	* @author		dsmith	
	* 
	*/
	public class VolumeSliderData{
		
		private static var _SLIDER_DICT:Dictionary = new Dictionary();
		
		private var _id:String;
		
		public var volume:Number;
		
		public function VolumeSliderData( id:String ){
			
			_id = id;
			
		}
		
		/**
		 * Creates or returns an already created VolumeSliderData object. 
		 * @param id
		 * 
		 */		
		public static function getSliderDataById( id:String ):VolumeSliderData{
			
			if( _SLIDER_DICT[ id ] == null ){
				_SLIDER_DICT[ id ] = new VolumeSliderData( id );
			}
			
			return _SLIDER_DICT[ id ];
			
		}
		
		public function get id():String{
			
			return _id;
			
		}
		
	}
}