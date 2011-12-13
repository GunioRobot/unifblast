package  
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import library.WorldX;
	
	/**
	 * ...
	 * @author Hill
	 */
	public class ManActor extends Actor 
	{
		
		
		public function ManActor(parent:DisplayObjectContainer, initLocation:Point, initVelocity:Point) 
		{
			//***Create costume/Sprite***
			var manSprite:Sprite = new ManSprite1(); //Will only create this entire object with this sprite so wont work later one if we add different characters
			parent.addChild(manSprite);
			
			//***Create Shape Definition***
			var manShapeDef:b2PolygonDef = new b2PolygonDef(); //Defines shape Values
			manShapeDef.SetAsBox(25 / PhysicValues.RATIO, 37.5 / PhysicValues.RATIO);
			manShapeDef.friction = 0.3;
			manShapeDef.restitution = 0.5;
			manShapeDef.density = 1;
			
			//***Create Body Definition***
			var manBodyDef:b2BodyDef = new b2BodyDef();//Creates Body and Sets Position
			//manBodyDef.position.Set(950 / PhysicValues.RATIO, 10 / PhysicValues.RATIO);
			manBodyDef.position.Set(initLocation.x / PhysicValues.RATIO, initLocation.y / PhysicValues.RATIO);
			manBodyDef.angle = 45 * Math.PI / 180; //NEEDS LOOKING AT SO IT CHANGES WITH ANGLE OF MOUSE
			
			//***Create Body***
			var manBody:b2Body = PhysicValues.world.CreateBody(manBodyDef);

			//***Create Shape***
			manBody.CreateShape(manShapeDef);
			manBody.SetMassFromShapes();
			
			//***Set the velocity to match our parameter***
			var velocityVector:b2Vec2 = new b2Vec2(0, initVelocity.y / PhysicValues.RATIO);
			manBody.SetLinearVelocity(velocityVector);
			
			super(manBody, manSprite);
			
			
		}
		
		override protected function childSpecificUpdating():void//***If costume is off stage output to screen***
		{
			if (_costume.y > _costume.stage.stageHeight)
			{
				trace ("wow! Off stage!");
			}
			
			super.childSpecificUpdating();
			//WorldX.xVelocity += this._body.GetLinearVelocity().x;
			//trace("Man: X-Vel: " + WorldX.xVelocity);
			var newVelocity:b2Vec2 = new b2Vec2(0, this._body.GetLinearVelocity().y);
			this._body.SetLinearVelocity(newVelocity);
		}
		
	}

}