import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.0
import QtMultimedia 5.14
import Qt.labs.settings 1.1


//引入Qt定义的类
import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0

//import LGlobal 1.0


import "qrc:/QML"


import "GameMakerGlobal.js" as GameMakerGlobalJS

import "GameScene.js" as GameSceneJS
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
    game.gd["$sys_main_roles"]: 当前主角列表，保存了主角属性（{$rid、$id、$name、$index、$showName、$scale、$speed、$avatar、$avatarSize、$x、$y 等}）
    game.gd["$sys_music"]: 当前播放的音乐名
    game.gd["$sys_sound"]: 从右到左：音乐、音效 播放状态
    game.gd["$sys_scale"]: 当前缩放大小
    game.gd["$sys_random_fight"]：随机战斗

    _private.objCommonScripts["game_init"] = tCommoncript.$gameInit;
    _private.objCommonScripts["before_save"] = tCommoncript.$beforeSave;
    _private.objCommonScripts["before_load"] = tCommoncript.$beforeLoad;
    _private.objCommonScripts["after_save"] = tCommoncript.$afterSave;
    _private.objCommonScripts["after_load"] = tCommoncript.$afterLoad;
    _private.objCommonScripts["combatant_class"] = tCommoncript.$Combatant;
    _private.objCommonScripts["refresh_combatant"] = tCommoncript.$refreshCombatant;
    _private.objCommonScripts["check_all_combatants"] = tCommoncript.$checkAllCombatants;
    _private.objCommonScripts["fight_skill_algorithm"]：战斗算法
    _private.objCommonScripts["fight_role_choice_skills_or_goods_algorithm"]：战斗人物选择技能或物品算法
    _private.objCommonScripts["game_over_script"];   //游戏结束脚本
    _private.objCommonScripts["common_run_away_algorithm"]：逃跑算法
    _private.objCommonScripts["fight_start_script"]：战斗开始通用脚本
    _private.objCommonScripts["fight_round_script"]：战斗回合通用脚本
    _private.objCommonScripts["fight_end_script"]：战斗结束通用脚本（升级经验、获得金钱）
    _private.objCommonScripts["fight_combatant_position_algorithm"]：//获取 某战斗角色 中心位置
    _private.objCommonScripts["fight_combatant_melee_position_algorithm"]：//战斗角色近战 坐标
    _private.objCommonScripts["fight_skill_melee_position_algorithm"]//特效在战斗角色的 坐标
    _private.objCommonScripts["fight_combatant_set_choice"] //设置 战斗人物的 初始化 或 休息
    _private.objCommonScripts["fight_menus"]//战斗菜单
    //_private.objCommonScripts["resume_event_script"]
    //_private.objCommonScripts["get_goods_script"]
    //_private.objCommonScripts["use_goods_script"]
    _private.objCommonScripts["equip_reserved_slots"] //装备预留槽位
    _private.objCommonScripts["fight_roles_round"]   //一个大回合内 每次返回一个战斗人物的回合
    _private.objCommonScripts["combatant_info"]
    _private.objCommonScripts["show_goods_name"]
    _private.objCommonScripts["show_combatant_name"]
    _private.objCommonScripts["common_check_skill"]
    _private.objCommonScripts["combatant_round_script"]
    //_private.objCommonScripts["events"]


    //_private.objCommonScripts["levelup_script"]：升级脚本（经验等条件达到后升级和结果）
    //_private.objCommonScripts["level_Algorithm"]：升级算法（直接升级对经验等条件的影响）

*/



