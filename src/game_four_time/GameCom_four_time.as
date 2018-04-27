package game_four_time
{
	import flash.utils.Dictionary;
	
	import starling.core.Starling;

	public class GameCom_four_time
	{
		public static const WIDTH:int = 8;//不变
		public static const HEIGHT:int = 8;//不变

		public static const SCORE_CONTAINER_HEIGHT:int = 80;//不变
		public static const SCORE_CONTAINER_Y:int = 10;//不变
		
		public static const TIMER_HEIGHT:int = 80;
		public static const TIMER_BALL_HEIGHT:int = 60;
		
		public static var FRAME_WIDTH:int = 55;//ball_width - 3
		
		public static var BALL_WIDTH:int = 58;//map_width - 10

		public static var MAP_WIDTH:int = 69;//all_width / width
		
		public static const COLOR_NUM:int = 6;//不变
		
		public static var ALL_WIDTH:int;
		
		public static const O_ALL_WIDTH:int = 640;//不变
		
		public static var SCALE:Number;
		
		public static const O_FONT_SIZE:int = 40;//不变
		
		public static const FONT_COLOR:uint = 0x666666;//不变
		
		public static const COLOR_SCORE_FIX:int = 1000;
		
		public static const OTIMELONG:Number = 30;
		
		public static const TIMELONGDESC:Number = 0.2;
		
		public static var MINTIMELONG:Number = OTIMELONG / 3;
		
		private static var tmpColorIndexVec:Vector.<int>;
		
		private static var upVec:Vector.<int>;
		private static var downVec:Vector.<int>;
		private static var leftVec:Vector.<int>;
		private static var rightVec:Vector.<int>;
		
		public static function init():void{
			
			ALL_WIDTH = Starling.current.viewPort.width;
			
			SCALE = ALL_WIDTH / O_ALL_WIDTH;
			
			MAP_WIDTH = ALL_WIDTH / WIDTH;
			
			BALL_WIDTH = MAP_WIDTH - 10 * SCALE;
			
			FRAME_WIDTH = BALL_WIDTH - 3 * SCALE;
			
			tmpColorIndexVec = new Vector.<int>(COLOR_NUM,true);
			
			for(var i:int = 0 ; i < COLOR_NUM ; i++){
				
				tmpColorIndexVec[i] = i + 1;
			}
			
			upVec = new Vector.<int>(2,true);
			downVec = new Vector.<int>(2,true);
			leftVec = new Vector.<int>(2,true);
			rightVec = new Vector.<int>(2,true);
		}
		
		public static function getRandomColorIndex(_data:Vector.<int>,_index:int):int{
			
			var vec:Vector.<int> = tmpColorIndexVec.concat();
			
			var tmpInt:int = _index % WIDTH;
			
			if(tmpInt == 0){
				
				leftVec[0] = 0;
				leftVec[1] = 0;
				
			}else if(tmpInt == 1){
				
				leftVec[0] = _data[_index - 1];
				leftVec[1] = 0;
				
			}else{
				
				leftVec[0] = _data[_index - 1];
				leftVec[1] = _data[_index - 2];
				
				if(leftVec[0] == leftVec[1] && leftVec[0] != 0){
					
					var tmpInt2:int = vec.indexOf(leftVec[0]);
					
					if(tmpInt2 != -1){
						
						vec.splice(tmpInt2,1);
					}
				}
			}
			
			if(tmpInt == WIDTH - 1){
				
				rightVec[0] = 0;
				rightVec[1] = 0;
				
			}else if(tmpInt == WIDTH - 2){
				
				rightVec[0] = _data[_index + 1];
				rightVec[1] = 0;
				
			}else{
				
				rightVec[0] = _data[_index + 1];
				rightVec[1] = _data[_index + 2];
				
				if(rightVec[0] == rightVec[1] && rightVec[0] != 0){
					
					tmpInt2 = vec.indexOf(rightVec[0]);
					
					if(tmpInt2 != -1){
						
						vec.splice(tmpInt2,1);
					}
				}
			}
			
			tmpInt = int(_index / WIDTH);
			
			if(tmpInt == 0){
				
				upVec[0] = 0;
				upVec[1] = 0;
				
			}else if(tmpInt == 1){
				
				upVec[0] = _data[_index - WIDTH];
				upVec[1] = 0;
				
			}else{
				
				upVec[0] = _data[_index - WIDTH];
				upVec[1] = _data[_index - WIDTH * 2];
				
				if(upVec[0] == upVec[1] && upVec[0] != 0){
					
					tmpInt2 = vec.indexOf(upVec[0]);
					
					if(tmpInt2 != -1){
						
						vec.splice(tmpInt2,1);
					}
				}
			}
			
			if(tmpInt == HEIGHT - 1){
				
				downVec[0] = 0;
				downVec[1] = 0;
				
			}else if(tmpInt == HEIGHT - 2){
				
				downVec[0] = _data[_index + WIDTH];
				downVec[1] = 0;
				
			}else{
				
				downVec[0] = _data[_index + WIDTH];
				downVec[1] = _data[_index + WIDTH * 2];
				
				if(downVec[0] == downVec[1] && downVec[0] != 0){
					
					tmpInt2 = vec.indexOf(downVec[0]);
					
					if(tmpInt2 != -1){
						
						vec.splice(tmpInt2,1);
					}
				}
			}
			
			if(upVec[0] == downVec[0] && upVec[0] != 0){
				
				tmpInt = vec.indexOf(upVec[0]);
				
				if(tmpInt != -1){
					
					vec.splice(tmpInt,1);
				}
			}
			
			if(leftVec[0] == rightVec[0] && leftVec[0] != 0){
				
				tmpInt = vec.indexOf(leftVec[0]);
				
				if(tmpInt != -1){
					
					vec.splice(tmpInt,1);
				}
			}
			
			return vec[int(Math.random() * vec.length)];
		}
		
		public static function check(_data:Vector.<int>,_vec:Vector.<int>,_resultVec:Vector.<int>,_max:int,_min:int):int{
			
			var vec:Vector.<int> = _vec.concat();
			
			var max:int = 0;
			
			var resultDic:Dictionary = new Dictionary;
			
			for(var i:int = 0 ; i < vec.length ; i++){
				
				var dic:Dictionary = new Dictionary;
				
				var index:int = vec[i];
				
				dic[index] = true;
				
				var num:int = 1;
				
				var m:int = 1;
				
				var next:int = index - m * WIDTH;
				
				while(next > -1){
					
					if(_data[index] == _data[next]){
						
						dic[next] = true;
						
						num++;
						
						var p:int = vec.indexOf(next,i);
						
						if(p != -1){
							
							vec.splice(p,1);
						}
						
						next = next - m * WIDTH;
						
					}else{
						
						break;
					}
				}
				
				m = 1;
				
				next = index + m * WIDTH;
				
				while(next < WIDTH * HEIGHT){
					
					if(_data[index] == _data[next]){
						
						dic[next] = true;
						
						num++;
						
						p = vec.indexOf(next,i);
						
						if(p != -1){
							
							vec.splice(p,1);
						}
						
						next = next + m * WIDTH;
						
					}else{
						
						break;
					}
				}
				
				if(num >= _min){
					
					for(var str:String in dic){
						
						resultDic[str] = true;
					}
					
					if(num > max){
						
						max = num;
					}
				}
			}
			
			vec = _vec.concat();
			
			for(i = 0 ; i < vec.length ; i++){
				
				dic = new Dictionary;
				
				index = vec[i];
				
				dic[index] = true;
				
				num = 1;
				
				m = 1;
				
				next = index - m;
				
				while(next > -1 && int(next / WIDTH) == int(index / WIDTH)){
					
					if(_data[index] == _data[next]){
						
						dic[next] = true;
						
						num++;
						
						p = vec.indexOf(next,i);
						
						if(p != -1){
							
							vec.splice(p,1);
						}
						
						next = next - m;
						
					}else{
						
						break;
					}
				}
				
				m = 1;
				
				next = index + m;
				
				while(int(next / WIDTH) == int(index / WIDTH)){
					
					if(_data[index] == _data[next]){
						
						dic[next] = true;
						
						num++;
						
						p = vec.indexOf(next,i);
						
						if(p != -1){
							
							vec.splice(p,1);
						}
						
						next = next + m;
						
					}else{
						
						break;
					}
				}
				
				if(num >= _min){
					
					for(str in dic){
						
						resultDic[str] = true;
					}
					
					if(num > max){
						
						max = num;
					}
				}
			}
			
			if(max >= _max){
				
				for(str in resultDic){
					
					_resultVec.push(str);
				}
				
				return max;
				
			}else{
				
				return 0;
			}
		}
		
		
		public static function getScore(_num:int,_max:int):int{
			
			return _num * getMaxFix(_max);
		}
		
		public static function getMaxFix(_max:int):int{
			
			return _max - 3;
		}
	}
}