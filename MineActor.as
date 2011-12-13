package  
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Common.Math.b2Vec2;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import library.WorldX;
	/**
	 * ...
	 * @author Hill
	 */
	public class MineActor extends Actor
	{
		
		//private static const MINE_DIAMETER:int = 35; //This could cause the hitbox to be this or the actual shape of the sprite, unsure as of yet(This isnt used)
		
		private var _beenHit:Boolean;
		
		
		public function MineActor(parent:DisplayObjectContainer, location:Point) 
		{
			_beenHit = false;
			//***Create the costume/sprite***
			var mineMovie:MovieClip = new MineMovie(); //careful?
			parent.addChild(mineMovie);
			
			//***Create Shape Definition***
			var mineShapeDef:b2PolygonDef = new b2PolygonDef(); //Circle def works better for simulating forward moving motion
			mineShapeDef.SetAsBox(24 / PhysicValues.RATIO, 6 / PhysicValues.RATIO);
			mineShapeDef.density = 3;
			mineShapeDef.friction = 0.3;
			mineShapeDef.restitution = 1.9; //could we use this to give the mine explosion effect?
			
			//***Create Body Definition***
			var mineBodyDef:b2BodyDef = new b2BodyDef();
			mineBodyDef.position.Set(location.x / PhysicValues.RATIO, location.y / PhysicValues.RATIO);
			
			//***Create Body***
			var mineBody:b2Body = PhysicValues.world.CreateBody(mineBodyDef);
			
			//***Create Shape***
			mineBody.CreateShape(mineShapeDef);
			mineBody.SetMassFromShapes();
			
			
			super(mineBody, mineMovie);
			
			//***set frame for the movie***
			setMyMovieFrame();
		}
		
		public function hitByMan():void //*** If mine hit by man flag as hit and set movie animation for mine***
		{
			if (! _beenHit)
			{
				_beenHit = true;
				setMyMovieFrame();
				dispatchEvent(new MineEvent(MineEvent.MINE_CONTACT));
			}
		}
		
		private function setMyMovieFrame():void //***Handles costume/animation weather mine is hit or not***
		{
			if (_beenHit)
			{
				MovieClip(_costume).gotoAndPlay(2);
			}
			else 
			{
				MovieClip(_costume).gotoAndStop(1);
			}
		}
		override protected function childSpecificUpdating():void
		{
			super.childSpecificUpdating();
			//var worldX:WorldX = new WorldX();
			//var thisInstance:WorldX = new WorldX();
			var newVelocity:b2Vec2 = new b2Vec2(WorldX.xVelocity, 0);
			newVelocity.x *= -1;
			//trace("Mine: X-Vel: " + this._body.GetLinearVelocity().x);
			this._body.SetLinearVelocity(newVelocity);
		}
	}

}