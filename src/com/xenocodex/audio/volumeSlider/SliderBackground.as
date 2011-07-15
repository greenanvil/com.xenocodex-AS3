package com.xenocodex.audio.volumeSlider{

	import com.xenocodex.img.SlicedBmpSprite;
	
	import flash.display.*;
	import flash.events.*;
	
	
	/**
	* Created: May 28, 2011, 5:36:36 PM
	*
	* @author		dsmith	
	* 
	*/
	public class SliderBackground extends Sprite{
		
		private var _id:String;
		
		private var _height:Number;
		
		private var _bgHldr:Sprite;
		private var _bgSprite:SlicedBmpSprite;
		private var _skinXML:XML;
		
		public function SliderBackground( id:String ){
			
			super();
			
			_id = id;
			
			if ( this.stage ) {
				_build();
			} else {
				this.addEventListener( Event.ADDED_TO_STAGE, this.handleAddedToStage );
			}
			
		}
		
		private function _build():void{
			
			_bgHldr = new Sprite();
			
			this.addChild( _bgHldr );
			
		}
		
		public function set skinXML( skinXML:XML ):void{
			
			_skinXML = skinXML;
			
		}
		
		private function _draw():void{
			
			if( !_skinXML ) return;
			
			// clear the contents of the background holder
			while( _bgHldr.numChildren > 0 ){
				_bgHldr.removeChildAt( 0 );
				
			}
			
			_bgHldr.addChild( new SlicedBmpSprite( _skinXML, _height ));
			
		}
		override public function set height( newH:Number ):void{
			
			_height = newH;
			
			if( this.stage ) _draw();
			
		}
		
		private function handleAddedToStage(e:Event = null):void{
			
			this.removeEventListener( Event.ADDED_TO_STAGE, this.handleAddedToStage );
			
			_build();
			
		}
		
	}
}