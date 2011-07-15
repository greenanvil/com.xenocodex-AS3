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

		import com.xenocodex.controls.scroller.events.ScrollBarEvent;
		import com.xenocodex.controls.scroller.events.ScrollAreaEvent;
		
		import com.gskinner.motion.GTween;
		import com.gskinner.motion.easing.Linear;
		import com.gskinner.motion.easing.Sine;
		
		import flash.display.CapsStyle;
		import flash.display.DisplayObject;
		import flash.display.JointStyle;
		import flash.display.LineScaleMode;
		import flash.display.Shape;
		import flash.display.Sprite;
		import flash.utils.Dictionary;
		
		public class ScrollArea extends Sprite{
			
			private var _w:int;
			private var _h:int;
			private var _bWidth:int;
			private var _bColor:int;
			private var _bAlpha:Number;
			private var _rtMargin:int = 0;
			private var _bMargin:int = 0;
			
			public var slideSpeed:Number = .1;
			
			private var _slideDir:String = 'horiz';
			
			public var _widthHldr:Sprite = new Sprite();
			private var _innerBody:Sprite = new Sprite();
			public var _innerBodyMask:Sprite = new Sprite();
			public var _borderHldr:Shape = new Shape();
			
			public var _slideTween:GTween;
			private var _bodyMoved:Boolean = false;
			private var _centering:Boolean = false;
			
			private var _scrollItemDict:Dictionary;
			
			public function ScrollArea(w:int, h:int, bWidth:int = 0, bColor:uint = 0x000000, bAlpha:Number = 1){
				
				_w = w;
				_h = h;
				_bWidth = bWidth;
				_bColor =bColor;
				_bAlpha = bAlpha;
				
				this.addChild(_widthHldr);
				this.addChild(_innerBody);
				this.addChild(_innerBodyMask);
				this.addChild(_borderHldr);
				
				_innerBody.mask = _innerBodyMask;
				
				_slideTween = new GTween(_innerBody, this.slideSpeed);
				_slideTween.ease = Linear.easeNone;
				_slideTween.onComplete = handleTweenComplete;
				_slideTween.onChange = handleBodyTweenChange;
				
				this.draw();
				
			}
			
			public function draw():void{
				
				// draw width holder
				with(_widthHldr.graphics){
					clear();
					beginFill(0x000000, 0);
					drawRect(0, 0, _w, _h);
					endFill();
				}
				
				// draw body mask
				with(_innerBodyMask.graphics){
					clear();
					beginFill(0x000000, .5);
					drawRect(0, 0, _w, _h);
					endFill();
				}
				
				// draw border
				if(_bWidth > 0){
					
					with(_borderHldr.graphics){
						clear();
						lineStyle(_bWidth, _bColor, _bAlpha, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 10);
						lineTo(_innerBodyMask.width, 0);
						lineTo(_innerBodyMask.width, _innerBodyMask.height);
						lineTo(0, _innerBodyMask.height);
						lineTo(0, 0);
					}
				}
			}
			
			public function moveContent(pos:Number):void{
				
				_bodyMoved = true;
				
				if(_slideDir == 'vert'){
					
					_slideTween.proxy.y = (((_innerBody.height - _bMargin) - _h) * pos) * -1; //
					
				} else {
					
					_slideTween.proxy.x = (((_innerBody.width - _rtMargin) - _w) * pos) * -1;
					
				}
			}
			
			public function handleTweenComplete(tween:GTween):void{
				
				_bodyMoved = false;
				
				if( _centering ){
					
					_centering = false;
					
				}
				
			}
			
			public function handleBodyTweenChange(tween:GTween):void{
				
				if( _centering ){
					
					var scrBarEvent:ScrollBarEvent = new ScrollBarEvent( ScrollBarEvent.CENTERING, true, true);
					dispatchEvent( scrBarEvent );
					
				}
				
			}
			
			public function slideToNearestItem():void{
				
				if(!_bodyMoved) return;
				
				_centering = true;
				
				var targPos:Number = ( _slideDir == 'vert' )  ? _slideTween.getValue('y') * -1 : _slideTween.getValue('x') * -1;
				var testPos:Number = 0, itemIndex:int = 0, nearestPos:Number;
				var leftChild:DisplayObject, rightChild:DisplayObject;
				
				while(testPos < targPos && itemIndex + 1 < _innerBody.numChildren){
					
					leftChild = _innerBody.getChildAt(itemIndex);
					rightChild = _innerBody.getChildAt(itemIndex + 1);
					
					// find the nearest position
					if(itemIndex == _innerBody.numChildren){
						
						nearestPos = ( _slideDir == 'vert' )  ? _innerBody.getChildAt(_innerBody.numChildren - 1).y : _innerBody.getChildAt(_innerBody.numChildren - 1).x;
						
					} else if(_slideDir != 'vert' && targPos >= leftChild.x && targPos < rightChild.x || _slideDir == 'vert' && targPos >= leftChild.y && targPos < rightChild.y){
						
						if ( _slideDir == 'vert' ) {
							
							nearestPos = (targPos - leftChild.y <= rightChild.y - targPos) ? leftChild.y : rightChild.y;
							
						} else {
							
							nearestPos = (targPos - leftChild.x <= rightChild.x - targPos) ? leftChild.x : rightChild.x;
							
						}
						break;
						
					}
					
					itemIndex++;
					
				}
				
				if ( _slideDir == 'vert' ) {
					_slideTween.proxy.y = !isNaN(nearestPos * -1) ? nearestPos * -1 : 0;
				} else {
					_slideTween.proxy.x = !isNaN(nearestPos * -1) ? nearestPos * -1 : 0;
				}
				
			}
			
			public function resize(w:Number, h:Number):void{
				
				_w = w;
				_h = h;
				
				this.draw();
				
			}
			
			public function getWidth():int{
				
				return Math.floor(_w);
				
			}
			
			public function getHeight():int{
				
				return Math.floor(_h);
				
			}
			
			public function getBodyPosition():Number{
				
				return ( _slideDir == 'vert' ) ? _innerBody.y : _innerBody.x;
				
			}
			
			public function reset():void{
				
				if ( _slideDir == 'vert' ) {
					_innerBody.y = 0;
				} else {
					_innerBody.x = 0;
				}
				
				this.dispatchEvent( new ScrollBarEvent( ScrollBarEvent.CENTERING, true, true ));
				
			}
			
			public function get innerBody():Sprite{
				return _innerBody;
			}
			
			public function set rtMargin(mrgn:int):void{
				
				_rtMargin = mrgn;
				
			}
			
			public function get bMargin():int{
				
				return _bMargin;
				
			}
			
			public function set bMargin(mrgn:int):void{
				
				_bMargin = mrgn;
				
			}
			
			public function set slideDir(newDir:String):void{
				
				_slideDir = newDir == 'vert' ? 'vert' : 'horiz';
				
			}
			
			public function set scrollItemDict(iDict:Dictionary):void{
				
				_scrollItemDict = iDict;
				
			}
			
			private function doEventDispatch(eName:String, infoObj:Object = null):void{
				this.dispatchEvent(new ScrollAreaEvent(eName, infoObj));
			}
			
			
			public function cleanUp():void{
				
				
			}
			
		}
	}