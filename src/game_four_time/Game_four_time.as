package game_four_time
{
	import com.greensock.TweenLite;
	import com.greensock.easing.ElasticIn;
	import com.greensock.easing.ElasticOut;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quint;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import publicTools.TextButton;
	import publicTools.TimeUtil;
	
	import record.Record;
	
	import resource.Resource;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class Game_four_time
	{
		private static var state:int = 0;//0正常游戏中  1结束画面  2暂停画面
		
		private static var initOK:Boolean;
		
		private static var gameSpeed:Number = 1;
		
		public static var container:Sprite;
		
		private static var bgContainer:Sprite;
		
		public static var mapContainer:Sprite;
		
		public static var textFieldContainer:Sprite;
		
		private static var gameOverContainer:Sprite;
		
		private static var maskContainer:Sprite;
		
		private static var finalScoreTf:TextField;
		
		private static var timerContainer:Sprite;
		
		private static var timeLong:Number;
		
		private static var frameTexture:Texture;
		
		public static var imgVec:Vector.<Image>;
		
		private static var quadBatch:QuadBatch;
		
		private static var frameImgVec:Vector.<Image>;
		
		private static var frameQb:QuadBatch;
		
		public static var touchSp:Sprite;
		
		private static var dataReal:Vector.<int>;
		
		private static var data:Vector.<int>;
		
		private static var chooseVec:Vector.<int>;
		
		private static var resultVec:Vector.<int>;
		
		private static var lastTouchPoint:Point;
		
		private static var scoreTf:TextField;
		
		private static var bestScoreTf:TextField;
		
		private static var ball:Sprite;
		
		private static var light:Sprite;
		
		public static var resumeBt:TextButton;
		
		public static var restartBt:TextButton;
		
		public static var soundBt:TextButton
		
		public static var tutorialCallBack:Function;
		
		private static var initOKCallBack:Function;
		
		private static var _canAction:Boolean;
		
		public static function get canAction():Boolean
		{
			return _canAction;
		}
		
		public static function set canAction(value:Boolean):void
		{
			if(_canAction == value){
				
				return;
			}
			
			if(value){
				
				touchSp.addEventListener(TouchEvent.TOUCH,beTouch);
				
			}else{
				
				touchSp.removeEventListener(TouchEvent.TOUCH,beTouch);
			}
			
			_canAction = value;
		}
		
		private static var scoreReal:int;
		private static var _score:int = int.MIN_VALUE;
		
		public static function get score():int
		{
			return _score;
		}
		
		public static function set score(value:int):void
		{
			if(_score == value){
				
				return;
			}
			
			_score = value;
			
			textFieldContainer.unflatten();
			
			if(value > bestScore){
				
				bestScore = value;
			}
			
//			scoreTf.text = "Score\n" + _score;
			
			scoreTf.text = GameText_four_time.SCORE[GameText_four_time.nowLanguageIndex] + _score;
			
			textFieldContainer.flatten();
		}
		
		private static var bestScoreReal:int;
		private static var _bestScore:int = int.MIN_VALUE;
		
		public static function get bestScore():int
		{
			return _bestScore;
		}
		
		public static function set bestScore(value:int):void
		{
			if(_bestScore == value){
				
				return;
			}
			
			_bestScore = value;
			
//			bestScoreTf.text = "Best\n" + _bestScore;
			
			bestScoreTf.text = GameText_four_time.BEST[GameText_four_time.nowLanguageIndex] + _bestScore;
		}
		
		private static var timerNumReal:Number;
		private static var _timerNum:Number;
		
		public static function get timerNum():Number{
			
			return _timerNum;
		}
		
		public static function set timerNum(value:Number):void{
			
			if(_timerNum == value){
				
				return;
			}
			
			light.x = ball.x = GameCom_four_time.TIMER_BALL_HEIGHT * GameCom_four_time.SCALE * 0.5 + (GameCom_four_time.ALL_WIDTH - GameCom_four_time.TIMER_BALL_HEIGHT * GameCom_four_time.SCALE) * value;
			
			ball.rotation = (GameCom_four_time.ALL_WIDTH - GameCom_four_time.TIMER_BALL_HEIGHT * GameCom_four_time.SCALE) * value / (GameCom_four_time.TIMER_BALL_HEIGHT * GameCom_four_time.SCALE * 0.5);
			
			timerNumReal = _timerNum = value;
		}
		
		//临时变量
		private static var i:int,m:int;
		
		private static var matrix:Matrix = new Matrix;
		
		private static var tmpIntVec:Vector.<int> = new Vector.<int>;
		
		
		public static function start(_data:Vector.<int> = null,_score:int = 0,_time:Number = 0,_timeLong:Number = GameCom_four_time.OTIMELONG,_initOKCallBack:Function = null):void{
			
			state = 0;
			
			initOKCallBack = _initOKCallBack;
			
			if(!initOK){
			
				init();
			}
			
			Snake.deactiveCallBack = deactive;
			
			Snake.activeCallBack = null;
			
			bestScoreReal = bestScore = Record.data.bestScore;
			
			scoreReal = score = _score;
			
			timeLong = _timeLong;
			
			timerNum = _time;
			
			trace("Game start  timerNum:",timerNum,"    timeLong:",timeLong);
			
			if(!_data){
			
				for(i = 0 ; i < GameCom_four_time.HEIGHT * GameCom_four_time.WIDTH ; i++){
					
					data[i] = 0;
				}
				
				for(i = 0 ; i < GameCom_four_time.HEIGHT * GameCom_four_time.WIDTH ; i++){
					
					var colorIndex:int = GameCom_four_time.getRandomColorIndex(data,i);
					
					dataReal[i] = data[i] = colorIndex;
				}
				
			}else{
				
				data = _data;
				
				dataReal = data.concat();
			}
			
			TweenLite.killTweensOf(Game_four_time);
			
			resultVec.length = 0;
			
			chooseVec.length = 0;
			
			addFrame();
			
			quadBatchReset();
			
			textFieldContainer.x = -GameCom_four_time.ALL_WIDTH;
			timerContainer.x = -GameCom_four_time.ALL_WIDTH;
			mapContainer.x = -GameCom_four_time.ALL_WIDTH;
			
			if(!initOK){
				
				initOK = true;
				
				TweenLite.delayedCall(1,showMap);
				
			}else{
				
				showMap();
			}
		}
		
		private static function showMap():void{
			
			TweenLite.to(mapContainer,1,{x:0,onComplete:startGame});
			TweenLite.to(textFieldContainer,1,{x:0,onComplete:startGame});
			TweenLite.to(timerContainer,1,{x:0,onComplete:startGame});
		}
		
		private static function startGame():void{
			
			canAction = true;
			
			startTimer(false);
			
			if(initOKCallBack){
				
				initOKCallBack();
			}
		}
		
		private static function quadBatchReset():void{
			
			quadBatch.reset();
			
			for(i = 0 ; i < GameCom_four_time.WIDTH * GameCom_four_time.HEIGHT ; i++){
				
				if(data[i] < GameCom_four_time.COLOR_SCORE_FIX){
					
					imgVec[i].texture = Resource.textureAtlas.getTexture(String(data[i]));
					
				}else{
				
					var color:int = data[i] % GameCom_four_time.COLOR_SCORE_FIX;
					
					imgVec[i].texture = Resource.textureAtlas.getTexture("z" + data[i] % GameCom_four_time.COLOR_SCORE_FIX + int(data[i] / GameCom_four_time.COLOR_SCORE_FIX));
				}
					
				quadBatch.addImage(imgVec[i]);
			}
			
//			_disappearNum = 1;
		}
		
		private static function init():void{
			
//			if(initOK){
//				
//				return ;
//			}
//			
//			initOK = true;
			
			GameCom_four_time.init();
			
			TimeUtil.init();
			
			initFrameTexture();
			
			data = new Vector.<int>(GameCom_four_time.WIDTH * GameCom_four_time.HEIGHT ,true);
			
			dataReal = new Vector.<int>(GameCom_four_time.WIDTH * GameCom_four_time.HEIGHT ,true);
			
			chooseVec = new Vector.<int>;
			
			resultVec = new Vector.<int>;
			
			
			container = new Sprite;
			
			
			initBgContainer();
			
			initMapContainer();
			
			initTextFieldContainer();
			
			initTimerContainer();
			
			initGameOverContainer();
			
			initMaskContainer();
			
			
			container.addChild(bgContainer);
			
			textFieldContainer.y = GameCom_four_time.SCORE_CONTAINER_Y * GameCom_four_time.SCALE;
			
			container.addChild(textFieldContainer);
			
			if((Starling.current.viewPort.height - GameCom_four_time.ALL_WIDTH) * 0.5 - (GameCom_four_time.SCORE_CONTAINER_Y + GameCom_four_time.SCORE_CONTAINER_HEIGHT) * GameCom_four_time.SCALE > GameCom_four_time.TIMER_HEIGHT * GameCom_four_time.SCALE){
			
				timerContainer.y = (GameCom_four_time.SCORE_CONTAINER_Y + GameCom_four_time.SCORE_CONTAINER_HEIGHT) * GameCom_four_time.SCALE + ((Starling.current.viewPort.height - GameCom_four_time.ALL_WIDTH) * 0.5 - (GameCom_four_time.SCORE_CONTAINER_Y + GameCom_four_time.SCORE_CONTAINER_HEIGHT) * GameCom_four_time.SCALE - GameCom_four_time.TIMER_HEIGHT * GameCom_four_time.SCALE) * 0.5;
				
				mapContainer.y = (Starling.current.viewPort.height - GameCom_four_time.ALL_WIDTH) * 0.5;
				
			}else{
				
				timerContainer.y = (GameCom_four_time.SCORE_CONTAINER_Y + GameCom_four_time.SCORE_CONTAINER_HEIGHT) * GameCom_four_time.SCALE;
				
				mapContainer.y = timerContainer.y + GameCom_four_time.SCALE * GameCom_four_time.TIMER_HEIGHT;
			}
			
			container.addChild(timerContainer);
			
			container.addChild(mapContainer);
			
			container.addChild(gameOverContainer);
			
			container.addChild(maskContainer);
			
			
			
			var quad:Quad = new Quad(Starling.current.viewPort.width,Starling.current.viewPort.height,0xFF0000);
			
			quad.touchable = false;
			
			var testBt:Button = new Button(Texture.fromColor(50,50,0xFF000000));
			
//			container.addChild(testBt);
			
			testBt.addEventListener(Event.TRIGGERED,test);
			
			//----
		}
		
		private static function initTimerContainer():void{
			
			timerContainer = new Sprite;
			
			timerContainer.touchable = false;
			
//			timerContainer.y = scoreTf.y + scoreTf.height + ((Starling.current.viewPort.height - GameCom_four_time.ALL_WIDTH) * 0.5 - scoreTf.y - scoreTf.height - GameCom_four_time.TIMER_HEIGHT * GameCom_four_time.SCALE) * 0.5;
			
			ball = new Sprite;
			
			var img:Image = new Image(Resource.textureAtlas.getTexture("ball"));
			
			img.width = img.height = GameCom_four_time.TIMER_BALL_HEIGHT * GameCom_four_time.SCALE;
			
			img.x = img.y = -0.5 * img.width;
			
			ball.addChild(img);
			
			ball.x = 0.5 * img.width;
			
			ball.y = 0.5 * img.width + (GameCom_four_time.TIMER_HEIGHT - GameCom_four_time.TIMER_BALL_HEIGHT) * 0.5 * GameCom_four_time.SCALE;
			
			ball.flatten();
			
			timerContainer.addChild(ball);
			
			
			light = new Sprite;
			
			img = new Image(Resource.textureAtlas.getTexture("light"));
			
			img.width = img.height = GameCom_four_time.TIMER_BALL_HEIGHT * GameCom_four_time.SCALE;
			
			img.x = img.y = -0.5 * img.width;
			
			light.addChild(img);
			
			light.x = 0.5 * img.width;
			
			light.y = 0.5 * img.width + (GameCom_four_time.TIMER_HEIGHT - GameCom_four_time.TIMER_BALL_HEIGHT) * 0.5 * GameCom_four_time.SCALE;
			
			light.flatten();
			
			timerContainer.addChild(light);
		}
		
		private static function initTextFieldContainer():void{
			
			textFieldContainer = new Sprite;
			
			textFieldContainer.name = "textFieldContainer";
			
//			scoreTf = new TextField(GameCom_four_time.ALL_WIDTH / 2,GameCom_four_time.SCORE_CONTAINER_HEIGHT * GameCom_four_time.SCALE,"",Resource.FONT_NAME,GameCom_four_time.O_FONT_SIZE * GameCom_four_time.SCALE,GameCom_four_time.FONT_COLOR,true);
			
			scoreTf = new TextField(GameCom_four_time.ALL_WIDTH / 2,GameCom_four_time.SCORE_CONTAINER_HEIGHT * GameCom_four_time.SCALE,"",GameText_four_time.FONT_NAME[GameText_four_time.nowLanguageIndex],GameCom_four_time.O_FONT_SIZE * GameCom_four_time.SCALE,GameCom_four_time.FONT_COLOR,true);
			
//			scoreTf.y = GameCom_four_time.SCORE_CONTAINER_Y * GameCom_four_time.SCALE;
			
			textFieldContainer.addChild(scoreTf);
			
//			bestScoreTf = new TextField(GameCom_four_time.ALL_WIDTH / 2,GameCom_four_time.SCORE_CONTAINER_HEIGHT * GameCom_four_time.SCALE,"",Resource.FONT_NAME,GameCom_four_time.O_FONT_SIZE * GameCom_four_time.SCALE,GameCom_four_time.FONT_COLOR,true);
			
			bestScoreTf = new TextField(GameCom_four_time.ALL_WIDTH / 2,GameCom_four_time.SCORE_CONTAINER_HEIGHT * GameCom_four_time.SCALE,"",GameText_four_time.FONT_NAME[GameText_four_time.nowLanguageIndex],GameCom_four_time.O_FONT_SIZE * GameCom_four_time.SCALE,GameCom_four_time.FONT_COLOR,true);
			
			bestScoreTf.x = GameCom_four_time.ALL_WIDTH * 0.5;
			
//			bestScoreTf.y = GameCom_four_time.SCORE_CONTAINER_Y * GameCom_four_time.SCALE;
			
			textFieldContainer.addChild(bestScoreTf);
			
			textFieldContainer.addEventListener(TouchEvent.TOUCH,textFieldContainerTouch);
		}
		
		private static function initMapContainer():void{
			
			mapContainer = new Sprite;
			
			mapContainer.y = (Starling.current.viewPort.height - GameCom_four_time.MAP_WIDTH * GameCom_four_time.WIDTH) * 0.5;
			
			var bg:QuadBatch = new QuadBatch;
			
			bg.touchable = false;
			
			mapContainer.addChild(bg);
			
			touchSp = new Sprite;
			
			touchSp.name = "touchSp";
			
			var quad:Quad = new Quad(GameCom_four_time.WIDTH * GameCom_four_time.MAP_WIDTH,GameCom_four_time.HEIGHT * GameCom_four_time.MAP_WIDTH,0);
			
			quad.alpha = 0;
			
			touchSp.addChild(quad);
			
			touchSp.flatten();
			
			mapContainer.addChild(touchSp);
			
			frameQb = new QuadBatch;
			
			frameQb.name = "frameQb";
			
			frameQb.touchable = false;
			
			mapContainer.addChild(frameQb);
			
			quadBatch = new QuadBatch;
			
			quadBatch.name = "quadBatch";
			
			frameImgVec = new Vector.<Image>(GameCom_four_time.WIDTH * GameCom_four_time.HEIGHT,true);
			imgVec = new Vector.<Image>(GameCom_four_time.WIDTH * GameCom_four_time.HEIGHT,true);
			
			for(i = 0 ; i < GameCom_four_time.HEIGHT ; i++){
				
				for(m = 0 ; m < GameCom_four_time.WIDTH ; m++){
					
					var img:Image = new Image(Resource.textureAtlas.getTexture("1"));
					
					img.width = img.height = GameCom_four_time.BALL_WIDTH;
					
					img.x = m * GameCom_four_time.MAP_WIDTH + (GameCom_four_time.MAP_WIDTH - img.width) * 0.5;
					img.y = i * GameCom_four_time.MAP_WIDTH + (GameCom_four_time.MAP_WIDTH - img.height) * 0.5;
					
					quadBatch.addImage(img);
					
					imgVec[i * GameCom_four_time.WIDTH + m] = img;
					
					img = new Image(frameTexture);
					
					img.width = img.height = GameCom_four_time.MAP_WIDTH;
					
					img.x = m * GameCom_four_time.MAP_WIDTH;
					img.y = i * GameCom_four_time.MAP_WIDTH;
					
					frameImgVec[i * GameCom_four_time.WIDTH + m] = img;
					
					img = new Image(Resource.textureAtlas.getTexture("mapBg"));
					
					img.width = img.height = GameCom_four_time.MAP_WIDTH;
					
					img.x = m * GameCom_four_time.MAP_WIDTH;
					img.y = i * GameCom_four_time.MAP_WIDTH;
					
					bg.addImage(img);
				}
			}
			
			quadBatch.touchable = false;
			
			mapContainer.addChild(quadBatch);
		}
		
		private static function initBgContainer():void{
			
			bgContainer = new Sprite;
			
			var img:Image = new Image(Resource.textureAtlas.getTexture("bg"));
			
			img.width = Starling.current.viewPort.width;
			img.height = Starling.current.viewPort.height;
			
			bgContainer.blendMode = BlendMode.NONE;
			
			bgContainer.touchable = false;
			
			bgContainer.addChild(img);
			
			bgContainer.flatten();
		}
		
		private static function initMaskContainer():void{
			
			maskContainer = new Sprite;
			
			maskContainer.visible = false;
			
			var sp:Sprite = new Sprite;
			
			var quad:Quad = new Quad(Starling.current.viewPort.width,Starling.current.viewPort.height,0);
			
			sp.addChild(quad);
			
			sp.touchable = false;
			sp.blendMode = BlendMode.NONE;
			
			sp.flatten();
			
			maskContainer.addChild(sp);
			
//			resumeBt = new TextButton("Resume",resumeGame);
			
			resumeBt = new TextButton(GameText_four_time.RESUMBT[GameText_four_time.nowLanguageIndex],resumeGame);
			
			resumeBt.x = (GameCom_four_time.ALL_WIDTH - resumeBt.width) * 0.5;
			
			resumeBt.y = (Starling.current.viewPort.height - 100 * GameCom_four_time.SCALE - resumeBt.height * 7) * 0.5;
			
			maskContainer.addChild(resumeBt);
			
//			restartBt = new TextButton("Restart",restartGame);
			
			restartBt = new TextButton(GameText_four_time.RESTART_BT[GameText_four_time.nowLanguageIndex],restartGame);
			
			restartBt.x = (GameCom_four_time.ALL_WIDTH - restartBt.width) * 0.5;
			
			restartBt.y = resumeBt.y + restartBt.height * 2;
			
			maskContainer.addChild(restartBt);
			
//			var tutorialBt:TextButton = new TextButton("Tutorial",showTutorial);
			
			var tutorialBt:TextButton = new TextButton(GameText_four_time.TUTORIAL_BT[GameText_four_time.nowLanguageIndex],showTutorial);
			
			tutorialBt.x = (GameCom_four_time.ALL_WIDTH - tutorialBt.width) * 0.5;
			
			tutorialBt.y = restartBt.y + tutorialBt.height * 2;
			
			maskContainer.addChild(tutorialBt);
			
			if(Record.data.musicOn){
				
//				var str:String = "Sound ON";
				
				var str:String = GameText_four_time.SOUND_ON[GameText_four_time.nowLanguageIndex];
				
			}else{
				
//				str = "Sound OFF";
				
				str = GameText_four_time.SOUND_OFF[GameText_four_time.nowLanguageIndex];
			}
			
			soundBt = new TextButton(str,soundClick);
			
			soundBt.x = (GameCom_four_time.ALL_WIDTH - soundBt.width) * 0.5;
			
			soundBt.y = tutorialBt.y + soundBt.height * 2;
			
			maskContainer.addChild(soundBt);
		}
		
		private static function initGameOverContainer():void{
			
			gameOverContainer = new Sprite;
			
			gameOverContainer.visible = false;
			
			var quad:starling.display.Quad = new starling.display.Quad(Starling.current.viewPort.width,Starling.current.viewPort.height,0);
			
			quad.alpha = 0.7;
			
			gameOverContainer.addChild(quad);
			
//			finalScoreTf = new TextField(Starling.current.viewPort.width,Starling.current.viewPort.height,"",Resource.FONT_NAME,GameCom_four_time.SCALE * 80,0xFFFF00,true);
			
			finalScoreTf = new TextField(Starling.current.viewPort.width,Starling.current.viewPort.height,"",GameText_four_time.FONT_NAME[GameText_four_time.nowLanguageIndex],GameCom_four_time.SCALE * 80,0xFFFF00,true);
			
			gameOverContainer.addChild(finalScoreTf);
			
			gameOverContainer.flatten();
			
			gameOverContainer.addEventListener(TouchEvent.TOUCH,restartContainerTouch);
		}
		
		private static function initFrameTexture():void{
			
			var bitmapData:BitmapData = new BitmapData(GameCom_four_time.MAP_WIDTH * 4,GameCom_four_time.MAP_WIDTH,true,0x00000000);
			
			var shape:Shape = new Shape;
			
			shape.graphics.beginFill(0);
			
			shape.graphics.drawRect((GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25,(GameCom_four_time.MAP_WIDTH + GameCom_four_time.FRAME_WIDTH) * 0.5,(GameCom_four_time.MAP_WIDTH + GameCom_four_time.FRAME_WIDTH) * 0.5);
			
			shape.graphics.drawRect((GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.5,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.5,GameCom_four_time.FRAME_WIDTH,GameCom_four_time.FRAME_WIDTH);
			
			bitmapData.draw(shape);
			
			//----
			
			shape.graphics.clear();
			
			shape.graphics.beginFill(0);
			
			shape.graphics.drawRect(0,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25,GameCom_four_time.MAP_WIDTH,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25);
			
			shape.graphics.drawRect(0,(GameCom_four_time.MAP_WIDTH + GameCom_four_time.FRAME_WIDTH) * 0.5,GameCom_four_time.MAP_WIDTH,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25);
			
			matrix.identity();
			
			matrix.translate(GameCom_four_time.MAP_WIDTH,0);
			
			bitmapData.draw(shape,matrix);
			
			//----
			
			shape.graphics.clear();
			
			shape.graphics.beginFill(0);
			
			shape.graphics.drawRect(0,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.5,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25);
			
			shape.graphics.drawRect((GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25,0,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25);
			
			shape.graphics.drawRect(0,(GameCom_four_time.MAP_WIDTH + GameCom_four_time.FRAME_WIDTH) * 0.5,GameCom_four_time.MAP_WIDTH - (GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25);
			
			shape.graphics.drawRect((GameCom_four_time.MAP_WIDTH + GameCom_four_time.FRAME_WIDTH) * 0.5,0,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25,(GameCom_four_time.MAP_WIDTH + GameCom_four_time.FRAME_WIDTH) * 0.5);
			
			matrix.translate(GameCom_four_time.MAP_WIDTH,0);
			
			bitmapData.draw(shape,matrix);
			
			//----
			
			shape.graphics.clear();
			
			shape.graphics.beginFill(0);
			
			shape.graphics.drawRect(0,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25,(GameCom_four_time.MAP_WIDTH + GameCom_four_time.FRAME_WIDTH) * 0.5,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25);
			
			shape.graphics.drawRect((GameCom_four_time.MAP_WIDTH + GameCom_four_time.FRAME_WIDTH) * 0.5,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25,(GameCom_four_time.MAP_WIDTH + GameCom_four_time.FRAME_WIDTH) * 0.5);
			
			shape.graphics.drawRect(0,(GameCom_four_time.MAP_WIDTH + GameCom_four_time.FRAME_WIDTH) * 0.5,(GameCom_four_time.MAP_WIDTH + GameCom_four_time.FRAME_WIDTH) * 0.5,(GameCom_four_time.MAP_WIDTH - GameCom_four_time.FRAME_WIDTH) * 0.25);
			
			matrix.translate(GameCom_four_time.MAP_WIDTH,0);
			
			bitmapData.draw(shape,matrix);
			
			//----
			
			frameTexture = Texture.fromBitmapData(bitmapData,false);
		}
		
		private static function beTouch(e:TouchEvent):void{
			
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			
			if(touch){
				
				if(touch.phase == TouchPhase.BEGAN){
					
					Resource.playSound(0,150);
					
					var p:Point = touch.getLocation(e.currentTarget as DisplayObject);
					
					var index:int = int(p.x / GameCom_four_time.MAP_WIDTH) + int(p.y /  GameCom_four_time.MAP_WIDTH) * GameCom_four_time.WIDTH;
					
					chooseVec.push(index);
					
					addFrame();
					
					lastTouchPoint = p;
					
				}else if(touch.phase == TouchPhase.MOVED && chooseVec.length > 0){
					
					p = touch.getLocation(e.currentTarget as DisplayObject);
					
					if(p.x >= (e.currentTarget as DisplayObject).width || p.y >= (e.currentTarget as DisplayObject).height || p.x <= 0 || p.y <= 0){
						
//						chooseVec.length = 0
//						
//						addFrame();
						
						return;
					}
					
					index = int(p.x / GameCom_four_time.MAP_WIDTH) + int(p.y /  GameCom_four_time.MAP_WIDTH) * GameCom_four_time.WIDTH;
					
					if(chooseVec[chooseVec.length - 1] == index){
						
						return;
						
					}else{
						
						Resource.playSound(0,150);
						
						var x1:int = index % GameCom_four_time.WIDTH;
						var y1:int = int(index / GameCom_four_time.WIDTH);
						
						while(true){
							
							var lastIndex:int = chooseVec[chooseVec.length - 1];
							
							var x0:int = lastIndex % GameCom_four_time.WIDTH;
							var y0:int = int(lastIndex / GameCom_four_time.WIDTH);
							
							if((x0 == x1 && Math.abs(y0 - y1) == 1) || (Math.abs(x0 - x1) == 1 && y0 == y1)){
								
								break;
								
							}else if(x0 == x1){
								
								if(y1 < y0){
									
									var nextIndex:int = lastIndex - GameCom_four_time.WIDTH;
									
								}else{
									
									nextIndex = lastIndex + GameCom_four_time.WIDTH;
								}
								
							}else if(y0 == y1){
								
								if(x1 < x0){
									
									nextIndex = lastIndex - 1;
									
								}else{
									
									nextIndex = lastIndex + 1;
								}
								
							}else{
								
								if(x1 < x0){
									
									var fix0:int = lastIndex - 1;
									
								}else{
									
									fix0 = lastIndex + 1;
								}
								
								if(y1 < y0){
									
									var fix1:int = lastIndex - GameCom_four_time.WIDTH;
									
								}else{
									
									fix1 = lastIndex + GameCom_four_time.WIDTH;
								}
								
								var x2:int = fix0 % GameCom_four_time.WIDTH;
								var y2:int = int(fix0 / GameCom_four_time.WIDTH);
								
								var p0:Point = new Point;
								
								p0.x = (x2 - 0.5) * GameCom_four_time.MAP_WIDTH;
								p0.y = (y2 - 0.5) * GameCom_four_time.MAP_WIDTH;
								
								var x3:int = fix1 % GameCom_four_time.WIDTH;
								var y3:int = int(fix1 / GameCom_four_time.WIDTH);
								
								var p1:Point = new Point;
								
								p1.x = (x3 - 0.5) * GameCom_four_time.MAP_WIDTH;
								p1.y = (y3 - 0.5) * GameCom_four_time.MAP_WIDTH;
								
								var a0:Number = Point.distance(p0,p);
								var b0:Number = Point.distance(p0,lastTouchPoint);
								var c0:Number = Point.distance(lastTouchPoint,p);
								
								var tp0:Number = (a0 + b0 + c0) * 0.5;
								
								var area0:Number = tp0 * (tp0 - a0) * (tp0 - b0) * (tp0 - c0);
								
								var a1:Number = Point.distance(p1,p);
								var b1:Number = Point.distance(p1,lastTouchPoint);
								var c1:Number = Point.distance(lastTouchPoint,p);
								
								var tp1:Number = (a1 + b1 + c1) * 0.5;
								
								var area1:Number = tp1 * (tp1 - a1) * (tp1 - b1) * (tp1 - c1);
								
								if(area0 < area1){
									
									nextIndex = fix0;
									
								}else{
									
									nextIndex = fix1;
								}
							}
							
							i = chooseVec.indexOf(nextIndex);
							
							if(i != -1){
								
								if(chooseVec[chooseVec.length - 2] != nextIndex){
									
									chooseVec = chooseVec.slice(i);
									
									addFrame(true);
									
									startMove();
									
									return;
									
								}else{
									
//									chooseVec.length = 0
									
									chooseVec.pop();
									
									addFrame();
									
									return;
								}
								
							}else{
								
								chooseVec.push(nextIndex);
							}
						}
					}
					
					i = chooseVec.indexOf(index);
					
					if(i != -1){
						
						if(chooseVec[chooseVec.length - 2] != index){
							
							chooseVec = chooseVec.slice(i);
							
							addFrame(true);
							
							startMove();
							
						}else{
							
							chooseVec.pop();
							
							addFrame();
						}
						
					}else{
						
						chooseVec.push(index);
						
						addFrame();
					}
					
					lastTouchPoint = p;
					
				}else if(touch.phase == TouchPhase.ENDED){
					
					chooseVec.length = 0
					
					addFrame();
				}
			}
		}
		
		private static function addFrame(_finish:Boolean = false):void{
			
			frameQb.reset();
			
			if(chooseVec.length == 0){
				
				return;
				
			}else if(chooseVec.length == 1){
				
				var img:Image = frameImgVec[chooseVec[0]];
				
				img.setTexCoordsTo(0,0,0);
				img.setTexCoordsTo(1,0.25,0);
				img.setTexCoordsTo(2,0,1);
				img.setTexCoordsTo(3,0.25,1);
				
				frameQb.addImage(img);
				
			}else{
				
				if(!_finish){
					
					img = frameImgVec[chooseVec[0]];
					
					var x0:int = chooseVec[0] % GameCom_four_time.WIDTH;
					var y0:int = int(chooseVec[0] / GameCom_four_time.WIDTH);
					
					var x1:int = chooseVec[1] % GameCom_four_time.WIDTH;
					var y1:int = int(chooseVec[1] / GameCom_four_time.WIDTH);
					
					if(x0 == x1){
						
						if(y1 > y0){
							
							img.setTexCoordsTo(0,1,0);
							img.setTexCoordsTo(1,1,1);
							img.setTexCoordsTo(2,0.75,0);
							img.setTexCoordsTo(3,0.75,1);
							
						}else{
							
							img.setTexCoordsTo(0,0.75,1);
							img.setTexCoordsTo(1,0.75,0);
							img.setTexCoordsTo(2,1,1);
							img.setTexCoordsTo(3,1,0);
						}
						
					}else{
						
						if(x1 > x0){
							
							img.setTexCoordsTo(0,1,0);
							img.setTexCoordsTo(1,0.75,0);
							img.setTexCoordsTo(2,1,1);
							img.setTexCoordsTo(3,0.75,1);
							
						}else{
							
							img.setTexCoordsTo(0,0.75,0);
							img.setTexCoordsTo(1,1,0);
							img.setTexCoordsTo(2,0.75,1);
							img.setTexCoordsTo(3,1,1);
						}
					}
					
					frameQb.addImage(img);
					
					for(i = 1 ; i < chooseVec.length - 1 ; i++){
						
						img = frameImgVec[chooseVec[i]];
						
						x0 = chooseVec[i - 1] % GameCom_four_time.WIDTH;
						y0 = int(chooseVec[i - 1] / GameCom_four_time.WIDTH);
						
						x1 = chooseVec[i] % GameCom_four_time.WIDTH;
						y1 = int(chooseVec[i] / GameCom_four_time.WIDTH);
						
						var x2:int = chooseVec[i + 1] % GameCom_four_time.WIDTH;
						var y2:int = int(chooseVec[i + 1] / GameCom_four_time.WIDTH);
						
						if(x0 == x1 && x1 == x2){
							
							img.setTexCoordsTo(0,0.25,1);
							img.setTexCoordsTo(1,0.25,0);
							img.setTexCoordsTo(2,0.5,1);
							img.setTexCoordsTo(3,0.5,0);
							
						}else if(y0 == y1 && y1 == y2){
							
							img.setTexCoordsTo(0,0.25,0);
							img.setTexCoordsTo(1,0.5,0);
							img.setTexCoordsTo(2,0.25,1);
							img.setTexCoordsTo(3,0.5,1);
							
						}else{
							
							if((x1 - x0 == 1 && y2 - y1 == -1) || (y1 - y0 == 1 && x2 - x1 == -1)){
								
								img.setTexCoordsTo(0,0.5,0);
								img.setTexCoordsTo(1,0.75,0);
								img.setTexCoordsTo(2,0.5,1);
								img.setTexCoordsTo(3,0.75,1);
								
							}else if((y1 - y0 == 1 && x2 - x1 == 1) || (x1 - x0 == -1 && y2 - y1 == -1)){
								
								img.setTexCoordsTo(0,0.5,1);
								img.setTexCoordsTo(1,0.5,0);
								img.setTexCoordsTo(2,0.75,1);
								img.setTexCoordsTo(3,0.75,0);
								
							}else if((x1 - x0 == 1 && y2 - y1 == 1) || ( y1 - y0 == -1 && x2 - x1 == -1)){
								
								img.setTexCoordsTo(0,0.75,0);
								img.setTexCoordsTo(1,0.75,1);
								img.setTexCoordsTo(2,0.5,0);
								img.setTexCoordsTo(3,0.5,1);
								
							}else{
								
								img.setTexCoordsTo(0,0.75,1);
								img.setTexCoordsTo(1,0.5,1);
								img.setTexCoordsTo(2,0.75,0);
								img.setTexCoordsTo(3,0.5,0);
							}
						}
						
						frameQb.addImage(img);
					}
					
					img = frameImgVec[chooseVec[i]];
					
					x0 = chooseVec[i - 1] % GameCom_four_time.WIDTH;
					y0 = int(chooseVec[i - 1] / GameCom_four_time.WIDTH);
					
					x1 = chooseVec[i] % GameCom_four_time.WIDTH;
					y1 = int(chooseVec[i] / GameCom_four_time.WIDTH);
					
					if(x0 == x1){
						
						if(y1 > y0){
							
							img.setTexCoordsTo(0,0.75,1);
							img.setTexCoordsTo(1,0.75,0);
							img.setTexCoordsTo(2,1,1);
							img.setTexCoordsTo(3,1,0);
							
						}else{
							
							img.setTexCoordsTo(0,1,0);
							img.setTexCoordsTo(1,1,1);
							img.setTexCoordsTo(2,0.75,0);
							img.setTexCoordsTo(3,0.75,1);
						}
						
					}else{
						
						if(x1 > x0){
							
							img.setTexCoordsTo(0,0.75,0);
							img.setTexCoordsTo(1,1,0);
							img.setTexCoordsTo(2,0.75,1);
							img.setTexCoordsTo(3,1,1);
							
						}else{
							
							img.setTexCoordsTo(0,1,0);
							img.setTexCoordsTo(1,0.75,0);
							img.setTexCoordsTo(2,1,1);
							img.setTexCoordsTo(3,0.75,1);
						}
					}
					
					frameQb.addImage(img);
					
				}else{
					
					for(i = 0 ; i < chooseVec.length ; i++){
						
						img = frameImgVec[chooseVec[i]];
						
						if(i == 0){
							
							x0 = chooseVec[chooseVec.length - 1] % GameCom_four_time.WIDTH;
							y0 = int(chooseVec[chooseVec.length - 1] / GameCom_four_time.WIDTH);
							
							x2 = chooseVec[i + 1] % GameCom_four_time.WIDTH;
							y2 = int(chooseVec[i + 1] / GameCom_four_time.WIDTH);
							
						}else if(i == chooseVec.length - 1){
							
							x0 = chooseVec[i - 1] % GameCom_four_time.WIDTH;
							y0 = int(chooseVec[i - 1] / GameCom_four_time.WIDTH);
							
							x2 = chooseVec[0] % GameCom_four_time.WIDTH;
							y2 = int(chooseVec[0] / GameCom_four_time.WIDTH);
							
						}else{
							
							x0 = chooseVec[i - 1] % GameCom_four_time.WIDTH;
							y0 = int(chooseVec[i - 1] / GameCom_four_time.WIDTH);
							
							x2 = chooseVec[i + 1] % GameCom_four_time.WIDTH;
							y2 = int(chooseVec[i + 1] / GameCom_four_time.WIDTH);
						}
						
						x1 = chooseVec[i] % GameCom_four_time.WIDTH;
						y1 = int(chooseVec[i] / GameCom_four_time.WIDTH);
						
						if(x0 == x1 && x1 == x2){
							
							img.setTexCoordsTo(0,0.25,1);
							img.setTexCoordsTo(1,0.25,0);
							img.setTexCoordsTo(2,0.5,1);
							img.setTexCoordsTo(3,0.5,0);
							
						}else if(y0 == y1 && y1 == y2){
							
							img.setTexCoordsTo(0,0.25,0);
							img.setTexCoordsTo(1,0.5,0);
							img.setTexCoordsTo(2,0.25,1);
							img.setTexCoordsTo(3,0.5,1);
							
						}else{
							
							if((x1 - x0 == 1 && y2 - y1 == -1) || (y1 - y0 == 1 && x2 - x1 == -1)){
								
								img.setTexCoordsTo(0,0.5,0);
								img.setTexCoordsTo(1,0.75,0);
								img.setTexCoordsTo(2,0.5,1);
								img.setTexCoordsTo(3,0.75,1);
								
							}else if((y1 - y0 == 1 && x2 - x1 == 1) || (x1 - x0 == -1 && y2 - y1 == -1)){
								
								img.setTexCoordsTo(0,0.5,1);
								img.setTexCoordsTo(1,0.5,0);
								img.setTexCoordsTo(2,0.75,1);
								img.setTexCoordsTo(3,0.75,0);
								
							}else if((x1 - x0 == 1 && y2 - y1 == 1) || ( y1 - y0 == -1 && x2 - x1 == -1)){
								
								img.setTexCoordsTo(0,0.75,0);
								img.setTexCoordsTo(1,0.75,1);
								img.setTexCoordsTo(2,0.5,0);
								img.setTexCoordsTo(3,0.5,1);
								
							}else{
								
								img.setTexCoordsTo(0,0.75,1);
								img.setTexCoordsTo(1,0.5,1);
								img.setTexCoordsTo(2,0.75,0);
								img.setTexCoordsTo(3,0.5,0);
							}
						}
						
						frameQb.addImage(img);
					}
				}
			}
		}
		
		public static function startMove(_force:Boolean = false):void{
			
			if(tutorialCallBack){
				
				var fun:Function = tutorialCallBack;
				
				tutorialCallBack = null;
				
				fun();
				
				return;
			}
			
			Resource.playSound(1,0,2);
			
			if(!_force){
				
				canAction = false;
			}
			
			_moveNum = 0;
			
			TweenLite.to(Game_four_time,1,{moveNum:1,onComplete:moveOver,onCompleteParams:[_force]});
		}
		
		private static function moveOver(_force:Boolean):void{
			
			tmpIntVec.length = chooseVec.length;
			
			for(i = 0 ; i < chooseVec.length ; i++){
				
				if(i == 0){
					
					tmpIntVec[i] = data[chooseVec[chooseVec.length - 1]];
					
				}else{
					
					tmpIntVec[i] = data[chooseVec[i - 1]];
				}
			}
			
			for(i = 0 ; i < chooseVec.length ; i++){
				
				data[chooseVec[i]] = tmpIntVec[i];
			}
			
			quadBatchReset();
			
			if(!_force){//正常开始移动球
				
				resultVec.length = 0;
				
				var max:int = GameCom_four_time.check(data,chooseVec,resultVec,4,3);
				
				if(max != 0){//移动成功
					
					actionSuccess(max);
					
				}else{//移动失败
					
					actionFail();
				}
				
			}else{//球逆行结束
				
				chooseVec.length = 0;
				
				addFrame();
				
				canAction = true;
			}
		}
		
		public static function actionSuccess(_max:int):void{
			
			Resource.playSound(2);
			
			stopTimer();
			
			timerNumReal = 0;
			
			if(timeLong > GameCom_four_time.MINTIMELONG){
				
				timeLong = timeLong - GameCom_four_time.TIMELONGDESC;
			}
			
			dataReal = data.concat();
			
			for(i = 0 ; i < resultVec.length ; i++){
				
				dataReal[resultVec[i]] = GameCom_four_time.getRandomColorIndex(dataReal,resultVec[i]);
			}
			
			scoreReal = scoreReal + GameCom_four_time.getScore(resultVec.length,_max);
			
			if(scoreReal > bestScoreReal){
				
				bestScoreReal = scoreReal;
				
				Record.data.bestScore = bestScoreReal;
								
//				Record.writeRecord();
			}
			
			chooseVec.length = 0;
			
			addFrame();
			
			if(tutorialCallBack){
				
				var fun:Function = tutorialCallBack;
				
				tutorialCallBack = null;
				
				fun(_max);
				
				return;
			}
			
			_disappearNum = 1;
			
			TweenLite.to(Game_four_time,1,{disappearNum:0.00001,onComplete:disappearOver,onCompleteParams:[_max],ease:ElasticIn.ease});
		}
		
		private static function scoreChange(_max:int):void{
			
			//不要删除  如果不是用scoreReal则需要开启这段代码
//			var newScore:int = score + GameCom_four_time.getScore(resultVec.length,_max);
//			
//			TweenLite.to(Game_four_time,1,{score:newScore});
			
			TweenLite.to(Game_four_time,1,{score:scoreReal});
			
			//不要删除  如果不是用bestScoreReal则需要开启这段代码
//			if(newScore > bestScore){
//				
//				Record.data.bestScore = newScore;
//				
//				Record.writeRecord();
//			}
		}
		
		public static function actionFail():void{
			
			if(tutorialCallBack){
				
				var fun:Function = tutorialCallBack;
				
				tutorialCallBack = null;
				
				fun();
				
				return;
			}
			
			chooseVec.reverse();
			
			startMove(true);
		}
		
		private static function disappearOver(_max:int):void{
			
			for(i = 0 ; i < resultVec.length ; i++){
				
				data[resultVec[i]] = GameCom_four_time.getMaxFix(_max) * GameCom_four_time.COLOR_SCORE_FIX + data[resultVec[i]];
			}
			
			quadBatchReset();
			
			TweenLite.to(Game_four_time,1,{timerNum:0});
			
			_disappearNum = 1;
			
			disappearNum = 0.00001;
			
			TweenLite.to(Game_four_time,0.5,{disappearNum:1,onComplete:showScoreOver,onCompleteParams:[_max],ease:Quint.easeOut});
		}
		
		private static function showScoreOver(_max:int):void{
			
			scoreChange(_max);
			
			TweenLite.to(Game_four_time,0.5,{disappearNum:0.00001,onComplete:scoreDisappear,ease:Quint.easeIn});
		}
		
		private static function scoreDisappear():void{
			
			//不要删除  如果不是用dataReal 则需要开启这段代码
//			for(i = 0 ; i < resultVec.length ; i++){
//				
//				data[resultVec[i]] = GameCom_four_time.getRandomColorIndex(data,resultVec[i]);
//			}
			
			data = dataReal.concat();
			
			quadBatchReset();
			
			_disappearNum = 1;
			
			disappearNum = 0.00001;
			
			TweenLite.to(Game_four_time,1,{disappearNum:1,onComplete:actionOver,ease:ElasticOut.ease});
		}
		
		private static function actionOver():void{
			
			chooseVec.length = 0;
			
			startTimer();
			
			canAction = true;
		}
		
		private static function showGameOverContainer():void{
			
			canAction = false;
			
			TweenLite.killTweensOf(Game_four_time);
			
			gameOverContainer.visible = true;
			
			gameOverContainer.unflatten();
			
//			finalScoreTf.text = "score\n\n" + score + "\n\n\nTouch To Restart\n\n\n";
			
			finalScoreTf.text = GameText_four_time.RESTART0[GameText_four_time.nowLanguageIndex] + score + GameText_four_time.RESTART1[GameText_four_time.nowLanguageIndex];
			
			gameOverContainer.flatten();
		}
		
		private static var _moveNum:Number;
		
		public static function get moveNum():Number{
			
			return _moveNum;
		}
		
		public static function set moveNum(value:Number):void{
			
			var p:Number = value - _moveNum;
			
			for(i = 0 ; i < chooseVec.length ; i++){
				
				if(i != chooseVec.length - 1){
					
					var d:int = chooseVec[i + 1] - chooseVec[i];
					
				}else{
					
					d = chooseVec[0] - chooseVec[i];
				}
				
				switch(d){
					
					case -1:
						
						var dx:Number = -p * GameCom_four_time.MAP_WIDTH;
						var dy:Number = 0;
						
						break;
					
					case 1:
						
						dx = p * GameCom_four_time.MAP_WIDTH;
						dy = 0;
						
						break;
					
					case -GameCom_four_time.WIDTH:
						
						dx = 0;
						dy = -p * GameCom_four_time.MAP_WIDTH;
						
						break;
					
					default:
						
						dx = 0;
						dy = p * GameCom_four_time.MAP_WIDTH;
				}
				
				matrix.identity();
				
				matrix.translate(dx,dy);
				
				quadBatch.transformQuad(chooseVec[i],matrix);
			}
			
			_moveNum = value;
		}
		
		private static var _disappearNum:Number = 1;
		
		public static function get disappearNum():Number{
			
			return _disappearNum;
		}
		
		public static function set disappearNum(value:Number):void{
			
			for(i = 0 ; i < resultVec.length ; i++){
				
				matrix.identity();
				
				matrix.translate(-imgVec[resultVec[i]].x - GameCom_four_time.BALL_WIDTH * 0.5,-imgVec[resultVec[i]].y - GameCom_four_time.BALL_WIDTH * 0.5);
				
				matrix.scale(value / _disappearNum,value / _disappearNum);
				
				matrix.translate(imgVec[resultVec[i]].x + GameCom_four_time.BALL_WIDTH * 0.5,imgVec[resultVec[i]].y + GameCom_four_time.BALL_WIDTH * 0.5);
				
				quadBatch.transformQuad(resultVec[i],matrix);				
			}
			
			_disappearNum = value;
		}
		
		
		
		private static function restartContainerTouch(e:TouchEvent):void{
			
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject,TouchPhase.ENDED);
			
			if(touch){
				
				gameOverContainer.visible = false;
				
				start();
			}
		}
		
		public static function startTimer(_reset:Boolean = true):void{
			
			if(_reset){
			
				timerNum = 0;
				
				var tmpTimeLong:Number = timeLong;
				
			}else{
				
				tmpTimeLong = timeLong * (1 - timerNum);
			}
			
			TweenLite.to(Game_four_time,tmpTimeLong,{timerNum:1,ease:Linear.easeNone,onComplete:timerComplete});
		}
		
		public static function stopTimer():void{
			
			TweenLite.killTweensOf(Game_four_time,false,{timerNum:0});
		}
		
		private static function timerComplete():void{
			
			state = 1;
			
			showGameOverContainer();
		}
		
		private static function resumeGame():void{
			
			showMask(false);
		}
		
		private static function restartGame():void{
			
			showMask(false);
			
			start();
		}
		
		public static function showMask(_b:Boolean):void{
			
			maskContainer.visible = _b;
			
			if(_b){
				
				state = 2;
				
				TimeUtil.speed = 0;
				
			}else{
				
				state = 0;
				
				TimeUtil.speed = gameSpeed;
			}
		}
		
		private static function deactive():void{
			
			trace("game deactive");
			
			if(initOK){
				
				if(state == 0){
				
					Record.data.time = timerNumReal;
					Record.data.data = dataReal;
					Record.data.score = scoreReal;
					Record.data.timeLong = timeLong;
					
					showMask(true);
					
				}else if(state == 1){
					
					Record.data.time = 0;
					Record.data.data = null;
					Record.data.score = 0;
					Record.data.timeLong = GameCom_four_time.OTIMELONG;
					
				}else if(state == 2){
					
					Record.data.time = timerNumReal;
					Record.data.data = dataReal;
					Record.data.score = scoreReal;
					Record.data.timeLong = timeLong;
				}
				
				Record.writeRecord();
			}
		}
		
		private static function textFieldContainerTouch(e:TouchEvent):void{
			
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject,TouchPhase.ENDED);
			
			if(touch){
				
				showMask(true);
			}
		}
		
		private static function showTutorial():void{
			
			deactive();
			
			showMask(false);
			
//			Record.data.time = timerNumReal;
//			Record.data.data = dataReal;
//			Record.data.score = scoreReal;
//			Record.data.timeLong = timeLong;
//			
//			Record.writeRecord();
			
			GameTutorial_four_time.start();
		}
		
		private static function soundClick():void{
			
			Record.data.musicOn = !Record.data.musicOn;
			
//			Record.writeRecord();
			
			if(Record.data.musicOn){
				
//				var str:String = "Sound ON";
				
				var str:String = GameText_four_time.SOUND_ON[GameText_four_time.nowLanguageIndex];
				
			}else{
				
//				str = "Sound OFF";
				
				str = GameText_four_time.SOUND_OFF[GameText_four_time.nowLanguageIndex];
			}
			
			soundBt.text = str;
		}
		
//		private static function writeRecord():void{
//			
//			Record.data.time = timerNumReal;
//			Record.data.data = dataReal;
//			Record.data.score = scoreReal;
//			Record.data.timeLong = timeLong;
//			
//			Record.writeRecord();
//		}
		
		private static function test(e:Event):void{
			
			
		}
	}
}