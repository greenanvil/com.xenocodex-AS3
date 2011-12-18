package com.xenocodex.mouse{
	
	import com.xenocodex.mouse.event.DragDistanceWatcherEvent;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class DragDistanceWatcher extends Sprite{
		
		protected static var EVT_DISP:EventDispatcher;
		
		private var _isWatching:Boolean = false;
		private var _timer:Timer;
		
		private var _startX:Number;
		private var _startY:Number;
		
		private var _xDiff:Number;
		private var _yDiff:Number;
		
		public var xAmt:Number;
		public var yAmt:Number;
		
		public var draw:Boolean = false;
		public var maxDist:Number = 100;
		
		public function DragDistanceWatcher(){
			
			super();
			
			_timer = new Timer( 100 );
			_timer.addEventListener( TimerEvent.TIMER, _handleTimerEvent );
			
		}
		
		public function startWatch( e:MouseEvent ):void{
			
			_startX = mouseX;
			_startY = mouseY;
			
			this.xAmt = this.yAmt = 0;
			
			if( this.draw ) this.drawRange();
			
			_timer.start();
			
			_isWatching = true;
			
		}
		
		public function stopWatch( e:MouseEvent ):void{
			
			if( this.draw ) this.clearRange(); 
			
			_isWatching = false;
			
			_timer.stop();
			
		}
		
		public function drawRange():void{
			
			this.graphics.lineStyle( 1 );
			this.graphics.drawRect( _startX - maxDist, _startY - maxDist, maxDist * 2, maxDist * 2 );
			
		}
		
		public function clearRange():void{
			
			this.graphics.clear();
			
		}
		
		private function _handleTimerEvent( e:TimerEvent ):void{
			
			_xDiff = mouseX - _startX;
			_yDiff = mouseY - _startY;
			
			this.xAmt = _xDiff / this.maxDist;
			this.yAmt = _yDiff / this.maxDist;
			
			if( this.xAmt > 1 ){
				this.xAmt = 1;
			} else if( this.xAmt < -1 ) {
				this.xAmt = -1;
			}
			
			if( this.yAmt > 1 ){
				this.yAmt = 1;
			} else if( this.yAmt < -1 ){
				this.yAmt = -1;
			}
			
			this.dispatchEvent( new DragDistanceWatcherEvent( DragDistanceWatcherEvent.UPDATE, _xDiff, _yDiff, this.xAmt, this.yAmt));
			
		}
		
		public function get isActive():Boolean{
			return _isWatching;
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