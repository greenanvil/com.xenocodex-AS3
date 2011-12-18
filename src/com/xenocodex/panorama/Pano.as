package com.xenocodex.panorama{
	
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.SkyBox;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	import com.xenocodex.panorama.data.PanoramaImages;
	
	import flash.display.MovieClip;
	import flash.display.Stage3D;
	
	public class Pano extends MovieClip{
		
		private var _stage3D:Stage3D;
		
		public var skybox:SkyBox;
		public var box:Box;
		
		public var scene:Object3D = new Object3D();
		
		public var panoImages:PanoramaImages;
		
		public var maxPanSpeed:Number = 0.002;
		
		public var minVAngle:Number = 0;
		public var maxVAngle:Number = 180;
		public var currVAngle:Number;
		
		public var _faceUp:Plane;
		public var _faceDown:Plane;
		public var _faceLeft:Plane;
		public var _faceRight:Plane;
		public var _faceFront:Plane;
		public var _faceBack:Plane;
		
		
		public function Pano( panoImages:PanoramaImages, stage3D:Stage3D ){
			
			super();
			
			_stage3D = stage3D;
			
			this.panoImages = panoImages;
			
			_build();
			
		}
		
		private function _build():void{
			
			var skinDownHi:TextureMaterial = new TextureMaterial( new BitmapTextureResource( this.panoImages.hiDown.bitmapData ));
			var skinUpHi:TextureMaterial = new TextureMaterial( new BitmapTextureResource( this.panoImages.hiUp.bitmapData ));
			var skinUpFront:TextureMaterial = new TextureMaterial( new BitmapTextureResource( this.panoImages.hiFront.bitmapData ));
			var skinUpBack:TextureMaterial = new TextureMaterial( new BitmapTextureResource( this.panoImages.hiBack.bitmapData ));
			var skinUpRight:TextureMaterial = new TextureMaterial( new BitmapTextureResource( this.panoImages.hiRight.bitmapData ));
			var skinUpLeft:TextureMaterial = new TextureMaterial( new BitmapTextureResource( this.panoImages.hiLeft.bitmapData ));
			
			// build skybox
			this.skybox = new SkyBox(
				3000, 					//Size of skybox
				new TextureMaterial( new BitmapTextureResource( this.panoImages.lowRight.bitmapData )), 		//Material for right side
				new TextureMaterial( new BitmapTextureResource( this.panoImages.lowLeft.bitmapData )),		//Material for left side
				new TextureMaterial( new BitmapTextureResource( this.panoImages.lowBack.bitmapData )), 		//Material for back side
				new TextureMaterial( new BitmapTextureResource( this.panoImages.lowFront.bitmapData )), 		//Material for front side
				new TextureMaterial( new BitmapTextureResource( this.panoImages.lowDown.bitmapData )), 		//Material for bottom side
				new TextureMaterial( new BitmapTextureResource( this.panoImages.lowUp.bitmapData )), 		//Material for top side
				0.01);					//Padding from the edges in texture coordinates
			
			//this.skybox.rotationZ = 180;
			
			var bottomMaterial:FillMaterial = new FillMaterial(0xFF0000);
			var topMaterial:FillMaterial = new FillMaterial(0x00FF00);
			
			// build cube
			_faceUp = new Plane( 2000, 2000, 1, 1 , false, false, bottomMaterial, skinUpHi );
			_faceUp.z = 1000;
			_faceUp.rotationX = 180 * Math.PI/180;
			_faceUp.rotationZ = 180 * Math.PI/180;
			
			_faceDown = new Plane( 2000, 2000, 1, 1 , false, false, null, skinDownHi );
			_faceDown.z = -1000;
			
			_faceLeft = new Plane( 2000, 2000, 1, 1 , false, false, null, skinUpLeft );
			_faceLeft.x = 1000;
			_faceLeft.rotationX = 90 * Math.PI/180;
			_faceLeft.rotationZ = -90 * Math.PI/180;
			
			_faceRight = new Plane( 2000, 2000, 1, 1 , false, false, null, skinUpRight );
			_faceRight.x = -1000;
			_faceRight.rotationX = 90 * Math.PI/180;
			_faceRight.rotationZ = 90 * Math.PI/180;
			
			_faceFront = new Plane( 2000, 2000, 1, 1 , false, false, null, skinUpFront );
			_faceFront.y = -1000;
			_faceFront.rotationX = -90 * Math.PI/180;
			_faceFront.rotationY = 180 * Math.PI/180;
			
			_faceBack = new Plane( 2000, 2000, 1, 1 , true, false, bottomMaterial, skinUpBack );
			_faceBack.y = 1000;
			_faceBack.rotationX = 90 * Math.PI/180;
			//_faceBack.rotationY = -180 * Math.PI/180;
			
			this.scene.addChild( _faceDown );
			this.scene.addChild( _faceUp );
			this.scene.addChild( _faceLeft );
			this.scene.addChild( _faceRight );
			this.scene.addChild( _faceFront );
			this.scene.addChild( _faceBack );
			
			
//			this.box = new Box(999, 999, 999, 1, 1, 1, true);
			this.box = new Box(2048, 2048, 2048, 1, 1, 1, true);
			
			// load materials
			var material:FillMaterial = new FillMaterial(0x3F95F5);
			this.box.setMaterialToAllSurfaces(material);
		
			this.box.addSurface( new TextureMaterial( new BitmapTextureResource( this.panoImages.hiDown.bitmapData )), 0, 2 );
			this.box.addSurface( new TextureMaterial( new BitmapTextureResource( this.panoImages.hiUp.bitmapData )), 6, 2 );
			this.box.addSurface( new TextureMaterial( new BitmapTextureResource( this.panoImages.hiFront.bitmapData )), 12, 2 );
			this.box.addSurface( new TextureMaterial( new BitmapTextureResource( this.panoImages.hiRight.bitmapData )), 30, 2 );
			this.box.addSurface( new TextureMaterial( new BitmapTextureResource( this.panoImages.hiBack.bitmapData )), 18, 2 );
			this.box.addSurface( new TextureMaterial( new BitmapTextureResource( this.panoImages.hiLeft.bitmapData )), 24, 2 );
			
		}
	}
}