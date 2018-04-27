package publicTools
{
	import com.greensock.TweenLite;
	
	import flash.utils.getTimer;

	public class TimeUtil
	{
		public static var speed:Number = 1;
		
		private static var lastTickTime:int;
		
		private static var nowTickTime:int;
		
		private static var lastTime:int;
		
		private static var nowTime:int;
		
		public function TimeUtil()
		{
		}
		
		public static function init():void{
			
			TweenLite.getTimerFun = gameGetTimer;
		}
		
		private static function gameGetTimer():int{
			
			return nowTime;
		}
		
		public static function tick():void{
			
			nowTickTime = getTimer();
			
			nowTime = lastTime + (nowTickTime - lastTickTime) * speed;
			
			lastTickTime = nowTickTime;
			
			lastTime = nowTime;
		}
	}
}