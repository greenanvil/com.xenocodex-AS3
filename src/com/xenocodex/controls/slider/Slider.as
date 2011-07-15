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

package com.xenocodex.controls.slider{
	
	import com.xenocodex.controls.data.SliderData;
	import com.xenocodex.controls.slider.data.SliderSkinData;
	import com.xenocodex.controls.slider.thumbTab.ThumbTab;
	import com.xenocodex.img.BmpSprite;
	import com.xenocodex.img.ImgLib;
	import com.xenocodex.img.SlicedBmpSprite;
	import com.xenocodex.ui.BmpBtn;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Slider extends Sprite{
		
		private var _slideLength:Number = 100;
		
		private var _bgHldr:Sprite= new Sprite();
		private var _levelIndicator:Sprite= new Sprite();
		private var _levelIndicatorMask:Sprite= new Sprite();
		private var _dragThumb:ThumbTab = new ThumbTab();
		
		private var _data:SliderData;
		private var _skinData:SliderSkinData = new SliderSkinData();
		
		public function Slider(){
			
			super();
			
			if( this.stage ){
				this.build();
			} else {
				this.addEventListener( Event.ADDED_TO_STAGE, this.handleAddedToStage );
			}
			
		}
		
		public function build():void{
			
			this.addChild( _bgHldr );
			this.addChild( _levelIndicator );
			this.addChild( _levelIndicatorMask );
			this.addChild( _dragThumb );
			
		}
		
		public function set skinXML( xmlIN:XML ):void{
			
			// store the xml until sliced bmp supports a skin object (vs. just xml)
			_skinData.baseXML = xmlIN;
			
			_skinData.trayImgLibID = xmlIN.tray.@libImgName;
			_skinData.trayStartCapX = xmlIN.tray.startCap.@x;
			_skinData.trayStartCapY = xmlIN.tray.startCap.@y;
			_skinData.trayStartCapW = xmlIN.tray.startCap.@w;
			_skinData.trayStartCapH = xmlIN.tray.startCap.@h;
			
			_skinData.trayMidTileX = xmlIN.tray.startCap.@x;
			_skinData.trayMidTileY = xmlIN.tray.startCap.@y;
			_skinData.trayMidTileW = xmlIN.tray.startCap.@w;
			_skinData.trayMidTileH = xmlIN.tray.startCap.@h;
			
			_skinData.trayEndCapX = xmlIN.tray.startCap.@x;
			_skinData.trayEndCapY = xmlIN.tray.startCap.@y;
			_skinData.trayEndCapW = xmlIN.tray.startCap.@w;
			_skinData.trayEndCapH = xmlIN.tray.startCap.@h;
			
			_skinData.tabImgLibID = xmlIN.tab.@libImgName;
			_skinData.tabOffSliceX = xmlIN.tab.off.@x;
			_skinData.tabOffSliceY = xmlIN.tab.off.@y;
			_skinData.tabOffSliceW  = xmlIN.tab.off.@w;
			_skinData.tabOffSliceH = xmlIN.tab.off.@h;
			
			_skinData.tabOffSliceX = xmlIN.tab.over.@x;
			_skinData.tabOffSliceY = xmlIN.tab.over.@y;
			_skinData.tabOffSliceW  = xmlIN.tab.over.@w;
			_skinData.tabOffSliceH = xmlIN.tab.over.@h;
			
			this.updateSkin();
			
		}
		
		private function updateSkin():void{
			
			while( _bgHldr.numChildren > 0 ){
				_bgHldr.removeChildAt( 0 );
			}
			
			while( _dragThumb.numChildren > 0 ){
				_dragThumb.removeChildAt( 0 );
			}
			
			if( _skinData.baseXML.tray != undefined ) _bgHldr.addChild( new SlicedBmpSprite( _skinData.baseXML.tray[0], _slideLength, _skinData.baseXML.tray[0].@dynDim ));
			
			_levelIndicator = new Sprite();
			_levelIndicatorMask = new Sprite();
			
			_dragThumb.bmpBtnTab = new BmpBtn();
			_dragThumb.bmpBtnTab.skinXML = _skinData.baseXML.tab[0];
			_dragThumb.bmpBtnTab.draw();
			
			if( !isNaN( parseInt( _skinData.baseXML.tab[0].@xOffset ))) _dragThumb.x += parseInt( _skinData.baseXML.tab[0].@xOffset );
			if( !isNaN( parseInt( _skinData.baseXML.tab[0].@yOffset ))) _dragThumb.y += parseInt( _skinData.baseXML.tab[0].@yOffset );
			
		}
		
		private function handleAddedToStage( e:Event ):void{
			
			this.removeEventListener( Event.ADDED_TO_STAGE, this.handleAddedToStage );
			this.build();
			
		}
		
		public function get dragThumb():Sprite{
			return _dragThumb.bmpBtnTab;
		}
		
		public function get tray():Sprite{
			return _bgHldr;
		}
		
		public function set length( len:Number ):void{
			_slideLength = len;
		}
		
		public function get length():Number{
			return _slideLength;
		}
		
	}
}