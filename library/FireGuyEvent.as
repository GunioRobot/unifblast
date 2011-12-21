    package library
    {
		import flash.events.Event;
		public class FireGuyEvent extends Event
		{
			public static const FIRE_GUY:String = "FireGuy";
			public static const STOP_GUY:String = "StopGuy";

			public function FireGuyEvent(type:String = FireGuyEvent.FIRE_GUY, bubbles:Boolean = false, cancelable:Boolean = false)
			{
				super(type, bubbles, cancelable);
			}

			override public function clone():Event {
				return new FireGuyEvent(type, bubbles, cancelable);
			}
		}
    }