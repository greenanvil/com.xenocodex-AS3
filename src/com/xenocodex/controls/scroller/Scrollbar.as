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

package com.xenocodex.controls.scroller{
	
	import com.xenocodex.img.ImgLib;
	import com.xenocodex.img.SlicedBmpSprite;
	import com.xenocodex.controls.scroller.events.ScrollTabEvent;
	import com.xenocodex.controls.scroller.events.ScrollBarEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author dsmith
	 */
	public class Scrollbar extends Sprite{
		
		private var totalLen:int = 0, sizeRatio:Number = 1, trayLen:int = 1, trgtPos:Number = 0, currPosRat:Number = 0;
		private var dragSpecs:Object = {topL:0, topR:0, throwLen:0};
		
		private var trayBmp:Bitmap = new Bitmap();
		private var tray:ScrollTray = new ScrollTray();
		private var scrollTab:ScrollTab;
		private var bTop:ScrollBtn = new ScrollBtn();
		private var bBottom:ScrollBtn = new ScrollBtn();
		
		private var _w:int = 0;
		private var _h:int = 0;
		
		private var _maxY:Number;
		
		private var tabHWtchr:Timer, imgLib:ImgLib, skinXML:XML;
		
		public function Scrollbar() {
			this.init();
		}
		
		private function init():void {
			this.imgLib = ImgLib.getImgLib();
			this.tabHWtchr = new Timer(100);
			this.tabHWtchr.addEventListener(TimerEvent.TIMER, this.handleTimerEvent);
			this.scrollTab = new ScrollTab();
			this.scrollTab.addEventListener('scrollTabEvent', this.handleScrolltabEvent);
			this.addChild(this.scrollTab);
			
		}
		
		public function draw(sizeRatio:Number = -1, trgtPos:Number = -1):void {
			
			if (!this.skinXML) return;
			
			if (sizeRatio >= 1) {
				
				this.bTop.interactive = false;
				this.bBottom.interactive = false;
				this.scrollTab.visible = false;
				
			} else {
				
				this.bTop.interactive = true;
				this.bBottom.interactive = true;
				this.scrollTab.visible = true;
				
			}
			
			// update position and sizeRatio if appropriate
			if (trgtPos > -1) this.setTrgtPos(trgtPos);
			if (sizeRatio > -1) this.setSizeRatio(sizeRatio);
			
			// build top button if it exists
			if (this.skinXML..bTop[0]) {
				
				this.bTop.setSkinXML(this.skinXML..bTop[0]);
				this.bTop.dir = 'up';
				this.bTop.draw();
				
				this.bTop.addEventListener(MouseEvent.CLICK, this.handleBtnClick);
				
				this.addChild(this.bTop);
				
			}
			
			// build bottom button if it exists
			if (this.skinXML..bBottom[0]) {
				
				this.bBottom.setSkinXML(this.skinXML..bBottom[0]);
				this.bBottom.dir = 'down';
				
				this.bBottom.addEventListener(MouseEvent.CLICK, this.handleBtnClick);
				
				this.bBottom.draw();
				
			}
			
			// build tray
			while( this.tray.numChildren > 0 ){
				this.tray.removeChildAt( 0 );
			}
			
			this.trayLen = (this.totalLen - this.bTop.height - this.bBottom.height);
			this.tray.addChild(new SlicedBmpSprite(this.skinXML..tray[0], this.trayLen));
			
			this.tray.y = this.bTop.height;
			
			this.tray.addEventListener(MouseEvent.CLICK, this.handleTrayClick);
			
			if (this.bBottom.height > 0) {
				
				this.bBottom.y = this.bTop.height + this.trayLen;
				this.addChild(this.bBottom);
			}
			
			this.scrollTab.y = this.bTop.height + this.getTabPos();
			this.scrollTab.tabHeight = this.getTabHeight();
			this.scrollTab.draw();
			this.scrollTab.setDragRect({tY: this.bTop.height - this.scrollTab.x, tH:this.trayLen - this.scrollTab.height});
			
			this.fixStackOrder();
			
			_maxY = this.tray.y + this.tray.height - this.scrollTab.height;
			
			this.findMaxWidth();
			
		}
		
		private function fixStackOrder():void {
			this.addChild(this.tray);
			this.addChild(this.scrollTab);
			this.addChild(this.bTop);
			this.addChild(this.bBottom);
		}
		
		private function findMaxWidth():void{
			
			var topOffW:int = parseInt(String(this.skinXML.bTop.off.@wh).split(',')[0]);
			if(topOffW > _w) _w = topOffW;
			
			var topOnW:int = parseInt(String(this.skinXML.bTop.over.@wh).split(',')[0]);
			if(topOnW > _w) _w = topOnW;
			
			var bottomOffW:int = parseInt(String(this.skinXML.bBottom.off.@wh).split(',')[0]);
			if(bottomOffW > _w) _w = bottomOffW;
			
			var bottomOnW:int = parseInt(String(this.skinXML.bBottom.over.@wh).split(',')[0]);
			if(bottomOnW > _w) _w = bottomOnW;
			
			var tabOffW:int = parseInt(String(this.skinXML.tab.off.slice[1].@w));
			if(tabOffW > _w) _w = tabOffW;
			
			var tabOnW:int = parseInt(String(this.skinXML.tab.over.slice[1].@w));
			if(tabOnW > _w) _w = tabOnW;
			
		}
		
		public function getWidth():int{
			return _w;
		}
		
		private function handleScrolltabEvent( e:ScrollTabEvent ):void {
			switch(e.name) {
				case 'watch':
					
					this.tabHWtchr.start();
					break;
				
				case 'unwatch':
					this.tabHWtchr.stop();
					
					//var scrBarEvent:ScrollBarEvent = new ScrollBarEvent( ScrollBarEvent.MOUSE_UP, true, true);
					//dispatchEvent( scrBarEvent );
					
					break;
			}
		}
		
		private function handleBtnClick(e:MouseEvent):void{
			
			switch(e.currentTarget.dir) {
				
				case 'up':
				case 'down':
					this.doBClickTabMove(e.currentTarget.dir);
					
					var scrBarEvent:ScrollBarEvent = new ScrollBarEvent( ScrollBarEvent.MOUSE_UP, true, true);
					dispatchEvent( scrBarEvent );
					
					break;
				
			}
			
		}
		
		private function handleTrayClick(e:MouseEvent):void{
			
			if (e.localY < (this.scrollTab.y - this.tray.y)) {
				this.doBClickTabMove('up');
			} else {
				this.doBClickTabMove('down');
			}
			
			var scrBarEvent:ScrollBarEvent = new ScrollBarEvent( ScrollBarEvent.MOUSE_UP, true, true);
			dispatchEvent( scrBarEvent );
			
		}
		
		private function handleMClick(e:MouseEvent):void {
			
			if (e.target is ScrollBtn) {
				
				switch(e.target.dir) {
					
					case 'up':
					case 'down':
						this.doBClickTabMove(e.target.dir);
						break;
					
				}
				
			} else if (e.target is ScrollTray) {
				
				if (e.localY < (this.scrollTab.y - this.tray.y)) {
					this.doBClickTabMove('up');
				} else {
					this.doBClickTabMove('down');
				}
				
			}
			
		}
		
		private function doBClickTabMove(dir:String):void {
			
			switch(dir) {
				case 'up':
					if (this.scrollTab.y == this.tray.y) return;
					this.scrollTab.y = (this.scrollTab.y - this.scrollTab.height < this.tray.y) ? this.tray.y : this.scrollTab.y - this.scrollTab.height;
					//this.scrollTab.y = this.sc
					break;
				
				default:
					if (this.scrollTab.y >= _maxY) return;
					this.scrollTab.y = (this.scrollTab.y + this.scrollTab.height >= _maxY) ? _maxY : this.scrollTab.y + this.scrollTab.height;
					
					break;
			}
			
			this.dispatchPosUpdate();
			
		}
		
		private function dispatchPosUpdate():void{
			
			this.currPosRat = this.getPosRatio();
			
			var scrBarEvent:ScrollBarEvent = new ScrollBarEvent( ScrollBarEvent.POS_UPDATE, true, true);
			scrBarEvent.pos = this.currPosRat;
			dispatchEvent( scrBarEvent );
			
		}
		
		/**
		 * Gets the position that the scrollTab should be at in pixels
		 * @return		Number
		 */
		private function getTabPos():Number {
			return this.trayLen * this.trgtPos;
		}
		
		public function setTabPos(pos:Number):void{
			
			var newY:Number = (pos * (this.tray.height - this.scrollTab.height)) + this.tray.y;
			
			if(newY > _maxY) newY = _maxY;
			
			this.scrollTab.y = Math.floor(newY);
			
		}
		
		/**
		 * Gets the position that the scrollTab should be at in pixels
		 * @return		Number
		 */
		private function getPosRatio():Number {
			
			var posRatio:Number = (this.scrollTab.y - this.tray.y) / (this.tray.height - this.scrollTab.height);
			
			return Math.floor(posRatio * 100) / 100;
		}
		
		/**
		 * Returns the height that the thumb tab should be in pixels
		 * @return		int
		 */
		private function getTabHeight():int {
			
			return Math.floor(this.trayLen * this.sizeRatio);
		}
		
		/**
		 * Accepts and stores skin data for the control. Intended to be used
		 * with com.greenanvil.ui.ImgLib.
		 * @param	imgName			The string identifier the ImgLib resource that
		 * 										is to be used.
		 * @param	skinXML			Skin config data XML
		 * @return		void
		 */
		public function setSkin(skinXML:XML):void {
			this.skinXML = skinXML;
			this.scrollTab.setSkinXML(skinXML..tab[0]);
		}
		
		/**
		 * Sets the overall length of the control including control buttons.
		 * @param	newLen				An integer
		 * @return		void
		 */
		public function setLength(newLen:int):void {
			this.totalLen = newLen;
		}
		
		/**
		 * Takes in a number between 0 and 1 and uses it to determine how long
		 * the scrollTab should be relative to the track its on.
		 * @param	sizeRatio			A number between 0 and 1
		 * @return		void
		 */
		public function setSizeRatio(sizeRatio:Number):void {
			this.sizeRatio = sizeRatio;
		}
		
		/**
		 * Takes in a number between 0 and 1 that represents the position of the
		 * target relative to the total length of the Scrollbar target container
		 * @param	newPos				A number between 0 and 1
		 * @return		void
		 */
		public function setTrgtPos(newPos:Number):void {
			this.trgtPos = newPos;
		}
		
		/*
		Group: Event Dispatcher
		*/
		
		private function handleTimerEvent(e:TimerEvent):void{
			
			var posRat:Number = this.getPosRatio();
			
			if (this.currPosRat != posRat)  this.dispatchPosUpdate();
			
		}
		
		
		
		public function cleanUp():void{
			this.tabHWtchr.removeEventListener(TimerEvent.TIMER, this.handleTimerEvent);
			this.scrollTab.removeEventListener('scrollTabEvent', this.handleScrolltabEvent);
			this.bTop.removeEventListener(MouseEvent.CLICK, this.handleBtnClick);
			this.bBottom.removeEventListener(MouseEvent.CLICK, this.handleBtnClick);
			this.tray.removeEventListener(MouseEvent.CLICK, this.handleTrayClick);
		}
		
	}
}