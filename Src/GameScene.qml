import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14
import QtMultimedia 5.14
import Qt.labs.settings 1.1


//引入Qt定义的类
import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0

import LGlobal 1.0


import "qrc:/QML"


import "GameMakerGlobal.js" as GameMakerGlobalJS

//import "GameJS.js" as GameJS
//import "File.js" as File



/*鹰：
  技术：
    1、防止多个键按下后释放一个出现不走问题：
        把所有按下的键都保存到一个Object中，释放一个删除一个，然后弹出下一个键（方向）
    2、event.isAutoRepeat
        第一次按返回false，长按会一直返回true
    3、防止Canvas闪烁，openMap时隐藏，绘制完成后显示：
        itemBackMapContainer.visible = false;
        itemFrontMapContainer.visible = false;
        角色增删也必须设置为这样（要加入map和role全部初始化完毕）

    4、缩放：将地图块大小更改即可；
    5、障碍判断：人物所占地图块和障碍地图块比较；
      角色障碍判断：两个矩形重叠算法；

    gameScene是视窗，itemContainer是整个地图、精灵的容器，角色移动时，itemContainer也在移动，一直会将角色移动在最中央。


  说明：占用的全局属性、事件和定时器：
    game.addtimer("$sys_random_fight_timer", 1000, -1, true)：战斗定时
    game.gf["$sys_random_fight_timer"]：战斗事件
    //game.addtimer("resume_event", 1000, -1, true)：恢复定时
    //game.gf["resume_timer"]：恢复事件

    game.gd["$sys_fight_heros"]：我方所有战斗人员列表
    //game.gd["$sys_hidden_fight_heros"]：我方所有隐藏了的战斗人员列表
    game.gd["$sys_money"]: 金钱
    game.gd["$sys_goods"]: 道具道具 列表（存的是{$rid: goodsRId, $count: count}）
    game.gd["$sys_map"]: 当前地图信息
    game.gd["$sys_fps"]: 当前FPS
    game.gd["$sys_main_roles"]: 当前主角列表，保存了主角属性（{$rid、$index、$name、$showName、$scale、$speed、$avatar、$avatarSize、$x、$y 等}）
    game.gd["$sys_music"]: 当前播放的音乐名
    game.gd["$sys_scale"]: 当前缩放大小
    game.gd["$sys_random_fight"]：随机战斗

    game.objCommonScripts["combatant_class"] = tCommoncript.$Combatant;
    game.objCommonScripts["refresh_combatant"] = tCommoncript.$refreshCombatant;
    game.objCommonScripts["check_all_combatants"] = tCommoncript.$checkAllCombatants;
    game.objCommonScripts["fight_skill_algorithm"]：战斗算法
    game.objCommonScripts["enemy_choice_skill_algorithm"]：敌人出技能算法
    game.objCommonScripts["game_over_script"];   //游戏结束脚本
    game.objCommonScripts["common_run_away_algorithm"]：逃跑算法
    game.objCommonScripts["fight_start_script"]：战斗开始通用脚本
    game.objCommonScripts["fight_round_script"]：战斗回合通用脚本
    game.objCommonScripts["fight_end_script"]：战斗结束通用脚本（升级经验、获得金钱）
    game.objCommonScripts["resume_event_script"]
    //game.objCommonScripts["get_goods_script"]
    //game.objCommonScripts["use_goods_script"]
    game.objCommonScripts["equip_reserved_slots"] //装备预留槽位
    game.objCommonScripts["sort_fight_algorithm"]
    game.objCommonScripts["combatant_info"]
    game.objCommonScripts["show_goods_name"]
    game.objCommonScripts["show_combatant_name"]
    game.objCommonScripts["common_check_skill"]
    game.objCommonScripts["combatant_round_script"]
    //game.objCommonScripts["events"]


    //game.objCommonScripts["levelup_script"]：升级脚本（经验等条件达到后升级和结果）
    //game.objCommonScripts["level_Algorithm"]：升级算法（直接升级对经验等条件的影响）

*/



