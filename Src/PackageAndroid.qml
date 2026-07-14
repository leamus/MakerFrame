import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14


//import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


import 'qrc:/QML'


//import './Core'

////import GameComponents 1.0
//import 'Core/GameComponents'


//import 'File.js' as File



Item {
    id: root


    signal sg_close();



    //width: 600
    //height: 800
    anchors.fill: parent

    focus: true
    clip: true

    //color: $Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        //opacity: 0
        color: $Global.style.backgroundColor
        //radius: 9
    }


    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: parent.height * 0.9

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: '*打包文件夹路径：'
            }

            TextField {
                id: textPackageDirPath

                Layout.fillWidth: true

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextField.Wrap

                onTextChanged: {
                    _private.refresh();
                }
            }

            Button {
                text: '选择'
                onClicked: {
                    $fileDialog.show({
                        Title: '选择文件夹',
                        Folder: $GlobalJS.toURL($GameMakerGlobal.config.strProjectRootPath), //shortcuts.home
                        //NameFilters: [ 'zip files (*.zip)', 'All files (*)' ],
                        SelectMultiple: false,
                        SelectExisting: true,
                        SelectFolder: true,
                        //ConvertURL: false,
                        OnAccepted: function(url, urls) {
                            const path = $GlobalJS.toPath(url);

                            //loader.focus = true;
                            //loader.forceActiveFocus();
                            //root.focus = true;
                            //root.forceActiveFocus();

                            textPackageDirPath.text = url;

                            root.forceActiveFocus();
                        },
                    });
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Label {
                text: '*APP名：'
            }
            TextField {
                id: textAPPName

                Layout.fillWidth: true

                placeholderText: 'APP名'

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
                text: '图标：'
            }

            TextField {
                id: textIconPath

                Layout.fillWidth: true

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextField.Wrap

                onTextChanged: {
                    imageIcon.source = $GlobalJS.toURL(textIconPath.text);
                }
            }

            Image {
                id: imageIcon

                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                //width: 50
                //height: 50

                //source: textIconPath.text
            }

            Button {
                text: '选择'
                onClicked: {
                    $fileDialog.show({
                        Title: '选择图标文件',
                        Folder: $GlobalJS.toURL($GameMakerGlobal.config.strProjectRootPath), //shortcuts.home
                        NameFilters: [ 'PNG files (*.png)', 'All files (*)' ],
                        SelectMultiple: false,
                        SelectExisting: true,
                        SelectFolder: false,
                        //ConvertURL: false,
                        OnAccepted: function(url, urls) {
                            textIconPath.text = $GlobalJS.toPath(url);
                        },
                    });
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            //visible: _private.nPackageType !== 1

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
            //visible: _private.nPackageType !== 1

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

        ComboBox {
            id: comboType

            Layout.fillWidth: true


            model: ['重新生成全部文件', '只重新复制工程', '只修改配置']

            background: Rectangle {
                //implicitWidth: comboBoxComponentItem.comboBoxWidth
                implicitHeight: 35
                //border.color: control.pressed ? '#6495ED' : '#696969'
                //border.width: control.visualFocus ? 2 : 1
                color: 'transparent'
                //border.color: comboBoxComponentItem.color
                border.width: 2
                radius: 6
            }

            onActivated: {
                console.debug('[PackageAndroid]ComboBox:', comboType.currentIndex,
                              comboType.currentText,
                              comboType.currentValue);
            }
            /*onHighlighted: {
                console.debug('onHighlighted:', comboType.currentIndex,
                              comboType.currentText,
                              comboType.currentValue);
            }
            onAccepted: {
                console.debug(comboType.currentIndex,
                              comboType.currentText,
                              comboType.currentValue);
            }*/

        }

        Label {
            Layout.fillWidth: true

            wrapMode: Label.WrapAnywhere

            text: {
                if(Qt.platform.os === 'android')
                    return '<font color="red">注意：Android下需要安装 Apktool M 或 MT 软件辅助打包</font>'
                else if(Qt.platform.os === 'windows')
                    return '<font color="red">注意：Windows下需要安装 Java 环境 和 Apktools 软件辅助打包</font>'
            }
        }

        Notepad {
            id: textResult

            Layout.fillWidth: true
            Layout.fillHeight: true


            //textArea.color: $Global.style.foreground
            textArea.readOnly: true

            textArea.wrapMode: TextArea.WrapAnywhere
            textArea.horizontalAlignment: TextArea.AlignJustify
            //textArea.verticalAlignment: TextArea.AlignVCenter

            textArea.selectByMouse: false

            textArea.background: Rectangle {
                //implicitWidth: 200
                //implicitHeight: 40
                color: $Global.style.backgroundColor
                border.color: parent.parent.textArea.activeFocus ? $Global.style.accent : $Global.style.hintTextColor
                border.width: parent.parent.textArea.activeFocus ? 2 : 1
            }
        }

        Button {
            Layout.alignment: Qt.AlignCenter

            text: '生　成'
            onClicked: {
                _private.make();
            }
        }
    }



    QObject {
        id: _private

        //property int nPackageType: 0 //1为app；2为Game

        //property string strPackageDir: 'D:/Documents/Desktop/QtEnv/_MakerFrame/Packages/Android/MakerFrame_鹰歌软件框架游戏引擎_ALL_Qt5.15.2'
        property alias strPackageDir: textPackageDirPath.text

        //初始化，刷新配置
        function refresh() {
            textAPPName.text = '';
            textPackageName.text = '';
            textIconPath.text = '';
            textTapClientID.text = '';
            textTapClientToken.text = '';
            textResult.text = '';


            if(!$Frame.sl_fileExists(_private.strPackageDir + '/AndroidManifest.xml')) {
                textResult.text = '没有找到打包文件夹，请配置后点击“生成”按钮';
                return false;
            }


            let error = 0;

            let content;
            let regExp;
            let res;

            imageIcon.source = $GlobalJS.toURL(_private.strPackageDir) + '/res/drawable-ldpi/icon.png';


            content = $Frame.sl_fileRead(_private.strPackageDir + '/assets/QML/Config.js');
            if(!content) {
                //nPackageType = 1;
                textResult.append('读取 Config.js 失败');
                ++error;
            }
            else {
                //nPackageType = 2;
                //textResult.append('打包为 鹰歌引擎Game');

                //regExp = /category: '(\S*)'/g;
                regExp = /appName = '(\S*)'/g;
                res = regExp.exec(content);
                textAPPName.text = res[1];

                //regExp = /property string strTDSClientID: '(\w*)'/g;
                regExp = /tdsClientID: '(\w*)'/g;
                res = regExp.exec(content);
                textTapClientID.text = res[1];

                //regExp = /property string strTDSClientToken: '(\w*)'/g;
                regExp = /tdsClientToken: '(\w*)'/g;
                res = regExp.exec(content);
                textTapClientToken.text = res[1];
            }


            content = $Frame.sl_fileRead(_private.strPackageDir + '/AndroidManifest.xml');
            if(!content) {
                textResult.append('读取 AndroidManifest.xml 失败');
                ++error;
            }
            else {
                /*regExp = /android:label="(\S*)"/g;
                res = regExp.exec(content);
                textAPPName.text = res[1];
                */

                regExp = /package="(\S*)"/g;
                res = regExp.exec(content);
                textPackageName.text = res[1];
            }


            if(error === 0)
                textResult.append('读取打包文件夹配置成功<br>注意：1、如果项目中有使用插件（Qt和QML），请先将插件自行解压到assets/Plugins目录下，并将所有so文件移动到lib/xxx/目录下再进行打包。<br>2、如果打包为APP，则将主qml改名为main.qml并放在assets/QML文件夹下（默认载入路径可在FrameConfig.qml中修改），框架会自动载入。<br>3、Config.js为简单配置，其他高级配置在 GameMakerSingleton.qml、GameMakerGlobal.qml、AndroidManifest.xml 和 QML/LGlobal目录下。');
        }

        //修改配置文件（Config.js、AndroidManifest.xml）
        function modifyConfig() {
            let content;
            let regExp;
            let res;

            textResult.text = '';


            content = $Frame.sl_fileRead(_private.strPackageDir + '/assets/QML/Config.js');
            if(!content) {
                textResult.append('读取 Config.js 失败');
            }
            else {
                //regExp = /(category: ')\S*(')/g;
                regExp = /(appName = ')\S*(')/g;
                content = content.replace(regExp, '$1' + textAPPName.text + '$2');

                //regExp = /(property string strTDSClientID: ')\w*(')/g;
                regExp = /(tdsClientID: ')\w*(')/g;
                content = content.replace(regExp, '$1' + textTapClientID.text + '$2');

                //regExp = /(property string strTDSClientToken: ')\w*(')/g;
                regExp = /(tdsClientToken: ')\w*(')/g;
                content = content.replace(regExp, '$1' + textTapClientToken.text + '$2');


                res = $Frame.sl_fileWrite(content, _private.strPackageDir + '/assets/QML/Config.js');
                if(res === 0) {
                    textResult.append('写入 Config.js 成功');
                }
                else
                    textResult.append('写入 Config.js 失败');
                //console.warn(content);
            }

            content = $Frame.sl_fileRead(_private.strPackageDir + '/AndroidManifest.xml');
            if(!content) {
                textResult.append('读取 AndroidManifest.xml 失败');
            }
            else {
                regExp = /(android:label=")\S*(")/g;
                content = content.replace(regExp, '$1' + textAPPName.text + '$2');


                regExp = /(package=")\S*(")/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');

                regExp = /(android:name=")\S*(\.openadsdk.permission.TT_PANGOLIN)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');

                regExp = /(android:name=")\S*(\.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');

                regExp = /(android:authorities=")\S*(\.TTFileProvider)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                regExp = /(android:authorities=")\S*(\.TTMultiProvider)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                regExp = /(android:authorities=")\S*(\.com\.tds\.ad\.fileprovider)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                regExp = /(android:authorities=")\S*(\.com\.tapsdk\.tapad\.okdownload)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                //regExp = /(android:authorities=")\S*(\.tap_config\.provider)/g;
                //content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                //regExp = /(android:authorities=")\S*(\.tap_user\.provider)/g;
                //content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                regExp = /(android:authorities=")\S*(\.pangle\.servermanager\.downloader\.com\.bytedance\.sdk\.openadsdk\.adhost)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                regExp = /(android:authorities=")\S*(\.pangle\.servermanager\.main)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                regExp = /(android:authorities=")\S*(\.pangle\.provider\.proxy\.main)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                regExp = /(android:authorities=")\S*(\.pangle\.fileprovider)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                regExp = /(android:authorities=")\S*(\.bytedance\.android\.openliveplugin\.process\.server\.LiveServerManager)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                regExp = /(android:authorities=")\S*(\.pangle\.servermanager\.bytelive\.com\.byted\.live\.lite)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                regExp = /(android:authorities=")\S*(\.pangle\.servermanager\.push\.com\.byted\.live\.lite)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                regExp = /(android:authorities=")\S*(\.androidx-startup)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                regExp = /(android:authorities=")\S*(\.TapTapKitInitProvider)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');
                regExp = /(android:authorities=")\S*(\.themisLite)/g;
                content = content.replace(regExp, '$1' + textPackageName.text + '$2');

                regExp = /\$\{applicationId\}/g;
                content = content.replace(regExp, textPackageName.text);


                res = $Frame.sl_fileWrite(content, _private.strPackageDir + '/AndroidManifest.xml');
                if(res === 0) {
                    textResult.append('写入 AndroidManifest.xml 成功');
                }
                else
                    textResult.append('写入 AndroidManifest.xml 失败');
                //console.warn(content);
            }


            textIconPath.text = textIconPath.text.trim();
            //复制 icon
            if(textIconPath.text && $Frame.sl_fileExists(textIconPath.text)) {
                $Frame.sl_fileCopy(textIconPath.text, strPackageDir + '/res/drawable-hdpi/icon.png', true);
                $Frame.sl_fileCopy(textIconPath.text, strPackageDir + '/res/drawable-ldpi/icon.png', true);
                $Frame.sl_fileCopy(textIconPath.text, strPackageDir + '/res/drawable-mdpi/icon.png', true);
                $Frame.sl_fileCopy(textIconPath.text, strPackageDir + '/res/drawable-xhdpi/icon.png', true);
                $Frame.sl_fileCopy(textIconPath.text, strPackageDir + '/res/drawable-xxhdpi/icon.png', true);
                $Frame.sl_fileCopy(textIconPath.text, strPackageDir + '/res/drawable-xxxhdpi/icon.png', true);
            }
        }

        //生成
        function make() {
            const path = $Platform.externalDataPath + '/GameMaker/Games';


            let missingFiles = '';

            const zipFiles = []; //需要解压的文件（后者会覆盖前者的同名文件）
            const needFilesName = ['MakerFrame_Package_Android_*.zip', 'MakerFrame_GameRuntime_Android_*.zip'];
            for(const needFileName of needFilesName) {
                const zipFile = $Frame.sl_dirList(path, [needFileName], 0x002 | 0x2000 | 0x4000, 0x0);
                if(!zipFile[0])
                    missingFiles += needFileName + ',';
                else
                    zipFiles.push(zipFile[0]);
            }

            /*
            const zipFiles = [];
            let zipFile;

            zipFile = $Frame.sl_dirList(path, ['MakerFrame_Package_Android_*.zip'], 0x002 | 0x2000 | 0x4000, 0x0);
            if(!zipFile[0])
                missingFiles += 'MakerFrame_Package_Android_xxx.zip,';
            else
                zipFiles.push(zipFile[0]);
            zipFile = $Frame.sl_dirList(path, ['MakerFrame_GameRuntime_Android_*.zip'], 0x002 | 0x2000 | 0x4000, 0x0);
            if(!zipFile[0])
                missingFiles += 'MakerFrame_GameRuntime_Android_xxx.zip,';
            else
                zipFiles.push(zipFile[0]);
            */


            //let strPackageDir = path + '/' + $GameMakerGlobal.config.strCurrentProjectName;

            //0：全部更新；1：只更新工程；2：只修改配置；
            function continueScript(packageType) {
                $dialog.show({
                    Msg: '请等待...',
                    Buttons: Dialog.NoButton,
                    OnAccepted: function() {
                        $dialog.show();
                        //$dialog.forceActiveFocus();
                    },
                    OnRejected: ()=>{
                        $dialog.show();
                        //$dialog.forceActiveFocus();
                    },
                });

                $showBusyIndicator(true, function() {
                    let ret;

                    try {
                        if(packageType === 0) { //全部
                            $Frame.sl_removeRecursively(strPackageDir);
                            ret = $Frame.sl_extractDir(path + '/' + zipFiles[0], strPackageDir);
                            ret = $Frame.sl_extractDir(path + '/' + zipFiles[1], strPackageDir);

                            ret = $Frame.sl_dirCopy($GameMakerGlobal.config.strProjectRootPath + $GameMakerGlobal.config.strCurrentProjectName, strPackageDir + '/assets/Project', true, 0);

                            modifyConfig();
                        }
                        else if(packageType === 1) { //只是工程
                            $Frame.sl_removeRecursively(strPackageDir + '/assets/Project');

                            ret = $Frame.sl_dirCopy($GameMakerGlobal.config.strProjectRootPath + $GameMakerGlobal.config.strCurrentProjectName, strPackageDir + '/assets/Project', true, 0);
                        }
                        else
                            modifyConfig();
                    }
                    catch(e) {
                        $CommonLibJS.printException(e);

                        return;
                    }
                    finally {
                        $showBusyIndicator(false);

                        $dialog.close();
                    }


                    textResult.append('注意：如果使用apktool编译失败，尝试进入 "设置->编译->更换工具->重置"，重新下载aapt，如果下载无进度，则在 "更换工具" 页面点 "服务器"，更换源再尝试下载。');


                    $dialog.show({
                        Msg: '生成打包文件夹成功，请用三方软件来打包并签名APK（<font color="red">%1</font>）'.arg(strPackageDir),
                        Buttons: Dialog.Yes,
                        OnAccepted: function() {
                            //root.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            //root.forceActiveFocus();
                        },
                    });
                });

                //root.forceActiveFocus();
            }

            let msg;
            if(comboType.currentIndex === 0) { //需要两个压缩文件
                if(missingFiles !== '') {
                    $dialog.show({
                        Msg: '请将 <font color="red">%1</font> 环境文件下载并放入 <font color="red">%2</font> 文件夹下（可以在gitee、github或Q群里下载）。'.arg(missingFiles).arg(path),
                        Buttons: Dialog.Yes,
                        OnAccepted: function() {
                            //root.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            //root.forceActiveFocus();
                        },
                    });
                    return false;
                }
                msg = '找到：<font color="red">' + zipFiles.join(',') + '</font><br><font color="red">注意：此操作会删除 打包文件夹的所有文件，请确保路径选择正确！</font><br>确定？';
            }
            else { //需要 AndroidManifest.xml 和其他配置文件
                if(!$Frame.sl_fileExists(strPackageDir + '/AndroidManifest.xml')) {
                    $dialog.show({
                        Msg: '没有找到配置文件，请先选择“重新生成全部文件”。',
                        Buttons: Dialog.Yes | Dialog.No,
                        OnAccepted: function() {
                            //root.forceActiveFocus();
                        },
                        OnRejected: ()=>{
                            //root.forceActiveFocus();
                        },
                        OnDiscarded: ()=>{
                            //root.forceActiveFocus();
                        },
                    });
                    return false;
                }
                if(comboType.currentIndex === 1)
                    msg = '<font color="red">此操作会删除 打包文件夹的项目的所有文件，请确保路径选择正确！</font><br>确定？';
                else if(comboType.currentIndex === 2)
                    msg = '确定？';
            }

            $dialog.show({
                Msg: msg,
                Buttons: Dialog.Yes | Dialog.No,
                OnAccepted: function() {
                    continueScript(comboType.currentIndex);
                },
                OnRejected: ()=>{
                    //root.forceActiveFocus();
                },
                OnDiscarded: ()=>{
                    //root.forceActiveFocus();
                },
            });

            return true;
        }
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: function(event) {
        console.debug('[PackageAndroid]Keys.onEscapePressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onBackPressed: function(event) {
        console.debug('[PackageAndroid]Keys.onBackPressed');
        event.accepted = true;

        sg_close();
    }
    Keys.onPressed: function(event) {
        console.debug('[PackageAndroid]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Keys.onReleased: function(event) {
        console.debug('[PackageAndroid]Keys.onReleased:', event.key, event.isAutoRepeat);
        event.accepted = true;
    }


    Component.onCompleted: {
        //textPackageDirPath.text = $GameMakerGlobal.config.strProjectRootPath + $GameMakerGlobal.config.strCurrentProjectName;
        textPackageDirPath.text = $Platform.externalDataPath + '/GameMaker/Games/' + $GameMakerGlobal.config.strCurrentProjectName;
        _private.refresh();

        console.debug('[PackageAndroid]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[PackageAndroid]Component.onDestruction');
    }
}
