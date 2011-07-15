package com.xenocodex.video.vidPaneSupport.data{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;

	
	/**
	* Created: May 31, 2011, 10:11:16 PM
	*
	* @author		dsmith	
	* 
	*/
	public class VidpaneSkinData{
		
		public static var BG_STYLE_SOLID:String = 'com.xenocodex.video.vidPaneSupport.data.VidpaneSkinData.BG_STYLE_SOLID';
		
		private static var _SKIN_DATA_DICT:Dictionary = new Dictionary();
		
		public var bgStyle:String;
		public var bgColors:Array = new Array();
		public var bgAlphas:Array = new Array();
		public var bgRatios:Array = new Array();
		public var bgAngle:Number = 0;
		public var bgMatrix:Matrix;
		
		public function VidpaneSkinData(){
		}
		
		public static function loadSkinXml( xmlIn:XMLList ):void{
			
			for each( var vidpane:XML in xmlIn ){
				
				var vidpaneID:String = vidpane.@id.toString()
				
				_SKIN_DATA_DICT[ vidpaneID ] = new VidpaneSkinData();
				
				switch( vidpane.styles.bg[0].@type.toString() ){
					
					case 'radial':
						_SKIN_DATA_DICT[ vidpaneID ].bgStyle = GradientType.RADIAL;
						break;
					
					case 'linear':
						_SKIN_DATA_DICT[ vidpaneID ].bgStyle = GradientType.LINEAR;
						break;
					
					default:
						_SKIN_DATA_DICT[ vidpaneID ].bgStyle = VidpaneSkinData.BG_STYLE_SOLID;
						break;
					
				}
				
				// save color and alpha data for the background
				for each( var colorData:XML in vidpane.styles.bg[0].color ){
					
					_SKIN_DATA_DICT[ vidpaneID ].bgColors.push( parseInt( colorData.@value.toString()));
					_SKIN_DATA_DICT[ vidpaneID ].bgAlphas.push(( colorData.@alpha.toString() != '' ) ? parseFloat( colorData.@alpha.toString()) : 1 );
					
				}
				
				_SKIN_DATA_DICT[ vidpaneID ].bgRatios = ( vidpane.styles.bg[0].@ratios.toString() == '' ) ? String( vidpane.styles.bg[0].@ratios.toString()).split( ' ' ) : [ 0, 255 ];
				_SKIN_DATA_DICT[ vidpaneID ].bgAngle = parseFloat( vidpane.styles.bg[0].@angle.toString());
				
			}
			
		}
		
		public static function getSkinDataById( vidpaneID:String ):VidpaneSkinData{
			
			return _SKIN_DATA_DICT[ vidpaneID ];
			
		}
		
	}
}