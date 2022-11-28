package base.data;

#if FEATURE_DISCORD
import discord_rpc.DiscordRpc as RPCWrapper;

/**
	Discord Client Wrapper class for the linc_discord-rpc library
	https://github.com/Aidan63/linc_discord-rpc
**/
class DiscordRPC
{
	public static function init(id:String = '814588678700924999'):Void
	{
		RPCWrapper.start({
			clientID: id,
			onReady: ready,
			onError: catchError,
			onDisconnected: dc
		});

		lime.app.Application.current.onExit.add(function(e:Dynamic)
		{
			destroy();
		});
	}

	public static function destroy()
		RPCWrapper.shutdown();

	static function ready():Void
	{
		RPCWrapper.presence({
			details: "",
			state: null,
			largeImageKey: 'icon',
			largeImageText: "Project Feather"
		});
	}

	static function catchError(_code:Int, _message:String):Void
		trace('Error! $_code : $_message');

	static function dc(_code:Int, _message:String):Void
		trace('Disconnected! $_code : $_message');

	public static function update(detailsMain:String = '', detailsSub:String = '', ?keyBig:String, ?keySmall:String, ?detailsBig:String, ?detailsSmall:String,
			?timeEnd:Float, ?startTime:Bool):Void
	{
		var timeNow:Float = (startTime ? Date.now().getTime() : 0);

		if (timeEnd > 0)
			timeEnd = timeNow + timeEnd;

		RPCWrapper.presence({
			details: detailsMain,
			state: detailsSub,
			largeImageKey: keyBig,
			smallImageKey: keySmall,
			largeImageText: detailsBig,
			smallImageText: detailsSmall,
			startTimestamp: Std.int(timeNow / 1000),
			endTimestamp: Std.int(timeEnd / 1000)
		});
	}
}
#else

/**
	Discord Client Wrapper class for the linc_discord-rpc library
	https://github.com/Aidan63/linc_discord-rpc

	this class won't work on your platform as it's unsupported
**/
class DiscordRPC
{
	public static function init():Void
		return trace("Discord Client is not supported on this platform");

	public static function update(detailsMain:String = '', detailsSub:String = '', ?keyBig:String, ?keySmall:String, ?detailsBig:String, ?detailsSmall:String,
			?timeEnd:Float, ?startTime:Bool):Void
		return;

	public static function destroy()
		return;
}
#end