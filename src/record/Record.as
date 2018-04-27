package record
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.registerClassAlias;

	public class Record
	{
		public static var data:RecordData;
		
		private static const PATH:String = "/snake/score_four_time.snk";
		
		private static var file:File;
		
		private static var fileStream:FileStream;
		
		public static function readRecord():void{
			
			registerClassAlias("RecordData",RecordData);
			
			file = new File;
			
			file.nativePath = File.documentsDirectory.nativePath + PATH;
			
			fileStream = new FileStream;
			
			if(file.exists){
				
				fileStream.open(file,FileMode.READ);
				
				data = fileStream.readObject();
				
				fileStream.close();
				
			}else{
				
				fileStream.open(file,FileMode.WRITE);
				
				data = new RecordData;
				
				fileStream.writeObject(data);
				
				fileStream.close();
			}
		}
		
		public static function writeRecord():void{
			
			fileStream.open(file,FileMode.WRITE);
			
			fileStream.writeObject(data);
			
			trace("Write record  timeLong:",data.timeLong,"   timeNum:",data.time);
			
			fileStream.close();
		}
	}
}