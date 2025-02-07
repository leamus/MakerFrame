import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


////import GameComponents 1.0
//import 'Core/GameComponents'


import 'qrc:/QML'


//import './Core'


//import 'File.js' as File



Item {
    id: root


    signal sg_close();



    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        color: Global.style.backgroundColor
        //opacity: 0
    }


    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: parent.height * 0.9

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: '*打包文件夹路径:'
            }

            TextField {
                id: textPackageDirPath

                Layout.fillWidth: true

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextField.Wrap
            }

            Button {
                text: '选择'
                onClicked: {
                    filedialog.open();
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: '*游戏名：'
            }
            TextField {
                id: textGameName

                Layout.fillWidth: true

                placeholderText: '游戏名'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextField.Wrap

            }
        }

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: '*应用包名：'
            }
            TextField {
                id: textPackageName

                Layout.fillWidth: true

                placeholderText: '应用包名'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextField.Wrap

            }
        }

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: '图标:'
            }

            TextField {
                id: textIconPath

                Layout.fillWidth: true

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextField.Wrap
            }

            Image {
                id: imageIcon

                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                //width: 50
                //height: 50
            }

            Button {
                text: '选择'
                onClicked: {
                    filedialogIcon.open();
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: 'Tap Client ID：'
            }
            TextField {
                id: textTapClientID

                Layout.fillWidth: true

                placeholderText: '为空则不使用Tap实名认证'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextField.Wrap

            }
        }

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: 'Tap Client Token：'
            }
            TextField {
                id: textTapClientToken

                Layout.fillWidth: true

                placeholderText: ''

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextField.Wrap

            }
        }

        Label {
            Layout.fillWidth: true

            wrapMode: Label.Wrap
            text: {
                if(Qt.platform.os === 'android')
                    return '<font color="red">注意：Android 下打包，需要安装 Apktool M 或 MT 软件辅助</font>'
                else if(Qt.platform.os === 'windows')
                    return '<font color="red">注意：Windows 下打包，需要安装 Java 环境 和 Apktools 软件辅助</font>'
            }
        }

        Notepad {
            id: textResult

            Layout.fillWidth: true
            Layout.fillHeight: true


            textArea.background: Rectangle {
                //implicitWidth: 200
                //implicitHeight: 40
                color: Global.style.backgroundColor
                border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                border.width: parent.parent.textArea.activeFocus ? 2 : 1
            }
            //textArea.color: Global.style.foreground
            //textArea.readOnly: true
            textArea.selectByMouse: false

        }

        Button {
            Layout.alignment: Qt.AlignCenter

            text: '生　成'
            onClicked: {
                _private.makePackage();
            }
        }
    }



    //打开工程 对话框
    Dialog1.FileDialog {
        id: filedialog

        visible: false

        title: '选择文件夹'
        //folder: shortcuts.home
        folder: GlobalJS.toURL(GameMakerGlobal.config.strProjectRootPath)
        //nameFilters: [ 'zip files (*.zip)', 'All files (*)' ]

        selectMultiple: false
        selectExisting: true
        selectFolder: true

        onAccepted: {
            //loader.focus = true;
            //loader.forceActiveFocus();
            //rootGameMaker.focus = true;
            //rootGameMaker.forceActiveFocus();

            console.debug('[AndroidConfigure]You chose: ' + fileUrl, fileUrls);


            let fUrl;
            if(Qt.platform.os === 'android')
                //注意：content://com.android.externalstorage.documents/tree转换真实路径时会报错：
                fUrl = GlobalJS.toPath(Platform.sl_getRealPathFromURI(fileUrl.toString().replace('content://com.android.externalstorage.documents/tree', 'content://com.android.externalstorage.documents/document')));
            else
                fUrl = GlobalJS.toPath(FrameManager.sl_urlDecode(fileUrl.toString()));

            textPackageDirPath.text = fUrl;
            _private.init();

            root.forceActiveFocus();
        }
        onRejected: {
            //rootGameMaker.forceActiveFocus();


            //sg_close();
            console.debug('[AndroidConfigure]onRejected');
            //Qt.quit()

        }
        Component.onCompleted: {
            //visible = true;
        }
    }

    Dialog1.FileDialog {
        id: filedialogIcon

        visible: false

        title: '选择图标文件'
        //folder: shortcuts.home
        nameFilters: [ 'PNG files (*.png)', 'All files (*)' ]

        selectMultiple: false
        selectExisting: true
        selectFolder: false

        onAccepted: {
            console.debug('[AndroidConfigure]You chose: ' + fileUrl, fileUrls, typeof(fileUrl), JSON.stringify(fileUrl));
            /*let strFileUrl = fileUrl.toString();

            if(Qt.platform.os === 'android') {
                if(strFileUrl.indexOf('primary') >= 0) {
                    textImageResourceName.text = 'file:/storage/emulated/0/' + strFileUrl.substr(strFileUrl.indexOf('%3A')+3);
                }
                else if(strFileUrl.indexOf('document/') >= 0) {
                    let tt = strFileUrl.indexOf('%3A');
                    textImageResourceName.text = 'file:/storage/' + strFileUrl.slice(strFileUrl.indexOf('/document/') + '/document/'.length, tt) + '/' + strFileUrl.slice(tt + 3);
                }
                else
                    textImageResourceName.text = fileUrl;
            }
            else
                textImageResourceName.text = fileUrl;
            */

            let path;
            if(Qt.platform.os === 'android')
                path = Platform.sl_getRealPathFromURI(fileUrl);
            else
                path = FrameManager.sl_urlDecode(fileUrl);

            textIconPath.text = GlobalJS.toURL(path);
            imageIcon.source = GlobalJS.toURL(path);
        }

        onRejected: {
            //gameMap.forceActiveFocus();

            console.debug('[AndroidConfigure]onRejected')
            //Qt.quit();
        }
        Component.onCompleted: {
            //visible = true;
        }
    }



    QObject {
        id: _private

        //property string strPackageDir: 'D:/Documents/Desktop/QtEnv/_MakerFrame/Packages/Android/MakerFrame_鹰歌软件框架游戏引擎_ALL_Qt5.15.2'
        property alias strPackageDir: textPackageDirPath.text

        //初始化，读取配置
        function init() {
            textGameName.text = '';
            textPackageName.text = '';
            textIconPath.text = '';
            textTapClientID.text = '';
            textTapClientToken.text = '';
            textResult.text = '';


            if(!FrameManager.sl_fileExists(_private.strPackageDir + '/AndroidManifest.xml')) {
                textResult.text = '没有找到打包文件夹，请配置后点击“生成”按钮';
                return false;
            }


            let error = 0;

            let content;
            let reg;
            let res;

            imageIcon.source = GlobalJS.toURL(_private.strPackageDir) + '/res/drawable-ldpi/icon.png';


            content = FrameManager.sl_fileRead(_private.strPackageDir + '/assets/QML/GameRuntime/GameMakerGlobal.qml');
            if(!content) {
                textResult.text += '读取 GameMakerGlobal.qml 失败\r\n';
                ++error;
            }

            reg = /category: '(\S*)'/g;
            res = reg.exec(content);
            textGameName.text = res[1];

            reg = /property string strTDSClientID: '(\w*)'/g;
            res = reg.exec(content);
            textTapClientID.text = res[1];

            reg = /property string strTDSClientToken: '(\w*)'/g;
            res = reg.exec(content);
            textTapClientToken.text = res[1];


            content = FrameManager.sl_fileRead(_private.strPackageDir + '/AndroidManifest.xml');
            if(!content) {
                textResult.text += '读取 AndroidManifest.xml 失败\r\n';
                ++error;
            }

            reg = /package="(\S*)"/g;
            res = reg.exec(content);
            textPackageName.text = res[1];


            if(error === 0)
                textResult.text = '读取打包文件夹配置成功';
        }

        //修改配置文件（GameMakerGlobal.qml、AndroidManifest.xml）
        function modifyConfig() {
            let content;
            let reg;
            let res;

            textResult.text = '';


            content = FrameManager.sl_fileRead(_private.strPackageDir + '/assets/QML/GameRuntime/GameMakerGlobal.qml');
            if(!content)
                textResult.text += '读取 GameMakerGlobal.qml 失败\r\n';
            else {
                reg = /(category: ')\S*(')/g;
                content = content.replace(reg, '$1' + textGameName.text + '$2');

                reg = /(property string strTDSClientID: ')\w*(')/g;
                content = content.replace(reg, '$1' + textTapClientID.text + '$2');

                reg = /(property string strTDSClientToken: ')\w*(')/g;
                content = content.replace(reg, '$1' + textTapClientToken.text + '$2');


                res = FrameManager.sl_fileWrite(content, _private.strPackageDir + '/assets/QML/GameRuntime/GameMakerGlobal.qml');
                if(res === 0) {
                    textResult.text += '写入 GameMakerGlobal.qml 成功\r\n';
                }
                else
                    textResult.text += '写入 GameMakerGlobal.qml 失败\r\n';
                //console.warn(content);
            }

            content = FrameManager.sl_fileRead(_private.strPackageDir + '/AndroidManifest.xml');
            if(!content)
                textResult.text += '读取 AndroidManifest.xml 失败\r\n';
            else {
                reg = /(android:label=")\S*(")/g;
                content = content.replace(reg, '$1' + textGameName.text + '$2');


                reg = /(package=")\S*(")/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');

                reg = /(android:name=")\S*(\.openadsdk.permission.TT_PANGOLIN)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');

                reg = /(android:name=")\S*(\.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');

                reg = /(android:authorities=")\S*(\.TTFileProvider)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.TTMultiProvider)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.com\.tds\.ad\.fileprovider)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.com\.tapsdk\.tapad\.okdownload)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                //reg = /(android:authorities=")\S*(\.tap_config\.provider)/g;
                //content = content.replace(reg, '$1' + textPackageName.text + '$2');
                //reg = /(android:authorities=")\S*(\.tap_user\.provider)/g;
                //content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.pangle\.servermanager\.downloader\.com\.bytedance\.sdk\.openadsdk\.adhost)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.pangle\.servermanager\.main)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.pangle\.provider\.proxy\.main)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.pangle\.fileprovider)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.bytedance\.android\.openliveplugin\.process\.server\.LiveServerManager)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.pangle\.servermanager\.bytelive\.com\.byted\.live\.lite)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.pangle\.servermanager\.push\.com\.byted\.live\.lite)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.androidx-startup)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.TapTapKitInitProvider)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.themisLite)/g;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');

                reg = /\$\{applicationId\}/g;
                content = content.replace(reg, textPackageName.text);


                res = FrameManager.sl_fileWrite(content, _private.strPackageDir + '/AndroidManifest.xml');
                if(res === 0) {
                    textResult.text += '写入 AndroidManifest.xml 成功\r\n';
                }
                else
                    textResult.text += '写入 AndroidManifest.xml 失败\r\n';
                //console.warn(content);
            }


            //复制 icon
            if(FrameManager.sl_fileExists(GlobalJS.toPath(textIconPath.text))) {
                FrameManager.sl_fileCopy(GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-hdpi/icon.png', true);
                FrameManager.sl_fileCopy(GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-ldpi/icon.png', true);
                FrameManager.sl_fileCopy(GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-mdpi/icon.png', true);
                FrameManager.sl_fileCopy(GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-xhdpi/icon.png', true);
                FrameManager.sl_fileCopy(GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-xxhdpi/icon.png', true);
                FrameManager.sl_fileCopy(GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-xxxhdpi/icon.png', true);
            }
        }

        //制作打包环境
        function makePackage() {
            let path = Platform.externalDataPath + GameMakerGlobal.separator + 'GameMaker' + GameMakerGlobal.separator + 'Games';

            let zipFiles = FrameManager.sl_dirList(path, ['MakerFrame_*.zip'], 0x002 | 0x2000 | 0x4000, 0);
            zipFiles.sort();
            console.debug('[PackageAndroid]makePackage zip files:', zipFiles);

            /*let needFilesName = ['Android_Package_', 'Android_MakerFrame_GameRuntime_'];
            let needFilesIndex = [];
            for(let fileName in zipFiles) {
                for(let needFileName in needFilesName) {
                    if(zipFiles[fileName].indexOf(needFilesName[needFileName]) >= 0) {
                        needFilesIndex[needFileName] = fileName;
                        break;
                    }
                }
            }
            */

            let missingFiles = '';
            if(!zipFiles[0] || zipFiles[0].indexOf('MakerFrame_GameRuntime_Android_') < 0)
                missingFiles += 'MakerFrame_GameRuntime_Android_xxx.zip,';
            if(!zipFiles[1] || zipFiles[1].indexOf('MakerFrame_Package_Android_') < 0)
                missingFiles += 'MakerFrame_Package_Android_xxx.zip,';

            if(missingFiles !== '') {
                rootWindow.aliasGlobal.dialogCommon.show({
                    Msg: '请将 <font color="red">%1</font> 文件下载并放入 <font color="red">%2</font> 文件夹下（文件可以在Q群或gitee里下载）'.arg(missingFiles).arg(path),
                    Buttons: Dialog.Yes,
                    OnAccepted: function() {
                        root.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        root.forceActiveFocus();
                    },
                });
                return false;
            }


            //let strPackageDir = path + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName;

            //1：只更新工程；2：全部更新；
            function continueScript(packageType) {
                rootWindow.aliasGlobal.dialogCommon.show({
                    Msg: '请等待。。。',
                    Buttons: Dialog.NoButton,
                    OnAccepted: function() {
                        rootWindow.aliasGlobal.dialogCommon.open();
                        rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        rootWindow.aliasGlobal.dialogCommon.open();
                        rootWindow.aliasGlobal.dialogCommon.forceActiveFocus();
                    },
                });

                rootWindow.aliasGlobal.showBusyIndicator(true);


                GlobalLibraryJS.setTimeout(function() {
                    let ret;

                    try {
                        if(packageType === 1) {
                            FrameManager.sl_removeRecursively(strPackageDir + GameMakerGlobal.separator + 'assets' + GameMakerGlobal.separator + 'Project');
                        }
                        else if(packageType === 2) {
                            FrameManager.sl_removeRecursively(strPackageDir);
                            ret = FrameManager.sl_extractDir(path + GameMakerGlobal.separator + zipFiles[0], strPackageDir);
                            ret = FrameManager.sl_extractDir(path + GameMakerGlobal.separator + zipFiles[1], strPackageDir);
                        }

                        ret = FrameManager.sl_dirCopy(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName, strPackageDir + GameMakerGlobal.separator + 'assets' + GameMakerGlobal.separator + 'Project', true);
                    } catch(e) {
                        GlobalLibraryJS.printException(e);
                        return;
                    } finally {
                        rootWindow.aliasGlobal.showBusyIndicator(false);

                        rootWindow.aliasGlobal.dialogCommon.close();
                    }


                    modifyConfig();


                    rootWindow.aliasGlobal.dialogCommon.show({
                        Msg: '生成打包文件夹成功，请用三方软件来打包并签名APK（<font color="red">%1</font>）'.arg(strPackageDir),
                        Buttons: Dialog.Yes,
                        OnAccepted: function() {
                            root.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            root.forceActiveFocus();
                        },
                    });
                },200,root);

                //root.forceActiveFocus();
            }

            if(FrameManager.sl_fileExists(strPackageDir + GameMakerGlobal.separator + 'AndroidManifest.xml')) {

                rootWindow.aliasGlobal.dialogCommon.show({
                    Msg: '检测到有旧打包文件夹，Yes（是）：只更新工程；Discard（丢弃）：更新整个打包文件夹<br><font color="red">此操作会删除打包文件夹路径，请确保路径选择正确！</font>',
                    Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                    OnAccepted: function() {
                        continueScript(1);
                    },
                    OnRejected: ()=>{
                        root.forceActiveFocus();
                    },
                    OnDiscarded: ()=>{
                        rootWindow.aliasGlobal.dialogCommon.close();
                        continueScript(2);
                    },
                });
            }
            else {
                rootWindow.aliasGlobal.dialogCommon.show({
                    Msg: '找到：' + zipFiles.join(',') + '是否继续？',
                    Buttons: Dialog.Yes | Dialog.No,
                    OnAccepted: function() {
                        continueScript(2);
                    },
                    OnRejected: ()=>{
                        root.forceActiveFocus();
                    },
                    OnDiscarded: ()=>{
                        root.forceActiveFocus();
                    },
                });
            }

            return true;
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        sg_close();

        console.debug('[PackageAndroid]Keys.onEscapePressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        sg_close();

        console.debug('[PackageAndroid]Keys.onBackPressed');
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug('[PackageAndroid]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
    }
    Keys.onReleased: {
        console.debug('[PackageAndroid]Keys.onReleased:', event.key, event.isAutoRepeat);
    }


    Component.onCompleted: {
        //textPackageDirPath.text = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName;
        textPackageDirPath.text = Platform.externalDataPath + GameMakerGlobal.separator + 'GameMaker' + GameMakerGlobal.separator + 'Games' + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName;
        _private.init();

        console.debug('[PackageAndroid]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[PackageAndroid]Component.onDestruction');
    }
}
