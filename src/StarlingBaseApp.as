package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import robotlegs.bender.framework.api.IContext;
	
	import starling.core.Starling;
	
	import view.base.StarlingRootSprite;
	
	public class StarlingBaseApp extends Sprite
	{
		
		protected var _context:IContext;
		protected var _starling:Starling;
		
		public function StarlingBaseApp()
		{
			// Init stage.
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			
			// No flash.display mouse interactivity.
			mouseEnabled = mouseChildren = false;
			
			// Init Starling.
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			_starling = new Starling( StarlingRootSprite, stage, null, null, "auto", "baseline" );
			_starling.enableErrorChecking = false;
			_starling.showStats = true;
			_starling.start();
			
			/**
			// Init Robotlegs.
			_context = new Context();
			_context.install( MVCSBundle, StarlingViewMapExtension, SignalCommandMapBundle );
			_context.configure( AppConfig, this, _starling );
			_context.configure( new ContextView( this ) );
			*/
			
			/**
			// Simulate ASUS TF201 screen properties.
			DeviceCapabilities.dpi = 149;
			DeviceCapabilities.screenPixelWidth = 800;
			DeviceCapabilities.screenPixelHeight = 600;
			*/
			
			// Update Starling view port on stage resizes.
			stage.addEventListener( Event.RESIZE, onStageResize, false, int.MAX_VALUE, true );
			stage.addEventListener( Event.DEACTIVATE, onStageDeactivate, false, 0, true );
		}
		
		private function onStageResize( event:Event ):void {
			if( stage.stageWidth < 256 || stage.stageHeight < 256 ) return;
			_starling.stage.stageWidth = stage.stageWidth;
			_starling.stage.stageHeight = stage.stageHeight;
			const viewPort:Rectangle = _starling.viewPort;
			viewPort.width = stage.stageWidth;
			viewPort.height = stage.stageHeight;
			try {
				_starling.viewPort = viewPort;
			}
			catch( error:Error ) {
			}
		}
		
		private function onStageDeactivate( event:Event ):void {
			_starling.stop();
			stage.addEventListener( Event.ACTIVATE, onStageActivate, false, 0, true );
		}
		
		private function onStageActivate( event:Event ):void {
			stage.removeEventListener( Event.ACTIVATE, onStageActivate );
			_starling.start();
		}
	}
}