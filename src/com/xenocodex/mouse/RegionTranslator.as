package com.xenocodex.mouse{
	
	import com.xenocodex.mouse.event.RegionTranslatorEvent;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class RegionTranslator extends Sprite{
		
		protected static var EVT_DISP:EventDispatcher;
		
		public var updateInterval:int = 10;
		public var lineColor:int = 0xFF0000;
		
		public var yMin:Number = 0;
		public var yMax:Number = 1;
		public var xMin:Number = -1;
		public var xMax:Number = 1;
		
		public var deadRect:Rectangle;
		
		public var xMod:Number = 0;
		public var yMod:Number = 0;
		
		private var _active:Boolean = false;
		private var _w:Number;
		private var _h:Number;
		
		private var _mousePoint:Point;
		
		private var _timer:Timer;
		
		private var _lastMsg:String;
		
		public function RegionTranslator(rW:Number, rH:Number ){
			
			_w = rW;
			_h = rH;
			
			_mousePoint = new Point( 0, 0 );
			
			_timer = new Timer( updateInterval );
			_timer.addEventListener( TimerEvent.TIMER, handleTimerUpdate );
			
			this.xMod = this.xMax / 2;
			this.yMod = this.xMax / 2;
			
//			this.deadRect = new Rectangle( 200, 200, _w - 400, _h - 400 );
			
		}
		
		public function handleTimerUpdate( e:TimerEvent ):void{
			
			var rangeTop:Number = this.deadRect ? this.deadRect.top : _h / 2;
			var rangeBottom:Number = this.deadRect ? this.deadRect.bottom : _h / 2;
			
			_mousePoint.x = mouseX;
			_mousePoint.y = mouseY;
			
			this.globalToLocal( _mousePoint );
			
			var yModBase:Number = ( _mousePoint.y / _h ) * ( this.yMax - this.yMin ) + this.yMin;
			
			var newMsg:String;
			
			this.xMod = ( _mousePoint.x / _w ) * ( this.xMax - this.xMin ) + this.xMin;
			
			if( _mousePoint.y < rangeTop ){
				this.yMod = this.getEaseOut( 0, rangeTop, _mousePoint.y );
			} else if( _mousePoint.y > rangeBottom ){
				this.yMod = this.getEaseIn( rangeBottom, _h, _mousePoint.y );
			}
			
			if( this.xMod > this.xMax ) this.xMod = this.xMax;
			if( this.xMod < this.xMin ) this.xMod = this.xMin;
			if( this.yMod > this.yMax ) this.yMod = this.yMax;
			if( this.yMod < this.yMin ) this.yMod = this.yMin;
			
			this.dispatchEvent( new RegionTranslatorEvent( RegionTranslatorEvent.UPDATE, this.xMod, this.yMod ));
			
		}
		
		public function set showLines( show:Boolean ):void{
			
			if( show ){
				
				this.graphics.clear();
				this.graphics.lineStyle( 1, this.lineColor );
				this.graphics.drawRect( 0, 0, _w, _h );
				
			} else {
				this.graphics.clear();
			}
		}
		
		public function set active( a:Boolean ):void{
			
			_active = a;
			
			if( a ){
				_timer.start();
			} else {
				_timer.stop();
			}
			
		}
		
		public function getEaseOut( min:Number, max:Number, currNum:Number ):Number{
			return Math.sin(((( currNum - min ) / ( max - min )) * 90 ) * Math.PI/180 ) * 90;
		}
		
		public function getEaseIn( min:Number, max:Number, currNum:Number ):Number{
			return Math.sin((((( currNum - min ) / ( max - min )) * 90 ) + 90 ) * Math.PI/180 ) * -90 + 180;
		}
		
		public function get active():Boolean{
			return _active;
		}
		
		public static function addEventListener(...p_args:Array):void{
			if(EVT_DISP == null) EVT_DISP = new EventDispatcher();
			EVT_DISP.addEventListener.apply(null, p_args);
		}
		
		public static function removeEventListener(...p_args:Array):void{
			if(EVT_DISP == null) return;
			EVT_DISP.removeEventListener.apply(null, p_args);
		}
		
		public static function dispatchEvent(...p_args:Array):void{
			if(EVT_DISP == null) return;
			EVT_DISP.dispatchEvent.apply(null, p_args);
		}
	}
}