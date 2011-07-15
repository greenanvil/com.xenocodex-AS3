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
	
	import com.xenocodex.img.BmpBtn;
	import com.xenocodex.img.BmpSprite;
	import com.xenocodex.img.ImgLib;
	import com.xenocodex.img.SlicedBmp;
	import com.xenocodex.controls.scroller.events.ScrollTabEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ScrollTab extends BmpBtn{
		
		private var tabH:Number = 0;
		private var offHldr:Sprite
		private var dragRect:Object = { tX:0, tY:0, tH:0 };
		
		public function ScrollTab() {
			super();
			this.init();
		}
		
		override public function init():void {
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.handleRollOut);
			
		}
		
		public function set tabHeight(newH:Number):void {
			this.tabH = newH;
		}
		
		override public function draw():void {
			
			this.clear();
			
			this.bmpBodyOff = SlicedBmp.create( this.skinXML..off[0], this.tabH, 'Y' );
			this.bmpBodyOver = SlicedBmp.create( this.skinXML..over[0], this.tabH, 'Y' );
			
			this.addChild(this.bmpBodyOff);
			
		}
		
		private function clear():void{
			
			while(this.numChildren > 0){
				this.removeChildAt(0);
			}
			
		}
		
		public function setDragRect(newSpecs:Object):void {
			if (newSpecs.tX) this.dragRect.tX = newSpecs.tX;
			if (newSpecs.tY) this.dragRect.tY= newSpecs.tY;
			if (newSpecs.tH) this.dragRect.tH = newSpecs.tH;
		}
		
		private function handleMouseDown(e:MouseEvent):void {
			this.doEventDispatch('watch');
			this.startDrag(false, new Rectangle(this.dragRect.tX, this.dragRect.tY, 0, this.dragRect.tH));// this.trayBmp.height -  this.thumbTab.height));
		}
		
		private function handleMouseUp(e:MouseEvent):void {
			this.doEventDispatch('unwatch');
			this.stopDrag();
		}
		
		private function handleRollOut(e:MouseEvent):void {
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this.handleStageMouseUp);
		}
		
		private function handleStageMouseUp(e:MouseEvent):void {	
			this.doEventDispatch('unwatch');
			this.stopDrag();
			try{
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleStageMouseUp);
			} catch( e:Error ){}
		}
		
	/*
		Group: Event Dispatcher
	*/
		private function doEventDispatch(eName:String, infoObj:Object = null):void{
			
			this.dispatchEvent(new ScrollTabEvent(eName, infoObj));
			
		}
		
	}

}