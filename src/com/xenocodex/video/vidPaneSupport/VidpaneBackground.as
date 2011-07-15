package com.xenocodex.video.vidPaneSupport{
	
	import com.xenocodex.video.VidPane;
	import com.xenocodex.video.VidPaneLayer;
	import com.xenocodex.video.vidPaneSupport.data.VidpaneSkinData;
	import com.xenocodex.video.vidPaneSupport.enum.VidpaneBackgroundTypes;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	
	public class VidpaneBackground extends VidPaneLayer{
		
		private var _bgHldr:Sprite = new Sprite();
		
		private var _vidPane:DisplayObject;
		private var _innerShadow:DropShadowFilter;
		
		public function VidpaneBackground( vidPane:DisplayObject ){
			
			super();
			
			_vidPane = vidPane;
			_build();
			
		}
		
		private function _build():void{
			
			this.addChild( _bgHldr );
		}
		
		private function _createInnerShadow(inner:Boolean = false, distance:Number = 5, alpha:Number = .4, blur:Number = 2, shadowAngle:Number = 45 ):DropShadowFilter{
			
			var color:Number = 0x000000;
			var angle:Number = shadowAngle;
			var alpha:Number = alpha;
			var blurX:Number = blur;
			var blurY:Number = blur;
			var distance:Number = distance;
			var strength:Number = 0.85;
			var inner:Boolean = inner;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			return new DropShadowFilter(distance,
				angle,
				color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
		}
		
		public function render( bgData:VidpaneSkinData ):void{
			
			_bgHldr.graphics.clear();
			
			if( bgData.bgStyle == VidpaneSkinData.BG_STYLE_SOLID ){
				
				_bgHldr.graphics.beginFill((( bgData.bgColors.length > 0 ) ? bgData.bgColors[ 0 ] : 0x000000 ));
				_bgHldr.graphics.drawRect( 0, 0, _vidPane.width, _vidPane.height );
				_bgHldr.graphics.endFill();
				
			} else {
				
				var bgMatrix:Matrix = new Matrix();
				bgMatrix.createGradientBox( _vidPane.width, _vidPane.height, ( bgData.bgAngle/180 * Math.PI ));
				
				_bgHldr.graphics.beginGradientFill( bgData.bgStyle, bgData.bgColors, bgData.bgAlphas, bgData.bgRatios, bgMatrix  );
				_bgHldr.graphics.drawRect( 0, 0, _vidPane.width, _vidPane.height );
				_bgHldr.graphics.endFill();
				
			}
			
		}
		
	}
}