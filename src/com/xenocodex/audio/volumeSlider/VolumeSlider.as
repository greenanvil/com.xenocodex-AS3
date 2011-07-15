package com.xenocodex.audio.volumeSlider{
	
	import com.xenocodex.audio.uvMeter.UvMeter;
	import com.xenocodex.audio.uvMeter.UvMeterData;
	import com.xenocodex.audio.volumeSlider.data.VolumeSliderData;
	import com.xenocodex.audio.volumeSlider.events.VolumeSliderEvent;
	import com.xenocodex.img.SlicedBmpSprite;
	import com.xenocodex.util.ActionRelay;
	
	import flash.display.Sprite;
	import flash.events.*;
	
	/**
	 * Created: May 28, 2011, 3:00:00 PM
	 * @author		dsmith	
	 * 
	 */
	public class VolumeSlider extends Sprite{
		
		private var _data:VolumeSliderData;
		
		private var _sliderHeight:Number = 240; // design is 237
		
		private var _bg:SliderBackground;
		private var _uvMeterBg:SliderBackground;
		
		private var _paddingTop:Number;
		private var _paddingRight:Number;
		private var _paddingBottom:Number;
		private var _paddingLeft:Number;
		
		private var _uvMeter:UvMeter;
		private var _uvMeterX:int;
		private var _uvMeterY:int;
		
		public function VolumeSlider( id:String ){
			
			super();
			
			_data = VolumeSliderData.getSliderDataById( id );
			
			this.addEventListener( Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage );
			
			if ( this.stage ) {
				this.build();
			} else {
				this.addEventListener( Event.ADDED_TO_STAGE, this.handleAddedToStage );
			}
			
		}
		
		private function setupEventListeners():void{
			
//			ActionRelay.addEventListener( StatusMessageEvent.LOAD_STATUS, this.handleStatusEvent );
//			ActionRelay.addEventListener( StatusMessageEvent.IRC_STATUS, this.handleStatusEvent );
			
		}
		
		private function build():void{
			
			this.setupEventListeners();
			
			var skinXML:XML = 
				<skin>
					<slider id="micVolumeSlider">
						<bg id="main" libImgName="sliderSprite">
							<slice x="0" y="46" w="28" h="3" />
							<slice x="0" y="49" w="28" h="1" isTile="1" />
							<slice x="0" y="50" w="28" h="3" />
						</bg>
						<bg id="inner" libImgName="sliderSprite" padding="4 0 5 4" >
							<slice w="20" h="3" x="12" y="0" />
							<slice w="20" h="1" x="12" y="3" isTile="1" />
							<slice w="20" h="3" x="12" y="4" />
						</bg>
						<uvMeter bgColor="0x292929" x="8" y="9" unitCount="17" />
						<tab>
							<off libImgName="sliderSprite">
								<slice w="11" h="1" x="0" y="3" />
								<slice w="11" h="1" x="0" y="4" isTile="1" />
								<slice w="11" h="1" x="0" y="5" />
							</off>
							<over libImgName="sliderSprite">
								<slice w="11" h="1" x="0" y="6" />
								<slice w="11" h="1" x="0" y="7" isTile="1" />
								<slice w="11" h="1" x="0" y="8" />
							</over>
						</tab>
					</slider>
				</skin>;
			
			_buildMainBackground( skinXML );
			_buildUVMeter( skinXML );
			_buildUvMeterBg( skinXML );
			
			this.layout();
			
		}
		
		private function _parseSkinXml( skinXML:XML ):void{
			
			
			
		}
		
		private function _buildMainBackground( skinXML:XML ):void{
			
			_bg = new SliderBackground( 'main' );
			
			var dbug:XML = skinXML.slider.(@id == 'micVolumeSlider').bg.(@id == 'main')[0];
			
			_bg.skinXML = skinXML.slider.(@id == 'micVolumeSlider').bg.(@id == 'main')[0];
			
			this.addChild( _bg );
			
		}
		
		private function _buildUVMeter( skinXML:XML ):void{
			
			// build the uv meter data object
			var meterData:UvMeterData = new UvMeterData();
			meterData.bgColor = parseInt( skinXML..uvMeter[0].@bgColor );
			meterData.unitCount = parseInt( skinXML..uvMeter[0].@unitCount );
			
			// build the uv meter
			_uvMeter = new UvMeter( meterData );
			_uvMeter.x = parseInt( skinXML..uvMeter[0].@x );
			_uvMeter.y = parseInt( skinXML..uvMeter[0].@y );
			
			// build the uv meter background
			_uvMeterBg = new SliderBackground( 'inner' );
			
			var innerBgSkinXML:XML = skinXML.slider.(@id == 'micVolumeSlider').bg.(@id == 'inner')[0];
			
			var paddingArr:Array = String( innerBgSkinXML.@padding ).split( ' ' );
			_paddingTop = ( paddingArr.length > 0 && !isNaN( parseInt( paddingArr[ 0 ])) ) ? parseInt( paddingArr[ 0 ] ) : 0;
			_paddingLeft = ( paddingArr.length > 0 && !isNaN( parseInt( paddingArr[ 3 ])) ) ? parseInt( paddingArr[ 3 ] ) : 0;
			_paddingBottom = ( !isNaN( parseInt( paddingArr[ 2 ] )) ) ? parseInt( paddingArr[ 2 ] ) : 0;
			
			_uvMeterBg.skinXML = innerBgSkinXML;
			
			this.addChild( _uvMeterBg );
			
			this.addChild( _uvMeter );
			
		}
		
		private function _buildUvMeterBg( skinXML:XML ):void{
			
			
			
		}
		
		private function layout():void{
			
			// apply the stored height to the main background
			_bg.height = _sliderHeight;
			
			_uvMeterBg.height = _sliderHeight - _paddingTop - _paddingBottom;
			_uvMeterBg.x = _paddingLeft;
			_uvMeterBg.y = _paddingTop;
			
			// dispatch layout update event
			ActionRelay.dispatchEvent( new VolumeSliderEvent( VolumeSliderEvent.LAYOUT_UPDATE, _data.id ));
			
		}
		
		override public function set height( newH:Number ):void{
			
			// set the stored height of the volume slider
			_sliderHeight = newH;
			
			if( this.stage ){
				this.layout();
			}
			
		}
		
		private function handleAddedToStage(e:Event = null):void{
			
			this.removeEventListener( Event.ADDED_TO_STAGE, this.handleAddedToStage );
			
			this.build();
			
		}
		
		private function handleRemovedFromStage(e:Event = null):void{
			
			this.removeEventListener( Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage );
			
			// Cleanup procedures
			
		}
		
	}
}