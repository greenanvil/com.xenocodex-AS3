package com.xenocodex.audio.uvMeter{

	import flash.display.Sprite;
	
	
	/**
	* Created: May 30, 2011, 10:23:47 AM
	*
	* @author		dsmith	
	* 
	*/
	public class UvMeter extends Sprite{
		
		private var _data:UvMeterData;
		
		private var _bgHldr:Sprite = new Sprite();
		private var _unitsHldr:Sprite = new Sprite();
		private var _unitsMask:Sprite = new Sprite();
		
		public function UvMeter( data:UvMeterData ){
			
			super();
			
			_data = data;
			
			_build();
			
		}
		
		private function _build():void{
			
			this.addChild( _bgHldr );
			this.addChild( _unitsHldr );
			this.addChild( _unitsMask );
			
			_buildBg();
			
		}
		
		private function _buildBg():void{
			
			var unitCount:int = _data.unitCount;
			
			for( var i:Number=0; i < unitCount; i++ ){
				
				var newUnit:Sprite = _createUnit( _data.bgColor );
				
				newUnit.y = i * ( _data.unitH + _data.padding );
				_bgHldr.addChild( newUnit );
				
			}
			
		}
		
		private function _createUnit( unitColor:Number ):Sprite{
			
			var newUnitBg:Sprite = new Sprite();
			newUnitBg.graphics.beginFill( unitColor );
			
			if( _data.cornerRadius > 0 ){
				newUnitBg.graphics.drawRoundRect( 0, 0, _data.unitW, _data.unitH, _data.cornerRadius, _data.cornerRadius );
			} else {
				newUnitBg.graphics.drawRect( 0, 0, _data.unitW, _data.unitH );
			}
			
			newUnitBg.graphics.endFill();
			
			return newUnitBg;
			
		}
		
	}
}