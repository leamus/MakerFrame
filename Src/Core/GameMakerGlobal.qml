pragma Singleton

import QtQuick 2.14
import Qt.labs.settings 1.1


QtObject {

    //可存储配置
    property Settings settings: Settings {
        id: settings
        category: "RPGMaker"    //类别
        //fileName: 'RPGMaker.ini'

        property string strCurrentProjectName: "Project"
    }



    property string separator: Platform.separator(true)

    //引擎版本
    property string version: "1.6.20.231130"


    //配置
    property QtObject config: QtObject {
        //调试（显示一些调试功能）
        //property bool debug: Global.frameConfig.$sys.debug === 0 ? false : true
        //property bool debug: parseInt(FrameManager.config.Debug) === 0 ? false : true
        //property bool debug: parseInt(FrameManager.configValue('Debug', 0, 'File')) === 0 ? false : true
        property bool debug: true


        //当前项目名称
        property alias strCurrentProjectName: settings.strCurrentProjectName    //"Project"

        //项目根目录
        property string strProjectRootPath: {
            switch(Qt.platform.os) {
            case 'android':
                return Platform.getExternalDataPath() + separator + "RPGMaker" + separator + "Projects";
                //return "assets:";   //"."  //'qrc:'
            case 'windows':
            default:
                return "RPGMaker" + separator + "Projects";
                //return '.';
            }
        }

        //存档目录
        property string strSaveDataPath: {
            switch(Qt.platform.os) {
            case 'android':
                return Platform.getExternalDataPath() + separator + "RPGMaker" + separator + "SaveData" + separator + strCurrentProjectName;
                //return Platform.getExternalDataPath() + separator + "RPGGame" + separator + strCurrentProjectName + separator + "SaveData";
                //return Platform.getSdcardPath() + separator + "Leamus" + separator + "RPGGame" + separator + strCurrentProjectName + separator + "SaveData";
            case 'windows':
            default:
                return "RPGMaker" + separator + "SaveData" + separator + strCurrentProjectName;
                //return "SaveData";
            }
        }


        //数据文件存储 目录名
        property string strMapDirName: "Maps"
        property string strRoleDirName: "Roles"
        property string strSpriteDirName: "Sprites"
        property string strGoodsDirName: "Goods"
        property string strFightRoleDirName: "FightRoles"
        property string strFightSkillDirName: "FightSkills"
        property string strFightScriptDirName: "FightScripts"

        //资源 目录名
        property string strResourceDirName: "Resources"
        property string strMapResourceDirName: strResourceDirName + separator + "Maps"
        property string strRoleResourceDirName: strResourceDirName + separator + "Roles"
        property string strSpriteResourceDirName: strResourceDirName + separator + "Sprites"
        property string strGoodsResourceDirName: strResourceDirName + separator + "Goods"
        property string strImageResourceDirName: strResourceDirName + separator + "Images"
        property string strMusicResourceDirName: strResourceDirName + separator + "Music"
        property string strSoundResourceDirName: strResourceDirName + separator + "Sounds"
        property string strVideoResourceDirName: strResourceDirName + separator + "Videos"

    }


    //TapTap 开发者中心对应 Client ID，为空表示不使用tap验证
    //property string tds_ClientID: 'wpgisjxcdrwf0nnzdr'



    //下面函数是返回 某类型资源 的绝对路径（参数都是可选）

    function mapResourceURL(filepath) {
        let ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strMapResourceDirName;
        if(filepath)
            return ret + separator + filepath;
        return ret;
    }
    function roleResourceURL(filepath) {
        let ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strRoleResourceDirName;
        if(filepath)
            return ret + separator + filepath;
        return ret;
    }
    function spriteResourceURL(filepath) {
        let ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strSpriteResourceDirName;
        if(filepath)
            return ret + separator + filepath;
        return ret;
    }
    function goodsResourceURL(filepath) {
        let ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strGoodsResourceDirName;
        if(filepath)
            return ret + separator + filepath;
        return ret;
    }


    function soundResourceURL(filepath) {
        let ret;

        if(!filepath)
            filepath = '';

        //协议
        if(
            filepath.indexOf("file:") === 0 ||
            //filepath.indexOf(":/") === 0 ||
            filepath.indexOf("qrc:") === 0 ||
            filepath.indexOf("assets:") === 0 ||
            filepath.indexOf("http:") === 0 ||
            filepath.indexOf("https:") === 0 ||
            filepath.indexOf("ftp:") === 0 ||
            filepath.indexOf("ftps:") === 0
        )
            return filepath;
        else if(filepath.indexOf(":/") === 0)
            ret = 'qrc';
        //绝对目录，则相对于项目根路径
        else if(filepath.indexOf("/") === 0)
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName;
        //相对目录
        else
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strSoundResourceDirName;

        if(filepath)
            return ret + separator + filepath;

        return ret;
    }

    function musicResourceURL(filepath) {
        let ret;

        if(!filepath)
            filepath = '';

        //协议
        if(
            filepath.indexOf("file:") === 0 ||
            //filepath.indexOf(":/") === 0 ||
            filepath.indexOf("qrc:") === 0 ||
            filepath.indexOf("assets:") === 0 ||
            filepath.indexOf("http:") === 0 ||
            filepath.indexOf("https:") === 0 ||
            filepath.indexOf("ftp:") === 0 ||
            filepath.indexOf("ftps:") === 0
        )
            return filepath;
        else if(filepath.indexOf(":/") === 0)
            ret = 'qrc';
        //绝对目录，则相对于项目根路径
        else if(filepath.indexOf("/") === 0)
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName;
        //相对目录
        else
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strMusicResourceDirName;

        if(filepath)
            return ret + separator + filepath;

        return ret;
    }

    function imageResourceURL(filepath) {
        let ret;

        if(!filepath)
            filepath = '';

        //协议
        if(
            filepath.indexOf("file:") === 0 ||
            //filepath.indexOf(":/") === 0 ||
            filepath.indexOf("qrc:") === 0 ||
            filepath.indexOf("assets:") === 0 ||
            filepath.indexOf("http:") === 0 ||
            filepath.indexOf("https:") === 0 ||
            filepath.indexOf("ftp:") === 0 ||
            filepath.indexOf("ftps:") === 0
        )
            return filepath;
        else if(filepath.indexOf(":/") === 0)
            ret = 'qrc';
        //绝对目录，则相对于项目根路径
        else if(filepath.indexOf("/") === 0)
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName;
        //相对目录
        else
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strImageResourceDirName;

        if(filepath)
            return ret + separator + filepath;

        return ret;
    }

    function videoResourceURL(filepath) {
        let ret;

        if(!filepath)
            filepath = '';

        //协议
        if(
            filepath.indexOf("file:") === 0 ||
            //filepath.indexOf(":/") === 0 ||
            filepath.indexOf("qrc:") === 0 ||
            filepath.indexOf("assets:") === 0 ||
            filepath.indexOf("http:") === 0 ||
            filepath.indexOf("https:") === 0 ||
            filepath.indexOf("ftp:") === 0 ||
            filepath.indexOf("ftps:") === 0
        )
            return filepath;
        else if(filepath.indexOf(":/") === 0)
            ret = 'qrc';
        //绝对目录，则相对于项目根路径
        else if(filepath.indexOf("/") === 0)
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName;
        //相对目录
        else
            ret = config.strProjectRootPath + separator + config.strCurrentProjectName + separator + config.strVideoResourceDirName;

        if(filepath)
            return ret + separator + filepath;

        return ret;
    }

}
