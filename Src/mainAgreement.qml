import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
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


    signal s_close();



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
        width: parent.width * 0.96
        height: parent.height * 0.96
        anchors.centerIn: parent

        Notepad {
            id: msgBox

            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            //Layout.preferredHeight: 50
            Layout.maximumHeight: parent.height
            Layout.fillHeight: true


            text: ''

            textArea.color: 'white'
            //textArea.enabled: false
            textArea.readOnly: true

            textArea.selectByMouse: false

            textArea.font {
                pointSize: 15
            }

            textArea.background: Rectangle {
                //implicitWidth: 200
                //implicitHeight: 40
                color: "#80000000"
                //color: 'transparent'
                //color: Global.style.backgroundColor
                border.color: msgBox.textArea.focus ? Global.style.accent : Global.style.hintTextColor
                border.width: msgBox.textArea.focus ? 2 : 1
            }
        }

        Button {
            //Layout.fillWidth: true
            //Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter// | Qt.AlignTop
            Layout.preferredHeight: 50

            text: "返　回"
            onClicked: {
                s_close();
            }
        }
    }



    QtObject {
        id: _private

    }


    //配置
    QtObject {
        id: config
    }



    //Keys.forwardTo: []
    Keys.onEscapePressed: {
        s_close();

        console.debug("[mainAgreement]Escape Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onBackPressed: {
        s_close();

        console.debug("[mainAgreement]Back Key");
        event.accepted = true;
        //Qt.quit();
    }
    Keys.onPressed: {
        console.debug("[mainAgreement]key:", event, event.key, event.text)
    }


    Component.onCompleted: {
        let t = `
<CENTER><B>使用协议</B></CENTER>

  请务必认真阅读和理解本《软件许可使用协议》（以下简称《协议》）中规定的所有权利和限制。除非您接受本《协议》全部条款，否则您无权下载、安装或使用本"软件"及其相关服务。您一旦安装、复制、下载、访问或以其它方式使用本软件产品，将视为对本《协议》的接受，即表示您同意接受本《协议》各项条款的约束。如果您不同意本《协议》中的任何一个条款，请不要安装、复制或使用本软件。
  本《协议》是用户与 鹰歌框架引擎开发者（以下简称“开发者”） 之间关于用户下载、安装、使用、复制随附本《协议》的 鹰歌框架引擎 软件（以下简称“软件”）的法律协议。

1、权利声明
    本"软件"的一切知识产权，以及与"软件"相关的所有信息内容，包括但不限于：文字表述及其组合、图标、图饰、图像、图表、色彩、界面设计、版面框架、有关数据、附加程序、印刷材料或电子文档等均为开发者所有，受著作权法和国际著作权条约以及其他知识产权法律法规的保护。
2、许可范围
    2.1、下载、安装和使用：本软件为免费软件，用户可以非商业性、无限制数量地下载、安装及使用本软件。
    2.2、复制、分发和传播：用户可以非商业性、无限制数量地复制、分发和传播本软件产品。但必须保证每一份复制、分发和传播都是完整和真实的, 包括所有有关本软件产品的软件、电子文档, 版权和商标，亦包括本协议。
3、权利限制
    3.1、禁止反向工程、反向编译和反向汇编：用户不得对本软件产品进行反向工程（Reverse Engineer）、反向编译（Decompile）或反向汇编（Disassemble），同时不得改动编译在程序文件内部的任何资源。除法律、法规明文规定允许上述活动外，用户必须遵守此协议限制。
    3.2、组件分割:本软件产品是作为一个单一产品而被授予许可使用, 用户不得将各个部分分开用于任何目的。
    3.3、个别授权: 如需进行商业性的销售、复制、分发，包括但不限于软件销售、预装、捆绑等，必须获得开发者的书面授权和许可。
    3.4、保留权利：本协议未明示授权的其他一切权利仍归开发者所有， 用户使用其他权利时必须获得开发者的书面同意。
4、用户使用须知
    4.1、本软件由开发者提供产品支持。
    4.2、本软件是一款供二次开发的框架引擎架构（包括但不限于业务软件、游戏软件、系统软件等）。使用本软件或者下载文件会产生相应的流量费并由运营商收取，除此以外不产生其他费用。
    4.3、本软件不含有任何旨在破坏用户数据和获取用户隐私信息的恶意代码，不含有任何监控、监视用户计算机的功能代码，不会收集用户个人文件、文档等信息，不会泄漏用户隐私。
    4.4、软件的修改和升级：开发者保留随时为用户提供本软件的修改、升级版本的权利。软件升级更新会产生相应的数据流量费，由运营商收取。
    4.5、用户应在遵守法律及本协议的前提下使用本软件。用户无权实施包括但不限于下列行为：
        4.5.1、删除或者改变本软件上的所有权利管理电子信息；
        4.5.2、故意避开或者破坏著作权人为保护本软件著作权而采取的技术措施；
        4.5.3、利用本软件误导、欺骗他人；
        4.5.4、违反国家规定，对计算机信息系统功能进行删除、修改、增加、干扰，造成计算机信息系统不能正常运行；
        4.5.5、未经允许，进入计算机信息网络或者使用计算机信息网络资源 ；
        4.5.6、未经允许，对计算机信息网络功能进行删除、修改或者增加的；
        4.5.7、未经允许，对计算机信息网络中存储、处理或者传输的数据和应用程序进行删除、修改或者增加 ；
        4.5.8、破坏本软件系统或网站的正常运行，故意传播计算机病毒等破坏性程序；
        4.5.9、其他任何危害计算机信息网络安全的；
    4.6、对于从非开发者指定站点下载的本软件产品以及从非开发者发行的介质上获得的本软件产品，开发者无法保证该软件是否感染计算机病毒、是否隐藏有伪装的特洛伊木马程序或者黑客软件，使用此类软件，将可能导致不可预测的风险，建议用户不要轻易下载、安装、使用，开发者 不承担任何由此产生的一切法律责任。
5、免责与责任限制
    5.1、本软件经过详细的测试，但不能保证与所有的软硬件系统完全兼容，不能保证本软件完全没有错误。如果出现不兼容及软件错误的情况，用户可将情况报告开发者，获得技术支持。如果无法解决，用户可以删除本软件。
    5.2、在适用法律允许的最大范围内，对因使用或不能使用本软件所产生的损害及风险，包括但不限于直接或间接的个人损害、商业赢利的丧失、商业信息的丢失或任何其它经济损失，开发者不承担任何责任。
    5.3、对于因电信系统或互联网网络故障、计算机故障或病毒、信息损坏或丢失、计算机系统问题或其它任何不可抗力原因而产生损失，开发者不承担任何责任。
    5.4、用户违反本协议规定，对开发者造成损害的。开发者有权采取包括但不限于中断使用许可、停止提供服务、限制使用、法律追究等措施。
    5.5、使用本软件必须遵守国家有关法律和政策等，维护国家利益，保护国家安全，并遵守本协议。对于用户违法犯罪行为或违反本协议的使用而引起的一切责任，全部由用户负责，开发者不承担任何责任。
6、其他条款
    6.1、如果本协议中的任何条款无论因何种原因完全或部分无效或不具有执行力，或违反任何适用的法律，则该条款被视为删除，但本协议的其余条款仍应有效并且有约束力。
    6.2、开发者有权随时根据有关法律、法规的变化以及开发者经营状况和经营策略的调整等修改本协议。修改后的协议会在开发者中心产品官方网站上公布，并随附于新版本软件。当发生有关争议时，以最新的协议文本为准。如果不同意改动的内容，用户可以自行删除本软件。如果用户继续使用本软件，则视为您接受本协议的变动。
    6.3、本协议适用中华人民共和国法律。

`
        msgBox.text = GlobalLibraryJS.convertToHTML(t);
    }
}
