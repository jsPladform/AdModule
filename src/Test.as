package  
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import ru.pladform.event.AdEvent;
	import ru.pladform.event.AdLoaderEvent;
	import ru.pladform.IPladformModule;
	/**
	 * ...
	 * @author Alexander Semikolenov (alex@semikolenov.ru)
	 */
	public class Test extends Sprite
	{
		/**
		 * Ссылка на рекламный модуль.
		 */
		private const MODULE_PATH:String = "http://static.pladform.ru/adModule.swf"
		
		private var mcModule:PladformAdWrapper;
		private var timer:Timer;
		public function Test() 
		{
			if (stage)
			{
				addToStageHandler(null);
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, addToStageHandler)
			}
		}
		
		// STATIC METHODS
		
		// ACCESSORS
		
		// PUBLIC METHODS
		
		// PROTECTED METHODS
		
		// EVENT HANDLERS
		
		private function errLoadHandler(e:IOErrorEvent):void 
		{
			trace(e)
		}
		
		private function progressLoadHandler(e:ProgressEvent):void 
		{
			trace("loading:",100*e.bytesLoaded/e.bytesTotal+"%")
		}
		
		private function adLoadEventHandler(e:AdLoaderEvent):void 
		{
			trace("e = ",e)
		}
		
		private function adEventHandler(e:AdEvent):void 
		{
			trace("e = ",e)
		}
		
		private function completeLoadHandler(e:Event):void 
		{
			//Инициируем обертку над модулем
			mcModule = new PladformAdWrapper(e.target.content);
			addChild(mcModule);
			//Обязательно при инициализации указываем параметр pl 
			mcModule.init(new URLVariables("pl=1"));
			
			//подписываемся на события модуля для их обработки.
			mcModule.addEventListener(AdEvent.SHOW, adEventHandler);
			mcModule.addEventListener(AdEvent.CLOSE, adEventHandler);
			mcModule.addEventListener(AdEvent.COMPLETE, adEventHandler);
			mcModule.addEventListener(AdEvent.CLICK, adEventHandler);
			mcModule.addEventListener(AdEvent.EMPTY, adEventHandler);
			
			mcModule.addEventListener(AdLoaderEvent.COMPLETE, adLoadEventHandler);
			mcModule.addEventListener(AdLoaderEvent.ERROR, adLoadEventHandler);
			
		}
		
		private function addToStageHandler(e:Event):void 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			var loader :Loader = new Loader();
			Security.allowDomain("*")
			//загружаем модуль, если надо отслеживая процесс загрузки
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoadHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errLoadHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressLoadHandler);
			var context :LoaderContext	= new LoaderContext(true, ApplicationDomain.currentDomain);
			loader.load(new URLRequest(MODULE_PATH),context);
		}
		
		// PRIVATE METHODS
		
	}

}