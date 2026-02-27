pragma Singleton

import QtQuick 2.14
import Qt.labs.settings 1.1


//引入Qt定义的类
//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
//import _Global.Button 1.0


import 'qrc:/QML'


import 'GameMakerGlobal.js' as GameMakerGlobalJS

//import 'File.js' as File



QtObject {
    id: root
    objectName: 'GameMakerGlobal'

    //引擎版本
    readonly property string version: '1.15.3.250209'

    readonly property string separator: $Platform.sl_separator(true)

    //保存 Component 附加组件
    //单例的一个BUG：使用单例对象无法访问到Component，但内部使用root可以访问到；
    readonly property var $component: Component //root.Component



    //可存储配置
    //  目前存储：Projects/工程名（game.cd引擎变量，用到了$sys_sound）、$RunTimes、$RunDuration
    readonly property Settings settings: Settings {
        id: settings
        category: 'GameMaker'    //类别
        //fileName: 'GameMaker.ini'
        //fileName: parseInt($Frame.sl_configValue('RunType')) === 0 ? '' : 'GameMaker.ini'

        //当前工程
        property string $CurrentProjectName: ''  //'Project'
        property int $RunTimes: 0
        property int $RunDuration: 0
    }



    readonly property QtObject config: QtObject { //配置
        //调试（游戏显示一些调试功能，比如存档不检测、游戏场景显示FPS、战场上显示调试按钮）
        //property bool bDebug: Global.frameConfig.$sys.debug === 0 ? false : true
        //property bool bDebug: parseInt($Frame.config.Debug) === 0 ? false : true
        //property bool bDebug: parseInt($Frame.sl_configValue('Debug', 0)) === 0 ? false : true
        property bool bDebug: true


        //当前项目名称
        property alias strCurrentProjectName: settings.$CurrentProjectName    //'Project'

        //引擎工作目录
        property string strWorkPath: {
            switch(Qt.platform.os) {
            case 'android':
            case 'openharmony':
                return $Platform.externalDataPath + separator + 'GameMaker' + separator;
                //return 'assets:/';   //'./'  //':/'
            case 'windows':
                //if($Platform.compileType === 'debug')
                //    return 'F:/_Projects/Pets/MakerFrame/GameMaker/';
                //return $Platform.externalDataPath + separator + 'GameMaker' + separator;
            default:
                return $Platform.externalDataPath + separator + 'GameMaker' + separator;
                //return './';
            }
        }

        //项目根目录
        property string strProjectRootPath: {
            return strWorkPath + 'Projects/';
        }

        //存档目录
        property string strSaveDataPath: {
            switch(Qt.platform.os) {
            case 'android':
                return strWorkPath + 'SaveData' + separator + strCurrentProjectName + separator;
                //return $Platform.externalDataPath + separator + 'Games' + separator + strCurrentProjectName + separator + 'SaveData' + separator;
                //return $Platform.sl_getSdcardPath() + separator + 'Leamus' + separator + 'Games' + separator + strCurrentProjectName + separator + 'SaveData' + separator;
            case 'windows':
            default:
                return strWorkPath + 'SaveData' + separator + strCurrentProjectName + separator;
                //return 'SaveData' + separator;
            }
        }

        property url urlGameMakerCorePath: Qt.resolvedUrl('..')


        //数据文件存储 目录名
        property string strMapDirName: 'Maps'
        property string strRoleDirName: 'Roles'
        property string strSpriteDirName: 'Sprites'
        property string strGoodsDirName: 'Goods'
        property string strFightRoleDirName: 'FightRoles'
        property string strFightSkillDirName: 'FightSkills'
        property string strFightScriptDirName: 'FightScripts'

        //资源 目录名
        property string strResourceDirName: 'Resources'
        property string strMapResourceDirName: strResourceDirName + separator + 'Maps'
        property string strSpriteResourceDirName: strResourceDirName + separator + 'Sprites'
        property string strGoodsResourceDirName: strResourceDirName + separator + 'Goods'
        property string strImageResourceDirName: strResourceDirName + separator + 'Images'
        property string strMusicResourceDirName: strResourceDirName + separator + 'Music'
        property string strSoundResourceDirName: strResourceDirName + separator + 'Sounds'
        property string strVideoResourceDirName: strResourceDirName + separator + 'Videos'


        //TapTap 开发者中心对应 ClientID和ClientToken，为空表示不使用tap验证
        //readonly property string strTDSClientID: ''
        //readonly property string strTDSClientToken: ''
    }



    //下面函数是返回 某类型资源 的绝对路径（参数都是可选）

    function mapResourceURL(filepath) {return $GlobalJS.toURL(mapResourcePath(filepath));}
    function mapResourcePath(filepath) {
        let ret = config.strProjectRootPath + config.strCurrentProjectName + separator + config.strMapResourceDirName;
        if(filepath)
            return ret + separator + filepath;
        return ret;
    }
    function spriteResourceURL(filepath) {return $GlobalJS.toURL(spriteResourcePath(filepath));}
    function spriteResourcePath(filepath) {
        let ret = config.strProjectRootPath + config.strCurrentProjectName + separator + config.strSpriteResourceDirName;
        if(filepath)
            return ret + separator + filepath;
        return ret;
    }
    function goodsResourceURL(filepath) {return $GlobalJS.toURL(goodsResourcePath(filepath));}
    function goodsResourcePath(filepath) {
        let ret = config.strProjectRootPath + config.strCurrentProjectName + separator + config.strGoodsResourceDirName;
        if(filepath)
            return ret + separator + filepath;
        return ret;
    }


    function soundResourceURL(filepath) {return $GlobalJS.toURL(soundResourcePath(filepath));}
    function soundResourcePath(filepath='') {
        // /开始的目录，则相对于项目根路径
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        //绝对目录
        else if(filepath.includes(':'))
            return $GlobalJS.toPath(filepath);
        //相对目录
        else {
            let ret = config.strProjectRootPath + config.strCurrentProjectName + separator + config.strSoundResourceDirName;
            if(filepath)
                return ret + separator + filepath;
            return ret;
        }
    }

    function musicResourceURL(filepath) {return $GlobalJS.toURL(musicResourcePath(filepath));}
    function musicResourcePath(filepath='') {
        // /开始的目录，则相对于项目根路径
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        //绝对目录
        else if(filepath.includes(':'))
            return $GlobalJS.toPath(filepath);
        //相对目录
        else {
            let ret = config.strProjectRootPath + config.strCurrentProjectName + separator + config.strMusicResourceDirName;
            if(filepath)
                return ret + separator + filepath;
            return ret;
        }
    }

    function imageResourceURL(filepath) {return $GlobalJS.toURL(imageResourcePath(filepath));}
    function imageResourcePath(filepath='') {
        // /开始的目录，则相对于项目根路径
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        //绝对目录
        else if(filepath.includes(':'))
            return $GlobalJS.toPath(filepath);
        //相对目录
        else {
            let ret = config.strProjectRootPath + config.strCurrentProjectName + separator + config.strImageResourceDirName;
            if(filepath)
                return ret + separator + filepath;
            return ret;
        }
    }

    function videoResourceURL(filepath) {return $GlobalJS.toURL(videoResourcePath(filepath));}
    function videoResourcePath(filepath='') {
        // /开始的目录，则相对于项目根路径
        if(filepath.startsWith('/'))
            return config.strProjectRootPath + config.strCurrentProjectName + filepath;
        //绝对目录
        else if(filepath.includes(':'))
            return $GlobalJS.toPath(filepath);
        //相对目录
        else {
            let ret = config.strProjectRootPath + config.strCurrentProjectName + separator + config.strVideoResourceDirName;
            if(filepath)
                return ret + separator + filepath;
            return ret;
        }
    }



    //使用时长
    readonly property Timer timer: Timer {
        //id: timer

        property var nLastTime: new Date().getTime()

        repeat: true
        interval: 6000
        triggeredOnStart: false
        running: true
        onRunningChanged: {
            //if(running === true)
            //    nLastTime = new Date().getTime();
        }

        onTriggered: {
            let now = new Date().getTime();
            settings.$RunDuration += parseInt((now - nLastTime) / 1000);
            nLastTime = now;
        }
    }



    Component.onCompleted: {
        let gameMakerGlobal;
        //!!解决 assets BUG
        if(Qt.resolvedUrl('.').startsWith('file:assets:/')) {
            gameMakerGlobal = root;
            console.info('[GameMakerGlobal]file:assets:/ 开头，需额外处理');
            if(Qt.platform.os !== 'android')
                console.warn('[!GameMakerGlobal]非安卓环境？');
            //return;
        }
        else
            gameMakerGlobal = GameMakerGlobal;

        if($Frame.sl_globalObject().GameMakerGlobal && $Frame.sl_globalObject().GameMakerGlobal !== gameMakerGlobal) {
            const msg = '已存在不同GameMakerGlobal单例类，请重启框架或返回原引擎，否则数据出错';
            console.warn('[!GameMakerGlobal]' + msg);

            Global.globalData.$components.dialog.show({
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



        if($Platform.compileType === 'release') {
            //提交访问信息
            $GlobalJS.sendUsage({
                Times: settings.$RunTimes,
                Duration: settings.$RunDuration,
                Product: `${settings.category}_${$Platform.sysInfo.buildCpuArchitecture}_${version}(${$Platform.compileType})`,
            });
        }



        $Frame.sl_addImportPath(config.urlGameMakerCorePath);



        console.debug('[GameMakerGlobal]Component.onCompleted:', gameMakerGlobal, GameMakerGlobalJS/*, $window*/, gameMakerGlobal.Component, root.Component, gameMakerGlobal === root, Qt.resolvedUrl('.'), );
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

        if($Frame.sl_globalObject().GameMakerGlobal && $Frame.sl_globalObject().GameMakerGlobal !== gameMakerGlobal) {
            console.warn('[!GameMakerGlobal]已存在不同单例类');
            return;
        }

        delete $Frame.sl_globalObject().GameMakerGlobalJS;
        delete $Frame.sl_globalObject().$GameMakerGlobalJS;
        delete $Frame.sl_globalObject().GameMakerGlobal;
        delete $Frame.sl_globalObject().$GameMakerGlobal;



        console.debug('[GameMakerGlobal]Component.onDestruction');
    }
}
