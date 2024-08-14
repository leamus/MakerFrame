import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


////import RPGComponents 1.0
//import 'Core/RPGComponents'


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
                text: '*图标:'
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

                placeholderText: 'Tap Client ID'

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextField.Wrap

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
                border.color: textDebugInfo.textArea.enabled ? "#21be2b" : "transparent"
            }
            textArea.color: 'white'
            //textArea.readOnly: true
            textArea.selectByMouse: false

        }

        Button {
            Layout.alignment: Qt.AlignCenter

            text: '生  成'
            onClicked: {
                _private.makePackage();
            }
        }
    }



    //打开工程 对话框
    Dialog1.FileDialog {
        id: filedialog

        visible: false

        title: "选择文件夹"
        //folder: shortcuts.home
        folder: GlobalJS.toURL(GameMakerGlobal.config.strProjectRootPath)
        //nameFilters: [ "zip files (*.zip)", "All files (*)" ]

        selectMultiple: false
        selectExisting: true
        selectFolder: true

        onAccepted: {
            //loader.focus = true;
            //loader.forceActiveFocus();
            //rootGameMaker.focus = true;
            //rootGameMaker.forceActiveFocus();

            console.debug("[AndroidConfigure]You chose: " + fileUrl, fileUrls);


            let fUrl;
            if(Qt.platform.os === "android")
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
            console.debug("[AndroidConfigure]onRejected");
            //Qt.quit()

        }
        Component.onCompleted: {
            //visible = true;
        }
    }

    Dialog1.FileDialog {
        id: filedialogIcon

        visible: false

        title: "选择图标文件"
        //folder: shortcuts.home
        nameFilters: [ "PNG files (*.png)", "All files (*)" ]

        selectMultiple: false
        selectExisting: true
        selectFolder: false

        onAccepted: {
            console.debug("[AndroidConfigure]You chose: " + fileUrl, fileUrls, typeof(fileUrl), JSON.stringify(fileUrl));
            /*let strFileUrl = fileUrl.toString();

            if(Qt.platform.os === "android") {
                if(strFileUrl.indexOf("primary") >= 0) {
                    textImageResourceName.text = "file:/storage/emulated/0/" + strFileUrl.substr(strFileUrl.indexOf("%3A")+3);
                }
                else if(strFileUrl.indexOf("document/") >= 0) {
                    let tt = strFileUrl.indexOf("%3A");
                    textImageResourceName.text = "file:/storage/" + strFileUrl.slice(strFileUrl.indexOf("/document/") + "/document/".length, tt) + "/" + strFileUrl.slice(tt + 3);
                }
                else
                    textImageResourceName.text = fileUrl;
            }
            else
                textImageResourceName.text = fileUrl;
            */

            let path;
            if(Qt.platform.os === "android")
                path = Platform.sl_getRealPathFromURI(fileUrl);
            else
                path = FrameManager.sl_urlDecode(fileUrl);

            textIconPath.text = GlobalJS.toURL(path);
            imageIcon.source = GlobalJS.toURL(path);
        }

        onRejected: {
            //gameMap.forceActiveFocus();

            console.debug("[AndroidConfigure]onRejected")
            //Qt.quit();
        }
        Component.onCompleted: {
            //visible = true;
        }
    }



    QObject {
        id: _private

        //property string strPackageDir: 'D:/Documents/Desktop/QtEnv/_MakerFrame/Packages/Android/MakerFrame_鹰歌框架引擎_ALL_Qt5.15.2'
        property alias strPackageDir: textPackageDirPath.text

        function init() {
            if(!FrameManager.sl_fileExists(_private.strPackageDir + '/AndroidManifest.xml')) {
                textResult.text = '没有找到打包文件夹，请配置后点击“生成”按钮';
                return false;
            }


            let content;
            let reg;
            let res;

            imageIcon.source = GlobalJS.toURL(_private.strPackageDir) + '/res/drawable-ldpi/icon.png';


            content = FrameManager.sl_fileRead(_private.strPackageDir + '/assets/QML/RPGRuntime/GameMakerGlobal.qml');
            if(!content)
                textResult.text += '读取 GameMakerGlobal.qml 失败\r\n';

            reg = /category: '(\S*)'/;
            res = reg.exec(content);
            textGameName.text = res[1];

            reg = /property string tds_ClientID: '(\w*)'/;
            res = reg.exec(content);
            textTapClientID.text = res[1];


            content = FrameManager.sl_fileRead(_private.strPackageDir + '/AndroidManifest.xml');
            if(!content)
                textResult.text += '读取 AndroidManifest.xml 失败\r\n';

            reg = /package="(\S*)"/;
            res = reg.exec(content);
            textPackageName.text = res[1];
        }

        function modifyConfig() {
            let content;
            let reg;
            let res;

            textResult.text = '';


            content = FrameManager.sl_fileRead(_private.strPackageDir + '/assets/QML/RPGRuntime/GameMakerGlobal.qml');
            if(!content)
                textResult.text += '读取 GameMakerGlobal.qml 失败\r\n';
            else {
                reg = /(category: ')\S*(')/;
                content = content.replace(reg, '$1' + textGameName.text + '$2');

                reg = /(property string tds_ClientID: ')\w*(')/;
                content = content.replace(reg, '$1' + textTapClientID.text + '$2');

                res = FrameManager.sl_fileWrite(content, _private.strPackageDir + '/assets/QML/RPGRuntime/GameMakerGlobal.qml');
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


                reg = /(package=")\S*(")/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');

                reg = /(android:name=")\S*(\.openadsdk.permission.TT_PANGOLIN)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');

                reg = /(android:name=")\S*(\.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');

                reg = /(android:authorities=")\S*(\.TTFileProvider)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.TTMultiProvider)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.com\.tds\.ad\.fileprovider)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.com\.tapsdk\.tapad\.okdownload)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.tap_config\.provider)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.tap_user\.provider)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.pangle\.servermanager\.downloader\.com\.bytedance\.sdk\.openadsdk\.adhost)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.pangle\.servermanager\.main)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.pangle\.provider\.proxy.main)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.pangle\.fileprovider)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.bytedance\.android\.openliveplugin\.process\.server\.LiveServerManager)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.pangle\.servermanager\.bytelive\.com\.byted\.live\.lite)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.pangle\.servermanager\.push\.com\.byted\.live\.lite)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');
                reg = /(android:authorities=")\S*(\.androidx-startup)/;
                content = content.replace(reg, '$1' + textPackageName.text + '$2');


                res = FrameManager.sl_fileWrite(content, _private.strPackageDir + '/AndroidManifest.xml');
                if(res === 0) {
                    textResult.text += '写入 AndroidManifest.xml 成功\r\n';
                }
                else
                    textResult.text += '写入 AndroidManifest.xml 失败\r\n';
                //console.warn(content);
            }


            FrameManager.sl_fileCopy(GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-hdpi/icon.png', true);
            FrameManager.sl_fileCopy(GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-ldpi/icon.png', true);
            FrameManager.sl_fileCopy(GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-mdpi/icon.png', true);
            FrameManager.sl_fileCopy(GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-xhdpi/icon.png', true);
            FrameManager.sl_fileCopy(GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-xxhdpi/icon.png', true);
            FrameManager.sl_fileCopy(GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-xxxhdpi/icon.png', true);
        }

        function makePackage() {
            let path = Platform.externalDataPath + GameMakerGlobal.separator + "RPGMaker" + GameMakerGlobal.separator + "RPGGame";

            let jsFiles = FrameManager.sl_dirList(path, '*', 0x002 | 0x2000 | 0x4000, 0);
            jsFiles.sort();

            /*let needFilesName = ['Android_Package_', 'Android_MakerFrame_RPGRuntime_'];
            let needFilesIndex = [];
            for(let fileName in jsFiles) {
                for(let needFileName in needFilesName) {
                    if(jsFiles[fileName].indexOf(needFilesName[needFileName]) >= 0) {
                        needFilesIndex[needFileName] = fileName;
                        break;
                    }
                }
            }
            */

            let missingFiles = '';
            if(!jsFiles[0] || jsFiles[0].indexOf('MakerFrame_Package_Android_') < 0)
                missingFiles += 'MakerFrame_Package_Android_xxx.zip ';
            if(!jsFiles[1] || jsFiles[1].indexOf('MakerFrame_RPGRuntime_Android_') < 0)
                missingFiles += 'MakerFrame_RPGRuntime_Android_xxx.zip ';

            if(missingFiles !== '') {
                dialogCommon.show({
                    Msg: '请将 %1 文件下载并放入 %2 文件夹下（文件可以在Q群或gitee里下载）'.arg(missingFiles).arg(path),
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

            function continueScript(packageType) {
                dialogCommon.show({
                    Msg: '请等待。。。',
                    Buttons: Dialog.NoButton,
                    OnRejected: ()=>{
                        dialogCommon.open();
                        root.forceActiveFocus();
                    },
                });

                showBusyIndicator(true);

                GlobalLibraryJS.setTimeout(function() {
                    let ret;

                    try {
                        if(packageType === 1) {
                            FrameManager.sl_removeRecursively(strPackageDir + GameMakerGlobal.separator + 'assets' + GameMakerGlobal.separator + 'Project');
                        }

                        if(packageType === 2) {
                            FrameManager.sl_removeRecursively(strPackageDir);
                            ret = FrameManager.sl_extractDir(path + GameMakerGlobal.separator + jsFiles[0], strPackageDir);
                            ret = FrameManager.sl_extractDir(path + GameMakerGlobal.separator + jsFiles[1], strPackageDir);
                        }

                        ret = FrameManager.sl_dirCopy(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName, strPackageDir + GameMakerGlobal.separator + 'assets' + GameMakerGlobal.separator + 'Project', true);
                    } catch(e) {
                        GlobalLibraryJS.printException(e);
                        return;
                    } finally {
                        showBusyIndicator(false);

                        dialogCommon.close();
                    }


                    modifyConfig();


                    dialogCommon.show({
                        Msg: '生成打包文件夹成功，请用“APKtool软件”来打包APK（%1）'.arg(strPackageDir),
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

                dialogCommon.show({
                    Msg: '检测到有旧打包文件夹，Yes（是）：只更新工程；Discard（丢弃）：更新整个打包文件夹',
                    Buttons: Dialog.Yes | Dialog.No | Dialog.Discard,
                    OnAccepted: function() {
                        continueScript(1);
                    },
                    OnRejected: ()=>{
                        root.forceActiveFocus();
                    },
                    OnDiscarded: ()=>{
                        dialogCommon.close();
                        continueScript(2);
                    },
                });
            }
            else {
                continueScript(2);
            }

            return true;
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        sg_close();

        console.debug("[PackageAndroid]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        sg_close();

        console.debug("[PackageAndroid]Back Key");
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
        textPackageDirPath.text = Platform.externalDataPath + GameMakerGlobal.separator + "RPGMaker" + GameMakerGlobal.separator + "RPGGame" + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName;
        _private.init();

        console.debug('[PackageAndroid]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug("[PackageAndroid]Component.onDestruction");
    }
}