package record
{
	import game_four_time.GameCom_four_time;
	

	public class RecordData
	{
		public var hasTutorial:Boolean = false;
		public var bestScore:int = 0;
		public var musicOn:Boolean = true;
		
		public var time:Number = 0;
		public var timeLong:Number = GameCom_four_time.OTIMELONG;
		public var score:int = 0;
		public var data:Vector.<int>;
		
		public function RecordData()
		{
		}
	}
}