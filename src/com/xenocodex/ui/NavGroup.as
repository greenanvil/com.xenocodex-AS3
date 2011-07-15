package com.xenocodex.ui{
	
	import com.xenocodex.ui.layoutHelper.LayoutHelper;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class NavGroup extends Sprite{
		
		private var _activeEntryID:String;
		private var _navDict:Dictionary;
		private var _navList:Array;
		
		private var _layoutHelper:LayoutHelper;
		
		public function NavGroup(){
			super();
		}
		
	}
}