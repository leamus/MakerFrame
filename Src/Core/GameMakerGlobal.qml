pragma Singleton

import QtQuick 2.14
import Qt.labs.settings 1.1


import _Global 1.0


import 'qrc:/QML'


import 'GameMakerGlobal.js' as GameMakerGlobalJS



QtObject {

    //可存储配置
    //  目前存储：$RPG/工程名（game.cd引擎变量）、$PauseMusic、$PauseSound、$RunTimes
    property Settings settings: Settings {
        id: settings
        category: 'RPGMaker'    //类别
        //fileName: 'RPGMaker.ini'

        property string $strCurrentProjectName: 'Project'
    }



    property string separator: Platform.separator(true)

    property url urlRPGCorePath: Qt.resolvedUrl('.')


    //引擎版本
    property string version: '1.7.14.240215'


    //配置
    property QtObject config: QtObject {
        //调试（显示一些调试功能）
        //property bool debug: Global.frameConfig.$sys.debug === 0 ? false : true
        //property bool debug: parseInt(FrameManager.config.Debug) === 0 ? false : true
        //property bool debug: parseInt(FrameManager.configValue('Debug', 0)) === 0 ? false : true
        property bool debug: true


        //当前项目名称
        property alias strCurrentProjectName: settings.$strCurrentProjectName    //'Project'

        //引擎工作目录
        property string strWorkPath: {
            switch(Qt.platform.os) {
            case 'android':
                return Platform.getExternalDataPath() + separator + 'RPGMaker';
                //return 'assets:';   //'.'  //'qrc:'
            case 'windows':
                if(Platform.compileType() === 'release')
                    return 'RPGMaker';
                else
                    return 'F:/_Projects/Pets/MakerFrame/RPGMaker';
            default:
                return 'RPGMaker';
                //return '.';
            }
        }

        //项目根目录
        property string strProjectRootPath: {
            return strWorkPath + separator + 'Projects';
        }

        //存档目录
        property string strSaveDataPath: {
            switch(Qt.platform.os) {
            case 'android':
                return strWorkPath + separator + 'SaveData' + separator + strCurrentProjectName;
                //return Platform.getExternalDataPath() + separator + 'RPGGame' + separator + strCurrentProjectName + separator + 'SaveData';
                //return Platform.getSdcardPath() + separator + 'Leamus' + separator + 'RPGGame' + separator + strCurrentProjectName + separator + 'SaveData';
            case 'windows':
            default:
                return strWorkPath + separator + 'SaveData' + separator + strCurrentProjectName;
                //return 'SaveData';
            }
        }


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
        property string strRoleResourceDirName: strResourceDirName + separator + 'Roles'
        property string strSpriteResourceDirName: strResourceDirName + separator + 'Sprites'
        property string strGoodsResourceDirName: strResourceDirName + separator + 'Goods'
        property string strImageResourceDirName: strResourceDirName + separator + 'Images'
        property string strMusicResourceDirName: strResourceDirName + separator + 'Music'
        property string strSoundResourceDirName: strResourceDirName + separator + 'Sounds'
        property string strVideoResourceDirName: strResourceDirName + separator + 'Videos'

    }


    //TapTap 开发者中心对应 Client ID，为空表示不使用tap验证
    //property string tds_ClientID: 'wpgisjxcdrwf0nnzdr'



    //下面函数是返回 某类型资源 的绝对路径（参数都是可选）

    property var mapResourceURL: filepath=>GlobalJS.toURL(mapResourcePath(filepath))
    function mapResourcePath(filepath) {
        let ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strMapResourceDirName;
        if(filepath)
            return ret + separator + filepath;
        return ret;
    }
    property var roleResourceURL: filepath=>GlobalJS.toURL(roleResourcePath(filepath))
    function roleResourcePath(filepath) {
        let ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strRoleResourceDirName;
        if(filepath)
            return ret + separator + filepath;
        return ret;
    }
    property var spriteResourceURL: filepath=>GlobalJS.toURL(spriteResourcePath(filepath))
    function spriteResourcePath(filepath) {
        let ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strSpriteResourceDirName;
        if(filepath)
            return ret + separator + filepath;
        return ret;
    }
    property var goodsResourceURL: filepath=>GlobalJS.toURL(goodsResourcePath(filepath))
    function goodsResourcePath(filepath) {
        let ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strGoodsResourceDirName;
        if(filepath)
            return ret + separator + filepath;
        return ret;
    }


    property var soundResourceURL: filepath=>GlobalJS.toURL(soundResourcePath(filepath))
    function soundResourcePath(filepath) {
        let ret;

        if(!filepath)
            filepath = '';

        //协议
        if(
            filepath.indexOf('file:') === 0 ||
            //filepath.indexOf(':/') === 0 ||
            filepath.indexOf('qrc:') === 0 ||
            filepath.indexOf('assets:') === 0 ||
            filepath.indexOf('http:') === 0 ||
            filepath.indexOf('https:') === 0 ||
            filepath.indexOf('ftp:') === 0 ||
            filepath.indexOf('ftps:') === 0
        )
            return filepath;
        else if(filepath.indexOf(':/') === 0)
            ret = 'qrc';
        //绝对目录，则相对于项目根路径
        else if(filepath.indexOf('/') === 0)
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName;
        //相对目录
        else
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strSoundResourceDirName;

        if(filepath)
            return ret + separator + filepath;

        return ret;
    }

    property var musicResourceURL: filepath=>GlobalJS.toURL(musicResourcePath(filepath))
    function musicResourcePath(filepath) {
        let ret;

        if(!filepath)
            filepath = '';

        //协议
        if(
            filepath.indexOf('file:') === 0 ||
            //filepath.indexOf(':/') === 0 ||
            filepath.indexOf('qrc:') === 0 ||
            filepath.indexOf('assets:') === 0 ||
            filepath.indexOf('http:') === 0 ||
            filepath.indexOf('https:') === 0 ||
            filepath.indexOf('ftp:') === 0 ||
            filepath.indexOf('ftps:') === 0
        )
            return filepath;
        else if(filepath.indexOf(':/') === 0)
            ret = 'qrc';
        //绝对目录，则相对于项目根路径
        else if(filepath.indexOf('/') === 0)
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName;
        //相对目录
        else
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strMusicResourceDirName;

        if(filepath)
            return ret + separator + filepath;

        return ret;
    }

    property var imageResourceURL: filepath=>GlobalJS.toURL(imageResourcePath(filepath))
    function imageResourcePath(filepath) {
        let ret;

        if(!filepath)
            filepath = '';

        //协议
        if(
            filepath.indexOf('file:') === 0 ||
            //filepath.indexOf(':/') === 0 ||
            filepath.indexOf('qrc:') === 0 ||
            filepath.indexOf('assets:') === 0 ||
            filepath.indexOf('http:') === 0 ||
            filepath.indexOf('https:') === 0 ||
            filepath.indexOf('ftp:') === 0 ||
            filepath.indexOf('ftps:') === 0
        )
            return filepath;
        else if(filepath.indexOf(':/') === 0)
            ret = 'qrc';
        //绝对目录，则相对于项目根路径
        else if(filepath.indexOf('/') === 0)
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName;
        //相对目录
        else
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strImageResourceDirName;

        if(filepath)
            return ret + separator + filepath;

        return ret;
    }

    property var videoResourceURL: filepath=>GlobalJS.toURL(videoResourcePath(filepath))
    function videoResourcePath(filepath) {
        let ret;

        if(!filepath)
            filepath = '';

        //协议
        if(
            filepath.indexOf('file:') === 0 ||
            //filepath.indexOf(':/') === 0 ||
            filepath.indexOf('qrc:') === 0 ||
            filepath.indexOf('assets:') === 0 ||
            filepath.indexOf('http:') === 0 ||
            filepath.indexOf('https:') === 0 ||
            filepath.indexOf('ftp:') === 0 ||
            filepath.indexOf('ftps:') === 0
        )
            return filepath;
        else if(filepath.indexOf(':/') === 0)
            ret = 'qrc';
        //绝对目录，则相对于项目根路径
        else if(filepath.indexOf('/') === 0)
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName;
        //相对目录
        else
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strVideoResourceDirName;

        if(filepath)
            return ret + separator + filepath;

        return ret;
    }



    Component.onCompleted: {
        if(Platform.compileType() === 'release') {
            //提交访问信息
            let url = 'http://MakerFrame.Leamus.cn/api/v1/client/usage';
            let xhr = new XMLHttpRequest;
            xhr.open('POST', url, true);  //建立间接，要求异步响应
            xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');  //设置为表单方式提交
            xhr.onreadystatechange = function() {  //绑定响应状态事件监听函数
                if (xhr.readyState == 4) {  //监听readyState状态
                    if (xhr.status == 200) {  //监听HTTP状态码
                        //console.log('XMLHttpRequest:', xhr.responseText);  //接收数据
                    }
                    else
                        //0, '', '网页内容', object, null, '',
                        console.warn('Request ERROR:', xhr.status, xhr.statusText/*, xhr.responseText*/, xhr, xhr.responseXML, xhr.responseType, url);
                    //infoCallback(JSON.parse(xhr.responseText));
                }
                //else
                //    console.warn('!!!error readyState:', xhr.readyState, FrameManager.configValue('InfoJsonURL'))
            }
            xhr.send(`client=${Platform.sysInfo.prettyProductName}_${Platform.sysInfo.currentCpuArchitecture}(${Platform.compileType()})&product=${settings.category}_${Platform.sysInfo.buildCpuArchitecture}_${version}&serial=${Platform.sysInfo.machineUniqueId}${Qt.platform.os==='android'?'_'+Platform.getSerialNumber():''}&timestamp=${Number(new Date())}`);  //发送请求
            //xhr.send();
        }


        FrameManager.addImportPath(urlRPGCorePath);


        console.debug('[GameMakerGlobal]Component.onCompleted:', GameMakerGlobalJS);
    }
    Component.onDestruction: {
        console.debug('[GameMakerGlobal]Component.onDestruction');
    }
}
