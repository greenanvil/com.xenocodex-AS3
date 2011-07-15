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

package com.xenocodex.img{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author dsmith
	 */
	public class BmpBtn extends Sprite{
		
		public var bmpBodyOff:Sprite, bmpBodyOver:Sprite;
		public var skinXML:XML;
		public var imgLib:ImgLib;
		public var enabled:Boolean = false;
		private var whOff:Array, xyOff:Array, whOver:Array, xyOver:Array;
		
		public function BmpBtn() {
			this.init();
			this.interactive = true;
			this.buttonMode = true;
		}
		
		public function set interactive(intr:Boolean):void {
			this.enabled = intr;
			if (intr) {
				this.addEventListener(MouseEvent.ROLL_OVER, this.handleMOverSuper);
				this.addEventListener(MouseEvent.ROLL_OUT, this.handleMOutSuper);
				this.buttonMode = true;
			} else {
				this.removeEventListener(MouseEvent.ROLL_OVER, this.handleMOverSuper);
				this.removeEventListener(MouseEvent.ROLL_OUT, this.handleMOutSuper);
				this.buttonMode = false;
			}
		}
		
		public function init():void {
			this.imgLib = ImgLib.getImgLib();
			
		}
		
		public function setSkinXML(bData:XML):void {
			
			/* 
				Basic XML
				<bTop libImgName="mainSprite">
					<off wh="16,13" xy="0,0" />
					<over wh="16,13" xy="17,0" />
				</bTop>
			*/
			
			this.skinXML = bData;
			
			with (this) {
				whOff = String(this.skinXML.off.@wh).split(',');
				xyOff = String(this.skinXML.off.@xy).split(',');
				whOver = String(this.skinXML.over.@wh).split(',');
				xyOver = String(this.skinXML.over.@xy).split(',');
			}
			
		}
		
		public function draw():void {
			
			this.bmpBodyOff = new BmpSprite(ImgLib.getImg(this.skinXML.@libImgName).bitmapData, whOff[0], whOff[1], xyOff[0], xyOff[1]);
			this.bmpBodyOver = new BmpSprite(ImgLib.getImg(this.skinXML.@libImgName).bitmapData, whOver[0], whOver[1], xyOver[0], xyOver[1]);
			this.addChild(this.bmpBodyOff);
			
		}
		
		private function handleMOverSuper(e:MouseEvent):void {
			if (!this.contains(this.bmpBodyOver))this.addChild(this.bmpBodyOver); //if it doesn't contain bmpBodyOver, add it
			if (this.contains(this.bmpBodyOff)) this.removeChild(this.bmpBodyOff); //if it does contain bmpBodyOff, remove it
		}
		
		private function handleMOutSuper(e:MouseEvent):void {
			//this is throwing an error when there's a redraw, seeing if I can juryrig it to work for now
			if (!this.contains(this.bmpBodyOff))this.addChild(this.bmpBodyOff); //if it doesn't contain bodyOff, add it
			if (this.contains(this.bmpBodyOver)) this.removeChild(this.bmpBodyOver); //if it does contain BodyOver, remove it
		}
		
		override public function get width():Number {
			return (this.bmpBodyOff) ? this.bmpBodyOff.width : 0;
		}
		
		override public function get height():Number {
			return (this.bmpBodyOff) ? this.bmpBodyOff.height : 0;
		}
		
	}

}