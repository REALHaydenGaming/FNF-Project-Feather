package;

import base.backend.DebugInfo;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

/**
	the `Main` class actually initializes our game,
	you may not find use for it unless you wanna change existing variales on it
**/
class Main extends Sprite
{
	public static var game = {
		width: 1280, // the game window width
		height: 720, // the game window height
		zoom: -1.0, // defines the game's state bounds, -1.0 usually means automatic setup
		initialState: funkin.states.TitleState, // the game's initial state (shown after boot splash)
		framerate: 120, // the game's default framerate
		skipSplash: false, // whether the game boot splash should be skipped (defaults to false, changes true when seen once)
		fullscreen: false, // whether the game should start at fullscreen
		version: '0.0.1-PA', // the engine game version
	};

	public static function main():Void
		Lib.current.addChild(new Main());

	public function new()
	{
		super();

		// initialize the game controls for later use
		Controls.init();

		// initialize the discord rich presence wrapper
		DiscordRPC.init();

		// define the state bounds
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}

		addChild(new FlxGame(game.width, game.height, Start, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate, true, game.fullscreen));
		addChild(new DebugInfo(0, 0));

		FlxG.stage.application.window.onClose.add(function()
		{
			Controls.destroy();
			DiscordRPC.destroy();
		});
	}
}