Rectangle {

    id: rootGameScene


    //关闭退出
    signal s_close();


    //property alias g: rootGameScene.game
    property QtObject game: QtObject {

        //载入地图并执行地图载入事件；成功返回true。
        readonly property var loadmap: function(mapName, forceRepaint=false) {
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

            mainRole.$$collideRoles = {};
            mainRole.$$mapEventsTriggering = {};
            _private.stopAction(1, -1);


            let mapInfo = openMap(mapName, forceRepaint);

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
        //keeptime：如果为-1，表示点击后对话框会立即显示全部，为0表示等待显示完毕，为>0表示显示完毕后再延时KeepTime毫秒然后自动消失；
        //style为样式；
        //  （如果为数字，则表示自适应宽高（0b1为宽，0b10为高），否则固定大小；
        //  如果为对象，则可以修改BackgroundColor、BorderColor、FontSize、FontColor、MaskColor、Type）；
        //      分别表示 背景色、边框色、字体颜色、字体大小、遮盖色、自适应类型、持续时间；
        //pauseGame为是否暂停游戏（建议true），如果为false，尽量不要用yield关键字；
        //buttonNum为按钮数量（0-2，目前没用）。
        readonly property var msg: function(msg='', interval=20, pretext='', keeptime=0, style={Type: 0b10}, pauseGame=true, buttonNum=0, callback=true) {

            //样式
            if(style === undefined || style === null)
                style = {};
            else if(GlobalLibraryJS.isValidNumber(style))
                style = {Type: style};


            //按钮数
            buttonNum = parseInt(buttonNum);

            /*if(buttonNum === 1)
                loaderGameMsg.standardButtons = Dialog.Ok;
            else if(buttonNum === 2)
                loaderGameMsg.standardButtons = Dialog.Ok | Dialog.Cancel;
            else
                loaderGameMsg.standardButtons = Dialog.NoButton;
            */


            //是否暂停游戏
            if(pauseGame) {
                //loaderGameMsg.bPauseGame = true;
                game.pause('$msg');

                //loaderGameMsg.focus = true;
            }
            else {
                //loaderGameMsg.bPauseGame = false;
            }


            //回调函数
            if(callback === true) {
                callback = function(code, itemMsg) {
                    itemMsg.visible = false;

                    if(_private.config.objPauseNames['$msg'] !== undefined) {
                        //如果没有使用yield来中断代码，可以不要game.run()
                        game.goon('$msg');
                        game.run(true);
                        //_private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                    }
                }
            }
            loaderGameMsg.item.callback = callback;


            loaderGameMsg.item.show(msg.toString(), pretext.toString(), interval, keeptime, style);


            return true;
        }

        //在屏幕下方显示信息。
        //interval为文字显示间隔，为0则不使用；
        //pretext为已显示的文字（role为空的情况下）；
        //keeptime：如果为-1，表示点击后对话框会立即显示全部，为0表示等待显示完毕，为>0表示显示完毕后再延时KeepTime然后自动消失；
        //style为样式；
        //  如果为对象，则可以修改BackgroundColor、BorderColor、FontSize、FontColor、MaskColor、Name、Avatar）；
        //      分别表示 背景色、边框色、字体颜色、字体大小、遮盖色、自适应类型、持续时间、是否显示名字、是否显示头像；
        //pauseGame为是否暂停游戏（建议true），如果为false，尽量不要用yield关键字；
        readonly property var talk: function(role, msg='', interval=20, pretext='', keeptime=0, style=null, pauseGame=true, callback=true) {
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
                style = {};


            //是否暂停游戏
            if(pauseGame) {
                game.pause('$talk');

                //loaderGameMsg.focus = true;
            }
            else {
            }


            let bShowName = GlobalLibraryJS.shortCircuit(0b1, style.Name, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$talk', '$name'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$styles', '$talk', '$name'));
            let bShowAvatar = GlobalLibraryJS.shortCircuit(0b1, style.Avatar, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$talk', '$avatar'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$styles', '$talk', '$avatar'));
            if(role !== null) {
                if(role.$data.$name && bShowName)
                    pretext = role.$data.$name + "：" + pretext;
                if(role.$data.$avatar && bShowAvatar)
                    pretext = GlobalLibraryJS.showRichTextImage(game.$global.toURL(game.$gameMakerGlobal.imageResourceURL(role.$data.$avatar)), role.$data.$avatarSize[0], role.$data.$avatarSize[1]) + pretext;
            }


            //回调函数
            if(callback === true) {
                callback = function(code, itemMsg) {
                    itemMsg.visible = false;

                    if(_private.config.objPauseNames['$talk'] !== undefined) {
                        //如果没有使用yield来中断代码，可以不要game.run()
                        game.goon('$talk');
                        game.run(true);
                        //_private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                    }
                }
            }
            itemRootRoleMsg.callback = callback;


            itemRootRoleMsg.show(msg.toString(), pretext.toString(), interval, keeptime, style);


            return true;
        }

        //人物头顶显示信息。
        //interval为文字显示间隔，为0则不使用；
        //pretext为已显示的文字（role为空的情况下）；
        //keeptime：如果为-1，表示点击后对话框会立即显示全部，为0表示等待显示完毕，为>0表示显示完毕后再延时KeepTime然后自动消失；
        //style为样式；
        //  如果为对象，则可以修改BackgroundColor、BorderColor、FontSize、FontColor、MaskColor）；
        //      分别表示 背景色、边框色、字体颜色、字体大小、遮盖色、自适应类型、持续时间；
        //pauseGame为是否暂停游戏（建议true），如果为false，尽量不要用yield关键字；
        readonly property var say: function(role, msg, interval=60, pretext='', keeptime=1000, style={}) {
            if(!role)
                return false;

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
            let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$say') || {};
            let styleSystem = game.$gameMakerGlobalJS.$config.$styles.$say;

            role.message.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
            role.message.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
            role.message.textArea.font.pointSize = style.FontSize || styleUser.$fontSize || styleSystem.$fontSize;
            role.message.textArea.font.color = style.FontColor || styleUser.$fontColor || styleSystem.$fontColor;

            //role.message.visible = true;
            role.message.show(GlobalLibraryJS.convertToHTML(msg.toString()), GlobalLibraryJS.convertToHTML(pretext.toString()), interval, keeptime, 0b11);

            return true;
        }


        //显示一个菜单；
        //title为显示文字；
        //items为选项数组；
        //style：样式，包括MaskColor、BorderColor、BackgroundColor、ItemFontSize、ItemFontColor、ItemBackgroundColor1、ItemBackgroundColor2、TitleFontSize、TitleBackgroundColor、TitleFontColor、ItemBorderColor、ItemHeight、TitleHeight；
        //pauseGame是否暂停游戏；
        //返回值为选择的下标（0开始）；
        //注意：该脚本必须用yield才能暂停并接受返回值。
        readonly property var menu: function(title, items, style={}, pauseGame=true, callback=true) {

            if(callback === true) {   //默认回调函数
                callback = function(index, itemMenu) {
                    //gameMap.focus = true;

                    itemMenu.visible = false;
                    //menuGame.hide();

                    if(_private.config.objPauseNames['$menu' + itemMenu.nIndex] !== undefined) {
                        //如果没有使用yield来中断代码，可以不要game.run()
                        game.goon('$menu' + itemMenu.nIndex);
                        game.run(true, {Value: index});
                        //_private.asyncScript.run(index);
                    }



                    itemMenu.destroy();
                    //FrameManager.goon();
                    //console.debug("!!!asyncScript.run", index);
                }
            }

            let itemMenu = compGameMenu.createObject(itemGameMenus, {nIndex: itemGameMenus.nIndex, callback: callback});
            let maskMenu = itemMenu.maskMenu;
            let menuGame = itemMenu.menuGame;

            /*itemMenu.s_Choice.connect(function(index) {
            });*/

            //样式
            if(!style)
                style = {};
            let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$menu') || {};
            let styleSystem = game.$gameMakerGlobalJS.$config.$styles.$menu;

            maskMenu.color = style.MaskColor || styleUser.$maskColor || styleSystem.$maskColor;
            menuGame.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
            menuGame.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
            menuGame.nItemHeight = style.ItemHeight || styleUser.$itemHeight || styleSystem.$itemHeight;
            menuGame.nTitleHeight = style.TitleHeight || styleUser.$titleHeight || styleSystem.$titleHeight;
            menuGame.nItemFontSize = style.ItemFontSize || style.FontSize || styleUser.$itemFontSize || styleSystem.$itemFontSize;
            menuGame.colorItemFontColor = style.ItemFontColor || style.FontColor || styleUser.$itemFontColor || styleSystem.$itemFontColor;
            menuGame.colorItemColor1 = style.ItemBackgroundColor1 || style.BackgroundColor || styleUser.$itemBackgroundColor1 || styleSystem.$itemBackgroundColor1;
            menuGame.colorItemColor2 = style.ItemBackgroundColor2 || style.BackgroundColor || styleUser.$itemBackgroundColor2 || styleSystem.$itemBackgroundColor2;
            menuGame.nTitleFontSize = style.TitleFontSize || style.FontSize || styleUser.$titleFontSize || styleSystem.$titleFontSize;
            menuGame.colorTitleColor = style.TitleBackgroundColor || style.BackgroundColor || styleUser.$titleBackgroundColor || styleSystem.$titleBackgroundColor;
            menuGame.colorTitleFontColor = style.TitleFontColor || style.FontColor || styleUser.$titleFontColor || styleSystem.$titleFontColor;
            menuGame.colorItemBorderColor = style.ItemBorderColor || style.BorderColor || styleUser.$itemBorderColor || styleSystem.$itemBorderColor;


            //是否暂停游戏
            if(pauseGame) {
                game.pause('$menu' + itemGameMenus.nIndex);
            }
            else {
            }



            ++itemGameMenus.nIndex;
            itemMenu.visible = true;
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
        readonly property var input: function(title='', pretext='', style={}, pauseGame=true, callback=true) {

            //样式
            if(style === undefined || style === null)
                style = {};
            let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$input') || {};
            let styleSystem = game.$gameMakerGlobalJS.$config.$styles.$input;


            //是否暂停游戏
            if(pauseGame) {
                game.pause('$input');
            }
            else {
            }



            rectGameInput.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
            rectGameInput.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
            textGameInput.font.pointSize = style.FontSize || styleUser.$fontSize || styleSystem.$fontSize;
            textGameInput.font.color = style.FontColor || styleUser.$fontColor || styleSystem.$fontColor;

            rectGameInputTitle.color = style.TitleBackgroundColor || styleUser.$titleBackgroundColor || styleSystem.$titleBackgroundColor;
            rectGameInputTitle.border.color = style.TitleBorderColor || styleUser.$titleBorderColor || styleSystem.$titleBorderColor;
            textGameInputTitle.font.pointSize = style.TitleFontSize || styleUser.$titleFontSize || styleSystem.$titleFontSize;
            textGameInputTitle.font.color = style.TitleFontColor || styleUser.$titleFontColor || styleSystem.$titleFontColor;

            maskGameInput.color = style.MaskColor || styleUser.$maskColor || styleSystem.$maskColor;


            textGameInputTitle.text = title;
            textGameInput.text = pretext;


            //回调函数
            if(callback === true) {
                callback = function(itemInput) {
                    itemInput.visible = false;

                    if(_private.config.objPauseNames['$input'] !== undefined) {
                        //如果没有使用yield来中断代码，可以不要game.run()
                        game.goon('$input');
                        game.run(true, {Value: textGameInput.text});
                        //_private.asyncScript.run(textGameInput.text);
                    }
                }
            }
            itemRootGameInput.callback = callback;


            itemRootGameInput.visible = true;

        }


        //创建主角；
        //role：角色资源名 或 标准创建格式的对象（RId为角色资源名）。
        //  其他参数：$id、$name、$showName、$scale、$speed、$avatar、$avatarSize、$x、$y、$bx、$by、$direction、$action、$targetBx、$targetBy、$targetX、$targetY、$targetBlocks、$targetPositions、$targetBlockAuto；
        //  $name为游戏显示名；
        //  $action：
        //    为0表示静止；为1表示随机移动；为-1表示禁止操作；
        //    为2表示定向移动；此时（用其中一个即可）：
        //      $targetBx、$targetBy为定向的地图块坐标
        //      $targetX、$targetY为定向的像素坐标；
        //      $targetBlocks：为定向的地图块坐标数组;
        //      $targetPositions为定向的像素坐标数组;
        //      $targetBlockAuto为定向的地图块自动寻路坐标数组；
        //  $direction表示静止方向（0、1、2、3分别表示上右下左）；
        //成功返回 组件对象。
        readonly property var createhero: function(role={}) {
            if(GlobalLibraryJS.isString(role)) {
                role = {RId: role, $id: role, $name: role};
            }
            if(!role.$id) {
                if(role.$name)
                    role.$id = role.$name;
                else
                    role.$id = role.RId + GlobalLibraryJS.randomString(6, 6, '0123456789');
            }
            if(!role.$name) {
                role.$name = role.RId;
            }


            for(let th of _private.arrMainRoles) {
                if(th.$id === role.$id) {
                    console.warn('[!GameScene]已经有主角：', role.$id);
                    return false;
                }
            }

            if(_private.arrMainRoles[0] !== undefined) {
                console.warn('[!GameScene]已经有主角：', role.$id);
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

                game.gd["$sys_main_roles"][index] = {$rid: role.RId, $id: role.$id, $name: role.$name, $index: index, $showName: true, $speed: 0, $scale: [1,1], $avatar: '', $avatarSize: [0, 0], $x: mainRole.x, $y: mainRole.y};

                role = game.gd["$sys_main_roles"][index];

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

            //_private.arrMainRoles[index].$id = role.$id;
            //_private.arrMainRoles[index].$index = index;

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

            mainRole.$type = 1;

            mainRole.refresh();



            mainRole.$data = role;

            //if(role.$direction === undefined)
            //    role.$direction = 2;

            game.hero(index, role);

            //console.debug("[GameScene]createhero：mainRole：", JSON.stringify(cfg));

            return mainRole;
        }

        //返回 主角；
        //hero可以是下标，或主角的$id，或主角对象，-1表示返回所有主角；
        //props：非返回所有主角时，为修改的 单个主角属性，同 createhero 的第二个参数；
        //返回经过props修改的 主角 或 所有主角的列表；如果没有则返回null；
        readonly property var hero: function(hero=-1, props={}) {
            if(hero === -1)
                return _private.arrMainRoles;


            //找到index

            let index = -1;
            if(GlobalLibraryJS.isString(hero)) {
                for(index = 0; index < _private.arrMainRoles.length; ++index) {
                    if(_private.arrMainRoles[index].$data.$id === hero) {
                        break;
                    }
                }
            }
            else if(GlobalLibraryJS.isValidNumber(hero)) {
                index = hero;
            }
            else if(GlobalLibraryJS.isObject(hero)) {
                index = hero.$data.$index;
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
                    hero.$name = heroComp.textName.text = props.$name;
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
                    hero.$avatar/* = heroComp.$avatar*/ = props.$avatar;
                if(props.$avatarSize !== undefined) {  //修改头像
                    hero.$avatarSize[0]/* = heroComp.$avatarSize.width*/ = props.$avatarSize[0];
                    hero.$avatarSize[1]/* = heroComp.$avatarSize.height*/ = props.$avatarSize[1];
                }

                if(props.$action !== undefined)
                    heroComp.nActionType = props.$action;

                //下面都是自动行走
                if(props.$targetBx !== undefined || props.$targetBy !== undefined) {
                    let tPos = getMapBlockPos(props.$targetBx, props.$targetBy);
                    if(props.$targetBx === undefined)
                        tPos[0] = -1;
                    if(props.$targetBy === undefined)
                        tPos[1] = -1;
                    heroComp.targetsPos = [Qt.point(tPos[0], tPos[1])];
                }
                if(props.$targetX !== undefined || props.$targetY !== undefined) {
                    if(props.$targetX === undefined)
                        props.$targetX = -1;
                    if(props.$targetY === undefined)
                        props.$targetY = -1;
                    heroComp.targetsPos = [Qt.point(props.$targetX, props.$targetY)];
                }
                if(GlobalLibraryJS.isArray(props.$targetBlocks) && props.$targetBlocks.length > 0) {
                    heroComp.targetsPos = [];
                    for(let targetBlock of props.$targetBlocks) {
                        let tPos = getMapBlockPos(targetBlock[0], targetBlock[1]);
                        /*if(props.$targetBx === undefined)
                            tPos[0] = -1;
                        if(props.$targetBy === undefined)
                            tPos[1] = -1;
                            */
                        heroComp.targetsPos.push(Qt.point(tPos[0], tPos[1]));
                    }
                }
                if(GlobalLibraryJS.isArray(props.$targetPositions) && props.$targetPositions.length > 0) {
                    heroComp.targetsPos = props.$targetPositions;
                }
                if(GlobalLibraryJS.isArray(props.$targetBlockAuto) && props.$targetBlockAuto.length === 2) {
                    let rolePos = heroComp.pos();
                    heroComp.targetsPos = GameMakerGlobalJS.computePath([rolePos.bx, rolePos.by], [props.$targetBlockAuto[0], props.$targetBlockAuto[1]]);
                }

                if(props.$x !== undefined)   //修改x坐标
                    hero.$x = heroComp.x = props.$x;
                if(props.$y !== undefined)   //修改y坐标
                    hero.$y = heroComp.y = props.$y;
                if(props.$x !== undefined || props.$y !== undefined)
                    if(heroComp === _private.sceneRole)setMapToRole(_private.sceneRole);

                if(props.$bx || props.$by)
                    setMainRolePos(parseInt(props.$bx), parseInt(props.$by), hero.$index);


                if(props.$direction !== undefined)
                    heroComp.changeDirection(props.$direction);
                    /*/貌似必须10ms以上才可以使其转向（鹰：使用AnimatedSprite就不用延时了）
                    GlobalLibraryJS.setTimeout(function() {
                            if(heroComp)
                                heroComp.changeDirection(props.$direction);
                        },20,rootGameScene
                    );*/

            }

            return heroComp;
        }

        //删除主角；
        //hero可以是下标，或主角的$id，或主角对象，-1表示所有主角；
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
                mainRole.$data = null;
                //mainRole.$id = '';
                //mainRole.$name = '';
                //mainRole.$index = -1;
                //mainRole.$avatar = '';
                //mainRole.$avatarSize = Qt.size(0, 0);

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
                    if(_private.arrMainRoles[index].$data.$id === hero) {
                        break;
                    }
                }
            }
            else if(GlobalLibraryJS.isValidNumber(hero))
                index = hero;
            else if(GlobalLibraryJS.isObject(hero)) {
                index = hero.$data.$index;
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
                //_private.arrMainRoles[index].$index = index;
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
        //其他参数：$id、$name、$showName、$scale、$speed、$avatar、$avatarSize、$x、$y、$bx、$by、$direction、$action、$targetBx、$targetBy、$targetX、$targetY、$targetBlocks、$targetPositions、$targetBlockAuto、$start；
        //  $name为游戏显示名；
        //  $action：
        //    为0表示静止；为1表示随机移动；为-1表示禁止操作；
        //    为2表示定向移动；此时（用其中一个即可）：
        //      $targetBx、$targetBy为定向的地图块坐标
        //      $targetX、$targetY为定向的像素坐标；
        //      $targetBlocks：为定向的地图块坐标数组;
        //      $targetPositions为定向的像素坐标数组;
        //      $targetBlockAuto为定向的地图块自动寻路坐标数组；
        //    为-1表示禁止操作；
        //  $direction表示静止方向（0、1、2、3分别表示上右下左）；
        //  $start表示角色是否自动动作（true或false)；
        //成功返回 组件对象。
        readonly property var createrole: function(role={}) {

            if(GlobalLibraryJS.isString(role)) {
                role = {RId: role, $id: role, $name: role};
            }
            if(!role.$id) {
                if(role.$name)
                    role.$id = role.$name;
                else
                    role.$id = role.RId + GlobalLibraryJS.randomString(6, 6, '0123456789');
            }
            if(!role.$name) {
                role.$name = role.RId;
            }

            if(_private.objRoles[role.$id] !== undefined)
                return false;


            let filePath = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + role.RId + GameMakerGlobal.separator + "role.json";
            //let cfg = File.read(filePath);
            let cfg = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));
            //console.debug("[GameScene]createRole：filePath：", filePath);

            if(cfg === '')
                return false;
            cfg = JSON.parse(cfg);


            let roleComp = compRole.createObject(itemRoleContainer);


            roleComp.spriteSrc = Global.toURL(GameMakerGlobal.roleResourceURL(cfg.Image));
            roleComp.sizeFrame = Qt.size(cfg.FrameSize[0], cfg.FrameSize[1]);
            roleComp.nFrameCount = cfg.FrameCount;
            roleComp.arrFrameDirectionIndex = cfg.FrameIndex;
            roleComp.interval = cfg.FrameInterval;
            //roleComp.implicitWidth = cfg.RoleSize[0];
            //roleComp.implicitHeight = cfg.RoleSize[1];
            roleComp.width = cfg.RoleSize[0];
            roleComp.height = cfg.RoleSize[1];
            roleComp.x1 = cfg.RealOffset[0];
            roleComp.y1 = cfg.RealOffset[1];
            roleComp.width1 = cfg.RealSize[0];
            roleComp.height1 = cfg.RealSize[1];
            roleComp.rectShadow.opacity = isNaN(parseFloat(cfg.ShadowOpacity)) ? 0.3 : parseFloat(cfg.ShadowOpacity);
            roleComp.penetrate = isNaN(parseInt(cfg.Penetrate)) ? 0 : parseInt(cfg.Penetrate);

            //roleComp.test = true;

            roleComp.sprite.s_playEffect.connect(rootSoundEffect.playSoundEffect);
            roleComp.actionSprite.s_playEffect.connect(rootSoundEffect.playSoundEffect);



            _private.objRoles[role.$id] = roleComp;

            roleComp.$type = 2;


            roleComp.refresh();


            //roleComp.$id = role.$id;
            roleComp.$data = role;

            //roleComp.$name = role.$name;
            role.$speed = parseFloat(cfg.MoveSpeed);
            role.$scale = [((cfg.Scale && cfg.Scale[0] !== undefined) ? cfg.Scale[0] : 1), ((cfg.Scale && cfg.Scale[1] !== undefined) ? cfg.Scale[1] : 1)];

            role.$avatar = cfg.Avatar || '';
            role.$avatarSize = [((cfg.AvatarSize && cfg.AvatarSize[0] !== undefined) ? cfg.AvatarSize[0] : 0), ((cfg.AvatarSize && cfg.AvatarSize[1] !== undefined) ? cfg.AvatarSize[1] : 0)];

            //if(role.$direction === undefined)
            //    role.$direction = 2;

            game.role(roleComp, role);


            return roleComp;

        }

        //返回 角色；
        //role可以是下标，或角色的$id，或角色对象，-1表示返回所有角色；
        //props：非返回所有角色时，为修改的 单个角色属性，同 createhero 的第二个参数；
        //返回经过props修改的 角色 或 所有角色的列表；如果没有则返回null；
        readonly property var role: function(role=-1, props={}) {
            if(role === -1/* || role === undefined || role === null*/)
                return _private.objRoles;


            let roleComp;

            if(GlobalLibraryJS.isString(role)) {
                roleComp = _private.objRoles[role];
                if(roleComp === undefined)
                    return null;
            }
            else if(GlobalLibraryJS.isValidNumber(role))
                return false;
            else if(GlobalLibraryJS.isObject(role)) {
                roleComp = role;
            }
            else
                return false;


            role = roleComp.$data;


            if(!GlobalLibraryJS.objectIsEmpty(props)) {
                //修改属性
                //GlobalLibraryJS.copyPropertiesToObject(roleComp, props, true);

                //!!!后期想办法把refresh去掉
                //roleComp.refresh();

                if(props.$name !== undefined)   //修改名字
                    role.$name = roleComp.textName.text = props.$name;
                if(props.$showName === true)   //修改名字
                    role.$showName = roleComp.textName.visible = true;
                else if(props.$showName === false)
                    role.$showName = roleComp.textName.visible = false;
                if(props.$speed !== undefined)   //修改速度
                    roleComp.moveSpeed = parseFloat(props.$speed);
                if(props.$scale && props.$scale[0] !== undefined) {
                    roleComp.rXScale = props.$scale[0];
                }
                if(props.$scale && props.$scale[1] !== undefined) {
                    roleComp.rYScale = props.$scale[1];
                }

                //!!!这里要加入名字是否重复
                if(props.$avatar !== undefined)   //修改头像
                    role.$avatar = props.$avatar;
                if(props.$avatarSize !== undefined) {  //修改头像
                    //roleComp.$avatarSize.width = props.$avatarSize[0];
                    //roleComp.$avatarSize.height = props.$avatarSize[1];
                    role.$avatarSize = props.$avatarSize;
                }

                if(props.$action !== undefined)
                    roleComp.nActionType = props.$action;

                if(props.$targetBx !== undefined || props.$targetBy !== undefined) {
                    let tPos = getMapBlockPos(props.$targetBx, props.$targetBy);
                    if(props.$targetBx === undefined)
                        tPos[0] = -1;
                    if(props.$targetBy === undefined)
                        tPos[1] = -1;
                    roleComp.targetsPos = [Qt.point(tPos[0], tPos[1])];
                }
                if(props.$targetX !== undefined || props.$targetY !== undefined) {
                    if(props.$targetX === undefined)
                        props.$targetX = -1;
                    if(props.$targetY === undefined)
                        props.$targetY = -1;
                    roleComp.targetsPos = [Qt.point(props.$targetX, props.$targetY)];
                }
                if(GlobalLibraryJS.isArray(props.$targetBlocks) && props.$targetBlocks.length > 0) {
                    roleComp.targetsPos = [];
                    for(let targetBlock of props.$targetBlocks) {
                        let tPos = getMapBlockPos(targetBlock[0], targetBlock[1]);
                        /*if(props.$targetBx === undefined)
                            tPos[0] = -1;
                        if(props.$targetBy === undefined)
                            tPos[1] = -1;
                            */
                        roleComp.targetsPos.push(Qt.point(tPos[0], tPos[1]));
                    }
                }
                if(GlobalLibraryJS.isArray(props.$targetPositions) && props.$targetPositions.length > 0) {
                    roleComp.targetsPos = props.$targetPositions;
                }
                if(GlobalLibraryJS.isArray(props.$targetBlockAuto) && props.$targetBlockAuto.length === 2) {
                    let rolePos = roleComp.pos();
                    roleComp.targetsPos = GameMakerGlobalJS.computePath([rolePos.bx, rolePos.by], [props.$targetBlockAuto[0], props.$targetBlockAuto[1]]);
                }

                if(props.$x !== undefined)   //修改x坐标
                    roleComp.x = props.$x;
                if(props.$y !== undefined)   //修改y坐标
                    roleComp.y = props.$y;
                if(props.$x !== undefined || props.$y !== undefined)
                    if(roleComp === _private.sceneRole)setMapToRole(_private.sceneRole);

                if(props.$bx !== undefined || props.$by !== undefined)
                    setRolePos(roleComp, props.$bx, props.$by);
                    //moverole(roleComp, bx, by);


                if(props.$direction !== undefined)
                    roleComp.changeDirection(props.$direction);
                    /*/貌似必须10ms以上才可以使其转向（鹰：使用AnimatedSprite就不用延时了）
                    GlobalLibraryJS.setTimeout(function() {
                            if(roleComp)
                                roleComp.changeDirection(props.$direction);
                        },20,rootGameScene
                    );
                    */

                if(props.$realSize !== undefined) {
                    roleComp.width1 = props.$realSize[0];
                    roleComp.height1 = props.$realSize[1];
                    //console.debug('!!!', props.$realSize)
                }


                if(props.$start === true)
                    roleComp.start();
                else if(props.$start === false)
                    roleComp.stop();

            }


            return roleComp;
        }

        //移动角色到bx，by。
        readonly property var moverole: function(role, bx, by) {

            if(GlobalLibraryJS.isString(role)) {
                role = _private.objRoles[role];
                if(role === undefined)
                    return false;
            }


            setRolePos(role, bx, by);

            /*
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
            */


            return true;
        }


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


            delete _private.objRoles[role.$data.$id];

            for(let c of role.$components) {
                if(GlobalLibraryJS.isComponent(c))
                    c.destroy();
            }
            role.destroy();



            return true;
        }



        //角色的影子中心所在的各种坐标；
        //role为角色组件（可用heros和roles命令返回的组件）；
        //  如果为数字或空，则是主角；如果是字符串，则在主角和NPC中查找；
        //pos为[x,y]，如果为空则表示返回角色中心所在各种坐标；
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
            let centerX = role.x + role.x1 + parseInt(role.width1 / 2);
            let centerY = role.y + role.y1 + parseInt(role.height1 / 2);

            if(pos) {
                if(pos[0] === Math.floor(centerX / sizeMapBlockSize.width) && pos[1] === Math.floor(centerY / sizeMapBlockSize.height))
                    return true;
                return false;
            }
            else
                return {bx: Math.floor(centerX / sizeMapBlockSize.width),
                    by: Math.floor(centerY / sizeMapBlockSize.height),
                    x: role.x,
                    y: role.y,
                    cx: centerX,
                    cy: centerY,
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


            let newFightRole = GameSceneJS.getFightRoleObject(fightrole, true);


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
            loaderFightScene.enemies.push(new _private.objCommonScripts["combatant_class"](name));

        }*/

        //返回战斗主角；
        //fighthero为下标，或战斗角色的name，或战斗角色对象，或-1（返回所有战斗主角）；
        //type为0表示返回 对象，为1表示只返回名字（选择框用）；
        //返回null表示没有，false错误；
        readonly property var fighthero: function(fighthero=-1, type=0) {
            if(game.gd["$sys_fight_heros"] === undefined || game.gd["$sys_fight_heros"] === null)
                return false;

            if(fighthero === null || fighthero === undefined)
                fighthero = -1;

            if(fighthero === -1) {
                if(type === 0)
                    return game.gd["$sys_fight_heros"];
                else {  //只返回名字
                    let arrName = [];
                    for(let th of game.gd["$sys_fight_heros"])
                        arrName.push(th.$name);
                    return arrName;
                }
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



            if(type === 0) {
                return fighthero;
            }
            else    //只返回名字
                return fighthero.$name;

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


            skill = GameSceneJS.getSkillObject(skill, copyedNewProps);
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
                    if(GlobalLibraryJS.isString(skill) && tskill.$rid !== skill) {
                        fighthero.$skills.push(tskill);
                        continue;
                    }

                    let bFilterFlag = true;
                    //有筛选
                    if(filters) {
                        //开始筛选
                        for(let tf in filters) {
                            //_private.goodsResource[tg.$rid][filterkey] === filtervalue
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
                    if(GlobalLibraryJS.isString(skill) && tskill.$rid !== skill) {
                        //fighthero.$skills.push(tskill);
                        continue;
                    }


                    let bFilterFlag = true;
                    //有筛选
                    if(filters) {
                        //开始筛选
                        for(let tf in filters) {
                            //_private.goodsResource[tg.$rid][filterkey] === filtervalue
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
        //    支持格式：{HP: 6, HP: [6,6,6], 'HP,2': 6}
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
                _private.objCommonScripts["refresh_combatant"](fighthero);

            return fighthero;
        }

        //背包内 获得 count个道具；返回背包中 改变后 道具个数，返回false表示错误。
        //goods可以为 道具资源名、 或 标准创建格式的对象（带有RId、Params和其他属性），或道具本身（带有$rid），或 下标；
        //count为0表示使用goods内的$count；
        readonly property var getgoods: function(goods, count=0) {

            if(GlobalLibraryJS.isObject(goods)) { //如果直接是对象
                goods = GameSceneJS.getGoodsObject(goods, true);

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
                        if(tg && tg.$rid === goods) {
                            count += tg.$count;
                        }
                    }
                    return count;
                }

                goods = GameSceneJS.getGoodsObject(goods);
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
                if(tg && tg.$rid === goods.$rid && tg.$stackable) {
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
                    if(GlobalLibraryJS.isString(goods) && tg && goods !== tg.$rid)
                        continue;

                    let bFilterFlag = true;
                    //有筛选
                    if(!GlobalLibraryJS.objectIsEmpty(filters)) {
                        //开始筛选
                        for(let tf in filters) {
                            //_private.goodsResource[tg.$rid][filterkey] === filtervalue
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
                goodsInfo = GameSceneJS.getGoodsResource(goods.$rid);
            }
            else if(GlobalLibraryJS.isValidNumber(goods)) { //如果直接是数字
                if(goods < 0 || goods >= game.gd["$sys_goods"].length)
                    return false;

                goods = game.gd["$sys_goods"][goods];
                goodsInfo = GameSceneJS.getGoodsResource(goods.$rid);
            }
            else if(GlobalLibraryJS.isString(goods)) { //如果直接是字符串
                goodsInfo = GameSceneJS.getGoodsResource(goods);
                goods = GameSceneJS.getGoodsObject(goods);
            }
            else
                return false;

            if(!goodsInfo || !goods)
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

            if(fighthero < 0)
                fighthero = null;
            else
                fighthero = game.fighthero(fighthero);
            //if(!fighthero)
            //    return false;


            if(goodsInfo.$commons.$useScript)
                game.run(goodsInfo.$commons.$useScript(goods, fighthero));


            //计算新属性
            let continueScript = function() {
                //计算新属性
                for(let tfh of game.gd["$sys_fight_heros"])
                    _private.objCommonScripts["refresh_combatant"](tfh);
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


            if(!GlobalLibraryJS.isObject(fighthero.$equipment))
                fighthero.$equipment = {};



            goods = GameSceneJS.getGoodsObject(goods, copyedNewProps);
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
                    if(_private.objCommonScripts["equip_reserved_slots"].indexOf(newPosition) !== -1)
                        fighthero.$equipment[newPosition] = undefined;
                    else
                        delete fighthero.$equipment[newPosition];
                    */
                    delete fighthero.$equipment[newPosition];
                }
                else
                    oldEquip.$count = newCount;

                //计算新属性
                _private.objCommonScripts["refresh_combatant"](fighthero);
                //刷新战斗时人物数据
                //loaderFightScene.refreshAllFightRoleInfo();

                return newCount;
            }

            //if(oldEquip === undefined || oldEquip.$rid !== goods) {    //如果原来没有装备
            if(goods.$count > 0) {
                fighthero.$equipment[newPosition] = goods;

                //计算新属性
                _private.objCommonScripts["refresh_combatant"](fighthero);
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


            if(!GlobalLibraryJS.isObject(fighthero.$equipment))
                fighthero.$equipment = {};


            let oldEquip = fighthero.$equipment[positionName];

            /*
            if(_private.objCommonScripts["equip_reserved_slots"].indexOf(positionName) !== -1)
                fighthero.$equipment[positionName] = undefined;
            else
                delete fighthero.$equipment[positionName];
            */
            delete fighthero.$equipment[positionName];


            //计算新属性
            _private.objCommonScripts["refresh_combatant"](fighthero);
            //刷新战斗时人物数据
            //loaderFightScene.refreshAllFightRoleInfo();

            return oldEquip;
        }

        //返回某 fighthero 的装备；如果positionName为null，则返回所有装备的数组；
        //fighthero为下标，或战斗角色的name，或战斗角色对象；
        //返回格式：全部装备的数组 或 某一个位置的装备；
        //错误返回false。
        readonly property var equipment: function(fighthero, positionName=null) {

            if(fighthero < 0)
                return false;

            //找到fighthero
            fighthero = game.fighthero(fighthero);
            if(!fighthero)
                return false;


            if(!GlobalLibraryJS.isObject(fighthero.$equipment))
                fighthero.$equipment = {};


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

                //loaderGameMsg.focus = true;
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

            game.run(function*() {
                let fightHeros = game.fighthero();
                if(fightHeros.length === 0) {
                    game.run(function *(){yield game.msg('没有战斗人物', 10);});
                    return;
                }

                game.pause('$fight');
                //_private.nStage = 1;
                game.stage(1);


                //loaderFightScene.test();
                //loaderFightScene.init(GameSceneJS.getFightScriptObject(fightScript));

                fight.run(loaderFightScene.init, -1, GameSceneJS.getFightScriptObject(fightScript));


                //暂停脚本，直到stage为0
                // 鹰：必须写在这里，因为如果有多个fighting同时运行，则会出错（因为Timer会一直game.run）
                while(game.stage() !== 0)
                    yield null;

            });
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
        readonly property var musicpausing: function() {
            //return itemBackgroundMusic.objMusicPause[$name] !== undefined;
            if(GlobalLibraryJS.objectIsEmpty(itemBackgroundMusic.objMusicPause) &&
                !GameMakerGlobal.settings.value('$PauseMusic') &&
                (game.gd["$sys_sound"] & 0b1)
            )
                return false;

            return true;
        }


        readonly property var soundeffectpausing: function() {
            //return _private.config.nSoundConfig !== 0;
            if(GlobalLibraryJS.objectIsEmpty(rootSoundEffect.objSoundEffectPause) &&
                !GameMakerGlobal.settings.value('$PauseSound') &&
                (game.gd["$sys_sound"] & 0b10)
            )
                return false;
            return true;
        }


        //播放视频
        //video是视频名称；properties包含两个属性：$videoOutput（包括x、y、width、height等） 和 $mediaPlayer；
        //  也可以 $x、$y、$width、$height。
        readonly property var playvideo: function(video, properties={}, pauseGame=true) {

            //是否暂停游戏
            if(pauseGame) {
                game.pause('$video');

                //loaderGameMsg.focus = true;
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
                //如果没有使用yield来中断代码，可以不要game.run()
                game.goon('$video');
                game.run(true);
                //_private.asyncScript.run(_private.asyncScript.lastEscapeValue);
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


            //if(_private.spritesResource[imageRId] === undefined) {
            //    _private.spritesResource[imageRId].$$cache = {image: image};
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
            if(!GameSceneJS.getSpriteResource(spriteEffectRId))
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

            //let data = _private.spritesResource[spriteEffectRId];
            //properties.spriteSrc = Global.toURL(GameMakerGlobal.spriteResourceURL(data.Image));



            if(properties.$loops === undefined)
                properties.$loops = 1;


            //载入资源
            let sprite = _private.objTmpSprites[id];
            sprite = GameSceneJS.loadSpriteEffect(spriteEffectRId, sprite, properties.$loops, properties.$parent);
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
                else {
                    console.warn('找不到：', properties.$parent);
                    delsprite(id);
                    return;
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

            //if(_private.spritesResource[spriteEffectRId] === undefined) {
            //    _private.spritesResource[spriteEffectRId].$$cache = {sprite: sprite};
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
            setMapToRole(_private.sceneRole);

            game.gd["$sys_scale"] = n;
        }

        //场景跟随某个角色
        readonly property var setscenerole: function(r) {
            let role = game.hero(r);
            if(!role)
                role = game.role(r);
            if(role) {
                _private.sceneRole = role;
                setMapToRole(_private.sceneRole);
            }
        }

        //暂停游戏。
        readonly property var pause: function(name='$user_pause', times=1) {
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
                _private.config.objPauseNames[name] += times;
                console.warn('游戏被(%1)多次暂停 %2 次，请检查是否有暂停游戏的指令（比如msg、menu等）没有使用yield？'.arg(name).arg(_private.config.objPauseNames[name]));
            }
            else
                _private.config.objPauseNames[name] = times;
            //_private.config.objPauseNames[name] = (_private.config.objPauseNames[name] ? _private.config.objPauseNames[name] + 1 : 1);

            //joystick.enabled = false;
            //buttonA.enabled = false;
        }
        //继续游戏。
        readonly property var goon: function(name='$user_pause', times=-1) {
            //战斗模式不能设置
            //if(_private.nStage === 1)
            //    return;


            if(name === true) {
                _private.config.objPauseNames = {};
            }
            else {
                if(_private.config.objPauseNames[name]) {
                    if(times > 0)
                        _private.config.objPauseNames[name] -= times;
                    else
                        _private.config.objPauseNames[name] = 0;
                    if(_private.config.objPauseNames[name] <= 0)
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

                //压缩
                if(data.Type === 1) {
                    //debug下不检测存档
                    if(GameMakerGlobal.config.debug === false && data.Verify !== Qt.md5(_private.strSaveDataSalt + data.Data)) {
                        return false;
                    }
                    try {
                        data.Data = JSON.parse(FrameManager.sl_qml_Uncompress(data.Data, 1).toString());
                    }
                    catch(e) {
                        return false;
                    }

                    return data;
                }
                else {
                    //debug下不检测存档
                    if(GameMakerGlobal.config.debug === false && data.Verify !== Qt.md5(_private.strSaveDataSalt + JSON.stringify(data.Data))) {
                        return false;
                    }
                    return data;
                }
            }
            return false;
        }

        //!!存档，showName为显示名。
        //game.gd 开头为 $$ 的键不会保存
        //返回存档数据
        readonly property var save: function(fileName="autosave", showName='', type=1, compressionLevel=-1) {
            fileName = fileName.trim();
            if(!fileName)
                fileName = "autosave";



            //载入before_save脚本
            if(_private.objCommonScripts["before_save"])
                game.run([_private.objCommonScripts["before_save"](), 'before_save'], {Priority: -3, Type: 0, Running: 0});



            //过滤掉 $$ 开头的所有键
            let fSaveFilter = function(k, v) {
                if(k.indexOf("$$") === 0)
                    return undefined;
                return v;
            }

            let filePath = GameMakerGlobal.config.strSaveDataPath + GameMakerGlobal.separator + fileName + ".json";


            let outputData = {};
            let fileData;

            outputData.Version = "0.6";
            outputData.Name = showName;
            outputData.Type = type;
            outputData.Time = GlobalLibraryJS.formatDate();
            if(type === 1) {    //压缩
                let GlobalDataString = JSON.stringify(game.gd, fSaveFilter);
                outputData.Data = FrameManager.sl_qml_Compress(GlobalDataString, compressionLevel, 1).toString();
                outputData.Verify = Qt.md5(_private.strSaveDataSalt + outputData.Data);
                fileData = JSON.stringify(outputData, fSaveFilter);
            }
            else {
                let GlobalDataString = JSON.stringify(game.gd, fSaveFilter);
                outputData.Data = game.gd;
                outputData.Verify = Qt.md5(_private.strSaveDataSalt + GlobalDataString);
                fileData = JSON.stringify(outputData, fSaveFilter);
            }



            //!!!导出为文件
            //console.debug(JSON.stringify(outputData));
            //let ret = File.write(path + GameMakerGlobal.separator + 'map.json', JSON.stringify(outputData));
            let ret = FrameManager.sl_qml_WriteFile(fileData, Global.toPath(filePath), 0);
            //console.debug(itemContainer.arrCanvasMap[2].toDataURL())


            //载入after_save脚本
            if(_private.objCommonScripts["after_save"])
                game.run([_private.objCommonScripts["after_save"](), 'after_save'], {Priority: -1, Type: 0, Running: 1});


            return ret;

        }

        //读档（读取数据到 game.gd），成功返回true，失败返回false。
        readonly property var load: function(fileName="autosave") {

            //载入after_load脚本
            if(_private.objCommonScripts["before_load"])
                game.run([_private.objCommonScripts["before_load"](), 'before_load'], {Priority: -3, Type: 0, Running: 0});



            //let filePath = GameMakerGlobal.config.strSaveDataPath + GameMakerGlobal.separator + fileName + ".json";

            fileName = fileName.trim();
            if(!fileName)
                fileName = "autosave";

            let ret = checksave(fileName)
            if(ret === false)
                return false;


            release(false);
            init(false, false, ret['Data']);


            //game.gd = ret['Data'];
            //GlobalLibraryJS.copyPropertiesToObject(game.gd, ret['Data']);


            game.$sys.reloadFightHeros();

            //刷新战斗时人物数据
            //loaderFightScene.refreshAllFightRoleInfo();

            game.$sys.reloadGoods();


            //地图
            game.loadmap(game.gd["$sys_map"].$name, true);

            //读取主角
            for(let th of game.gd["$sys_main_roles"]) {
                let mainRole = game.createhero(th.$rid);
                //game.hero(mainRole, th);
            }

            //开始移动地图
            //setMapToRole(_private.sceneRole);

            //其他
            game.setinterval(game.gd["$sys_fps"]);
            game.scale(game.gd["$sys_scale"]);

            game.playmusic(game.gd["$sys_music"]);

            /*if(game.gd["$sys_sound"] & 0b10)
                _private.config.nSoundConfig = 0;
            else
                _private.config.nSoundConfig = 1;
            */


            if(game.gd["$sys_random_fight"]) {
                game.fighton(...game.gd["$sys_random_fight"]);
            }


            //载入after_load脚本
            if(_private.objCommonScripts["after_load"])
                game.run([_private.objCommonScripts["after_load"](), 'after_load'], {Priority: -1, Type: 0, Running: 1});


            return true;
        }

        //游戏结束（调用游戏结束脚本）；
        readonly property var gameover: function(params) {
            game.run(_private.objCommonScripts["game_over_script"](params), 0);
        }


        //返回插件
        readonly property var plugin: function(...params) {
            let plugin = _private.objPlugins[params[0]][params[1]];
            if(plugin && plugin.$autoLoad === false) {
                plugin.$autoLoad = true;
                plugin.$load();
                plugin.$init();
            }

            return plugin;
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
        //  vScript 为执行脚本（字符串、函数、生成器函数、生成器对象都可以），如果为null则表示强制执行队列，为true表示下次js事件循环再运行
        //    可以为数组（vScript是执行脚本时 为 第二个下标为tips，是null或true时为给_private.asyncScript.lastEscapeValue值）；
        //  scriptProps：
        //    如果为数字，表示优先级Priority；
        //      Type默认为0，Running默认为1，Value默认为无；
        //    如果为对象，则有以下参数：
        //      Priority为优先级；>=0为插入到对应的事件队列下标位置（0为挂到第一个）；-1为追加到队尾；-2为立即执行（此时代码前必须有yield）；-3为将此代码执行完毕再返回（注意：1、代码里yield不能返回了；2、此时Running必须为0）；
        //      Type为运行类型（如果为0，表示为代码，否则表示vScript为JS文件名，而scriptProps.Path为路径）；
        //      Running为1或2，表示如果队列里如果为空则执行（区别为：1是下一个JS事件循环执行，2是立即执行）；为0时不执行；
        //      Value：传递给事件队列的值，无则默认上一次的；
        readonly property var run: function(vScript, scriptProps=-1, ...params) {
            if(vScript === undefined) {
                console.warn('[!GameScene]运行脚本未定义!!!');
                return false;
            }


            //参数
            let priority, runType = 0, running = 1, value;
            if(GlobalLibraryJS.isObject(scriptProps)) { //如果是参数对象
                priority = GlobalLibraryJS.isValidNumber(scriptProps.Priority) ? scriptProps.Priority : -1;
                runType = GlobalLibraryJS.isValidNumber(scriptProps.Type) ? scriptProps.Type : 0;
                running = GlobalLibraryJS.isValidNumber(scriptProps.Running) ? scriptProps.Running : 1;
                value = Object.keys(scriptProps).indexOf('Value') < 0 ? _private.asyncScript.lastEscapeValue : scriptProps.Value;
            }
            else if(GlobalLibraryJS.isValidNumber(scriptProps)) {   //如果是数字，则默认是优先级
                priority = scriptProps;
                runType = 0;
                running = 1;
                value = _private.asyncScript.lastEscapeValue;
            }
            else {
                console.warn('[!GameScene]运行脚本属性错误!!!');
                return false;
            }


            //直接运行
            if(vScript === null) {
                _private.asyncScript.run(value);
                return 1;
            }

            //下次js循环运行
            else if(vScript === true) {
                /*GlobalLibraryJS.runNextEventLoop(function() {
                    //game.goon('$event');
                        _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                    }, 'game.run1');
                */
                _private.asyncScript.lastEscapeValue = value;
                _private.asyncScript.runNextEventLoop('game.run1');

                return 0;
            }

            else if(vScript === false) {
                return false;
            }


            if(runType === 0) { //vScript是代码

            }
            else {  //vScript是文件名
                let tScript;
                if(GlobalLibraryJS.isArray(vScript)) {
                    tScript = vScript[0];
                }
                else {
                    tScript = vScript;
                }

                tScript = tScript.trim();
                if(!scriptProps.Path)
                    scriptProps.Path = game.$projectpath;

                if(GlobalLibraryJS.isArray(vScript))
                    vScript[0] = scriptProps.Path + GameMakerGlobal.separator + tScript;
                else
                    vScript = scriptProps.Path + GameMakerGlobal.separator + tScript;
            }

            //可以立刻执行
            if(GlobalJS.createScript(_private.asyncScript, runType, priority, vScript, ...params) === 0) {
                //暂停游戏主Timer，否则有可能会Timer先超时并运行game.run(null)，导致执行两次
                //game.pause('$event');

                if(running === 1) {
                    //GlobalLibraryJS.setTimeout(function() {
                    /*GlobalLibraryJS.runNextEventLoop(function() {
                        //game.goon('$event');
                            _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                        }, 'game.run');
                    */
                    _private.asyncScript.lastEscapeValue = value;
                    _private.asyncScript.runNextEventLoop('game.run');
                }
                else if(running === 2)
                    _private.asyncScript.run(value);

                return 0;
            }
        }

        //鹰：NO
        //将脚本放入 系统脚本引擎（asyncScript）中 等候执行；一般用在编辑器中载入外部脚本文件
        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var script: function(fileName, priority, filePath) {
            fileName = fileName.trim();
            if(!filePath)
                filePath = game.$projectpath + GameMakerGlobal.separator + fileName;
            else
                filePath = filePath + GameMakerGlobal.separator + fileName;

            if(GlobalJS.createScript(_private.asyncScript, 1, priority, filePath) === 0)
                return _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
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
            return GlobalJS._eval(data, filePath, envs);
        }

        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var evalfile: function(fileName, filePath="", envs={}) {
            fileName = fileName.trim();
            if(!filePath)
                filePath = game.$projectpath + GameMakerGlobal.separator + fileName;
            else
                filePath = filePath + GameMakerGlobal.separator + fileName;

            GlobalJS._evalFile(filePath, envs);
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

        //插件（直接访问，不推荐）
        readonly property var $plugins: _private.objPlugins


        //系统 数据 和 函数（一般特殊需求）
        readonly property var $sys: ({
            release: release,
            init: init,

            screen: itemComponentsContainer,    //固定屏幕上（所有，包含战斗场景）
            scene: gameScene,   //会改变大小
            container: itemContainer,   //会改变大小和随地图移动

            interact: GameSceneJS.buttonAClicked,  //交互函数

            //重新创建（修复继承链），并计算新属性
            reloadFightHeros: function() {

                let tFightHeros = game.gd["$sys_fight_heros"];
                game.gd["$sys_fight_heros"] = [];

                for(let tfh of tFightHeros) {
                    //let tfh = tFightHeros[tIndex];
                    if(tfh) {
                        tfh = GameSceneJS.getFightRoleObject(tfh, true);
                        game.gd["$sys_fight_heros"].push(tfh);
                        _private.objCommonScripts["refresh_combatant"](tfh);
                    }
                    else {
                        console.warn('跳过错误存档战斗人物：', tfh);
                    }


                    /*let t = game.gd["$sys_fight_heros"][tIndex];
                    game.gd["$sys_fight_heros"][tIndex] = new _private.objCommonScripts["combatant_class"](t.$rid, t.$name);
                    GlobalLibraryJS.copyPropertiesToObject(game.gd["$sys_fight_heros"][tIndex], t);

                    //game.gd["$sys_fight_heros"][tIndex].__proto__ = _private.objCommonScripts["combatant_class"].prototype;
                    //game.gd["$sys_fight_heros"][tIndex].$$fightData = {};
                    //game.gd["$sys_fight_heros"][tIndex].$$fightData.$buffs = {};
                    */
                }
            },

            //重新创建（修复继承链）
            reloadGoods: function() {

                let tGoods = game.gd["$sys_goods"];
                game.gd["$sys_goods"] = [];

                for(let tg of tGoods) {
                    //let tg = tGoods[tIndex];
                    if(tg) {
                        tg = GameSceneJS.getGoodsObject(tg, true);
                        game.gd["$sys_goods"].push(tg);
                    }
                    else {
                        console.warn('跳过错误存档道具：', tg);
                    }
                }
            },

            playSoundEffect: rootSoundEffect.playSoundEffect,

            getSkillObject: GameSceneJS.getSkillObject,
            getGoodsObject: GameSceneJS.getGoodsObject,
            getFightRoleObject: GameSceneJS.getFightRoleObject,
            getFightScriptObject: GameSceneJS.getFightScriptObject,

            getSkillResource: GameSceneJS.getSkillResource,
            getGoodsResource: GameSceneJS.getGoodsResource,
            getFightRoleResource: GameSceneJS.getFightRoleResource,
            getFightScriptResource: GameSceneJS.getFightScriptResource,
            getSpriteResource: GameSceneJS.getSpriteResource,

            loadSpriteEffect: GameSceneJS.loadSpriteEffect,

            components: {
                joystick: joystick,
                buttons: itemButtons,
                fps: itemFPS,
                map: [canvasBackMap, canvasFrontMap],
            },

            //资源
            resources: $resources,
        })



        //地图大小和视窗大小
        readonly property size $mapSize: Qt.size(itemContainer.width, itemContainer.height)
        readonly property size $sceneSize: Qt.size(rootGameScene.width, rootGameScene.height)

        //上次帧间隔时长
        property int $frameDuration: 0

        //property real fAspectRatio: Screen.width / Screen.height



        //资源（!!!鹰：过时：兼容旧代码）
        readonly property alias objGoods: _private.goodsResource
        readonly property alias objFightRoles: _private.fightRolesResource
        readonly property alias objSkills: _private.skillsResource
        readonly property alias objFightScripts: _private.fightScriptsResource
        readonly property alias objSprites: _private.spritesResource

        readonly property alias objCommonScripts: _private.objCommonScripts

        readonly property alias objCacheSoundEffects: _private.objCacheSoundEffects



        readonly property QtObject $resources: QtObject {
            readonly property alias goods: _private.goodsResource
            readonly property alias fightRoles: _private.fightRolesResource
            readonly property alias skills: _private.skillsResource
            readonly property alias fightScripts: _private.fightScriptsResource
            readonly property alias sprites: _private.spritesResource

            readonly property alias commonScripts: _private.objCommonScripts

            readonly property alias cacheSoundEffects: _private.objCacheSoundEffects


            //readonly property alias objTmpImages: _private.objTmpImages
            //readonly property alias objTmpSprites: _private.objTmpSprites

            //readonly property alias objImages: _private.objImages
            //readonly property alias objMusic: _private.objMusic
            //readonly property alias objVideos: _private.objVideos



            //readonly property alias objRoles: _private.objRoles
            //readonly property alias arrMainRoles: _private.arrMainRoles

        }

    }

    property Item mainRole


    property alias _public: _public

    property alias config: _private.config
    //property alias _private: _private

    property alias fightScene: loaderFightScene

    property alias asyncScript: _private.asyncScript



    //property alias mainRole: mainRole

    //地图块大小（用于缩放地图块）
    property size sizeMapBlockSize



    //是否是测试模式（不会存档）
    property bool bTest: false



    //游戏开始脚本
    //startScript为true，则载入start.js；为字符串，则直接运行startScript
    function init(startScript=true, bLoadResources=true, gameData=null) {
        game.gd["$sys_fight_heros"] = [];
        //game.gd["$sys_hidden_fight_heros"] = [];
        game.gd["$sys_money"] = 0;
        game.gd["$sys_goods"] = [];
        game.gd["$sys_map"] = {};
        game.gd["$sys_fps"] = 16;
        game.gd["$sys_main_roles"] = [];
        game.gd["$sys_sound"] = 0b11;
        game.gd["$sys_music"] = '';
        game.gd["$sys_scale"] = 1;


        if(bLoadResources)
            GameSceneJS.loadResources();


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
                _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
            */

            if(_private.objCommonScripts["game_start"])
                game.run([_private.objCommonScripts["game_start"](), 'game_start']);
        }
        else if(startScript === false) {

        }
        else {  //是脚本
            game.run([startScript, 'game_start']);
        }


        //恢复游戏数据
        if(gameData)
            GlobalLibraryJS.copyPropertiesToObject(game.gd, gameData);


        //init脚本
        if(_private.objCommonScripts["game_init"])
            game.run([_private.objCommonScripts["game_init"](), 'game_init']);


        //所有插件初始化
        for(let tc in _private.objPlugins)
            for(let tp in _private.objPlugins[tc])
                if(_private.objPlugins[tc][tp].$init && _private.objPlugins[tc][tp].$autoLoad !== false)
                    _private.objPlugins[tc][tp].$init();


        game.pause();
        game.goon('$release');

        //game.run([function(){game.goon(true);}, 'goon']);

        //进游戏时如果设置了屏幕旋转，则x、y坐标会互换导致出错，所以重新刷新一下屏幕；
        //!!!屏幕旋转会导致 itemContainer 的x、y坐标互换!!!???
        //GlobalLibraryJS.setTimeout(function() {
        //        setMapToRole(_private.sceneRole);
        //    },10,rootGameScene
        //);
    }



    //释放所有资源
    function release(bUnloadResources=true) {

        //timer.stop();
        _private.config.objPauseNames = {};
        game.pause('$release');


        //所有插件释放
        for(let tc in _private.objPlugins)
            for(let tp in _private.objPlugins[tc])
                if(_private.objPlugins[tc][tp].$release && _private.objPlugins[tc][tp].$autoLoad !== false)
                    _private.objPlugins[tc][tp].$release();


        game.scale(1);

        _private.asyncScript.clear(1);
        //_private.asyncScript.run(_private.asyncScript.lastEscapeValue);

        loaderGameMsg.item.stop();
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
        dialogTrade.visible = false;
        loaderGameMsg.item.visible = false;
        itemRootRoleMsg.visible = false;
        itemRootGameInput.visible = false;

        itemGameMenus.nIndex = 0;
        for(let tim in itemGameMenus.children) {
            itemGameMenus.children[tim].destroy();
        }

        //itemMenu.visible = false;
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


        _private.sceneRole = mainRole;
        mainRole.$$collideRoles = {};
        mainRole.$$mapEventsTriggering = {};


        _private.nStage = 0;


        loaderFightScene.visible = false;


        itemContainer.mapInfo = null;

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
            GameSceneJS.unloadResources();
    }


    //打开地图
    function openMap(mapName, forceRepaint=false) {
        let mapPath = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + mapName;

        if(forceRepaint || game.gd["$sys_map"].$name !== mapName || !itemContainer.mapInfo) {

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
            sizeMapBlockSize.width = Math.round(itemContainer.mapInfo.MapBlockSize[0] * nMapBlockScale);
            sizeMapBlockSize.height = Math.round(itemContainer.mapInfo.MapBlockSize[1] * nMapBlockScale);

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

            imageMapBlock.source = Global.toURL(GameMakerGlobal.mapResourceURL(itemContainer.mapInfo.MapBlockImage[0]));

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
            for(let i in itemContainer.mapInfo.MapEventData) {
                let p = i.split(',');
                itemContainer.mapEventBlocks[parseInt(p[0]) + parseInt(p[1]) * itemContainer.mapInfo.MapSize[0]] = itemContainer.mapInfo.MapEventData[i];
            }

            //console.debug("itemContainer.mapEventBlocks", JSON.stringify(itemContainer.mapEventBlocks))

            //game.$sys_map.$name = itemContainer.mapInfo.MapName;
            game.gd["$sys_map"].$name = itemContainer.mapInfo.MapName;
            game.gd["$sys_map"].$$columns = itemContainer.mapInfo.MapSize[0];
            game.gd["$sys_map"].$$rows = itemContainer.mapInfo.MapSize[1];
            game.gd["$sys_map"].$$info = itemContainer.mapInfo;

            game.gd["$sys_map"].$$obstacles = [];
            for(let mb in itemContainer.mapInfo.MapBlockSpecialData) {
                if(itemContainer.mapInfo.MapBlockSpecialData[mb] === -1)
                    game.gd["$sys_map"].$$obstacles.push(mb.split(','));
            }
        }



        //执行载入地图脚本

        //之前的
        //if(itemContainer.mapInfo.SystemEventData !== undefined && itemContainer.mapInfo.SystemEventData["$1"] !== undefined) {
        //    if(GlobalJS.createScript(_private.asyncScript, 0, 0, itemContainer.mapInfo.SystemEventData["$1"]) === 0)
        //        return _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
        //}

        //使用Component（太麻烦）
        //let scriptComp = Qt.createComponent(Global.toURL(filePath + GameMakerGlobal.separator + "map.qml"));
        //console.debug('!!!999', Global.toURL(filePath + GameMakerGlobal.separator + "map.qml"), scriptComp)
        //let script = scriptComp.createObject({}, rootGameScene);

        //let script = Qt.createQmlObject('import QtQuick 2.14;import "map.js" as Script;Item {property var script: Script}', rootGameScene, Global.toURL(filePath + GameMakerGlobal.separator));
        //script.destroy();
        let ts = _private.jsEngine.load('map.js', Global.toURL(mapPath));
        itemContainer.mapInfo.$$Script = ts;
        if(ts.$start)
            game.run([ts.$start(), 'map $start']);
        else if(ts.start)
            game.run([ts.start(), 'map start']);



        console.debug("[GameScene]openMap", itemContainer.width, itemContainer.height)

        //test();

        return itemContainer.mapInfo;
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
        //let targetX = role.x + role.x1 + parseInt(role.width1 / 2);
        //let targetY = role.y + role.y1 + parseInt(role.height1 / 2);

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

        if(role === _private.sceneRole)setMapToRole(_private.sceneRole);
    }

    //设置主角坐标（块坐标）
    function setMainRolePos(bx, by, index=0) {
        let mainRole = _private.arrMainRoles[index];

        setRolePos(mainRole, bx, by);
        //setMapToRole(_private.sceneRole);
        if(mainRole === _private.sceneRole)setMapToRole(_private.sceneRole);

        game.gd["$sys_main_roles"][index].$x = mainRole.x;
        game.gd["$sys_main_roles"][index].$y = mainRole.y;
    }

    function setMapToRole(role) {
        if(!role)
            return;

        //计算角色移动时，地图移动的 左上角和右下角 的坐标

        //场景在地图左上角时的中央坐标
        let mapLeftTopCenterX = parseInt(gameScene.nMaxMoveWidth / 2);
        let mapLeftTopCenterY = parseInt(gameScene.nMaxMoveHeight / 2);

        //场景在地图右下角时的中央坐标
        let mapRightBottomCenterX = itemContainer.width - mapLeftTopCenterX;
        let mapRightBottomCenterY = itemContainer.height - mapLeftTopCenterY;

        //角色最中央坐标
        let roleCenterX = role.x + role.x1 + parseInt(role.width1 / 2);
        let roleCenterY = role.y + role.y1 + parseInt(role.height1 / 2);

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

        if(mainRole.nActionType === -1)
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

            if(GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames)) {
                _private.doAction(1, event.key);
                mainRole.nActionType = 1;
            }

            event.accepted = true;

            break;

        case Qt.Key_Return:
            if(event.isAutoRepeat === true) { //如果是按住不放的事件，则返回（只记录第一次按）
                event.accepted = true;
                return;
            }


            if(GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                GameSceneJS.buttonAClicked();


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
        acceptedButtons: Qt.AllButtons  /*Qt.LeftButton | Qt.RightButton*/
        onPressed: {
            mouse.accepted = true;
        }
    }



    //地图界面元素容器
    Item {
        id: itemComponentsContainer
        anchors.fill: parent



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
            //z: 0
            width: rootGameScene.width / scale
            height: rootGameScene.height / scale

            clip: true
            color: "black"

            transformOrigin: Item.TopLeft



            Item {    //所有东西的容器
                id: itemContainer


                property var mapInfo: null          //地图数据（map.json 和 map.js（$$Script） 的数据）
                property var mapEventBlocks: ({})   //有事件的地图块ID（换算后的）

                //property var image1: "1.jpg"
                //property var image2: "2.png"


                //width: 800
                //height: 600

                //scale: 2



                //地图点击
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.AllButtons  /*Qt.LeftButton | Qt.RightButton*/
                    onClicked: {
                        GameSceneJS.mapClickEvent(mouse.x, mouse.y);
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

                        smooth: GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$map', '$smooth'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$map', '$smooth'), true)


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

                                //如果前景色需要半透明，则背景的每一层都必须绘制，如果没有半透明，则不需要绘制不属于地板层的
                                if(_private.config.rMapOpacity >= 1)
                                    //跳过不属于地板层的
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

                        smooth: GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$map', '$smooth'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$map', '$smooth'), true)

                        opacity: _private.config.rMapOpacity


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

                                //跳过地板层
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
                    GameSceneJS.onTriggered();
                    //使用脚本队列的话，人物移动就不能在asyncScript.wait下使用了
                    //game.run(GameSceneJS.onTriggered);
                    //game.run(true);
                }
            }
        }


        /*/游戏对话框
        Dialog {
            id: loaderGameMsg

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
                enabled: loaderGameMsg.standardButtons === Dialog.NoButton
                onPressed: {
                    //rootGameScene.forceActiveFocus();
                    loaderGameMsg.reject();
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



        //操控杆
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

                    if(mainRole.nActionType === -1)
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
                    mainRole.nActionType = 10;

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



        //战斗场景
        /*/Loader {
            id: loaderFightScene

            source: "./FightScene.qml"
            asynchronous: false

            Connections {
                target: loaderFightScene.item

                //!鹰：Loader每次载入的时候都会重新Connection一次，所以没有的会出现警告
                function onS_FightOver() {

        */
        FightScene {
            id: loaderFightScene

            visible: false
            anchors.fill: parent
            z: 2

            Component.onCompleted: {
                //loaderFightScene.asyncScript = _private.asyncScript;
            }
        }



        //菜单
        GameMenuWindow {
            id: gameMenuWindow

            visible: false
            anchors.fill: parent
            z: 3

            onS_close: {
                gameMenuWindow.visible = false;

                if(_private.config.objPauseNames['$menu_window'] !== undefined) {
                    //如果没有使用yield来中断代码，可以不要game.run()
                    game.goon('$menu_window');
                    game.run(true);
                    //_private.asyncScript.run(_private.asyncScript.lastEscapeValue);
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


        //交易框
        GameTradeWindow {
            id: dialogTrade

            visible: false
            anchors.fill: parent
            z: 4

        }



        //角色对话框
        Item {
            id: itemRootRoleMsg


            //显示完全后延时
            property int nKeepTime: 0
            //显示状态：-1：停止；0：显示完毕；1：正在显示
            property int nShowStatus: -1

            //回调函数
            property var callback


            //signal accepted();
            //signal rejected();


            function over(code) {
                itemRootRoleMsg.nShowStatus = -1;

                if(GlobalLibraryJS.isFunction(itemRootRoleMsg.callback))
                    itemRootRoleMsg.callback(code, itemRootRoleMsg);
                else {  // if(itemRootRoleMsg.callback === true) {   //默认回调函数
                    //gameMap.focus = true;

                    itemRootRoleMsg.visible = false;


                    /*/*if(itemRootRoleMsg.bPauseGame && _private.config.bPauseGame) {
                        game.goon();
                        itemRootRoleMsg.bPauseGame = false;
                    }* /*/

                    /*if(_private.config.objPauseNames['$talk'] !== undefined) {
                        game.goon('$talk');
                        _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                    }*/



                    //itemRootRoleMsg.destroy();
                    ////FrameManager.goon();
                }
            }

            function stop(type=0) {
                messageRole.stop(type);
            }

            function show(msg, pretext, interval, keeptime, style) {

                let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$talk') || {};
                let styleSystem = game.$gameMakerGlobalJS.$config.$styles.$talk;

                messageRole.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
                messageRole.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
                messageRole.textArea.font.pointSize = style.FontSize || styleUser.$fontSize || styleSystem.$fontSize;
                messageRole.textArea.font.color = style.FontColor || styleUser.$fontColor || styleSystem.$fontColor;
                maskMessageRole.color = style.MaskColor || styleUser.$maskColor || styleSystem.$maskColor;
                //let type = GlobalLibraryJS.shortCircuit(0b1, style.Type, styleUser.$type, styleSystem.$type);

                //-1：即点即关闭；0：等待显示完毕(需点击）；>0：显示完毕后过keeptime毫秒自动关闭（不需点击）；
                itemRootRoleMsg.nKeepTime = keeptime || 0;

                itemRootRoleMsg.nShowStatus = 1;



                itemRootRoleMsg.visible = true;
                //touchAreaRoleMsg.enabled = false;
                messageRole.show(GlobalLibraryJS.convertToHTML(msg), GlobalLibraryJS.convertToHTML(pretext), interval, keeptime, 0b0);
                //FrameManager.wait(-1);
            }

            function clicked() {
                //显示完毕，则关闭
                if(itemRootRoleMsg.nShowStatus === 0)
                    itemRootRoleMsg.over(1);
                //如果正在显示，且nKeepTime为-1（表示点击后显示全部）；
                else if(itemRootRoleMsg.nShowStatus === 1 && itemRootRoleMsg.nKeepTime === -1) {
                    itemRootRoleMsg.nShowStatus = 0;
                    messageRole.stop(1);
                }
            }


            visible: false
            anchors.fill: parent
            z: 5


            Mask {
                id: maskMessageRole

                anchors.fill: parent

                visible: color.a !== 0

                color: "transparent"

                mouseArea.onPressed: {
                    itemRootRoleMsg.clicked();
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
                    itemRootRoleMsg.clicked();
                    //rootGameScene.forceActiveFocus();
                }

                onS_over: {
                    //自动关闭
                    if(itemRootRoleMsg.nKeepTime > 0)
                        itemRootRoleMsg.over(2);
                    else
                        itemRootRoleMsg.nShowStatus = 0;
                }
            }


            /*MultiPointTouchArea {
                id: touchAreaRoleMsg
                anchors.fill: parent
                enabled: false
                //enabled: itemRootRoleMsg.standardButtons === Dialog.NoButton

                //onPressed: {
                onReleased: {
                    //rootGameScene.forceActiveFocus();
                    //console.debug("MultiPointTouchArea1")
                    itemRootRoleMsg.over();
                    //console.debug("MultiPointTouchArea2")
                }
            }*/

        }


        Loader {
            id: loaderGameMsg

            visible: true
            anchors.fill: parent
            z: 6

            sourceComponent: compGameMsg
            asynchronous: false

            /*Connections {
                target: loaderGameMsg.item

                function onAccepted() {
                }
                function onRejected() {
                }
            }
            */

            onLoaded: {
            }
        }


        //临时存放创建的Menus
        Item {
            id: itemGameMenus

            //创建一个自增1
            property int nIndex: 0

            anchors.fill: parent
            z: 7

        }

        //游戏 输入框
        Item {
            id: itemRootGameInput


            //回调函数
            property var callback

            visible: false
            anchors.fill: parent
            z: 8



            Mask {
                id: maskGameInput

                anchors.fill: parent

                visible: color.a !== 0

                color: "#7FFFFFFF"

                mouseArea.onPressed: {
                    //itemRootGameInput.visible = false;
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
                    //radius: itemMenu.radius

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
                        if(GlobalLibraryJS.isFunction(itemRootGameInput.callback))
                            itemRootGameInput.callback(itemRootGameInput);
                        else {  // if(itemRootGameInput.callback === true) {   //默认回调函数
                            //gameMap.focus = true;

                            itemRootGameInput.visible = false;


                            /*/*if(itemRootGameInput.bPauseGame && _private.config.bPauseGame) {
                                game.goon();
                                itemRootGameInput.bPauseGame = false;
                            }* /*/

                            /*if(_private.config.objPauseNames['$input'] !== undefined) {
                                game.goon('$input');
                                _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                            }*/



                            //itemRootGameInput.destroy();
                            ////FrameManager.goon();
                        }

                    }
                }
            }
        }

        //视频播放
        Item {
            id: itemVideo

            visible: false
            anchors.fill: parent
            z: 9

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
                acceptedButtons: Qt.AllButtons  /*Qt.LeftButton | Qt.RightButton*/
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
    }



    Item {
        id: itemBackgroundMusic

        property var arrMusicStack: []  //播放音乐栈

        property var objMusicPause: ({})    //暂停类型


        function isPlaying() {
            return audioBackgroundMusic.playbackState === Audio.PlayingState;
        }

        function play() {
            //bPlay = true;
            if(!game.musicpausing())
                audioBackgroundMusic.play();
            //nPauseTimes = 0;
        }

        function stop() {
            //bPlay = false;
            audioBackgroundMusic.stop();
            //nPauseTimes = 0;
        }

        function pause(name='$user') {
            if(name === true) { //全局
                GameMakerGlobal.settings.setValue('$PauseMusic', 1);
            }
            else if(name === false) { //存档
                game.gd["$sys_sound"] &= ~0b1;
            }
            else if(name && GlobalLibraryJS.isString(name)) {
                //if(objMusicPause[name] === 1)
                //    console.warn('游戏被多次暂停，请检查是否有暂停游戏的指令（比如msg、menu等）没有使用yield？');
                objMusicPause[name] = (objMusicPause[name] ? objMusicPause[name] + 1 : 1);
                //objMusicPause[name] = 1;
            }
            else
                return;


            //if(audioBackgroundMusic.playbackState !== Audio.StoppedState)
                audioBackgroundMusic.pause();


            //console.debug("!!!pause", nPauseTimes)
        }

        function resume(name='$user') {
            if(name === true) { //全局
                GameMakerGlobal.settings.setValue('$PauseMusic', 0);
            }
            else if(name === false) { //存档
                game.gd["$sys_sound"] |= 0b1;
            }
            else if(name === null) {    //清空
                objMusicPause = {};
            }
            else if(name && GlobalLibraryJS.isString(name)) {
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
            else
                return;


            if(GlobalLibraryJS.objectIsEmpty(objMusicPause) &&
                !GameMakerGlobal.settings.value('$PauseMusic') &&
                (game.gd["$sys_sound"] & 0b1)
            ) {
                //if(audioBackgroundMusic.playbackState !== Audio.StoppedState)
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

    QtObject {
        id: rootSoundEffect

        property var objSoundEffectPause: ({})    //暂停类型


        function pause(name='$user') {
            if(name === true) { //全局
                GameMakerGlobal.settings.setValue('$PauseSound', 1);
            }
            else if(name === false) { //存档
                game.gd["$sys_sound"] &= ~0b10;
            }
            else if(name && GlobalLibraryJS.isString(name)) {
                //if(objSoundEffectPause[name] === 1)
                //    console.warn('游戏被多次暂停，请检查是否有暂停游戏的指令（比如msg、menu等）没有使用yield？');
                objSoundEffectPause[name] = (objSoundEffectPause[name] ? objSoundEffectPause[name] + 1 : 1);
                //objSoundEffectPause[name] = 1;
            }
            else
                return;

            //console.debug("!!!pause", nPauseTimes)
        }

        function resume(name='$user') {
            if(name === true) { //全局
                GameMakerGlobal.settings.setValue('$PauseSound', 0);
            }
            else if(name === false) { //存档
                game.gd["$sys_sound"] |= 0b10;
            }
            else if(name === null) {    //清空
                objSoundEffectPause = {};
            }
            else if(name && GlobalLibraryJS.isString(name)) {
                if(objSoundEffectPause[name]) {
                    --objSoundEffectPause[name];
                    if(objSoundEffectPause[name] === 0)
                        delete objSoundEffectPause[name];
                }
                else {
                    //rootGameScene.forceActiveFocus();
                    //return;
                }
            }
            else
                return;

            //console.debug("!!!resume", nPauseTimes, bPlay)
        }



        function playSoundEffect(soundeffectSource) {
            if(_private.objCacheSoundEffects[soundeffectSource]) {
                if(game.soundeffectpausing())
                    return;

                //!!!鹰：手机上，如果状态为playing，貌似后面play就没声音了。。。
                if(_private.objCacheSoundEffects[soundeffectSource].isPlaying)
                    _private.objCacheSoundEffects[soundeffectSource].stop();
                _private.objCacheSoundEffects[soundeffectSource].play();
            }
        }

    }



    //调试
    Rectangle {
        id: itemFPS
        //width: Platform.compileType() === "debug" ? rootGameScene.width / 3 : rootGameScene.width / 2
        //width: textFPS.width + textPos.width
        width: 150
        height: Platform.compileType() === "debug" ? textFPS.implicitHeight : textFPS.implicitHeight
        color: "#90FFFFFF"

        Row {
            height: 15

            Text {
                id: textFPS
                //y: 0
                width: 60
                //width: contentWidth + 50
                height: textFPS.implicitHeight
            }

            Text {
                id: textPos
                //y: 15
                width: 90
                //width: contentWidth + 50
                height: textFPS.implicitHeight

                //visible: Platform.compileType() === "debug"
            }
        }
        Text {
            id: textPos1
            y: 15
            //width: 200
            width: 120
            height: 15

            visible: Platform.compileType() === "debug"
        }


        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons  /*Qt.LeftButton | Qt.RightButton*/
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



    QtObject {  //公有数据,函数,对象等
        id: _public

    }


    QtObject {  //私有数据,函数,对象等
        id: _private


        //游戏配置/设置
        property var config: QtObject {
            property int nInterval: 16

            property var objPauseNames: ({})     //暂停游戏

            property real rJoystickSpeed: 0.2   //开启摇杆加速功能（最低速度比例）

            //键盘是否可以操作
            property bool bKeyboard: true

            //前景地图遮挡人物透明度
            property real rMapOpacity: 1

            //是否游戏提前载入所有资源
            property int nLoadAllResources: 0

        }

        //存档m5的盐
        readonly property string strSaveDataSalt: "深林孤鹰@鹰歌联盟Leamus_" + GameMakerGlobal.config.strCurrentProjectName

        //游戏目前阶段（0：正常；1：战斗）
        property int nStage: 0



        //资源（外部读取） 信息

        property var goodsResource: ({})         //所有道具信息；格式：key为 道具资源名，每个对象属性：$rid为 道具资源名，其他是脚本返回值（$commons）
        property var fightRolesResource: ({})        //所有战斗角色信息
        property var skillsResource: ({})        //所有技能信息
        property var fightScriptsResource: ({})        //所有战斗脚本信息
        property var spritesResource: ({})       //所有特效信息；格式：key为 特效资源名，每个对象属性：$rid为 为特效资源名，$$cache为缓存{image: Image组件, music: SoundEffect组件}

        property var objCacheSoundEffects: ({})       //所有音效信息

        property var objCommonScripts: ({})     //系统用到的 通用脚本（外部脚本优先，如果没有使用 GameMakerGlobal.js的）

        //媒体列表 信息
        //property var objImages: ({})         //{图片名: 图片路径}
        //property var objMusic: ({})         //{音乐名: 音乐路径}
        //property var objVideos: ({})         //{视频名: 视频路径}



        //创建的 角色NPC 和 主角 组件容器
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


        //场景跟踪角色
        property var sceneRole: mainRole



        //异步脚本（整个游戏的脚本队列系统）
        property var asyncScript: new GlobalLibraryJS.Async(rootGameScene)

        //JS引擎，用来载入外部JS文件
        property var jsEngine: new GlobalJS.JSEngine(rootGameScene)
        property var objPlugins: ({})

        //临时保存屏幕旋转
        property int lastOrient: -1



        //键盘处理
        property var keys: ({}) //保存按下的方向键

        //type为0表示按钮，type为1表示键盘（会保存key），2为自动行走
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


            if(mainRole.nActionType === -1)
                return;

            mainRole.nActionType = 0;
        }


        /*function buttonMenuClicked() {
            console.debug("[GameScene]buttonMenuClicked");


            game.window(1);

        }*/



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
                        game.save();  //存档

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
                        console.warn("游戏没有正常退出，但并不碍事：", err);
                        throw err;
                    }
                },
                OnRejected: ()=>{
                    if(rootGameScene)rootGameScene.forceActiveFocus();
                },
            });
        }



        //清空canvas
        function clearCanvas(canvas) {
            let ctx = canvas.getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height);
        }

    }



    //游戏信息框
    Component {
        id: compGameMsg

        //游戏对话框
        Item {
            id: rootGameMsgDialog


            //是否暂停了游戏
            //property bool bPauseGame: true
            //显示完全后延时
            property int nKeepTime: 0
            //显示状态：-1：停止；0：显示完毕；1：正在显示
            property int nShowStatus: -1
            //property alias textGameMsg: textGameMsg.text
            //property int standardButtons: Dialog.Ok | Dialog.Cancel

            //回调函数
            property var callback


            //signal accepted();
            //signal rejected();


            function over(code) {
                rootGameMsgDialog.nShowStatus = -1;

                if(GlobalLibraryJS.isFunction(rootGameMsgDialog.callback))
                    rootGameMsgDialog.callback(code, rootGameMsgDialog);
                else {  // if(rootGameMsgDialog.callback === true) {   //默认回调函数
                    //gameMap.focus = true;

                    rootGameMsgDialog.visible = false;


                    /*/*if(rootGameMsgDialog.bPauseGame && _private.config.bPauseGame) {
                        game.goon();
                        rootGameMsgDialog.bPauseGame = false;
                    }* /*/

                    /*if(_private.config.objPauseNames['$msg'] !== undefined) {
                        game.goon('$msg');
                        _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                    }*/



                    rootGameMsgDialog.destroy();
                    ////FrameManager.goon();
                }
            }

            function stop(type=0) {
                messageGame.stop(type);
            }

            function show(msg, pretext, interval, keeptime, style) {

                let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$msg') || {};
                let styleSystem = game.$gameMakerGlobalJS.$config.$styles.$msg;

                messageGame.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
                messageGame.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
                messageGame.textArea.font.pointSize = style.FontSize || styleUser.$fontSize || styleSystem.$fontSize;
                messageGame.textArea.font.color = style.FontColor || styleUser.$fontColor || styleSystem.$fontColor;
                maskMessageGame.color = style.MaskColor || styleUser.$maskColor || styleSystem.$maskColor;
                let type = GlobalLibraryJS.shortCircuit(0b1, style.Type, styleUser.$type, styleSystem.$type);

                //-1：即点即关闭；0：等待显示完毕(需点击）；>0：显示完毕后过keeptime毫秒自动关闭（不需点击）；
                rootGameMsgDialog.nKeepTime = keeptime || 0;

                rootGameMsgDialog.nShowStatus = 1;



                rootGameMsgDialog.visible = true;
                //touchAreaGameMsg.enabled = false;
                messageGame.show(GlobalLibraryJS.convertToHTML(msg), GlobalLibraryJS.convertToHTML(pretext), interval, rootGameMsgDialog.nKeepTime, type);
                //FrameManager.wait(-1);
            }

            function clicked() {
                //显示完毕，则关闭
                if(rootGameMsgDialog.nShowStatus === 0)
                    rootGameMsgDialog.over(1);
                //如果正在显示，且nKeepTime为-1（表示点击后显示全部）；
                else if(rootGameMsgDialog.nShowStatus === 1 && rootGameMsgDialog.nKeepTime === -1) {
                    rootGameMsgDialog.nShowStatus = 0;
                    messageGame.stop(1);
                }
            }


            visible: false
            anchors.fill: parent
            //z: 0


            Mask {
                id: maskMessageGame

                anchors.fill: parent

                visible: color.a !== 0

                color: "#7FFFFFFF"

                mouseArea.onPressed: {
                    rootGameMsgDialog.clicked();
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
                    rootGameMsgDialog.clicked();
                    //rootGameScene.forceActiveFocus();
                }

                onS_over: {
                    //自动关闭
                    if(rootGameMsgDialog.nKeepTime > 0)
                        rootGameMsgDialog.over(2);
                    else
                        rootGameMsgDialog.nShowStatus = 0;
                }
            }


            /*MultiPointTouchArea {
                id: touchAreaGameMsg
                anchors.fill: parent
                //enabled: rootGameMsgDialog.standardButtons === Dialog.NoButton
                enabled: false

                //onPressed: {
                onReleased: {
                    //rootGameScene.forceActiveFocus();
                    //显示完毕，则关闭
                    if(rootGameMsgDialog.nShowStatus === 0)
                        rootGameMsgDialog.over();
                    //如果正在显示，且nKeepTime为-1（表示点击后显示全部）；
                    else if(rootGameMsgDialog.nShowStatus === 1 && rootGameMsgDialog.nKeepTime === -1) {
                        rootGameMsgDialog.nShowStatus = 0;
                        messageGame.stop(1);
                    }
                }
            }*/

        }

    }


    //游戏菜单
    Component {
        id: compGameMenu

        //游戏 选择框
        Item {
            id: rootGameMenu


            //第几个Menu
            property int nIndex
            property var callback   //点击后的回调函数，true为缺省

            property alias maskMenu: maskMenu
            property alias menuGame: menuGame


            //signal s_Choice(int index)


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

                    //radius: rootGameMenu.radius

                    width: parent.width
                    height: parent.height

                    colorTitleColor: "#EE00CC99"
                    strTitle: ''

                    //height: parent.height / 2
                    //anchors.centerIn: parent

                    onS_Choice: {

                        if(GlobalLibraryJS.isFunction(rootGameMenu.callback))
                            rootGameMenu.callback(index, rootGameMenu);
                        else if(rootGameMenu.callback === true) {   //默认回调函数
                            //gameMap.focus = true;

                            rootGameMenu.visible = false;
                            //menuGame.hide();



                            rootGameMenu.destroy();
                            //FrameManager.goon();
                            //console.debug("!!!asyncScript.run", index);
                        }
                    }
                }
            }
        }
    }


    //游戏按键
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


    //角色
    Component {
        id: compRole

        Role {
            id: rootRole

            //头顶消息
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

            //名字
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
                text: (rootRole.$data && rootRole.$data.$name) ? rootRole.$data.$name : ''
                wrapMode: Text.NoWrap
            }

            //属性
            //property int $index: -1
            //property string $id: ''

            //自定义属性（系统包含一些常用属性，比如$id、$index、$name、$showName、$avatar、$avatarSize等）
            property var $data: null
            //property string $name: ''
            //property string $avatar: ''
            //property size $avatarSize: Qt.size(0, 0)
            property int $type: -1  //角色类型（1为主角，2为NPC）

            //其他属性（用户自定义）
            property var $props: ({})

            //依附在角色上的图片和特效
            property var $components: []


            //在场景中的坐标
            readonly property int sceneX: x + itemContainer.x
            readonly property int sceneY: y + itemContainer.y


            //行动类别；
            //0为停止；1为正常行走；2为动向移动；10为摇杆行走；-1为禁止操作
            property int nActionType: 1

            //目标坐标
            property var targetsPos: []

            //状态持续时间
            property int nActionStatusKeepTime: 0

            //保存上个Interval碰撞的角色名（包含主角）
            property var $$collideRoles: ({})

            property var $$mapEventsTriggering: ({})    //保存正在触发的地图事件


            //返回各种坐标
            function pos(tPos) {
                return game.rolepos(rootRole, tPos);
            }

            //返回方向
            //0、1、2、3分别表示上右下左；
            function direction() {
                switch(moveDirection) {
                case Qt.Key_Up:
                    return 0;
                case Qt.Key_Right:
                    return 1;
                case Qt.Key_Down:
                    return 2;
                case Qt.Key_Left:
                    return 3;
                }
                return -1;
            }


            z: y + y1

            //x、y是 图片 在 地图 中的坐标；
            //占位坐标：x + x1；y + y1
            //在 场景 中的 占位坐标：x + x1 + itemContainer.x
            //x: 180
            //y: 100
            //width: 50
            //height: 100


            sprite.animatedsprite.smooth: GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$role', '$smooth'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$role', '$smooth'), true)
            actionSprite.animatedsprite.smooth: GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$role', '$smooth'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$role', '$smooth'), true)


            //spriteSrc: "./Role2.png"
            //sizeFrame: Qt.size(32, 48)
            //nFrameCount: 4
            //arrFrameDirectionIndex: [[0,3],[0,2],[0,0],[0,1]]


            function action(tsprite) {
                GameSceneJS.loadSpriteEffect(tsprite.RId, rootRole.actionSprite, tsprite.$loops);
                if(GlobalLibraryJS.isValidNumber(tsprite.width))
                    rootRole.actionSprite.width = tsprite.width;
                if(GlobalLibraryJS.isValidNumber(tsprite.height))
                    rootRole.actionSprite.height = tsprite.height;
                rootRole.actionSprite.x = tsprite.x || 0;
                rootRole.actionSprite.y = tsprite.y || 0;
                rootRole.actionSprite.playAction();
            }


            mouseArea.onClicked: {
                GameSceneJS.roleClickEvent(rootRole, mouse.x, mouse.y);
            }


            Component.onCompleted: {
                //console.debug("[GameScene]Role Component.onCompleted");
            }
        }

    }

    Component {
        id: compCacheSoundEffect
        /*SoundEffect { //wav格式，实时性高
            property bool isPlaying: playing
        }*/
        Audio { //支持各种格式
            property bool isPlaying: playbackState === Audio.PlayingState
            onPlaying: {
            }
            onStopped: {
            }
            onPaused: {
            }
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
                acceptedButtons: Qt.AllButtons  /*Qt.LeftButton | Qt.RightButton*/
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

            animatedsprite.smooth: GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$spriteEffect', '$smooth'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$spriteEffect', '$smooth'), true)


            MouseArea {
                anchors.fill: parent
                enabled: true;
                acceptedButtons: Qt.AllButtons  /*Qt.LeftButton | Qt.RightButton*/
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



    /*  限制挺多：1、workerScript.sendMessage 只能一个参数，且只能传递一些数据，函数不能传递；
    WorkerScript {
        id: workerScriptWalk
        source: 'computeWalkPath.mjs'

        onMessage: {
            console.warn('Worker')
        }
    }
    mjs文件内容：
    WorkerScript.onMessage = function(message) {
        // ... long-running operations and calculations are done here
        WorkerScript.sendMessage({ 'ret': 666});
    }
    */



    Connections {
        target: Qt.application
        function onStateChanged() {
            switch(Qt.application.state){
            case Qt.ApplicationActive:   //每次窗口激活时触发
                _private.keys = {};
                //mainRole.moveDirection = -1;

                itemBackgroundMusic.resume('$sys_inactive');
                rootSoundEffect.resume('$sys_inactive');

                break;
            case Qt.ApplicationInactive:    //每次窗口非激活时触发
                _private.keys = {};
                //mainRole.moveDirection = -1;

                itemBackgroundMusic.pause('$sys_inactive');
                rootSoundEffect.pause('$sys_inactive');

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
        mainRole = compRole.createObject(itemRoleContainer);
        mainRole.sprite.s_playEffect.connect(rootSoundEffect.playSoundEffect);
        mainRole.actionSprite.s_playEffect.connect(rootSoundEffect.playSoundEffect);


        //console.debug("[GameScene]globalObject：", FrameManager.globalObject().game);

        FrameManager.globalObject().game = game;
        FrameManager.globalObject().g = game;
        //FrameManager.globalObject().g = g;

        //console.debug("[GameScene]globalObject：", FrameManager.globalObject().game);

        console.debug("[GameScene]Component.onCompleted");
    }

    Component.onDestruction: {
        //release();

        delete FrameManager.globalObject().game;
        delete FrameManager.globalObject().g;

        console.debug("[GameScene]Component.onDestruction");
    }
}
