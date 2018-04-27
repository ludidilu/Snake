package
{
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import game_four_time.GameTutorial_four_time;
	import game_four_time.Game_four_time;
	
	import publicTools.TimeUtil;
	
	import record.Record;
	
	import resource.Resource;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	[SWF(frameRate="60")]
	public class Snake extends flash.display.Sprite
	{
		private static var initNum:int = 2;
		
		public static var deactiveCallBack:Function;
		public static var activeCallBack:Function;
		
		public function Snake()
		{
			super();
			
			stage.addEventListener(KeyboardEvent.KEY_UP,test);
			
			stage.quality = StageQuality.LOW;
			
			addEventListener(flash.events.Event.ADDED_TO_STAGE,initStarling);
			
			addEventListener(flash.events.Event.ENTER_FRAME,updateFrame);
			
			addEventListener(flash.events.Event.DEACTIVATE,deactive);
			
			addEventListener(flash.events.Event.ACTIVATE,active);
		}
		
		private function initStarling(e:flash.events.Event):void{
			
			var myStarling:Starling = new Starling(starling.display.Sprite,stage,new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight),null,"auto","baseline");
			
			myStarling.addEventListener(starling.events.Event.CONTEXT3D_CREATE,starlingInitOK);
		}
		
		private function starlingInitOK(e:starling.events.Event):void{
			
			Starling.current.start();
			
			Record.readRecord();
			
			Resource.init(gameStart);
		}
		
		private function gameStart():void{
			
			if(Record.data.hasTutorial){
				
				Game_four_time.start(Record.data.data,Record.data.score,Record.data.time,Record.data.timeLong);
				
			}else{
			
				GameTutorial_four_time.start();
			}
			
			Starling.current.stage.addChild(Game_four_time.container);
		}
		
		private function deactive(e:flash.events.Event):void{
			
			if(deactiveCallBack){
				
				deactiveCallBack();
			}
		}
		
		private function active(e:flash.events.Event):void{
			
			if(activeCallBack){
				
				activeCallBack();
			}
		}
		
		private function updateFrame(e:flash.events.Event):void{
			
			TimeUtil.tick();
		}
		
		private function test(e:KeyboardEvent):void{
			
			if(e.keyCode == 109){
				
				Starling.current.drawToBitmapDataCallBack = getBitmapData;
			}
		}
		
		private function getBitmapData(_bitmapData:BitmapData):void{
			
			var byteArray:ByteArray = new ByteArray;
			
			_bitmapData.encode(_bitmapData.rect,new PNGEncoderOptions,byteArray);
			
			var file:File = new File("e:/icon" + _bitmapData.width + "_" + _bitmapData.height + ".png");
			
			var fs:FileStream = new FileStream;
			
			fs.open(file,FileMode.WRITE);
			
			fs.writeBytes(byteArray);
			
			fs.close();
		}
	}
}