Rectangle {

    id: rootGameScene


    //关闭退出
    signal s_close();


    property alias _private: _private

    property alias fightScene: loaderFightScene


    property alias g: rootGameScene.game
    property QtObject game: QtObject {

        //载入地图并执行地图载入事件；成功返回true。
        readonly property var loadmap: function(mapName) {
            timer.running = false;

            game.d = {};
            game.f = {};

            for(let c of _private.arrayMapComponents) {
                if(GlobalLibraryJS.isComponent(c))
                    c.destroy();
            }
            _private.arrayMapComponents = [];

            game.delrole(-1);

            _private.objTimers = {};

            itemContainer.mapEventsTriggering = {};


            game.gd["$sys_map"].$name = mapName;
            let mapPath = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + mapName;
            let mapInfo = openMap(mapPath);

            //载入地图会卡顿，重新开始计时会顺滑一点
            timer.running = true;
            timer.nLastTime = 0;

            return true;
        }

        /*readonly property var map: {
            name: ""
        }*/

        //在屏幕中间显示提示信息。
        //interval为文字显示间隔，为0则不使用；
        //pretext为已显示的文字；
        //keeptime：如果为-1，表示点击后对话框会立即显示全部，为0表示等待显示完毕，为>0表示显示完毕后再延时KeepTime然后自动消失；
        //style为样式；
        //  （如果为数字，则表示自适应宽高（0b1为宽，0b10为高），否则固定大小；
        //  如果为对象，则可以修改BackgoundColor、BorderColor、FontSize、FontColor、MaskColor、Type）；
        //      分别表示 背景色、边框色、字体颜色、字体大小、遮盖色、自适应类型、持续时间；
        //pauseGame为是否暂停游戏（建议true），如果为false，尽量不要用yield关键字；
        //buttonNum为按钮数量（0-2，目前没用）。
        readonly property var msg: function(msg='', interval=20, pretext='', keeptime=0, style={Type: 0b10}, pauseGame=true, buttonNum=0) {

            //样式
            if(style === undefined || style === null)
                style = {};
            else if(GlobalLibraryJS.isValidNumber(style))
                style = {Type: style};


            //按钮数
            buttonNum = parseInt(buttonNum);

            /*if(buttonNum === 1)
                dialogGameMsg.standardButtons = Dialog.Ok;
            else if(buttonNum === 2)
                dialogGameMsg.standardButtons = Dialog.Ok | Dialog.Cancel;
            else
                dialogGameMsg.standardButtons = Dialog.NoButton;
            */


            //是否暂停游戏
            if(pauseGame) {
                //dialogGameMsg.bPauseGame = true;
                game.pause('$msg');

                //dialogGameMsg.focus = true;
            }
            else {
                //dialogGameMsg.bPauseGame = false;
            }



            dialogGameMsg.show(msg.toString(), pretext.toString(), interval, keeptime, style);

            return true;
        }

        //在屏幕下方显示信息。
        //interval为文字显示间隔，为0则不使用；
        //pretext为已显示的文字（role为空的情况下）；
        //keeptime：如果为-1，表示点击后对话框会立即显示全部，为0表示等待显示完毕，为>0表示显示完毕后再延时KeepTime然后自动消失；
        //style为样式；
        //  如果为对象，则可以修改BackgoundColor、BorderColor、FontSize、FontColor、MaskColor、Name、Avatar）；
        //      分别表示 背景色、边框色、字体颜色、字体大小、遮盖色、自适应类型、持续时间、是否显示名字、是否显示头像；
        //pauseGame为是否暂停游戏（建议true），如果为false，尽量不要用yield关键字；
        readonly property var talk: function(role, msg='', interval=20, pretext='', keeptime=0, style=null, pauseGame=true) {
            //console.debug("say1")

            if(GlobalLibraryJS.isString(role)) {
                do {
                    let roleName = role;
                    role = game.hero(roleName);
                    if(role !== null)
                        break;
                    role = game.role(roleName);
                    //if(role !== null)
                    //    break;
                    //role = null;
                }while(0);

            }

            //样式
            if(!style)
                style = {Name: true, Avatar: true};


            //是否暂停游戏
            if(pauseGame) {
                game.pause('$talk');

                //dialogGameMsg.focus = true;
            }
            else {
            }


            if(role !== null) {
                if(role.$name && style.Name)
                    pretext = role.$name + "：" + pretext;
                if(role.$avatar && style.Avatar)
                    pretext = GlobalLibraryJS.showRichTextImage(game.$global.toURL(game.$gameMakerGlobal.imageResourceURL(role.$avatar)), role.$avatarSize.width, role.$avatarSize.height) + pretext;
            }
            dialogRoleMsg.show(msg.toString(), pretext.toString(), interval, keeptime, style);

            //console.debug("say2")
        }

        //人物头顶显示信息。
        //interval为文字显示间隔，为0则不使用；
        //pretext为已显示的文字（role为空的情况下）；
        //keeptime：如果为-1，表示点击后对话框会立即显示全部，为0表示等待显示完毕，为>0表示显示完毕后再延时KeepTime然后自动消失；
        //style为样式；
        //  如果为对象，则可以修改BackgoundColor、BorderColor、FontSize、FontColor、MaskColor）；
        //      分别表示 背景色、边框色、字体颜色、字体大小、遮盖色、自适应类型、持续时间；
        //pauseGame为是否暂停游戏（建议true），如果为false，尽量不要用yield关键字；
        readonly property var say: function(role, msg, interval=60, pretext='', keeptime=1000, style={}) {
            if(GlobalLibraryJS.isString(role)) {
                do {
                    let roleName = role;
                    role = game.hero(roleName);
                    if(role !== null)
                        break;
                    role = game.role(roleName);
                    if(role !== null)
                        break;
                    return false;
                }while(0);

            }

            //样式
            if(!style)
                style = {};
            role.message.color = style.BackgoundColor || '#BF6699FF';
            role.message.border.color = style.BorderColor || 'white';
            role.message.textArea.font.pointSize = style.FontSize || 9;
            role.message.textArea.font.color = style.FontColor || 'white';

            //role.message.visible = true;
            role.message.show(GlobalLibraryJS.convertToHTML(msg.toString()), GlobalLibraryJS.convertToHTML(pretext.toString()), interval, keeptime, 0b11);

            return true;
        }


        //显示一个菜单；
        //title为显示文字；
        //items为选项数组；
        //style：样式，包括MaskColor、BorderColor、BackgroundColor、ItemFontSize、ItemFontColor、ItemBackgroundColor1、ItemBackgroundColor2、TitleFontSize、TitleBackgroundColor、TitleFontColor、ItemBorderColor；
        //pauseGame是否暂停游戏；
        //返回值为选择的下标（0开始）；
        //注意：该脚本必须用yield才能暂停并接受返回值。
        readonly property var menu: function(title, items, style={}, pauseGame=true) {

            //样式
            if(!style)
                style = {};
            maskMenu.color = style.MaskColor || '#7FFFFFFF';
            menuGame.border.color = style.BorderColor || "white";
            menuGame.color = style.BackgroundColor || "#CF6699FF";
            menuGame.nItemFontSize = style.ItemFontSize || style.FontSize || 16;
            menuGame.colorItemFontColor = style.ItemFontColor || style.FontColor || "white";
            menuGame.colorItemColor1 = style.ItemBackgroundColor1 || style.BackgroundColor || "#00FFFFFF";
            menuGame.colorItemColor2 = style.ItemBackgroundColor2 || style.BackgroundColor || "#66FFFFFF";
            menuGame.nTitleFontSize = style.TitleFontSize || style.FontSize || 16;
            menuGame.colorTitleColor = style.TitleBackgroundColor || style.BackgroundColor || "#EE00CC99";
            menuGame.colorTitleFontColor = style.TitleFontColor || style.BackgroundColor || "white";
            menuGame.colorItemBorderColor = style.ItemBorderColor || style.BorderColor || "#60FFFFFF";


            //是否暂停游戏
            if(pauseGame) {
                game.pause('$menu');
            }
            else {
            }



            rectMenu.visible = true;
            menuGame.strTitle = title;
            menuGame.show(items);

        }

        //显示一个输入框；
        //title为显示文字；
        //pretext为预设文字；
        //style为自定义样式；
        //pauseGame是否暂停游戏；
        //返回值为输入值；
        //注意：该脚本必须用yield才能暂停并接受返回值。
        readonly property var input: function(title='', pretext='', style={}, pauseGame=true) {

            //样式
            if(style === undefined || style === null)
                style = {};


            //是否暂停游戏
            if(pauseGame) {
                game.pause('$input');
            }
            else {
            }



            rectGameInput.color = style.BackgoundColor || '#FFFFFF';
            rectGameInput.border.color = style.BorderColor || '#60000000';
            textGameInput.font.pointSize = style.FontSize || 16;
            textGameInput.font.color = style.FontColor || 'black';

            rectGameInputTitle.color = style.TitleBackgoundColor || '#EE00CC99';
            rectGameInputTitle.border.color = style.TitleBorderColor || 'white';
            textGameInputTitle.font.pointSize = style.TitleFontSize || 16;
            textGameInputTitle.font.color = style.TitleFontColor || 'white';


            maskGameInput.color = style.MaskColor || '#7FFFFFFF';



            rectRootGameInput.visible = true;
            textGameInputTitle.text = title;
            textGameInput.text = pretext;

        }


        //创建主角；
        //role：角色资源名 或 标准创建格式的对象（RId为角色资源名）。
        //  其他参数：$name、$showName、$scale、$speed、$avatar、$avatarSize、$x、$y、$bx、$by；
        //  $name为游戏名；
        //成功返回true。
        readonly property var createhero: function(role={}) {
            if(GlobalLibraryJS.isString(role)) {
                role = {RId: role};
            }
            if(!role.$name) {
                role.$name = role.RId;
            }


            for(let th of _private.arrMainRoles) {
                if(th.$name === role.$name) {
                    console.warn('[!GameScene]已经有主角：', role.$name);
                    return false;
                }
            }

            if(_private.arrMainRoles[0] !== undefined) {
                console.warn('[!GameScene]已经有主角：', role.$name);
                return false;
            }


            let filePath = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + role.RId + GameMakerGlobal.separator + "role.json";
            //let cfg = File.read(filePath);
            let cfg = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));
            console.debug('[GameScene]createhero：filePath：', filePath);

            if(cfg === '') {
                console.warn('[!GameScene]角色读取失败：', cfg);
                return false;
            }
            cfg = JSON.parse(cfg);


            //let role = compRole.createObject(itemRoleContainer);
            let index = 0;
            _private.arrMainRoles[index] = mainRole;
            _private.arrMainRoles[index].visible = true;

            if(game.gd["$sys_main_roles"][index] === undefined) {
                //mainRole.$name = role.$name;

                game.gd["$sys_main_roles"][index] = {$rid: role.RId, $index: index, $name: role.$name, $showName: true, $speed: 0, $scale: [1,1], $avatar: '', $avatarSize: [0, 0], $x: 0, $y: 0};

                role.$avatar = cfg.Avatar || '';
                role.$avatarSize = [((cfg.AvatarSize && cfg.AvatarSize[0] !== undefined) ? cfg.AvatarSize[0] : 0), ((cfg.AvatarSize && cfg.AvatarSize[1] !== undefined) ? cfg.AvatarSize[1] : 0)];
                role.$speed = parseFloat(cfg.MoveSpeed);
                role.$scale = [((cfg.Scale && cfg.Scale[0] !== undefined) ? cfg.Scale[0] : 1), ((cfg.Scale && cfg.Scale[1] !== undefined) ? cfg.Scale[1] : 1)];

            }
            //有数据，说明从存档已读取
            else {
                if(!game.gd["$sys_main_roles"][index].$scale)
                    game.gd["$sys_main_roles"][index].$scale = [];
                if(!game.gd["$sys_main_roles"][index].$avatarSize)
                    game.gd["$sys_main_roles"][index].$avatarSize = [];

                role = game.gd["$sys_main_roles"][index];
            }

            _private.arrMainRoles[index].$index = index;

            game.gd["$sys_main_roles"][index].__proto__ = cfg;



            mainRole.spriteSrc = Global.toURL(GameMakerGlobal.roleResourceURL(cfg.Image));
            mainRole.sizeFrame = Qt.size(cfg.FrameSize[0], cfg.FrameSize[1]);
            mainRole.nFrameCount = cfg.FrameCount;
            mainRole.arrFrameDirectionIndex = cfg.FrameIndex;
            mainRole.interval = cfg.FrameInterval;
            //mainRole.implicitWidth = cfg.RoleSize[0]);
            //mainRole.implicitHeight = cfg.RoleSize[1]);
            mainRole.width = cfg.RoleSize[0];
            mainRole.height = cfg.RoleSize[1];
            mainRole.x1 = cfg.RealOffset[0];
            mainRole.y1 = cfg.RealOffset[1];
            mainRole.width1 = cfg.RealSize[0];
            mainRole.height1 = cfg.RealSize[1];
            //mainRole.moveSpeed = parseFloat(cfg.MoveSpeed);
            mainRole.rectShadow.opacity = isNaN(parseFloat(cfg.ShadowOpacity)) ? 0.3 : parseFloat(cfg.ShadowOpacity);
            mainRole.penetrate = isNaN(parseInt(cfg.Penetrate)) ? 0 : parseInt(cfg.Penetrate);

            mainRole.refresh();



            if(role.$direction === undefined)
                role.$direction = 2;

            game.hero(index, role);

            //console.debug("[GameScene]createhero：mainRole：", JSON.stringify(cfg));

            return mainRole;
        }

        //返回 主角；
        //hero可以是下标，或主角的$name，或主角对象，-1表示所有主角；
        //props：需要修改的 单个主角属性（有$name、$showName、$speed、$scale、$avatar、$avatarSize，$direction、$x，$y、$bx、$by）；
        //  $action：为2表示定向移动，此时$targetBx、$targetBy、$targetX、$targetY为定向的地图块坐标或像素坐标（用其中一对即可）；
        //  $direction表示静止方向（0、1、2、3分别表示上右下左）；
        //返回经过props修改的 主角 或 所有主角的列表；如果没有则返回null；
        readonly property var hero: function(hero=-1, props={}) {

            if(hero === -1)
                return _private.arrMainRoles;


            //找到index

            let index = -1;
            if(GlobalLibraryJS.isString(hero)) {
                for(index = 0; index < _private.arrMainRoles.length; ++index) {
                    if(_private.arrMainRoles[index].$name === hero) {
                        break;
                    }
                }
            }
            else if(GlobalLibraryJS.isValidNumber(hero)) {
                index = hero;
            }
            else if(GlobalLibraryJS.isObject(hero)) {
                index = hero.$index;
            }
            else {
                return false;
            }

            if(index >= _private.arrMainRoles.length)
                return null;
            else if(index < 0)
                return false;


            //let hero = _private.arrMainRoles[heroIndex];



            hero = game.gd["$sys_main_roles"][index];
            let heroComp = _private.arrMainRoles[index];

            if(!GlobalLibraryJS.objectIsEmpty(props)) {
                //修改属性
                //GlobalLibraryJS.copyPropertiesToObject(hero, props, true);

                //!!!后期想办法把refresh去掉
                //mainRole.refresh();

                //GlobalLibraryJS.copyPropertiesToObject(hero, props, true);
                if(props.$name !== undefined)   //修改名字
                    hero.$name = heroComp.$name = props.$name;
                if(props.$showName === true)   //修改名字
                    hero.$showName = heroComp.textName.visible = true;
                else if(props.$showName === false)
                    hero.$showName = heroComp.textName.visible = false;
                if(props.$speed !== undefined)   //修改速度
                    hero.$speed = heroComp.moveSpeed = parseFloat(props.$speed);
                if(props.$scale && props.$scale[0] !== undefined) {
                    hero.$scale[0] = heroComp.rXScale = props.$scale[0];
                }
                if(props.$scale && props.$scale[1] !== undefined) {
                    hero.$scale[1] = heroComp.rYScale = props.$scale[1];
                }
                //!!!这里要加入名字是否重复
                if(props.$avatar !== undefined)   //修改头像
                    hero.$avatar = heroComp.$avatar = props.$avatar;
                if(props.$avatarSize !== undefined) {  //修改头像
                    hero.$avatarSize[0] = heroComp.$avatarSize.width = props.$avatarSize[0];
                    hero.$avatarSize[1] = heroComp.$avatarSize.height = props.$avatarSize[1];
                }

                if(props.$action !== undefined)
                    heroComp.nActionType = props.$action;

                if(props.$targetBx !== undefined && props.$targetBy !== undefined) {
                    [heroComp.targetPos.x, heroComp.targetPos.y] = getMapBlockPos(props.$targetBx, props.$targetBy);
                }
                if(props.$targetX !== undefined)   //修改x坐标
                    heroComp.targetPos.x = props.$x;
                if(props.$targetY !== undefined)   //修改y坐标
                    heroComp.targetPos.y = props.$y;

                if(props.$x !== undefined)   //修改x坐标
                    hero.$x = heroComp.x = props.$x;
                if(props.$y !== undefined)   //修改y坐标
                    hero.$y = heroComp.y = props.$y;
                if(props.$x !== undefined || props.$y !== undefined)
                    setMapToRole(mainRole);

                if(props.$bx || props.$by)
                    setMainRolePos(parseInt(props.$bx), parseInt(props.$by), hero.$index);

                if(props.$direction !== undefined)
                    //貌似必须10ms以上才可以使其转向
                    GlobalLibraryJS.setTimeout(function() {
                            heroComp.changeDirection(props.$direction);
                        },20,rootGameScene
                    );

            }

            return heroComp;
        }

        //删除主角；
        //hero可以是下标，或主角的name，或主角对象，-1表示所有主角；
        readonly property var delhero: function(hero=-1) {

            let tmpDelHero = function () {
                mainRole.spriteSrc = "";
                mainRole.nFrameCount = 0;
                mainRole.width = 0;
                mainRole.height = 0;
                mainRole.x1 = 0;
                mainRole.y1 = 0;
                mainRole.width1 = 0;
                mainRole.height1 = 0;
                mainRole.rXScale = 1;
                mainRole.rYScale = 1;
                mainRole.moveSpeed = 0.1;
                //mainRole.textName.text = '';
                mainRole.$index = -1;
                mainRole.$name = '';
                mainRole.$avatar = '';
                mainRole.$avatarSize = Qt.size(0, 0);

                //其他属性（用户自定义）
                mainRole.$props = {};
                mainRole.refresh();

                _private.stopAction(1, -1);
            }


            if(hero === -1) {
                for(let tr of _private.arrMainRoles) {
                    //tr.destroy();
                    tr.visible = false;

                    for(let c of tr.$components) {
                        if(GlobalLibraryJS.isComponent(c))
                            c.destroy();
                    }
                    tr.$components = [];
                }
                _private.arrMainRoles = [];
                game.gd["$sys_main_roles"] = [];

                tmpDelHero();

                return true;
            }


            //找到index

            let index = -1;
            if(GlobalLibraryJS.isString(hero)) {
                for(index = 0; index < _private.arrMainRoles.length; ++index) {
                    if(_private.arrMainRoles[index].$name === hero) {
                        break;
                    }
                }
            }
            else if(GlobalLibraryJS.isValidNumber(hero))
                index = hero;
            else if(GlobalLibraryJS.isObject(hero)) {
                index = hero.$index;
            }
            else {
                return false;
            }
            if(index >= _private.arrMainRoles.length || index < 0)
                return false;


            //let hero = _private.arrMainRoles[heroIndex];



            _private.arrMainRoles[index].visible = false;
            for(let c of _private.arrMainRoles[index].$components) {
                if(GlobalLibraryJS.isComponent(c))
                    c.destroy();
            }
            _private.arrMainRoles[index].$components = [];

            //_private.arrMainRoles[index].destroy();
            delete _private.arrMainRoles[index];
            delete game.gd["$sys_main_roles"][index];

            tmpDelHero();

            //修正下标
            for(; index < game.gd["$sys_main_roles"].length; ++index) {
                game.gd["$sys_main_roles"][index].$index = index;
                _private.arrMainRoles[index].$index = index;
            }


            return true;
        }

        //将主角移动到地图 x、y 位置。
        readonly property var movehero: setMainRolePos

        /*readonly property var movehero: function(bx, by, index=0) {

            if(index >= _private.arrMainRoles.length || index < 0)
                return false;

            let role = _private.arrMainRoles[index];

            setRolePos(role, bx, by);

            return true;
        }*/


        //创建NPC；
        //role：角色资源名 或 标准创建格式的对象（RId为角色资源名）。
        //其他参数：$name、$showName、$speed、$scale、$avatar、$avatarSize、$direction、$action、$start、$x、$y、$bx、$by；
        //  $name为游戏名；
        //  $action为0表示静止，为1表示随机移动；
        //  $direction表示静止方向（0、1、2、3分别表示上右下左）；
        //  $start表示角色是否自动动作（true或false)；
        //成功返回true。
        readonly property var createrole: function(role={}) {

            if(GlobalLibraryJS.isString(role)) {
                role = {RId: role};
            }
            if(!role.$name) {
                role.$name = role.RId;
            }

            if(_private.objRoles[role.$name] !== undefined)
                return false;


            let filePath = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + role.RId + GameMakerGlobal.separator + "role.json";
            //let cfg = File.read(filePath);
            let cfg = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));
            //console.debug("[GameScene]createRole：filePath：", filePath);

            if(cfg === '')
                return false;
            cfg = JSON.parse(cfg);


            let roleObj = compRole.createObject(itemRoleContainer);


            roleObj.spriteSrc = Global.toURL(GameMakerGlobal.roleResourceURL(cfg.Image));
            roleObj.sizeFrame = Qt.size(cfg.FrameSize[0], cfg.FrameSize[1]);
            roleObj.nFrameCount = cfg.FrameCount;
            roleObj.arrFrameDirectionIndex = cfg.FrameIndex;
            roleObj.interval = cfg.FrameInterval;
            //roleObj.implicitWidth = cfg.RoleSize[0];
            //roleObj.implicitHeight = cfg.RoleSize[1];
            roleObj.width = cfg.RoleSize[0];
            roleObj.height = cfg.RoleSize[1];
            roleObj.x1 = cfg.RealOffset[0];
            roleObj.y1 = cfg.RealOffset[1];
            roleObj.width1 = cfg.RealSize[0];
            roleObj.height1 = cfg.RealSize[1];
            roleObj.rectShadow.opacity = isNaN(parseFloat(cfg.ShadowOpacity)) ? 0.3 : parseFloat(cfg.ShadowOpacity);
            roleObj.penetrate = isNaN(parseInt(cfg.Penetrate)) ? 0 : parseInt(cfg.Penetrate);

            //roleObj.test = true;


            _private.objRoles[role.$name] = roleObj;


            roleObj.refresh();


            //roleObj.$name = role.$name;
            role.$speed = parseFloat(cfg.MoveSpeed);
            role.$scale = [((cfg.Scale && cfg.Scale[0] !== undefined) ? cfg.Scale[0] : 1), ((cfg.Scale && cfg.Scale[1] !== undefined) ? cfg.Scale[1] : 1)];

            role.$avatar = cfg.Avatar || '';
            role.$avatarSize = [((cfg.AvatarSize && cfg.AvatarSize[0] !== undefined) ? cfg.AvatarSize[0] : 0), ((cfg.AvatarSize && cfg.AvatarSize[1] !== undefined) ? cfg.AvatarSize[1] : 0)];

            if(role.$direction === undefined)
                role.$direction = 2;

            game.role(roleObj, role);


            return roleObj;

        }

        //返回 角色；
        //role可以是下标，或角色的$name，或角色对象，-1表示所有角色；
        //props：需要修改的 单个角色属性（有 $name、$showName、$speed、$scale、$avatar、$avatarSize、$direction、$action、$start、$x、$y、$bx、$by）；
        //  $action：为0表示静止；为1表示随机移动；为2表示定向移动，此时$targetBx、$targetBy、$targetX、$targetY为定向的地图块坐标或像素坐标（用其中一对即可）；
        //返回经过props修改的 角色 或 所有角色的列表；如果没有则返回null；
        readonly property var role: function(role, props={}) {
            if(role === -1/* || role === undefined || role === null*/)
                return _private.objRoles;


            if(GlobalLibraryJS.isString(role)) {
                role = _private.objRoles[role];
                if(role === undefined)
                    return null;
            }
            else if(GlobalLibraryJS.isValidNumber(role))
                return false;
            else if(GlobalLibraryJS.isObject(role)) {
            }
            else
                return false;


            if(!GlobalLibraryJS.objectIsEmpty(props)) {
                //修改属性
                //GlobalLibraryJS.copyPropertiesToObject(role, props, true);

                //!!!后期想办法把refresh去掉
                //role.refresh();

                if(props.$name !== undefined)   //修改名字
                    role.$name = props.$name;
                if(props.$showName === true)   //修改名字
                    role.textName.visible = true;
                else if(props.$showName === false)
                    role.textName.visible = false;
                if(props.$speed !== undefined)   //修改速度
                    role.moveSpeed = parseFloat(props.$speed);
                if(props.$scale && props.$scale[0] !== undefined) {
                    role.rXScale = props.$scale[0];
                }
                if(props.$scale && props.$scale[1] !== undefined) {
                    role.rYScale = props.$scale[1];
                }

                //!!!这里要加入名字是否重复
                if(props.$avatar !== undefined)   //修改头像
                    role.$avatar = props.$avatar;
                if(props.$avatarSize !== undefined) {  //修改头像
                    role.$avatarSize.width = props.$avatarSize[0];
                    role.$avatarSize.height = props.$avatarSize[1];
                }

                if(props.$action !== undefined)
                    role.nActionType = props.$action;

                if(props.$x !== undefined)   //修改x坐标
                    role.x = props.$x;
                if(props.$y !== undefined)   //修改y坐标
                    role.y = props.$y;

                if(props.$bx !== undefined || props.$by !== undefined)
                    setRolePos(role, props.$bx, props.$by);
                    //moverole(role, bx, by);

                if(props.$targetBx !== undefined && props.$targetBy !== undefined) {
                    [role.targetPos.x, role.targetPos.y] = getMapBlockPos(props.$targetBx, props.$targetBy);
                }
                if(props.$targetX !== undefined)   //修改x坐标
                    role.targetPos.x = props.$x;
                if(props.$targetY !== undefined)   //修改y坐标
                    role.targetPos.y = props.$y;

                if(props.$start === true)
                    role.start();
                else if(props.$start === false)
                    role.stop();

                if(props.$direction !== undefined)
                    //貌似必须10ms以上才可以使其转向
                    GlobalLibraryJS.setTimeout(function() {
                            role.changeDirection(props.$direction);
                        },20,rootGameScene
                    );

                if(props.$realSize !== undefined) {
                    role.width1 = props.$realSize[0];
                    role.height1 = props.$realSize[1];
                    //console.debug('!!!', props.$realSize)
                }
            }


            return role;
        }

        //移动角色到bx，by。
        readonly property var moverole: function(role, bx, by) {

            if(GlobalLibraryJS.isString(role)) {
                role = _private.objRoles[role];
                if(role === undefined)
                    return false;
            }

            setRolePos(role, bx, by);

            return true;
        }
        /*/移动角色到x，y。
        readonly property var moverole123: function(role, bx, by) {

            if(GlobalLibraryJS.isString(role)) {
                role = _private.objRoles[role];
                if(role === undefined)
                    return false;
            }

            if(bx !== undefined && by !== undefined) {
                //边界检测

                if(bx < 0)
                    bx = 0;
                else if(bx >= itemContainer.mapInfo.MapSize[0])
                    bx = itemContainer.mapInfo.MapSize[0] - 1;

                if(by < 0)
                    by = 0;
                else if(by >= itemContainer.mapInfo.MapSize[1])
                    by = itemContainer.mapInfo.MapSize[1] - 1;


                //如果在最右边的图块，且人物宽度超过图块，则会超出地图边界
                //if(bx === itemContainer.mapInfo.MapSize[0] - 1 && role.width1 > sizeMapBlockSize.width)
                //    role.x = itemContainer.width - role.x2 - 1;
                //else
                //    role.x = roleCenterX - role.x1 - role.width1 / 2;
                role.x = bx * sizeMapBlockSize.width - role.x1;


                //如果在最下边的图块，且人物高度超过图块，则会超出地图边界
                //if(by === itemContainer.mapInfo.MapSize[1] - 1 && role.height1 > sizeMapBlockSize.height)
                //    role.y = itemContainer.height - role.y2 - 1;
                //else
                //    role.y = roleCenterY - role.y1 - role.height1 / 2;
                role.y = by * sizeMapBlockSize.height - role.y1;

            }


            return true;
        }
        */


        //删除角色；
        //role可以是 角色对象、角色名或-1（表示删除所有）；
        //成功返回true。
        readonly property var delrole: function(role=-1) {
            if(role === -1) {
                for(let r in _private.objRoles) {
                    for(let c of _private.objRoles[r].$components) {
                        if(GlobalLibraryJS.isComponent(c))
                            c.destroy();
                    }

                    _private.objRoles[r].destroy();
                }
                _private.objRoles = {};

                return true;
            }



            if(GlobalLibraryJS.isString(role)) {
                role = _private.objRoles[role];
                if(role === undefined)
                    return false;
            }


            delete _private.objRoles[role.$name];

            for(let c of role.$components) {
                if(GlobalLibraryJS.isComponent(c))
                    c.destroy();
            }
            role.destroy();



            return true;
        }



        //角色中心所在块坐标；
        //role为角色组件（可用heros和roles命令返回的组件）；
        //  如果为数字或空，则是主角；如果是字符串，则在主角和NPC中查找；
        //pos为[x,y]，如果为空则表示返回角色中心所在块坐标；
        readonly property var rolepos: function(role, pos) {
            if(GlobalLibraryJS.isValidNumber(role)) {
                role = mainRole;
            }
            else if(!role)
                role = mainRole;
            else {
                let r = game.hero(role);
                if(!r)
                    r = game.role(role);
                if(!r)
                    return false;
                role = r;
            }



            //人物的占位最中央 所在地图的坐标
            let centerX = role.x + role.x1 + role.width1 / 2;
            let centerY = role.y + role.y1 + role.height1 / 2;

            if(pos) {
                if(pos[0] === Math.floor(centerX / sizeMapBlockSize.width) && pos[1] === Math.floor(centerY / sizeMapBlockSize.height))
                    return true;
                return false;
            }
            else
                return {bx: Math.floor(centerX / sizeMapBlockSize.width),
                    by: Math.floor(centerY / sizeMapBlockSize.height),
                    cx: centerX,
                    cy: centerY,
                    x: role.x,
                    y: role.y,
                    rx: role.x1,
                    ry: role.y1,
                };


            /*
            ([centerX, centerY])
            ([role.x, role.y])
            ([role.x + role.x1, role.y + role.y1])
            ([role.x + role.x2, role.y + role.y2])


            let mainRoleUseBlocks = [];

            //计算人物所占的地图块
            let usedMapBlocks = _private.fComputeUseBlocks(role.x + role.x1, role.y + role.y1, role.x + role.x2, role.y + role.y2);

            for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
                for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
                    mainRoleUseBlocks.push(xb + yb * itemContainer.mapInfo.MapSize[0]);
                }
            }
            */

        }



        //创建一个战斗主角；返回这个战斗主角对象；
        //fightrole为战斗主角资源名 或 标准创建格式的对象（带有RId、Params和其他属性）。
        readonly property var createfighthero: function(fightrole) {
            if(game.gd["$sys_fight_heros"] === undefined)
                game.gd["$sys_fight_heros"] = [];


            let newFightRole = _public.getFightRoleObject(fightrole, true);


            //newFightRole.$rid = fightRoleRId;
            newFightRole.$index = game.gd["$sys_fight_heros"].length;
            game.gd["$sys_fight_heros"].push(newFightRole);


            return newFightRole;
        }

        //删除一个战斗主角；
        //fighthero为下标，或战斗角色的name，或战斗角色对象，或-1（删除所有战斗主角）。
        readonly property var delfighthero: function(fighthero) {

            if(fighthero === -1) {
                game.gd["$sys_fight_heros"] = [];
                return true;
            }


            fighthero = game.fighthero(fighthero);
            if(!fighthero)
                return false;


            let fightheroIndex = fighthero.$index;

            if(fightheroIndex >= game.gd["$sys_fight_heros"].length)
                return false;

            //if(game.gd["$sys_fight_heros"] === undefined)
            //    return false;

            game.gd["$sys_fight_heros"].splice(fightheroIndex, 1);

            //修正下标
            for(let tfh in game.gd["$sys_fight_heros"])
                game.gd["$sys_fight_heros"][tfh].$index = tfh;



            return true;
        }

        /*readonly property var createfightenemy: function(name) {
            loaderFightScene.enemies.push(new game.objCommonScripts["combatant_class"](name));

        }*/

        //返回战斗主角；
        //fighthero为下标，或战斗角色的name，或战斗角色对象，或-1（删除所有战斗主角）；
        //type为0表示只返回名字（选择框用），为1表示返回对象。
        //返回null表示没有，false错误；
        readonly property var fighthero: function(fighthero=-1, type=1) {
            if(game.gd["$sys_fight_heros"] === undefined || game.gd["$sys_fight_heros"] === null)
                return false;

            if(fighthero === null || fighthero === undefined)
                fighthero = -1;

            if(fighthero === -1) {
                if(type === 0) {//只返回名字
                    let arrName = [];
                    for(let th of game.gd["$sys_fight_heros"])
                        arrName.push(th.$name);
                    return arrName;
                }
                else
                    return game.gd["$sys_fight_heros"];
            }


            if(GlobalLibraryJS.isString(fighthero)) {
                for(let fightheroIndex = 0; fightheroIndex < game.gd["$sys_fight_heros"].length; ++fightheroIndex) {
                    if(game.gd["$sys_fight_heros"][fightheroIndex].$name === fighthero) {
                        fighthero = game.gd["$sys_fight_heros"][fightheroIndex];
                        break;
                    }
                }
            }
            if(GlobalLibraryJS.isObject(fighthero)) {
                //fightHero = fighthero;
                //fightheroIndex = fighthero.$index;
            }
            else if(GlobalLibraryJS.isValidNumber(fighthero)) {
                if(fighthero >= game.gd["$sys_fight_heros"].length)
                    return null;
                else if(fighthero < 0)
                    return false;

                fighthero = game.gd["$sys_fight_heros"][fighthero];
            }
            else {
                return false;
            }



            if(type === 0) {//只返回名字
                return fighthero.$name;
            }
            else
                return fighthero;

        }

        //获得技能；
        //fighthero为下标，或战斗角色的name，或战斗角色对象；
        //skill为技能资源名，或 标准创建格式的对象（带有RId、Params和其他属性），或技能本身（带有$rid）；
        //skillIndex为替换到第几个（如果为-1或大于已有技能数，则追加）；
        //copyedNewProps是 从skills复制的创建的新技能的属性（skills为技能对象才有效，复制一个新技能同时再复制copyedNewProps属性）；
        //成功返回true。
        readonly property var getskill: function(fighthero, skill, skillIndex=-1, copyedNewProps={}) {
            if(skillIndex === undefined || skillIndex === null)
                skillIndex = -1;


            skill = _public.getSkillObject(skill, copyedNewProps);
            if(skill === null)
                return false;



            if(fighthero < 0)
                return false;

            //找到fighthero
            fighthero = game.fighthero(fighthero);
            if(!fighthero)
                return false;



            if(skillIndex < 0 || skillIndex >= fighthero.$skills.length)
                fighthero.$skills.push(skill);
            else
                //fighthero.$skills[skillIndex].$rid = skillRId;
                fighthero.$skills.splice(skillIndex, 0, skill);   //插入

            return true;
        }

        //移除技能；
        //fighthero为下标，或战斗角色的name，或战斗角色对象；
        //skill：技能下标（-1为删除所有 符合filters 的 技能），或 技能资源名（符合filters 的 技能）；
        //filters：技能条件筛选；
        //成功返回skill对象的数组；失败返回false。
        readonly property var removeskill: function(fighthero, skill=-1, filters={}) {
            if(skill === undefined || skill === null)
                skill = -1;
            //if(skillIndex >= objFightHero.$skills.length || fightheroIndex < 0)
            //    return false;
            //if(type === undefined || type === null)
            //    type = -1;



            if(fighthero < 0)
                return false;

            //找到fighthero
            fighthero = game.fighthero(fighthero);
            if(!fighthero)
                return false;



            //如果直接是 字符串或全部，则 按 过滤条件 找出所有
            if(GlobalLibraryJS.isString(skill) || skill === -1) {
                let deletedSkills = [];
                let tSkills = fighthero.$skills;
                fighthero.$skills = [];

                //循环每个技能
                for(let tskill of tSkills) {
                    //如果找到技能rid
                    if(GlobalLibraryJS.isString(skill) && tskill.$rid !== skill)
                        continue;

                    let bFilterFlag = true;
                    //有筛选
                    if(filters) {
                        //开始筛选
                        for(let tf in filters) {
                            //_private.objGoods[tg.$rid][filterkey] === filtervalue
                            if(tskill[tf] !== filters[tf]) {
                                bFilterFlag = false;
                                break;
                            }
                        }
                    }
                    if(bFilterFlag)
                        deletedSkills.push(tskill);
                    else
                        fighthero.$skills.push(tskill);
                }

                if(deletedSkills.length === 0)
                    return false;
                return deletedSkills;
            }
            else if(GlobalLibraryJS.isValidNumber(skill)) {
                if(skill < 0 || skill >= fighthero.$skills.length)
                    return false;
                else {
                    let deletedSkill = fighthero.$skills.splice(skill, 1);
                    return deletedSkill ? [deletedSkill] : false;
                }
            }

            else
                return false;

            return false;
        }


        //返回技能信息；
        //fighthero为下标，或战斗角色的name，或战斗角色对象；
        //skill：技能下标（-1为所有 符合filters 的 技能），或 技能资源名（符合filters 的 技能）；
        //filters：技能条件筛选；
        //成功返回 技能数组。
        readonly property var skill: function(fighthero, skill=-1, filters={}) {
            if(skill === undefined || skill === null)
                skill = -1;
            //if(type === undefined || type === null)
            //    type = -1;
            //if(skillIndex >= objFightHero.$skills.length || fightheroIndex < 0)
            //    return null;



            if(fighthero < 0)
                return false;

            //找到fighthero
            fighthero = game.fighthero(fighthero);
            if(!fighthero)
                return false;



            //如果直接是 字符串或全部，则 按 过滤条件 找出所有
            if(GlobalLibraryJS.isString(skill) || skill === -1) {

                let tSkills = [];

                //循环每个技能
                for(let tskill of fighthero.$skills) {
                    //如果找到技能rid
                    if(GlobalLibraryJS.isString(skill) && tskill.$rid !== skill)
                        continue;


                    let bFilterFlag = true;
                    //有筛选
                    if(filters) {
                        //开始筛选
                        for(let tf in filters) {
                            //_private.objGoods[tg.$rid][filterkey] === filtervalue
                            if(tskill[tf] !== filters[tf]) {
                                bFilterFlag = false;
                                break;
                            }
                        }
                    }
                    if(bFilterFlag)
                        tSkills.push(tskill);

                }

                if(tSkills.length === 0)
                    return null;
                return tSkills;
            }
            else if(GlobalLibraryJS.isValidNumber(skill)) {
                if(skill >= fighthero.$skills.length)
                    return null;
                else if(skill < 0)
                    return false;
                else {
                    let tSkill = fighthero.$skills[skill];
                    return tSkill ? [tSkill] : null;
                    //return tSkill ? tSkill : null;
                }
            }
            else if(GlobalLibraryJS.isObject(skill)) { //如果直接是对象
                //循环每个技能
                for(let tskill of fighthero.$skills) {
                    //如果找到技能
                    if(tskill === skill)
                        return true;
                }
                return false;
            }
            else
                return null;

        }


        //战斗角色修改属性；
        //  fighthero为下标，或战斗角色的name，或战斗角色对象；
        //  props：对象；Key可以为 属性 或 属性,下标，Value可以为 数字（字符串属性或n段属性都修改） 或 数组（针对n段属性，对应修改）；
        //    支持格式：{HP: 6, HP: [6,6,6], 'HP,3': 6}
        //  type为1表示加，为2表示乘，为3表示赋值，为0表示将n段值被n+1段值赋值；
        //  成功返回战斗角色对象；失败返回false；
        readonly property var addprops: function(fighthero, props={}, type=1, refresh=true) {

            if(fighthero < 0)
                return false;

            //找到fighthero
            fighthero = game.fighthero(fighthero);
            if(!fighthero)
                return false;


            GameMakerGlobalJS.addProps(fighthero.$properties, props, type, fighthero.$$propertiesWithExtra);


            /*if(fighthero.$properties.healthHP > fighthero.$$propertiesWithExtra.HP)
                fighthero.$properties.healthHP = fighthero.$$propertiesWithExtra.HP;
            if(fighthero.$properties.healthHP < 0)
                fighthero.$properties.healthHP = 0;
            if(fighthero.$properties.remainHP > fighthero.$$propertiesWithExtra.healthHP)
                fighthero.$properties.remainHP = fighthero.$$propertiesWithExtra.healthHP;
            if(fighthero.$properties.remainHP < 0)
                fighthero.$properties.remainHP = 0;

            if(tKeys.indexOf('remainMP') >= 0 && tKeys.indexOf('MP') >= 0)
                if(fighthero.$properties.remainMP > fighthero.$$propertiesWithExtra.MP)
                    fighthero.$properties.remainMP = fighthero.$$propertiesWithExtra.MP;
            */

            if(refresh)
                game.objCommonScripts["refresh_combatant"](fighthero);

            return fighthero;
        }

        //背包内 获得 count个道具；返回背包中 改变后 道具个数，返回false表示错误。
        //goods可以为 道具资源名、 或 标准创建格式的对象（带有RId、Params和其他属性），或道具本身（带有$rid），或 下标；
        //count为0表示使用goods内的$count；
        readonly property var getgoods: function(goods, count=0) {

            if(GlobalLibraryJS.isObject(goods)) { //如果直接是对象
                goods = _public.getGoodsObject(goods, true);

                if(count)
                    goods.$count = count;
                if(!goods.$count)
                    return false;

                if(!goods.$stackable) {
                    game.gd["$sys_goods"].push(goods);
                    return goods.$count;
                }
            }
            else if(GlobalLibraryJS.isString(goods)) { //如果直接是字符串
                if(count === 0) {
                    for(let tg of game.gd["$sys_goods"]) {
                        //找到
                        if(tg.$rid === goods) {
                            count += tg.$count;
                        }
                    }
                    return count;
                }

                goods = _public.getGoodsObject(goods);
                goods.$count = count;

                if(!goods.$stackable) {
                    game.gd["$sys_goods"].push(goods);
                    return goods.$count;
                }
            }
            else if(GlobalLibraryJS.isValidNumber(goods)) { //如果直接是数字
                if(goods < 0 || goods >= game.gd["$sys_goods"].length)
                    return false;

                goods = game.gd["$sys_goods"][goods];
                if(count > 0)
                    goods.$count += count;
                //if(goodsProps)
                //    GlobalLibraryJS.copyPropertiesToObject(goods, goodsProps/*, true*/);  //!!更改对象属性

                return goods.$count;
            }
            else
                return false;




            //下面是 stackable（可叠加） 的 goods（对象） 查找

            //循环查找goods
            for(let tg of game.gd["$sys_goods"]) {
                //找到
                if(tg.$rid === goods.$rid && tg.$stackable) {
                    tg.$count += goods.$count;
                    return tg.$count;
                }
            }

            //如果没有找到
            game.gd["$sys_goods"].push(goods);
            return goods.$count;
        }

        //背包内 减去count个道具，返回背包中 改变后 道具个数；
        //goods可以为 道具资源名、道具对象 和 下标；
        //如果 装备数量不够，则返回<0（相差数），原道具数量不变化；
        //返回 false 表示错误。
        readonly property var removegoods: function(goods, count=1) {
            if(!GlobalLibraryJS.isValidNumber(count) || count < 0)   //如果直接是数字
                return false;


            if(GlobalLibraryJS.isObject(goods)) { //如果是 道具对象
                if(count === true)
                    count = goods.$count;

                //搜索所在位置
                for(let tg in game.gd["$sys_goods"]) {
                    if(game.gd["$sys_goods"][tg] === goods) {

                        let newCount = goods.$count - count;  //剩余数量
                        if(newCount < 0)
                            return newCount;
                        else if(newCount === 0)
                            game.gd["$sys_goods"].splice(tg, 1);
                        else
                            game.gd["$sys_goods"][tg].$count = newCount;

                        return newCount;
                    }
                }
                return false;
            }
            else if(GlobalLibraryJS.isValidNumber(goods)) { //如果直接是数字
                if(goods < 0 || goods >= game.gd["$sys_goods"].length)
                    return false;

                if(count === true)
                    count = game.gd["$sys_goods"][goods].$count;

                let newCount = game.gd["$sys_goods"][goods].$count - count;  //剩余数量
                if(newCount < 0)
                    return newCount;
                else if(newCount === 0)
                    game.gd["$sys_goods"].splice(goods, 1);
                else
                    game.gd["$sys_goods"][goods].$count = newCount;

                return newCount;
            }
            else if(GlobalLibraryJS.isString(goods)) { //如果直接是字符串
            }
            else
                return false;



            //下面是 goods（字符串） 查找（将所有 为goods的 道具资源名 的道具删count个）

            //要删除的下标数组
            let tarrRemovedIndex = [];
            let tCount = count;
            //遍历所有道具，计算是否够减
            for(let tg = game.gd["$sys_goods"].length - 1; tg >= 0; --tg) {
                if(game.gd["$sys_goods"][tg].$rid === goods) {
                    tarrRemovedIndex.push(tg);
                    tCount = tCount - game.gd["$sys_goods"][tg].$count;
                    //if(tCount <= 0)
                    //    break;
                }
            }
            if(tCount > 0)  //不够
                return -tCount;


            //循环
            while(1) {
                //if(tarrRemovedIndex.length === 0)
                //    return -tCount;

                let tindex = tarrRemovedIndex.shift();

                //剩余数量
                count = count - game.gd["$sys_goods"][tindex].$count;
                if(count >= 0)
                    game.gd["$sys_goods"].splice(tindex, 1);
                else
                    game.gd["$sys_goods"][tindex].$count = -count;

                if(count > 0)
                    continue;
                else
                    return -tCount;
            }

            //return -tCount;
        }

        //获得道具列表中某项道具信息；
        //goods为-1表示返回所有道具的数组（此时filters是道具属性的过滤条件）；
        //goods为数字（下标），则返回单个道具信息的数组；
        //goods为字符串（道具资源名），返回所有符合道具信息的数组（此时filters是道具属性的过滤条件）；
        //返回格式：道具数组。
        readonly property var goods: function(goods=-1, filters={}) {
            if(GlobalLibraryJS.isObject(goods)) {
                for(let tg of game.gd["$sys_goods"]) {
                    if(tg === goods)
                        return [tg];
                }
                return null;
            }

            if(GlobalLibraryJS.isString(goods) || goods === -1) { //如果直接是 字符串或全部，则 按 过滤条件 找出所有
                let ret = [];

                for(let tg of game.gd["$sys_goods"]) {
                    if(GlobalLibraryJS.isString(goods) && goods !== tg.$rid)
                        continue;

                    let bFilterFlag = true;
                    //有筛选
                    if(!GlobalLibraryJS.objectIsEmpty(filters)) {
                        //开始筛选
                        for(let tf in filters) {
                            //_private.objGoods[tg.$rid][filterkey] === filtervalue
                            if(tg[tf] !== filters[tf]) {
                                bFilterFlag = false;
                                break;
                            }
                        }
                    }
                    if(bFilterFlag)
                        ret.push(tg);
                }

                if(ret.length === 0)
                    return null;
                return ret;
            }
            else if(GlobalLibraryJS.isValidNumber(goods)) { //如果直接是数字
                if(goods >= game.gd["$sys_goods"].length)
                    return null;
                else if(goods < 0)
                    return false;
                else {
                    let tg = game.gd["$sys_goods"][goods];
                    return tg ? [tg] : null;
                }
                //else
                //    return game.gd["$sys_goods"];
            }


            return null;
        }

        //使用道具（会执行道具use脚本）；
        //fighthero为下标，或战斗角色的name，或战斗角色对象，也可以为null或undefined；
        //goods可以为 道具资源名、道具对象 和 下标。
        readonly property var usegoods: function(fighthero, goods) {
            let goodsInfo = null;
            if(GlobalLibraryJS.isObject(goods)) { //如果直接是对象
                goodsInfo = _private.objGoods[goods.$rid];
            }
            else if(GlobalLibraryJS.isValidNumber(goods)) { //如果直接是数字
                if(goods < 0 || goods >= game.gd["$sys_goods"].length)
                    return false;

                goods = game.gd["$sys_goods"][goods];
                goodsInfo = _private.objGoods[goods.$rid];
            }
            else if(GlobalLibraryJS.isString(goods)) { //如果直接是字符串
                goodsInfo = _private.objGoods[goods];
                goods = _public.getGoodsObject(goods);
            }
            else
                return false;

            /*let heroProperty, heroPropertyNew;

            if(heroIndex === null || heroIndex === undefined || (heroIndex >= game.gd["$sys_fight_heros"].length || heroIndex < 0))
                ;
            else {
                heroProperty = game.gd["$sys_fight_heros"][heroIndex].$properties;
                heroPropertyNew = game.gd["$sys_fight_heros"][heroIndex].$$propertiesWithExtra;
            }*/

            //if(fighthero < 0)
            //    return false;

            fighthero = game.fighthero(fighthero);
            //if(!fighthero)
            //    return false;


            if(goodsInfo.$commons.$useScript)
                game.run(goodsInfo.$commons.$useScript(goods, fighthero));


            //计算新属性
            let continueScript = function() {
                //计算新属性
                for(let fighthero of game.gd["$sys_fight_heros"])
                    game.objCommonScripts["refresh_combatant"](fighthero);
                //刷新战斗时人物数据
                //loaderFightScene.refreshAllFightRoleInfo();
            }
            game.run(continueScript);
        }

        //直接装备一个道具（不是从背包中）；
        //fighthero为下标，或战斗角色的name，或战斗角色对象；
        //goods可以为 道具资源名、 或 标准创建格式的对象（带有RId、Params和其他属性），或道具本身（带有$rid），或 下标；
        //newPosition：如果为空，则使用 goods 的 position 属性来装备；
        //copyedNewProps是 从goods复制的创建的新道具的属性（goods为道具对象才有效，复制一个新道具同时再复制（覆盖）copyedNewProps属性，比如$count、$position）；
        //返回null表示错误；
        //注意：会将目标装备移除，需要保存则先unload到getgoods。
        readonly property var equip: function(fighthero, goods, newPosition=undefined, copyedNewProps={$count: 1}) {

            if(fighthero < 0)
                return false;

            //找到fighthero
            fighthero = game.fighthero(fighthero);
            if(!fighthero)
                return false;



            goods = _public.getGoodsObject(goods, copyedNewProps);
            if(goods === null)
                return false;


            if(!newPosition) {
                newPosition = goods.$position;
            }


            let oldEquip = fighthero.$equipment[newPosition];

            //如果有相同装备
            if(oldEquip !== undefined && oldEquip.$rid === goods.$rid && oldEquip.$stackable && goods.$stackable) {
                let newCount = oldEquip.$count + goods.$count;
                if(newCount < 0)
                    return newCount;
                else if(newCount === 0) {
                    /*
                    if(game.objCommonScripts["equip_reserved_slots"].indexOf(newPosition) !== -1)
                        fighthero.$equipment[newPosition] = undefined;
                    else
                        delete fighthero.$equipment[newPosition];
                    */
                    delete fighthero.$equipment[newPosition];
                }
                else
                    oldEquip.$count = newCount;

                //计算新属性
                game.objCommonScripts["refresh_combatant"](fighthero);
                //刷新战斗时人物数据
                //loaderFightScene.refreshAllFightRoleInfo();

                return newCount;
            }

            //if(oldEquip === undefined || oldEquip.$rid !== goods) {    //如果原来没有装备
            if(goods.$count > 0) {
                fighthero.$equipment[newPosition] = goods;

                //计算新属性
                game.objCommonScripts["refresh_combatant"](fighthero);
                //刷新战斗时人物数据
                //loaderFightScene.refreshAllFightRoleInfo();
            }
            return goods.$count;
            //}
        }

        //卸下某装备（所有个数），返回装备对象，没有返回undefined；
        //fighthero为下标，或战斗角色的name，或战斗角色对象；
        //返回旧装备；
        readonly property var unload: function(fighthero, positionName) {

            if(fighthero < 0)
                return false;

            //找到fighthero
            fighthero = game.fighthero(fighthero);
            if(!fighthero)
                return false;



            //if(goods === undefined || goods === null)
            //    return null;


            let oldEquip = fighthero.$equipment[positionName];

            /*
            if(game.objCommonScripts["equip_reserved_slots"].indexOf(positionName) !== -1)
                fighthero.$equipment[positionName] = undefined;
            else
                delete fighthero.$equipment[positionName];
            */
            delete fighthero.$equipment[positionName];


            //计算新属性
            game.objCommonScripts["refresh_combatant"](fighthero);
            //刷新战斗时人物数据
            //loaderFightScene.refreshAllFightRoleInfo();

            return oldEquip;
        }

        //返回某 fighthero 的装备；如果positionName为null，则返回所有装备；
        //fighthero为下标，或战斗角色的name，或战斗角色对象；
        //返回格式：单个：装备对象，多个：单个的数组；
        //错误返回null。
        readonly property var equipment: function(fighthero, positionName=null) {

            if(fighthero < 0)
                return false;

            //找到fighthero
            fighthero = game.fighthero(fighthero);
            if(!fighthero)
                return false;



            //返回多个
            if(positionName === false || positionName === null || positionName === undefined) {

                let ret = [];

                for(let te in fighthero.$equipment) {
                    ret.push(fighthero.$equipment[te]);
                }

                return ret;
            }

            //返回单个
            return fighthero.$equipment[positionName];
        }

        //进入交易界面；
        //goods为买的物品rid列表；
        //mygoodsinclude为true表示可卖背包内所有物品，为数组则为数组中可交易的物品列表；
        //callback为交易结束后的脚本。
        readonly property var trade: function(goods=[], mygoodsinclude=true, callback=null, pauseGame=true) {

            //是否暂停游戏
            if(pauseGame) {
                game.pause('$trade');

                //dialogGameMsg.focus = true;
            }
            else {
            }



            dialogTrade.init(goods, mygoodsinclude, callback);
        }

        //获得金钱；返回金钱数目；
        readonly property var money: function(m) {
            if(!game.gd["$sys_money"]) {
                game.gd["$sys_money"] = 0;
            }
            if(m)
                game.gd["$sys_money"] += m;
            return game.gd["$sys_money"];
        }


        //载入 fightScript 脚本 并进入战斗；
        //fightScript可以为 战斗脚本资源名、标准创建格式的对象（带有RId、Params和其他属性），或战斗脚本对象本身（带有$rid）；
        //params是给战斗脚本$createData的参数。
        readonly property var fighting: function(fightScript) {
            let fightHeros = game.fighthero();
            if(fightHeros.length === 0) {
                game.run(function *(){yield game.msg('没有战斗人物', 10);});
                return;
            }

            //game.pause();
            //_private.nStage = 1;


            loaderFightScene.visible = true;
            loaderFightScene.focus = true;
            //loaderFightScene.test();
            //loaderFightScene.init(_public.getFightScriptObject(fightScript));
            game.run(loaderFightScene.init, -1, _public.getFightScriptObject(fightScript));
        }

        //载入 fightScript 脚本 并开启随机战斗；每过 interval 毫秒执行一次 百分之probability 的概率 是否进入随机战斗；
        //fightScript可以为 战斗脚本资源名、标准创建格式的对象（带有RId、Params和其他属性），或战斗脚本对象本身（带有$rid）；
        //flag：0b1为行动时遇敌，0b10为静止时遇敌；
        //params是给战斗脚本$createData的参数；
        //会覆盖之前的fighton；
        readonly property var fighton: function(fightScript, probability=5, flag=3, interval=1000) {
            game.gd["$sys_random_fight"] = [fightScript, probability, flag, interval];

            game.deltimer("$sys_random_fight_timer", true);
            game.addtimer("$sys_random_fight_timer", interval, -1, true);
            game.gf["$sys_random_fight_timer"] = function() {

                //判断行动或静止状态

                //行动中
                if(_private.getSpritePlay(mainRole)) {
                    if((0b1 & flag) === 0)
                        return;
                }
                else {
                    if((0b10 & flag) === 0)
                        return;
                }


                if(GlobalLibraryJS.randTarget(probability, 100) === 1) {
                    //game.createfightenemy();
                    game.fighting(fightScript);
                }
            }
        }

        //关闭随机战斗。
        readonly property var fightoff: function() {
            delete game.gd["$sys_random_fight"];

            game.deltimer("$sys_random_fight_timer", true);
            delete game.gf["$sys_random_fight_timer"];
        }

        //加入定时器；
        //timerName：定时器名称；interval：定时器间隔；times：触发次数（-1为无限）；bGlobal：是否是全局定时器；
        //成功返回true。
        readonly property var addtimer: function(timerName, interval, times, bGlobal=false) {
            let objTimer;
            if(bGlobal)
                objTimer = _private.objGlobalTimers;
            else
                objTimer = _private.objTimers;

            if(objTimer[timerName] !== undefined)
                return false;

            objTimer[timerName] = [interval, times, interval];
            return true;
        }

        //删除定时器。
        readonly property var deltimer: function(timerName, bGlobal=false) {
            let objTimer;
            if(bGlobal)
                objTimer = _private.objGlobalTimers;
            else
                objTimer = _private.objTimers;

            delete objTimer[timerName];
        }


        //播放音乐；
        //music为音乐名；
        //params为参数；
        //  $loops为循环次数，空或0表示无限循环；
        //成功返回true。
        readonly property var playmusic: function(music, params={}) {
            let filePath = GameMakerGlobal.musicResourceURL(music);
            //if(!FrameManager.sl_qml_FileExists(Global.toPath(filePath))) {
            //    console.warn('[!GameScene]video no exist：', video, filePath)
            //    return false;
            //}

            //if(_private.objMusic[musicRId] === undefined)
            //    return false;

            if(!params.$loops)
                params.$loops = Audio.Infinite;

            audioBackgroundMusic.source = Global.toURL(filePath);
            audioBackgroundMusic.loops = params.$loops;
            itemBackgroundMusic.play();

            game.gd["$sys_music"] = music;

            //console.debug("~~~playmusic:", _private.objMusic[musicRId], Global.toURL(GameMakerGlobal.musicResourceURL(_private.objMusic[musicRId])));
            //console.debug("~~~playmusic:", audioBackgroundMusic.source, audioBackgroundMusic.source.toString());

            return true;
        }

        //停止音乐。
        readonly property var stopmusic: function() {
            itemBackgroundMusic.stop();
        }

        //暂停音乐。
        readonly property var pausemusic: function(name='$user') {
            itemBackgroundMusic.pause(name);
        }

        //继续播放音乐。
        readonly property var resumemusic: function(name='$user') {
            itemBackgroundMusic.resume(name);
        }
        //将音乐暂停并存栈。一般用在需要播放战斗音乐前。
        readonly property var pushmusic: function() {
            itemBackgroundMusic.arrMusicStack.push([game.gd["$sys_music"], audioBackgroundMusic.position]);
            itemBackgroundMusic.stop();
        }
        //播放上一次存栈的音乐。一般用在战斗结束后（$commonFightEndScript已调用，不用写在战斗结束脚本中）。
        readonly property var popmusic: function() {
            if(itemBackgroundMusic.arrMusicStack.length === 0)
                return;
            let m = itemBackgroundMusic.arrMusicStack.pop();
            game.gd["$sys_music"] = m[0];
            audioBackgroundMusic.source = Global.toURL(GameMakerGlobal.musicResourceURL(game.gd["$sys_music"]));
            audioBackgroundMusic.seek(m[1]);
            //if(m[2])
                itemBackgroundMusic.play();
            //else
            //    itemBackgroundMusic.stop();
        }
        readonly property var seekmusic: function(offset=0) {
            audioBackgroundMusic.seek(offset);
        }

        readonly property var musicplaying: function() {
            return itemBackgroundMusic.isPlaying();
        }
        readonly property var musicpausing: function($name) {
            return itemBackgroundMusic.objMusicPause[$name] !== undefined;
        }
        readonly property var soundeffectpausing: function() {
            return rootGameScene._private.config.nSoundConfig !== 0;
        }


        //播放视频
        //video是视频名称；properties包含两个属性：$videoOutput（包括x、y、width、height等） 和 $mediaPlayer；
        //  也可以 $x、$y、$width、$height。
        readonly property var playvideo: function(video, properties={}, pauseGame=true) {

            //是否暂停游戏
            if(pauseGame) {
                game.pause('$video');

                //dialogGameMsg.focus = true;
            }
            else {
            }


            let filePath = GameMakerGlobal.videoResourceURL(video);
            //if(!FrameManager.sl_qml_FileExists(Global.toPath(filePath))) {
            //    console.warn('[!GameScene]video no exist：', video, filePath)
            //    return false;
            //}

            //if(_private.objVideos[videoRId] === undefined)
            //    return false;
            if(properties === undefined)
                properties = {};

            if(properties.$videoOutput === undefined)
                properties.$videoOutput = {};
            if(properties.$mediaPlayer === undefined)
                properties.$mediaPlayer = {};


            if(properties.$videoOutput.$width === undefined && properties.$width === undefined)
                videoOutput.width = Qt.binding(function(){return videoOutput.implicitWidth});
            else if(properties.$width === -1)
                videoOutput.width = rootGameScene.width;
            else if(GlobalLibraryJS.isValidNumber(properties.$width)) {
                videoOutput.width = properties.$width * Screen.pixelDensity;
            }

            if(properties.$videoOutput.$height === undefined && properties.$height === undefined)
                videoOutput.height = Qt.binding(function(){return videoOutput.implicitHeight});
            else if(properties.$height === -1)
                videoOutput.height = rootGameScene.height;
            else if(GlobalLibraryJS.isValidNumber(properties.$height)) {
                videoOutput.height = properties.$height * Screen.pixelDensity;
            }


            mediaPlayer.source = Global.toURL(filePath);

            GlobalLibraryJS.copyPropertiesToObject(videoOutput, properties.$videoOutput, {onlyCopyExists: true});
            GlobalLibraryJS.copyPropertiesToObject(mediaPlayer, properties.$mediaPlayer, {onlyCopyExists: true});
            /*
            let tKeys = Object.keys(videoOutput);
            for(let tp in properties)
                if(tKeys.indexOf(tp) >= 0)
                    videoOutput[tp] = properties[tp];
            */

            itemVideo.visible = true;

            mediaPlayer.play();
            gameScene.color='#CCFFFFFF';
            console.debug(gameScene.color)
            console.debug(gameScene.color==='#ccffffff');
        }
        //结束播放
        readonly property var stopvideo: function() {
            itemVideo.visible = false;
            mediaPlayer.stop();
            mediaPlayer.source = '';


            if(_private.config.objPauseNames['$video'] !== undefined) {
                game.goon('$video');
                _private.asyncScript.run();
            }

        }

        //显示图片；
        //image为图片名；properties为图片属性；id为图片标识（用来控制和删除）；
        //properties：包含 Image组件 的所有属性 和 $x、$y、$width、$height、$parent 等属性；还包括 $clicked、$doubleClicked 事件的回调函数；
        //  x、y、width、height 和 $x、$y、$width、$height 是坐标和宽高，每组（带$和不带$）只需填一种；
        //    不带$表示按像素；
        //    带$的属性有以下几种格式：
        //      $x、$y：如果为数字，则表示坐标是按固定长度（厘米）为单位的长度（跨平台用）；
        //        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填x、y 和 $x、$y 作用相同；为2表示全屏的百分比；为3表示居中后偏移多少像素，为4表示居中后偏移多少固定长度；
        //      $width、$height：如果为数字，则表示按固定长度（厘米）为单位的长度（跨平台用）；
        //        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填width、height 和 $width、$height 作用 相同；为2表示全屏的多少倍；为3表示自身的多少倍；为4表示是 固定宽高比 的多少倍；
        //  $parent：0表示显示在屏幕上（默认）；1表示显示在屏幕上（受scale影响）；2表示显示在地图上；字符串表示显示在某个角色上；
        readonly property var showimage: function(image, properties={}, id=undefined) {
            let filePath = GameMakerGlobal.imageResourceURL(image);
            //if(!FrameManager.sl_qml_FileExists(Global.toPath(filePath))) {
            //    console.warn('[!GameScene]image no exist：', video, filePath)
            //    return false;
            //}

            //if(_private.objImages[image] === undefined)
            //    return false;

            if(id === undefined || id === null)
                id = image;

            /*image.source = Global.toURL(GameMakerGlobal.imageResourceURL(imageRId));
            image.x = x;
            image.y = y;
            if(w === -1)
                image.width = rootGameScene.width;
            else
                image.width = w;
            if(h === -1)
                image.height = rootGameScene.height;
            else
                image.height = h;
            */

            //properties.source = Global.toURL(filePath);


            let tmp = _private.objTmpImages[id];
            //如果缓存中没有，则创建
            if(!tmp) {
                //let image = Qt.createQmlObject("import QtQuick 2.14; Image {}", rootGameScene);

                tmp = compCacheImage.createObject(null, {source: Global.toURL(filePath)});
                //随场景缩放
                //tmp = compCacheImage.createObject(gameScene, {source: Global.toURL(filePath)});
                //tmp = compCacheImage.createObject(rootGameScene, {source: Global.toURL(filePath)});
                //随地图移动
                //tmp = compCacheImage.createObject(itemContainer, {source: Global.toURL(filePath)});

                _private.objTmpImages[id] = tmp;
                tmp.id = id;
                //tmp.anchors.centerIn = rootGameScene;
            }
            //取出组件，循环赋值
            else {
                tmp.visible = false;
                tmp.source = Global.toURL(filePath);
                //tmp.parent = properties.$parent;
                /*
                let tKeys = Object.keys(tmp);
                for(let tp in properties)
                    if(tKeys.indexOf(tp) >= 0)
                        tmp[tp] = properties[tp];
                */
            }


            //会改变大小
            if(properties.$parent === 1)
                properties.$parent = gameScene;
            //会改变大小和随地图移动
            else if(properties.$parent === 2) {
                properties.$parent = itemContainer;
                _private.arrayMapComponents.push(tmp);
            }
            //某角色上
            else if(GlobalLibraryJS.isString(properties.$parent)) {
                let role = game.hero(properties.$parent);
                if(!role)
                    role = game.role(properties.$parent);
                if(role) {
                    properties.$parent = role;
                    role.$components.push(tmp);
                }
            }
            //固定屏幕上
            else
                properties.$parent = itemComponentsContainer;

            tmp.parent = properties.$parent;


            //if(_private.objSprites[imageRId] === undefined) {
            //    _private.objSprites[imageRId].$$cache = {image: image};
            //}


            //宽高比固定，为1 宽度适应高度，为2高度适应宽度
            let widthOrHeightAdaption = 0;

            //默认原宽度
            if(properties.$width === undefined && properties.width === undefined)
                tmp.width = tmp.implicitWidth;
            //屏宽
            else if(properties.$width === -1)
                tmp.width = Qt.binding(function(){return itemComponentsContainer.width});
            else if(GlobalLibraryJS.isArray(properties.$width)) {
                switch(properties.$width[1]) {
                //如果是 固定宽度
                case 1:
                    tmp.width = properties.$width[0] * Screen.pixelDensity;
                    break;
                //如果是 全屏百分比
                case 2:
                    tmp.width = Qt.binding(function(){return properties.$width[0] * itemComponentsContainer.width});
                    break;
                //如果是 自身百分比
                case 3:
                    tmp.width = properties.$width[0] * tmp.implicitWidth;
                    break;
                //宽度适应高度
                case 4:
                    widthOrHeightAdaption = 1;
                    break;
                //跨平台宽度
                case 5:
                    tmp.width = Qt.binding(function(){return Global.dpW(properties.$width[0])});
                    break;
                //按像素
                default:
                    tmp.width = properties.$width[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(properties.$width)) {
                tmp.width = properties.$width * Screen.pixelDensity;
            }

            //默认原高
            if(properties.$height === undefined && properties.height === undefined)
                tmp.height = tmp.implicitHeight;
            //屏高
            else if(properties.$height === -1)
                tmp.height = Qt.binding(function(){return itemComponentsContainer.height});
            else if(GlobalLibraryJS.isArray(properties.$height)) {
                switch(properties.$height[1]) {
                //如果是 固定高度
                case 1:
                    tmp.height = properties.$height[0] * Screen.pixelDensity;
                    break;
                //如果是 全屏百分比
                case 2:
                    tmp.height = Qt.binding(function(){return properties.$height[0] * itemComponentsContainer.height});
                    break;
                //如果是 自身百分比
                case 3:
                    tmp.height = properties.$height[0] * tmp.implicitHeight;
                    break;
                //高度适应宽度
                case 4:
                    widthOrHeightAdaption = 2;
                    break;
                //跨平台高度
                case 5:
                    tmp.height = Qt.binding(function(){return Global.dpH(properties.$height[0])});
                    break;
                //按像素
                default:
                    tmp.height = properties.$height[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(properties.$height)) {
                tmp.height = properties.$height * Screen.pixelDensity;
            }

            //宽度适应高度、高度适应宽度（乘以倍率）
            if(widthOrHeightAdaption === 1)
                tmp.width = tmp.height / tmp.implicitHeight * tmp.implicitWidth * properties.$width[0];
            else if(widthOrHeightAdaption === 2)
                tmp.height = tmp.width / tmp.implicitWidth * tmp.implicitHeight * properties.$height[0];


            //默认居中
            if(properties.$x === undefined && properties.x === undefined)
                tmp.x = Qt.binding(function(){return (properties.$parent.width - tmp.width) / 2});
                //tmp.x = (properties.$parent.width - tmp.width) / 2;
            else if(GlobalLibraryJS.isArray(properties.$x)) {
                switch(properties.$x[1]) {
                //如果是 固定长度
                case 1:
                    tmp.x = properties.$x[0] * Screen.pixelDensity;
                    break;
                //如果是 全屏百分比
                case 2:
                    tmp.x = Qt.binding(function(){return properties.$x[0] * itemComponentsContainer.width});
                    break;
                //如果是 居中偏移像素
                case 3:
                    tmp.x = Qt.binding(function(){return properties.$x[0] + (itemComponentsContainer.width - tmp.width) / 2});
                    break;
                //如果是 居中偏移固定长度
                case 4:
                    tmp.x = Qt.binding(function(){return properties.$x[0] * Screen.pixelDensity + (itemComponentsContainer.width - tmp.width) / 2});
                    break;
                //跨平台x
                case 5:
                    tmp.x = Qt.binding(function(){return Global.dpW(properties.$x[0])});
                    break;
                //按像素
                default:
                    tmp.x = properties.$x[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(properties.$x)) {
                tmp.x = properties.$x * Screen.pixelDensity;
            }

            //默认居中
            if(properties.$y === undefined && properties.y === undefined)
                tmp.y = Qt.binding(function(){return (properties.$parent.height - tmp.height) / 2});
                //tmp.y = (properties.$parent.height - tmp.height) / 2;
            else if(GlobalLibraryJS.isArray(properties.$y)) {
                switch(properties.$y[1]) {
                //如果是 固定长度
                case 1:
                    tmp.y = properties.$y[0] * Screen.pixelDensity;
                    break;
                //如果是 全屏百分比
                case 2:
                    tmp.y = Qt.binding(function(){return properties.$y[0] * itemComponentsContainer.height});
                    break;
                //如果是 居中偏移像素
                case 3:
                    tmp.y = Qt.binding(function(){return properties.$y[0] + (itemComponentsContainer.height - tmp.height) / 2});
                    break;
                //如果是 居中偏移固定长度
                case 4:
                    tmp.y = Qt.binding(function(){return properties.$y[0] * Screen.pixelDensity + (itemComponentsContainer.height - tmp.height) / 2});
                    break;
                //跨平台y
                case 5:
                    tmp.y = Qt.binding(function(){return Global.dpH(properties.$y[0])});
                    break;
                //按像素
                default:
                    tmp.y = properties.$y[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(properties.$y)) {
                tmp.y = properties.$y * Screen.pixelDensity;
            }


            if(properties.$clicked === null)
                tmp.clicked = function(image){game.delimage(image.id)};
            else// if(properties.$clicked !== undefined)
                tmp.clicked = properties.$clicked;


            if(properties.$doubleClicked === null)
                tmp.doubleClicked = function(image){game.delimage(image.id)};
            else// if(properties.$doubleClicked !== undefined)
                tmp.doubleClicked = properties.$doubleClicked;


            if(properties.$visible === undefined)
                properties.visible = true;
            else
                properties.visible = properties.$visible;



            GlobalLibraryJS.copyPropertiesToObject(tmp, properties, {onlyCopyExists: true, objectRecursion: 0});


            return id;
        }
        //删除图片，id为图片标识
        readonly property var delimage: function(id=-1) {
            if(id === undefined || id === null || id === -1) {
                for(let ti in _private.objTmpImages)
                    _private.objTmpImages[ti].destroy();

                _private.objTmpImages = {};
                return true;
            }

            let image = _private.objTmpImages[id];
            if(image) {
                image.destroy();
                delete _private.objTmpImages[id];

                return true;
            }
            return false;
        }

        //显示精灵
        //spriteEffectRId为精灵名；properties为精灵属性；id为精灵标识（用来控制和删除）
        //properties：包含 SpriteEffect组件 的所有属性 和 $x、$y、$width、$height、$parent 等属性；还包括 $clicked、$doubleClicked、$looped、$finished 事件的回调函数；
        //  x、y、width、height 和 $x、$y、$width、$height 是坐标和宽高，每组（带$和不带$）只需填一种；
        //    不带$表示按像素；
        //    带$的属性有以下几种格式：
        //      $x、$y：如果为数字，则表示坐标是按固定长度（厘米）为单位的长度（跨平台用）；
        //        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填x、y 和 $x、$y 作用相同；为2表示全屏的百分比；为3表示居中后偏移多少像素，为4表示居中后偏移多少固定长度；
        //      $width、$height：如果为数字，则表示按固定长度（厘米）为单位的长度（跨平台用）；
        //        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填width、height 和 $width、$height 作用 相同；为2表示全屏的多少倍；为3表示自身的多少倍；为4表示是 固定宽高比 的多少倍；
        //  $parent：0表示显示在屏幕上（默认）；1表示显示在屏幕上（受scale影响）；2表示显示在地图上；字符串表示显示在某个角色上；
        readonly property var showsprite: function(spriteEffectRId, properties={}, id=undefined) {
            if(_private.objSprites[spriteEffectRId] === undefined)
                return false;

            if(id === undefined || id === null)
                id = spriteEffectRId;

            /*image.source = Global.toURL(GameMakerGlobal.imageResourceURL(spriteEffectRId));
            image.x = x;
            image.y = y;
            if(w === -1)
                image.width = rootGameScene.width;
            else
                image.width = w;
            if(h === -1)
                image.height = rootGameScene.height;
            else
                image.height = h;
            */

            //let data = game.objSprites[spriteEffectRId];
            //properties.spriteSrc = Global.toURL(GameMakerGlobal.spriteResourceURL(data.Image));



            if(properties.$loops === undefined)
                properties.$loops = 1;


            //载入资源
            let sprite = _private.objTmpSprites[id];
            sprite = _public.loadSpriteEffect(spriteEffectRId, sprite, properties.$loops, properties.$parent);
            sprite.visible = false;
            _private.objTmpSprites[id] = sprite;
            sprite.id = id;


            //会改变大小
            if(properties.$parent === 1)
                properties.$parent = gameScene;
            //会改变大小和随地图移动
            else if(properties.$parent === 2) {
                properties.$parent = itemContainer;
                _private.arrayMapComponents.push(sprite);
            }
            //某角色上
            else if(GlobalLibraryJS.isString(properties.$parent)) {
                let role = game.hero(properties.$parent);
                if(!role)
                    role = game.role(properties.$parent);
                if(role) {
                    properties.$parent = role;
                    role.$components.push(sprite);
                }
            }
            //固定屏幕上
            else
                properties.$parent = itemComponentsContainer;

            sprite.parent = properties.$parent;




            //改变大小和位置

            //宽高比固定，为1 宽度适应高度，为2高度适应宽度
            let widthOrHeightAdaption = 0;

            //改变大小
            //默认原宽
            if(properties.$width  === undefined && properties.width === undefined)
                sprite.width = sprite.implicitWidth;
            //屏宽
            else if(properties.$width === -1)
                sprite.width = Qt.binding(function(){return itemComponentsContainer.width});
            else if(GlobalLibraryJS.isArray(properties.$width)) {
                switch(properties.$width[1]) {
                //如果是 固定宽度
                case 1:
                    sprite.width = properties.$width[0] * Screen.pixelDensity;
                    break;
                //如果是 全屏百分比
                case 2:
                    sprite.width = Qt.binding(function(){return properties.$width[0] * itemComponentsContainer.width});
                    break;
                //如果是 自身百分比
                case 3:
                    sprite.width = properties.$width[0] * sprite.implicitWidth;
                    break;
                //宽度适应高度
                case 4:
                    widthOrHeightAdaption = 1;
                    break;
                //跨平台宽度
                case 5:
                    sprite.width = Qt.binding(function(){return Global.dpW(properties.$width[0])});
                    break;
                //按像素
                default:
                    sprite.width = properties.$width[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(properties.$width)) {
                sprite.width = properties.$width * Screen.pixelDensity;
            }

            //默认原高
            if(properties.$height === undefined && properties.height === undefined)
                sprite.height = sprite.implicitHeight;
            //全屏
            else if(properties.$height === -1)
                sprite.height = Qt.binding(function(){return itemComponentsContainer.height});
            else if(GlobalLibraryJS.isArray(properties.$height)) {
                switch(properties.$height[1]) {
                //如果是 固定高度
                case 1:
                    sprite.height = properties.$height[0] * Screen.pixelDensity;
                    break;
                //如果是 全屏百分比
                case 2:
                    sprite.height = Qt.binding(function(){return properties.$height[0] * itemComponentsContainer.height});
                    break;
                //如果是 自身百分比
                case 3:
                    sprite.height = properties.$height[0] * sprite.implicitHeight;
                    break;
                //高度适应宽度
                case 4:
                    widthOrHeightAdaption = 2;
                    break;
                //跨平台高度
                case 5:
                    sprite.height = Qt.binding(function(){return Global.dpH(properties.$height[0])});
                    break;
                //按像素
                default:
                    sprite.height = properties.$height[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(properties.$height)) {
                sprite.height = properties.$height * Screen.pixelDensity;
            }

            //宽度适应高度、高度适应宽度（乘以倍率）
            if(widthOrHeightAdaption === 1)
                sprite.width = sprite.height / sprite.implicitHeight * sprite.implicitWidth * properties.$width[0];
            else if(widthOrHeightAdaption === 2)
                sprite.height = sprite.width / sprite.implicitWidth * sprite.implicitHeight * properties.$height[0];


            //默认居中
            if(properties.$x === undefined && properties.x === undefined)
                sprite.x = Qt.binding(function(){return (properties.$parent.width - sprite.width) / 2});
                //sprite.x = (properties.$parent.width - sprite.width) / 2;
            else if(GlobalLibraryJS.isArray(properties.$x)) {
                switch(properties.$x[1]) {
                //如果是 固定长度
                case 1:
                    sprite.x = properties.$x[0] * Screen.pixelDensity;
                    break;
                //如果是 全屏百分比
                case 2:
                    sprite.x = Qt.binding(function(){return properties.$x[0] * itemComponentsContainer.width});
                    break;
                //如果是 居中偏移像素
                case 3:
                    sprite.x = Qt.binding(function(){return properties.$x[0] + (itemComponentsContainer.width - sprite.width) / 2});
                    break;
                //如果是 居中偏移固定长度
                case 4:
                    sprite.x = Qt.binding(function(){return properties.$x[0] * Screen.pixelDensity + (itemComponentsContainer.width - sprite.width) / 2});
                    break;
                //跨平台x
                case 5:
                    sprite.x = Qt.binding(function(){return Global.dpW(properties.$x[0])});
                    break;
                //按像素
                default:
                    sprite.x = properties.$x[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(properties.$x)) {
                sprite.x = properties.$x * Screen.pixelDensity;
            }

            //默认居中
            if(properties.$y === undefined && properties.y === undefined)
                sprite.y = Qt.binding(function(){return (properties.$parent.height - sprite.height) / 2});
                //sprite.y = (properties.$parent.height - sprite.height) / 2;
            else if(GlobalLibraryJS.isArray(properties.$y)) {
                switch(properties.$y[1]) {
                //如果是 固定长度
                case 1:
                    sprite.y = properties.$y[0] * Screen.pixelDensity;
                    break;
                //如果是 全屏百分比
                case 2:
                    sprite.y = Qt.binding(function(){return properties.$y[0] * itemComponentsContainer.height});
                    break;
                //如果是 居中偏移像素
                case 3:
                    sprite.y = Qt.binding(function(){return properties.$y[0] + (itemComponentsContainer.height - sprite.height) / 2});
                    break;
                //如果是 居中偏移固定长度
                case 4:
                    sprite.y = Qt.binding(function(){return properties.$y[0] * Screen.pixelDensity + (itemComponentsContainer.height - sprite.height) / 2});
                    break;
                //跨平台y
                case 5:
                    sprite.y = Qt.binding(function(){return Global.dpH(properties.$y[0])});
                    break;
                //按像素
                default:
                    sprite.y = properties.$y[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(properties.$y)) {
                sprite.y = properties.$y * Screen.pixelDensity;
            }


            if(properties.$clicked === null)
                sprite.clicked = function(sprite){game.delsprite(sprite.id)};
            else// if(properties.$clicked !== undefined)
                sprite.clicked = properties.$clicked;

            if(properties.$doubleClicked === null)
                sprite.doubleClicked = function(sprite){game.delsprite(sprite.id)};
            else// if(properties.$doubleClicked !== undefined)
                sprite.doubleClicked = properties.$doubleClicked;


            if(properties.$looped === null)
                //sprite.looped = function(sprite){game.delsprite(sprite.id)};
                sprite.looped = null;
            else// if(properties.$looped !== undefined)
                sprite.looped = properties.$looped;

            if(properties.$finished === null)
                //sprite.finished = function(sprite){game.delsprite(sprite.id)};
                sprite.finished = null;
            else// if(properties.$finished !== undefined)
                sprite.finished = properties.$finished;



            if(properties.$visible === undefined)
                properties.visible = true;
            else
                properties.visible = properties.$visible;



            GlobalLibraryJS.copyPropertiesToObject(sprite, properties, {onlyCopyExists: true, objectRecursion: 0});
            /*/复制属性
            let tKeys = Object.keys(sprite);
            for(let tp in properties)
                if(tKeys.indexOf(tp) >= 0)
                    sprite[tp] = properties[tp];
            */

            //if(_private.objSprites[spriteEffectRId] === undefined) {
            //    _private.objSprites[spriteEffectRId].$$cache = {sprite: sprite};
            //}

            //sprite.visible = true;

            sprite.restart();

            return id;
        }

        //删除精灵，id为精灵标识
        readonly property var delsprite: function(id=-1) {
            if(id === undefined || id === null || id === -1) {
                for(let ti in _private.objTmpSprites)
                    _private.objTmpSprites[ti].destroy();

                _private.objTmpSprites = {};
                return true;
            }

            let sprite = _private.objTmpSprites[id];
            if(sprite) {
                sprite.destroy();
                delete _private.objTmpSprites[id];

                return true;
            }

            return false;
        }


        //设置操作（遥感可用和可见、键盘可用）；
        //参数$gamepad的$visible和$enabled，$keyboard的$enabled；
        //参数为空则返回遥感组件，可自定义；
        readonly property var control: function(config={}) {
            if(!config)
                return itemGamePad;

            if(config && config.$gamepad) {
                if(config.$gamepad.$visible !== undefined)
                    itemGamePad.visible = config.$gamepad.$visible;
                if(config.$gamepad.$enabled !== undefined)
                    itemGamePad.enabled = config.$gamepad.$enabled;
            }
            if(config && config.$keyboard) {
                if(config.$keyboard.$enabled !== undefined)
                    _private.config.bKeyboard = config.$keyboard.$enabled;
            }
        }

        //将场景缩放n倍；可以是小数。
        readonly property var scale: function(n) {
            gameScene.scale = parseFloat(n);
            setMapToRole(mainRole);

            game.gd["$sys_scale"] = n;
        }

        //暂停游戏。
        readonly property var pause: function(name='$user_pause') {
            if(name === undefined || name === null)
                return !GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames);
            if(name === true)
                return _private.config.objPauseNames;

            //战斗模式不能设置
            //if(_private.nStage === 1)
            //    return;

            timer.stop();
            _private.stopAction(1, -1);

            if(_private.config.objPauseNames[name] > 0) {
                ++_private.config.objPauseNames[name];
                console.warn('游戏被多次暂停 (%1：%2)，请检查是否有暂停游戏的指令（比如msg、menu等）没有使用yield？'.arg(name).arg(_private.config.objPauseNames[name]));
            }
            else
                _private.config.objPauseNames[name] = 1;
            //_private.config.objPauseNames[name] = (_private.config.objPauseNames[name] ? _private.config.objPauseNames[name] + 1 : 1);

            //joystick.enabled = false;
            //buttonA.enabled = false;
        }
        //继续游戏。
        readonly property var goon: function(name='$user_pause') {
            //战斗模式不能设置
            //if(_private.nStage === 1)
            //    return;


            if(name === true) {
                _private.config.objPauseNames = {};
            }
            else {
                if(_private.config.objPauseNames[name]) {
                    --_private.config.objPauseNames[name];
                    if(_private.config.objPauseNames[name] === 0)
                        delete _private.config.objPauseNames[name];
                }
                else {
                    //rootGameScene.forceActiveFocus();
                    //return;
                }
            }


            if(GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames)) {
                timer.start();
                //_private.config.bPauseGame = false;
            }

            //joystick.enabled = true;
            //buttonA.enabled = true;

            rootGameScene.forceActiveFocus();
        }

        //设置游戏刷新率（interval毫秒）。
        readonly property var setinterval: function(interval) {
            if(GlobalLibraryJS.isValidNumber(interval)) {
                _private.config.nInterval = interval;
            }

            if(_private.config.nInterval <= 0)
                _private.config.nInterval = 16;
            timer.interval = _private.config.nInterval;
            game.gd["$sys_fps"] = _private.config.nInterval;
        }

        //暂停time毫秒。
        readonly property var wait: function(ms) {
            _private.asyncScript.wait(ms);
        }

        //返回start~end之间的随机整数（包含start，不包含end）。
        readonly property var rnd: function(start, end) {
            return GlobalLibraryJS.random(start, end);
        }
        //显示msg提示。
        readonly property var toast: function(msg) {
            Platform.showToast(msg);
        }

        //显示窗口；
        //params：
        //  $id：0b1为主菜单；0b10为战斗人物信息；0b100为道具信息；0b1000为系统菜单；
        //  $value：战斗人物信息时为下标；
        //  $visible：为false表示关闭窗口；
        //style：样式，包括MaskColor、BorderColor、BackgroundColor、ItemFontSize、ItemFontColor、ItemBackgroundColor1、ItemBackgroundColor2、TitleFontSize、TitleBackgroundColor、TitleFontColor、ItemBorderColor；
        readonly property var window: function(params=null, style={}, pauseGame=true) {
            if(GlobalLibraryJS.isValidNumber(params))
                params = {$id: params, $visible: true};
            else if(!params) {
                params = {$id: 0b1111, $visible: true};
            }

            if(params.$visible !== false) {

                if(pauseGame)
                    game.pause('$menu_window');

                /*switch(params.$id) {
                case 1:
                    break;
                case 2:
                    break;
                }*/
                gameMenuWindow.showWindow(params.$id, params.$value, style);
            }
            else
                gameMenuWindow.closeWindow(params.$id);

        }

        //检测存档是否存在且正确，失败返回false，成功返回存档对象（包含Name和Data）。
        readonly property var checksave: function(fileName) {
            fileName = fileName.trim();
            let filePath = GameMakerGlobal.config.strSaveDataPath + GameMakerGlobal.separator + fileName + ".json";
            if(!FrameManager.sl_qml_FileExists(Global.toPath(filePath)))
                return false;

            let data = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));
            //let cfg = File.read(filePath);
            //console.debug("musicInfo", filePath, musicInfo)
            //console.debug("cfg", cfg, filePath);

            if(data !== "") {
                data = JSON.parse(data);

                if(GameMakerGlobal.config.debug === false && data.Verify !== Qt.md5(_private.strSaveDataSalt + JSON.stringify(data["Data"])))
                    return false;

                return data;
            }
            return false;
        }

        //!!存档，showName为显示名。
        //game.gd 开头为 $$ 的键不会保存
        readonly property var save: function(fileName="autosave", showName='') {
            fileName = fileName.trim();
            if(!fileName)
                fileName = "autosave";



            //载入save脚本
            if(_private.objCommonScripts["game_save_script"])
                game.run([_private.objCommonScripts["game_save_script"](), '$save'], -2);



            let fSaveFilter = function(k, v) {
                if(k.indexOf("$$") === 0)
                    return undefined;
                return v;
            }

            let filePath = GameMakerGlobal.config.strSaveDataPath + GameMakerGlobal.separator + fileName + ".json";

            let GlobalDataString = JSON.stringify(game.gd, fSaveFilter);

            let outputData = {};

            outputData.Version = "0.6";
            outputData.Data = game.gd;
            outputData.Name = showName;
            outputData.Time = GlobalLibraryJS.formatDate();
            outputData.Verify = Qt.md5(_private.strSaveDataSalt + GlobalDataString);


            //!!!导出为文件
            //console.debug(JSON.stringify(outputData));
            //let ret = File.write(path + GameMakerGlobal.separator + 'map.json', JSON.stringify(outputData));
            let ret = FrameManager.sl_qml_WriteFile(JSON.stringify(outputData, fSaveFilter), Global.toPath(filePath), 0);
            //console.debug(itemContainer.arrCanvasMap[2].toDataURL())


            return ret;

        }

        //读档（读取数据到 game.gd），成功返回true，失败返回false。
        readonly property var load: function(fileName="autosave") {
            //let filePath = GameMakerGlobal.config.strSaveDataPath + GameMakerGlobal.separator + fileName + ".json";

            fileName = fileName.trim();
            if(!fileName)
                fileName = "autosave";


            let ret = checksave(fileName)
            if(ret === false)
                return false;


            release(false);
            init(false, false);


            //game.gd = ret['Data'];
            GlobalLibraryJS.copyPropertiesToObject(game.gd, ret['Data']);


            game.$sys.reloadFightHero();

            //刷新战斗时人物数据
            //loaderFightScene.refreshAllFightRoleInfo();

            game.$sys.reloadGoods();


            //地图
            game.loadmap(game.gd["$sys_map"].$name);

            //读取主角
            for(let th of game.gd["$sys_main_roles"]) {
                let mainRole = game.createhero(th.$rid);
                //game.hero(mainRole, th);
            }

            //开始移动地图
            setMapToRole(mainRole);

            //其他
            game.setinterval(game.gd["$sys_fps"]);
            game.scale(game.gd["$sys_scale"]);
            game.playmusic(game.gd["$sys_music"]);

            if(game.gd["$sys_random_fight"]) {
                game.fighton(...game.gd["$sys_random_fight"]);
            }


            //载入load脚本
            if(_private.objCommonScripts["game_load_script"])
                game.run([_private.objCommonScripts["game_load_script"](), '$load'], -2);


            return true;
        }

        //游戏结束（调用游戏结束脚本）；
        readonly property var gameover: function(params) {
            game.run(game.objCommonScripts["game_over_script"](params));
        }


        //设置游戏阶段（战斗、平时），内部使用
        readonly property var stage: function(nStage=null) {
            if(nStage === undefined || nStage === null)
                return _private.nStage;
            return (_private.nStage = nStage);
        }



        //读取json文件，返回解析后对象
        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var loadjson: function(fileName, filePath="") {
            fileName = fileName.trim();
            if(!fileName)
                return null;

            if(!filePath)
                filePath = game.$projectpath + GameMakerGlobal.separator + fileName;
            else
                filePath = filePath + GameMakerGlobal.separator + fileName;

            let data = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));

            if(!data) {
                console.warn("[!GameScene]loadjson Fail:", filePath);
                return null;
            }
            return JSON.parse(data);
        }


        //将代码放入 系统脚本引擎（asyncScript）中 等候执行；
        //  strScript 为执行脚本（字符串、函数、生成器函数、生成器对象都可以），如果为null则表示强制执行队列；
        //  priority为优先级，-2为立即执行（此时代码前必须有yield），-1为追加到队尾，0为挂到第一个，1以后类推；
        readonly property var run: function(strScript, priority=-1, ...params) {
            if(strScript === undefined) {
                console.warn('鹰：运行脚本未定义!!!');
                return false;
            }

            if(strScript === null) {
                return _private.asyncScript.run();
            }

            if(GlobalJS.createScript(_private.asyncScript, 0, priority, strScript, ...params) === 0)
                return _private.asyncScript.run();
        }

        //将脚本放入 系统脚本引擎（asyncScript）中 等候执行；一般用在编辑器中载入外部脚本文件
        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var script: function(fileName, priority, filePath) {
            fileName = fileName.trim();
            if(!filePath)
                filePath = game.$projectpath + GameMakerGlobal.separator + fileName;
            else
                filePath = filePath + GameMakerGlobal.separator + fileName;

            if(GlobalJS.createScript(_private.asyncScript, 1, priority, filePath) === 0)
                return _private.asyncScript.run();
        }

        //脚本上次返回的值
        readonly property var lastreturn: function() {
            return _private.asyncScript.lastReturnedValue;
        }
        //脚本上次返回的值（return+yield）
        readonly property var lastvalue: function() {
            return _private.asyncScript.lastEscapeValue;
        }

        //运行代码；
        //在这里执行会有上下文环境
        readonly property var evalcode: function(data, filePath="", envs={}) {
            return GlobalJS.Eval(data, filePath, envs);
        }

        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var evalfile: function(fileName, filePath="", envs={}) {
            fileName = fileName.trim();
            if(!filePath)
                filePath = game.$projectpath + GameMakerGlobal.separator + fileName;
            else
                filePath = filePath + GameMakerGlobal.separator + fileName;

            GlobalJS.EvalFile(filePath, envs);
        }

        //用C++执行脚本；已注入game和fight环境
        readonly property var evaluate: function(program, filePath="", lineNumber = 1) {
            return FrameManager.evaluate(program, filePath, lineNumber);
        }
        readonly property var evaluateFile: function(file, path, lineNumber = 1) {
            if(path === undefined) {
                if(FrameManager.globalObject().evaluateFilePath === undefined)
                    FrameManager.globalObject().evaluateFilePath = game.$projectpath;
                path = FrameManager.globalObject().evaluateFilePath;
            }
            else
                FrameManager.globalObject().evaluateFilePath = path;
            return FrameManager.evaluateFile(path + GameMakerGlobal.separator + file, lineNumber);
        }
        readonly property var importModule: function(filePath) {
            return FrameManager.importModule(filePath);
        }


        readonly property var date: ()=>{return new Date();}

        readonly property var math: Math

        readonly property var http: new XMLHttpRequest

        //局部/全局 数据/方法
        property var d: ({})
        property var f: ({})
        property var gd: ({})
        property var gf: ({})



        //项目根目录
        property string $projectpath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName


        //用户脚本（用户 common_scripts.js，如果没有则指向 GameMakerGlobalJS）
        property var $userscripts: null


        //几个脚本（需要重新定义变量指向，否则外部qml和js无法使用）
        readonly property var $globalLibraryJS: GlobalLibraryJS
        readonly property var $global: Global
        readonly property var $globalJS: GlobalJS
        readonly property var $gameMakerGlobal: GameMakerGlobal
        readonly property var $gameMakerGlobalJS: GameMakerGlobalJS
        readonly property var $config: GameMakerGlobal.config

        //插件
        readonly property var $plugins: _private.objPlugins


        //系统 数据 和 函数（一般特殊需求）
        readonly property var $sys: ({
            release: release,
            init: init,

            screen: itemComponentsContainer,    //固定屏幕上
            scene: gameScene,   //会改变大小
            container: itemContainer,   //会改变大小和随地图移动

            interact: _private.buttonAClicked,

            reloadFightHero: function() {
                //重新创建（修复继承链），并计算新属性
                for(let tIndex in game.gd["$sys_fight_heros"]) {
                    game.gd["$sys_fight_heros"][tIndex] = _public.getFightRoleObject(game.gd["$sys_fight_heros"][tIndex], true);


                    /*let t = game.gd["$sys_fight_heros"][tIndex];
                    game.gd["$sys_fight_heros"][tIndex] = new game.objCommonScripts["combatant_class"](t.$rid, t.$name);
                    GlobalLibraryJS.copyPropertiesToObject(game.gd["$sys_fight_heros"][tIndex], t);

                    //game.gd["$sys_fight_heros"][tIndex].__proto__ = game.objCommonScripts["combatant_class"].prototype;
                    //game.gd["$sys_fight_heros"][tIndex].$$fightData = {};
                    //game.gd["$sys_fight_heros"][tIndex].$$fightData.$buffs = {};
                    */


                    game.objCommonScripts["refresh_combatant"](game.gd["$sys_fight_heros"][tIndex]);
                }
            },
            reloadGoods: function() {
                //重新创建（修复继承链）
                for(let tIndex in game.gd["$sys_goods"]) {
                    game.gd["$sys_goods"][tIndex] = _public.getGoodsObject(game.gd["$sys_goods"][tIndex], true);
                }
            },
            getSkillObject: _public.getSkillObject,
            getGoodsObject: _public.getGoodsObject,
            getFightRoleObject: _public.getFightRoleObject,
            getFightScriptObject: _public.getFightScriptObject,

        })



        //地图大小和视窗大小
        readonly property size $mapSize: Qt.size(itemContainer.width, itemContainer.height)
        readonly property size $sceneSize: Qt.size(rootGameScene.width, rootGameScene.height)

        //property real fAspectRatio: Screen.width / Screen.height


        //readonly property alias objRoles: _private.objRoles
        //readonly property alias arrMainRoles: _private.arrMainRoles



        //资源
        readonly property alias objGoods: _private.objGoods
        readonly property alias objSkills: _private.objSkills
        readonly property alias objFightScripts: _private.objFightScripts
        readonly property alias objFightRoles: _private.objFightRoles
        readonly property alias objSprites: _private.objSprites
        readonly property alias objCacheSoundEffects: _private.objCacheSoundEffects

        readonly property alias objCommonScripts: _private.objCommonScripts

        //readonly property alias objTmpImages: _private.objTmpImages
        //readonly property alias objTmpSprites: _private.objTmpSprites

        //readonly property alias objImages: _private.objImages
        //readonly property alias objMusic: _private.objMusic
        //readonly property alias objVideos: _private.objVideos

    }

    property Item mainRole: compRole.createObject(itemRoleContainer);


    property alias _public: _public


    //property alias mainRole: mainRole

    //地图块大小（用于缩放地图块）
    property size sizeMapBlockSize



    //是否是测试模式（不会存档）
    property bool bTest: false



    //游戏开始脚本
    //startScript为true，则载入start.js；为字符串，则直接运行startScript
    function init(startScript=true, bLoadResources=true) {
        game.gd["$sys_fight_heros"] = [];
        //game.gd["$sys_hidden_fight_heros"] = [];
        game.gd["$sys_money"] = 0;
        game.gd["$sys_goods"] = [];
        game.gd["$sys_map"] = {};
        game.gd["$sys_fps"] = 16;
        game.gd["$sys_main_roles"] = [];
        game.gd["$sys_music"] = '';
        game.gd["$sys_scale"] = 1;

        if(bLoadResources)
            loadResources();


        //插件初始化
        for(let tp in _private.objPlugins) {
            if(_private.objPlugins[tp].$init)
                _private.objPlugins[tp].$init();
        }


        //game.gf["$sys"] = _private.objCommonScripts;

        //读取 start.js 脚本
        if(startScript === true) {
            /*
            let filePath = game.$projectpath + GameMakerGlobal.separator + "start.js";
            //let cfg = File.read(filePath);
            let data = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));
            //if(data === "")
            //    return false;
            if(GlobalJS.createScript(_private.asyncScript, 0, 0, eval(data)) === 0)
                _private.asyncScript.run();
            */

            if(_private.objCommonScripts["game_start_script"])
                game.run([_private.objCommonScripts["game_start_script"](), '$start']);
        }
        else if(startScript === false) {

        }
        else {
            game.run([startScript, 'start']);
        }

        if(_private.objCommonScripts["game_init_script"])
            game.run([_private.objCommonScripts["game_init_script"](), '$init']);

        //game.run([function(){game.goon(true);}, 'goon']);

        //进游戏时如果设置了屏幕旋转，则x、y坐标会互换导致出错，所以重新刷新一下屏幕；
        //!!!屏幕旋转会导致 itemContainer 的x、y坐标互换!!!???
        GlobalLibraryJS.setTimeout(function() {
                setMapToRole(mainRole);
            },10,rootGameScene
        );
    }

    //载入资源
    function loadResources() {

        let projectpath = game.$projectpath + GameMakerGlobal.separator;



        //读通用算法脚本
        let tCommoncript;
        if(FrameManager.sl_qml_FileExists(Global.toPath(projectpath + 'common_script.js')))
            tCommoncript = _private.jsEngine.load('common_script.js', Global.toURL(projectpath));
        if(tCommoncript) {
            _private.objCommonScripts["combatant_class"] = tCommoncript.$Combatant;
            _private.objCommonScripts["combatant_info"] = tCommoncript.$combatantInfo;
            _private.objCommonScripts["show_goods_name"] = tCommoncript.$showGoodsName;
            _private.objCommonScripts["show_combatant_name"] = tCommoncript.$showCombatantName;
            _private.objCommonScripts["common_check_skill"] = tCommoncript.$commonCheckSkill;
            _private.objCommonScripts["refresh_combatant"] = tCommoncript.$refreshCombatant;
            _private.objCommonScripts["check_all_combatants"] = tCommoncript.$checkAllCombatants;
            _private.objCommonScripts["game_over_script"] = tCommoncript.$gameOverScript;
            _private.objCommonScripts["common_run_away_algorithm"] = tCommoncript.$commonRunAwayAlgorithm;
            _private.objCommonScripts["fight_skill_algorithm"] = tCommoncript.$skillEffectAlgorithm;
            _private.objCommonScripts["enemy_choice_skill_algorithm"] = tCommoncript.$enemyChoiceSkillAlgorithm;
            _private.objCommonScripts["fight_init_script"] = tCommoncript.$commonFightInitScript;
            _private.objCommonScripts["fight_start_script"] = tCommoncript.$commonFightStartScript;
            _private.objCommonScripts["fight_round_script"] = tCommoncript.$commonFightRoundScript;
            _private.objCommonScripts["fight_end_script"] = tCommoncript.$commonFightEndScript;
            //_private.objCommonScripts["resume_event_script"] = tCommoncript.$resumeEventScript;
            //_private.objCommonScripts["get_goods_script"] = tCommoncript.commonGetGoodsScript;
            //_private.objCommonScripts["use_goods_script"] = tCommoncript.commonUseGoodsScript;
            _private.objCommonScripts["equip_reserved_slots"] = tCommoncript.$equipReservedSlots;
            _private.objCommonScripts["sort_fight_algorithm"] = tCommoncript.$sortFightAlgorithm;
            _private.objCommonScripts["combatant_round_script"] = tCommoncript.$combatantRoundScript;

            //_private.objCommonScripts["events"] = tCommoncript.$events;
            //_private.objCommonScripts["get_buff"] = tCommoncript.$getBuff;

            game.$userscripts = tCommoncript;
        }
        else
            game.$userscripts = GameMakerGlobalJS;

        /*data = game.loadjson("common_algorithm.json");
        if(data) {
            let ret = GlobalJS.Eval(data["FightAlgorithm"]);
            _private.objCommonScripts["game_over_script"] = ret.$gameOverScript;
            _private.objCommonScripts["common_run_away_algorithm"] = ret.$commonRunAwayAlgorithm;
            _private.objCommonScripts["fight_skill_algorithm"] = ret.$skillEffectAlgorithm;
            _private.objCommonScripts["enemy_choice_skill_algorithm"] = ret.$enemyChoiceSkillAlgorithm;
            _private.objCommonScripts["fight_start_script"] = ret.$commonFightStartScript;
            _private.objCommonScripts["fight_round_script"] = ret.$commonFightRoundScript;
            _private.objCommonScripts["fight_end_script"] = ret.$commonFightEndScript;
            //_private.objCommonScripts["resume_event_script"] = ret.$resumeEventScript;
            _private.objCommonScripts["get_goods_script"] = ret.commonGetGoodsScript;
            _private.objCommonScripts["use_goods_script"] = ret.commonUseGoodsScript;
            _private.objCommonScripts["equip_reserved_slots"] = ret.$equipReservedSlots;
        }*/
        if(!_private.objCommonScripts["combatant_class"]) {
            _private.objCommonScripts["combatant_class"] = GameMakerGlobalJS.$Combatant;
            console.debug("[!GameScene]载入系统创建战斗角色脚本");
        }
        else
            console.debug("[GameScene]载入创建战斗角色脚本OK");

        if(!_private.objCommonScripts["refresh_combatant"]) {
            _private.objCommonScripts["refresh_combatant"] = GameMakerGlobalJS.$refreshCombatant;
            console.debug("[!GameScene]载入系统计算属性脚本");
        }
        else
            console.debug("[GameScene]载入计算属性脚本OK");

        if(!_private.objCommonScripts["check_all_combatants"]) {
            _private.objCommonScripts["check_all_combatants"] = GameMakerGlobalJS.$checkAllCombatants;
            console.debug("[!GameScene]载入系统计算属性脚本");
        }
        else
            console.debug("[GameScene]载入计算属性脚本OK");

        if(!_private.objCommonScripts["game_over_script"]) {
            _private.objCommonScripts["game_over_script"] = GameMakerGlobalJS.$gameOverScript;
            console.debug("[!GameScene]载入系统游戏结束脚本");
        }
        else
            console.debug("[GameScene]载入游戏结束脚本OK");

        if(!_private.objCommonScripts["fight_skill_algorithm"]) {
            _private.objCommonScripts["fight_skill_algorithm"] = GameMakerGlobalJS.$skillEffectAlgorithm;
            console.debug("[!GameScene]载入系统战斗算法");
        }
        else
            console.debug("[GameScene]载入战斗算法OK");  //, _private.objCommonScripts["fight_skill_algorithm"], data, eval("()=>{}"));

        if(!_private.objCommonScripts["enemy_choice_skill_algorithm"]) {
            _private.objCommonScripts["enemy_choice_skill_algorithm"] = GameMakerGlobalJS.$enemyChoiceSkillAlgorithm;
            console.debug("[!GameScene]载入敌人选择技能算法");
        }
        else
            console.debug("[GameScene]载入敌人选择技能OK");


        if(!_private.objCommonScripts["fight_init_script"]) {
            _private.objCommonScripts["fight_init_script"] = GameMakerGlobalJS.$commonFightInitScript;
            console.debug("[!GameScene]载入系统战斗初始化脚本");
        }
        else
            console.debug("[GameScene]载入战斗初始化脚本OK");
        if(!_private.objCommonScripts["fight_start_script"]) {
            _private.objCommonScripts["fight_start_script"] = GameMakerGlobalJS.$commonFightStartScript;
            console.debug("[!GameScene]载入系统战斗开始脚本");
        }
        else
            console.debug("[GameScene]载入战斗开始脚本OK");
        if(!_private.objCommonScripts["fight_round_script"]) {
            _private.objCommonScripts["fight_round_script"] = GameMakerGlobalJS.$commonFightRoundScript;
            console.debug("[!GameScene]载入系统战斗回合脚本");
        }
        else
            console.debug("[GameScene]载入战斗回合脚本OK");
        if(!_private.objCommonScripts["fight_end_script"]) {
            _private.objCommonScripts["fight_end_script"] = GameMakerGlobalJS.$commonFightEndScript;
            console.debug("[!GameScene]载入系统战斗结束脚本");
        }
        else
            console.debug("[GameScene]载入战斗结束脚本OK");

        /*if(!_private.objCommonScripts["resume_event_script"]) {
            _private.objCommonScripts["resume_event_script"] = GameMakerGlobalJS.$resumeEventScript;
            console.debug("[!GameScene]载入系统恢复脚本");
        }
        else
            console.debug("[GameScene]载入恢复算法脚本OK");  //, _private.objCommonScripts["resume_timer"], data, eval("()=>{}"));
        */

        /*if(!_private.objCommonScripts["get_goods_script"]) {
            _private.objCommonScripts["get_goods_script"] = GameMakerGlobalJS.commonGetGoodsScript;
            console.debug("[!GameScene]载入系统通用获得道具脚本");
        }
        else
            console.debug("[GameScene]载入通用获得道具脚本OK");
        if(!_private.objCommonScripts["use_goods_script"]) {
            _private.objCommonScripts["use_goods_script"] = GameMakerGlobalJS.commonUseGoodsScript;
            console.debug("[!GameScene]载入系统通用使用道具脚本");
        }
        else
            console.debug("[GameScene]载入通用使用道具脚本OK");
        */

        if(!_private.objCommonScripts["common_run_away_algorithm"]) {
            _private.objCommonScripts["common_run_away_algorithm"] = GameMakerGlobalJS.$commonRunAwayAlgorithm;
            console.debug("[!GameScene]载入系统逃跑算法");
        }
        else
            console.debug("[GameScene]载入逃跑算法OK");

        if(!_private.objCommonScripts["sort_fight_algorithm"]) {
            _private.objCommonScripts["sort_fight_algorithm"] = GameMakerGlobalJS.$sortFightAlgorithm;
            console.debug("[!GameScene]载入系统排序算法");
        }
        else
            console.debug("[GameScene]载入逃跑排序OK");

        if(!_private.objCommonScripts["combatant_info"]) {
            _private.objCommonScripts["combatant_info"] = GameMakerGlobalJS.$combatantInfo;
            console.debug("[!GameScene]载入系统战斗人物信息");
        }
        else
            console.debug("[GameScene]载入战斗人物信息OK");

        if(!_private.objCommonScripts["show_goods_name"]) {
            _private.objCommonScripts["show_goods_name"] = GameMakerGlobalJS.$showGoodsName;
            console.debug("[!GameScene]载入系统显示道具名称信息");
        }
        else
            console.debug("[GameScene]载入显示道具名称信息OK");

        if(!_private.objCommonScripts["show_combatant_name"]) {
            _private.objCommonScripts["show_combatant_name"] = GameMakerGlobalJS.$showCombatantName;
            console.debug("[!GameScene]载入系统显示战斗人物名称信息");
        }
        else
            console.debug("[GameScene]载入显示战斗人物名称信息OK");

        if(!_private.objCommonScripts["equip_reserved_slots"]) {
            _private.objCommonScripts["equip_reserved_slots"] = GameMakerGlobalJS.$equipReservedSlots;;
            console.debug("[!GameScene]载入系统预置装备槽");
        }
        else
            console.debug("[GameScene]载入预置装备槽OK");

        if(!_private.objCommonScripts["common_check_skill"]) {
            _private.objCommonScripts["common_check_skill"] = GameMakerGlobalJS.$commonCheckSkill;
            console.debug("[!GameScene]载入系统通用检查技能脚本");
        }
        else
            console.debug("[GameScene]载入通用检查技能脚本OK");

        if(!_private.objCommonScripts["combatant_round_script"]) {
            _private.objCommonScripts["combatant_round_script"] = GameMakerGlobalJS.$combatantRoundScript;
            console.debug("[!GameScene]载入系统通用Buff脚本");
        }
        else
            console.debug("[GameScene]载入通用Buff脚本OK");

        /*
        if(!_private.objCommonScripts["events"]) {
            _private.objCommonScripts["events"] = GameMakerGlobalJS.$events;
            console.debug("[!GameScene]载入系统通用events");
        }
        else
            console.debug("[GameScene]载入通用eventsOK");
            */



        if(FrameManager.sl_qml_FileExists(Global.toPath(projectpath + 'start.js'))) {
            //载入初始脚本
            let ts = _private.jsEngine.load('start.js', Global.toURL(projectpath));
            if(ts) {
                _private.objCommonScripts["game_start_script"] = ts.$start || ts.start;
                _private.objCommonScripts["game_init_script"] = ts.$init || ts.init;
                _private.objCommonScripts["game_save_script"] = ts.$save || ts.save;
                _private.objCommonScripts["game_load_script"] = ts.$load || ts.load;
            }
        }



        //读道具信息
        let path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName;
        let items = FrameManager.sl_qml_listDir(Global.toPath(path), "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let ts = _private.jsEngine.load('goods.js', Global.toURL(path + GameMakerGlobal.separator + item + GameMakerGlobal.separator));
            if(ts.data) {
                _private.objGoods[item] = ts.data;
                _private.objGoods[item].$rid = item;
                _private.objGoods[item].__proto__ = _private.objGoods[item].$commons;

                console.debug("[GameScene]载入Goods", item);
            }
            else
                console.warn("[!GameScene]载入Goods ERROR", item);


            /*let filePath = path + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "goods.json";
            //console.debug(path, items, item, filePath)
            let data = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));

            if(data !== "") {
                data = JSON.parse(data);
                let t = GlobalJS.Eval(data["Goods"]);
                if(t) {
                    _private.objGoods[item] = t;
                    _private.objGoods[item].$rid = item;
                    console.debug("[GameScene]载入Goods", item);
                }
            }
            if(!data)
                console.warn("[!GameScene]载入Goods ERROR", item);
            */
        }


        //读技能信息
        path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName;
        items = FrameManager.sl_qml_listDir(Global.toPath(path), "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let ts = _private.jsEngine.load('fight_skill.js', Global.toURL(path + GameMakerGlobal.separator + item + GameMakerGlobal.separator));
            if(ts.data) {
                _private.objSkills[item] = ts.data;
                _private.objSkills[item].$rid = item;
                _private.objSkills[item].__proto__ = _private.objSkills[item].$commons;

                console.debug("[GameScene]载入FightSkill", item);
            }
            else
                console.warn("[!GameScene]载入FightSkill ERROR", item);


            /*let filePath = path + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "fight_skill.json";
            //console.debug(path, items, item, filePath)
            let data = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));

            if(data !== "") {
                data = JSON.parse(data);
                let t = GlobalJS.Eval(data["FightSkill"]);
                if(t) {
                    _private.objSkills[item] = t;
                    _private.objSkills[item].$rid = item;
                    console.debug("[GameScene]载入FightSkill", item);
                }
            }
            if(!data)
                console.warn("[!GameScene]载入FightSkill ERROR", item);
            */
        }


        //读战斗脚本信息
        path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName;
        items = FrameManager.sl_qml_listDir(Global.toPath(path), "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let ts = _private.jsEngine.load('fight_script.js', Global.toURL(path + GameMakerGlobal.separator + item + GameMakerGlobal.separator));
            if(ts.data) {
                _private.objFightScripts[item] = ts.data;
                _private.objFightScripts[item].$rid = item;
                _private.objFightScripts[item].__proto__ = _private.objFightScripts[item].$commons;

                console.debug("[GameScene]载入FightScript", item);
            }
            else
                console.warn("[!GameScene]载入FightScript ERROR", item);


        }



        //读战斗角色信息
        path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName;
        items = FrameManager.sl_qml_listDir(Global.toPath(path), "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {

            let ts = _private.jsEngine.load('fight_role.js', Global.toURL(path + GameMakerGlobal.separator + item + GameMakerGlobal.separator));
            if(ts) {
                _private.objFightRoles[item] = ts.data;
                _private.objFightRoles[item].$rid = item;
                //_private.objFightRoles[item].__proto__ = game.objCommonScripts["combatant_class"].prototype;
                _private.objFightRoles[item].__proto__ = _private.objFightRoles[item].$commons;
                _private.objFightRoles[item].$commons.__proto__ = game.objCommonScripts["combatant_class"].prototype;

                //_private.objFightRoles[item].$createData = ts.$createData;
                //_private.objFightRoles[item].$commons = ts.$commons;

                console.debug("[GameScene]载入FightRole Script", item);
            }
            else
                console.warn("[!GameScene]载入FightSkill Script ERROR", item);



            //let data = File.read(filePath);
            /*let data = FrameManager.sl_qml_ReadFile(Global.toPath(path + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "fight_role.json"));

            if(data) {
                data = JSON.parse(data);

                //_private.objFightRoles[item] = data;
                _private.objFightRoles[item].ActionData = data.ActionData;
                console.debug("[GameScene]载入FightRole", item);
            }
            else {
                console.warn("[!GameScene]载入FightRole ERROR：" + item);
                continue;
            }
            */

        }




        //读特效信息
        path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName;
        items = FrameManager.sl_qml_listDir(Global.toPath(path), "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            //console.debug(path, items, item)
            let data = FrameManager.sl_qml_ReadFile(Global.toPath(path + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "sprite.json"));

            if(data) {
                data = JSON.parse(data);
                if(data) {
                    _private.objSprites[item] = data;
                    _private.objSprites[item].$rid = item;
                    //_private.objSprites[item].__proto__ = _private.objSprites[item].$commons;

                    //let cacheImage = Qt.createQmlObject("import QtQuick 2.14;import QtMultimedia 5.14; Audio {}", parent);
                    let cacheSoundEffect;
                    if(data.Sound) {
                        if(_private.objCacheSoundEffects[data.Sound])
                            cacheSoundEffect = _private.objCacheSoundEffects[data.Sound];
                        else {
                            cacheSoundEffect = compCacheSoundEffect.createObject(rootGameScene, {source: Global.toURL(GameMakerGlobal.soundResourceURL(data.Sound))});
                            _private.objCacheSoundEffects[data.Sound] = cacheSoundEffect;
                        }
                    }
                    let cacheImage = compCacheImage.createObject(rootGameScene, {source: Global.toURL(GameMakerGlobal.spriteResourceURL(data.Image))});
                    _private.objSprites[item].$$cache = {image: cacheImage, audio: cacheSoundEffect};

                    console.debug("[GameScene]载入Sprite", item);
                }
            }
            else
                console.warn("[!GameScene]载入Sprite ERROR", item);
        }


        //let data;

        /*/读图片信息
        filePath = game.$projectpath + GameMakerGlobal.separator +  "images.json";
        //let cfg = File.read(filePath);
        data = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));
        //console.debug("data", filePath, data)
        //console.debug("cfg", cfg, filePath);

        if(data !== "") {
            data = JSON.parse(data)["List"];
            for(let m in data) {
                _private.objImages[data[m]["Name"]] = data[m]["URL"];
            }
            console.debug("[GameScene]载入图片OK");
        }

        //读音乐信息
        filePath = game.$projectpath + GameMakerGlobal.separator +  "music.json";
        //let cfg = File.read(filePath);
        data = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));
        //console.debug("data", filePath, data)
        //console.debug("cfg", cfg, filePath);

        if(data !== "") {
            data = JSON.parse(data)["List"];
            for(let m in data) {
                _private.objMusic[data[m]["Name"]] = data[m]["URL"];
            }
            console.debug("[GameScene]载入音乐OK");
        }

        //读视频信息
        filePath = game.$projectpath + GameMakerGlobal.separator +  "videos.json";
        //let cfg = File.read(filePath);
        data = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));
        //console.debug("data", filePath, data)
        //console.debug("cfg", cfg, filePath);

        if(data !== "") {
            data = JSON.parse(data)["List"];
            for(let m in data) {
                _private.objVideos[data[m]["Name"]] = data[m]["URL"];
            }
            console.debug("[GameScene]载入视频OK");
        }
        */




        /*if(!_private.objCommonScripts["get_buff"]) {
            _private.objCommonScripts["get_buff"] = GameMakerGlobalJS.$getBuff;
            console.debug("[!GameScene]载入系统通用获得Buff脚本");
        }
        else
            console.debug("[GameScene]载入通用获得Buff脚本OK");
        */

        //if(!_private.objCommonScripts["equip_reserved_slots"])
        //    _private.objCommonScripts["equip_reserved_slots"] = [];



        /*/读升级链
        filePath = game.$projectpath + GameMakerGlobal.separator;
        let tlevelChainScript;
        if(FrameManager.sl_qml_FileExists(Global.toPath(filePath + 'level_chain.js')))
            tlevelChainScript = _private.jsEngine.load('level_chain.js', Global.toURL(filePath));
        if(tlevelChainScript) {
            _private.objCommonScripts["levelup_script"] = tlevelChainScript.$commonLevelUpScript;
            _private.objCommonScripts["level_Algorithm"] = tlevelChainScript.$commonLevelAlgorithm;
        }*/

        /*data = game.loadjson("level_chain.json");
        if(data) {
            let ret = GlobalJS.Eval(data["LevelChainScript"]);
            _private.objCommonScripts["levelup_script"] = ret.$commonLevelUpScript;
            _private.objCommonScripts["level_Algorithm"] = ret.$commonLevelAlgorithm;
        }

        if(!_private.objCommonScripts["levelup_script"]) {
            _private.objCommonScripts["levelup_script"] = GameMakerGlobalJS.$commonLevelUpScript;
            console.debug("[!GameScene]载入系统升级脚本");
        }
        else
            console.debug("[GameScene]载入升级脚本OK");  //, _private.objCommonScripts["levelup_script"], data, eval("()=>{}"));


        if(!_private.objCommonScripts["level_Algorithm"]) {
            _private.objCommonScripts["level_Algorithm"] = GameMakerGlobalJS.$commonLevelAlgorithm;
            console.debug("[!GameScene]载入系统升级算法");
        }
        else
            console.debug("[GameScene]载入升级算法OK");  //, _private.objCommonScripts["level_Algorithm"], data, eval("()=>{}"));
        */



        //console.debug("_private.objMusic", JSON.stringify(_private.objMusic))




        //安卓配置
        do {
            if(Qt.platform.os !== "android")
                break;

            _private.lastOrient = Platform.getScreenOrientation();

            if(game.$userscripts.$config === undefined)
                break;
            if(game.$userscripts.$config.$android === undefined)
                break;
            //旋转配置
            if(game.$userscripts.$config.$android.$orient) {
                Platform.setScreenOrientation(game.$userscripts.$config.$android.$orient);
            }

        }while(0);



        //控制器 默认值

        let joystickConfig = {
            $left: 6,
            $bottom: 7,
            $size: 20,
            $opacity: 0.6,
        };
        /*let buttonAConfig = {
            $right: 10,
            $bottom: 16,
            $size: 6,
            $color: 'red',
            $opacity: 0.6,
            $image: '',
            $clicked: function() {
                //if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                //    return;
                if(game.pause(null))
                    return;
                _private.buttonAClicked();
            }
        };
        let buttonMenuConfig = {
            $right: 16,
            $bottom: 8,
            $size: 6,
            $color: 'blue',
            $opacity: 0.6,
            $image: '',
            $clicked: function() {
                //if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                //    return;
                if(game.pause(null))
                    return;
                _private.buttonMenuClicked();
            }
        };*/

        do {
            if(game.$userscripts.$config === undefined)
                break;

            //摇杆 配置
            do {
                if(game.$userscripts.$config.$joystick === undefined)
                    break;
                let tConfig = game.$userscripts.$config.$joystick;
                if(tConfig.$size !== undefined) {
                    joystickConfig.$size = tConfig.$size;
                }
                if(tConfig.$left !== undefined)
                    joystickConfig.$left = tConfig.$left;
                if(tConfig.$bottom !== undefined)
                    joystickConfig.$bottom = tConfig.$bottom;
                if(tConfig.$opacity !== undefined)
                    joystickConfig.$opacity = tConfig.$opacity;
            }while(0);

            //按键配置
            do {
                if(game.$userscripts.$config.$buttons === undefined)
                    break;

                /*/A键
                do {
                    if(game.$userscripts.$config.$buttons[0] === undefined)
                        break;
                    let tConfig = game.$userscripts.$config.$buttons[0];
                    if(tConfig.$size !== undefined) {
                        buttonAConfig.$size = tConfig.$size;
                    }
                    if(tConfig.$color !== undefined)
                        buttonAConfig.$color = tConfig.$color;
                    if(tConfig.$opacity !== undefined)
                        buttonAConfig.$opacity = tConfig.$opacity;
                    if(tConfig.$image !== undefined)
                        buttonAConfig.$image = tConfig.$image;

                    if(tConfig.$right !== undefined)
                        buttonAConfig.$right = tConfig.$right;
                    if(tConfig.$bottom !== undefined)
                        buttonAConfig.$bottom = tConfig.$bottom;
                    if(tConfig.$clicked !== undefined)
                        buttonAConfig.$clicked = tConfig.$clicked;
                }while(0);

                //B键
                do {
                    if(game.$userscripts.$config.$buttons[1] === undefined)
                        break;
                    let tConfig = game.$userscripts.$config.$buttons[1];
                    if(tConfig.$size !== undefined) {
                        buttonMenuConfig.$size = tConfig.$size;
                    }
                    if(tConfig.$color !== undefined)
                        buttonMenuConfig.$color = tConfig.$color;
                    if(tConfig.$opacity !== undefined)
                        buttonMenuConfig.$opacity = tConfig.$opacity;
                    if(tConfig.$image !== undefined)
                        buttonMenuConfig.$image = tConfig.$image;
                    if(tConfig.$right !== undefined)
                        buttonMenuConfig.$right = tConfig.$right;
                    if(tConfig.$bottom !== undefined)
                        buttonMenuConfig.$bottom = tConfig.$bottom;
                    if(tConfig.$clicked !== undefined)
                        buttonMenuConfig.$clicked = tConfig.$clicked;
                }while(0);
                */

                //自定义
                for(let tb = 0; tb < game.$userscripts.$config.$buttons.length; ++tb) {
                    let tConfig = game.$userscripts.$config.$buttons[tb];
                    let button = compButtons.createObject(itemButtons);
                    button.width = tConfig.$size * Screen.pixelDensity;
                    button.height = tConfig.$size * Screen.pixelDensity;
                    if(tConfig.$color !== undefined)
                        button.color = tConfig.$color;
                    if(tConfig.$opacity !== undefined)
                        button.opacity = tConfig.$opacity;
                    if(tConfig.$image)
                        button.image.source = Global.toURL(GameMakerGlobal.imageResourceURL(tConfig.$image));
                    button.anchors.rightMargin = tConfig.$right * Screen.pixelDensity;
                    button.anchors.bottomMargin = tConfig.$bottom * Screen.pixelDensity;
                    button.s_pressed.connect(function(){
                        //if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                        //    return;
                        game.run(tConfig.$clicked);
                    });
                }

            }while(0);
        }while(0);

        joystick.width = joystickConfig.$size * Screen.pixelDensity;
        joystick.height = joystickConfig.$size * Screen.pixelDensity;
        joystick.anchors.leftMargin = joystickConfig.$left * Screen.pixelDensity;
        joystick.anchors.bottomMargin = joystickConfig.$bottom * Screen.pixelDensity;
        joystick.opacity = joystickConfig.$opacity;

        /*buttonA.width = buttonAConfig.$size * Screen.pixelDensity;
        buttonA.height = buttonAConfig.$size * Screen.pixelDensity;
        buttonA.color = buttonAConfig.$color;
        buttonA.opacity = buttonAConfig.$opacity;
        if(buttonAConfig.$image)
            buttonA.image.source = Global.toURL(GameMakerGlobal.imageResourceURL(buttonAConfig.$image));
        buttonA.anchors.rightMargin = buttonAConfig.$right * Screen.pixelDensity;
        buttonA.anchors.bottomMargin = buttonAConfig.$bottom * Screen.pixelDensity;
        buttonA.buttonClicked = buttonAConfig.$clicked;

        buttonMenu.width = buttonMenuConfig.$size * Screen.pixelDensity;
        buttonMenu.height = buttonMenuConfig.$size * Screen.pixelDensity;
        buttonMenu.color = buttonMenuConfig.$color;
        buttonMenu.opacity = buttonMenuConfig.$opacity;
        if(buttonMenuConfig.$image)
            buttonMenu.image.source = Global.toURL(GameMakerGlobal.imageResourceURL(buttonMenuConfig.$image));
        buttonMenu.anchors.rightMargin = buttonMenuConfig.$right * Screen.pixelDensity;
        buttonMenu.anchors.bottomMargin = buttonMenuConfig.$bottom * Screen.pixelDensity;
        buttonMenu.buttonClicked = buttonMenuConfig.$clicked;
        */



        //载入扩展 插件/组件
        let componentPath = game.$projectpath + GameMakerGlobal.separator + "Plugins" + GameMakerGlobal.separator;

        //循环三方根目录
        for(let tc0 of FrameManager.sl_qml_listDir(Global.toPath(componentPath), '*', 0x001 | 0x2000 | 0x4000, 0)) {
            //if(tc0 === '$Leamus')
            //    continue;

            //循环三方插件目录
            for(let tc1 of FrameManager.sl_qml_listDir(Global.toPath(componentPath + tc0 + GameMakerGlobal.separator), '*', 0x001 | 0x2000 | 0x4000, 0)) {

                let jsPath = componentPath + tc0 + GameMakerGlobal.separator + tc1 + GameMakerGlobal.separator + 'Components' + GameMakerGlobal.separator;
                if(!FrameManager.sl_qml_FileExists(Global.toPath(jsPath + 'main.js')))
                    continue;

                try {
                    let ts = _private.jsEngine.load('main.js', Global.toURL(jsPath));


                    //放入 _private.objPlugins 中
                    if(ts.$pluginId !== undefined) {
                        _private.objPlugins[ts.$pluginId] = ts;
                    }
                    if(!GlobalLibraryJS.isObject(_private.objPlugins[tc0]))
                        _private.objPlugins[tc0] = {};
                    _private.objPlugins[tc0][tc1] = ts;


                    if(ts.$load)
                        ts.$load();
                }
                catch(e) {
                    console.error(e);
                    continue;
                }
            }
        }



        game.setinterval(16);
        game.scale(1);

    }


    //释放所有资源
    function release(bUnloadResources=true) {

        //释放插件
        for(let tp in _private.objPlugins) {
            if(_private.objPlugins[tp].$release)
                _private.objPlugins[tp].$release();
        }


        //timer.stop();
        _private.config.objPauseNames = {};
        game.pause();

        game.scale(1);

        _private.asyncScript.clear(1);
        //_private.asyncScript.run();

        messageGame.stop();
        messageRole.stop();

        game.delrole(-1);
        game.delimage();
        game.delsprite();
        game.delhero(-1);
        game.stopvideo();
        itemBackgroundMusic.stop();
        itemBackgroundMusic.arrMusicStack = [];
        itemBackgroundMusic.objMusicPause = {};


        //FrameManager.goon();


        gameMenuWindow.closeWindow(-1);
        //gameMenuWindow.visible = false;
        dialogGameMsg.visible = false;
        dialogRoleMsg.visible = false;
        dialogTrade.visible = false;

        rectMenu.visible = false;
        //menuGame.hide();

        /*/
        for(let i in _private.objTmpSprites) {
            _private.objTmpSprites[i].destroy();
        }
        _private.objTmpSprites = {};
        */


        game.d = {};
        game.f = {};
        game.gd = {};
        game.gf = {};




        _private.objRoles = {};
        _private.arrMainRoles = [];
        _private.objTmpImages = {};
        _private.objTmpSprites = {};


        _private.objTimers = {};
        _private.objGlobalTimers = {};

        _private.nStage = 0;


        loaderFightScene.visible = false;


        for(let tc in itemBackMapContainer.arrCanvas) {
            itemBackMapContainer.arrCanvas[tc].unloadImage(imageMapBlock.source);
            _private.clearCanvas(itemBackMapContainer.arrCanvas[tc]);
            itemBackMapContainer.arrCanvas[tc].requestPaint();
        }
        for(let tc in itemFrontMapContainer.arrCanvas) {
            itemFrontMapContainer.arrCanvas[tc].unloadImage(imageMapBlock.source);
            _private.clearCanvas(itemFrontMapContainer.arrCanvas[tc]);
            itemFrontMapContainer.arrCanvas[tc].requestPaint();
        }

        //canvasBackMap.unloadImage(imageMapBlock.source);
        //canvasFrontMap.unloadImage(imageMapBlock.source);
        imageMapBlock.source = "";


        if(bUnloadResources)
            unloadResources();
    }

    function unloadResources() {

        //卸载扩展 插件、组件
        for(let tp in _private.objPlugins) {
            if(_private.objPlugins[tp].$unload)
                _private.objPlugins[tp].$unload();
        }



        if(Qt.platform.os === "android") {
            Platform.setScreenOrientation(_private.lastOrient);
            //if(game.$userscripts.$config && game.$userscripts.$config.$android)
        }


        for(let i in _private.objSprites) {
            _private.objSprites[i].$$cache.image.destroy();
            if(_private.objSprites[i].$$cache.audio)
                _private.objSprites[i].$$cache.audio.destroy();
        }
        _private.objSprites = {};

        _private.objSkills = {};
        _private.objFightScripts = {};
        _private.objFightRoles = {};
        _private.objGoods = {};
        _private.objCacheSoundEffects = {};

        //_private.objImages = {};
        //_private.objMusic = {};
        //_private.objVideos = {};

        _private.objCommonScripts = {};

        game.$userscripts = null;

        _private.objPlugins = {};
        _private.jsEngine.clear();



        for(let tb in itemButtons.children) {
            itemButtons.children[tb].destroy();
        }

    }


    //打开地图
    function openMap(mapPath) {
        itemBackMapContainer.visible = false;
        itemFrontMapContainer.visible = false;

        //let cfg = File.read(mapPath);
        let mapInfo = FrameManager.sl_qml_ReadFile(Global.toPath(mapPath + GameMakerGlobal.separator + "map.json"));
        //console.debug("cfg", cfg, mapPath);

        if(mapInfo === "")
            return false;
        mapInfo = JSON.parse(mapInfo);
        //console.debug("cfg", cfg);
        //loader.setSource("./MapEditor_1.qml", {});


        //地图数据
        //itemContainer.mapInfo = JSON.parse(File.read(mapFilePath));
        itemContainer.mapInfo = mapInfo;

        let nMapBlockScale = parseFloat(itemContainer.mapInfo.MapScale) || 1;
        sizeMapBlockSize.width = parseInt(itemContainer.mapInfo.MapBlockSize[0] * nMapBlockScale);
        sizeMapBlockSize.height = parseInt(itemContainer.mapInfo.MapBlockSize[1] * nMapBlockScale);

        itemContainer.width = itemContainer.mapInfo.MapSize[0] * sizeMapBlockSize.width;
        itemContainer.height = itemContainer.mapInfo.MapSize[1] * sizeMapBlockSize.height;

        //如果地图小于等于场景，则将地图居中
        if(itemContainer.width < gameScene.width)
            itemContainer.x = (rootGameScene.width - itemContainer.width * gameScene.scale) / 2 / gameScene.scale;
        if(itemContainer.height < gameScene.height)
            itemContainer.y = (rootGameScene.height - itemContainer.height * gameScene.scale) / 2 / gameScene.scale;

        //console.debug("!!!", itemContainer.width, gameScene.scale, rootGameScene.width, itemContainer.x);
        //console.debug("!!!", itemContainer.height, gameScene.scale, rootGameScene.height, itemContainer.y);


        //卸载原地图块图片
        for(let tc in itemBackMapContainer.arrCanvas) {
            itemBackMapContainer.arrCanvas[tc].unloadImage(imageMapBlock.source);
        }
        for(let tc in itemFrontMapContainer.arrCanvas) {
            itemFrontMapContainer.arrCanvas[tc].unloadImage(imageMapBlock.source);
        }

        imageMapBlock.source = Global.toURL(GameMakerGlobal.mapResourceURL(mapInfo.MapBlockImage[0]));

        //载入新地图块图片
        for(let tc in itemBackMapContainer.arrCanvas) {
            itemBackMapContainer.arrCanvas[tc].loadImage(imageMapBlock.source);
            if(itemBackMapContainer.arrCanvas[tc].isImageLoaded(imageMapBlock.source)) {
                //console.debug("[GameScene]Canvas.loadImage载入OK，requestPaint");
                itemBackMapContainer.arrCanvas[tc].requestPaint();
            }
            //else
                //console.debug("[GameScene]Canvas.loadImage载入NO，等待回调。。。");
        }
        for(let tc in itemFrontMapContainer.arrCanvas) {
            itemFrontMapContainer.arrCanvas[tc].loadImage(imageMapBlock.source);
            if(itemFrontMapContainer.arrCanvas[tc].isImageLoaded(imageMapBlock.source)) {
                //console.debug("[GameScene]canvasBackMap.loadImage载入OK，requestPaint");
                itemFrontMapContainer.arrCanvas[tc].requestPaint();
            }
            //else
                //console.debug("[GameScene]Canvas.loadImage载入NO，等待回调。。。");
        }


        itemContainer.mapEventBlocks = {};
        //转换事件的地图块的坐标为地图块的ID
        for(let i in mapInfo.MapEventData) {
            let p = i.split(',');
            itemContainer.mapEventBlocks[parseInt(p[0]) + parseInt(p[1]) * itemContainer.mapInfo.MapSize[0]] = mapInfo.MapEventData[i];
        }

        //console.debug("itemContainer.mapEventBlocks", JSON.stringify(itemContainer.mapEventBlocks))

        //game.map.$name = mapInfo.MapName;



        //执行载入地图脚本

        //之前的
        //if(itemContainer.mapInfo.SystemEventData !== undefined && itemContainer.mapInfo.SystemEventData["$1"] !== undefined) {
        //    if(GlobalJS.createScript(_private.asyncScript, 0, 0, itemContainer.mapInfo.SystemEventData["$1"]) === 0)
        //        return _private.asyncScript.run();
        //}

        //使用Component（太麻烦）
        //let scriptComp = Qt.createComponent(Global.toURL(filePath + GameMakerGlobal.separator + "map.qml"));
        //console.debug('!!!999', Global.toURL(filePath + GameMakerGlobal.separator + "map.qml"), scriptComp)
        //let script = scriptComp.createObject({}, rootGameScene);

        //let script = Qt.createQmlObject('import QtQuick 2.14;import "map.js" as Script;Item {property var script: Script}', rootGameScene, Global.toURL(filePath + GameMakerGlobal.separator));
        //script.destroy();
        let ts = _private.jsEngine.load('map.js', Global.toURL(mapPath + GameMakerGlobal.separator));
        itemContainer.mapInfo.$$Script = ts;
        if(ts.$start)
            game.run([ts.$start(), 'map $start']);
        else if(ts.start)
            game.run([ts.start(), 'map start']);



        console.debug("[GameScene]openMap", itemContainer.width, itemContainer.height)

        //test();

        return mapInfo;
    }

    function updateAllRolesPos() {

    }


    //块坐标对应的真实坐标
    //bx、by为块坐标；dx、dy为偏移坐标（为小数则偏移多少个块，为整数则偏移多少坐标）
    function getMapBlockPos(bx, by, dx=0.5, dy=0.5) {

        //边界检测

        if(bx < 0)
            bx = 0;
        else if(bx >= itemContainer.mapInfo.MapSize[0])
            bx = itemContainer.mapInfo.MapSize[0] - 1;

        if(by < 0)
            by = 0;
        else if(by >= itemContainer.mapInfo.MapSize[1])
            by = itemContainer.mapInfo.MapSize[1] - 1;


        //在目标图块最中央的 地图的坐标
        let targetX;
        let targetY;
        if(dx.toString().indexOf('.') < 0)
            targetX = parseInt((bx) * sizeMapBlockSize.width);
        else {
            targetX = parseInt((bx + dx) * sizeMapBlockSize.width);
            dx = 0;
        }
        if(dy.toString().indexOf('.') < 0)
            targetY = parseInt((by) * sizeMapBlockSize.height);
        else {
            targetY = parseInt((by + dy) * sizeMapBlockSize.height);
            dy = 0;
        }
        //let targetX = parseInt(role.x + role.x1 + role.width1 / 2);
        //let targetY = parseInt(role.y + role.y1 + role.height1 / 2);

        return [targetX + dx, targetY + dy];
    }

    //设置角色坐标（块坐标）
    function setRolePos(role, bx, by) {

        let targetX;
        let targetY;
        [targetX, targetY] = getMapBlockPos(bx, by);

        //设置角色坐标

        //如果在最右边的图块，且人物宽度超过图块，则会超出地图边界
        if(bx === itemContainer.mapInfo.MapSize[0] - 1 && role.width1 > sizeMapBlockSize.width)
            role.x = itemContainer.width - role.x2 - 1;
        else
            role.x = targetX - role.x1 - role.width1 / 2;
        //role.x = bx * sizeMapBlockSize.width - role.x1;

        //如果在最下边的图块，且人物高度超过图块，则会超出地图边界
        if(by === itemContainer.mapInfo.MapSize[1] - 1 && role.height1 > sizeMapBlockSize.height)
            role.y = itemContainer.height - role.y2 - 1;
        else
            role.y = targetY - role.y1 - role.height1 / 2;
        //role.y = by * sizeMapBlockSize.height - role.y1;
    }

    //设置主角坐标（块坐标）
    function setMainRolePos(bx, by, index=0) {
        let mainRole = _private.arrMainRoles[index];

        setRolePos(mainRole, bx, by);
        setMapToRole(mainRole);

        game.gd["$sys_main_roles"][index].$x = mainRole.x;
        game.gd["$sys_main_roles"][index].$y = mainRole.y;
    }

    function setMapToRole(role) {

        //计算角色移动时，地图移动的 左上角和右下角 的坐标

        //场景在地图左上角时的中央坐标
        let mapLeftTopCenterX = parseInt(gameScene.nMaxMoveWidth / 2);
        let mapLeftTopCenterY = parseInt(gameScene.nMaxMoveHeight / 2);

        //场景在地图右下角时的中央坐标
        let mapRightBottomCenterX = itemContainer.width - mapLeftTopCenterX;
        let mapRightBottomCenterY = itemContainer.height - mapLeftTopCenterY;

        //角色最中央坐标
        let roleCenterX = role.x + role.x1 + role.width1 / 2;
        let roleCenterY = role.y + role.y1 + role.height1 / 2;

        //开始移动地图

        //如果场景小于地图
        if(gameScene.width < itemContainer.width) {
            //如果人物中心 X 小于 地图左上坐标的 X
            if(roleCenterX <= mapLeftTopCenterX) {
                itemContainer.x = 0;
            }
            //如果人物中心 X 大于 地图右下坐标的 X
            else if(roleCenterX >= mapRightBottomCenterX) {
                itemContainer.x = gameScene.width - itemContainer.width;
            }
            //如果在区间，则随着主角移动
            else {
                itemContainer.x = mapLeftTopCenterX - roleCenterX;
            }
        }
        //如果地图小于等于场景，则将地图居中
        else {
            itemContainer.x = (rootGameScene.width - itemContainer.width * gameScene.scale) / 2 / gameScene.scale;

            //itemContainer.x = 0;
        }


        //如果场景小于地图
        if(gameScene.height < itemContainer.height) {
            //如果人物中心 Y 小于 地图左上坐标的 Y
            if(roleCenterY <= mapLeftTopCenterY) {
                itemContainer.y = 0;
            }
            //如果人物中心 Y 大于 地图右下坐标的 Y
            else if(roleCenterY >= mapRightBottomCenterY) {
                itemContainer.y = gameScene.height - itemContainer.height;
            }
            //如果在区间，则随着主角移动
            else {
                itemContainer.y = mapLeftTopCenterY - roleCenterY;
            }
        }
        //如果地图小于等于场景则不动
        else {
            itemContainer.y = (rootGameScene.height - itemContainer.height * gameScene.scale) / 2 / gameScene.scale;

            //itemContainer.y = 0;
        }

    }



    function test() {

        /*itemContainer.mapInfo = {
            //mapWidth: 800,
            //mapHeight: 600,
            //blockWidth: 50,
            //blockHeight: 50,
            //rowCount: 12,
            //colCount: 16,
            data: [1,2,3,4,5,6,7,8,
                9,1,1,1,1,1,1,1,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                20,1,1,1,1,3,2,4,
                6,5,7,8,9,20,1,20],

            events: [1, 40]
        };*/


        //itemContainer.mapInfo.events = [1, 40];

        //mainRole.x1 = 0;
        //mainRole.y1 = mainRole.height - sizeMapBlockSize.height;
        //mainRole.width1 = 50;
        //mainRole.width1 = mainRole.width;
        //mainRole.height1 = sizeMapBlockSize.height;
        //mainRole.height1 = mainRole.height;
    }



    //width: 400
    //height: 300
    clip: true
    focus: true
    color: "black"



    //Keys.forwardTo: [itemContainer]

    Keys.onEscapePressed: {
        _private.exitGame();
        event.accepted = true;

        console.debug("[GameScene]Escape Key");
    }
    Keys.onBackPressed: {
        _private.exitGame();
        event.accepted = true;

        console.debug("[GameScene]Back Key");
    }
    Keys.onTabPressed: {
        rootGameScene.forceActiveFocus();

        event.accepted = true;
        console.debug("[GameScene]Tab Key");
    }
    Keys.onSpacePressed: {
        event.accepted = true;
    }



    Keys.onPressed: {   //键盘按下
        //console.debug("[GameScene]Keys.onPressed:", event.key, event.isAutoRepeat);

        if(!_private.config.bKeyboard)
            return;

        switch(event.key) {
        case Qt.Key_Up:
        case Qt.Key_Right:
        case Qt.Key_Down:
        case Qt.Key_Left:
            if(event.isAutoRepeat === true) { //如果是按住不放的事件，则返回（只记录第一次按）
                event.accepted = true;
                //mainRole.start();
                return;
            }

            if(GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                _private.doAction(1, event.key);

            event.accepted = true;

            break;

        case Qt.Key_Return:
            if(event.isAutoRepeat === true) { //如果是按住不放的事件，则返回（只记录第一次按）
                event.accepted = true;
                return;
            }


            if(GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                _private.buttonAClicked();


            event.accepted = true;

            break;

        default:
            event.accepted = true;
        }
    }

    Keys.onReleased: {
        //console.debug("[GameScene]Keys.onReleased", event.isAutoRepeat);

        if(!_private.config.bKeyboard)
            return;


        switch(event.key) {
        case Qt.Key_Up:
        case Qt.Key_Right:
        case Qt.Key_Down:
        case Qt.Key_Left:
            if(event.isAutoRepeat === true) { //如果是按住不放的事件，则返回（只记录第一次按）
                event.accepted = true;
                return;
            }

            _private.stopAction(1, event.key);

            event.accepted = true;

            break;

        default:
            event.accepted = true;
        }


        //console.debug("[GameScene]timer", timer.running);
    }


    MouseArea {
        anchors.fill: parent
        onPressed: {
            mouse.accepted = true;
        }
    }



    //游戏场景(可视区域）
    Rectangle {
        id: gameScene


        //场景的 人物的最大X、Y坐标（返回场景 / 地图 的较小值）；这个可以固定
        //如果地图小于场景时，人物不会到达场景边缘
        readonly property int nMaxMoveWidth: gameScene.width < itemContainer.width ? gameScene.width : itemContainer.width;
        readonly property int nMaxMoveHeight: gameScene.height < itemContainer.height ? gameScene.height : itemContainer.height;

        //地图场景的 最中央坐标（左上角的）；
        //人物绘制在场景最中间（返回地图最中间 - 人物的一半）
        readonly property int nRoleCenterInScenePosX: parseInt((gameScene.width - mainRole.width1) / 2);
        readonly property int nRoleCenterInScenePosY: parseInt((gameScene.height - mainRole.height1) / 2);



        //anchors.fill: parent
        width: rootGameScene.width / scale
        height: rootGameScene.height / scale

        clip: true
        color: "black"

        transformOrigin: Item.TopLeft



        Item {    //所有东西的容器
            id: itemContainer


            property var mapEventsTriggering: ({})    //保存正在触发的地图事件

            property var mapInfo: ({})          //地图数据（map.json 和 map.js（$$Script） 的数据）
            property var mapEventBlocks: ({})   //有事件的地图块ID（换算后的）

            //property var image1: "1.jpg"
            //property var image2: "2.png"


            //地图事件触发
            function gameEvent(eventName) {
                let tScript = itemContainer.mapInfo.$$Script['$' + eventName];
                if(!tScript)
                    tScript = itemContainer.mapInfo.$$Script[eventName];
                if(!tScript)
                    tScript = game.f['$' + eventName];
                if(!tScript)
                    tScript = game.f[eventName];

                GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '地图事件:' + eventName]);
                //game.run([tScript, '地图事件:' + eventName]);

                console.debug("[GameScene]gameEvent:", eventName);    //触发
            }
            //离开事件触发
            function gameEventCanceled(eventName) {
                let tScript = itemContainer.mapInfo.$$Script['$' + eventName + '_leave'];
                if(!tScript)
                    tScript = itemContainer.mapInfo.$$Script[eventName + '_leave'];
                if(!tScript)
                    tScript = game.f['$' + eventName + '_leave'];
                if(!tScript)
                    tScript = game.f[eventName + '_leave'];

                GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '地图事件离开:' + eventName + '_leave']);
                //game.run([tScript, '地图事件离开:' + eventName + '_leave']);

                console.debug("[GameScene]gameEventCanceled:", eventName + '_leave');    //触发
            }



            //width: 800
            //height: 600

            //scale: 2



            //地图点击
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    let eventName = '$map_click';
                    let tScript = itemContainer.mapInfo.$$Script[eventName];
                    if(!tScript)
                        tScript = game.f[eventName];
                    if(!tScript)
                        tScript = game.gf[eventName];
                    if(tScript)
                        game.run([tScript, eventName], -1, Math.floor(mouse.x / sizeMapBlockSize.width), Math.floor(mouse.y / sizeMapBlockSize.height), mouse.x, mouse.y);

                    //console.debug(mouse.x, mouse.y,
                    //              Math.floor(mouse.x / sizeMapBlockSize.width), Math.floor(mouse.y / sizeMapBlockSize.height))
                }
            }



            Image { //预先载入图片
                id: imageMapBlock
                //source: "file:./1.png"
                visible: false

                onStatusChanged: {
                    /*if(status === Image.Ready) {
                        for(let tc in itemBackMapContainer.arrCanvas) {
                            itemBackMapContainer.arrCanvas[tc].requestPaint();
                        }
                        for(let tc in itemFrontMapContainer.arrCanvas) {
                            itemFrontMapContainer.arrCanvas[tc].requestPaint();
                        }

                        console.debug("[GameScene]Image.Ready");
                    }
                    */
                }
                Component.onCompleted: {
                    console.debug("[GameScene]Image Component.onCompleted");
                }
            }


            //背景地图容器
            Item {
                id: itemBackMapContainer
                anchors.fill: parent
                property var arrCanvas: [canvasBackMap]

                Canvas {
                    id: canvasBackMap
                    anchors.fill: parent


                    onPaint: {  //绘制地图

                        //地图块没有准备好
                        /*if(imageMapBlock.status !== Image.Ready) {
                            console.debug("[GameScene]canvasMapBlock：地图块图片没有准备好：", imageMapBlock.source.status);
                            return;
                        }*/

                        if(!available) {
                            console.debug("[GameScene]canvasBackMap：地图块没有准备好：");
                            return;
                        }
                        if(!isImageLoaded(imageMapBlock.source)) {
                            console.debug("[GameScene]canvasBackMap：地图块图片没有载入：");
                            //loadImage(imageMapBlock.source);
                            return;
                        }


                        let ctx = getContext("2d");

                        //ctx.fillStyle = Qt.rgba(1, 0, 0, 1);
                        //ctx.fillRect(0, 0, width, height);
                        ctx.clearRect(0, 0, width, height);

                        //循环绘制地图块
                        /* 之前的
                        for(let i = 0; i < itemContainer.mapInfo.data.length; i++)
                        {
                            //x1、y1为源，x2、y2为目标
                            let x1 = itemContainer.mapInfo.data[i] % itemContainer.mapInfo.MapSize[0];    //12
                            let y1 = parseInt(itemContainer.mapInfo.data[i] / itemContainer.mapInfo.MapSize[0]);  //16
                            let x2 = i % itemContainer.mapInfo.MapSize[0];  //12
                            let y2 = parseInt(i / itemContainer.mapInfo.MapSize[0]);    //16

                            ctx.drawImage(imageMapBlock.source,
                                          x1 * itemContainer.mapInfo.MapBlockSize[0], y1 * itemContainer.mapInfo.MapBlockSize[1],
                                          itemContainer.mapInfo.MapBlockSize[0], itemContainer.mapInfo.MapBlockSize[1],
                                          x2 * sizeMapBlockSize.width, y2 * sizeMapBlockSize.height,
                                          sizeMapBlockSize.width, sizeMapBlockSize.height);

                            //ctx.drawImage(imageMapBlock2.source, 0, 0, 100, 100);

                            if(y2 > itemContainer.mapInfo.MapSize[1]) {
                                console.warn("WARNING!!!too many rows");
                                break;
                            }
                        }
                        */

                        //绘制每一层
                        for(let k = 0; k < itemContainer.mapInfo.MapCount; ++k) {
                            //console.debug("k:", k);

                            //跳过不属于这一层的
                            if(k >= itemContainer.mapInfo.MapOfRole)
                                continue;

                            for(let j = 0; j < itemContainer.mapInfo.MapData[k].length; ++j) {
                            //	console.debug("j:", j);
                                //循环绘制地图块
                                for(let i = 0; i < itemContainer.mapInfo.MapData[k][j].length; ++i) {
                            //		console.debug("i:", i);

                                    ctx.fillStyle = Qt.rgba(255, 0, 0, 1);
                                    //ctx.fillRect(x2, y2, sizeMapBlockSize.width, sizeMapBlockSize.height);

                                    if(itemContainer.mapInfo.MapData[k][j][i].toString() === '-1,-1,-1')
                                        continue;

                                    let _block = itemContainer.mapInfo.MapData[k][j][i];
                                    //x1、y1为源，x2、y2为目标
                                    let x1 = _block[0] * itemContainer.mapInfo.MapBlockSize[0];
                                    let y1 = _block[1] * itemContainer.mapInfo.MapBlockSize[1];
                                    let x2 = i * sizeMapBlockSize.width;
                                    let y2 = j * sizeMapBlockSize.height;

                                    //console.debug(k,j,i, ":", x1,y1,x2,y2);
                                    //console.debug(itemContainer.mapInfo.MapBlockSize[0], itemContainer.mapInfo.MapBlockSize[1], imageMapBlock, imageMapBlock.source);

                                    ctx.drawImage(imageMapBlock.source,
                                                  x1, y1,
                                                  itemContainer.mapInfo.MapBlockSize[0], itemContainer.mapInfo.MapBlockSize[1],
                                                  x2, y2,
                                                  sizeMapBlockSize.width, sizeMapBlockSize.height
                                    );
                                }
                            }
                        }

                        itemBackMapContainer.visible = true;

                        console.debug("[GameScene]canvasMapBack onPaint");
                    }

                    onImageLoaded: {    //载入图片完成
                        requestPaint(); //重新绘图

                        console.debug("[GameScene]canvasMapBack onImageLoaded");
                    }


                    Component.onCompleted: {
                        //loadImage(image1);  //载入图片
                        //loadImage(image2);
                        console.debug("[GameScene]canvasMapBack Component.onCompleted");
                    }
                }
            }


            //精灵容器
            Item {
                id: itemRoleContainer
                anchors.fill: parent


                /*Role {
                    id: mainRole

                    property Message message: Message {
                        parent: mainRole
                        visible: false
                        width: parent.width
                        height: parent.height * 0.2
                        anchors.bottom: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter

                        nMaxHeight: 32

                        onS_over: {
                            visible = false;
                        }
                    }

                    property string $name: ""

                    //在场景中的坐标
                    readonly property int sceneX: x + itemContainer.x
                    readonly property int sceneY: y + itemContainer.y

                    //其他属性（用户自定义）
                    property var props: ({})



                    z: y + y1



                    Component.onCompleted: {
                        //console.debug("[GameScene]Role Component.onCompleted");
                    }
                }
                */

            }


            //前景地图容器
            Item {
                id: itemFrontMapContainer
                anchors.fill: parent
                property var arrCanvas: [canvasFrontMap]

                Canvas {
                    id: canvasFrontMap
                    anchors.fill: parent


                    onPaint: {  //绘制地图

                        //地图块没有准备好
                        /*if(imageMapBlock.status !== Image.Ready) {
                            console.debug("[GameScene]canvasMapBlock：地图块图片没有准备好：", imageMapBlock.source.status);
                            return;
                        }*/

                        if(!available) {
                            console.debug("[GameScene]canvasFrontMap：地图块没有准备好：");
                            return;
                        }
                        if(!isImageLoaded(imageMapBlock.source)) {
                            console.debug("[GameScene]canvasFrontMap：地图块图片没有载入：");
                            //loadImage(imageMapBlock.source);
                            return;
                        }


                        let ctx = getContext("2d");

                        //ctx.fillStyle = Qt.rgba(1, 0, 0, 1);
                        //ctx.fillRect(0, 0, width, height);
                        ctx.clearRect(0, 0, width, height);

                        //循环绘制地图块
                        /* 之前的
                        for(let i = 0; i < itemContainer.mapInfo.data.length; i++)
                        {
                            //x1、y1为源，x2、y2为目标
                            let x1 = itemContainer.mapInfo.data[i] % itemContainer.mapInfo.MapSize[0];    //12
                            let y1 = parseInt(itemContainer.mapInfo.data[i] / itemContainer.mapInfo.MapSize[0]);  //16
                            let x2 = i % itemContainer.mapInfo.MapSize[0];  //12
                            let y2 = parseInt(i / itemContainer.mapInfo.MapSize[0]);    //16

                            ctx.drawImage(imageMapBlock.source,
                                          x1 * itemContainer.mapInfo.MapBlockSize[0], y1 * itemContainer.mapInfo.MapBlockSize[1],
                                          itemContainer.mapInfo.MapBlockSize[0], itemContainer.mapInfo.MapBlockSize[1],
                                          x2 * sizeMapBlockSize.width, y2 * sizeMapBlockSize.height,
                                          sizeMapBlockSize.width, sizeMapBlockSize.height);

                            //ctx.drawImage(imageMapBlock2.source, 0, 0, 100, 100);

                            if(y2 > itemContainer.mapInfo.MapSize[1]) {
                                console.warn("WARNING!!!too many rows");
                                break;
                            }
                        }
                        */

                        //绘制每一层
                        for(let k = 0; k < itemContainer.mapInfo.MapCount; ++k) {
                            //console.debug("k:", k);

                            //跳过不属于这一层的
                            if(k < itemContainer.mapInfo.MapOfRole)
                                continue;

                            for(let j = 0; j < itemContainer.mapInfo.MapData[k].length; ++j) {
                            //	console.debug("j:", j);
                                //循环绘制地图块
                                for(let i = 0; i < itemContainer.mapInfo.MapData[k][j].length; ++i) {
                            //		console.debug("i:", i);

                                    ctx.fillStyle = Qt.rgba(255, 0, 0, 1);
                                    //ctx.fillRect(x2, y2, sizeMapBlockSize.width, sizeMapBlockSize.height);

                                    if(itemContainer.mapInfo.MapData[k][j][i].toString() === '-1,-1,-1')
                                        continue;

                                    let _block = itemContainer.mapInfo.MapData[k][j][i];
                                    //x1、y1为源，x2、y2为目标
                                    let x1 = _block[0] * itemContainer.mapInfo.MapBlockSize[0];
                                    let y1 = _block[1] * itemContainer.mapInfo.MapBlockSize[1];
                                    let x2 = i * sizeMapBlockSize.width;
                                    let y2 = j * sizeMapBlockSize.height;

                                    //console.debug(k,j,i, ":", x1,y1,x2,y2);
                                    //console.debug(itemContainer.mapInfo.MapBlockSize[0], itemContainer.mapInfo.MapBlockSize[1], imageMapBlock, imageMapBlock.source);

                                    ctx.drawImage(imageMapBlock.source,
                                                  x1, y1,
                                                  itemContainer.mapInfo.MapBlockSize[0], itemContainer.mapInfo.MapBlockSize[1],
                                                  x2, y2,
                                                  sizeMapBlockSize.width, sizeMapBlockSize.height
                                    );
                                }
                            }
                        }

                        itemFrontMapContainer.visible = true;

                        console.debug("[GameScene]canvasFrontMap onPaint");
                    }

                    onImageLoaded: {    //载入图片完成
                        requestPaint(); //重新绘图

                        console.debug("[GameScene]canvasFrontMap onImageLoaded");
                    }


                    Component.onCompleted: {
                        //loadImage(image1);  //载入图片
                        //loadImage(image2);
                        console.debug("[GameScene]canvasFrontMap Component.onCompleted");
                    }
                }
            }
        }



        //游戏FPS
        Timer {
            property var nLastTime: 0

            id: timer
            repeat: true
            interval: 16
            triggeredOnStart: false
            running: false
            onRunningChanged: {
                if(running === true)
                    nLastTime = game.date().getTime();
            }

            onTriggered: {
                //如果是0，则重新赋值
                if(nLastTime <= 0) {
                    nLastTime = game.date().getTime();
                    return;
                }

                let bAsyncScriptIsEmpty = _private.asyncScript.isEmpty();

                //获取精确时间差
                let realinterval = game.date().getTime() - nLastTime;
                nLastTime = nLastTime + realinterval;

                //console.debug("!!!realinterval", realinterval)


                if(realinterval > 0)
                    textFPS.text = "FPS:" + Math.round(1000 / realinterval);


                //定时器操作

                //遍历全局定时器
                for(let tt in _private.objGlobalTimers) {
                    _private.objGlobalTimers[tt][2] -= realinterval;

                    //触发
                    if(_private.objGlobalTimers[tt][2] <= 0) {
                        //如果0个
                        if(_private.objGlobalTimers[tt][1] === 0) {
                            delete _private.objGlobalTimers[tt];
                            continue;
                        }
                        else if(_private.objGlobalTimers[tt][1] > 0){
                            --_private.objGlobalTimers[tt][1];
                        }

                        //如果次数完毕
                        if(_private.objGlobalTimers[tt][1] === 0)
                            delete _private.objGlobalTimers[tt];
                        else
                            _private.objGlobalTimers[tt][2] = _private.objGlobalTimers[tt][0];

                        GlobalJS.createScript(_private.asyncScript, 0, -1, [game.gf[tt], '全局定时器事件:' + tt]);
                        //game.run([game.gf[tt], tt]);

                        //GlobalJS.runScript(_private.asyncScript, 0, "game.gf['%1']()".arg(tt));
                    }
                }
                //遍历定时器
                for(let tt in _private.objTimers) {
                    _private.objTimers[tt][2] -= realinterval;

                    //触发
                    if(_private.objTimers[tt][2] <= 0) {
                        //如果0个
                        if(_private.objTimers[tt][1] === 0) {
                            delete _private.objTimers[tt];
                            continue;
                        }
                        else if(_private.objTimers[tt][1] > 0){
                            --_private.objTimers[tt][1];
                        }

                        //如果次数完毕
                        if(_private.objTimers[tt][1] === 0)
                            delete _private.objTimers[tt];
                        else
                            _private.objTimers[tt][2] = _private.objTimers[tt][0];

                        let tScript = itemContainer.mapInfo.$$Script[tt];
                        if(!tScript)
                            tScript = game.f[tt];

                        GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '定时器事件:' + tt], tt);
                        //game.run([tScript, tt]);
                        //GlobalJS.runScript(_private.asyncScript, 0, "game.f['%1']()".arg(tt));
                    }
                }


                //NPC操作

                //遍历每个NPC
                for(let r in _private.objRoles) {
                    let role = _private.objRoles[r];

                    //停止状态
                    //if(role.nActionType === 0)
                    //    continue;


                    let centerX = parseInt(role.x + role.x1 + role.width1 / 2);
                    let centerY = parseInt(role.y + role.y1 + role.height1 / 2);

                    //定向移动
                    if(role.nActionType === 2) {

                        if(role.targetPos.x < centerX) {
                            role.moveDirection = Qt.Key_Left;
                            _private.startSprite(role, role.moveDirection);
                        }
                        else if(role.targetPos.x > centerX) {
                            role.moveDirection = Qt.Key_Right;
                            _private.startSprite(role, role.moveDirection);
                        }
                        else if(role.targetPos.y < centerY) {
                            role.moveDirection = Qt.Key_Up;
                            _private.startSprite(role, role.moveDirection);
                        }
                        else if(role.targetPos.y > centerY) {
                            role.moveDirection = Qt.Key_Down;
                            _private.startSprite(role, role.moveDirection);
                        }
                        else {
                            //role.moveDirection = -1;
                            role.nActionType = 0;
                            _private.stopSprite(role);


                            let eventName = `$${role.$name}_arrive`;
                            let tScript = itemContainer.mapInfo.$$Script[eventName];
                            if(!tScript)
                                tScript = game.f[eventName];
                            if(!tScript)
                                tScript = game.gf[eventName];
                            if(tScript)
                                GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '角色事件:' + role.$name], role);
                                //game.run([tScript, role.$name]);

                            //console.debug('!!!ok, getup')
                        }
                    }


                    //增加状态时间
                    role.nActionStatusKeepTime += realinterval;

                    //走路状态
                    if(role.sprite.running) {
                        //console.debug("walk status")

                        //随机走
                        if(role.nActionType === 1) {
                            //如果到达切换状态阈值
                            if(role.nActionStatusKeepTime > 500) {
                                role.nActionStatusKeepTime = 0;

                                //概率停止
                                if(GlobalLibraryJS.randTarget(5, 6) !== 0) {
                                    _private.stopSprite(role);
                                    //role.moveDirection = -1;
                                    //role.stop();
                                    //console.debug("Stop");
                                    continue;
                                }

                            }
                        }

                        //计算走路
                        let offsetMove = Math.round(role.moveSpeed * realinterval);
                        offsetMove = _private.fComputeRoleMoveOffset(role, role.moveDirection, offsetMove);

                        if(role.nActionType === 1) {
                            if(offsetMove === 0) {
                                _private.stopSprite(role);
                                //role.moveDirection = -1;
                                //role.stop();
                                //console.debug("Stop2...");
                                continue;
                            }

                            //console.debug("Start...", role.moveDirection, offsetMove);
                            //人物移动计算（值为按键值）
                            switch(role.moveDirection) {
                            case Qt.Key_Left:
                                role.x -= offsetMove;
                                break;

                            case Qt.Key_Right:
                                role.x += offsetMove;
                                break;

                            case Qt.Key_Up: //同Left
                                role.y -= offsetMove;
                                break;

                            case Qt.Key_Down:   //同Right
                                role.y += offsetMove;
                                break;

                            default:
                                break;
                            }
                        }

                        //定向走
                        else if(role.nActionType === 2) {

                            //console.debug("Start...", role.moveDirection, offsetMove);
                            //人物移动计算（值为按键值）
                            switch(role.moveDirection) {
                            case Qt.Key_Left:
                                if(role.targetPos.x < centerX && role.targetPos.x > centerX - offsetMove)
                                    role.x = parseInt(role.targetPos.x - role.x1 - role.width1 / 2);
                                else
                                    role.x -= offsetMove;
                                break;

                            case Qt.Key_Right:
                                if(role.targetPos.x > centerX && role.targetPos.x < centerX + offsetMove)
                                    role.x = parseInt(role.targetPos.x - role.x1 - role.width1 / 2);
                                else
                                    role.x += offsetMove;
                                break;

                            case Qt.Key_Up: //同Left
                                if(role.targetPos.y < centerY && role.targetPos.y > centerY - offsetMove)
                                    role.y = parseInt(role.targetPos.y - role.y1 - role.height1 / 2);
                                else
                                    role.y -= offsetMove;
                                break;

                            case Qt.Key_Down:   //同Right
                                if(role.targetPos.y > centerY && role.targetPos.y < centerY + offsetMove)
                                    role.y = parseInt(role.targetPos.y - role.y1 - role.height1 / 2);
                                else
                                    role.y += offsetMove;
                                break;

                            default:
                                break;
                            }
                        }
                    }
                    //站立状态
                    else {
                        //随机走
                        if(role.nActionType === 1) {
                            //如果到达切换状态阈值
                            if(role.nActionStatusKeepTime > 500) {
                                role.nActionStatusKeepTime = 0;

                                //移动（概率）
                                //console.debug("stop status")
                                let tn = GlobalLibraryJS.random(1, 10)
                                if(tn === 1) {
                                    _private.startSprite(role, Qt.Key_Up);
                                    //role.moveDirection = Qt.Key_Up;
                                    //role.start();
                                }
                                else if(tn === 2) {
                                    _private.startSprite(role, Qt.Key_Down);
                                    //role.moveDirection = Qt.Key_Down;
                                    //role.start();
                                }
                                else if(tn === 3) {
                                    _private.startSprite(role, Qt.Key_Left);
                                    //role.moveDirection = Qt.Key_Left;
                                    //role.start();
                                }
                                else if(tn === 4) {
                                    _private.startSprite(role, Qt.Key_Right);
                                    //role.moveDirection = Qt.Key_Right;
                                    //role.start();
                                }
                            }
                        }
                        //console.debug("status:", role.moveDirection)
                    }



                    let collideRoles = {};

                    //与其他角色碰撞
                    for(let r in _private.objRoles) {
                        //跳过自身
                        if(role === _private.objRoles[r])
                            continue;
                        //跳过没有大小的
                        //if(_private.objRoles[r].width1 === 0 || _private.objRoles[r].height1 === 0)
                        //    continue;

                        if(
                            //(role.penetrate === 0 && _private.objRoles[r].penetrate === 0) &&
                            GlobalLibraryJS.checkRectangleClashed(
                                Qt.rect(role.x + role.x1, role.y + role.y1, role.width1, role.height1),
                                Qt.rect(_private.objRoles[r].x + _private.objRoles[r].x1, _private.objRoles[r].y + _private.objRoles[r].y1, _private.objRoles[r].width1, _private.objRoles[r].height1),
                            )
                        ) {
                            let eventName = `$${role.$name}_collide`;
                            let tScript = itemContainer.mapInfo.$$Script[eventName];
                            if(!tScript)
                                tScript = game.f[eventName];
                            if(!tScript)
                                tScript = game.gf[eventName];
                            if(tScript) {
                                //keep：是否是持续碰撞；
                                //key：
                                let keep = false;
                                let key = 'role_' + _private.objRoles[r].$name;
                                if(role.$$collideRoles[key] !== undefined) {
                                    keep = true;
                                    collideRoles[key] = role.$$collideRoles[key] + realinterval;
                                }
                                else
                                    collideRoles[key] = realinterval;

                                GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '角色碰撞角色事件:' + role.$name], role, _private.objRoles[r], keep);
                            }
                        }
                    }
                    //与主角碰撞
                    for(let r in _private.arrMainRoles) {
                        //跳过自身
                        if(role === _private.arrMainRoles[r])
                            continue;
                        //跳过没有大小的
                        //if(_private.arrMainRoles[r].width1 === 0 || _private.arrMainRoles[r].height1 === 0)
                        //    continue;

                        if(
                            //(role.penetrate === 0 && _private.arrMainRoles[r].penetrate === 0) &&
                            GlobalLibraryJS.checkRectangleClashed(
                                Qt.rect(role.x + role.x1 - 1, role.y + role.y1 - 1, role.width1 + 2, role.height1 + 2),
                                Qt.rect(_private.arrMainRoles[r].x + _private.arrMainRoles[r].x1, _private.arrMainRoles[r].y + _private.arrMainRoles[r].y1, _private.arrMainRoles[r].width1, _private.arrMainRoles[r].height1),
                            )
                        ) {
                            let eventName = `$${role.$name}_collide`;
                            let tScript = itemContainer.mapInfo.$$Script[eventName];
                            if(!tScript)
                                tScript = game.f[eventName];
                            if(!tScript)
                                tScript = game.gf[eventName];
                            if(tScript) {
                                //keep：是否是持续碰撞；
                                //key：
                                let keep = false;
                                let key = 'hero_' + _private.arrMainRoles[r].$name;
                                if(role.$$collideRoles[key] !== undefined) {
                                    keep = true;
                                    collideRoles[key] = role.$$collideRoles[key] + realinterval;
                                }
                                else
                                    collideRoles[key] = realinterval;
                                GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '角色碰撞主角事件:' + role.$name], role, _private.arrMainRoles[r], keep);
                            }
                        }
                    }

                    role.$$collideRoles = collideRoles;
                }



                //主角操作
                do {
                    let tIndex = 0; //mainRole下标
                    let mainRole = _private.arrMainRoles[tIndex];
                    if(!mainRole)
                        break;



                    //人物的占位最中央 所在地图的坐标
                    let centerX = mainRole.x + mainRole.x1 + mainRole.width1 / 2;
                    let centerY = mainRole.y + mainRole.y1 + mainRole.height1 / 2;


                    //自动行走
                    if(mainRole.nActionType === 2) {
                        if(mainRole.targetPos.x < centerX) {
                            _private.doAction(1, Qt.Key_Left);
                        }
                        else if(mainRole.targetPos.x > centerX) {
                            _private.doAction(1, Qt.Key_Right);
                        }
                        else if(mainRole.targetPos.y < centerY) {
                            _private.doAction(1, Qt.Key_Up);
                        }
                        else if(mainRole.targetPos.y > centerY) {
                            _private.doAction(1, Qt.Key_Down);
                        }
                        else {
                            mainRole.nActionType = 0;

                            _private.stopAction(1, -1);


                            let eventName = `$${mainRole.$name}_arrive`;
                            let tScript = itemContainer.mapInfo.$$Script[eventName];
                            if(!tScript)
                                tScript = game.f[eventName];
                            if(!tScript)
                                tScript = game.gf[eventName];
                            if(tScript)
                                GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '主角事件:' + mainRole.$name], mainRole);
                                //game.run([tScript, mainRole.$name]);

                            //console.debug('!!!ok, getup')
                        }
                    }

                    //console.debug('moveDirection:', mainRole.moveDirection)
                    else if(!mainRole.sprite.running)
                        break;


                    //计算真实移动偏移，初始为 角色速度 * 时间差
                    let offsetMove = Math.round(mainRole.moveSpeed * realinterval);

                    //如果开启摇杆加速，且用的不是键盘，则乘以摇杆偏移
                    if(_private.config.rJoystickSpeed > 0 && GlobalLibraryJS.objectIsEmpty(_private.keys)) {
                        let tOffset;    //遥感百分比
                        if(mainRole.moveDirection === Qt.Key_Left || mainRole.moveDirection === Qt.Key_Right) {
                            tOffset = Math.abs(joystick.pointInput.x);
                        }
                        else {
                            tOffset = Math.abs(joystick.pointInput.y);
                        }
                        //小于最小值
                        if(tOffset < _private.config.rJoystickSpeed)
                            tOffset = _private.config.rJoystickSpeed;
                        offsetMove = Math.round(offsetMove * tOffset);
                    }


                    //计算障碍距离
                    offsetMove = _private.fComputeRoleMoveToObstacleOffset(mainRole, mainRole.moveDirection, offsetMove);
                    if(offsetMove === 0) {  //如果碰墙

                        if(!_private.fChangeMainRoleDirection())
                            break;
                    }

                    //计算与其他角色距离
                    offsetMove = _private.fComputeRoleMoveToRolesOffset(mainRole, mainRole.moveDirection, offsetMove);

                    if(offsetMove !== undefined && offsetMove !== 0) {
                        //console.debug("offsetMove:", offsetMove);
                    }
                    else
                        break;


                    //存主角的新坐标
                    //let roleNewX = mainRole.x, roleNewY = mainRole.y;

                    //定向走
                    if(mainRole.nActionType === 2) {

                        //console.debug("Start...", mainRole.moveDirection, offsetMove);
                        //人物移动计算（值为按键值）
                        switch(mainRole.moveDirection) {
                        case Qt.Key_Left:
                            if(mainRole.targetPos.x < centerX && mainRole.targetPos.x > centerX - offsetMove)
                                mainRole.x = parseInt(mainRole.targetPos.x - mainRole.x1 - mainRole.width1 / 2);
                            else
                                mainRole.x -= offsetMove;
                            break;

                        case Qt.Key_Right:
                            if(mainRole.targetPos.x > centerX && mainRole.targetPos.x < centerX + offsetMove)
                                mainRole.x = parseInt(mainRole.targetPos.x - mainRole.x1 - mainRole.width1 / 2);
                            else
                                mainRole.x += offsetMove;
                            break;

                        case Qt.Key_Up: //同Left
                            if(mainRole.targetPos.y < centerY && mainRole.targetPos.y > centerY - offsetMove)
                                mainRole.y = parseInt(mainRole.targetPos.y - mainRole.y1 - mainRole.height1 / 2);
                            else
                                mainRole.y -= offsetMove;
                            break;

                        case Qt.Key_Down:   //同Right
                            if(mainRole.targetPos.y > centerY && mainRole.targetPos.y < centerY + offsetMove)
                                mainRole.y = parseInt(mainRole.targetPos.y - mainRole.y1 - mainRole.height1 / 2);
                            else
                                mainRole.y += offsetMove;
                            break;

                        default:
                            break;
                        }
                    }
                    else {
                        //人物移动计算（值为按键值）
                        switch(mainRole.moveDirection) {
                        case Qt.Key_Left:
                            mainRole.x -= offsetMove;
                            break;

                        case Qt.Key_Right:
                            mainRole.x += offsetMove;
                            break;

                        case Qt.Key_Up: //同Left
                            mainRole.y -= offsetMove;
                            break;

                        case Qt.Key_Down:   //同Right
                            mainRole.y += offsetMove;
                            break;

                        default:
                            break;
                        }
                    }



                    //mainRole.x = roleNewX;
                    //mainRole.y = roleNewY;

                    game.gd["$sys_main_roles"][tIndex].$x = mainRole.x;
                    game.gd["$sys_main_roles"][tIndex].$y = mainRole.y;





                    //开始移动地图
                    setMapToRole(mainRole);


                    /*/
                    let roleUseBlocks = fComputeRoleUseBlocks(roleNewX, roleNewY);
                    let checkover = false;

                    //检测特殊图块；如果是多方向的话，至少要检测两个方向，且检测人物坐标与障碍坐标的关系!!

                    //转换事件的地图块的坐标为地图块的ID
                    for(let i in roleUseBlocks) {
                        //计算出 行列
                        let px = roleUseBlocks[i] % itemContainer.mapInfo.MapSize[0];
                        let py = parseInt(roleUseBlocks[i] / itemContainer.mapInfo.MapSize[0]);
                        let strP = [px, py].toString();

                        console.debug("检测障碍：", strP, itemContainer.mapInfo.MapBlockSpecialData)
                        //存在障碍
                        if(itemContainer.mapInfo.MapBlockSpecialData[strP] !== undefined) {
                            switch(itemContainer.mapInfo.MapBlockSpecialData[strP]) {
                                //!!!这里需要修改
                            case -1:
                                if(mainRole.moveDirection === Qt.Key_Left) {

                                    let v = (px + 1) * sizeMapBlockSize.width - (mainRole.x + mainRole.x1);
                                    let rolePos = _private.fComputeRoleMoveOffset(mainRole, mainRole.moveDirection, v);
                                    roleNewX = rolePos[0];
                                    checkover = true;

                                    console.debug("碰到左边墙壁", px, (px + 1) * sizeMapBlockSize.width, (mainRole.x + mainRole.x1), v);
                                }
                                if(mainRole.moveDirection === Qt.Key_Right) {

                                    let rolePos = _private.fComputeRoleMoveOffset(mainRole, mainRole.moveDirection, (px) * sizeMapBlockSize.width - (mainRole.x + mainRole.x2));
                                    roleNewX = rolePos[0];
                                    checkover = true;

                                    console.debug("碰到右边障碍");
                                }
                                if(mainRole.moveDirection === Qt.Key_Up) {

                                    let rolePos = _private.fComputeRoleMoveOffset(mainRole, mainRole.moveDirection, (py + 1) * sizeMapBlockSize.height - (mainRole.y + mainRole.y1));
                                    roleNewX = rolePos[1];
                                    checkover = true;

                                    console.debug("碰到上方障碍");
                                }
                                if(mainRole.moveDirection === Qt.Key_Down) {

                                    let rolePos = _private.fComputeRoleMoveOffset(mainRole, mainRole.moveDirection, (py) * sizeMapBlockSize.height - (mainRole.y + mainRole.y2));
                                    roleNewX = rolePos[1];
                                    checkover = true;

                                    console.debug("碰到下边障碍");
                                }
                                break;
                            }

                            if(checkover)
                                break;

                        }
                    }
                    */






                    //计算是否触发地图事件


                    let mainRoleUseBlocks = [];

                    //计算人物所占的地图块

                    //返回 地图块坐标（左上和右下）
                    let usedMapBlocks = _private.fComputeUseBlocks(mainRole.x + mainRole.x1, mainRole.y + mainRole.y1, mainRole.x + mainRole.x2, mainRole.y + mainRole.y2);

                    //转换为 每个地图块ID
                    for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
                        for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
                            mainRoleUseBlocks.push(xb + yb * itemContainer.mapInfo.MapSize[0]);
                        }
                    }

                    let tEvents = {};   //暂存这次触发的所有事件
                    //循环事件
                    for(let event in itemContainer.mapEventBlocks) {
                        //console.debug("[GameScene]检测事件：", event, mainRoleUseBlocks);
                        //如果占用块包含事件块，则事件触发
                        if(mainRoleUseBlocks.indexOf(parseInt(event)) > -1) {
                            let isTriggered = itemContainer.mapEventsTriggering[itemContainer.mapEventBlocks[event]] ||
                                tEvents[itemContainer.mapEventBlocks[event]];

                            tEvents[itemContainer.mapEventBlocks[event]] = event;  //加入

                            //如果已经被触发过
                            if(isTriggered) {

                                ////将触发的事件删除（itemContainer.mapEventsTriggering剩下的就是 下面要取消触发的事件 了）
                                delete itemContainer.mapEventsTriggering[itemContainer.mapEventBlocks[event]];
                                continue;
                            }
                            //console.debug("[GameScene]gameEvent触发:", event, mainRoleUseBlocks, itemContainer.mapEventBlocks[event]);    //触发
                            itemContainer.gameEvent(itemContainer.mapEventBlocks[event]);   //触发事件
                        }
                        //console.debug("event:", event, mainRoleUseBlocks, mainRoleUseBlocks.indexOf(event), typeof(event), typeof(itemContainer.mapInfo.events[0]), typeof(mainRoleUseBlocks[0]))
                    }

                    //检测离开事件区域
                    for(let event in itemContainer.mapEventsTriggering) {
                        //console.debug("[GameScene]gameEventCanceled触发:", event, mainRoleUseBlocks, itemContainer.mapEventBlocks[event]);    //触发
                        itemContainer.gameEventCanceled(itemContainer.mapEventBlocks[itemContainer.mapEventsTriggering[event]]);   //触发事件
                        //console.debug("event:", event, mainRoleUseBlocks, mainRoleUseBlocks.indexOf(event), typeof(event), typeof(itemContainer.mapInfo.events[0]), typeof(mainRoleUseBlocks[0]))
                    }

                    itemContainer.mapEventsTriggering = tEvents;



                    textPos.text = " 【%1】".
                        arg([Math.floor(centerX / sizeMapBlockSize.width), Math.floor(centerY / sizeMapBlockSize.height)])
                        //.arg(itemContainer.mapInfo.data.length)
                    ;

                    textPos1.text = "[%1](%2),(%3),(%4),(%5)".
                        arg(mainRoleUseBlocks).
                        arg([centerX, centerY]).
                        arg([mainRole.x, mainRole.y]).
                        arg([mainRole.x + mainRole.x1, mainRole.y + mainRole.y1]).
                        arg([mainRole.x + mainRole.x2, mainRole.y + mainRole.y2])
                    ;

                }while(0);



                //放在这里运行事件，因为 loadmap 的地图事件会改掉所有原来的事件；
                //如果异步脚本 初始为空，且现在不为空
                if(bAsyncScriptIsEmpty && !_private.asyncScript.isEmpty())
                    game.run(null);



                //插件
                for(let tp in _private.objPlugins) {
                    if(_private.objPlugins[tp].$timerTriggered)
                        _private.objPlugins[tp].$timerTriggered(realinterval);
                }

                /*/精确控制下一帧（有问题）
                let runinterval = game.date().getTime() - nLastTime;
                if(runinterval >= _private.config.nInterval) {
                    timer.interval = 1;
                }
                else {
                    timer.interval = _private.config.nInterval + _private.config.nInterval - runinterval;
                }

                //console.debug("!!!runinterval", runinterval, timer.interval);
                */

                //nLastTime = nLastTime + realinterval;

                //timer.start();

            }
        }
    }


    /*/游戏对话框
    Dialog {
        id: dialogGameMsg

        property alias textGameMsg: textGameMsg.text

        title: ""
        width: 300
        height: 200
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true

        anchors.centerIn: parent

        Text {
            id: textGameMsg
            text: qsTr("")
        }


        MultiPointTouchArea {
            anchors.fill: parent
            enabled: dialogGameMsg.standardButtons === Dialog.NoButton
            onPressed: {
                //rootGameScene.forceActiveFocus();
                dialogGameMsg.reject();
            }
        }


        onAccepted: {
            //gameMap.focus = true;
            if(_private.config.bPauseGame)
                game.goon();
        }
        onRejected: {
            //gameMap.focus = true;
            if(_private.config.bPauseGame)
                game.goon();
            //console.log("Cancel clicked");
        }
    }*/


    //界面元素容器
    Item {
        id: itemComponentsContainer
        anchors.fill: parent


        Item {
            id: itemGamePad
            anchors.fill: parent

            z: 1


            Joystick {
                id: joystick

                property real rJoystickIgnore: 0.1  //忽略的最大偏移比

                anchors.left: parent.left
                anchors.bottom: parent.bottom

                width: 20 * Screen.pixelDensity
                height: 20 * Screen.pixelDensity

                //anchors.margins: 1 * Screen.pixelDensity
                transformOrigin: Item.BottomLeft
                anchors.leftMargin: 6 * Screen.pixelDensity
                anchors.bottomMargin: 7 * Screen.pixelDensity
                //anchors.verticalCenterOffset: -100
                //anchors.horizontalCenterOffset: -100

                opacity: 0.6
                scale: 1

                onPressedChanged: {
                    if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                        return;

                    if(pressed === false) {
                        _private.stopAction(0);
                    }
                    //console.debug("[GameScene]Joystick onPressedChanged:", pressed)
                }

                onPointInputChanged: {
                    //if(pointInput === Qt.point(0,0))
                    //    return;

                    if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                        return;

                    if(!pressed)    //如果没按下
                        return;

                    if(Math.abs(pointInput.x) > Math.abs(pointInput.y)) {
                        if(Math.abs(pointInput.x) < rJoystickIgnore) {    //忽略
                            _private.stopAction(0);
                            return;
                        }

                        if(pointInput.x > 0)
                            _private.doAction(0, Qt.Key_Right);
                        else
                            _private.doAction(0, Qt.Key_Left);
                    }
                    else {
                        if(Math.abs(pointInput.y) < rJoystickIgnore) {    //忽略
                            _private.stopAction(0);
                            return;
                        }

                        if(pointInput.y > 0)
                            _private.doAction(0, Qt.Key_Down);
                        else
                            _private.doAction(0, Qt.Key_Up);
                    }

                    //console.debug("[GameScene]onPointInputChanged", pointInput);
                }
            }


            /*/A键
            GameButton {
                id: buttonA


                property var buttonClicked: null

                property Image image: Image {
                    parent: buttonA
                    anchors.fill: parent
                }


                anchors.right: parent.right
                anchors.bottom: parent.bottom

                anchors.rightMargin: 10 * Screen.pixelDensity
                anchors.bottomMargin: 16 * Screen.pixelDensity

                //anchors.verticalCenterOffset: -100
                //anchors.horizontalCenterOffset: -100

                width: 6 * Screen.pixelDensity
                height: 6 * Screen.pixelDensity


                color: "red"

                onS_pressed: {
                    //if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                    //    return;
                    game.run(buttonClicked);
                }
            }


            //Menu键
            GameButton {
                id: buttonMenu


                property var buttonClicked: null

                property Image image: Image {
                    parent: buttonMenu
                    anchors.fill: parent
                }


                anchors.right: parent.right
                anchors.bottom: parent.bottom

                anchors.rightMargin: 16 * Screen.pixelDensity
                anchors.bottomMargin: 8 * Screen.pixelDensity

                //anchors.verticalCenterOffset: -100
                //anchors.horizontalCenterOffset: -100

                width: 6 * Screen.pixelDensity
                height: 6 * Screen.pixelDensity


                color: "blue"

                onS_pressed: {
                    //if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                    //    return;
                    game.run(buttonClicked);
                }
            }
            */

            Item {
                id: itemButtons
                anchors.fill: parent
            }
        }

    }



    /*
    //战斗场景
    Loader {
        id: loaderFightScene
        anchors.fill: parent

        visible: false


        source: "./FightScene.qml"
        asynchronous: false


        Connections {
            target: loaderFightScene.item

            //!鹰：Loader每次载入的时候都会重新Connection一次，所以没有的会出现警告
            function onS_FightOver() {
                rootGameScene.focus = true;
                loaderFightScene.visible = false;

                //_private.nStage = 0;
                //game.goon();

                //升级检测
                //for(let h in game.gd["$sys_fight_heros"]) {
                //    game.levelup(game.gd["$sys_fight_heros"][h]);
                //}
            }

            function onS_showFightRoleInfo(nIndex) {
                gameMenuWindow.showWindow(0b10, nIndex);
                //gameMenuWindow.showFightRoleInfo(nIndex);
            }

            //function onS_ShowSystemWindow() {
            //    gameMenuWindow.show();
            //}
        }

        onLoaded: {
            loaderFightScene.item.asyncScript = _private.asyncScript;
        }
    }
    */

    //战斗场景
    FightScene {
        id: loaderFightScene
        anchors.fill: parent

        visible: false


        //!鹰：Loader每次载入的时候都会重新Connection一次，所以没有的会出现警告
        onS_FightOver: function() {
            rootGameScene.focus = true;
            loaderFightScene.visible = false;

            //_private.nStage = 0;
            //game.goon();

            //升级检测
            //for(let h in game.gd["$sys_fight_heros"]) {
            //    game.levelup(game.gd["$sys_fight_heros"][h]);
            //}
        }

        onS_showFightRoleInfo: function(nIndex) {
            gameMenuWindow.showWindow(0b10, nIndex);
            //gameMenuWindow.showFightRoleInfo(nIndex);
        }

        //function onS_ShowSystemWindow() {
        //    gameMenuWindow.show();
        //}

        Component.onCompleted: {
            loaderFightScene.asyncScript = _private.asyncScript;
        }
    }



    //菜单
    GameMenuWindow {
        id: gameMenuWindow

        visible: false
        anchors.fill: parent

        onS_close: {
            gameMenuWindow.visible = false;

            if(_private.config.objPauseNames['$menu_window'] !== undefined) {
                game.goon('$menu_window');
                //_private.asyncScript.run();
            }

        }
        onS_show: {
            let show = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$window', '$show');
            if(show)
                show(newFlags, windowFlags);
        }
        onS_hide: {
            let hide = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$window', '$hide');
            if(hide)
                hide(newFlags, windowFlags);
        }
    }


    GameTradeWindow {
        id: dialogTrade

        anchors.fill: parent
        visible: false

    }



    //角色对话框
    Item {
        id: dialogRoleMsg


        //显示完全后延时
        property int nKeepTime: 0
        //显示状态：-1：停止；0：显示完毕；1：正在显示
        property int nShowStatus: -1


        signal accepted();
        signal rejected();


        function show(msg, pretext, interval, keeptime, style) {

            messageRole.color = style.BackgoundColor || '#BF6699FF';
            messageRole.border.color = style.BorderColor || 'white';
            messageRole.textArea.font.pointSize = style.FontSize || 16;
            messageRole.textArea.font.color = style.FontColor || 'white';
            maskMessageRole.color = style.MaskColor || 'transparent';

            //-1：即点即关闭；0：等待显示完毕(需点击）；>0：显示完毕后过keeptime毫秒自动关闭（不需点击）；
            dialogRoleMsg.nKeepTime = keeptime || 0;

            dialogRoleMsg.nShowStatus = 1;



            //console.debug("show1")
            dialogRoleMsg.visible = true;
            //touchAreaRoleMsg.enabled = false;
            messageRole.show(GlobalLibraryJS.convertToHTML(msg), GlobalLibraryJS.convertToHTML(pretext), interval, keeptime, 0b0);
            //console.debug("show2")
            //FrameManager.wait(-1);
        }

        function clicked() {
            //显示完毕，则关闭
            if(dialogRoleMsg.nShowStatus === 0)
                dialogRoleMsg.rejected();
            //如果正在显示，且nKeepTime为-1（表示点击后显示全部）；
            else if(dialogRoleMsg.nShowStatus === 1 && dialogRoleMsg.nKeepTime === -1) {
                dialogRoleMsg.nShowStatus = 0;
                messageRole.stop(1);
            }
        }


        anchors.fill: parent
        visible: false


        Mask {
            id: maskMessageRole

            anchors.fill: parent

            visible: color.a !== 0

            color: "transparent"

            mouseArea.onPressed: {
                dialogRoleMsg.clicked();
            }
        }


        Message {
            id: messageRole
            width: parent.width
            height: parent.height * 0.1
            //height: 90
            anchors.bottom: parent.bottom


            nMaxWidth: parent.width
            nMaxHeight: parent.height * 0.2
            //nMaxHeight: 90


            textArea.enabled: false

            textArea.onReleased: {
                dialogRoleMsg.clicked();
                //rootGameScene.forceActiveFocus();
            }

            onS_over: {
                //自动关闭
                if(dialogRoleMsg.nKeepTime > 0)
                    dialogRoleMsg.rejected();
                else
                    dialogRoleMsg.nShowStatus = 0;
            }
        }


        /*MultiPointTouchArea {
            id: touchAreaRoleMsg
            anchors.fill: parent
            enabled: false
            //enabled: dialogRoleMsg.standardButtons === Dialog.NoButton

            //onPressed: {
            onReleased: {
                //rootGameScene.forceActiveFocus();
                //console.debug("MultiPointTouchArea1")
                dialogRoleMsg.rejected();
                //console.debug("MultiPointTouchArea2")
            }
        }*/


        onAccepted: {
            //gameMap.focus = true;
            dialogRoleMsg.visible = false;

            dialogRoleMsg.nShowStatus = -1;


            if(_private.config.objPauseNames['$talk'] !== undefined) {
                game.goon('$talk');
                _private.asyncScript.run();
            }


            //FrameManager.goon();
        }
        onRejected: {
            //console.debug("onRejected1")
            dialogRoleMsg.visible = false;

            dialogRoleMsg.nShowStatus = -1;


            if(_private.config.objPauseNames['$talk'] !== undefined) {
                game.goon('$talk');
                _private.asyncScript.run();
            }


            //FrameManager.goon();
            //console.debug("onRejected2")
        }
    }


    //游戏对话框
    Item {
        id: dialogGameMsg

        //是否暂停了游戏
        //property bool bPauseGame: true
        //显示完全后延时
        property int nKeepTime: 0
        //显示状态：-1：停止；0：显示完毕；1：正在显示
        property int nShowStatus: -1
        //property alias textGameMsg: textGameMsg.text
        //property int standardButtons: Dialog.Ok | Dialog.Cancel


        signal accepted();
        signal rejected();


        function show(msg, pretext, interval, keeptime, style) {

            messageGame.color = style.BackgoundColor || '#BF6699FF';
            messageGame.border.color = style.BorderColor || 'white';
            messageGame.textArea.font.pointSize = style.FontSize || 16;
            messageGame.textArea.font.color = style.FontColor || 'white';
            maskMessageGame.color = style.MaskColor || '#7FFFFFFF';
            let type = style.Type || 0b10;

            //-1：即点即关闭；0：等待显示完毕(需点击）；>0：显示完毕后过keeptime毫秒自动关闭（不需点击）；
            dialogGameMsg.nKeepTime = keeptime || 0;

            dialogGameMsg.nShowStatus = 1;



            dialogGameMsg.visible = true;
            //touchAreaGameMsg.enabled = false;
            messageGame.show(GlobalLibraryJS.convertToHTML(msg), GlobalLibraryJS.convertToHTML(pretext), interval, dialogGameMsg.nKeepTime, type);
            //FrameManager.wait(-1);

        }

        function clicked() {
            //显示完毕，则关闭
            if(dialogGameMsg.nShowStatus === 0)
                dialogGameMsg.rejected();
            //如果正在显示，且nKeepTime为-1（表示点击后显示全部）；
            else if(dialogGameMsg.nShowStatus === 1 && dialogGameMsg.nKeepTime === -1) {
                dialogGameMsg.nShowStatus = 0;
                messageGame.stop(1);
            }
        }


        anchors.fill: parent
        visible: false


        Mask {
            id: maskMessageGame

            anchors.fill: parent

            visible: color.a !== 0

            color: "#7FFFFFFF"

            mouseArea.onPressed: {
                dialogGameMsg.clicked();
            }
        }


        Message {
            id: messageGame

            width: parent.width * 0.7
            height: parent.height * 0.7
            anchors.centerIn: parent


            nMaxWidth: parent.width * 0.7
            nMaxHeight: parent.height * 0.7


            textArea.enabled: false

            textArea.onReleased: {
                dialogGameMsg.clicked();
                //rootGameScene.forceActiveFocus();
            }

            onS_over: {
                //自动关闭
                if(dialogGameMsg.nKeepTime > 0)
                    dialogGameMsg.rejected();
                else
                    dialogGameMsg.nShowStatus = 0;
            }
        }


        /*MultiPointTouchArea {
            id: touchAreaGameMsg
            anchors.fill: parent
            //enabled: dialogGameMsg.standardButtons === Dialog.NoButton
            enabled: false

            //onPressed: {
            onReleased: {
                //rootGameScene.forceActiveFocus();
                //显示完毕，则关闭
                if(dialogGameMsg.nShowStatus === 0)
                    dialogGameMsg.rejected();
                //如果正在显示，且nKeepTime为-1（表示点击后显示全部）；
                else if(dialogGameMsg.nShowStatus === 1 && dialogGameMsg.nKeepTime === -1) {
                    dialogGameMsg.nShowStatus = 0;
                    messageGame.stop(1);
                }
            }
        }*/


        onAccepted: {
            //gameMap.focus = true;

            dialogGameMsg.visible = false;

            dialogGameMsg.nShowStatus = -1;


            /*if(dialogGameMsg.bPauseGame && _private.config.bPauseGame) {
                game.goon();
                dialogGameMsg.bPauseGame = false;
            }*/

            if(_private.config.objPauseNames['$msg'] !== undefined) {
                game.goon('$msg');
                _private.asyncScript.run();
            }


            //FrameManager.goon();
        }
        onRejected: {
            //gameMap.focus = true;

            dialogGameMsg.visible = false;

            dialogGameMsg.nShowStatus = -1;


            /*if(dialogGameMsg.bPauseGame && _private.config.bPauseGame) {
                game.goon();
                dialogGameMsg.bPauseGame = false;
            }*/

            if(_private.config.objPauseNames['$msg'] !== undefined) {
                game.goon('$msg');
                _private.asyncScript.run();
            }


            //FrameManager.goon();
        }
    }

    //游戏 选择框
    Item {
        id: rectMenu

        anchors.fill: parent
        visible: false

        Mask {
            id: maskMenu

            anchors.fill: parent

            visible: color.a !== 0

            color: "#60000000"
        }

        Rectangle {
            //width: parent.width * 0.5
            width: Screen.width > Screen.height ? parent.width * 0.6 : parent.width * 0.9
            //height: parent.height * 0.5
            height: Math.min(menuGame.implicitHeight, parent.height * 0.5)
            anchors.centerIn: parent

            clip: true
            color: "#00000000"
            border.color: "white"
            radius: height / 20


            GameMenu {
                id: menuGame

                //radius: rectMenu.radius

                width: parent.width
                height: parent.height

                colorTitleColor: "#EE00CC99"
                strTitle: ''

                //height: parent.height / 2
                //anchors.centerIn: parent

                onS_Choice: {
                    //gameMap.focus = true;

                    rectMenu.visible = false;
                    //menuGame.hide();

                    if(_private.config.objPauseNames['$menu'] !== undefined) {
                        game.goon('$menu');
                        _private.asyncScript.run(index);
                    }

                    //FrameManager.goon();
                    //console.debug("!!!asyncScript.run", index);
                }
            }
        }
    }

    //游戏 输入框
    Item {
        id: rectRootGameInput

        anchors.fill: parent
        visible: false

        Mask {
            id: maskGameInput

            anchors.fill: parent

            visible: color.a !== 0

            color: "#7FFFFFFF"

            mouseArea.onPressed: {
                //rectRootGameInput.visible = false;
                //game.goon('$input');
                //_private.asyncScript.run(textGameInput.text);
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width * 0.6
            //height: parent.height * 0.6

            Rectangle {
                id: rectGameInputTitle

                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 60
                //implicitHeight: 60

                //color: "darkred"
                color: "#EE00CC99"
                //radius: rectMenu.radius

                Text {
                    id: textGameInputTitle

                    anchors.fill: parent

                    color: "white"

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    font.pointSize: 16
                    font.bold: true

                    wrapMode: Text.NoWrap
                }

            }


            Rectangle {
                id: rectGameInput
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: textGameInput.implicitHeight


                color: "#FFFFFF"

                border {
                    color: '#60000000'
                }


                TextArea {
                    id: textGameInput

                    anchors.fill: parent


                    color: "black"

                    //horizontalAlignment: Text.AlignHCenter
                    //verticalAlignment: Text.AlignVCenter

                    font.pointSize: 16
                    font.bold: true

                    selectByKeyboard: true
                    selectByMouse: true
                    wrapMode: Text.Wrap
                }
            }

            ColorButton {

                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                text: '确定'
                onButtonClicked: {
                    rectRootGameInput.visible = false;

                    if(_private.config.objPauseNames['$input'] !== undefined) {
                        game.goon('$input');
                        _private.asyncScript.run(textGameInput.text);
                    }

                }
            }
        }
    }

    //视频播放
    Item {
        id: itemVideo
        anchors.fill: parent
        visible: false

        MediaPlayer {
            id: mediaPlayer

            source: ""

            onStopped: {
                game.stopvideo();
            }
        }

        //渲染视频
        VideoOutput{
            id: videoOutput

            anchors.centerIn: parent
            source: mediaPlayer
            //fillMode: VideoOutput.Stretch
            //x: 0
            //y: 0

            //width: rootGameScene.width
            //height: rootGameScene.height
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(mediaPlayer.playbackState === MediaPlayer.PlayingState)
                    mediaPlayer.pause();
                else
                    mediaPlayer.play();
            }
            onDoubleClicked: {
                game.stopvideo();
            }
        }
    }



    //调试
    Rectangle {
        width: Platform.compileType() === "debug" ? rootGameScene.width / 3 : rootGameScene.width / 2
        height: Platform.compileType() === "debug" ? textFPS.implicitHeight : textFPS.implicitHeight
        color: "#90FFFFFF"

        Row {
            height: 15

            Text {
                id: textFPS
                //y: 0
                width: 100
                height: textFPS.implicitHeight
            }

            Text {
                id: textPos
                //y: 15
                width: 100
                height: textFPS.implicitHeight

                //visible: Platform.compileType() === "debug"
            }
        }
        Text {
            id: textPos1
            y: 15
            width: 200
            height: 15

            visible: Platform.compileType() === "debug"
        }


        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
                dialogScript.open();
            }
        }
    }




    //测试脚本对话框
    Dialog {
        id: dialogScript

        title: "执行脚本"
        width: parent.width * 0.9
        height: Math.max(200, Math.min(parent.height, textScript.implicitHeight + 160))
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true
        visible: false

        anchors.centerIn: parent

        TextArea {
            id: textScript
            width: parent.width
            placeholderText: "输入脚本命令"

            //textFormat: Text.RichText
            selectByKeyboard: true
            selectByMouse: true
            wrapMode: TextEdit.Wrap
        }

        onAccepted: {
            //gameMap.focus = true;
            rootGameScene.forceActiveFocus();
            console.debug(eval(textScript.text));
            //GlobalJS.runScript(_private.asyncScript, 0, textScript.text);
        }
        onRejected: {
            //gameMap.focus = true;
            rootGameScene.forceActiveFocus();
            //console.log("Cancel clicked");
        }
    }




    Item {
        id: itemBackgroundMusic

        property var arrMusicStack: []  //播放音乐栈

        property var objMusicPause: ({})


        function isPlaying() {
            return audioBackgroundMusic.playbackState === Audio.PlayingState;
        }

        function play() {
            //bPlay = true;
            if(GlobalLibraryJS.objectIsEmpty(objMusicPause))
                audioBackgroundMusic.play();
            //nPauseTimes = 0;
        }

        function stop() {
            //bPlay = false;
            audioBackgroundMusic.stop();
            //nPauseTimes = 0;
        }

        function pause(name='$user') {
            //if(objMusicPause[name] === 1)
            //    console.warn('游戏被多次暂停，请检查是否有暂停游戏的指令（比如msg、menu等）没有使用yield？');
            //objMusicPause[name] = (objMusicPause[name] ? objMusicPause[name] + 1 : 1);
            objMusicPause[name] = 1;

            if(audioBackgroundMusic.playbackState !== Audio.StoppedState)
                audioBackgroundMusic.pause();
            //console.debug("!!!pause", nPauseTimes)
        }

        function resume(name='$user') {
            if(name === true) {
                objMusicPause = {};
            }
            else {
                if(objMusicPause[name]) {
                    --objMusicPause[name];
                    if(objMusicPause[name] === 0)
                        delete objMusicPause[name];
                }
                else {
                    //rootGameScene.forceActiveFocus();
                    //return;
                }
            }


            if(GlobalLibraryJS.objectIsEmpty(objMusicPause)) {
                if(audioBackgroundMusic.playbackState !== Audio.StoppedState)
                    audioBackgroundMusic.play();
            }

            //console.debug("!!!resume", nPauseTimes, bPlay)
        }

        Audio {
            id: audioBackgroundMusic
            loops: Audio.Infinite

            onPlaybackStateChanged: {
            }
        }
    }


    QtObject {  //公有数据,函数,对象等
        id: _public


        //创建Skill对象
        //forceNew：当skill为技能对象时，forceNew为true或对象（会复制它的属性）则表示再新建一个相同的技能对象返回；
        function getSkillObject(skill, forceNew=true) {
            let retSkill = null;
            if(GlobalLibraryJS.isString(skill)) {
                if(_private.objSkills[skill] === undefined) {
                    console.warn('没有技能：', skill);
                    return null;
                }

                //创建技能
                retSkill = {$rid: skill};
                if(_private.objSkills[skill].$createData)
                    GlobalLibraryJS.copyPropertiesToObject(retSkill, _private.objSkills[skill].$createData());
                retSkill.__proto__ = _private.objSkills[skill];
            }
            else if(GlobalLibraryJS.isObject(skill)) {
                //如果已是 技能对象，直接返回
                if(skill.$rid && _private.objSkills[skill.$rid] !== undefined) {
                    if(forceNew === false)
                        return skill;

                    /*if(_private.objSkills[skill.$rid].$createData)
                        retSkill = _private.objSkills[skill.$rid].$createData();
                    else
                        retSkill = {};
                    */
                    retSkill = {};
                    GlobalLibraryJS.copyPropertiesToObject(retSkill, skill/*, true*/);
                    if(GlobalLibraryJS.isObject(forceNew))
                        GlobalLibraryJS.copyPropertiesToObject(retSkill, forceNew/*, true*/);
                    retSkill.__proto__ = _private.objSkills[skill.$rid];

                    //return retSkill;
                }

                else if(_private.objSkills[skill.RId] === undefined) {
                    console.warn('没有技能：', skill.RId);
                    return null;
                }

                else {
                    //创建技能
                    retSkill = {$rid: skill.RId};
                    if(_private.objSkills[skill.RId].$createData)
                        GlobalLibraryJS.copyPropertiesToObject(retSkill, _private.objSkills[skill.RId].$createData(skill.Params));
                    //delete skill.RId;
                    //delete skill.Params;
                    GlobalLibraryJS.copyPropertiesToObject(retSkill, skill, {filterExcept: {RId: undefined, Params: undefined}, filterRecursion: false});
                    retSkill.__proto__ = _private.objSkills[skill.RId];
                }
            }
            else
                return null;


            return retSkill;
        }

        //创建Goods对象
        //forceNew：当goods为道具对象时，forceNew为true或对象（会复制它的属性）则表示再新建一个相同的道具对象返回
        function getGoodsObject(goods, forceNew=true) {
            let retGoods = null;
            if(GlobalLibraryJS.isString(goods)) {
                if(_private.objGoods[goods] === undefined) {
                    console.warn('没有道具：', goods);
                    return null;
                }

                retGoods = {$rid: goods};
                if(_private.objGoods[goods].$createData)
                    GlobalLibraryJS.copyPropertiesToObject(retGoods, _private.objGoods[goods].$createData());
                retGoods.__proto__ = _private.objGoods[goods];
            }
            else if(GlobalLibraryJS.isObject(goods)) {
                //如果已是 道具对象
                if(goods.$rid && _private.objGoods[goods.$rid] !== undefined) {
                    if(forceNew === false)
                        return goods;

                    /*
                    if(_private.objGoods[goods.$rid].$createData)
                        retGoods = _private.objGoods[goods.$rid].$createData();
                    else
                        retGoods = {};
                    */
                    retGoods = {};
                    GlobalLibraryJS.copyPropertiesToObject(retGoods, goods/*, true*/);
                    if(GlobalLibraryJS.isObject(forceNew))
                        GlobalLibraryJS.copyPropertiesToObject(retGoods, forceNew/*, true*/);
                    retGoods.__proto__ = _private.objGoods[goods.$rid];

                    //return retGoods;
                }

                else if(_private.objGoods[goods.RId] === undefined) {
                    console.warn('没有道具：', goods.RId);
                    return null;
                }

                else {
                    retGoods = {$rid: goods.RId};
                    if(_private.objGoods[goods.RId].$createData)
                        GlobalLibraryJS.copyPropertiesToObject(retGoods, _private.objGoods[goods.RId].$createData(goods.Params));
                    //delete goods.RId;
                    //delete goods.Params;
                    GlobalLibraryJS.copyPropertiesToObject(retGoods, goods, {filterExcept: {RId: undefined, Params: undefined}, filterRecursion: false});
                    retGoods.__proto__ = _private.objGoods[goods.RId];
                }
            }
            else
                return null;


            //得到道具所有的skill对象 并替换到skills
            if(retGoods.$skills) {
                let tskills = [];
                for(let tskill in retGoods.$skills) {
                    let t = _public.getSkillObject(retGoods.$skills[tskill], true);
                    if(t)
                        tskills.push(t);
                }
                retGoods.$skills = tskills;
            }
            if(retGoods.$fight) {
                let tskills = [];
                for(let tfight in retGoods.$fight) {
                    let t = _public.getSkillObject(retGoods.$fight[tfight], true);
                    if(t)
                        tskills.push(t);
                }
                retGoods.$fight = tskills;
            }


            return retGoods;
        }

        //创建FightRole对象
        //forceNew：当FightRole为战斗人物对象时，forceNew为true或对象（会复制它的属性）则表示再新建一个相同的战斗人物对象返回
        function getFightRoleObject(fightrole, forceNew=true) {
            let retFightRole = null;
            if(GlobalLibraryJS.isString(fightrole)) {
                if(_private.objFightRoles[fightrole] === undefined) {
                    console.warn('没有战斗角色：', fightrole);
                    return null;
                }

                //创建战斗人物
                retFightRole = {$rid: fightrole};
                GlobalLibraryJS.copyPropertiesToObject(retFightRole, new game.objCommonScripts["combatant_class"](fightrole));
                if(_private.objFightRoles[fightrole].$createData)
                    GlobalLibraryJS.copyPropertiesToObject(retFightRole, _private.objFightRoles[fightrole].$createData());
                retFightRole.__proto__ = _private.objFightRoles[fightrole];
            }
            else if(GlobalLibraryJS.isObject(fightrole)) {
                //如果已是 战斗人物对象，直接返回
                if(fightrole.$rid && _private.objFightRoles[fightrole.$rid] !== undefined) {
                    if(forceNew === false)
                        return fightrole;

                    retFightRole = new game.objCommonScripts["combatant_class"](fightrole.$rid);
                    //if(_private.objFightRoles[fightrole.$rid].$createData)
                    //    GlobalLibraryJS.copyPropertiesToObject(retFightRole, _private.objFightRoles[fightrole.$rid].$createData());
                    GlobalLibraryJS.copyPropertiesToObject(retFightRole, fightrole/*, true*/);
                    if(GlobalLibraryJS.isObject(forceNew))
                        GlobalLibraryJS.copyPropertiesToObject(retFightRole, forceNew/*, true*/);
                    retFightRole.__proto__ = _private.objFightRoles[fightrole.$rid];

                    //return retFightRole;
                }

                else if(_private.objFightRoles[fightrole.RId] === undefined) {
                    console.warn('没有战斗角色：', fightrole.RId);
                    return null;
                }
                else {
                    //创建战斗人物
                    retFightRole = {$rid: fightrole.RId};
                    GlobalLibraryJS.copyPropertiesToObject(retFightRole, new game.objCommonScripts["combatant_class"](fightrole.RId));
                    if(_private.objFightRoles[fightrole.RId].$createData)
                        GlobalLibraryJS.copyPropertiesToObject(retFightRole, _private.objFightRoles[fightrole.RId].$createData(fightrole.Params));
                    //delete fightrole.RId;
                    //delete fightrole.Params;
                    GlobalLibraryJS.copyPropertiesToObject(retFightRole, fightrole, {filterExcept: {RId: undefined, Params: undefined}, filterRecursion: false});
                    retFightRole.__proto__ = _private.objFightRoles[fightrole.RId];
                }
            }
            else
                return null;


            //替换所有equip、goods、skills 为对象
            if(retFightRole.$skills) {
                let tskills = [];
                for(let tt in retFightRole.$skills) {
                    let t = _public.getSkillObject(retFightRole.$skills[tt], true);
                    if(t)
                        tskills.push(t);
                }
                retFightRole.$skills = tskills;
            }
            if(retFightRole.$goods) {
                let tGoods = [];
                for(let tt in retFightRole.$goods) {
                    let t = _public.getGoodsObject(retFightRole.$goods[tt], true);
                    if(t)
                        tGoods.push(t);
                }
                retFightRole.$goods = tGoods;
            }
            if(retFightRole.$equipment) {
                let tequipment = {};
                for(let tt in retFightRole.$equipment) {
                    let t = _public.getGoodsObject(retFightRole.$equipment[tt], true);
                    if(t)
                        tequipment[tt] = t;
                }
                retFightRole.$equipment = tequipment;
            }

            //刷新
            game.objCommonScripts["refresh_combatant"](retFightRole);


            return retFightRole;
        }

        function getFightScriptObject(fightscript, forceNew=true) {
            let retFightScript = null;
            if(GlobalLibraryJS.isString(fightscript)) {
                if(_private.objFightScripts[fightscript] === undefined) {
                    console.warn('没有战斗脚本：', fightscript);
                    return null;
                }

                //创建战斗脚本
                retFightScript = {$rid: fightscript};
                if(_private.objFightScripts[fightscript].$createData)
                    GlobalLibraryJS.copyPropertiesToObject(retFightScript, _private.objFightScripts[fightscript].$createData());
                retFightScript.__proto__ = _private.objFightScripts[fightscript];
            }
            else if(GlobalLibraryJS.isObject(fightscript)) {
                //如果已是 战斗脚本对象，直接返回
                if(fightscript.$rid && _private.objFightScripts[fightscript.$rid] !== undefined) {
                    if(forceNew === false)
                        return fightscript;

                    /*
                    if(_private.objFightScripts[fightscript.$rid].$createData)
                        retFightScript = _private.objFightScripts[fightscript.$rid].$createData(fightscript.Params);
                    else
                        retFightScript = {};
                    */
                    retFightScript = {};
                    //GlobalLibraryJS.copyPropertiesToObject(retFightScript, new game.objCommonScripts["combatant_class"](fightscript.$rid));
                    GlobalLibraryJS.copyPropertiesToObject(retFightScript, fightscript/*, true*/);
                    if(GlobalLibraryJS.isObject(forceNew))
                        GlobalLibraryJS.copyPropertiesToObject(retFightScript, forceNew/*, true*/);
                    retFightScript.__proto__ = _private.objFightScripts[fightscript.$rid];

                    //return retFightScript;
                }

                else if(_private.objFightScripts[fightscript.RId] === undefined) {
                    console.warn('没有战斗脚本：', fightscript.RId);
                    return null;
                }
                else {
                    //创建战斗脚本
                    retFightScript = {$rid: fightscript.RId};
                    if(_private.objFightScripts[fightscript.RId].$createData)
                        GlobalLibraryJS.copyPropertiesToObject(retFightScript, _private.objFightScripts[fightscript.RId].$createData(fightscript.Params));
                    //delete fightscript.RId;
                    //delete fightscript.Params;
                    GlobalLibraryJS.copyPropertiesToObject(retFightScript, fightscript, {filterExcept: {RId: undefined, Params: undefined}, filterRecursion: false});
                    retFightScript.__proto__ = _private.objFightScripts[fightscript.RId];
                }
            }
            else
                return null;


            return retFightScript;
        }



        //载入特效，返回特效对象
        //如果 spriteEffect 为null，则 创建1个 SpriteEffect 组件并返回（这个一般用在 角色动作上）
        function loadSpriteEffect(spriteEffectRId, spriteEffect, loops=1, parent=itemRoleContainer) {
            //console.debug("[FightScene]loadSpriteEffect0");

            /*let filePath = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + spriteEffectRId + GameMakerGlobal.separator + "sprite.json";
            //console.debug("[FightScene]filePath2：", filePath);
            let data = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));
            */

            let data = game.objSprites[spriteEffectRId];

            if(data) {
                if(!spriteEffect) {
                    spriteEffect = compCacheSpriteEffect.createObject(parent);
                    spriteEffect.s_playEffect.connect(function(soundeffectSource) {
                        if(_private.objCacheSoundEffects[soundeffectSource]) {
                            if(_private.config.nSoundConfig !== 0)
                                return;

                            //!!!鹰：手机上，如果状态为playing，貌似后面play就没声音了。。。
                            if(_private.objCacheSoundEffects[soundeffectSource].playing)
                                _private.objCacheSoundEffects[soundeffectSource].stop();
                            _private.objCacheSoundEffects[soundeffectSource].play();
                        }
                    });
                }

                spriteEffect.spriteSrc = Global.toURL(GameMakerGlobal.spriteResourceURL(data.Image));
                spriteEffect.sizeFrame = Qt.size(parseInt(data.FrameSize[0]), parseInt(data.FrameSize[1]));
                spriteEffect.nFrameCount = parseInt(data.FrameCount);
                spriteEffect.offsetIndex = Qt.point(parseInt(data.OffsetIndex[0]), parseInt(data.OffsetIndex[1]));

                spriteEffect.interval = parseInt(data.FrameInterval);
                //spriteEffect.width = parseInt(textSpriteWidth.text);
                //spriteEffect.height = parseInt(textSpriteHeight.text);
                spriteEffect.implicitWidth = parseInt(data.SpriteSize[0]);
                spriteEffect.implicitHeight = parseInt(data.SpriteSize[1]);
                spriteEffect.opacity = parseFloat(data.Opacity);
                spriteEffect.rXScale = parseFloat(data.XScale);
                spriteEffect.rYScale = parseFloat(data.YScale);

                if(data.Sound) {
                    spriteEffect.soundeffectName = data.Sound;
                }
                else {
                    spriteEffect.soundeffectName = "";
                }
                //console.debug("!!!", data.Sound, spriteEffect.soundeffectName)
                spriteEffect.soundeffectDelay = parseInt(data.SoundDelay);

                spriteEffect.animatedsprite.loops = loops;
                //spriteEffect.restart();

                return spriteEffect;
            }

            console.warn("[GameScene]载入特效失败：" + spriteEffectRId);
            return null;
        }

    }


    QtObject {  //私有数据,函数,对象等
        id: _private


        //游戏配置/设置
        property var config: QtObject {
            property int nInterval: 16
            property var objPauseNames: ({})     //暂停游戏
            property int nSoundConfig: 0        //0为播放，>0为暂停
            property real rJoystickSpeed: 0.2   //开启摇杆加速功能（最低速度比例）
            //键盘是否可以操作
            property bool bKeyboard: true
        }

        //存档m5的盐
        readonly property string strSaveDataSalt: "深林孤鹰@鹰歌联盟Leamus_" + GameMakerGlobal.config.strCurrentProjectName

        //游戏目前阶段（0：正常；1：战斗）
        property int nStage: 0



        //资源（外部读取） 信息

        property var objSkills: ({})        //所有技能信息
        property var objFightScripts: ({})        //所有战斗脚本信息
        property var objFightRoles: ({})        //所有战斗角色信息
        property var objGoods: ({})         //所有道具信息；格式：key为 道具资源名，每个对象属性：$rid为 道具资源名，其他是脚本返回值（$commons）
        property var objSprites: ({})       //所有特效信息；格式：key为 特效资源名，每个对象属性：$rid为 为特效资源名，$$cache为缓存{image: Image组件, music: SoundEffect组件}
        property var objCacheSoundEffects: ({})       //所有音效信息

        property var objCommonScripts: ({})     //系统用到的 通用脚本（外部脚本优先，如果没有使用 GameMakerGlobal.js的）

        //媒体列表 信息
        //property var objImages: ({})         //{图片名: 图片路径}
        //property var objMusic: ({})         //{音乐名: 音乐路径}
        //property var objVideos: ({})         //{视频名: 视频路径}



        //创建的 角色NPC 和 主角
        property var objRoles: ({})
        property var arrMainRoles: []

        property var objTmpImages: ({})      //临时图片组件（用户用）
        property var objTmpSprites: ({})      //临时精灵组件（用户用）

        //地图缓存（目前没用到）
        property var objCacheMaps: ({})

        //依附在地图上的图片和特效，切换地图时删除
        property var arrayMapComponents: []


        //定时器
        property var objTimers: ({})        //{定时器名: [间隔,触发次数,是否全局,剩余时长]}
        property var objGlobalTimers: ({})        //{定时器名: [间隔,触发次数,是否全局,剩余时长]}



        //异步脚本（整个游戏的脚本队列系统）
        property var asyncScript: new GlobalLibraryJS.Async(rootGameScene)

        //JS引擎，用来载入外部JS文件
        property var jsEngine: new GlobalJS.JSEngine(rootGameScene)
        property var objPlugins: ({})

        //临时保存屏幕旋转
        property int lastOrient: -1



        //键盘处理
        property var keys: ({}) //保存按下的方向键

        //type为0表示按钮，type为1表示键盘（会保存key）
        function doAction(type, key) {
            switch(key) {
            case Qt.Key_Down:
                _private.startSprite(mainRole, Qt.Key_Down);
                //mainRole.moveDirection = Qt.Key_Down; //移动方向
                //mainRole.start();
                //timer.start();  //开始移动
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            case Qt.Key_Left:
                _private.startSprite(mainRole, Qt.Key_Left);
                //mainRole.moveDirection = Qt.Key_Left;
                //mainRole.start();
                //timer.start();
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            case Qt.Key_Right:
                _private.startSprite(mainRole, Qt.Key_Right);
                //mainRole.moveDirection = Qt.Key_Right;
                //mainRole.start();
                //timer.start();
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            case Qt.Key_Up:
                _private.startSprite(mainRole, Qt.Key_Up);
                //mainRole.moveDirection = Qt.Key_Up;
                //mainRole.start();
                //timer.start();
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            default:
                break;
            }
        }

        function stopAction(type, key) {

            if(type === 1) {
                switch(key) {
                case Qt.Key_Up:
                case Qt.Key_Right:
                case Qt.Key_Left:
                case Qt.Key_Down:
                    delete keys[key]; //从键盘保存中删除

                    //获取下一个已经按下的键
                    let l = Object.keys(keys);
                    //console.debug(l);
                    //keys.pop();
                    if(l.length === 0) {    //如果没有键被按下
                        //timer.stop();
                        _private.stopSprite(mainRole);
                        //mainRole.stop();
                        //console.debug("[GameScene]_private.stopAction stop");
                    }
                    else {
                        _private.startSprite(mainRole, l[0]);
                        //mainRole.moveDirection = l[0];    //弹出第一个按键
                        //mainRole.start();
                        //console.debug("[GameScene]_private.stopAction nextKey");
                    }
                    break;

                default:
                    keys = {};
                    _private.stopSprite(mainRole);
                    //mainRole.stop();
                    //console.debug("[GameScene]_private.stopAction stop1");
                }
            }
            else {
                _private.stopSprite(mainRole);
                //mainRole.stop();
                //console.debug("[GameScene]_private.stopAction stop2");
            }

            mainRole.nActionType = 0;
        }


        /*function buttonMenuClicked() {
            console.debug("[GameScene]buttonMenuClicked");


            game.window(1);

        }*/

        function buttonAClicked() {
            console.debug("[GameScene]buttonAClicked");


            //计算是否触发地图事件

            //人物面向的有效矩形
            let usePos = Qt.rect(0,0,0,0);

            //可以触发事件的最远距离
            let maxDistance;

            //人物方向
            switch(mainRole.stopDirection) {
            case Qt.Key_Up:
                maxDistance = sizeMapBlockSize.height / 3;
                usePos = Qt.rect(mainRole.x + mainRole.x1, mainRole.y + mainRole.y1 - maxDistance, mainRole.width1, maxDistance);
                break;
            case Qt.Key_Right:
                maxDistance = sizeMapBlockSize.width / 3;
                usePos = Qt.rect(mainRole.x + mainRole.x2, mainRole.y + mainRole.y1, maxDistance, mainRole.height1);
                break;
            case Qt.Key_Down:
                maxDistance = sizeMapBlockSize.height / 3;
                usePos = Qt.rect(mainRole.x + mainRole.x1, mainRole.y + mainRole.y2, mainRole.width1, maxDistance);
                break;
            case Qt.Key_Left:
                maxDistance = sizeMapBlockSize.width / 3;
                usePos = Qt.rect(mainRole.x + mainRole.x1 - maxDistance, mainRole.y + mainRole.y1, maxDistance, mainRole.height1);
                break;
            default:
                return;
            }

            //计算人物所占的地图块
            let usedMapBlocks = _private.fComputeUseBlocks(usePos.x, usePos.y, usePos.x + usePos.width, usePos.y + usePos.height);


            let mainRoleUseBlocks = [];

            for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
                for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
                    mainRoleUseBlocks.push(xb + yb * itemContainer.mapInfo.MapSize[0]);
                }
            }

            //console.debug("人物占用图块：", usedMapBlocks,mainRoleUseBlocks)

            //循环地图事件（优先）
            for(let event in itemContainer.mapEventBlocks) {
                //console.debug("[GameScene]检测事件：", event, mainRoleUseBlocks);
                if(mainRoleUseBlocks.indexOf(parseInt(event)) > -1) {  //如果事件触发
                    //console.debug("[GameScene]gameEvent触发:", event, mainRoleUseBlocks, itemContainer.mapEventBlocks[event]);    //触发
                    itemContainer.gameEvent(itemContainer.mapEventBlocks[event]);   //触发事件
                    return; //!!只执行一次事件
                }
                //console.debug("event:", event, mainRoleUseBlocks, mainRoleUseBlocks.indexOf(event), typeof(event), typeof(itemContainer.mapInfo.events[0]), typeof(mainRoleUseBlocks[0]))
            }

            //循环NPC
            for(let r in objRoles) {
                if(GlobalLibraryJS.checkRectangleClashed(
                    usePos,
                    Qt.rect(objRoles[r].x + objRoles[r].x1, objRoles[r].y + objRoles[r].y1, objRoles[r].width1, objRoles[r].height1),
                    0
                )) {
                    console.debug("[GameScene]触发NPC事件：", objRoles[r].$name);

                    //获得脚本（地图脚本优先级 > game.f定义的）
                    let tScript = itemContainer.mapInfo.$$Script[objRoles[r].$name];
                    if(!tScript)
                        tScript = game.f[objRoles[r].$name];
                    if(tScript) {
                        game.run([tScript, objRoles[r].$name], objRoles[r]);
                        //GlobalJS.runScript(_private.asyncScript, 0, "game.f['%1']()".arg(objRoles[r].$name));

                        return; //!!只执行一次事件
                    }
                }
            }
        }


        //开始播放某个方向的精灵
        function startSprite(role, key) {
            role.moveDirection = key; //移动方向
            role.start();
        }
        //停止播放
        function stopSprite(role) {
            //role.moveDirection = -1;
            role.stop();
        }

        //某角色是否在移动
        function getSpritePlay(role) {
            return role.sprite.running;
            //或者 role.moveDirection === -1;  //
        }



        //计算 占用的图块
        function fComputeUseBlocks(x1, y1, x2, y2) {

            //let blocks = [];    //人物所占用地图块 列表

            //人物所占 起始和终止 的地图块ID，然后按序统计出来地图块
            ////+1、-1 是因为 小于等于图块 时，只占用1个图块
            let xBlock1 = Math.floor((x1) / sizeMapBlockSize.width);
            let xBlock2 = Math.floor((x2) / sizeMapBlockSize.width);
            let yBlock1 = Math.floor((y1) / sizeMapBlockSize.height);
            let yBlock2 = Math.floor((y2) / sizeMapBlockSize.height);

            /*/计算 所占的 地图块
            for(; yBlock1 <= yBlock2; ++yBlock1) {
                for(let xb = xBlock1; xb <= xBlock2; xb ++) {
                    blocks.push(xb + yBlock1 * itemContainer.mapInfo.MapSize[0])
                }
            }
            return blocks;*/

            return [xBlock1, yBlock1, xBlock2, yBlock2];
        }


        //计算 role 在 moveDirection 方向 在 offsetMove 距离中碰到障碍的距离
        //  障碍算法：从direction方向依次循环每个地图块，如果遇到障碍就返回距离（肯定是最近）
        function fComputeRoleMoveToObstacleOffset(role, direction, offsetMove) {

            if(offsetMove <= 0)
                return 0;

            let computeOver = false;//是否计算完毕（遇到图块就停止）
            //计算移动后占用图块
            let usedMapBlocks;


            //计算障碍距离（值为按键值）
            switch(direction) {
            case Qt.Key_Left:

                //如果超过地图左，则返回到左边的距离
                if(role.x + role.x1 - offsetMove < 0)
                    offsetMove = role.x + role.x1;

                usedMapBlocks = _private.fComputeUseBlocks(role.x + role.x1 - offsetMove, role.y + role.y1, role.x + role.x1, role.y + role.y2);

                //console.debug("usedMapBlocks:", usedMapBlocks);

                //从上到下，从右到左（由近到远） 检测障碍
                for(let xb = usedMapBlocks[2]; usedMapBlocks[0] <= xb; --xb) {
                    for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
                        let strP = [xb, yb].toString();

                        //console.debug("检测障碍：", strP, itemContainer.mapInfo.MapBlockSpecialData)
                        //存在特殊图块
                        if(itemContainer.mapInfo.MapBlockSpecialData[strP] !== undefined) {
                            switch(itemContainer.mapInfo.MapBlockSpecialData[strP]) {
                            //!!!这里需要修改
                            //障碍
                            case -1:
                                //计算离障碍距离
                                offsetMove = (role.x + role.x1) - (xb + 1) * sizeMapBlockSize.width;    //计算人物与障碍距离
                                computeOver = true;
                                break;
                            default:
                                continue;
                            }
                            if(computeOver)
                                break;
                        }
                    }
                    if(computeOver)
                        break;
                }
                break;

            case Qt.Key_Right:

                //如果超过地图右，则返回到右边的距离
                if(role.x + role.x2 + offsetMove >= itemContainer.width)
                    offsetMove = itemContainer.width - (role.x + role.x2) - 1;

                usedMapBlocks = _private.fComputeUseBlocks(role.x + role.x2, role.y + role.y1, role.x + role.x2 + offsetMove, role.y + role.y2);

                //console.debug("usedMapBlocks:", usedMapBlocks);
                //从上到下，从左到右
                for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
                    for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
                        let strP = [xb, yb].toString();

                        //console.debug("检测障碍：", strP, itemContainer.mapInfo.MapBlockSpecialData)
                        //存在障碍
                        if(itemContainer.mapInfo.MapBlockSpecialData[strP] !== undefined) {
                            switch(itemContainer.mapInfo.MapBlockSpecialData[strP]) {
                                //!!!这里需要修改
                            case -1:
                                offsetMove = (xb) * sizeMapBlockSize.width - (role.x + role.x2) - 1;    //计算人物与障碍距离
                                computeOver = true;
                                break;
                            default:
                                continue;
                            }
                            if(computeOver)
                                break;
                        }
                    }
                    if(computeOver)
                        break;
                }
                break;

            case Qt.Key_Up: //同Left

                //如果超过地图上，则返回到上边的距离
                if(role.y + role.y1 - offsetMove < 0)
                    offsetMove = role.y + role.y1;

                usedMapBlocks = _private.fComputeUseBlocks(role.x + role.x1, role.y + role.y1 - offsetMove, role.x + role.x2, role.y + role.y1);

                //console.debug("usedMapBlocks:", usedMapBlocks);
                //从左到右，从下到上
                for(let yb = usedMapBlocks[3]; yb >= usedMapBlocks[1]; --yb) {
                    for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
                        let strP = [xb, yb].toString();

                        //console.debug("检测障碍：", strP, itemContainer.mapInfo.MapBlockSpecialData)
                        //存在障碍
                        if(itemContainer.mapInfo.MapBlockSpecialData[strP] !== undefined) {
                            switch(itemContainer.mapInfo.MapBlockSpecialData[strP]) {
                                //!!!这里需要修改
                            case -1:
                                offsetMove = (role.y + role.y1) - (yb + 1) * sizeMapBlockSize.height;    //计算人物与障碍距离
                                computeOver = true;
                                break;
                            default:
                                continue;
                            }
                            if(computeOver)
                                break;
                        }
                    }
                    if(computeOver)
                        break;
                }
                break;

            case Qt.Key_Down:   //同Right

                //如果超过地图下，则返回到下边的距离
                if(role.y + role.y2 + offsetMove >= itemContainer.height)
                    offsetMove = itemContainer.height - (role.y + role.y2) - 1;

                usedMapBlocks = _private.fComputeUseBlocks(role.x + role.x1, role.y + role.y2, role.x + role.x2, role.y + role.y2 + offsetMove);

                //console.debug("usedMapBlocks:", usedMapBlocks);
                //从左到右，从上到下
                for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
                    for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
                        let strP = [xb, yb].toString();

                        //console.debug("检测障碍：", strP, itemContainer.mapInfo.MapBlockSpecialData)
                        //存在障碍
                        if(itemContainer.mapInfo.MapBlockSpecialData[strP] !== undefined) {
                            switch(itemContainer.mapInfo.MapBlockSpecialData[strP]) {
                                //!!!这里需要修改
                            case -1:
                                offsetMove = (yb) * sizeMapBlockSize.height - (role.y + role.y2) - 1;    //计算人物与障碍距离
                                computeOver = true;
                                break;
                            default:
                                continue;
                            }
                            if(computeOver)
                                break;
                        }
                    }
                    if(computeOver)
                        break;
                }
                break;

            default:
                return;
            }

            return offsetMove;
        }

        //计算 role 在 direction 方向 在 offsetMove 距离中碰到其他roles的距离
        function fComputeRoleMoveToRolesOffset(role, direction, offsetMove) {

            if(offsetMove <= 0)
                return 0;

            switch(direction) {
            case Qt.Key_Left:

                //与其他角色碰撞
                for(let r in objRoles) {
                    //跳过自身
                    if(role === objRoles[r])
                        continue;
                    //跳过没有大小的
                    //if(objRoles[r].width1 === 0 || objRoles[r].height1 === 0)
                    //    continue;

                    if(
                        (role.penetrate === 0 && objRoles[r].penetrate === 0) &&
                        GlobalLibraryJS.checkRectangleClashed(
                            Qt.rect(role.x + role.x1 - offsetMove, role.y + role.y1, offsetMove, role.height1),
                            Qt.rect(objRoles[r].x + objRoles[r].x1, objRoles[r].y + objRoles[r].y1, objRoles[r].width1, objRoles[r].height1),
                    ))
                        offsetMove = (role.x + role.x1) - (objRoles[r].x + objRoles[r].x2) - 1;
                }
                //与主角碰撞
                for(let r in arrMainRoles) {
                    //跳过自身
                    if(role === arrMainRoles[r])
                        continue;
                    //跳过没有大小的
                    //if(arrMainRoles[r].width1 === 0 || arrMainRoles[r].height1 === 0)
                    //    continue;

                    if(
                        (role.penetrate === 0 && arrMainRoles[r].penetrate === 0) &&
                        GlobalLibraryJS.checkRectangleClashed(
                            Qt.rect(role.x + role.x1 - offsetMove, role.y + role.y1, offsetMove, role.height1),
                            Qt.rect(arrMainRoles[r].x + arrMainRoles[r].x1, arrMainRoles[r].y + arrMainRoles[r].y1, arrMainRoles[r].width1, arrMainRoles[r].height1),
                    ))
                        offsetMove = (role.x + role.x1) - (arrMainRoles[r].x + arrMainRoles[r].x2) - 1;
                }

                return offsetMove;

                break;

            case Qt.Key_Right:

                for(let r in objRoles) {
                    //跳过自身
                    if(role === objRoles[r])
                        continue;
                    //跳过没有大小的
                    //if(objRoles[r].width1 === 0 || objRoles[r].height1 === 0)
                    //    continue;

                    if(
                        (role.penetrate === 0 && objRoles[r].penetrate === 0) &&
                        GlobalLibraryJS.checkRectangleClashed(
                            Qt.rect(role.x + role.x2 + 1, role.y + role.y1, offsetMove, role.height1),
                            Qt.rect(objRoles[r].x + objRoles[r].x1, objRoles[r].y + objRoles[r].y1, objRoles[r].width1, objRoles[r].height1),
                    ))
                        offsetMove = (objRoles[r].x + objRoles[r].x1) - (role.x + role.x2) - 1;
                }
                for(let r in arrMainRoles) {
                    //跳过自身
                    if(role === arrMainRoles[r])
                        continue;
                    //跳过没有大小的
                    //if(arrMainRoles[r].width1 === 0 || arrMainRoles[r].height1 === 0)
                    //    continue;

                    if(
                        (role.penetrate === 0 && arrMainRoles[r].penetrate === 0) &&
                        GlobalLibraryJS.checkRectangleClashed(
                            Qt.rect(role.x + role.x2 + 1, role.y + role.y1, offsetMove, role.height1),
                            Qt.rect(arrMainRoles[r].x + arrMainRoles[r].x1, arrMainRoles[r].y + arrMainRoles[r].y1, arrMainRoles[r].width1, arrMainRoles[r].height1),
                    ))
                        offsetMove = (arrMainRoles[r].x + arrMainRoles[r].x1) - (role.x + role.x2) - 1;
                }

                return offsetMove;

                break;

            case Qt.Key_Up: //同Left

                for(let r in objRoles) {
                    //跳过自身
                    if(role === objRoles[r])
                        continue;
                    //跳过没有大小的
                    //if(objRoles[r].width1 === 0 || objRoles[r].height1 === 0)
                    //    continue;

                    if(
                        (role.penetrate === 0 && objRoles[r].penetrate === 0) &&
                        GlobalLibraryJS.checkRectangleClashed(
                            Qt.rect(role.x + role.x1, role.y + role.y1 - offsetMove, role.width1, offsetMove),
                            Qt.rect(objRoles[r].x + objRoles[r].x1, objRoles[r].y + objRoles[r].y1, objRoles[r].width1, objRoles[r].height1),
                    ))
                        offsetMove = (role.y + role.y1) - (objRoles[r].y + objRoles[r].y2) - 1;
                }
                for(let r in arrMainRoles) {
                    //跳过自身
                    if(role === arrMainRoles[r])
                        continue;
                    //跳过没有大小的
                    //if(arrMainRoles[r].width1 === 0 || arrMainRoles[r].height1 === 0)
                    //    continue;

                    if(
                        (role.penetrate === 0 && arrMainRoles[r].penetrate === 0) &&
                        GlobalLibraryJS.checkRectangleClashed(
                            Qt.rect(role.x + role.x1, role.y + role.y1 - offsetMove, role.width1, offsetMove),
                            Qt.rect(arrMainRoles[r].x + arrMainRoles[r].x1, arrMainRoles[r].y + arrMainRoles[r].y1, arrMainRoles[r].width1, arrMainRoles[r].height1),
                    ))
                        offsetMove = (role.y + role.y1) - (arrMainRoles[r].y + arrMainRoles[r].y2) - 1;
                }

                return offsetMove;

                break;

            case Qt.Key_Down:   //同Right

                for(let r in objRoles) {
                    //跳过自身
                    if(role === objRoles[r])
                        continue;
                    //跳过没有大小的
                    //if(objRoles[r].width1 === 0 || objRoles[r].height1 === 0)
                    //    continue;

                    if(
                        (role.penetrate === 0 && objRoles[r].penetrate === 0) &&
                        GlobalLibraryJS.checkRectangleClashed(
                            Qt.rect(role.x + role.x1, role.y + role.y2 + 1, role.width1, offsetMove),
                            Qt.rect(objRoles[r].x + objRoles[r].x1, objRoles[r].y + objRoles[r].y1, objRoles[r].width1, objRoles[r].height1),
                    ))
                        offsetMove = (objRoles[r].y + objRoles[r].y1) - (role.y + role.y2) - 1;
                }
                for(let r in arrMainRoles) {
                    //跳过自身
                    if(role === arrMainRoles[r])
                        continue;
                    //跳过没有大小的
                    //if(arrMainRoles[r].width1 === 0 || arrMainRoles[r].height1 === 0)
                    //    continue;

                    if(
                        (role.penetrate === 0 && arrMainRoles[r].penetrate === 0) &&
                        GlobalLibraryJS.checkRectangleClashed(
                            Qt.rect(role.x + role.x1, role.y + role.y2 + 1, role.width1, offsetMove),
                            Qt.rect(arrMainRoles[r].x + arrMainRoles[r].x1, arrMainRoles[r].y + arrMainRoles[r].y1, arrMainRoles[r].width1, arrMainRoles[r].height1),
                    ))
                        offsetMove = (arrMainRoles[r].y + arrMainRoles[r].y1) - (role.y + role.y2) - 1;
                }

                return offsetMove;

                break;

            default:
                //console.warn("[GameScene]fComputeRoleMoveOffset:", direction);
                return;
            }

        }

        //计算 role 在 derect方向 在 offsetMove 距离中最多能移动的距离
        //  Role向direction方向移动offsetMove，如果遇到障碍或其他role，则返回离最近障碍的距离
        function fComputeRoleMoveOffset(role, direction, offsetMove) {

            if(offsetMove <= 0)
                return 0;

            if(role.width1 <= 0 || role.height1 <= 0)
                return offsetMove;

            offsetMove = _private.fComputeRoleMoveToObstacleOffset(role, direction, offsetMove);

            if(offsetMove <= 0)
                return 0;

            offsetMove = _private.fComputeRoleMoveToRolesOffset(role, direction, offsetMove);

            return offsetMove;
        }



        //???
        function fChangeMainRoleDirection() {
            return;

            console.debug("！！碰墙返回", mainRole.moveDirection);
            if(mainRole.$props.$tmpDirection !== undefined) {
                _private.startSprite(mainRole, mainRole.$props.$tmpDirection);
                delete mainRole.$props.$tmpDirection;
                return;
            }

            //人物的占位最中央 所在地图的坐标
            let bx = Math.floor((mainRole.x + mainRole.x1 + mainRole.width1 / 2) / sizeMapBlockSize.width);
            let by = Math.floor((mainRole.y + mainRole.y1 + mainRole.height1 / 2) / sizeMapBlockSize.height);

            switch(mainRole.moveDirection) {
            case Qt.Key_Left:
                if(mainRole.x + mainRole.x1 === 0) {
                    return;
                }

                break;

            case Qt.Key_Right:
                if(mainRole.x + mainRole.x2 === itemContainer.width - 1) {
                    return;
                }

                break;

            case Qt.Key_Up:
                if(mainRole.y + mainRole.y1 === 0) {
                    console.debug("！！碰边界返回2")
                    return;
                }

                //左边距离和右边距离
                let toffset1 = (mainRole.x + mainRole.x2) % sizeMapBlockSize.width + 1;
                let toffset2 = sizeMapBlockSize.width - (mainRole.x + mainRole.x1) % sizeMapBlockSize.width;
                if(toffset1 > sizeMapBlockSize.width / 3 && toffset2 > sizeMapBlockSize.width / 3 ) {
                    //_private.startSprite(mainRole, Qt.Key_Up);
                    console.debug("！！不能转方向返回")
                    return;
                }
                if(toffset1 < toffset2) {
                    if(toffset1 < _private.fComputeRoleMoveOffset(mainRole, Qt.Key_Left, toffset1)) {
                        console.debug("！！左有障碍返回")
                        return;
                    }

                    console.debug("！！转方向Left", mainRole.moveDirection, Qt.Key_Left)
                    mainRole.$props.$tmpDirection = mainRole.moveDirection;
                    _private.startSprite(mainRole, Qt.Key_Left);
                    if(offsetMove > toffset1)
                        offsetMove = toffset1;
                }
                else {
                    if(toffset2 < _private.fComputeRoleMoveOffset(mainRole, Qt.Key_Right, toffset2)) {
                        console.debug("！！右有障碍返回")
                        return;
                    }

                    console.debug("！！转方向Right", mainRole.moveDirection, Qt.Key_Right)
                    mainRole.$props.$tmpDirection = mainRole.moveDirection;
                    _private.startSprite(mainRole, Qt.Key_Right);
                    if(offsetMove > toffset2)
                        offsetMove = toffset2;
                }

                break;

            case Qt.Key_Down:
                if(mainRole.y + mainRole.y2 === itemContainer.height - 1)
                    return offsetMove;

                break;

            }

            return offsetMove;
        }



        function exitGame() {

            dialogCommon.show({
                Msg: '确认退出游戏？',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function(){
                    if(!bTest)
                        game.save("");  //存档

                    let err;
                    try {
                        release();
                    }
                    catch(e) {
                        err = e;
                    }

                    s_close();

                    FrameManager.sl_qml_clearComponentCache();
                    //FrameManager.sl_qml_trimComponentCache();

                    console.debug("[GameScene]Close");

                    if(err) {
                        console.warn("游戏没有正常退出，但并不碍事");
                        throw err;
                    }
                },
                OnRejected: ()=>{
                    rootGameScene.forceActiveFocus();
                },
            });
        }



        //清空canvas
        function clearCanvas(canvas) {
            let ctx = canvas.getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height);
        }




    }



    Component {
        id: compButtons


        GameButton {
            id: tGameButton


            property Image image: Image {
                parent: tGameButton
                anchors.fill: parent
            }


            anchors.right: parent.right
            anchors.bottom: parent.bottom

            anchors.rightMargin: 16 * Screen.pixelDensity
            anchors.bottomMargin: 8 * Screen.pixelDensity

            //anchors.verticalCenterOffset: -100
            //anchors.horizontalCenterOffset: -100

            width: 6 * Screen.pixelDensity
            height: 6 * Screen.pixelDensity


            color: 'white'
        }

    }


    Component {
        id: compRole

        Role {
            id: rootRole

            property Message message: Message {
                parent: rootRole
                visible: false
                enabled: false
                width: parent.width
                height: parent.height * 0.2
                anchors.bottom: rootRole.textName.top
                anchors.horizontalCenter: parent.horizontalCenter

                nMaxHeight: 32

                onS_over: {
                    visible = false;
                }
            }

            property Text textName: Text {
                parent: rootRole
                visible: true
                width: parent.width
                height: implicitHeight
                anchors.bottom: parent.top
                anchors.horizontalCenter: parent.horizontalCenter

                color: "white"

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pointSize: 9
                font.bold: true
                text: $name
                wrapMode: Text.NoWrap
            }

            //属性
            property int $index: -1
            property string $name: ''
            property string $avatar: ''
            property size $avatarSize: Qt.size(0, 0)

            //保存上个Interval碰撞的角色名（包含主角）
            property var $$collideRoles: ({})

            //其他属性（用户自定义）
            property var $props: ({})

            //依附在角色上的图片和特效
            property var $components: []


            //在场景中的坐标
            readonly property int sceneX: x + itemContainer.x
            readonly property int sceneY: y + itemContainer.y


            //行动类别；
            //0为停止；1为缓慢走；2为动向移动
            property int nActionType: 1

            property point targetPos: Qt.point(-1,-1)

            //状态持续时间
            property int nActionStatusKeepTime: 0


            z: y + y1

            //x、y是 图片 在 地图 中的坐标；
            //占位坐标：x + x1；y + y1
            //在 场景 中的 占位坐标：x + x1 + itemContainer.x
            //x: 180
            //y: 100
            //width: 50
            //height: 100

            //spriteSrc: "./Role2.png"
            //sizeFrame: Qt.size(32, 48)
            //nFrameCount: 4
            //arrFrameDirectionIndex: [[0,3],[0,2],[0,0],[0,1]]

            mouseArea.onClicked: {
                console.debug("[GameScene]触发NPC事件：", $name);

                let eventName = `$${$name}_click`;
                //获得脚本（地图脚本优先级 > game.f定义的）
                let tScript = itemContainer.mapInfo.$$Script[eventName];
                if(!tScript)
                    tScript = game.f[eventName];
                if(!tScript)
                    tScript = game.gf[eventName];
                if(tScript) {
                    game.run([tScript, $name], rootRole);
                    //GlobalJS.runScript(_private.asyncScript, 0, "game.f['%1']()".arg(objRoles[r].$name));

                    return; //!!只执行一次事件
                }
                else {
                    mouse.accepted = false;
                }
            }


            Component.onCompleted: {
                //console.debug("[GameScene]Role Component.onCompleted");
            }
        }

    }

    Component {
        id: compCacheSoundEffect
        SoundEffect {
        }
    }
    Component {
        id: compCacheImage
        //Image {
        AnimatedImage {
            //id号
            property var id

            //回调函数
            property var clicked
            property var doubleClicked

            visible: false

            MouseArea {
                anchors.fill: parent
                enabled: true;
                onClicked: {
                    //console.debug('clicked: parent.id', parent.id)
                    if(parent.clicked)
                        game.run(parent.clicked, -1, parent);
                }

                onDoubleClicked: {
                    //game.delimage(parent.id);
                    if(parent.doubleClicked)
                        game.run(parent.doubleClicked, -1, parent);
                }
            }
        }
    }
    Component {
        id: compCacheSpriteEffect
        SpriteEffect {
            //id号
            property var id

            property bool bUsing: false

            //回调函数
            property var clicked
            property var doubleClicked
            property var looped
            property var finished

            //visible: false

            MouseArea {
                anchors.fill: parent
                enabled: true;
                onClicked: {
                    //console.debug('clicked: parent.id', parent.id)
                    if(parent.clicked)
                        game.run(parent.clicked, -1, parent);
                }

                onDoubleClicked: {
                    //game.delimage(parent.id);
                    if(parent.doubleClicked)
                        game.run(parent.doubleClicked, -1, parent);
                }
            }

            onS_looped: {
                //console.debug('clicked: parent.id', parent.id)
                if(looped)
                    game.run(looped, -1, this);
            }

            onS_finished: {
                //game.delimage(parent.id);
                if(finished)
                    game.run(finished, -1, this);
            }
        }
    }
    Component {
        id: compCacheWordMove
        WordMove {
            //visible: true
        }
    }



    Connections {
        target: Qt.application
        function onStateChanged() {
            switch(Qt.application.state){
            case Qt.ApplicationActive:   //每次窗口激活时触发
                _private.keys = {};
                //mainRole.moveDirection = -1;

                itemBackgroundMusic.resume('$sys_inactive');
                --rootGameScene._private.config.nSoundConfig;

                break;
            case Qt.ApplicationInactive:    //每次窗口非激活时触发
                _private.keys = {};
                //mainRole.moveDirection = -1;

                itemBackgroundMusic.pause('$sys_inactive');
                ++rootGameScene._private.config.nSoundConfig;

                break;
            case Qt.ApplicationSuspended:   //程序挂起（比如安卓的后台运行、息屏）
                _private.keys = {};
                //mainRole.moveDirection = -1;
                //itemBackgroundMusic.pause();
                break;
            case Qt.ApplicationHidden:
                _private.keys = {};
                //mainRole.moveDirection = -1;
                //itemBackgroundMusic.pause();
                break;
            }
        }
    }


    Component.onCompleted: {

        //console.debug("[GameScene]globalObject：", FrameManager.globalObject().game);
        FrameManager.globalObject().game = game;
        //FrameManager.globalObject().g = g;
        //console.debug("[GameScene]globalObject：", FrameManager.globalObject().game);

        console.debug("[GameScene]Component.onCompleted");
    }

    Component.onDestruction: {
        //release();

        console.debug("[GameScene]Component.onDestruction");
    }
}
