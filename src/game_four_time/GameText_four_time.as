package game_four_time
{
	import resource.Resource;

	public class GameText_four_time
	{
		public static var nowLanguageIndex:int = 1;
		
		public static const FONT_NAME:Vector.<String> = Vector.<String>([Resource.FONT_NAME1,Resource.FONT_NAME1]);
		
		//english
		public static const SCORE:Vector.<String> = Vector.<String>(["Score\n","得分\n"]);
		public static const BEST:Vector.<String> = Vector.<String>(["Record\n","纪录\n"]);
		public static const SOUND_ON:Vector.<String> = Vector.<String>(["Sound On","音效 开"]);
		public static const SOUND_OFF:Vector.<String> = Vector.<String>(["Sound Off","音效 关"]);
		public static const RESTART0:Vector.<String> = Vector.<String>(["Score\n\n","得分\n\n"]);
		public static const RESTART1:Vector.<String> = Vector.<String>(["\n\nTouch to Restart\n\n\n","\n\n点击屏幕\n重新开始游戏\n\n\n"]);
		public static const RESUMBT:Vector.<String> = Vector.<String>(["Resume","回到游戏"]);
		public static const RESTART_BT:Vector.<String> = Vector.<String>(["Restart","重新开始"]);
		public static const TUTORIAL_BT:Vector.<String> = Vector.<String>(["Tutorial","教程"]);
	}
}