package com.xenocodex.motion{
	
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.easing.Sine;
	
	import flash.display.DisplayObject;
	
	public class RandomRotate{
		
		private var _targ:DisplayObject;
		public var _tween:GTween;
		
		public var minDegrees:int = 1;
		public var maxDegrees:int = 90;
		public var minDuration:int = 1;
		public var maxDuration:int = 4;
		public var pauseLen:Number = 1;
		
		public function RandomRotate( target:DisplayObject ){
			
			_targ = target;
			
			_tween = new GTween(_targ, 1);
			_tween.ease = Sine.easeInOut; //Linear.easeNone;
			_tween.onComplete = _handleTweenComplete;
			
		}
		
		public function randomRotation():void{
			
			var duration:Number = Math.floor( Math.random() * (( maxDuration - minDuration ) + minDuration ));
			var degreesBase:Number = Math.floor( Math.random() * (( maxDegrees - minDegrees ) + minDegrees ));
			var dirMod:Number = ( Math.random() * 100 < 50 ) ? -1 : 1;
			
			var degrees:Number = degreesBase * dirMod;
			
			_tween.duration = duration > 0 ? duration : minDuration;
			
			this.applyRotation( degrees );
			
		}
		
		public function applyRotation( deg:Number ):void{
			
			_tween.proxy.rotation += deg;
			
		}
		
		private function _handleTweenComplete( tween:GTween ):void{
			
//			trace( this + ' > _handleTweenComplete()' );
			
			this.randomRotation();
			
		}
		
	}
}