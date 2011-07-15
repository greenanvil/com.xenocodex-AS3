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

package com.xenocodex.ui{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ShapeBtn extends Sprite{
		
		public var enabled:Boolean = false;
		private var down:Boolean = false;
		
		private var bgHldr:Sprite = new Sprite();
		private var labelHldr:Sprite = new Sprite();
		private var offState:Sprite = new Sprite();
		private var overState:Sprite = new Sprite();
		private var downState:Sprite = new Sprite();
		
		private var downColor:uint;
		private var overColor:uint;
		
		private var hspot:Sprite = new Sprite();
		
		private var lbl:ShapeBtnLabel;
		
		public var evtMsg:String = 'none';
		
		public function ShapeBtn(configObj:Object, evtMsg:String, labelTxt:String = 'Click Me'){
			
			if(evtMsg) this.evtMsg = evtMsg;
			
			this.downColor = parseInt(configObj.down.font);
			this.overColor = parseInt(configObj.over.font);
			
			this.drawRect(this.offState, configObj.off.w, configObj.off.h, configObj.off.bgColor, configObj.off.alpha);
			this.drawRect(this.overState, configObj.over.w, configObj.over.h, configObj.over.bgColor, configObj.over.alpha);
			this.drawRect(this.downState, configObj.down.w, configObj.down.h, configObj.down.bgColor, configObj.down.alpha);
			
			this.bgHldr.addChild(this.offState);
			
			this.addChild(this.bgHldr);
			
			this.lbl = new ShapeBtnLabel(configObj.labelFontName, labelTxt, configObj.tFmt);
			this.positionLabel();
			this.addChild(this.lbl);
			
			this.interactive = true;
			
			var hspot:Sprite = new Sprite(); 
			this.drawRect(hspot, this.width, this.height, 0x000000, 0);
			this.addChild(hspot);
			
		}
		
		private function positionLabel(pos:String = 'MM'):void{
			switch(pos){
				default:
					this.lbl.x = (this.width / 2) - (this.lbl.width / 2);
					this.lbl.y = (this.height / 2) - (this.lbl.height / 2);
					break;
			}
		}
		
		private function drawRect(targRect:Sprite, w:int, h:int, bgCol:uint, alpha:Number):void{
			
			targRect.graphics.beginFill(bgCol, alpha);
			targRect.graphics.drawRect(0, 0, w, h);
			targRect.graphics.endFill();
			
		}
		
		public function set interactive(intr:Boolean):void {
			this.enabled = intr;
			if (intr) {
				this.addEventListener(MouseEvent.ROLL_OVER, this.handleMOver);
				this.addEventListener(MouseEvent.ROLL_OUT, this.handleMOut);
				this.buttonMode = true;
			} else {
				this.removeEventListener(MouseEvent.ROLL_OVER, this.handleMOver);
				this.removeEventListener(MouseEvent.ROLL_OUT, this.handleMOut);
				this.buttonMode = false;
			}
			
		}
		
		public function set isDown(d:Boolean):void{
			
			if(d == this.down) return;
			
			this.down = d;
			
			if (d) {
				this.interactive = false;
				this.bgHldr.addChild(this.downState);
				this.bgHldr.removeChildAt(0);
			} else {
				this.interactive = false;
				this.bgHldr.addChild(this.offState);
				this.bgHldr.removeChildAt(0);
			}
			
		}
		
		private function handleMOver(e:MouseEvent):void {
			this.bgHldr.addChild(this.overState);
			this.bgHldr.removeChildAt(0);
		}
		
		private function handleMOut(e:MouseEvent):void {
			this.bgHldr.addChild(this.offState);
			this.bgHldr.removeChildAt(0);
		}		
	}
}