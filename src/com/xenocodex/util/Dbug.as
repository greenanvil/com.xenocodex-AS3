package com.xenocodex.util{
	
	public class Dbug{
		
		public static var LEVEL:int = 0;
		
		public function Dbug(){
		}
		
		public static function report( msg:String, lvl:int = 1 ):void{
			
			if( Dbug.LEVEL >= lvl ) trace( msg );
			
		}
	}
}