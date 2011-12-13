package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hill
	 */
	public class MineEvent extends Event 
	{
		
		public static const MINE_CONTACT:String = "Mine Contact"
		
		public function MineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new MineEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MineEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}