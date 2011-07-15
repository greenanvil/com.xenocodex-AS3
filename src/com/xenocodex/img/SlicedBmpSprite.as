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
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author dsmith
	 */
	public class SlicedBmpSprite extends Sprite{
		
		public var dynDim:String;
		public var oppDimLen:Number;
		public var scaleGridEdgeW:int = 1;
		private var buildXML:XML;
		private var buildLen:int;
		private var redraw:Boolean = false;
		
		public function SlicedBmpSprite(dataIN:*, buildLen:int, dynDim:String = 'Y') {
			
			this.dynDim = dynDim.toUpperCase();
			
			switch( typeof dataIN ){
				
				case 'xml':
					
					this.buildXML = dataIN;
					break;
				
				case 'object':
					
					break;
				
			}
			
			
			this.buildLen = buildLen;
			
			this.build();
			
		}
		
		public function setGridEdgeW(newW:int):void {
			this.scaleGridEdgeW = newW;
		}
		
		public function build():void {
			
			var xCaret:int = 0, yCaret:int = 0, addIndex:int = 0, thisSliceInfo:XML;
			var libImgName:String, sliceData:XMLList, sliceInfo:XML, wh:Array, xy:Array, isStaticHTile:Boolean;
			var tileCount:int, sliceIndex:int, staticDim:int, eachTileDim:Number, lastPieceOffset:int, otherDimMax:Number = 0;
			
			var tileList:Array = new Array();
			var staticHTileList:Array = new Array();
			
			if (this.buildXML.@xpandLen.toString != '') staticDim = parseInt(this.buildXML.@xpandLen);
			
			if (this.buildXML.@libImgName) {
				libImgName = this.buildXML.@libImgName;
			} else {
				// throw error... cant proceed without image lib image
			}
			
			var srcImg:Bitmap = ImgLib.getImg( libImgName );
			
			if( !srcImg ){
				throw( new Error('No source image.'));
				return;
			}
			
			sliceData = this.buildXML..slice;
			
			var tileSlices:XMLList = this.buildXML.*.(hasOwnProperty('@isTile') && @isTile == '1');
			var nonTileSlices:XMLList = this.buildXML.*.(!hasOwnProperty('@isTile'));
			
			// sum the relevant dimension of all non-tile slices
			var nTileSliceLen:int = 0, allTilesLen:int = 0;
			for each(thisSliceInfo in nonTileSlices) nTileSliceLen += (this.dynDim == 'Y') ? parseInt(thisSliceInfo.@h) : parseInt(thisSliceInfo.@w);
			
			// get tile slice lenths
			var tilesLen:int = tileSlices.length(), tileNum:Number = 0;
			var eachTileLen:int = ((buildLen - nTileSliceLen) / tilesLen);
			var sliceBaseLen:int = 0, sliceLen:int = 0, relDirAttr:String, isTile:Boolean = false, thisW:int, thisH:int, thisX:int, thisY:int;
			var lastTileXtnd:int = (buildLen - nTileSliceLen - (eachTileLen * tilesLen));
			
			for each(thisSliceInfo in this.buildXML..slice) {
				
				var thisSlice:BmpRegionTile;
				
				relDirAttr = (this.dynDim == 'Y') ? thisSliceInfo.@y : thisSliceInfo.@x;
				sliceBaseLen = parseInt(relDirAttr);
				isTile = (thisSliceInfo.hasOwnProperty('@isTile') && thisSliceInfo.@isTile == '1');
				sliceLen = isTile ? eachTileLen : sliceBaseLen;
				
				// create slice
				if (isTile) {
					thisW = (this.dynDim == 'Y') ? thisSliceInfo.@w : sliceLen; 
					thisH = (this.dynDim == 'Y') ? sliceLen :  thisSliceInfo.@h;
					thisSlice = new BmpRegionTile(srcImg.bitmapData, thisW, thisH, thisSliceInfo.@x, thisSliceInfo.@y, thisSliceInfo.@w, thisSliceInfo.@h, null, true);
				} else {
					thisSlice = new BmpRegionTile(srcImg.bitmapData, thisSliceInfo.@w, thisSliceInfo.@h, thisSliceInfo.@x, thisSliceInfo.@y, thisSliceInfo.@w, thisSliceInfo.@h, null, true);
				}
				
				thisSlice.x = xCaret; 
				thisSlice.y = yCaret;
				
				if (this.dynDim == 'Y') {
					yCaret += (isTile) ? thisH : parseInt(thisSliceInfo.@h);
				} else {
					xCaret += (isTile) ? thisW : parseInt(thisSliceInfo.@w);
				}
				
				if (this.redraw) {
					this.removeChildAt(addIndex);
					addIndex++;
				}
				this.addChild(thisSlice);
				
			}
			
			this.redraw = true;
			
		}
		
		public function expand(newW:int):void {
			
			// YOU ARE HERE
			// The idea: store a reference to the original build xml data. When the call comes to expand
			// update the @xpandLen value in the original xml and redraw at the new length.  
			// The question is, should the 3 slice responsibilities be on the build() method here, which means that
			// the BmpRegionTile is drawn and then redrawn, or do we pass some sort of transform object into the 
			// constructor for the BmpRegionTile object which will sort of clutter up the meaning of the constructor
			// BUT will draw it the intended way one time. 
			
			this.buildXML.@xpandLen = newW;
			
			this.build();
			
			trace(this.numChildren);
			
			/*
			var i:int, thisChild:DisplayObject, relDim:int;
			var cdrnLen:int = this.numChildren;
			
			for (i = 0; i < cdrnLen; i++) {
				
				thisChild = this.getChildAt(i);
				relDim = (this.dynDim == 'Y') ? thisChild.height : thisChild.width;
				
				if (thisChild.height == 1) {
					if (this.dynDim == 'Y') {
						thisChild.width = newW;
					} else {
						thisChild.height = newW;
					}
				} else {
					
					//trace('thisChild.height: ' + thisChild.height);
					//trace('center w: ' + (newW - (2 * scaleGridEdgeW)));
					
					//thisChild.scale9Grid = new Rectangle(1, 1, 198, 200);
					//thisChild.width = newW;
					
					//SlicedBmp(thisChild).exp
					
					trace(this.build);
					
				}
				
			}
			*/
			
		}
		
	}
	
}