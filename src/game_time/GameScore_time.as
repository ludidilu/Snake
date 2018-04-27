package game_time
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class GameScore_time
	{
		private static const PATH:String = "/snake/score_time.snk";
		
		private static var file:File;
		
		private static var fileStream:FileStream;
		
		public function GameScore_time()
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
				
				fileStream.writeInt(GameCom_time.OLIFE);
				
				fileStream.close();
				
				return 0;
			}
		}
		
		public static function writeHighScore(_score:int):void{
			
			fileStream.open(file,FileMode.WRITE);
			
			fileStream.writeInt(_score);
			
			fileStream.close();
		}
	}
}