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

package com.xenocodex.img{
	
	import com.xenocodex.img.events.ImgLibEvent;
	import com.xenocodex.util.Dbug;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	/**
	 * Loads, stores and provides externally loaded image assets.
	 * @author dsmith
	 */
	public class ImgLib extends Sprite{
		
		private static var SELF_REF:ImgLib = null;
		
		private static var EXPECT_NUM:int = 0;
		
		private static var IMG_STACK:Object = new Object();
		private static var REG_LIST:Array = new Array();
		
		public static var REG_QUEUE:Array = new Array();
		
		protected static var EVT_DISP:EventDispatcher;
		
		public function ImgLib(){ }
		
		public static function getImgLib():ImgLib {
			
			if (ImgLib.SELF_REF == null) SELF_REF = new ImgLib();
			
			return SELF_REF;
			
		}
		
		/**
		 * Sets the number of images that the ImgLib should load before firing out its ImgLibEvent.ALL_IMGS_LOADED
		 * event.
		 * @param n	The number of images to expect.
		 * 
		 */		
		public static function set expectNum( n:int ):void {
			ImgLib.EXPECT_NUM = ImgLib.EXPECT_NUM > 0 ? ImgLib.EXPECT_NUM + n : n;
		}
		
		public static function queueImg( imgID:String, imgLoc:String, addExpectNum:Boolean = false ):void{
			REG_QUEUE.push( { imgID:imgID, imgLoc:imgLoc, addExpectNum:addExpectNum } );
		}
		
		public static function loadQueuedImages():void{
			
			Dbug.report('ImgLib > loadQueuedImages()', 2);
			
			var queueLen:int = REG_QUEUE.length;
			
			if( queueLen == 0 ) ImgLib.dispatchEvent( new ImgLibEvent( ImgLibEvent.ALL_IMGS_LOADED ));
			
			ImgLib.EXPECT_NUM = REG_QUEUE.length;
			
			while( --queueLen > -1 ){
				ImgLib.loadImg( REG_QUEUE[ queueLen ].imgID, REG_QUEUE[ queueLen ].imgLoc, REG_QUEUE[ queueLen ].addExpectNum );
			}
			
		}
		
		/**
		 * Begins the loading of an image that the ImgLib references by the image ID value passed into imgID. An image ID is unique in 
		 * the ImgLib.
		 * @param imgID	The image ID of the loaded image.
		 * @param imgLoc	The location where the image may be found. May be a relative path or a fully qualified url.
		 * 
		 */		
		public static function loadImg(imgID:String, imgLoc:String, addExpectNum:Boolean = false ):void{
			
			Dbug.report('ImgLib > loadImg() > ' + imgID + ', '  + imgLoc  + ', '  + addExpectNum, 2);
			
			// TODO: warn if image name is already in use
			if (ImgLib.IMG_STACK[imgID]) {
				
				throw( new Error( 'ImgLib image with ID \'' + imgID + '\' already registered' ));
				
			} else {
				
				REG_LIST.push({imgID: imgID, loaded: false});
				
			}
			
			if( addExpectNum ) ImgLib.EXPECT_NUM++;
			
			var tmpLoader:Loader = new Loader();
			
			var newImgObj:Object = ImgLib.IMG_STACK[imgID] = new Object();
			
			var completeHandler:Function = function(e:Event):void {
				
				Dbug.report(this + ' completeHandler() > ID: ' + imgID, 2 ); 
				
				var tmpBmpData:BitmapData = new BitmapData(tmpLoader.content.width, tmpLoader.content.height);
				tmpBmpData.copyPixels(Bitmap(tmpLoader.content).bitmapData, new Rectangle(0, 0, tmpLoader.content.width, tmpLoader.content.height), new Point(0, 0));
				
				ImgLib.IMG_STACK[imgID] = {
					
					imgName: imgID,
					imgLoc: imgLoc,
					img: new Bitmap(tmpBmpData)
					
				}
				
				tmpLoader.unload();
				tmpLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				tmpLoader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				tmpLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				
				ImgLib.regImgLoad(imgID);
				
			}
			
			var httpStatusHandler:Function = function(e:HTTPStatusEvent):void {
				Dbug.report(this + ' httpStatusHandler() > ID: ' + imgID + ': httpStatusHandler: ' + e.status, 2); 
			}
			var ioErrorHandler:Function = function(e:IOErrorEvent):void {
				Dbug.report(this + ' ioErrorHandler() > ID: ' + imgID + ': ioErrorHandler: ' + e, 2); 
			}
			
			tmpLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, completeHandler );
			tmpLoader.contentLoaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );
			tmpLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			
			tmpLoader.load( new URLRequest( imgLoc ));
			
		}
		
		/**
		 * Registers that an image was loaded and drops the ImgLib.EXPECT_NUM by 1 if there are more images to load.
		 * @param imgID	The string identifier for the image asset that was loaded
		 * 
		 */		
		private static function regImgLoad( imgID:String ):void {
			
			var i:int = REG_LIST.length;
			while (--i) { if ( REG_LIST[ i ].imgID == imgID ) REG_LIST[ i ].loaded = true; }
			
			ImgLib.EXPECT_NUM--;
			
			ImgLib.dispatchEvent( new ImgLibEvent( ImgLibEvent.IMG_LOADED, imgID, true, true ) );
			
			if ( ImgLib.EXPECT_NUM == 0){
				
				ImgLib.dispatchEvent( new ImgLibEvent( ImgLibEvent.ALL_IMGS_LOADED, imgID, true, true ) );
				
			}
		}
		
		/**
		 * Returns true if all images that the ImgLib has been asked to load are loaded 
		 * @return 	Boolean
		 * 
		 */		
		public static function get allAreLoaded():Boolean {
			
			var imgsLoaded:Boolean = true;
			var i:int = REG_LIST.length;
			
			while (--i) {
				
				if (REG_LIST[i].loaded == false) imgsLoaded = false; 
				break;
				
			}
			
			if (ImgLib.EXPECT_NUM > 0) imgsLoaded = false;
			
			return imgsLoaded;
			
		}
		
		/**
		 * Returns true if an image asset has been loaded.
		 * @param	imgID			The string identifier for an image asset
		 * @return		Boolean
		 */
		public static function imageIsReady(imgID:String):Boolean {
			
			var infoRtrn:Boolean = false;
			var i:int = REG_LIST.length;
			
			if(i < 1) return false;
			
			while (--i) { 
				if (REG_LIST[i].imgID == imgID && REG_LIST[i].loaded == true) infoRtrn = true ;
			}
			
			return infoRtrn;
			
		}
		
		/**
		 * Returns a loaded image asset or undefined if no image can be found that matches the provided image ID.
		 * @param imgID	The string identifier of the image asset
		 * @return
		 * 
		 */		
		public static function getImg(imgID:String):Bitmap {
			if (!ImgLib.IMG_STACK[imgID]) return undefined;
			return ImgLib.IMG_STACK[imgID].img;
		}
		
		/**
		 *	Returns a Bitmap slice of a loaded image asset. 
		 * @param imgID 	The string identifier of the image asset
		 * @param slcX		The x position of the upper left pixel of the desired slice region relative to the image asset's upper left corner
		 * @param slcY		The y position of the upper left pixel of the desired slice region relative to the image asset's upper left corner
		 * @param slcW		The width of the desired slice region
		 * @param slcH		The height of the desired slice region
		 * @return 
		 * 
		 */		
		public static function getImgSlice(imgID:String, slcX:uint = 0, slcY:uint = 0, slcW:uint = 0, slcH:uint = 0):Bitmap {
			
			if (!ImgLib.IMG_STACK[imgID]) return undefined;
			
			var img:BitmapData = ImgLib.IMG_STACK[imgID].img.bitmapData;
			
			if (slcW == 0) slcW = img.width;
			if (slcH == 0) slcH = img.height;
			
			var imgSlice:BitmapData = new BitmapData(slcW, slcH, true, 0x00000000);
			
			imgSlice.copyPixels(img, new Rectangle(slcX, slcY, slcW, slcH), new Point(0, 0), null, null, true);
			
			return new Bitmap(imgSlice);
			
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