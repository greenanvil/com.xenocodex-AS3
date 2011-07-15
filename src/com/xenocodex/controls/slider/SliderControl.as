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
	
	import com.xenocodex.controls.slider.enum.TabAlign;
	import com.xenocodex.controls.slider.events.SliderEvent;
	import com.xenocodex.enum.Direction;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	public class SliderControl extends Sprite{
		
		private var _sliderId:String;
		
		private var _currAmt:Number = 0;
		
		private var _tab:Sprite;
		private var _tabRect:Rectangle;
		
		private var _slideMax:Number = 100;
		private var _startPos:Number = 0;
		
		private var _tabAlign:String;
		private var _tabXOffset:Number = 0;
		private var _tabYOffset:Number = 0;
		private var _dir:String;
		
		public function SliderControl( id:String = null, tab:Sprite = null, dir:String = null, tabAlign:String = null ){
			
			super();
			
			_sliderId = id ? id : 'sliderControl_' + getTimer();
			
			_dir = dir ? dir : Direction.HORIZONTAL;
			
			_tabAlign = tabAlign ? tabAlign : TabAlign.MIDDLE;
			
			if( tab ) this.tab = tab;
			
		}
		
		public function set slideMax( slideMax:Number ):void{
			
			_slideMax = slideMax + (( _tab.width % 2 != 0) ? -1 : 0 );
			
			_tabRect = ( _dir == Direction.HORIZONTAL ) ? new Rectangle( _tab.x, _tab.y, _slideMax, 0 ) : new Rectangle( _tab.x, _tab.y, 0, _slideMax );
			
		}
		
		public function set tab( tab:Sprite ):void{
			
			_tab = tab;
			
			switch( _dir ){
				
				case Direction.HORIZONTAL:
					
					switch( _tabAlign ){
						
						case TabAlign.START_EDGE:
							_tabXOffset = 0;
							break;
						
						case TabAlign.MIDDLE:
							_tabXOffset = Math.floor( _tab.width * .5 ) * -1;
							break;
						
						case TabAlign.END_EDGE:
							_tabXOffset = -_tab.width;
							break;
						
					}
					
					_tab.x += _tabXOffset;
					
					_tabRect = new Rectangle( _tab.x, _tab.y, _slideMax, 0 );
					
					break;
				
				case Direction.VERTICAL:
					
					switch( _tabAlign ){
						
						case TabAlign.START_EDGE:
							_tabYOffset = 0;
							break;
						
						case TabAlign.MIDDLE:
							_tabYOffset = Math.floor( _tab.height * .5 ) * -1;
							break;
						
						case TabAlign.END_EDGE:
							_tabYOffset = -_tab.width;
							break;
						
					}
					
					_tab.y += _tabYOffset;
					
					_tabRect = new Rectangle( _tab.x, _tab.y, 0, _slideMax );
					
					break
				
			}
			
			
			
			_tab.addEventListener( MouseEvent.MOUSE_DOWN, this.handleTabDown );
			_tab.addEventListener( MouseEvent.MOUSE_UP, this.handleTabUp );
			
		}
		
		public function set tabOffset( offset:Number ):void{
			
			switch( _dir ){
				
				case Direction.HORIZONTAL:
					_tabXOffset = offset;
					_tab.x += offset;
					break
				
				case Direction.VERTICAL:
					_tabYOffset = offset
					_tab.y += offset;
					break
				
			}
			
		}
		
		public function handleTabDown( e:MouseEvent ):void{
			
			_tab.stage.addEventListener( MouseEvent.MOUSE_UP, this.handleTabUp );
			_tab.stage.addEventListener( Event.ENTER_FRAME, this.handleEnterFrame );
			_tab.startDrag( false, _tabRect);
			
		}
		
		public function handleTabUp( e:MouseEvent ):void{
			
			_tab.stage.removeEventListener( MouseEvent.MOUSE_UP, this.handleTabUp );
			_tab.stage.removeEventListener( Event.ENTER_FRAME, this.handleEnterFrame );
			_tab.stopDrag();
			
			this.dispatchEvent( new SliderEvent( SliderEvent.TAB_RELEASE, _sliderId, _currAmt ));
			
		}
		
		private function handleEnterFrame( e:Event ):void{
			
			switch( _dir ){
			
				case Direction.HORIZONTAL:
					_currAmt = ( _tab.x - _tabXOffset ) / _slideMax;
					break;
				
				case Direction.VERTICAL:
					_currAmt = ( _tab.y - _tabYOffset ) / _slideMax;
					break;
				
			}
			
			this.dispatchEvent( new SliderEvent( SliderEvent.LEVEL_UPDATE, _sliderId, _currAmt ));
			
		}
		
		public function set level( lvl:Number ):void{
			
			_currAmt = lvl;
			
			switch( _dir ){
				
				case Direction.HORIZONTAL:
					
					_tab.x = ( _currAmt * _slideMax ) - _tabXOffset;
					break;
				
				case Direction.VERTICAL:
					
					_tab.y = ( _currAmt * _slideMax ) + _tabYOffset;
					break;
				
			}
			
		}
		
		public function get level():Number{
			
			return _currAmt;
			
		}
		
		public function get id():String{
			return _sliderId;
		}
		
	}
}