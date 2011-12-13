package  
{
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Dynamics.b2ContactListener;
	/**
	 * ...
	 * @author Hill
	 */
	public class CannonBlastContactListener extends b2ContactListener
	{
		
		public function CannonBlastContactListener() 
		{
			
		}
		
		override public function Add(point:b2ContactPoint):void //***Determine what has collided and output it and flag it up to MineActor it has been hit***
		{
			trace("Pow!");
			if (point.shape1.GetBody().GetUserData() is MineActor && point.shape2.GetBody().GetUserData() is ManActor)
			{
				MineActor(point.shape1.GetBody().GetUserData()).hitByMan();
				trace("MineActor and ManActor have collided");
			}
			else if (point.shape1.GetBody().GetUserData() is ManActor && point.shape2.GetBody().GetUserData() is MineActor)
			{
				MineActor(point.shape2.GetBody().GetUserData()).hitByMan();
				trace("ManActor and MineActor have collided");
			}
			super.Add(point);
		}
		
	}

}