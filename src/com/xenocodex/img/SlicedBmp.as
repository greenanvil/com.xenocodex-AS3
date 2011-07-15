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

package com.xenocodex.img {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.xenocodex.img.ImgLib;
	import com.xenocodex.img.events.ImgLibEvent;
	
	import com.xenocodex.img.SlicedBmpSprite;
	
	/**
	 * ...
	 * @author dsmith
	 */
	public class SlicedBmp extends Sprite{
		
		private static var imgLib:ImgLib = ImgLib.getImgLib();
		private var buildXML:XML;
		private var buildLen:int;
		private var growDir:String;
		
		public static function create(dataIN:XML, buildLen:int, growDir:String = 'Y'):SlicedBmpSprite {
			
			var xCaret:int = 0, yCaret:int = 0, thisSliceInfo:XML;
			var libImgName:String, sliceData:XMLList, sliceInfo:XML, wh:Array, xy:Array, isStaticHTile:Boolean;
			var tileCount:int, sliceIndex:int, staticDim:int, eachTileDim:Number, lastPieceOffset:int, otherDimMax:Number = 0;
			
			var tileList:Array = new Array(), rtrnSpr:SlicedBmpSprite = new SlicedBmpSprite(dataIN, buildLen, growDir);
			var staticHTileList:Array = new Array();
			
			growDir = growDir.toUpperCase()
			if (dataIN.@xpandLen) staticDim = parseInt(dataIN.@xpandLen);
			
			//trace('staticDim: ' + staticDim);
			
			if (dataIN.@libImgName) {
				libImgName = dataIN.@libImgName;
			} else {
				// throw error... cant proceed without image lib image
			}
			
			var srcImg:Bitmap = ImgLib.getImg(libImgName);
			
			sliceData = dataIN..slice;
			
			var tileSlices:XMLList = dataIN.*.(hasOwnProperty('@isTile') && @isTile == '1');
			var nonTileSlices:XMLList = dataIN.*.(!hasOwnProperty('@isTile'));
			
			// sum the relevant dimension of all non-tile slices
			var nTileSliceLen:int = 0, allTilesLen:int = 0;
			for each(thisSliceInfo in nonTileSlices) nTileSliceLen += (growDir == 'Y') ? parseInt(thisSliceInfo.@h) : parseInt(thisSliceInfo.@w);
			
			// get tile slice lenths
			var tilesLen:int = tileSlices.length(), tileNum:Number = 0;
			var eachTileLen:int = ((buildLen - nTileSliceLen) / tilesLen);
			var sliceBaseLen:int = 0, sliceLen:int = 0, relDirAttr:String, isTile:Boolean = false, thisW:int, thisH:int, thisX:int, thisY:int;
			var lastTileXtnd:int = (buildLen - nTileSliceLen - (eachTileLen * tilesLen));
			
			for each(thisSliceInfo in dataIN..slice) {
				
				var thisSlice:BmpRegionTile;
				
				relDirAttr = (growDir == 'Y') ? thisSliceInfo.@y : thisSliceInfo.@x;
				sliceBaseLen = parseInt(relDirAttr);
				isTile = (thisSliceInfo.hasOwnProperty('@isTile') && thisSliceInfo.@isTile == '1');
				sliceLen = isTile ? eachTileLen : sliceBaseLen;
				
				// create slice
				if (isTile) {
					thisW = (growDir == 'Y') ? thisSliceInfo.@w : sliceLen; 
					thisH = (growDir == 'Y') ? sliceLen :  thisSliceInfo.@h;
					thisSlice = new BmpRegionTile(srcImg.bitmapData, thisW, thisH, thisSliceInfo.@x, thisSliceInfo.@y, thisSliceInfo.@w, thisSliceInfo.@h, null, true);
				} else {
					thisSlice = new BmpRegionTile(srcImg.bitmapData, thisSliceInfo.@w, thisSliceInfo.@h, thisSliceInfo.@x, thisSliceInfo.@y, thisSliceInfo.@w, thisSliceInfo.@h, null, true);
				}
				
				thisSlice.x = xCaret; 
				thisSlice.y = yCaret;
				
				if (growDir == 'Y') {
					yCaret += (isTile) ? thisH : parseInt(thisSliceInfo.@h);
				} else {
					xCaret += (isTile) ? thisW : parseInt(thisSliceInfo.@w);
				}
				
				rtrnSpr.addChild(thisSlice);
				
			}
			
			return rtrnSpr;
			
		}
		
		/*
		public function expand(xpandLen:int):void {
			
			this.buildXML.@xpandLen = xpandLen;
			this.create(this.buildXML, this.buildLen, this.growDir);
			
		}
		*/
		
	}
	
}