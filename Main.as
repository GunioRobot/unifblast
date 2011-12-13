package  
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.b2Bound;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import library.PowerMeter;
	import flash.display.Stage;
	import library.AssetHandler;
	import library.ConnectToFB;
	import library.WorldX;
	import library.t;
	
	/**
	 * NOTES:
		 * 
	 * @author Hill
	 */
	public class Main extends MovieClip
	{

		var scrollSpeed:uint = 10;
		var _allActors:Array;
		var _actorsToRemove:Array;
		var _minesContacted:Array;
		var _worldFloor:b2Body;
		var _backWall:b2Body;
		private static var _stage:Stage;

		private const LAUNCH_POINT:Point = new Point(100, 550);
		var powerMeter = new PowerMeter();
		private var graybar:GrayBar 	= new GrayBar();
		private var redbar:RedBar 		= new RedBar();
		private var ibar:InvisibleBar 	= new InvisibleBar();
		private var replayBtn:ReplayButton = new ReplayButton;
		var lText:LoaderText 	= new LoaderText();
		var Asset = new AssetHandler(stage.stageWidth, stage.stageHeight);
		var cannon = Asset.Movie("Cannon");
		var holder = Asset.Movie("Holder");
		var s1:ScrollingBg = new ScrollingBg();
		var s2:ScrollingBg = new ScrollingBg();
		
		public function Main() {
			super();
			gotoAndStop(1);
			addEventListener(Event.ENTER_FRAME, loading);
		}
		
		public function loading(e:Event):void {
			var total:Number = stage.loaderInfo.bytesTotal;
			var loaded:Number = stage.loaderInfo.bytesLoaded;
			//t.obj(LoaderTextSymbol);
			LoaderTextSymbol.LoaderTxt.text = Math.floor((loaded / total) * 100) + "%";
			
			trace(Math.floor((loaded / total) * 100));
			
			if (total == loaded) {
				removeEventListener(Event.ENTER_FRAME, loading);
				gotoAndStop(2);
				addEventListener(Event.ENTER_FRAME, menu);
				stop();
			}
		}
		public function menu(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, menu);
			PlayBtn.addEventListener(MouseEvent.CLICK, playGame);
		}
		public function playGame(e:Event):void {
			PlayBtn.removeEventListener(MouseEvent.CLICK, playGame);
			gotoAndStop(3);
			InitGame();
		}
		public function replayGame(e:Event):void {
			replayBtn.removeEventListener(MouseEvent.CLICK, playGame);
			gotoAndStop(3);
			InitGame();
		}
		public function InitGame() //***Entry Point***
		{
			_stage = this.stage;
			_allActors = [];
			_actorsToRemove = [];
			_minesContacted = [];
			addChild(s1);
			addChild(s2);
			setupPhysicsWorld(); //Passes to setupPhysicsWorld method
			//addSomeMines();
			addEventListener(Event.ENTER_FRAME, newFrameListener);
			addPower();
			stage.addEventListener(MouseEvent.MOUSE_UP, checkReady);
			holder.x = 40;
			holder.y = 550;
			cannon.x = 30;
			cannon.y = 538;
			addChild(cannon);
			addChild(holder);
			s1.x = 0;
			s2.x = s1.width;
		}
		
		public function addPower():void {
			ibar.y = -7;
			addChild(graybar);
			redbar.mask = ibar;
			addChild(redbar);
			powerMeter.PowerMeterStart(redbar, cannon);
		}
		public static function get stage():Stage { return _stage; }
		
		
		private function newFrameListener(e:Event):void //***Real Time Code Method***
		{
			PhysicValues.world.Step(1 / 30.0, 10);
			for each (var actor:Actor in _allActors)
			{
				actor.updateNow();
			}
			
			reallyRemoveActors();
			for each (var mineToRemove:MineActor in _minesContacted)
			{
				safeRemoveActor(mineToRemove);
			}
			
			_minesContacted = []; //Position of this deletion command could take up comp resources
			
			s1.x -= WorldX.xVelocity;
			s2.x -= WorldX.xVelocity;
			if(s1.x < -s1.width)
			{
				s1.x = s1.width;
				addSomeMines();
			}
			else if(s2.x < -s2.width)
			{
				s2.x = s2.width;
				addSomeMines();
			}
			//Wind Resistance
			WorldX.xVelocity *= 0.99;
		}
		//Actually remove the actors that have been marked for deletion
		//in my remove actors function
		private function reallyRemoveActors():void 
		{
			for each (var removeMe:Actor in _actorsToRemove)
			{
				removeMe.destroy();
				
				//remove it from our main list of actors
				var actorIndex:int = _allActors.indexOf(removeMe);
				if (actorIndex > -1)
				{
					_allActors.splice(actorIndex, 1);
				}
			}
			
			_actorsToRemove = [];
		}
		
		//Mark an actor to be removed later, at a same time
		//It won't actually remove anything yet
		public function safeRemoveActor(actorToRemove:Actor):void
		{
			if (_actorsToRemove.indexOf(actorToRemove) < 0)
			{
				_actorsToRemove.push(actorToRemove);
			}
		}
		
		private function checkReady(e:Event):void{
			if (powerMeter.readyToLaunch==true)
			{
				launchMan();
				stage.removeEventListener(MouseEvent.MOUSE_UP, checkReady);
			}
		}
		
		private function launchMan():void //***On clock launch a newMan object and store it in array***
		{
			var direction:Point = new Point(mouseX, mouseY).subtract(LAUNCH_POINT);
			direction.normalize(powerMeter.currentPower);
			WorldX.xVelocity = 20;
			
			var newMan:ManActor = new ManActor(this, LAUNCH_POINT, direction);
			_allActors.push(newMan);
			removeChild(cannon);
			removeChild(holder);
			removeChild(graybar);
			removeChild(redbar);
			addSomeMines();
			addChild(replayBtn);
			replayBtn.addEventListener(MouseEvent.CLICK, replayGame);
		}
		
		private function randomNumber(low:Number=0, high:Number=1):Number
		{
			return Math.floor(Math.random() * (1+high-low)) + low;
		}
		
		private function addSomeMines():void 
		{
			var numberOfMines:int; //Stores the number of mines to be generated
			var newMineXValue:int; //Stores the X value of the mines to be placed
			
			//numberOfMines = randomNumber(0,5); //Generates how many mines to spawn, this could be useful later
			//if we wanted to spawn more mines the further the character is launched
			numberOfMines = 5;
			
			for (var i:int; i<numberOfMines; i++)
			{
				newMineXValue = randomNumber(720,1440);
				var newMine:MineActor = new MineActor(this, new Point(newMineXValue, 580))
				newMine.addEventListener(MineEvent.MINE_CONTACT, handleMineContact);
				_allActors.push(newMine);
			}
		}
		
		private function handleMineContact(e:MineEvent):void //!!!!!Maybe we could insert physics code here for mines rather than use bouncyness!!!!!
		{
			//Record the fact that the mine has been hit, to remove it laters
			var mineActor:MineActor = MineActor(e.currentTarget);
			mineActor.removeEventListener(MineEvent.MINE_CONTACT, handleMineContact);
			if (_minesContacted.indexOf(mineActor) < 0)
			{
				_minesContacted.push(mineActor);
			}
			WorldX.xVelocity += 5;
			
		}
		private function setupPhysicsWorld():void //***Creates Physics World values and then creates the World***
		{
			var worldBounds:b2AABB = new b2AABB();
			worldBounds.lowerBound.Set( -5000 / PhysicValues.RATIO, -5000 / PhysicValues.RATIO);
			worldBounds.upperBound.Set(5000 / PhysicValues.RATIO, 5000 / PhysicValues.RATIO);
			
			var gravity:b2Vec2 = new b2Vec2(0, 9.8);
			var allowSleep:Boolean = true;
			
			PhysicValues.world = new b2World(worldBounds, gravity, allowSleep); //Passes created variables to PhysicValues.as
			PhysicValues.world.SetContactListener(new CannonBlastContactListener()); //Sets contact listener to our contact listener
			
			//***Create Floor*** - When floor is hit it returns null as it isnt part of the Actor class!!!!
			var floorShapeDef:b2PolygonDef = new b2PolygonDef(); //***Define floor shape Values***
			floorShapeDef.SetAsBox(1000 / PhysicValues.RATIO, 5 / PhysicValues.RATIO);
			floorShapeDef.friction = 0.1;
			floorShapeDef.restitution = 0.2;
			floorShapeDef.density = 0.0;
			
			var floorBodyDef:b2BodyDef = new b2BodyDef();//***Creates Body and Sets Position***
			floorBodyDef.position.Set(1000 / PhysicValues.RATIO, 600 / PhysicValues.RATIO)
			
			_worldFloor = PhysicValues.world.CreateBody(floorBodyDef);//Passes to PhysicValues
			_worldFloor.CreateShape(floorShapeDef);
			_worldFloor.SetMassFromShapes();
			
			//***Create Back Wall*** This wall keeps the man from leaving the screen to the left
/*			var backWallShapeDef:b2PolygonDef = new b2PolygonDef(); //***Define floor shape Values***
			backWallShapeDef.SetAsBox(5 / PhysicValues.RATIO, 750 / PhysicValues.RATIO);
			backWallShapeDef.friction = 0.1;
			backWallShapeDef.restitution = 0.2;
			backWallShapeDef.density = 0.0;
			
			var backWallBodyDef:b2BodyDef = new b2BodyDef();//***Creates Body and Sets Position***
			backWallBodyDef.position.Set(0 / PhysicValues.RATIO, 0 / PhysicValues.RATIO)
			
			_backWall = PhysicValues.world.CreateBody(backWallBodyDef);//Passes to PhysicValues
			_backWall.CreateShape(backWallShapeDef);
			_backWall.SetMassFromShapes();*/
		}
		
	}

}