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

package com.xenocodex.controls{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import com.xenocodex.controls.events.UIBtnEvent;
	
	public class TextButton extends Sprite{
		
		private var evtMsg:String = 'TextClick';
		
		private var offColor:uint;
		private var overColor:uint;
		
		private var btnTField:TextField;
		private var hspot:Sprite = new Sprite();
		
		public function TextButton(evtMsg:String, txt:String, tFmt:TextFormat, offColor:uint, overColor:uint){
			
			this.evtMsg = evtMsg;
			
			this.offColor = offColor;
			this.overColor = overColor;
			
			this.btnTField = new TextField();
			with(this.btnTField){
				embedFonts = true;
				autoSize = TextFieldAutoSize.LEFT;
				selectable = false;
				defaultTextFormat = tFmt;
				text = txt;
			}
			
			this.addChild(this.btnTField);
			
			this.hspot.graphics.beginFill(0x000000, 0);
			this.hspot.graphics.drawRect(0, 0, this.width, this.height);
			this.hspot.graphics.endFill();
			this.hspot.buttonMode = true;
			
			this.hspot.addEventListener(MouseEvent.MOUSE_OVER, this.handleOver);
			this.hspot.addEventListener(MouseEvent.MOUSE_OUT, this.handleOut);
			this.hspot.addEventListener(MouseEvent.MOUSE_UP, this.handleBtnClick);
			
			this.addChild(this.hspot);
			
		}
		
		public function showOver(oState:Boolean):void{
			
			var currFmt:TextFormat = this.btnTField.getTextFormat();
			currFmt.color = (oState) ? this.overColor : this.offColor;
			this.btnTField.setTextFormat(currFmt);
			
		}
		
		private function handleOver(e:MouseEvent):void{ this.showOver(true); }
		private function handleOut(e:MouseEvent):void{ this.showOver(false); }
		
		private function handleBtnClick(e:MouseEvent):void {
			this.dispatchEvent(new UIBtnEvent(this.evtMsg));
		}
		
	}

}