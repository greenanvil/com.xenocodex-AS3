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

package com.xenocodex.video.vidPaneSupport{
	
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Sine;
	import com.xenocodex.ui.BmpBtn;
	import com.xenocodex.ui.SimpleFrame;
	import com.xenocodex.ui.controlGroup.ControlGroup;
	import com.xenocodex.ui.controlGroup.NavBg;
	import com.xenocodex.video.VidPane;
	import com.xenocodex.video.vidPaneSupport.data.VidpaneUIData;
	import com.xenocodex.video.vidPaneSupport.enum.VidpaneUIMode;
	import com.xenocodex.video.vidPaneSupport.events.VidPaneEvent;
	import com.xenocodex.video.vidPaneSupport.events.VidPaneUIEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.xml.XMLNode;
	
	public class VidpaneUI extends Sprite{
		
		private var _mode:String;
		
		private var _resizing:Boolean = false;
		private var _resizeTimer:Timer;
		
		private var _resizeRefX:Number = 0;
		private var _resizeRefY:Number = 0;
		private var _resizeDiffX:Number = 0;
		private var _resizeDiffY:Number = 0;
		
		private var _w:int = 100;
		private var _h:int = 30;
		
		private var _upperMask:Sprite = new Sprite();
		private var _lowerMask:Sprite = new Sprite();
		
		private var _upperCtrlGroup:ControlGroup = new ControlGroup();
		private var _lowerCtrlGroup:ControlGroup = new ControlGroup();
		
		private var _upperCtrlTween:GTween;
		private var _lowerPanelTween:GTween;
		
		private var _attachedVidpane:VidPane;
		
//		private var _frame:SimpleFrame = new SimpleFrame();
		
		private var _bResize:BmpBtn;
		private var _bSnapshot:BmpBtn;
		
		private var _libImgName:String = 'vidpaneSprite';
		
		public var skinXML:XML;
		
		public function VidpaneUI(){
			
			super();
			
			_mode = VidpaneUIMode.HORIZONTAL;
			
			_upperCtrlTween = new GTween( _upperCtrlGroup, .2 );
			_upperCtrlTween.ease = Sine.easeInOut;
			
			_lowerPanelTween = new GTween( _lowerCtrlGroup, .2 );
			_lowerPanelTween.ease = Sine.easeInOut;
			
			this.skinXML = <skinXML />;
			
		}
		
		public function build():void{
			
			this.addChild( _upperMask );
			this.addChild( _lowerMask );
			
			_upperCtrlGroup.bg = new NavBg();
			this.addChild( _upperCtrlGroup );
			
			_lowerCtrlGroup.bg = new NavBg();
			this.addChild( _lowerCtrlGroup );
			
			this.attachUpperCtrlButtons();
			this.attachLowerCtrlButtons();
			
//			this.addChild( _frame );
			
			this.layout();
			
		}
		
		private function attachUpperCtrlButtons():void{
			
			if( !this.skinXML ){
				
				trace( this + ' > attachUpperCtrlButtons() > no skin xml set' );
				return;
				
			}
			
			// attach snapshot button if a definition is found in the config xml
			if( this.skinXML.bSnapshot[0] && this.skinXML.bSnapshot[0].@libImgName != '' ){
				
				_bSnapshot = new BmpBtn();
				
				_bSnapshot.setSkinXML( this.skinXML.bSnapshot[0] );
				_bSnapshot.draw();
				
				_bSnapshot.addEventListener( MouseEvent.MOUSE_DOWN, this.handleSnapshotEvent );
				
				_upperCtrlGroup.addChild( _bSnapshot );
				
			}
			
		}
		
		private function attachLowerCtrlButtons():void{
			
			if( !this.skinXML ){
				
				trace( this + ' > attachLowerCtrlButtons() > no skin xml set' );
				return;
				
			}
			
			if( this.skinXML.bResize[0] && this.skinXML.bResize[0].@libImgName != '' ){
				
				_bResize = new BmpBtn();
				
				_bResize.setSkinXML( this.skinXML.bResize[0] );
				_bResize.draw();
				
				_bResize.addEventListener( MouseEvent.MOUSE_DOWN, this.handleResizeMouseEvent );
				
				_lowerCtrlGroup.addChild( _bResize );
			}
			
		}
		
		private function drawMask():void{
			
			_upperMask.graphics.clear();
			_upperMask.graphics.beginFill( 0x000000, .5 );
			_upperMask.graphics.drawRect( 0, 0, _w, _h );
			_upperMask.graphics.endFill();
			
			_lowerMask.graphics.clear();
			_lowerMask.graphics.beginFill( 0x000000, .5 );
			_lowerMask.graphics.drawRect( 0, 0, _w, _h );
			_lowerMask.graphics.endFill();
			
			_upperCtrlGroup.mask = _upperMask;
			_lowerCtrlGroup.mask = _lowerMask;
			
		}
		
		private function draw():void{
			
			this.drawMask();
			
			_upperCtrlGroup.data.shownW = _w;
			_upperCtrlGroup.data.shownH = _upperCtrlGroup.groupHeight;
			
			_lowerCtrlGroup.data.shownW = _w;
			_lowerCtrlGroup.data.shownH = _lowerCtrlGroup.groupHeight;
			
			this.updateCrtlSlideData();
			
			_upperCtrlGroup.bg.draw( _w, _upperCtrlGroup.groupHeight );
			_lowerCtrlGroup.bg.draw( _w, _lowerCtrlGroup.groupHeight );
			
		}
		
		private function layout():void{
			
			this.draw();
			
//			_frame.dims = [ _w, _h ];
			
			_upperCtrlGroup.data.shownX = 0;
			_upperCtrlGroup.data.shownY = 0;
			
			_lowerCtrlGroup.data.shownX = 0;
			_lowerCtrlGroup.data.shownY = _h - _lowerCtrlGroup.groupHeight;
			
			_lowerCtrlGroup.x = _lowerCtrlGroup.data.shownX;
			_lowerCtrlGroup.y = _lowerCtrlGroup.data.shownY;
			
			if( _bResize ) _bResize.x = _lowerCtrlGroup.bg.width - _bResize.width - _lowerCtrlGroup.margin;
			if( _bResize ) _bResize.y = _lowerCtrlGroup.bg.height - _bResize.height - _lowerCtrlGroup.margin;
			
			if( _bSnapshot ) _bSnapshot.x = this.skinXML.bSnapshot.layout.@topMargin;
			if( _bSnapshot ) _bSnapshot.y = this.skinXML.bSnapshot.layout.@sideMargin;
			
		}
		
		private function updateCrtlSlideData():void{
			
			_upperCtrlGroup.data.hiddenX = _upperCtrlGroup.data.shownX;
			_upperCtrlGroup.data.hiddenY = _upperCtrlGroup.data.shownH * -1;
			
			_lowerCtrlGroup.data.hiddenX = _lowerCtrlGroup.data.shownX;
			_lowerCtrlGroup.data.hiddenY = _h;
			
		}
		
		public function attachToVidPane( vp:VidPane ):void{
			
			vp.addEventListener( VidPaneEvent.UPDATE_LAYOUT, this.handleVidpaneLayoutUpdate );
			vp.addEventListener( MouseEvent.MOUSE_OVER, this.handleVidpaneMouseEvent );
			vp.addEventListener( MouseEvent.MOUSE_OUT, this.handleVidpaneMouseEvent );
			
			// assigning the ui property of the vidpane adds the VidpaneUI to the vidpanes display list
			vp.ui = this;
			
			_w = vp.width;
			_h = vp.height;
			
			_attachedVidpane = vp;
			
			this.build();
			
		}
		
		private function set minWidth( mw:Number ):void{
			
			switch( _mode ){
				
				case VidpaneUIMode.HORIZONTAL:
					_h = mw;
					break;
				
				case VidpaneUIMode.VERTICAL:
					_w = mw;
					break;
				
			}
			
			this.draw();
			
		}
		
		private function handleVidpaneLayoutUpdate( e:VidPaneEvent ):void{
			
			_w = e.dataObj.width;
			_h = e.dataObj.height;
			
			this.x = e.dataObj.x;
			this.y = e.dataObj.y;
			
			this.layout();
			
		}
		
		private function handleVidpaneMouseEvent( e:MouseEvent ):void{
			
			switch( e.type ){
				
				case MouseEvent.MOUSE_OVER:
					this.showUI();
					break;
				
				case MouseEvent.MOUSE_OUT:
					if( this.mouseX > _w || this.mouseY > _h || this.mouseX < 0  || this.mouseY < 0 ) this.hideUI();
					break;
				
			}
			
		}
		
		private function handleResizeMouseEvent( e:MouseEvent ):void{
			
			switch( e.type ){
				
				case MouseEvent.MOUSE_DOWN:
					
					this.stage.addEventListener( MouseEvent.MOUSE_UP, this.handleResizeMouseEvent );
					
					this.resizeStart();
					break;
				
				case MouseEvent.MOUSE_UP:
					
					this.stage.removeEventListener( MouseEvent.MOUSE_UP, this.handleResizeMouseEvent );
					
					this.resizeStop();
					break;
				
			}
			
		}
		
		private function handleSnapshotEvent( e:MouseEvent ):void{
			
			this.dispatchEvent( new VidPaneUIEvent( VidPaneUIEvent.SNAPSHOT, { vidPane: _attachedVidpane } ));
			
		}
		
		private function resizeStart():void{
			
			_resizing = true;
			
			_resizeTimer = new Timer( 100 );
			_resizeTimer.addEventListener( TimerEvent.TIMER, this.handleResizeTimerEvent );
			_resizeTimer.start();
			
		}
		
		private function resizeStop():void{
			
			_resizeTimer.stop();
			_resizing = false;
			
			if( this.mouseX > _w || this.mouseY > _h || this.mouseX < 0  || this.mouseY < 0  ) this.hideUI();
			
		}
		
		private function handleResizeTimerEvent( e:TimerEvent ):void{
			
			var vidSizeW:Number, vidSizeH:Number; 
			
			/*
			if( this.mouseX / this.mouseY > 1.333 ){
				
				vidSizeW = ( this.mouseY * 4 ) / 3;
				vidSizeH = this.mouseY;
				
			} else {
				
				vidSizeW = this.mouseX;
				vidSizeH = (this.mouseX * 3 ) / 4;
				
			}
			*/
			
			vidSizeW = this.mouseX;
			vidSizeH = (this.mouseX * 3 ) / 4;
			
			this.dispatchEvent( new VidPaneUIEvent( VidPaneUIEvent.DO_RESIZE, { vidW: vidSizeW, vidH: vidSizeH } ));
			
		}
		
		private function showUI():void{
			
			if( _resizing ) return;
			
			_upperCtrlTween.proxy.x = _upperCtrlGroup.data.shownX;
			_upperCtrlTween.proxy.y = _upperCtrlGroup.data.shownY;
			
			_lowerPanelTween.proxy.x = _lowerCtrlGroup.data.shownX;
			_lowerPanelTween.proxy.y = _lowerCtrlGroup.data.shownY;
			
		}
		
		private function hideUI():void{
			
			if( _resizing ) return;
			
			_upperCtrlTween.proxy.x = _upperCtrlGroup.data.hiddenX;
			_upperCtrlTween.proxy.y = _upperCtrlGroup.data.hiddenY;
			
			_lowerPanelTween.proxy.x = _lowerCtrlGroup.data.hiddenX;
			_lowerPanelTween.proxy.y = _lowerCtrlGroup.data.hiddenY;
			
		}
		
		public function cleanUp():void{
			
		}
		
		public function set mode( modeIN:String ):void{
			
			_mode = modeIN;
			
			this.layout();
			
		}
		
		public function set libImgName( strID:String ):void{
			_libImgName = strID;
		}
		
	}
}