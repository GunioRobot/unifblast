package library
{
	import Main; //doc class
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Stage;

	/**
	 * ...
	 * @author Simon
	 */
	
	 //IMPORTANT: VVVVVVVVVVVVVVV
	 //To use this, simply create an instance("MouseEvent" is 
	 //not working properly for me and if you can fix this .. thx).
	 // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	 
	public class PowerMeter extends MovieClip
	{
		//Change these constants at your leasure
		/*
		 * 
		 * The maximum and minimum values should be
		 * 
		 */
		private const _maximum:Number = 1000;
		private const _minimum:Number = 200;
		private const _rateOfChange:Number = 50;
		private const barHeight:Number = 200;
		
		//Don't touch these
		private var _readyToLaunch:Boolean = false;
		private var _mouseUp:Boolean = false;
		private var _goingUp:Boolean = true;
		private var _currentPower:Number = _minimum;
		private var _bar:RedBar;
		private var _cannon:Cannon;
		private var _cannonAngle:Number = 0;
		private var addition:Number = (barHeight / ((_maximum - _minimum) / _rateOfChange)) - (barHeight / _rateOfChange);
		public function PowerMeter()
		{
			
		}
		public function PowerMeterStart(bar:RedBar, cannon:Cannon):void
		{
			_bar = bar;
			_bar.y = 200;
			_cannon = cannon;
			Main.stage.addEventListener(MouseEvent.MOUSE_DOWN, StartCannon);
		}
		
		private function StartCannon(e:Event):void 
		{
			addEventListener(Event.ENTER_FRAME, LoopCannon);
		}
		
		private function StartPowerMeter(e:Event):void 
		{
			removeEventListener(Event.ENTER_FRAME, EndLoop);
			removeEventListener(Event.ENTER_FRAME, LoopCannon);
			Main.stage.removeEventListener(MouseEvent.MOUSE_DOWN, StartCannon);
			_mouseUp = false;
			_goingUp = true;
			addEventListener(Event.ENTER_FRAME, LoopPower);
		}
		
		private function LoopPower(e:Event) {
			if (_readyToLaunch==false)
			{
			Main.stage.addEventListener(MouseEvent.MOUSE_UP, EndLoopPower);
			if (_mouseUp)
			{
				removeEventListener(Event.ENTER_FRAME, EndLoop);
				removeEventListener(Event.ENTER_FRAME, LoopPower);
			}
			else
			{
				if (_goingUp)
				{
					if (_currentPower < _maximum)
					{
						_currentPower = _currentPower + _rateOfChange;
						_bar.y = _bar.y - (barHeight / _rateOfChange) - addition;
					}
					else
					{
						_goingUp = false;
					}
				}
				else
				{
					if (_currentPower > _minimum)
					{
						_currentPower = _currentPower - _rateOfChange;
						_bar.y = _bar.y + (barHeight / _rateOfChange) + addition;
					}
					else
					{
						_goingUp = true;
						trace(_bar.y);
					}
				}
			}
			}
		}
		
		private function LoopCannon(e:Event)
		{
			
			Main.stage.addEventListener(MouseEvent.MOUSE_UP, EndLoop);
			if (_mouseUp)
			{
				Main.stage.addEventListener(MouseEvent.MOUSE_DOWN, StartPowerMeter);
			}
			else
			{
					if (_cannonAngle > -90 && _goingUp) //move up
					{
						_cannonAngle -= 5;
						_cannon.rotation = _cannonAngle;
						trace("up" + _cannonAngle);
					}
					else //move down
					{
							_cannonAngle += 5;
							_cannon.rotation = _cannonAngle;
							trace("down" + _cannonAngle);
							if (_cannonAngle > -90 && _cannonAngle < 0) {
								_goingUp = false;
							} else {
								_goingUp = true;
							}
					}
			}
		}
		private function EndLoop(e:MouseEvent):void 
		{
			_mouseUp = true;
		}
		private function EndLoopPower(e:MouseEvent):void 
		{
			_mouseUp = true;
			_readyToLaunch = true;
		}
		public function get readyToLaunch():Boolean
		{
			return _readyToLaunch;
		}
		public function get currentPower():Number 
		{
			return _currentPower;
		}
		
		public function get cannonAngle():Number 
		{
			return _cannonAngle;
		}
	}

}