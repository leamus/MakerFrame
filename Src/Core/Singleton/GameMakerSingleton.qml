pragma Singleton

import QtQuick 2.14
import Qt.labs.settings 1.1

import '../Config.js' as Config

QtObject {
    id: root


    //本路径的引擎打开多少次（1个应用内）
    property int nOpenCount: 0


    //可存储配置
    //  目前存储：Projects/工程名（game.cd引擎变量，用到了$sys_sound）、$RunTimes、$RunDuration
    readonly property Settings settings: Settings {
        id: settings
        category: Config.AppName //'GameMaker' //应用名 或 类别
        //fileName: Config.AppName + '.ini' //'GameMaker.ini'
        //fileName: parseInt($Frame.sl_configValue('RunType')) === 0 ? '' : Config.AppName + '.ini'

        //当前工程
        property string $CurrentProjectName: 'Project'
        property int $RunTimes: 0
        property int $RunDuration: 0
    }


    //使用时长
    readonly property Timer timer: Timer {
        //id: timer

        property int nLastTime: new Date().getTime()

        repeat: true
        interval: 6000
        triggeredOnStart: false
        running: nOpenCount > 0
        onRunningChanged: {
            //if(running === true)
            //    nLastTime = new Date().getTime();
        }

        onTriggered: {
            console.debug('[GameMakerSingleton]onTriggered');

            let now = new Date().getTime();
            settings.$RunDuration += parseInt((now - nLastTime) / 1000);
            nLastTime = now;
        }
    }



    Component.onCompleted: {
        const urlGameMakerCorePath = Qt.resolvedUrl('..');
        $Frame.sl_addImportPath(urlGameMakerCorePath);


        $Global.globalData.$GameMakerSingleton[Qt.resolvedUrl('.')] = this;
        if($Global.globalData.$GameMakerSingleton.$$keys.length > 1) {
            console.info('[GameMakerSingleton]建议不要多开不同路径的游戏引擎:', $Global.globalData.$GameMakerSingleton.$$keys);
        }



        console.debug('[GameMakerSingleton]Component.onCompleted:', settings, Qt.resolvedUrl('.'), );
    }
    Component.onDestruction: {
        console.debug('[GameMakerSingleton]Component.onDestruction');
    }
}
