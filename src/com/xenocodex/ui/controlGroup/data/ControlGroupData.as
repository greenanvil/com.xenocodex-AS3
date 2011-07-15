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

package com.xenocodex.ui.controlGroup.data{
	
	public class ControlGroupData{
		
		public var minHeight:Number = 30;
		
		public var shownX:Number;
		public var shownY:Number;
		public var shownW:Number;
		public var shownH:Number;
		
		public var hiddenX:Number;
		public var hiddenY:Number;
		public var hiddenW:Number;
		public var hiddenH:Number;
		
		public function ControlGroupData(){}
		
		public function clear():void{
			this.shownX = NaN;
			this.shownY = NaN;
			this.shownW = NaN;
			this.shownH = NaN;
			
			this.hiddenX = NaN;
			this.hiddenY = NaN;
			this.hiddenW = NaN;
			this.hiddenH = NaN;
		}
		
	}
}