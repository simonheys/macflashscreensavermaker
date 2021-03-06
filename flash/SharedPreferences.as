package {
	import flash.net.SharedObject;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class SharedPreferences 
	{
		private static var 
			SHARED_OBJECT_ID:String = "com/yourcompany/project",
			_instance:SharedPreferences;
		
		public var
			displayString:String;
		
		private var
			_needsUpdate:Boolean,
			_updateIntervalId:Number,
			_attributes:Array = [
				"displayString"
			];
		
		private static var
			DEFAULT_ATTRIBUTES:Object = {
				displayString:"Hello World"
			};
			
		protected var
			_soId:String;
			
		function SharedPreferences()
		{
			setSharedObjectId(SHARED_OBJECT_ID);
			_needsUpdate = false;
			load();
		}
		
		public function checkUpdate():void
		{
			if ( _needsUpdate ) {
				clearInterval(_updateIntervalId);
				_needsUpdate = false;	
				save();
			}	
		}
		
		public function setNeedsUpdate():void
		{
			if ( !_needsUpdate ) {
				_needsUpdate = true;
				_updateIntervalId = setInterval(checkUpdate,30);
			}	
		}
		
		public function updateImmediately():void
		{
			save();
		}

		static public function getInstance():SharedPreferences
		{
			if ( null == _instance ) {
				_instance = new SharedPreferences();			
			}
			return _instance;		
		}
			
		private function setSharedObjectId(soId:String):void
		{
			_soId = soId;
		}
		
		public function save():void
		{
			var my_so:SharedObject = SharedObject.getLocal(_soId,"/");
			for ( var i:Number = 0; i < _attributes.length; i++ ) {
				my_so.data[_attributes[i]] = this[_attributes[i]];	
			}
			my_so.flush();
		}
	
		public function load():void
		{
			var my_so:SharedObject = SharedObject.getLocal(_soId,"/");
			var o:Object;
			 
			for ( var i:Number = 0; i < _attributes.length; i++ ) {
				o = my_so.data[_attributes[i]];
				if ( undefined == o ) {
					o = getDefault(_attributes[i]);
				}
				this[_attributes[i]] = o;	
			}
		}
		
		public function getDefault(value:String):Object
		{
			return DEFAULT_ATTRIBUTES[value];
		}	
	}
}