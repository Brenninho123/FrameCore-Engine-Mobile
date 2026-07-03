package source.mobile.backend;

import lime.utils.Assets;
import openfl.utils.Assets as OpenFLAssets;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

class StorageUtil
{
    public static var rootPath:String = #if android lime.system.System.applicationStorageDirectory #else "./" #end;

    public static function init():Void
    {
        #if android
        checkAndCopyFiles();
        #end
    }

    private static function checkAndCopyFiles():Void
    {
        var targetAssetsDir:String = Path.join([rootPath, "assets"]);
        var targetModsDir:String = Path.join([rootPath, "mods"]);

        if (!FileSystem.exists(targetAssetsDir))
            FileSystem.createDirectory(targetAssetsDir);

        if (!FileSystem.exists(targetModsDir))
            FileSystem.createDirectory(targetModsDir);

        for (asset in Assets.list())
        {
            if (asset.startsWith("assets/") || asset.startsWith("mods/"))
            {
                var targetPath:String = Path.join([rootPath, asset]);
                var directory:String = Path.directory(targetPath);

                if (!FileSystem.exists(directory))
                    FileSystem.createDirectory(directory);

                if (!FileSystem.exists(targetPath))
                {
                    var bytes = Assets.getBytes(asset);
                    if (bytes != null)
                        File.saveBytes(targetPath, bytes);
                }
            }
        }
    }
}
