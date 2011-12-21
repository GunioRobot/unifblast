package
{
	import Box2D.Dynamics.b2Body;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import library.WorldX;
	/**
	 * ...
	 * @author Hill
	 */
	public class Actor extends EventDispatcher
	{
		protected var _body:b2Body; //Physics representation
		protected var _costume:DisplayObject; //Sprite representation

		public function Actor(myBody:b2Body, myCostume:DisplayObject)
		{
			_body = myBody;
			_body.SetUserData(this);//Point to the specific actor that contains this b2Body
			_costume = myCostume;

			updateMyLook();
		}

		public function updateNow():void //***Actor updating***
		{
			updateMyLook();
			childSpecificUpdating();
		}

		protected function childSpecificUpdating():void
		{
			//I expect it to be called by classes created from this base class when i want to update somethinh other than updateMyLook();
		}

		public function destroy():void //***Destroy Actors***
		{
			//Remove event listener, misc clean up
			cleanUpBeforeRemoving();

			//remove the costume sprite from the display
			_costume.parent.removeChild(_costume);

			//destroy the body
			PhysicValues.world.DestroyBody(_body);

			//removes actor from the world
		}

		protected function cleanUpBeforeRemoving():void
		{
			//This function does nothing
			//will be overriden by my children
		}

		private function updateMyLook():void //***Sprite follows physics representation of the object***
		{
			_costume.x = _body.GetPosition().x * PhysicValues.RATIO;
			_costume.y = _body.GetPosition().y * PhysicValues.RATIO;
			_costume.rotation = _body.GetAngle() * 180 / Math.PI;
		}

	}

}