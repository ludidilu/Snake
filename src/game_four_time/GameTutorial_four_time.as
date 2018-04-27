package game_four_time
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	
	import flash.geom.Point;
	
	import publicTools.TimeUtil;
	
	import record.Record;
	
	import resource.Resource;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class GameTutorial_four_time
	{
		private static const tutorialSpeed:Number = 1;
		
		private static var fingerContainer:Sprite;
		
		private static const FINGER_WIDTH:int = 120;
		
		private static const point:Point = new Point;
		
		private static const touch:Touch = new Touch(0);
		
		private static const touchEvent:TouchEvent = new TouchEvent(TouchEvent.TOUCH,Vector.<Touch>([touch]));
		
		private static var touchBegin:Boolean = false;
		
		private static var arrowQuadBatch:QuadBatch;
		
		private static var maskQuadBatch:QuadBatch;
		
		private static var gou:Sprite;
		
		private static var cha:Sprite;
		
		private static var imgFix:Number;
		
		private static const data:Vector.<int> = Vector.<int>([
			4,4,3,4,5,6,1,2,
			2,3,5,5,6,1,2,3,
			3,5,5,1,1,2,3,4,
			4,5,6,1,2,3,4,5,
			5,6,2,2,3,4,5,6,
			6,1,1,3,4,5,6,1,
			1,2,3,4,5,6,1,2,
			2,3,4,5,6,1,2,3
		]);
		
		private static const fingerMovePath0:Vector.<int> = Vector.<int>([20,19,27,35,34,42,43,44,36,28,20]);
		
		private static const area0:Vector.<int> = Vector.<int>([19,43]);
		
		private static const fingerMovePath1:Vector.<int> = Vector.<int>([49,50,58,57,49]);
		
		private static const area1:Vector.<int> = Vector.<int>([34,50]);
		
		private static const fingerMovePath2:Vector.<int> = Vector.<int>([3,2,10,9,8,16,24,32,33,34,26,18,19,11,3]);
		
		private static const area2:Vector.<int> = Vector.<int>([9,33]);
		private static const area3:Vector.<int> = Vector.<int>([0,2]);
		
		public static function start():void{
			
			Game_four_time.start(data.concat(),0,0,GameCom_four_time.OTIMELONG,startTutorial);
			
			Snake.deactiveCallBack = deactive;
			
			Snake.activeCallBack = active;
			
			TimeUtil.speed = tutorialSpeed;
		}
		
		private static function startTutorial():void{
			
			imgFix = (GameCom_four_time.MAP_WIDTH - GameCom_four_time.BALL_WIDTH) * 0.5;
			
			Game_four_time.container.touchable = false;
			
			Game_four_time.mapContainer.localToGlobal(new Point(Game_four_time.imgVec[0].x,Game_four_time.imgVec[0].y),point);
			
			fingerContainer = new Sprite;
			
			var img:Image = new Image(Resource.textureAtlas.getTexture("finger"));
			
			img.width = img.height = FINGER_WIDTH * GameCom_four_time.SCALE;
			
			img.x = point.x - 15 * GameCom_four_time.SCALE;
			img.y = point.y + 15 * GameCom_four_time.SCALE;
			
			fingerContainer.addChild(img);
			
			fingerContainer.flatten();
			
			TweenLite.delayedCall(1,startTutorial0);
		}
		
		private static function startTutorial0():void{
			
			Game_four_time.container.addChild(fingerContainer);
			
			fingerContainer.x = Game_four_time.imgVec[fingerMovePath0[0]].x;
			fingerContainer.y = Game_four_time.imgVec[fingerMovePath0[0]].y;
			
			Game_four_time.tutorialCallBack = moveFingerOver;
			
			fingerContainer.alpha = 0;
			
			touchBegin = false;
			
			TweenLite.to(fingerContainer,0.5,{alpha:1,onComplete:moveFinger,onCompleteParams:[0,fingerMovePath0]});
		}
		
		private static function moveFinger(_index:int,_vec:Vector.<int>):void{
			
			if(_index < _vec.length){
				
				TweenLite.to(fingerContainer,0.15,{x:Game_four_time.imgVec[_vec[_index]].x,y:Game_four_time.imgVec[_vec[_index]].y,ease:Linear.easeNone,onComplete:moveFinger,onCompleteParams:[_index + 1,_vec],onUpdate:moveFingerUpdateFrame});
			}
		}
		
		private static function moveFingerOver():void{
			
			Game_four_time.stopTimer();
			
			TweenLite.killTweensOf(fingerContainer);
			
			TweenLite.to(fingerContainer,0.5,{alpha:0,onComplete:fingerDisappear});
		}
		
		private static function fingerDisappear():void{
			
			Game_four_time.container.removeChild(fingerContainer);
			
			arrowQuadBatch = new QuadBatch;
			
			Game_four_time.container.addChild(arrowQuadBatch);
			
			TweenLite.delayedCall(0.5,addArrow,[0]);
		}
		
		private static function addArrow(_index:int):void{
			
			if(_index < fingerMovePath0.length - 1){
				
				var img:Image = new Image(Resource.textureAtlas.getTexture("arrow"));
				
				img.width = img.height = GameCom_four_time.MAP_WIDTH;
			
				var d:int = fingerMovePath0[_index + 1] - fingerMovePath0[_index];
				
				if(d == -1){
					
					img.rotation = Math.PI;
					
					img.x = Game_four_time.imgVec[fingerMovePath0[_index]].x + GameCom_four_time.MAP_WIDTH * 0.5;
					img.y = Game_four_time.imgVec[fingerMovePath0[_index]].y + GameCom_four_time.MAP_WIDTH;
					
				}else if(d == GameCom_four_time.WIDTH){
					
					img.rotation = Math.PI * 0.5;
					
					img.x = Game_four_time.imgVec[fingerMovePath0[_index]].x + GameCom_four_time.MAP_WIDTH;
					img.y = Game_four_time.imgVec[fingerMovePath0[_index]].y + GameCom_four_time.MAP_WIDTH * 0.5;
					
				}else if(d == -GameCom_four_time.WIDTH){
					
					img.rotation = - Math.PI * 0.5;
					
					img.x = Game_four_time.imgVec[fingerMovePath0[_index]].x;
					img.y = Game_four_time.imgVec[fingerMovePath0[_index]].y + GameCom_four_time.MAP_WIDTH * 0.5;
					
				}else{
					
					img.x = Game_four_time.imgVec[fingerMovePath0[_index]].x + GameCom_four_time.MAP_WIDTH * 0.5;
					img.y = Game_four_time.imgVec[fingerMovePath0[_index]].y;
				}
				
				var p0:Point = new Point(img.x,img.y);
				
				var p1:Point = Game_four_time.mapContainer.localToGlobal(p0);
				
				img.x = p1.x - imgFix;
				img.y = p1.y - imgFix;
				
				img.alpha = 0;
				
				arrowQuadBatch.addImage(img);
				
				_alphaNum = 0;
				
				TweenLite.to(GameTutorial_four_time,0.1,{alphaNum:1,onComplete:addArrow,onCompleteParams:[_index + 1]});
				
			}else{
				
				TweenLite.delayedCall(1,startArrowDisappear);
			}
		}
		
		private static function startArrowDisappear():void{
			
			TweenLite.to(arrowQuadBatch,0.5,{alpha:0,onComplete:arrowDisappear});
		}
		
		private static function arrowDisappear():void{
			
			Game_four_time.container.removeChild(arrowQuadBatch);
			
			Game_four_time.startMove();
			
			Game_four_time.startTimer(false);
			
			Game_four_time.tutorialCallBack = actionSuccess;
		}
		
		private static function actionSuccess(_max:int):void{
			
			showMask(area0);
			
			maskQuadBatch.alpha = 0;
			
			TweenLite.to(maskQuadBatch,0.5,{alpha:1,onComplete:showMaskOK,onCompleteParams:[_max,area0]});
		}
		
		private static function showMaskOK(_max:int,_area:Vector.<int>):void{
			
			var img:Image = new Image(Resource.textureAtlas.getTexture("gou"));
			
			gou = new Sprite;
			
			gou.addChild(img);
			
			img.width = img.width * GameCom_four_time.SCALE * 2;
			img.height = img.height * GameCom_four_time.SCALE * 2;
			
			img.x = -0.5 * img.width;
			img.y = -0.5 * img.height;
			
			gou.addChild(img);
			
			gou.flatten();
			
			Game_four_time.container.addChild(gou);
			
			var p:Point = new Point;
			
			p.x = (Game_four_time.imgVec[_area[0]].x + Game_four_time.imgVec[_area[1]].x) * 0.5 - imgFix + GameCom_four_time.MAP_WIDTH * 0.5;
			p.y = (Game_four_time.imgVec[_area[0]].y + Game_four_time.imgVec[_area[1]].y) * 0.5 - imgFix + GameCom_four_time.MAP_WIDTH * 0.5;
			
			Game_four_time.mapContainer.localToGlobal(p,p);
			
			gou.x = p.x + img.width * 0.5 + GameCom_four_time.MAP_WIDTH;
			gou.y = p.y;
			
			gou.scaleX = gou.scaleY = 0;
			
			TweenLite.to(gou,0.5,{scaleX:1,scaleY:1,ease:Elastic.easeOut});
			
			TweenLite.delayedCall(1,maskDisappear,[_max]);
		}
		
		private static function maskDisappear(_max:int):void{
			
			TweenLite.to(gou,0.5,{alpha:0});
			
			TweenLite.to(maskQuadBatch,0.5,{alpha:0,onComplete:maskDisappearOK,onCompleteParams:[_max]});
		}
		
		private static function maskDisappearOK(_max:int):void{
			
			Game_four_time.container.removeChild(gou);
			
			Game_four_time.container.removeChild(maskQuadBatch);
			
			Game_four_time.actionSuccess(_max);
			
			TweenLite.delayedCall(3,startTutorial1);
		}
		
		private static function startTutorial1():void{
			
			Game_four_time.container.addChild(fingerContainer);
			
			fingerContainer.x = Game_four_time.imgVec[fingerMovePath1[0]].x;
			fingerContainer.y = Game_four_time.imgVec[fingerMovePath1[0]].y;
			
			Game_four_time.tutorialCallBack = moveFingerOver1;
			
			fingerContainer.alpha = 0;
			
			touchBegin = false;
			
			TweenLite.to(fingerContainer,0.5,{alpha:1,onComplete:moveFinger,onCompleteParams:[0,fingerMovePath1]});
		}
		
		private static function moveFingerOver1():void{
			
			TweenLite.killTweensOf(fingerContainer);
			
			TweenLite.to(fingerContainer,0.5,{alpha:0,onComplete:fingerDisappear1});
			
			Game_four_time.startMove();
			
			Game_four_time.tutorialCallBack = moveFail;
		}
		
		private static function fingerDisappear1():void{
			
			Game_four_time.container.removeChild(fingerContainer);
		}
		
		private static function moveFail():void{
			
			Game_four_time.stopTimer();
			
			showMask(area1);
			
			maskQuadBatch.alpha = 0;
			
			TweenLite.to(maskQuadBatch,0.5,{alpha:1,onComplete:showMaskOK1,onCompleteParams:[area1]});
		}
		
		
		private static function showMaskOK1(_area:Vector.<int>):void{
			
			var img:Image = new Image(Resource.textureAtlas.getTexture("cha"));
			
			cha = new Sprite;
			
			cha.addChild(img);
			
			img.width = img.width * GameCom_four_time.SCALE * 2;
			img.height = img.height * GameCom_four_time.SCALE * 2;
			
			img.x = -0.5 * img.width;
			img.y = -0.5 * img.height;
			
			cha.addChild(img);
			
			cha.flatten();
			
			Game_four_time.container.addChild(cha);
			
			var p:Point = new Point;
			
			p.x = (Game_four_time.imgVec[_area[0]].x + Game_four_time.imgVec[_area[1]].x) * 0.5 - imgFix + GameCom_four_time.MAP_WIDTH * 0.5;
			p.y = (Game_four_time.imgVec[_area[0]].y + Game_four_time.imgVec[_area[1]].y) * 0.5 - imgFix + GameCom_four_time.MAP_WIDTH * 0.5;
			
			Game_four_time.mapContainer.localToGlobal(p,p);
			
			cha.x = p.x + img.width * 0.5 + GameCom_four_time.MAP_WIDTH;
			cha.y = p.y;
			
			cha.scaleX = cha.scaleY = 0;
			
			TweenLite.to(cha,0.5,{scaleX:0.8,scaleY:0.8,ease:Elastic.easeOut});
			
			TweenLite.delayedCall(1,maskDisappear1);
		}
		
		private static function maskDisappear1():void{
			
			TweenLite.to(cha,0.5,{alpha:0});
			
			TweenLite.to(maskQuadBatch,0.5,{alpha:0,onComplete:maskDisappearOK1});
		}
		
		private static function maskDisappearOK1():void{
			
			Game_four_time.container.removeChild(cha);
			
			Game_four_time.container.removeChild(maskQuadBatch);
			
			Game_four_time.actionFail();
			
			Game_four_time.startTimer(false);
			
			TweenLite.delayedCall(2,startTutorial2);
		}
		
		private static function startTutorial2():void{
			
			Game_four_time.container.addChild(fingerContainer);
			
			fingerContainer.x = Game_four_time.imgVec[fingerMovePath2[0]].x;
			fingerContainer.y = Game_four_time.imgVec[fingerMovePath2[0]].y;
			
			Game_four_time.tutorialCallBack = moveFingerOver2;
			
			fingerContainer.alpha = 0;
			
			touchBegin = false;
			
			TweenLite.to(fingerContainer,0.5,{alpha:1,onComplete:moveFinger,onCompleteParams:[0,fingerMovePath2]});
		}
		
		private static function moveFingerOver2():void{
			
			Game_four_time.stopTimer();
			
			TweenLite.killTweensOf(fingerContainer);
			
			TweenLite.to(fingerContainer,0.5,{alpha:0,onComplete:fingerDisappear2});
			
			Game_four_time.startMove();
			
			Game_four_time.tutorialCallBack = moveFingerOver3;
		}
		
		private static function fingerDisappear2():void{
			
			Game_four_time.container.removeChild(fingerContainer);
		}
		
		private static function moveFingerOver3(_max:int):void{
			
			showMask(area2);
			
			maskQuadBatch.alpha = 0;
			
			TweenLite.to(maskQuadBatch,0.5,{alpha:1,onComplete:showMaskOK2,onCompleteParams:[_max]});
		}
		
		private static function showMaskOK2(_max:int):void{
			
			Game_four_time.container.addChild(gou);
			
			var p:Point = new Point;
			
			p.x = (Game_four_time.imgVec[area2[0]].x + Game_four_time.imgVec[area2[1]].x) * 0.5 - imgFix + GameCom_four_time.MAP_WIDTH * 0.5;
			p.y = (Game_four_time.imgVec[area2[0]].y + Game_four_time.imgVec[area2[1]].y) * 0.5 - imgFix + GameCom_four_time.MAP_WIDTH * 0.5;
			
			Game_four_time.mapContainer.localToGlobal(p,p);
			
			gou.x = p.x + gou.getChildAt(0).width * 0.5 + GameCom_four_time.MAP_WIDTH;
			gou.y = p.y;
			
			gou.alpha = 1;
			
			gou.scaleX = gou.scaleY = 0;
			
			TweenLite.to(gou,0.5,{scaleX:1,scaleY:1,ease:Elastic.easeOut});
			
			TweenLite.delayedCall(1,maskDisappear2,[_max]);
		}
		
		private static function maskDisappear2(_max:int):void{
			
			TweenLite.to(maskQuadBatch,0.5,{alpha:0,onComplete:showMaskAgain0,onCompleteParams:[_max]});
		}
		
		private static function showMaskAgain0(_max:int):void{
			
			showMask(area3);
			
			TweenLite.to(maskQuadBatch,0.5,{alpha:1,onComplete:showMaskOK3,onCompleteParams:[_max]});
		}
		
		private static function showMaskOK3(_max:int):void{
			
			Game_four_time.container.addChild(cha);
			
			var p:Point = new Point;
			
			p.x = (Game_four_time.imgVec[area3[0]].x + Game_four_time.imgVec[area3[1]].x) * 0.5 - imgFix + GameCom_four_time.MAP_WIDTH * 0.5;
			p.y = (Game_four_time.imgVec[area3[0]].y + Game_four_time.imgVec[area3[1]].y) * 0.5 - imgFix + GameCom_four_time.MAP_WIDTH * 0.5;
			
			Game_four_time.mapContainer.localToGlobal(p,p);
			
			cha.x = p.x + gou.getChildAt(0).width * 0.5 + GameCom_four_time.MAP_WIDTH;
			cha.y = p.y;
			
			cha.alpha = 1;
			
			cha.scaleX = cha.scaleY = 0;
			
			TweenLite.to(cha,0.5,{scaleX:0.8,scaleY:0.8,ease:Elastic.easeOut});
			
			TweenLite.delayedCall(1,maskDisappear3,[_max]);
		}
		
		private static function maskDisappear3(_max:int):void{
			
			TweenLite.to(maskQuadBatch,0.5,{alpha:0,onComplete:showMaskAgain1,onCompleteParams:[_max]});
		}
		
		private static function showMaskAgain1(_max:int):void{
			
			showMask(area2);
			
			Game_four_time.container.addChild(gou);
			
			maskQuadBatch.alpha = 0;
			
			TweenLite.to(maskQuadBatch,0.5,{alpha:1,onComplete:showMaskOK4,onCompleteParams:[_max]});
		}
		
		private static function showMaskOK4(_max:int):void{
			
			rotationGou0(0,_max);
		}
		
		private static function rotationGou0(_index:int,_max:int):void{
			
			TweenLite.to(gou,0.1,{rotation:-0.2,onComplete:rotationGou1,onCompleteParams:[_index + 1,_max]});
		}
		
		private static function rotationGou1(_index:int,_max:int):void{
			
			if(_index > 10){
				
				TweenLite.to(maskQuadBatch,0.5,{alpha:0,onComplete:showMaskAgain2,onCompleteParams:[_max]});
				
				TweenLite.to(gou,0.3,{rotation:0});
				
			}else{
			
				TweenLite.to(gou,0.1,{rotation:0.2,onComplete:rotationGou0,onCompleteParams:[_index + 1,_max]});
			}
		}
		
		private static function showMaskAgain2(_max:int):void{
			
			showMask(area3);
			
			Game_four_time.container.addChild(cha);
			
			maskQuadBatch.alpha = 0;
			
			TweenLite.to(maskQuadBatch,0.5,{alpha:1,onComplete:showMaskOK5,onCompleteParams:[_max]});
		}
		
		private static function showMaskOK5(_max:int):void{
			
			TweenLite.to(cha,0.5,{scaleX:0,scaleY:0,ease:Elastic.easeIn,onComplete:chaOver,onCompleteParams:[_max]});
		}
		
		private static function chaOver(_max:int):void{
			
			cha.unflatten();
			
			(cha.getChildAt(0) as Image).texture = Resource.textureAtlas.getTexture("gou");
			
			cha.flatten();
			
			TweenLite.to(cha,0.5,{scaleX:1,scaleY:1,ease:Elastic.easeOut,onComplete:removeAll,onCompleteParams:[_max]});
		}
		
		private static function removeAll(_max:int):void{
			
			TweenLite.to(cha,0.5,{alpha:0,onComplete:removeAllOK,onCompleteParams:[_max]});
			TweenLite.to(gou,0.5,{alpha:0});
			TweenLite.to(maskQuadBatch,0.5,{alpha:0});
		}
		
		private static function removeAllOK(_max:int):void{
			
			Game_four_time.container.removeChild(cha);
			Game_four_time.container.removeChild(gou);
			Game_four_time.container.removeChild(maskQuadBatch);
			
			Game_four_time.actionSuccess(_max);
			
			TweenLite.delayedCall(3,clickMask);
		}
		
		private static function clickMask():void{
			
			fingerContainer.x = Game_four_time.textFieldContainer.width * 0.5;
			fingerContainer.y = Game_four_time.textFieldContainer.height * 0.5 - Game_four_time.mapContainer.y;
			
			Game_four_time.container.addChild(fingerContainer);
			
			fingerContainer.alpha = 0;
			
			TweenLite.to(fingerContainer,0.3,{alpha:1,onComplete:clickMask1,onCompleteParams:[0,clickMask3]});
		}
		
		private static function clickMask1(_index:int,_callBack:Function):void{
			
			if(_index > 5){
				
				_callBack();
				
			}else{
			
				TweenLite.to(fingerContainer,0.2,{y:fingerContainer.y + 20 * GameCom_four_time.SCALE,onComplete:clickMask2,onCompleteParams:[_index + 1,_callBack]});
			}
		}
		
		private static function clickMask2(_index:int,_callBack:Function):void{
			
			TweenLite.to(fingerContainer,0.2,{y:fingerContainer.y - 20 * GameCom_four_time.SCALE,onComplete:clickMask1,onCompleteParams:[_index + 1,_callBack]});
		}

		private static function clickMask3():void{
			
			touch.globalX = Game_four_time.textFieldContainer.width * 0.5;
			touch.globalY = Game_four_time.textFieldContainer.height * 0.5;
			
			touch.target = Game_four_time.textFieldContainer;
			
			touch.phase = TouchPhase.ENDED;
			
			Game_four_time.textFieldContainer.dispatchEvent(touchEvent);
			
			TweenLite.killTweensOf(Game_four_time);
			
			TweenLite.delayedCall(1,clickMask4);
			
			TweenLite.to(fingerContainer,0.5,{alpha:0});
			
			TimeUtil.speed = tutorialSpeed;
		}
		
		private static function clickMask4():void{
			
			fingerContainer.x = Game_four_time.restartBt.x + Game_four_time.restartBt.width * 0.5;
			fingerContainer.y = Game_four_time.restartBt.y + Game_four_time.restartBt.height * 0.5 - Game_four_time.mapContainer.y;
			
			TweenLite.to(fingerContainer,0.3,{alpha:1,onComplete:clickMask5});
		}
		
		private static function clickMask5():void{
			
			clickMask1(0,tutorialOver);
		}
		
		private static function removeFinger():void{
			
			TweenLite.to(fingerContainer,0.3,{alpha:0,onComplete:tutorialOver});
		}
		
		private static function tutorialOver():void{
			
			Game_four_time.container.removeChild(fingerContainer);
			
			if(!Record.data.hasTutorial){
				
				Record.data.bestScore = 0;
				
				Record.data.hasTutorial = true;
				
//				Record.writeRecord();
			}
			
			Game_four_time.container.touchable = true;
			
			Game_four_time.showMask(false);
			
			Game_four_time.start(Record.data.data,Record.data.score,Record.data.time);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		private static function showMask(_area:Vector.<int>):void{
			
			if(!maskQuadBatch){
				
				maskQuadBatch = new QuadBatch;
			}
			
			maskQuadBatch.reset();
			
			Game_four_time.container.addChild(maskQuadBatch);
			
			var p:Point = new Point(Game_four_time.imgVec[_area[1]].x - imgFix + GameCom_four_time.MAP_WIDTH,Game_four_time.imgVec[_area[0]].y - imgFix);
			
			var p1:Point = Game_four_time.mapContainer.localToGlobal(p);
			
			var quad:Quad = new Quad(p1.x,p1.y,0);
			
			quad.alpha = 0.7;
			
			maskQuadBatch.addQuad(quad);
			
			p.x = Game_four_time.imgVec[_area[1]].x - imgFix + GameCom_four_time.MAP_WIDTH;
			p.y = Game_four_time.imgVec[_area[1]].y - imgFix + GameCom_four_time.MAP_WIDTH;
			
			p1 = Game_four_time.mapContainer.localToGlobal(p);
			
			quad = new Quad(GameCom_four_time.ALL_WIDTH - p1.x,p1.y,0);
			
			quad.x = p1.x;
			
			quad.alpha = 0.7;
			
			maskQuadBatch.addQuad(quad);
			
			p.x = Game_four_time.imgVec[_area[0]].x - imgFix;
			p.y = Game_four_time.imgVec[_area[1]].y - imgFix + GameCom_four_time.MAP_WIDTH;
			
			p1 = Game_four_time.mapContainer.localToGlobal(p);
			
			quad = new Quad(GameCom_four_time.ALL_WIDTH - p1.x,Starling.current.viewPort.height - p1.y,0);
			
			quad.x = p1.x;
			quad.y = p1.y;
			
			quad.alpha = 0.7;
			
			maskQuadBatch.addQuad(quad);
			
			p.x = Game_four_time.imgVec[_area[0]].x - imgFix;
			p.y = Game_four_time.imgVec[_area[0]].y - imgFix;
			
			if(p.x == 0){
				
				return;
			}
			
			p1 = Game_four_time.mapContainer.localToGlobal(p);
			
			quad = new Quad(p1.x,Starling.current.viewPort.height - p1.y,0);
			
			quad.y = p1.y;
			
			quad.alpha = 0.7;
			
			maskQuadBatch.addQuad(quad);
		}
		
		
		private static var _alphaNum:Number;

		public static function get alphaNum():Number
		{
			return _alphaNum;
		}

		public static function set alphaNum(value:Number):void
		{
			arrowQuadBatch.setQuadAlpha(arrowQuadBatch.numQuads - 1,value);
			
			_alphaNum = value;
		}

		
		private static function moveFingerUpdateFrame():void{
			
			var p:Point = Game_four_time.touchSp.localToGlobal(new Point(fingerContainer.x + GameCom_four_time.MAP_WIDTH * 0.5,fingerContainer.y + GameCom_four_time.MAP_WIDTH * 0.5));
			
			touch.globalX = p.x;
			touch.globalY = p.y;
			
			touch.target = Game_four_time.touchSp;
			
			if(!touchBegin){
				
				touchBegin = true;
				
				touch.phase = TouchPhase.BEGAN;
				
			}else{
				
				touch.phase = TouchPhase.MOVED;
			}
			
			Game_four_time.touchSp.dispatchEvent(touchEvent);
		}
		
		public static function deactive():void{
			
			TimeUtil.speed = 0;
		}
		
		public static function active():void{
			
			TimeUtil.speed = tutorialSpeed;
		}
	}
}