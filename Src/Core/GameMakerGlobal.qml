//pragma Singleton

import QtQuick 2.14
//import Qt.labs.settings 1.1


//引入Qt定义的类
//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
//import _Global.Button 1.0


import 'qrc:/QML'

//import 'Singleton'


//import 'GameMakerGlobal.js' as GameMakerGlobalJS
//import '../Config.js' as Config
//import 'File.js' as File



QtObject {
    id: root
    objectName: 'GameMakerGlobal'


    //引擎版本
    readonly property string version: '1.15.3.250209'

    //！！！兼容旧代码
    readonly property string separator: $Platform.sl_separator(true)

    //保存 Component 附加组件
    //单例的一个BUG：使用单例对象无法访问到Component，但内部使用root可以访问到；
    readonly property var $component: Component //root.Component

    //readonly property var $GameMakerGlobalJS: GameMakerGlobalJS


    readonly property var settings: GameMakerSingleton.settings


    readonly property QtObject config: QtObject { //配置
        //调试（游戏显示一些调试功能，比如存档不检测、游戏场景显示FPS、战场上显示调试按钮）
        //property bool bDebug: $Global.frameConfig.$sys.debug === 0 ? false : true
        //property bool bDebug: parseInt($Frame.config.Debug) === 0 ? false : true
        //property bool bDebug: parseInt($Frame.sl_configValue('Debug', 0)) === 0 ? false : true
        property bool bDebug: true


        //当前项目名称
        property string strCurrentProjectName: $GameMakerGlobal.settings.value('$CurrentProjectName') //GameMakerSingleton.settings.$CurrentProjectName

        //引擎工作目录
        property string strWorkPath: {
            switch(Qt.platform.os) {
            case 'android':
            case 'openharmony':
                return $Platform.externalDataPath + '/GameMaker/';
                //return 'assets:/';   //'./'  //':/'
            case 'windows':
                //if($Platform.compileType === 'debug')
                //    return 'F:/_Projects/Pets/MakerFrame/GameMaker/';
                //return $Platform.externalDataPath + '/GameMaker/';
            default:
                return $Platform.externalDataPath + '/GameMaker/';
                //return './';
            }
        }

        //项目根目录
        property string strProjectRootPath: {
            return strWorkPath + 'Projects/';

            /*switch(Qt.platform.os) {
            case 'android':
                //return 'assets:/';   //'./'  //':/'
            case 'openharmony':
                //return 'rawfile:/';
            case 'windows':
                //return './';
            default:
                //return './';
                return $Platform.sl_readOnlyPath();
            }
            */
        }

        //存档目录
        property string strSaveDataPath: {
            switch(Qt.platform.os) {
            case 'android':
            case 'openharmony':
                return strWorkPath + 'SaveData/' + strCurrentProjectName + '/';
                //return $Platform.externalDataPath + '/Games/' + strCurrentProjectName + '/SaveData/';
                //return $Platform.sl_getSdcardPath() + '/Leamus/Games/' + strCurrentProjectName + '/SaveData/';
            case 'windows':
            default:
                return strWorkPath + 'SaveData/' + strCurrentProjectName + '/';
                //return 'SaveData/';
            }
        }


        //数据文件存储 目录名
        property string strMapDirName: 'Maps'
        property string strSpriteDirName: 'Sprites'
        property string strRoleDirName: 'Roles'
        property string strGoodsDirName: 'Goods'
        property string strFightRoleDirName: 'FightRoles'
        property string strFightSkillDirName: 'FightSkills'
        property string strFightScriptDirName: 'FightScripts'

        //资源 目录名
        property string strResourceDirName: 'Resources'
        property string strMapResourceDirName: 'Maps'
        property string strSpriteResourceDirName: 'Sprites'
        property string strGoodsResourceDirName: 'Goods'
        property string strImageResourceDirName: 'Images'
        property string strMusicResourceDirName: 'Music'
        property string strSoundResourceDirName: 'Sounds'
        property string strVideoResourceDirName: 'Videos'
    }



    //下面函数是返回 数据/资源 的绝对路径（参数都是可选）

    function mapURL(filepath) {return $GlobalJS.toURL(mapPath(filepath));}
    function mapPath(filepath='') {
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strMapDirName;
        return filepath ? (ret + '/' + filepath) : ret;
    }
    function spriteURL(filepath) {return $GlobalJS.toURL(spritePath(filepath));}
    function spritePath(filepath='') {
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strSpriteDirName;
        return filepath ? (ret + '/' + filepath) : ret;
    }
    function roleURL(filepath) {return $GlobalJS.toURL(rolePath(filepath));}
    function rolePath(filepath='') {
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strRoleDirName;
        return filepath ? (ret + '/' + filepath) : ret;
    }
    function goodsURL(filepath) {return $GlobalJS.toURL(goodsPath(filepath));}
    function goodsPath(filepath='') {
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strGoodsDirName;
        return filepath ? (ret + '/' + filepath) : ret;
    }
    function fightRoleURL(filepath) {return $GlobalJS.toURL(fightRolePath(filepath));}
    function fightRolePath(filepath='') {
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strFightRoleDirName;
        return filepath ? (ret + '/' + filepath) : ret;
    }
    function fightSkillURL(filepath) {return $GlobalJS.toURL(fightSkillPath(filepath));}
    function fightSkillPath(filepath='') {
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strFightSkillDirName;
        return filepath ? (ret + '/' + filepath) : ret;
    }
    function fightScriptURL(filepath) {return $GlobalJS.toURL(fightScriptPath(filepath));}
    function fightScriptPath(filepath='') {
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strFightScriptDirName;
        return filepath ? (ret + '/' + filepath) : ret;
    }


    function mapResourceURL(filepath) {return $GlobalJS.toURL(mapResourcePath(filepath));}
    function mapResourcePath(filepath='') {
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strResourceDirName + '/' + config.strMapResourceDirName;
        return filepath ? (ret + '/' + filepath) : ret;
    }
    function spriteResourceURL(filepath) {return $GlobalJS.toURL(spriteResourcePath(filepath));}
    function spriteResourcePath(filepath='') {
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strResourceDirName + '/' + config.strSpriteResourceDirName;
        return filepath ? (ret + '/' + filepath) : ret;
    }
    function goodsResourceURL(filepath) {return $GlobalJS.toURL(goodsResourcePath(filepath));}
    function goodsResourcePath(filepath='') {
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strResourceDirName + '/' + config.strGoodsResourceDirName;
        return filepath ? (ret + '/' + filepath) : ret;
    }

    function imageResourceURL(filepath) {return $GlobalJS.toURL(imageResourcePath(filepath));}
    function imageResourcePath(filepath='') {
        // /开始的目录，则相对于项目根路径
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        //绝对目录
        //else if(filepath.includes(':')) return $GlobalJS.toPath(filepath);
        //相对目录
        else {
            const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strResourceDirName + '/' + config.strImageResourceDirName;
            return filepath ? (ret + '/' + filepath) : ret;
        }
    }
    function soundResourceURL(filepath) {return $GlobalJS.toURL(soundResourcePath(filepath));}
    function soundResourcePath(filepath='') {
        // /开始的目录，则相对于项目根路径
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        //绝对目录
        //else if(filepath.includes(':')) return $GlobalJS.toPath(filepath);
        //相对目录
        else {
            const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strResourceDirName + '/' + config.strSoundResourceDirName;
            return filepath ? (ret + '/' + filepath) : ret;
        }
    }
    function musicResourceURL(filepath) {return $GlobalJS.toURL(musicResourcePath(filepath));}
    function musicResourcePath(filepath='') {
        // /开始的目录，则相对于项目根路径
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        //绝对目录
        //else if(filepath.includes(':')) return $GlobalJS.toPath(filepath);
        //相对目录
        else {
            const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strResourceDirName + '/' + config.strMusicResourceDirName;
            return filepath ? (ret + '/' + filepath) : ret;
        }
    }
    function videoResourceURL(filepath) {return $GlobalJS.toURL(videoResourcePath(filepath));}
    function videoResourcePath(filepath='') {
        // /开始的目录，则相对于项目根路径
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        //绝对目录
        //else if(filepath.includes(':')) return $GlobalJS.toPath(filepath);
        //相对目录
        else {
            const ret = config.strProjectRootPath + config.strCurrentProjectName + '/' + config.strResourceDirName + '/' + config.strVideoResourceDirName;
            return filepath ? (ret + '/' + filepath) : ret;
        }
    }



    Component.onCompleted: {
        let gameMakerGlobal = root;
        //!!解决 assets BUG
        if(Qt.resolvedUrl('.').startsWith('file:assets:/')) {
            //gameMakerGlobal = root;
            console.info('[GameMakerGlobal]file:assets:/ 开头，需额外处理');
            if(Qt.platform.os !== 'android')
                console.warn('[!GameMakerGlobal]非安卓环境？');
            //return;
        }
        //else
        //    gameMakerGlobal = GameMakerGlobal;

        /*if($Frame.sl_globalObject().GameMakerGlobal && $Frame.sl_globalObject().GameMakerGlobal !== gameMakerGlobal) {
            const msg = '已存在不同GameMakerGlobal单例类，请重启框架或返回原引擎，否则数据出错';
            console.warn('[!GameMakerGlobal]' + msg);

            $Global.globalData.$components.dialog.show({
                Msg: msg,
                //Buttons: 0,
                OnAccepted: function() {
                },
                OnRejected: ()=>{
                },
            });
            return;
        }

        $Frame.sl_globalObject().$GameMakerGlobal = gameMakerGlobal;
        $Frame.sl_globalObject().GameMakerGlobal = gameMakerGlobal;
        $Frame.sl_globalObject().$GameMakerGlobalJS = GameMakerGlobalJS;
        $Frame.sl_globalObject().GameMakerGlobalJS = GameMakerGlobalJS;
        */



        ////if(root.settings.$CurrentProjectName)
            //config.strCurrentProjectName = root.settings.$CurrentProjectName;

        ++GameMakerSingleton.nOpenCount;



        console.debug('[GameMakerGlobal]Component.onCompleted:', gameMakerGlobal/*, GameMakerGlobalJS*//*, $window*/, gameMakerGlobal.Component, root.Component, gameMakerGlobal === root, Qt.resolvedUrl('.'), );
    }
    Component.onDestruction: {
        let gameMakerGlobal;
        //!!解决 assets BUG
        if(Qt.platform.os === 'android' && Qt.resolvedUrl('.').startsWith('file:assets:/')) {
            gameMakerGlobal = root;
            console.debug('[GameMakerGlobal]file:assets:/ 开头，需额外处理');
            //return;
        }
        else
            gameMakerGlobal = GameMakerGlobal;

        /*if($Frame.sl_globalObject().GameMakerGlobal && $Frame.sl_globalObject().GameMakerGlobal !== gameMakerGlobal) {
            console.warn('[!GameMakerGlobal]已存在不同单例类');
            return;
        }

        delete $Frame.sl_globalObject().GameMakerGlobalJS;
        delete $Frame.sl_globalObject().$GameMakerGlobalJS;
        delete $Frame.sl_globalObject().GameMakerGlobal;
        delete $Frame.sl_globalObject().$GameMakerGlobal;
        */



        --GameMakerSingleton.nOpenCount;



        console.debug('[GameMakerGlobal]Component.onDestruction');
    }
}
