package game_round
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class GameScore_round
	{
		private static const PATH:String = "/snake/score_round.snk";
		
		private static var file:File;
		
		private static var fileStream:FileStream;
		
		public function GameScore_round()
		{
		}
		
		public static function init():int{
			
			file = new File;
			
			file.nativePath = File.documentsDirectory.nativePath + PATH;
			
			fileStream = new FileStream;
			
			if(file.exists){
			
				fileStream.open(file,FileMode.READ);
				
				var highScore:int = fileStream.readInt();
				
				fileStream.close();
				
				return highScore;
				
			}else{
				
				fileStream.open(file,FileMode.WRITE);
				
				fileStream.writeInt(GameCom_round.OSCORE);
				
				fileStream.close();
				
				return 0;
			}
		}
		
		public static function writeBestScore(_score:int):void{
			
			fileStream.open(file,FileMode.WRITE);
			
			fileStream.writeInt(_score);
			
			fileStream.close();
		}
	}
}