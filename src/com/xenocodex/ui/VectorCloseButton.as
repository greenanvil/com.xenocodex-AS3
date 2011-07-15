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
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class VectorCloseButton extends Sprite{
		
		private var _built:Boolean = false;
		
		private var _w:int;
		private var _h:int;
		
		private var _bgColor:uint = 0xFF0000;
		
		private var _borderColor:uint = 0x000000;
		private var _borderWidth:uint = 2;
		
		private var _xColor:uint = 0xFFFFFF;
		private var _xLineWidth:uint = 4;
		private var _xMargin:uint = 6;
		
		private var _hSpot:Sprite = new Sprite();
		
		public function VectorCloseButton( w:int, h:int ){
			
			super();
			
			_w = w;
			_h = h;
			
			this.addEventListener( Event.ADDED_TO_STAGE, this.handleAddedToStage );
			
		}
		
		private function build():void{
			
			if( _built ) return;
			_built = true;
			
			var wMod:int = ( _borderWidth % 2 != 0 || _borderWidth == 1 ) ? -1 : 0;
			var hMod:int = ( _borderWidth % 2 != 0 || _borderWidth == 1 ) ? -1 : 0;
			
			this.graphics.beginFill( _bgColor );
			this.graphics.drawRect( 0, 0, _w, _h );
			this.graphics.endFill();
			
			this.graphics.lineStyle( _borderWidth, _borderColor );
			this.graphics.lineTo( _w + wMod, 0 );
			this.graphics.lineTo( _w + wMod, _h + hMod );
			this.graphics.lineTo( 0, _h + hMod );
			this.graphics.lineTo( 0, 0 );
			
			var innerBdrW:int = Math.floor( _borderWidth / 2 );
			var xOrigin:int = innerBdrW + _xMargin;
			var xW:int = _w - innerBdrW - _xMargin;
			var xH:int = _h - innerBdrW - _xMargin;
			
			this.graphics.lineStyle( _xLineWidth, _xColor );
			this.graphics.moveTo( xOrigin, xOrigin );
			this.graphics.lineTo( xW + wMod, xH );
			this.graphics.moveTo( xOrigin, xH );
			this.graphics.lineTo( xW + wMod, xOrigin );
			
			_hSpot.graphics.beginFill( 0xFF0000, 0 );
			_hSpot.graphics.drawRect( 0, 0, _w, _h );
			_hSpot.graphics.endFill();
			_hSpot.buttonMode = true;
			
			this.addChild( _hSpot );
			
		}
		
		private function handleAddedToStage( e:Event ):void{
			
			this.build();
			
		}
		
		public function set bgColor( c:uint ):void{ _bgColor = c; }
		public function set borderColor( c:uint ):void{ _borderColor = c; }
		public function set borderWidth( c:uint ):void{ _borderWidth = c; }
		public function set xColor( c:uint ):void{ _xColor = c; }
		public function set xLineWidth( c:uint ):void{ _xLineWidth = c; }
		public function set xMargin( c:uint ):void{ _xMargin = c; }
		
	}
}