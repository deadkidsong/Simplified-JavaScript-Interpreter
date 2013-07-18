package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import SJS.Interpreter;
	import SJS.Lexer;
	
	import SJS.Parser;
	
	/**
	 * ...
	 * @author Guobo
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			graphics.lineStyle(2, 0x996699);
			graphics.drawCircle(100, 100, 100);
			
			// entry point
			
			var p:Parser = new Parser();
			var tokens:Array = Lexer.tokenize("var m = 5 + 6 * 8;");
			
			
			trace(tokens.length);
			for (var i:int = 0; i < tokens.length; i++) {
				//trace(tokens[i]);
			}
			
			
			var ip:Interpreter = new Interpreter();
			ip.pushDict( { MovieClip:MovieClip } );
			ip.pushDict( { TempUtils:TempUtils } );
			ip.pushDict( { testAPI:testAPI } );
			ip.pushDict( { gg:graphics } );
			
			ip.doString("var m = 5 + 6 * 8;");
			ip.doString("var n = m + 1;");
			ip.doString("var a = 6;\rwhile(a<1000){a=a+1;}");
			ip.doString("function f(a){a=a+6;return a;}\rvar b = f(7);");
			ip.doString("var mc = new MovieClip(); var s = mc.width();");
			ip.doString("var g = mc.graphics; g.lineStyle(2, 0x996699);g.drawCircle(200, 200, 100);");
			ip.doString("var x = TempUtils.stat + 2;");
			ip.doString("var str = TempUtils.getName() + 'what';");
			ip.doString("var test = testAPI(5);");
			ip.doString("gg.drawCircle(300, 300, 100);");
			
			trace("value m is " + ip.vm.findVar("m"));
			trace("value n is " + ip.vm.findVar("n"));
			trace("value a is " + ip.vm.findVar("a"));
			trace("value b is " + ip.vm.findVar("b"));
			trace("value mc is " + ip.vm.findVar("mc"));
			addChild(ip.vm.findVar("mc"));
			
			trace("value x is " + ip.vm.findVar("x"));
			trace("value str is " + ip.vm.findVar("str"));
			trace("value test is " + ip.vm.findVar("test"));
		}
		
		public function testAPI(a:int):int {
			return a * a;
		}
		
	}
	
}