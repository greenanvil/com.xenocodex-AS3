package com.xenocodex.util{
	
	import com.xenocodex.events.StatusMessageEvent;
	import com.xenocodex.img.ImgLib;
	import com.xenocodex.img.events.ImgLibEvent;
	import com.xenocodex.util.ActionRelay;
	import com.xenocodex.util.Dbug;
	import com.xenocodex.util.FlashVarMgr;
	import com.xenocodex.util.data.ResourceLocations;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	
	public class PreloaderBase extends MovieClip{
		
		protected var _actionRelay:ActionRelay;
		protected var _swcLoader:Loader = new Loader();
		
		public var preloaderAnim:*;
		
		public function PreloaderBase( debugLevel:int = 0 ){
			
			Dbug.LEVEL = debugLevel;
			
			_actionRelay = ActionRelay.getActionRelay();
			
			if ( stage ) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			
			this.processFlashVars();
			
			addEventListener( Event.ENTER_FRAME, this.checkFrame );
			loaderInfo.addEventListener( ProgressEvent.PROGRESS, this.handleProgressEvent );
			loaderInfo.addEventListener( IOErrorEvent.IO_ERROR, this.handleIoError );
			
			this.build();
			
		}
		
		protected function processFlashVars():void{
			FlashVarMgr.regFlashVars( this.loaderInfo );
		}
		
		protected function build():void{
			
			Dbug.report( this + ' > build()' );
			
			this.buildPreloader();
			this.layout();
		}
		
		protected function buildPreloader():void{
			// overridden by extenders
		}
		
		protected function layout():void{
			// overridden by extenders
		}
		
		protected function handleIoError( e:IOErrorEvent ):void {
			trace( e.text ); 
		}
		
		protected function handleProgressEvent( e:ProgressEvent ):void {
			// overridden by extenders
		}
		
		protected function checkFrame( e:Event ):void {
			
			if ( this.currentFrame == this.totalFrames ) {
				
				this.stop();
				this.swfLoaded();
				
			}
			
		}
		
		protected function swfLoaded():void {
			
			removeEventListener( Event.ENTER_FRAME, this.checkFrame );
			loaderInfo.removeEventListener( ProgressEvent.PROGRESS, this.handleProgressEvent );
			loaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, this.handleIoError );
			
			// -----------------------------------
			// SWF is loaded and ready
			
			// dispacth load status event notifying the user of current activities
			ActionRelay.dispatchEvent( new StatusMessageEvent( StatusMessageEvent.LOAD_STATUS, 'Loading image assets...' ));
			
			_registerImageAssets();
			_loadImageAssets();
			
		}
		
		// ------------------------------------------------------------
		// Image Assets
		protected function _registerImageAssets():void{
			// overridden by extenders
			// Example: ImgLib.queueImg( 'mainBg', 'assets/grfx/bg.jpg' );
		}
		
		protected function _loadImageAssets():void{
			
			ActionRelay.dispatchEvent( new StatusMessageEvent( StatusMessageEvent.LOAD_STATUS, 'Setting up image library assets...' ));
			
			// load images
			ImgLib.addEventListener( ImgLibEvent.IMG_LOADED, this.handleImageLoaded );
			ImgLib.addEventListener( ImgLibEvent.ALL_IMGS_LOADED, this.handleAllImagesLoaded );
			
			this.stage.dispatchEvent( new StatusMessageEvent( StatusMessageEvent.LOAD_STATUS, 'Loading images...' ));
			
			ImgLib.loadQueuedImages();
			
		}
		
		protected function handleImageLoaded( e:ImgLibEvent ):void{
			Dbug.report( this + ' > handleImageLoaded() > image ID ' + e.id );
		}
		
		protected function handleAllImagesLoaded( e:ImgLibEvent ):void{
			
			Dbug.report( this + ' > handleAllImagesLoaded()' );
			
			this.loadMainSWC();
			
		}
		
		// ------------------------------------------------------------
		// Main SWC
		
		protected function loadMainSWC():void{
			
			Dbug.report( this + ' > loadMainSWC()' );
			
			var rlocs:Class = ResourceLocations;
			
			if( ResourceLocations.SWC_LIB ){
				
				_swcLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, this.handleMainSWCLoaded );
				_swcLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, this.handleProgressEvent );
				
				ActionRelay.dispatchEvent( new StatusMessageEvent( StatusMessageEvent.LOAD_STATUS, 'Loading swc library...' ));
				
				_swcLoader.load( new URLRequest( ResourceLocations.SWC_LIB ), new LoaderContext( false, ApplicationDomain.currentDomain ));
				
			} else {
				
				ActionRelay.dispatchEvent( new StatusMessageEvent( StatusMessageEvent.LOAD_STATUS, 'DONE', true ));
				this.loadMain();
				
			}
			
		}
		
		protected function handleMainSWCLoaded( event:Event ):void{
			
			Dbug.report( this + ' > handleMainSWCLoaded()' );
			
			this.stage.dispatchEvent( new StatusMessageEvent( StatusMessageEvent.LOAD_STATUS, 'DONE', true ));
			
			this.loadMain();
			
		}
		
		protected function loadMain():void{
			
			Dbug.report( this + ' > loadMain()' );
			
			var mainClass:Class = getDefinitionByName("Main") as Class;
			
			this.cleanup();
			
			if (parent == stage){
				stage.addChildAt(new mainClass() as DisplayObject, 0);	
			} else {
				addChildAt(new mainClass() as DisplayObject, 0);
			}
			
		}
		
		protected function cleanup():void{ 
			// overridden by extenders
		}
	}
}