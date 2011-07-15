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
	
	import com.xenocodex.ui.enum.NumberDisplayMode;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class NumberDisplay extends Sprite{
		
		public var pre:String = '';
		public var post:String = '';
		
		public var dropDecimal:Boolean = false;
		
		private var _amt:Number = 0;
		private var _displayNumber:Number = 0;
		
		private var _numStr:String = '0%';
		
		private var _rangeMin:Number = 0;
		private var _rangeMax:Number = 100;
		
		private var _tfield:TextField;
		private var _tfmt:TextFormat;
		
		private var _mode:String;
		
		public function NumberDisplay(){
			
			super();
			
			_mode = NumberDisplayMode.PERCENT;
			
			if( this.stage ){
				this.build();
			} else {
				this.addEventListener( Event.ADDED_TO_STAGE, this.handleAddedToStage );
			}
			
		}
		
		private function build():void{
			
			_tfield = new TextField();
			_tfmt = new TextFormat();
			
			_tfield.setTextFormat( _tfmt );
			_tfield.defaultTextFormat = _tfmt;
			_tfield.selectable = false;
			
			this.addChild( _tfield );
			
			this.layout();
			
		}
		
		private function layout():void{}
		
		private function getStrPercentage( perc:Number ):String{
			
			_amt = Math.floor( perc * 100 );
			
			return _amt.toString() + '%';
			
		}
		
		private function getStrRange( perc:Number ):String{
			
			_amt = _rangeMin + Math.floor( perc * ( _rangeMax - _rangeMin ));
			
			return _amt.toString();
			
		}
		
		private function getStrMoney( perc:Number ):String{
			
			switch( perc ){
			
				case 0:
					
					_amt = _rangeMin;
					break;
					
				case 1:
					
					_amt = _rangeMax;
					break;
				
				default:
					
					_amt = ( perc * ( _rangeMax - _rangeMin ));
					break;
				
			}
			
			_amt = Math.floor( _amt * 100 ) / 100;
			
			var amtStr:String = _amt.toString();
			
			// add decimal
			var amtSplit:Array = amtStr.split('.');
			if( amtSplit.length > 1 ){
			
				switch( String( amtSplit[1] ).length ){
					
					case 1:
						amtStr = amtStr + '0';
						break;
					
				}
				
			}
			
			var amtDecSplit:Array = amtStr.split('.');
			var charNum:Number
			
			if( amtDecSplit[0].length > 3 ){
				
				charNum = amtDecSplit[0].length - 3;
				amtStr = amtDecSplit[0].substring( 0, charNum ) + ',' + amtDecSplit[0].substring( charNum, amtStr.length ) + ( amtDecSplit[1] != undefined ? ( '.' + amtDecSplit[1] ) : '' );
				
			}
			
			if( dropDecimal ) amtStr = amtStr.split( '.' )[0];
			
			return '$' + amtStr;
			
		}
		
		public function set displayNumber( n:Number ):void{
			
			_displayNumber = n;
			
			if( _tfield ){
				
				switch( _mode ){
					
					case NumberDisplayMode.PERCENT:
						_numStr = this.getStrPercentage( _displayNumber );
						break;
					
					case NumberDisplayMode.RANGE:
						_numStr = this.getStrRange( _displayNumber );
						break;
					
					case NumberDisplayMode.MONEY:
						_numStr = this.getStrMoney( _displayNumber );
						break;
					
				}
				
				_tfield.htmlText = this.pre + _numStr + this.post;
				
			}
			
		}
		
		public function set level( n:Number ):void{
			
			if( _tfield ){
				
				switch( _mode ){
					
					case NumberDisplayMode.PERCENT:
						_numStr = this.getStrPercentage( n );
						break;
					
					case NumberDisplayMode.RANGE:
						_numStr = this.getStrRange( n );
						break;
					
					case NumberDisplayMode.MONEY:
						_numStr = this.getStrMoney( n );
						break;
					
				}
				
				_tfield.htmlText = this.pre + _numStr + this.post;
				
			}
			
		}
		
		public function set mode( m:String ):void{
			
			_mode = m;
			
		}
		
		public function set textFormat( tfmt:TextFormat ):void{
			
			_tfmt = tfmt;
			
			if( _tfield ){
				
				_tfield.setTextFormat( _tfmt );
				_tfield.defaultTextFormat = _tfmt;
				
			}
			
		}
		
		public function set rangeMin( r:Number ):void{
			
			_rangeMin = r;
			
			// set default display value based on available properties
			this.displayNumber = _amt;
			
		}
		
		public function set rangeMax( r:Number ):void{
			
			_rangeMax = r;
			
			// set default display value based on available properties
			this.displayNumber = _amt;
			
		}
		
		public function get value():Number{
			
			return _amt;
			
		}
		
		override public function set width( w:Number ):void{
			_tfield.width = w;
		}
		
		override public function set height( h:Number ):void{
			_tfield.height = h;
		}
		
		private function handleAddedToStage( e:Event ):void{
			
			this.removeEventListener( Event.ADDED_TO_STAGE, this.handleAddedToStage );
			this.build();
			
		}
		
	}
}