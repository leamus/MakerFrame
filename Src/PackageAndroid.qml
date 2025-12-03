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

    //color: Global.style.backgroundColor



    Mask {
        anchors.fill: parent
        //opacity: 0
        color: Global.style.backgroundColor
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
                text: '图标：'
            }

            TextField {
                id: textIconPath

                Layout.fillWidth: true

                //selectByKeyboard: true
                selectByMouse: true
                //wrapMode: TextField.Wrap

                onTextChanged: {
                    imageIcon.source = textIconPath.text;
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

            wrapMode: Label.Wrap
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
                _private.make();
            }
        }
    }



    //打开工程 对话框
    Dialog1.FileDialog {
        id: filedialog

        visible: false

        title: '选择文件夹'
        //folder: shortcuts.home
        folder: $GlobalJS.toURL(GameMakerGlobal.config.strProjectRootPath)
        //nameFilters: [ 'zip files (*.zip)', 'All files (*)' ]

        selectMultiple: false
        selectExisting: true
        selectFolder: true

        onAccepted: {
            //loader.focus = true;
            //loader.forceActiveFocus();
            //root.focus = true;
            //root.forceActiveFocus();

            console.debug('[PackageAndroid]You chose:', fileUrl, fileUrls);


            let fUrl;
            if(Qt.platform.os === 'android')
                //注意：content://com.android.externalstorage.documents/tree转换真实路径时会报错：
                fUrl = $GlobalJS.toPath($Platform.sl_getRealPathFromURI(fileUrl.toString().replace('content://com.android.externalstorage.documents/tree', 'content://com.android.externalstorage.documents/document')));
            else
                fUrl = $GlobalJS.toPath($Frame.sl_urlDecode(fileUrl.toString()));

            textPackageDirPath.text = fUrl;

            root.forceActiveFocus();
        }
        onRejected: {
            console.debug('[PackageAndroid]onRejected');
            //root.forceActiveFocus();


            //sg_close();
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
            console.debug('[PackageAndroid]You chose:', fileUrl, fileUrls, typeof(fileUrl), JSON.stringify(fileUrl));
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
                    textImageResourceName.text = fileUrl.toString();
            }
            else
                textImageResourceName.text = fileUrl.toString();
            */

            let path;
            if(Qt.platform.os === 'android')
                path = $Platform.sl_getRealPathFromURI(fileUrl.toString());
            else
                path = $Frame.sl_urlDecode(fileUrl.toString());

            textIconPath.text = $GlobalJS.toURL(path);
        }

        onRejected: {
            console.debug('[PackageAndroid]onRejected');

            //gameMap.forceActiveFocus();
        }
        Component.onCompleted: {
            //visible = true;
        }
    }



    QObject {
        id: _private

        //property string strPackageDir: 'D:/Documents/Desktop/QtEnv/_MakerFrame/Packages/Android/MakerFrame_鹰歌软件框架游戏引擎_ALL_Qt5.15.2'
        property alias strPackageDir: textPackageDirPath.text

        //初始化，刷新配置
        function refresh() {
            textGameName.text = '';
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


            content = $Frame.sl_fileRead(_private.strPackageDir + '/assets/QML/GameRuntime/Singleton/GameMakerGlobal.qml');
            if(!content) {
                textResult.append('读取 GameMakerGlobal.qml 失败');
                ++error;
            }
            else {
                regExp = /category: '(\S*)'/g;
                res = regExp.exec(content);
                textGameName.text = res[1];

                regExp = /property string strTDSClientID: '(\w*)'/g;
                res = regExp.exec(content);
                textTapClientID.text = res[1];

                regExp = /property string strTDSClientToken: '(\w*)'/g;
                res = regExp.exec(content);
                textTapClientToken.text = res[1];
            }


            content = $Frame.sl_fileRead(_private.strPackageDir + '/AndroidManifest.xml');
            if(!content) {
                textResult.append('读取 AndroidManifest.xml 失败');
                ++error;
            }
            else {
                regExp = /package="(\S*)"/g;
                res = regExp.exec(content);
                textPackageName.text = res[1];
            }


            if(error === 0)
                textResult.text = '读取打包文件夹配置成功';
        }

        //修改配置文件（GameMakerGlobal.qml、AndroidManifest.xml）
        function modifyConfig() {
            let content;
            let regExp;
            let res;

            textResult.text = '';


            content = $Frame.sl_fileRead(_private.strPackageDir + '/assets/QML/GameRuntime/Singleton/GameMakerGlobal.qml');
            if(!content)
                textResult.append('读取 GameMakerGlobal.qml 失败');
            else {
                regExp = /(category: ')\S*(')/g;
                content = content.replace(regExp, '$1' + textGameName.text + '$2');

                regExp = /(property string strTDSClientID: ')\w*(')/g;
                content = content.replace(regExp, '$1' + textTapClientID.text + '$2');

                regExp = /(property string strTDSClientToken: ')\w*(')/g;
                content = content.replace(regExp, '$1' + textTapClientToken.text + '$2');


                res = $Frame.sl_fileWrite(content, _private.strPackageDir + '/assets/QML/GameRuntime/Singleton/GameMakerGlobal.qml');
                if(res === 0) {
                    textResult.append('写入 GameMakerGlobal.qml 成功');
                }
                else
                    textResult.append('写入 GameMakerGlobal.qml 失败');
                //console.warn(content);
            }

            content = $Frame.sl_fileRead(_private.strPackageDir + '/AndroidManifest.xml');
            if(!content)
                textResult.append('读取 AndroidManifest.xml 失败');
            else {
                regExp = /(android:label=")\S*(")/g;
                content = content.replace(regExp, '$1' + textGameName.text + '$2');


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


            //复制 icon
            if(textIconPath.text.trim() && $Frame.sl_fileExists($GlobalJS.toPath(textIconPath.text))) {
                $Frame.sl_fileCopy($GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-hdpi/icon.png', true);
                $Frame.sl_fileCopy($GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-ldpi/icon.png', true);
                $Frame.sl_fileCopy($GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-mdpi/icon.png', true);
                $Frame.sl_fileCopy($GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-xhdpi/icon.png', true);
                $Frame.sl_fileCopy($GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-xxhdpi/icon.png', true);
                $Frame.sl_fileCopy($GlobalJS.toPath(textIconPath.text), strPackageDir + '/res/drawable-xxxhdpi/icon.png', true);
            }
        }

        //生成
        function make() {
            let path = $Platform.externalDataPath + GameMakerGlobal.separator + 'GameMaker' + GameMakerGlobal.separator + 'Games';

            let zipFiles = $Frame.sl_dirList(path, ['MakerFrame_*.zip'], 0x002 | 0x2000 | 0x4000, 0);
            zipFiles.sort();
            console.debug('[PackageAndroid]make zip files:', zipFiles);

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


            //let strPackageDir = path + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName;

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
                            ret = $Frame.sl_extractDir(path + GameMakerGlobal.separator + zipFiles[0], strPackageDir);
                            ret = $Frame.sl_extractDir(path + GameMakerGlobal.separator + zipFiles[1], strPackageDir);

                            ret = $Frame.sl_dirCopy(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName, strPackageDir + GameMakerGlobal.separator + 'assets' + GameMakerGlobal.separator + 'Project', true, 0);

                            modifyConfig();
                        }
                        else if(packageType === 1) { //只是工程
                            $Frame.sl_removeRecursively(strPackageDir + GameMakerGlobal.separator + 'assets' + GameMakerGlobal.separator + 'Project');

                            ret = $Frame.sl_dirCopy(GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName, strPackageDir + GameMakerGlobal.separator + 'assets' + GameMakerGlobal.separator + 'Project', true, 0);
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
                if(!$Frame.sl_fileExists(strPackageDir + GameMakerGlobal.separator + 'AndroidManifest.xml')) {
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
        //textPackageDirPath.text = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName;
        textPackageDirPath.text = $Platform.externalDataPath + GameMakerGlobal.separator + 'GameMaker' + GameMakerGlobal.separator + 'Games' + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName;
        _private.refresh();

        console.debug('[PackageAndroid]Component.onCompleted');
    }
    Component.onDestruction: {
        console.debug('[PackageAndroid]Component.onDestruction');
    }
}
