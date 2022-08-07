pragma Singleton

import QtQuick 2.14
import Qt.labs.settings 1.1


QtObject {

    property Settings settings: Settings {
        id: settings
        category: "GameMakerGlobal"    //类别
    }



    property string version: "0.8.10"


    property QtObject config: QtObject {
        //项目根目录
        property string strProjectPath: Platform.getExternalDataPath() + Platform.separator() + "GameMaker" + Platform.separator() + "Projects"

        //数据配置 目录名
        property string strMapDirName: "Maps"
        property string strRoleDirName: "Roles"
        property string strSpriteDirName: "Sprites"
        property string strGoodsDirName: "Goods"
        property string strFightRoleDirName: "FightRoles"
        property string strFightSkillDirName: "FightSkills"
        property string strFightScriptDirName: "FightScripts"

        //资源目录名
        property string strResourceDirName: "Resources"
        property string strMapResourceDirName: strResourceDirName + Platform.separator() + "Maps"
        property string strRoleResourceDirName: strResourceDirName + Platform.separator() + "Roles"
        property string strSpriteResourceDirName: strResourceDirName + Platform.separator() + "Sprites"
        property string strGoodsResourceDirName: strResourceDirName + Platform.separator() + "Goods"
        property string strSoundResourceDirName: strResourceDirName + Platform.separator() + "Sounds"
        property string strMusicResourceDirName: strResourceDirName + Platform.separator() + "Music"
        property string strImageResourceDirName: strResourceDirName + Platform.separator() + "Images"

        property string strCurrentProjectName: "Project"

        property string strSaveDataPath: Platform.getExternalDataPath() + Platform.separator() + "GameMaker" + Platform.separator() + "SaveData" + Platform.separator() + strCurrentProjectName
    }

    //资源 相对转绝对
    function mapResourceURL(filepath) {
        let ret = config.strProjectPath + Platform.separator() + config.strCurrentProjectName + Platform.separator() + config.strMapResourceDirName;
        if(filepath)
            return ret + Platform.separator() + filepath;
        return ret;
    }
    function roleResourceURL(filepath) {
        let ret = config.strProjectPath + Platform.separator() + config.strCurrentProjectName + Platform.separator() + config.strRoleResourceDirName;
        if(filepath)
            return ret + Platform.separator() + filepath;
        return ret;
    }
    function spriteResourceURL(filepath) {
        let ret = config.strProjectPath + Platform.separator() + config.strCurrentProjectName + Platform.separator() + config.strSpriteResourceDirName;
        if(filepath)
            return ret + Platform.separator() + filepath;
        return ret;
    }
    function goodsResourceURL(filepath) {
        let ret = config.strProjectPath + Platform.separator() + config.strCurrentProjectName + Platform.separator() + config.strGoodsResourceDirName;
        if(filepath)
            return ret + Platform.separator() + filepath;
        return ret;
    }
    function soundResourceURL(filepath) {
        let ret = config.strProjectPath + Platform.separator() + config.strCurrentProjectName + Platform.separator() + config.strSoundResourceDirName;
        if(filepath)
            return ret + Platform.separator() + filepath;
        return ret;
    }
    function musicResourceURL(filepath) {
        let ret = config.strProjectPath + Platform.separator() + config.strCurrentProjectName + Platform.separator() + config.strMusicResourceDirName;
        if(filepath)
            return ret + Platform.separator() + filepath;
        return ret;
    }
    function imageResourceURL(filepath) {
        let ret = config.strProjectPath + Platform.separator() + config.strCurrentProjectName + Platform.separator() + config.strImageResourceDirName;
        if(filepath)
            return ret + Platform.separator() + filepath;
        return ret;
    }



    /*

    property int nFullScreen: {
        switch(Qt.platform.os) {
            case "android":
                return 1;
            default:
                if(Platform.compileType() === "release")
                    return 1;
                else
                    return 2;
        }
    }

    //1
    property int nOrient: 0





    //声音
    property bool bSoundOn: true

    property bool bMusicOn: true
    property bool bEffectOn: true


    */
}
