import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.0
import QtMultimedia 5.14
import Qt.labs.settings 1.1


//引入Qt定义的类
import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


//import RPGComponents 1.0
import 'RPGComponents'


import 'qrc:/QML'


import 'GameMakerGlobal.js' as GameMakerGlobalJS

import 'GameScene.js' as GameSceneJS
//import 'File.js' as File



/*鹰：
  技术：
    1、防止多个键按下后释放一个出现不走问题：
        把所有按下的键都保存到一个Object中，释放一个删除一个，然后弹出下一个键（方向）
    2、event.isAutoRepeat
        第一次按返回false，长按会一直返回true
    3、防止Canvas闪烁，openMap时隐藏，绘制完成后显示：
        itemViewPort.itemBackMapContainer.visible = false;
        itemViewPort.itemFrontMapContainer.visible = false;
        角色增删也必须设置为这样（要加入map和role全部初始化完毕）

    4、缩放：将地图块大小更改即可；
    5、障碍判断：人物所占地图块和障碍地图块比较；
      角色障碍判断：两个矩形重叠算法；

    gameScene是视窗，itemContainer是整个地图、特效的容器，角色移动时，itemContainer也在移动，一直会将角色移动在最中央。


  说明：占用的全局属性、事件和定时器：
    game.addtimer('$sys_random_fight_timer', 1000, -1, true)：战斗定时
    game.gf['$sys_random_fight_timer']：战斗事件
    //game.addtimer('resume_event', 1000, -1, true)：恢复定时
    //game.gf['resume_timer']：恢复事件

    game.gd['$sys_fight_heros']：我方所有战斗人员列表
    //game.gd['$sys_hidden_fight_heros']：我方所有隐藏了的战斗人员列表
    game.gd['$sys_money']: 金钱
    game.gd['$sys_goods']: 道具道具 列表（存的是{$rid: goodsRID, $count: count}）
    game.gd['$sys_map']、game.d['$sys_map']: 当前地图信息
    game.gd['$sys_fps']: 当前FPS
    game.gd['$sys_main_roles']: 当前主角列表，保存了主角属性（{$rid、$id、$name、$index、$showName、$scale、$speed、$avatar、$avatarSize、$x、$y 等}）
    game.gd['$sys_music']: 当前播放的音乐名
    game.gd['$sys_sound']: 从右到左：音乐、音效 播放状态
    game.gd['$sys_scale']: 当前缩放大小
    game.gd['$sys_random_fight']：随机战斗

    _private.objCommonScripts['game_start'] = *$start;
    _private.objCommonScripts['game_init'] = tCommoncript.$gameInit;
    _private.objCommonScripts['game_release'] = tCommoncript.$gameRelease;
    _private.objCommonScripts['before_save'] = tCommoncript.$beforeSave;
    _private.objCommonScripts['before_load'] = tCommoncript.$beforeLoad;
    _private.objCommonScripts['after_save'] = tCommoncript.$afterSave;
    _private.objCommonScripts['after_load'] = tCommoncript.$afterLoad;
    _private.objCommonScripts['combatant_class'] = tCommoncript.$Combatant;
    _private.objCommonScripts['refresh_combatant'] = tCommoncript.$refreshCombatant;
    _private.objCommonScripts['combatant_is_valid'] = tCommoncript.$combatantIsValid;
    _private.objCommonScripts['check_all_combatants'] = tCommoncript.$checkAllCombatants;
    _private.objCommonScripts['fight_skill_algorithm']：战斗算法
    _private.objCommonScripts['fight_role_choice_skills_or_goods_algorithm']：战斗人物选择技能或物品算法
    _private.objCommonScripts['game_over_script'];   //游戏结束脚本
    _private.objCommonScripts['common_run_away_algorithm']：逃跑算法
    _private.objCommonScripts['fight_start_script']：战斗开始通用脚本
    _private.objCommonScripts['fight_round_script']：战斗回合通用脚本
    _private.objCommonScripts['fight_end_script']：战斗结束通用脚本（升级经验、获得金钱）
    _private.objCommonScripts['fight_combatant_position_algorithm']：//获取 某战斗角色 中心位置
    _private.objCommonScripts['fight_combatant_melee_position_algorithm']：//战斗角色近战 坐标
    _private.objCommonScripts['fight_skill_melee_position_algorithm']//特效在战斗角色的 坐标
    _private.objCommonScripts['fight_combatant_set_choice'] //设置 战斗人物的 初始化 或 休息
    _private.objCommonScripts['fight_menus']//战斗菜单
    //_private.objCommonScripts['resume_event_script']
    //_private.objCommonScripts['get_goods_script']
    //_private.objCommonScripts['use_goods_script']
    _private.objCommonScripts['fight_roles_round']   //一个大回合内 每次返回一个战斗人物的回合
    _private.objCommonScripts['combatant_info']
    _private.objCommonScripts['show_goods_name']
    _private.objCommonScripts['show_combatant_name']
    _private.objCommonScripts['common_check_skill']
    _private.objCommonScripts['combatant_round_script']
    //_private.objCommonScripts['events']


    //_private.objCommonScripts['levelup_script']：升级脚本（经验等条件达到后升级和结果）
    //_private.objCommonScripts['level_Algorithm']：升级算法（直接升级对经验等条件的影响）

*/



Item {
    id: rootGameScene


    //关闭退出
    signal s_close();



    //游戏初始化脚本
    //startScript为true，则载入start.js；为函数/生成器，则直接运行startScript；为false则不执行；
    //bLoadResources为是否载入资源（刚进入游戏时为true，其他情况比如读档为false，gameData为读档的数据）
    //必须用yield标记来让它运行完毕（第一次使用则不必）
    function init(startScript=true, bLoadResources=true, gameData=null) {

        //console.debug(_private.asyncScript.getGeneratorScriptArray().toJson());
        _private.asyncScript.clear(0);
        //console.debug(_private.asyncScript.getGeneratorScriptArray().toJson());


        //asyncScript.runNextEventLoop('init');


        //！！！鹰：注意：load是异步调用；且将 Priority 设置为顺序的（保证 game.load 的所有异步脚本执行完毕 再执行 game.load 的下一个命令）
        //let priority = 0;


        game.run(_init);
    }

    function *_init(startScript=true, bLoadResources=true, gameData=null) {

        //game.run(function*() {

        game.gd['$sys_fight_heros'] = [];
        //game.gd['$sys_hidden_fight_heros'] = [];
        game.gd['$sys_money'] = 0;
        game.gd['$sys_goods'] = [];
        game.gd['$sys_map'] = {};
        game.gd['$sys_fps'] = 16;
        game.gd['$sys_main_roles'] = [];
        game.gd['$sys_sound'] = 0b11;
        game.gd['$sys_music'] = '';
        game.gd['$sys_scale'] = 1;


        if(bLoadResources)
            yield *GameSceneJS.loadResources();


        //game.gf['$sys'] = _private.objCommonScripts;


        //恢复游戏数据
        if(gameData)
            GlobalLibraryJS.copyPropertiesToObject(game.gd, gameData);


        //计算新属性
        for(let tfh of game.gd['$sys_fight_heros'])
            _private.objCommonScripts['refresh_combatant'](tfh);
        //刷新战斗时人物数据
        //fight.$sys.refreshCombatant(-1);



        if(_private.objCommonScripts['game_init']) {
            //game.run([_private.objCommonScripts['game_init'](bLoadResources) ?? null, 'game_init'],
            //    {Priority: priority++, Type: 0, Running: 1});
            let r = _private.objCommonScripts['game_init'](bLoadResources);
            if(GlobalLibraryJS.isGenerator(r))yield *r;
        }


        //所有插件初始化
        for(let tc in _private.objPlugins)
            for(let tp in _private.objPlugins[tc])
                if(_private.objPlugins[tc][tp].$init && _private.objPlugins[tc][tp].$autoLoad !== false) {
                    //console.warn(_private.objPlugins[tc][tp].$init)
                    //_private.objPlugins[tc][tp].$init();
                    let r = _private.objPlugins[tc][tp].$init();
                    if(GlobalLibraryJS.isGenerator(r))yield *r;
                }


        //钩子函数调用
        for(let vfInit in game.$sys.hooks.init) {
            let r = game.$sys.hooks.init[vfInit](bLoadResources);
            if(GlobalLibraryJS.isGenerator(r))yield *r;
        }


        //game.pause();
        game.goon('$release');


        //game.run(function*() {
        //读取 start.js 脚本
        if(startScript === true) {
            /*
            let filePath = game.$projectpath + GameMakerGlobal.separator + 'start.js';
            //let cfg = File.read(filePath);
            let data = FrameManager.sl_qml_ReadFile(GlobalJS.toPath(filePath));
            //if(!data)
            //    return false;
            if(GlobalJS.createScript(_private.asyncScript, 0, 0, eval(data)) === 0)
                _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
            */

            if(_private.objCommonScripts['game_start']) {
                game.run(function*() {
                    let r = _private.objCommonScripts['game_start']();
                    if(GlobalLibraryJS.isGenerator(r))yield *r;
                }, {Tips: 'start'});
            }
        }
        else if(startScript === false) {
        }
        else if(startScript === null) {
        }
        else {  //是脚本
            game.run(function*() {
                let r = startScript();
                if(GlobalLibraryJS.isGenerator(r))yield *r;
            }, {Tips: 'start'});
        }

        //}, {Tips: 'start'});


        //}, {Priority: -2, Type: 0, Running: 1, Tips: 'init'});



        //进游戏时如果设置了屏幕旋转，则x、y坐标会互换导致出错，所以重新刷新一下屏幕；
        //!!!屏幕旋转会导致 itemContainer 的x、y坐标互换!!!???
        //GlobalLibraryJS.setTimeout(function() {
        //        setSceneToRole(_private.sceneRole);
        //    },10,rootGameScene
        //);
    }



    //释放所有资源
    //必须用yield标记来让它运行完毕
    function *release(bUnloadResources=true) {
        //asyncScript.runNextEventLoop('release');


        //！！！鹰：注意：load是异步调用；且将 Priority 设置为顺序的（保证 game.load 的所有异步脚本执行完毕 再执行 game.load 的下一个命令）
        //let priority = 0;

        //game.run(function*(){
            //timer.stop();
            _private.config.objPauseNames = {};
            game.pause('$release');


            //钩子函数调用
            for(let vfRelease in game.$sys.hooks.release) {
                let r = game.$sys.hooks.release[vfRelease](bUnloadResources);
                if(GlobalLibraryJS.isGenerator(r))yield *r;
            }


            //所有插件释放
            for(let tc in _private.objPlugins)
                for(let tp in _private.objPlugins[tc])
                    if(_private.objPlugins[tc][tp].$release && _private.objPlugins[tc][tp].$autoLoad !== false) {
                        //_private.objPlugins[tc][tp].$release();
                        let r = _private.objPlugins[tc][tp].$release();
                        if(GlobalLibraryJS.isGenerator(r))yield *r;
                    }


            if(_private.objCommonScripts['game_release']) {
                let r = _private.objCommonScripts['game_release'](bUnloadResources);
                if(GlobalLibraryJS.isGenerator(r))yield *r;
            }


            game.scale(1);

            //！！不能清空事件队列，因为有可能 game.load() 调用后下面还有其他代码！！
            //_private.asyncScript.clear(4);
            //_private.asyncScript.run(_private.asyncScript.lastEscapeValue);

            //loaderGameMsg.item.stop();
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

            //loaderGameMsg.item.visible = false;
            itemGameMsgs.nIndex = 0;
            for(let tim in itemGameMsgs.children) {
                itemGameMsgs.children[tim].destroy();
            }

            itemRootRoleMsg.visible = false;
            itemRootGameInput.visible = false;

            itemGameMenus.nIndex = 0;
            for(let tim in itemGameMenus.children) {
                itemGameMenus.children[tim].destroy();
            }

            //itemMenu.visible = false;
            //menuGame.hide();


            game.d = {};
            game.f = {};
            game.gd = {};
            game.gf = {};




            _private.objRoles = {};
            _private.arrMainRoles = [];
            _private.objTmpComponents = {};


            _private.objTimers = {};
            _private.objGlobalTimers = {};


            _private.sceneRole = mainRole;
            mainRole.$$collideRoles = {};
            mainRole.$$mapEventsTriggering = {};


            _private.nStage = 0;


            loaderFightScene.visible = false;


            itemViewPort.release();


            if(bUnloadResources)
                yield *GameSceneJS.unloadResources();
        //}, {Priority: -2, Type: 0, Running: 1, Tips: 'release'});



        //console.debug(_private.asyncScript.getGeneratorScriptArray().toJson());
        //_private.asyncScript.clear(0);
        ///_private.asyncScript.clear(4);
        //console.debug(_private.asyncScript.getGeneratorScriptArray().toJson());
    }


    function updateAllRolesPos() {

    }



    //设置角色坐标（块坐标）
    function setRolePos(bx, by, role) {
        if(!itemViewPort.mapInfo)
            return false;


        let targetX;
        let targetY;
        [targetX, targetY] = itemViewPort.getMapBlockPos(bx, by);

        //设置角色坐标

        //如果在最右边的图块，且人物宽度超过图块，则会超出地图边界
        if(bx === itemViewPort.mapInfo.MapSize[0] - 1 && role.width1 > itemViewPort.sizeMapBlockScaledSize.width)
            role.x = itemViewPort.itemContainer.width - role.x2 - 1;
        else
            role.x = targetX - role.x1 - role.width1 / 2;
        //role.x = bx * itemViewPort.sizeMapBlockScaledSize.width - role.x1;

        //如果在最下边的图块，且人物高度超过图块，则会超出地图边界
        if(by === itemViewPort.mapInfo.MapSize[1] - 1 && role.height1 > itemViewPort.sizeMapBlockScaledSize.height)
            role.y = itemViewPort.itemContainer.height - role.y2 - 1;
        else
            role.y = targetY - role.y1 - role.height1 / 2;
        //role.y = by * itemViewPort.sizeMapBlockScaledSize.height - role.y1;

        if(role === _private.sceneRole)setSceneToRole(_private.sceneRole);


        return true;
    }

    //设置主角坐标（块坐标）
    function setMainRolePos(bx, by, index=0) {
        let mainRole = _private.arrMainRoles[index];

        if(mainRole === undefined)
            return false;

        setRolePos(bx, by, mainRole);
        //setSceneToRole(_private.sceneRole);
        if(mainRole === _private.sceneRole)setSceneToRole(_private.sceneRole);

        game.gd['$sys_main_roles'][index].$x = mainRole.x;
        game.gd['$sys_main_roles'][index].$y = mainRole.y;
    }

    //场景移动到某角色
    function setSceneToRole(role) {
        if(!role)
            return;

        //计算角色移动时，地图移动的 左上角和右下角 的坐标

        //场景在地图左上角时的中央坐标
        let mapLeftTopCenterX = parseInt(itemViewPort.gameScene.nMaxMoveWidth / 2);
        let mapLeftTopCenterY = parseInt(itemViewPort.gameScene.nMaxMoveHeight / 2);

        //场景在地图右下角时的中央坐标
        let mapRightBottomCenterX = itemViewPort.itemContainer.width - mapLeftTopCenterX;
        let mapRightBottomCenterY = itemViewPort.itemContainer.height - mapLeftTopCenterY;

        //角色最中央坐标
        let roleCenterX = role.x + role.x1 + parseInt(role.width1 / 2);
        let roleCenterY = role.y + role.y1 + parseInt(role.height1 / 2);

        //开始移动地图

        itemViewPort.setScenePos(roleCenterX, roleCenterY);
    }



    //property alias g: rootGameScene.game
    property QtObject game: QtObject {

        //载入地图并执行地图载入事件；成功返回 true（生成器返回 地图信息）。
        //userData是用户传入数据，后期调用的钩子函数会传入；
        //forceRepaint表示是否强制重绘（为false时表示如果mapRID与现在的相同，则不重绘）；
        readonly property var loadmap: function*(mapRID, userData, forceRepaint=false) {

            if(!mapRID) {
                //asyncScript.runNextEventLoop('loadmap');
                console.exception('[!GameScene]loadmap Fail:', mapRID);
                return false;
            }


            //！！！鹰：注意：loadmap是异步调用；且将 Priority 设置为顺序的（保证 game.loadmap 的所有异步脚本执行完毕 再执行 game.loadmap 的下一个命令）
            //let priority = 0;


            //game.run(function*() {

            //执行之前地图的 $end 函数
            if(game.d['$sys_map'] && game.d['$sys_map'].$name) {
                let ts = _private.jsEngine.load('map.js', GlobalJS.toURL(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + game.d['$sys_map'].$name));
                if(ts.$end) {
                    let r = ts.$end(userData);
                    if(GlobalLibraryJS.isGenerator(r))yield *r;
                    //game.run(ts.$end(userData) ?? null, {Priority: priority++, Type: 0, Running: 1, Tips: 'map $end'});
                }
            }


            //清理工作

            timer.running = false;


            for(let tc in _private.objTmpMapComponents) {
                let c = _private.objTmpMapComponents[tc];
                if(GlobalLibraryJS.isComponent(c)) {
                    if(c.Destroy)
                        c.Destroy();
                    else if(c.destroy)
                        c.destroy();
                }
            }
            _private.objTmpMapComponents = [];

            game.delrole(-1);

            _private.objTimers = {};

            mainRole.$$collideRoles = {};
            mainRole.$$mapEventsTriggering = {};
            _private.stopMove(0);

            game.d = {};
            game.f = {};


            //载入beforeLoadmap脚本
            let beforeLoadmap = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$beforeLoadmap'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$beforeLoadmap'));
            if(beforeLoadmap) {
                let r = beforeLoadmap(mapRID, userData);
                if(GlobalLibraryJS.isGenerator(r))yield *r;
                //game.run(beforeLoadmap(mapRID, userData) ?? null, {Priority: priority++, Type: 0, Running: 1, Tips: 'beforeLoadmap'});
            }


            let mapInfo = GameSceneJS.openMap(mapRID, forceRepaint);

            setSceneToRole(_private.sceneRole);


            //载入地图会卡顿，重新开始计时会顺滑一点
            timer.running = true;
            timer.nLastTime = 0;


            let priority = 0;


            if(itemViewPort.mapScript.$start) {
                let r = itemViewPort.mapScript.$start(userData);
                if(GlobalLibraryJS.isGenerator(r))yield *r;
                //game.run([itemViewPort.mapScript.$start(userData) ?? null, 'map $start'], {Priority: priority++, Type: 0, Running: 1});
            }
            else if(itemViewPort.mapScript.start) {
                let r = itemViewPort.mapScript.start(userData);
                if(GlobalLibraryJS.isGenerator(r))yield *r;
                //game.run([itemViewPort.mapScript.start(userData) ?? null, 'map start'], {Priority: priority++, Type: 0, Running: 1});
            }


            //载入after_loadmap脚本
            let afterLoadmap = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$afterLoadmap'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$afterLoadmap'));
            if(afterLoadmap) {
                let r = afterLoadmap(mapRID, userData);
                if(GlobalLibraryJS.isGenerator(r))yield *r;
                //game.run([afterLoadmap(mapRID, userData) ?? null, 'afterLoadmap'], {Priority: priority++, Type: 0, Running: 1});
            }


            return mapInfo;

            //}, {Priority: -2, Type: 0, Running: 1, Tips: 'map load'});
            //return true;
        }

        /*readonly property var map: {
            name: ''
        }*/

        //在屏幕中间显示提示信息。
        //interval为文字显示间隔，为0则不使用；
        //pretext为预显示的文字；
        //keeptime：如果为-1，表示点击后对话框会立即显示全部，为0表示等待显示完毕，为>0表示显示完毕后再延时KeepTime毫秒然后自动消失；
        //style为样式；
        //  如果为数字，则含义为Type，表示自适应宽高（0b1为宽，0b10为高），否则固定大小；
        //  如果为对象，则可以修改BackgroundColor、BorderColor、FontSize、FontColor、MaskColor、Type）；
        //    分别表示 背景色、边框色、字体颜色、字体大小、遮盖色、自适应类型、持续时间；
        //pauseGame为是否暂停游戏；值为true、false或字符串。如果为true或字符串则表示需要暂停等待结束，命令建议用yield关键字修饰；如果为false，则尽量不要用yield关键字；
        //callback是结束时回调函数，默认为true（系统自动处理）；
        //  如果是普通函数且返回不为true，则仍然调用系统定义的回调函数；
        //  如果是生成器（函数），则先调用系统定义的回调函数，再将生成器（函数）放入事件队列中运行；
        //buttonNum为按钮数量（0-2，目前没用）。
        //返回组件对象；
        readonly property var msg: function(msg='', interval=20, pretext='', keeptime=0, style={Type: 0b10}, pauseGame=true/*, buttonNum=0*/, callback=true) {

            let itemGameMsg = compGameMsg.createObject(itemGameMsgs, {nIndex: itemGameMsgs.nIndex});


            //按钮数
            //buttonNum = parseInt(buttonNum);

            /*if(buttonNum === 1)
                loaderGameMsg.standardButtons = Dialog.Ok;
            else if(buttonNum === 2)
                loaderGameMsg.standardButtons = Dialog.Ok | Dialog.Cancel;
            else
                loaderGameMsg.standardButtons = Dialog.NoButton;
            */


            ++itemGameMsgs.nIndex;


            //如果为null，则返回 组件，用户自己配置并调用show
            if(msg !== true) {
                itemGameMsg.show(msg.toString(), interval, pretext.toString(), keeptime, style, pauseGame, callback);
            }
            //loaderGameMsg.item.fCallback = callback;
            //loaderGameMsg.item.show(msg.toString(), pretext.toString(), interval, keeptime, style);


            return itemGameMsg;
        }

        //在屏幕下方显示对话信息。
        //interval为文字显示间隔，为0则不使用；
        //pretext为预显示的文字；
        //keeptime：如果为-1，表示点击后对话框会立即显示全部，为0表示等待显示完毕，为>0表示显示完毕后再延时KeepTime然后自动消失；
        //style为样式，包括BackgroundColor、BorderColor、FontSize、FontColor、MaskColor、Name、Avatar）；
        //  分别表示 背景色、边框色、字体颜色、字体大小、遮盖色、自适应类型、持续时间、是否显示名字、是否显示头像；
        //pauseGame同msg的参数；
        //callback同msg的参数；
        //返回组件对象；
        readonly property var talk: function(role=null, msg='', interval=20, pretext='', keeptime=0, style=null, pauseGame=true, callback=true) {

            if(role !== true)
                itemRootRoleMsg.show(role, msg.toString(), interval, pretext.toString(), keeptime, style, pauseGame, callback);


            return itemRootRoleMsg;
        }

        //角色头顶显示文字信息。
        //interval为文字显示间隔，为0则不使用；
        //pretext为预显示的文字；
        //keeptime：如果为-1，表示点击后对话框会立即显示全部，为0表示等待显示完毕，为>0表示显示完毕后再延时KeepTime然后自动消失；
        //style为样式；
        //  如果为对象，则可以修改BackgroundColor、BorderColor、FontSize、FontColor）；
        //      分别表示 背景色、边框色、字体颜色、字体大小；
        //返回角色组件对象；
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
            role.message.textArea.color = style.FontColor || styleUser.$fontColor || styleSystem.$fontColor;

            //role.message.visible = true;
            role.message.show(GlobalLibraryJS.convertToHTML(msg.toString()), GlobalLibraryJS.convertToHTML(pretext.toString()), interval, keeptime, 0b11);


            return role;
        }


        //显示一个菜单；
        //title为显示文字；
        //items为选项数组；
        //style为样式，包括MaskColor、BorderColor、BackgroundColor、ItemFontSize、ItemFontColor、ItemBackgroundColor1、ItemBackgroundColor2、TitleFontSize、TitleBackgroundColor、TitleFontColor、ItemBorderColor、ItemHeight、TitleHeight；
        //pauseGame同msg的参数；
        //callback同msg的参数；
        //返回组件对象；
        //注意：该脚本必须用yield才能暂停并接受返回值；返回值为选择的下标（0开始）。
        readonly property var menu: function(title='', items=[], style={}, pauseGame=true, callback=true) {

            let itemMenu = compGameMenu.createObject(itemGameMenus, {nIndex: itemGameMenus.nIndex});
            //let maskMenu = itemMenu.maskMenu;
            //let menuGame = itemMenu.menuGame;

            /*itemMenu.s_Choice.connect(function(index) {
            });*/


            ++itemGameMenus.nIndex;

            if(title !== true)
                itemMenu.show(title, items, style, pauseGame, callback);

            return itemMenu;
        }

        //显示一个输入框；
        //title为显示文字；
        //pretext为预设文字；
        //style为自定义样式；
        //pauseGame同msg的参数；
        //callback同msg的参数；
        //返回组件对象；
        //注意：该脚本必须用yield才能暂停并接受返回值；返回值为输入值。
        readonly property var input: function(title='', pretext='', style={}, pauseGame=true, callback=true) {

            if(title !== true)
                itemRootGameInput.show(title, pretext, style, pauseGame, callback);


            return itemRootGameInput;
        }


        //创建主角；
        //role：角色资源名 或 标准创建格式的对象（RID为角色资源名）。
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
                role = {RID: role, $id: role, $name: role};
            }
            role.$rid = role.RID ?? role.RId;
            role.$type = 1;
            if(!role.$id) {
                if(role.$name)
                    role.$id = role.$name;
                else
                    role.$id = role.$rid + GlobalLibraryJS.randomString(6, 6, '0123456789');
            }
            if(!role.$name) {
                role.$name = role.$rid;
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


            let roleComp = GameSceneJS.loadRole(role.$rid, mainRole, role, itemViewPort.itemRoleContainer);
            if(!roleComp) {
                return false;
            }


            //let role = compRole.createObject(itemViewPort.itemRoleContainer);

            roleComp.$data = role;
            roleComp.$$type = 1;
            //roleComp.$id = role.$id;
            //roleComp.$index = index;

            roleComp.visible = true;


            let index = 0;
            _private.arrMainRoles[index] = roleComp;


            //let trole = {$index: index, $x: mainRole.x, $y: mainRole.y};


            role.$index = index;
            role.$x = role.$x ?? roleComp.x;
            role.$y = role.$y ?? roleComp.y;

            role.$speed = role.$speed ?? parseFloat(roleComp.$info.MoveSpeed);
            role.$scale = role.$scale ?? [((roleComp.$info.Scale && roleComp.$info.Scale[0] !== undefined) ? roleComp.$info.Scale[0] : 1), ((roleComp.$info.Scale && roleComp.$info.Scale[1] !== undefined) ? roleComp.$info.Scale[1] : 1)];
            role.$avatar = role.$avatar || roleComp.$info.Avatar || '';
            role.$avatarSize = role.$avatarSize || [((roleComp.$info.AvatarSize && roleComp.$info.AvatarSize[0] !== undefined) ? roleComp.$info.AvatarSize[0] : 0), ((roleComp.$info.AvatarSize && roleComp.$info.AvatarSize[1] !== undefined) ? roleComp.$info.AvatarSize[1] : 0)];
            role.$showName = role.$showName ?? (isNaN(parseInt(roleComp.$info.ShowName)) ? 1 : parseInt(roleComp.$info.ShowName));
            role.$penetrate = role.$penetrate ?? (isNaN(parseInt(roleComp.$info.Penetrate)) ? 0 : parseInt(roleComp.$info.Penetrate));

            role.__proto__ = roleComp.$info;

            //GlobalLibraryJS.copyPropertiesToObject(trole, role, {objectRecursion: 0});

            if(game.gd['$sys_main_roles'][index] === undefined) {
                //roleComp.$name = role.$name;

            }
            //有数据，说明从存档已读取
            else {
                /*if(!game.gd['$sys_main_roles'][index].$scale)
                    game.gd['$sys_main_roles'][index].$scale = [];
                if(!game.gd['$sys_main_roles'][index].$avatarSize)
                    game.gd['$sys_main_roles'][index].$avatarSize = [];
                */

                GlobalLibraryJS.copyPropertiesToObject(role, game.gd['$sys_main_roles'][index], {objectRecursion: 0});
            }
            game.gd['$sys_main_roles'][index] = role;


            //if(role.$direction === undefined)
            //    role.$direction = 2;



            game.hero(index, role);


            //console.debug('[GameScene]createhero：roleComp：', JSON.stringify(roleComp.$info));


            return roleComp;
        }

        //返回/修改 主角对象；
        //hero可以是下标，或字符串（主角的$id），或主角对象，-1表示返回所有主角；
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



            hero = game.gd['$sys_main_roles'][index];
            let heroComp = _private.arrMainRoles[index];

            if(!GlobalLibraryJS.objectIsEmpty(props)) {
                //修改属性
                //GlobalLibraryJS.copyPropertiesToObject(hero, props, true);

                //!!!后期想办法把reset去掉
                //mainRole.reset();

                //GlobalLibraryJS.copyPropertiesToObject(hero, props, true);
                if(props.$name !== undefined)   //修改名字
                    hero.$name = heroComp.textName.text = props.$name;
                if(props.$showName !== undefined)   //修改名字
                    hero.$showName = heroComp.textName.visible = props.$showName;
                else if(props.$showName === false)
                    hero.$showName = heroComp.textName.visible = false;
                if(props.$penetrate !== undefined)   //可穿透
                    hero.$penetrate = /*heroComp.$penetrate = */props.$penetrate;
                if(props.$speed !== undefined)   //修改速度
                    hero.$speed = heroComp.$$speed = parseFloat(props.$speed);
                if(props.$scale && props.$scale[0] !== undefined) { //缩放
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


                //下面都是定向移动
                if(props.$targetBx !== undefined || props.$targetBy !== undefined) {
                    let tPos = itemViewPort.getMapBlockPos(props.$targetBx, props.$targetBy);
                    if(props.$targetBx === undefined)
                        tPos[0] = -1;
                    if(props.$targetBy === undefined)
                        tPos[1] = -1;
                    heroComp.$$targetsPos = [Qt.point(tPos[0], tPos[1])];
                }
                if(props.$targetX !== undefined || props.$targetY !== undefined) {
                    if(props.$targetX === undefined)
                        props.$targetX = -1;
                    if(props.$targetY === undefined)
                        props.$targetY = -1;
                    heroComp.$$targetsPos = [Qt.point(props.$targetX, props.$targetY)];
                }
                if(GlobalLibraryJS.isArray(props.$targetBlockAuto) && props.$targetBlockAuto.length === 2) {
                    let rolePos = heroComp.pos();
                    //heroComp.$$targetsPos = GameMakerGlobalJS.computePath([rolePos.bx, rolePos.by], [props.$targetBlockAuto[0], props.$targetBlockAuto[1]]);
                    props.$targetBlocks = GameMakerGlobalJS.computePath([rolePos.bx, rolePos.by], [props.$targetBlockAuto[0], props.$targetBlockAuto[1]]);
                }
                if(GlobalLibraryJS.isArray(props.$targetBlocks)) {
                    heroComp.$$targetsPos = [];
                    for(let targetBlock of props.$targetBlocks) {
                        let tPos = itemViewPort.getMapBlockPos(targetBlock[0], targetBlock[1]);
                        /*if(props.$targetBx === undefined)
                            tPos[0] = -1;
                        if(props.$targetBy === undefined)
                            tPos[1] = -1;
                            */
                        heroComp.$$targetsPos.push(Qt.point(tPos[0], tPos[1]));
                    }
                }
                if(GlobalLibraryJS.isArray(props.$targetPositions) && props.$targetPositions.length > 0) {
                    heroComp.$$targetsPos = props.$targetPositions;
                }

                if(props.$action !== undefined)
                    heroComp.$$nActionType = props.$action;

                //如果没有定向目标，则停止
                //if(heroComp.$$targetsPos.length === 0 && props.$action === 2)
                //    props.$action = 0;


                if(props.$x !== undefined)   //修改x坐标
                    hero.$x = heroComp.x = props.$x;
                if(props.$y !== undefined)   //修改y坐标
                    hero.$y = heroComp.y = props.$y;
                if(props.$x !== undefined || props.$y !== undefined)
                    if(heroComp === _private.sceneRole)setSceneToRole(_private.sceneRole);

                if(props.$bx || props.$by)
                    setMainRolePos(parseInt(props.$bx), parseInt(props.$by), hero.$index);


                //如果不是从 createhero 过来的（createhero过来的，hero和props是一个对象）
                if(props !== hero) {
                    //其他属性直接赋值
                    let usedProps = ['$name', '$showName', '$penetrate', '$speed', '$scale', '$avatar', '$avatarSize', '$targetBx', '$targetBy', '$targetX', '$targetY', '$targetBlocks', '$targetPositions', '$targetBlockAuto', '$action', '$x', '$y', '$bx', '$by', '$direction', '$realSize', '$start'];
                    //for(let tp in props) {
                    for(let tp of Object.keys(props)) {
                        if(usedProps.indexOf(tp) >= 0)
                            continue;
                        hero[tp] = props[tp];
                    }
                }


                if(props.$direction !== undefined)
                    heroComp.changeAction(props.$direction);
                    /*/貌似必须10ms以上才可以使其转向（鹰：使用AnimatedSprite就不用延时了）
                    GlobalLibraryJS.setTimeout(function() {
                            if(heroComp)
                                heroComp.start(props.$direction, null);
                        },20,rootGameScene
                    );*/

                if(props.$realSize !== undefined) {
                    heroComp.width1 = props.$realSize[0];
                    heroComp.height1 = props.$realSize[1];
                    //console.debug('!!!', props.$realSize)
                }
            }

            return heroComp;
        }

        //删除主角；
        //hero可以是下标，或主角的$id，或主角对象，-1表示所有主角；
        readonly property var delhero: function(hero=-1) {

            let tmpDelHero = function(mainRole) {
                mainRole.strSource = '';
                mainRole.nFrameCount = 0;
                mainRole.width = 0;
                mainRole.height = 0;
                mainRole.x1 = 0;
                mainRole.y1 = 0;
                mainRole.width1 = 0;
                mainRole.height1 = 0;
                mainRole.rXScale = 1;
                mainRole.rYScale = 1;
                //mainRole.moveSpeed = 0.1;
                //mainRole.$penetrate = 0;
                //mainRole.textName.text = '';
                mainRole.$data = null;
                //mainRole.$id = '';
                //mainRole.$name = '';
                //mainRole.$index = -1;
                //mainRole.$avatar = '';
                //mainRole.$avatarSize = Qt.size(0, 0);

                //其他属性（用户自定义）
                mainRole.$props = {};
                mainRole.reset();

                _private.stopMove(0);
            }


            if(hero === -1) {
                for(let tr of _private.arrMainRoles) {
                    //tr.destroy();
                    tr.visible = false;
                    tmpDelHero(mainRole);

                    for(let tc in tr.$tmpComponents) {
                        let c = tr.$tmpComponents[tc];
                        if(GlobalLibraryJS.isComponent(c)) {
                            if(c.Destroy)
                                c.Destroy();
                            else if(c.destroy)
                                c.destroy();
                        }
                    }
                    tr.$tmpComponents = {};
                }
                _private.arrMainRoles = [];
                game.gd['$sys_main_roles'] = [];

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
            for(let tc in _private.arrMainRoles[index].$tmpComponents) {
                let c = _private.arrMainRoles[index].$tmpComponents[tc];
                if(GlobalLibraryJS.isComponent(c)) {
                    if(c.Destroy)
                        c.Destroy();
                    else if(c.destroy)
                        c.destroy();
                }
            }
            _private.arrMainRoles[index].$tmpComponents = {};


            //!!!如果多个主角，需要修改这个代码!!!
            //_private.arrMainRoles[index].destroy();
            //delete _private.arrMainRoles[index];
            //delete game.gd['$sys_main_roles'][index];
            _private.arrMainRoles.splice(index, 1);
            game.gd['$sys_main_roles'].splice(index, 1);

            tmpDelHero(mainRole);

            //修正下标
            for(; index < game.gd['$sys_main_roles'].length; ++index) {
                game.gd['$sys_main_roles'][index].$index = index;
                //_private.arrMainRoles[index].$index = index;
            }


            return true;
        }

        //将主角移动到地图 bx、by 位置。
        readonly property var movehero: function(...args) {
            if(args.length === 3)
                setMainRolePos(args[1], args[2], args[0]);
            else if(args.length === 2)
                setMainRolePos(args[0], args[1]);
        }

        /*readonly property var movehero: function(bx, by, index=0) {

            if(index >= _private.arrMainRoles.length || index < 0)
                return false;

            let role = _private.arrMainRoles[index];

            setRolePos(bx, by, role);

            return true;
        }*/


        //创建NPC；
        //role：角色资源名 或 标准创建格式的对象（RID为角色资源名）。
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
                role = {RID: role, $id: role, $name: role};
            }
            role.$rid = role.RID ?? role.RId;
            role.$type = 2;
            if(!role.$id) {
                if(role.$name)
                    role.$id = role.$name;
                else
                    role.$id = role.$rid + GlobalLibraryJS.randomString(6, 6, '0123456789');
            }
            if(!role.$name) {
                role.$name = role.$rid;
            }


            if(_private.objRoles[role.$id] !== undefined)
                return false;


            let roleComp = GameSceneJS.loadRole(role.$rid, null, role, itemViewPort.itemRoleContainer);
            if(!roleComp) {
                return false;
            }


            roleComp.$data = role;
            roleComp.$$type = 2;
            //roleComp.$id = role.$id;


            _private.objRoles[role.$id] = roleComp;


            //roleComp.$name = role.$name;
            role.$speed = role.$speed ?? parseFloat(roleComp.$info.MoveSpeed);
            role.$scale = role.$scale ?? [((roleComp.$info.Scale && roleComp.$info.Scale[0] !== undefined) ? roleComp.$info.Scale[0] : 1), ((roleComp.$info.Scale && roleComp.$info.Scale[1] !== undefined) ? roleComp.$info.Scale[1] : 1)];
            role.$avatar = role.$avatar || roleComp.$info.Avatar || '';
            role.$avatarSize = role.$avatarSize || [((roleComp.$info.AvatarSize && roleComp.$info.AvatarSize[0] !== undefined) ? roleComp.$info.AvatarSize[0] : 0), ((roleComp.$info.AvatarSize && roleComp.$info.AvatarSize[1] !== undefined) ? roleComp.$info.AvatarSize[1] : 0)];
            role.$showName = role.$showName ?? (isNaN(parseInt(roleComp.$info.ShowName)) ? 1 : parseInt(roleComp.$info.ShowName));
            role.$penetrate = role.$penetrate ?? (isNaN(parseInt(roleComp.$info.Penetrate)) ? 0 : parseInt(roleComp.$info.Penetrate));

            role.__proto__ = roleComp.$info;

            //if(role.$direction === undefined)
            //    role.$direction = 2;



            game.role(roleComp, role);


            return roleComp;

        }

        //返回/修改 角色对象；
        //role可以是下标，或字符串（角色的$id），或角色对象，-1表示返回所有角色；
        //props：非返回所有角色时，为修改的 单个角色属性，同 createrole 的第二个参数；
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

                //!!!后期想办法把reset去掉
                //roleComp.reset();

                if(props.$name !== undefined)   //修改名字
                    role.$name = roleComp.textName.text = props.$name;
                if(props.$showName !== undefined)   //修改名字
                    role.$showName = roleComp.textName.visible = props.$showName;
                if(props.$penetrate !== undefined)   //可穿透
                    role.$penetrate = /*roleComp.$penetrate = */props.$penetrate;
                if(props.$speed !== undefined)   //修改速度
                    role.$speed = roleComp.$$speed = parseFloat(props.$speed);
                if(props.$scale && props.$scale[0] !== undefined) {
                    role.$scale[0] = roleComp.rXScale = props.$scale[0];
                }
                if(props.$scale && props.$scale[1] !== undefined) {
                    role.$scale[1] = roleComp.rYScale = props.$scale[1];
                }

                //!!!这里要加入名字是否重复
                if(props.$avatar !== undefined)   //修改头像
                    role.$avatar = props.$avatar;
                if(props.$avatarSize !== undefined) {  //修改头像
                    //roleComp.$avatarSize.width = props.$avatarSize[0];
                    //roleComp.$avatarSize.height = props.$avatarSize[1];
                    role.$avatarSize = props.$avatarSize;
                }


                //下面都是定向移动
                if(props.$targetBx !== undefined || props.$targetBy !== undefined) {
                    let tPos = itemViewPort.getMapBlockPos(props.$targetBx, props.$targetBy);
                    if(props.$targetBx === undefined)
                        tPos[0] = -1;
                    if(props.$targetBy === undefined)
                        tPos[1] = -1;
                    roleComp.$$targetsPos = [Qt.point(tPos[0], tPos[1])];
                }
                if(props.$targetX !== undefined || props.$targetY !== undefined) {
                    if(props.$targetX === undefined)
                        props.$targetX = -1;
                    if(props.$targetY === undefined)
                        props.$targetY = -1;
                    roleComp.$$targetsPos = [Qt.point(props.$targetX, props.$targetY)];
                }
                if(GlobalLibraryJS.isArray(props.$targetBlockAuto) && props.$targetBlockAuto.length === 2) {
                    let rolePos = roleComp.pos();
                    //roleComp.$$targetsPos = GameMakerGlobalJS.computePath([rolePos.bx, rolePos.by], [props.$targetBlockAuto[0], props.$targetBlockAuto[1]]);
                    props.$targetBlocks = GameMakerGlobalJS.computePath([rolePos.bx, rolePos.by], [props.$targetBlockAuto[0], props.$targetBlockAuto[1]]);
                }
                if(GlobalLibraryJS.isArray(props.$targetBlocks) && props.$targetBlocks.length > 0) {
                    roleComp.$$targetsPos = [];
                    for(let targetBlock of props.$targetBlocks) {
                        let tPos = itemViewPort.getMapBlockPos(targetBlock[0], targetBlock[1]);
                        /*if(props.$targetBx === undefined)
                            tPos[0] = -1;
                        if(props.$targetBy === undefined)
                            tPos[1] = -1;
                            */
                        roleComp.$$targetsPos.push(Qt.point(tPos[0], tPos[1]));
                    }
                }
                if(GlobalLibraryJS.isArray(props.$targetPositions)) {
                    roleComp.$$targetsPos = props.$targetPositions;
                }

                if(props.$action !== undefined)
                    roleComp.$$nActionType = props.$action;

                //如果没有定向目标，则停止
                //if(roleComp.$$targetsPos.length === 0 && props.$action === 2)
                //    props.$action = 0;


                if(props.$x !== undefined)   //修改x坐标
                    roleComp.x = props.$x;
                if(props.$y !== undefined)   //修改y坐标
                    roleComp.y = props.$y;
                if(props.$x !== undefined || props.$y !== undefined)
                    if(roleComp === _private.sceneRole)setSceneToRole(_private.sceneRole);

                if(props.$bx !== undefined || props.$by !== undefined)
                    setRolePos(props.$bx, props.$by, roleComp);
                    //moverole(roleComp, bx, by);


                if(props.$direction !== undefined)
                    roleComp.changeAction(props.$direction);
                    /*/貌似必须10ms以上才可以使其转向（鹰：使用AnimatedSprite就不用延时了）
                    GlobalLibraryJS.setTimeout(function() {
                            if(roleComp)
                                roleComp.start(props.$direction, null);
                        },20,rootGameScene
                    );
                    */

                if(props.$realSize !== undefined) {
                    roleComp.width1 = props.$realSize[0];
                    roleComp.height1 = props.$realSize[1];
                    //console.debug('!!!', props.$realSize)
                }


                //如果不是从 createrole 过来的（createrole过来的，role和props是一个对象）
                if(props !== hero) {
                    //其他属性直接赋值
                    let usedProps = ['$name', '$showName', '$penetrate', '$speed', '$scale', '$avatar', '$avatarSize', '$targetBx', '$targetBy', '$targetX', '$targetY', '$targetBlocks', '$targetPositions', '$targetBlockAuto', '$action', '$x', '$y', '$bx', '$by', '$direction', '$realSize', '$start'];
                    //for(let tp in props) {
                    for(let tp of Object.keys(props)) {
                        if(usedProps.indexOf(tp) >= 0)
                            continue;
                        role[tp] = props[tp];
                    }
                }


                if(props.$start === true) {
                    /*
                    GlobalLibraryJS.setTimeout(function() {
                        roleComp.start();
                    }, 1, rootGameScene, 'fight.continueFight');

                    GlobalLibraryJS.runNextEventLoop(function() {
                        roleComp.start();
                        }, 'game.run1');
                    */
                    roleComp.start();
                }
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


            setRolePos(bx, by, role);

            /*
            if(bx !== undefined && by !== undefined) {
                //边界检测

                if(bx < 0)
                    bx = 0;
                else if(bx >= itemViewPort.mapInfo.MapSize[0])
                    bx = itemViewPort.mapInfo.MapSize[0] - 1;

                if(by < 0)
                    by = 0;
                else if(by >= itemViewPort.mapInfo.MapSize[1])
                    by = itemViewPort.mapInfo.MapSize[1] - 1;


                //如果在最右边的图块，且人物宽度超过图块，则会超出地图边界
                //if(bx === itemViewPort.mapInfo.MapSize[0] - 1 && role.width1 > itemViewPort.sizeMapBlockScaledSize.width)
                //    role.x = itemViewPort.itemContainer.width - role.x2 - 1;
                //else
                //    role.x = roleCenterX - role.x1 - role.width1 / 2;
                role.x = bx * itemViewPort.sizeMapBlockScaledSize.width - role.x1;


                //如果在最下边的图块，且人物高度超过图块，则会超出地图边界
                //if(by === itemViewPort.mapInfo.MapSize[1] - 1 && role.height1 > itemViewPort.sizeMapBlockScaledSize.height)
                //    role.y = itemViewPort.itemContainer.height - role.y2 - 1;
                //else
                //    role.y = roleCenterY - role.y1 - role.height1 / 2;
                role.y = by * itemViewPort.sizeMapBlockScaledSize.height - role.y1;

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
                    for(let tc in _private.objRoles[r].$tmpComponents) {
                        let c = _private.objRoles[r].$tmpComponents[tc];
                        if(GlobalLibraryJS.isComponent(c)) {
                            if(c.Destroy)
                                c.Destroy();
                            else if(c.destroy)
                                c.destroy();
                        }
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

            for(let tc in role.$tmpComponents) {
                let c = role.$tmpComponents[tc];
                if(GlobalLibraryJS.isComponent(c)) {
                    if(c.Destroy)
                        c.Destroy();
                    else if(c.destroy)
                        c.destroy();
                }
            }
            role.destroy();



            return true;
        }



        //角色的各种坐标；
        //参数role为角色组件（可用hero和role命令返回的组件）；
        //  如果为数字或空，则是主角；如果是字符串，则在主角和NPC中查找；
        //pos为[bx,by]，返回角色是否在这个地图块坐标上；如果为空则表示返回角色中心所在各种坐标；
        //  如果返回是坐标，则包括x、y（实际坐标）、bx、by（地图块坐标）、cx、cy（中心坐标）、rx1、ry2、rx2、ry2（影子的左上和右下坐标）、sx、sy（视窗中的坐标）；
        readonly property var rolepos: function(role, pos=null) {
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

            //如果是地图块坐标
            if(pos) {
                //返回 地图块坐标（左上和右下）
                let usedMapBlocks = itemViewPort.fComputeUseBlocks(role.x + role.x1, role.y + role.y1, role.x + role.x2, role.y + role.y2);

                //在占用块内
                if(pos[0] >= usedMapBlocks[0] && pos[0] <= usedMapBlocks[2] && pos[1] >= usedMapBlocks[1] && pos[1] <= usedMapBlocks[3])
                    return true;
                return false;
            }
            else
                return {
                    //地图块坐标
                    bx: Math.floor(centerX / itemViewPort.sizeMapBlockScaledSize.width),
                    by: Math.floor(centerY / itemViewPort.sizeMapBlockScaledSize.height),
                    //实际坐标
                    x: role.x,
                    y: role.y,
                    //中心坐标
                    cx: centerX,
                    cy: centerY,
                    //影子左上角坐标
                    rx1: role.x + role.x1,
                    ry1: role.y + role.y1,
                    //影子右下角坐标
                    rx2: role.x + role.x2,
                    ry2: role.y + role.y2,
                    //在 视窗 中的坐标
                    sx: role.x + itemViewPort.itemContainer.x,
                    sy: role.y + itemViewPort.itemContainer.y,
                };


            /*
            ([centerX, centerY])
            ([role.x, role.y])
            ([role.x + role.x1, role.y + role.y1])
            ([role.x + role.x2, role.y + role.y2])


            let mainRoleUseBlocks = [];

            //计算人物所占的地图块
            let usedMapBlocks = itemViewPort.fComputeUseBlocks(role.x + role.x1, role.y + role.y1, role.x + role.x2, role.y + role.y2);

            for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
                for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
                    mainRoleUseBlocks.push(xb + yb * itemViewPort.mapInfo.MapSize[0]);
                }
            }
            */

        }



        //创建一个战斗主角；返回这个战斗主角对象；
        //fightrole为战斗主角资源名 或 标准创建格式的对象（带有RID、Params和其他属性）。
        readonly property var createfighthero: function(fightrole) {
            if(game.gd['$sys_fight_heros'] === undefined)
                game.gd['$sys_fight_heros'] = [];


            let newFightRole = GameSceneJS.getFightRoleObject(fightrole, true);


            //newFightRole.$rid = fightRoleRID;
            newFightRole.$index = game.gd['$sys_fight_heros'].length;
            game.gd['$sys_fight_heros'].push(newFightRole);


            return newFightRole;
        }

        //删除一个战斗主角；
        //fighthero为下标，或战斗角色的name，或战斗角色对象，或-1（删除所有战斗主角）。
        readonly property var delfighthero: function(fighthero) {

            if(fighthero === -1) {
                game.gd['$sys_fight_heros'] = [];
                return true;
            }


            fighthero = game.fighthero(fighthero);
            if(!fighthero)
                return false;


            let fightheroIndex = fighthero.$index;

            if(fightheroIndex >= game.gd['$sys_fight_heros'].length)
                return false;

            //if(game.gd['$sys_fight_heros'] === undefined)
            //    return false;

            game.gd['$sys_fight_heros'].splice(fightheroIndex, 1);

            //修正下标
            for(let tfh in game.gd['$sys_fight_heros'])
                game.gd['$sys_fight_heros'][tfh].$index = tfh;



            return true;
        }

        /*readonly property var createfightenemy: function(name) {
            loaderFightScene.enemies.push(new _private.objCommonScripts['combatant_class'](name));

        }*/

        //返回战斗主角；
        //fighthero为下标，或战斗角色的name，或战斗角色对象，或-1（返回所有战斗主角）；
        //type为0表示返回 对象，为1表示只返回名字（选择框用）；
        //返回null表示没有，false错误；
        readonly property var fighthero: function(fighthero=-1, type=0) {
            if(game.gd['$sys_fight_heros'] === undefined || game.gd['$sys_fight_heros'] === null)
                return false;

            if(fighthero === null || fighthero === undefined)
                fighthero = -1;

            if(fighthero === -1) {
                if(type === 0)
                    return game.gd['$sys_fight_heros'];
                else {  //只返回名字
                    let arrName = [];
                    for(let th of game.gd['$sys_fight_heros'])
                        arrName.push(th.$name);
                    return arrName;
                }
            }


            if(GlobalLibraryJS.isString(fighthero)) {
                for(let fightheroIndex = 0; fightheroIndex < game.gd['$sys_fight_heros'].length; ++fightheroIndex) {
                    if(game.gd['$sys_fight_heros'][fightheroIndex].$name === fighthero) {
                        fighthero = game.gd['$sys_fight_heros'][fightheroIndex];
                        break;
                    }
                }
            }
            if(GlobalLibraryJS.isObject(fighthero)) {
                //fightHero = fighthero;
                //fightheroIndex = fighthero.$index;
            }
            else if(GlobalLibraryJS.isValidNumber(fighthero)) {
                if(fighthero >= game.gd['$sys_fight_heros'].length)
                    return null;
                else if(fighthero < 0)
                    return false;

                fighthero = game.gd['$sys_fight_heros'][fighthero];
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
        //skill为技能资源名，或 标准创建格式的对象（带有RID、Params和其他属性），或技能本身（带有$rid）；
        //skillIndex为替换到第几个（如果为-1或大于已有技能数，则追加）；
        //copyedNewProps是 从skills复制的创建的新技能的属性（skills为技能对象才有效，复制一个新技能同时再复制copyedNewProps属性）；
        //成功返回true；
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
                //fighthero.$skills[skillIndex].$rid = skillRID;
                fighthero.$skills.splice(skillIndex, 0, skill);   //插入

            return true;
        }

        //移除技能；
        //fighthero为下标，或战斗角色的name，或战斗角色对象；
        //skill：技能下标（-1为删除所有 符合filters 的 技能），或 技能资源名（符合filters 的 技能）；
        //filters：技能条件筛选；
        //成功返回skill对象的数组；失败返回false；
        readonly property var removeskill: function(fighthero, skill=-1, filters={}) {
            if(skill === undefined || skill === null)
                skill = -1;
            //if(skillIndex >= objFightRoles.$skills.length || fightheroIndex < 0)
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
        //成功返回 技能数组；
        readonly property var skill: function(fighthero, skill=-1, filters={}) {
            if(skill === undefined || skill === null)
                skill = -1;
            //if(type === undefined || type === null)
            //    type = -1;
            //if(skillIndex >= objFightRoles.$skills.length || fightheroIndex < 0)
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
        //  type如果为数组，第一个值为上面的含义，第二个表示乘的时候 参考属性（0为properties，1为propertiesWithExtra）；
        //  flags：从左到右：是否检测升级，是否调用刷新函数（如果修改一些不用刷新的属性，就不用刷新）；
        //  成功返回战斗角色对象；失败返回false；
        readonly property var addprops: function(fighthero, props={}, type=[1,1], flags=0b11) {

            if(fighthero < 0)
                return false;

            //找到fighthero
            fighthero = game.fighthero(fighthero);
            if(!fighthero)
                return false;


            //先刷新一次（主要是$$propertiesWithExtra）
            if(flags & 0b1)
                _private.objCommonScripts['refresh_combatant'](fighthero, false);

            //参考属性（乘以比例时的参考属性）
            let properties2;
            if(GlobalLibraryJS.isNumber(type)) {
                properties2 = fighthero.$$propertiesWithExtra;
            }
            else {
                if(type[1] === 1)
                    properties2 = fighthero.$$propertiesWithExtra;
                else
                    properties2 = fighthero.$properties;

                type = type[0];
            }

            GameMakerGlobalJS.addProps(fighthero.$properties, props, type, properties2);

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

            //再刷新一次
            if(flags & 0b1)
                _private.objCommonScripts['refresh_combatant'](fighthero, !!(flags & 0b10));


            return fighthero;
        }

        //背包内 获得 count个道具；返回背包中 改变后 道具个数，返回false表示错误。
        //goods可以为 道具资源名、 或 标准创建格式的对象（带有RID、Params和其他属性），或道具本身（带有$rid），或 下标；
        //count为0表示使用goods内的$count；
        readonly property var getgoods: function(goods, count=0) {
            if(!count)
                count = 0;

            if(GlobalLibraryJS.isObject(goods)) { //如果直接是对象
                goods = GameSceneJS.getGoodsObject(goods, false);

                if(!goods.$count)
                    goods.$count = 0;
                else {
                    count += goods.$count;
                    goods.$count = 0;
                }

                if(!goods.$stackable) {
                    if(count > 0)
                        goods.$count = count;
                    else
                        return false;

                    game.gd['$sys_goods'].push(goods);
                    return goods.$count;
                }
            }
            else if(GlobalLibraryJS.isString(goods)) { //如果直接是字符串
                if(count === 0) {
                    for(let tg of game.gd['$sys_goods']) {
                        //找到
                        if(tg && tg.$rid === goods) {
                            count += tg.$count;
                        }
                    }
                    return count;
                }

                goods = GameSceneJS.getGoodsObject(goods);

                if(!goods.$stackable) {
                    if(count > 0)
                        goods.$count = count;
                    else
                        return false;

                    game.gd['$sys_goods'].push(goods);
                    return goods.$count;
                }
            }
            else if(GlobalLibraryJS.isValidNumber(goods)) { //如果直接是数字
                if(goods < 0 || goods >= game.gd['$sys_goods'].length)
                    return false;

                goods = game.gd['$sys_goods'][goods];
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
            for(let tg of game.gd['$sys_goods']) {
                //找到
                if(tg && tg.$rid === goods.$rid && tg.$stackable) {
                    tg.$count += count;
                    return tg.$count;
                }
            }

            //如果没有找到

            if(count > 0)
                goods.$count = count;
            else
                return false;
            game.gd['$sys_goods'].push(goods);
            return goods.$count;
        }

        //背包内 减去count个道具，返回背包中 改变后 道具个数；
        //goods可以为 道具资源名、道具对象 和 下标；
        //count为个数，如果为true则表示道具的所有；
        //如果 装备数量不够，则返回<0（相差数），原道具数量不变化；
        //返回 false 表示错误；
        readonly property var removegoods: function(goods, count=1) {
            if(!GlobalLibraryJS.isValidNumber(count) || count < 0)   //如果直接是数字
                return false;


            if(GlobalLibraryJS.isObject(goods)) { //如果是 道具对象
                if(count === true)
                    count = goods.$count;

                //搜索所在位置
                for(let tg in game.gd['$sys_goods']) {
                    if(game.gd['$sys_goods'][tg] === goods) {

                        let newCount = goods.$count - count;  //剩余数量
                        if(newCount < 0)
                            return newCount;
                        else if(newCount === 0)
                            game.gd['$sys_goods'].splice(tg, 1);
                        else
                            game.gd['$sys_goods'][tg].$count = newCount;

                        return newCount;
                    }
                }
                return false;
            }
            else if(GlobalLibraryJS.isValidNumber(goods)) { //如果直接是数字
                if(goods < 0 || goods >= game.gd['$sys_goods'].length)
                    return false;

                if(count === true)
                    count = game.gd['$sys_goods'][goods].$count;

                let newCount = game.gd['$sys_goods'][goods].$count - count;  //剩余数量
                if(newCount < 0)
                    return newCount;
                else if(newCount === 0)
                    game.gd['$sys_goods'].splice(goods, 1);
                else
                    game.gd['$sys_goods'][goods].$count = newCount;

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
            for(let tg = game.gd['$sys_goods'].length - 1; tg >= 0; --tg) {
                if(game.gd['$sys_goods'][tg].$rid === goods) {
                    tarrRemovedIndex.push(tg);
                    tCount = tCount - game.gd['$sys_goods'][tg].$count;
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
                count = count - game.gd['$sys_goods'][tindex].$count;
                if(count >= 0)
                    game.gd['$sys_goods'].splice(tindex, 1);
                else
                    game.gd['$sys_goods'][tindex].$count = -count;

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
        //返回格式：道具数组；
        readonly property var goods: function(goods=-1, filters={}) {
            if(GlobalLibraryJS.isObject(goods)) {
                for(let tg of game.gd['$sys_goods']) {
                    if(tg === goods)
                        return [tg];
                }
                return null;
            }

            if(GlobalLibraryJS.isString(goods) || goods === -1) { //如果直接是 字符串或全部，则 按 过滤条件 找出所有
                let ret = [];

                for(let tg of game.gd['$sys_goods']) {
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
                if(goods >= game.gd['$sys_goods'].length)
                    return null;
                else if(goods < 0)
                    return false;
                else {
                    let tg = game.gd['$sys_goods'][goods];
                    return tg ? [tg] : null;
                }
                //else
                //    return game.gd['$sys_goods'];
            }


            return null;
        }

        //使用道具（会执行道具use脚本）；
        //fighthero为下标，或战斗角色的name，或战斗角色对象，也可以为null或undefined；
        //goods可以为 道具资源名、道具对象 和 下标；
        readonly property var usegoods: function*(fighthero, goods) {

            let goodsInfo = null;
            if(GlobalLibraryJS.isObject(goods)) { //如果直接是对象
                goodsInfo = GameSceneJS.getGoodsResource(goods.$rid);
            }
            else if(GlobalLibraryJS.isValidNumber(goods)) { //如果直接是数字
                if(goods < 0 || goods >= game.gd['$sys_goods'].length) {
                    //asyncScript.runNextEventLoop('usegoods');
                    return false;
                }

                goods = game.gd['$sys_goods'][goods];
                goodsInfo = GameSceneJS.getGoodsResource(goods.$rid);
            }
            else if(GlobalLibraryJS.isString(goods)) { //如果直接是字符串
                goodsInfo = GameSceneJS.getGoodsResource(goods);
                goods = GameSceneJS.getGoodsObject(goods);
            }
            else {
                //asyncScript.runNextEventLoop('usegoods');
                return false;
            }

            if(!goodsInfo || !goods) {
                //asyncScript.runNextEventLoop('usegoods');
                return false;
            }


            /*let heroProperty, heroPropertyNew;

            if(heroIndex === null || heroIndex === undefined || (heroIndex >= game.gd['$sys_fight_heros'].length || heroIndex < 0))
                ;
            else {
                heroProperty = game.gd['$sys_fight_heros'][heroIndex].$properties;
                heroPropertyNew = game.gd['$sys_fight_heros'][heroIndex].$$propertiesWithExtra;
            }*/

            //if(fighthero < 0)
            //    return false;

            if(fighthero < 0)
                fighthero = null;
            else
                fighthero = game.fighthero(fighthero);
            //if(!fighthero)
            //    return false;


            //game.run(function*(){
            if(goodsInfo.$commons.$useScript) {
                let r = goodsInfo.$commons.$useScript(goods, fighthero);
                if(GlobalLibraryJS.isGenerator(r))yield *r;
            }


            //计算新属性
            _private.objCommonScripts['refresh_combatant'](fighthero);

            //for(let tfh of game.gd['$sys_fight_heros'])
            //    _private.objCommonScripts['refresh_combatant'](tfh);

            //刷新战斗时人物数据
            //fight.$sys.refreshCombatant(-1);


            return true;

            //}, {Priority: -2, Type: 0, Running: 1, Tips: 'usegoods'});
            //return true;
        }

        //直接装备一个道具（不是从背包中）；
        //fighthero为下标，或战斗角色的name，或战斗角色对象；
        //goods可以为 道具资源名、 或 标准创建格式的对象（带有RID、Params和其他属性），或道具本身（带有$rid），或 下标；
        //newPosition：强制装到新部位，如果为空，则使用 goods 的 position 属性来装备；
        //copyedNewProps是 从goods复制的创建的新道具的属性（goods为道具对象才有效，复制一个新道具同时再复制（覆盖）copyedNewProps属性，比如$count、$position）；
        //返回null表示错误；
        //注意：会将目标装备移除，需要保存则先unload到getgoods；
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
                    if(_private.objCommonScripts['equip_reserved_slots'].indexOf(newPosition) !== -1)
                        fighthero.$equipment[newPosition] = undefined;
                    else
                        delete fighthero.$equipment[newPosition];
                    */
                    delete fighthero.$equipment[newPosition];
                }
                else
                    oldEquip.$count = newCount;

                //计算新属性
                _private.objCommonScripts['refresh_combatant'](fighthero);
                //刷新战斗时人物数据
                //fight.$sys.refreshCombatant(-1);

                return newCount;
            }

            //if(oldEquip === undefined || oldEquip.$rid !== goods) {    //如果原来没有装备
            if(goods.$count > 0) {
                fighthero.$equipment[newPosition] = goods;

                //计算新属性
                _private.objCommonScripts['refresh_combatant'](fighthero);
                //刷新战斗时人物数据
                //fight.$sys.refreshCombatant(-1);
            }
            return goods.$count;
            //}
        }

        //卸下某装备（所有个数）；
        //fighthero为下标，或战斗角色的name，或战斗角色对象；positionName为部位名；
        //返回旧装备，没有返回undefined；
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
            if(_private.objCommonScripts['equip_reserved_slots'].indexOf(positionName) !== -1)
                fighthero.$equipment[positionName] = undefined;
            else
                delete fighthero.$equipment[positionName];
            */
            delete fighthero.$equipment[positionName];


            //计算新属性
            _private.objCommonScripts['refresh_combatant'](fighthero);
            //刷新战斗时人物数据
            //fight.$sys.refreshCombatant(-1);

            return oldEquip;
        }

        //返回某 fighthero 的 positionName 部位的 装备；如果positionName为null，则返回所有装备的数组；
        //fighthero为下标，或战斗角色的name，或战斗角色对象；
        //返回格式：全部装备的数组 或 某一个位置的装备；错误返回false。
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
        //pauseGame同msg的参数；
        readonly property var trade: function(goods=[], mygoodsinclude=true, pauseGame=true, callback=true) {

            if(goods !== true)
                dialogTrade.show(goods, mygoodsinclude, pauseGame, callback);


            return dialogTrade;
        }

        //获得金钱；返回金钱数目；
        readonly property var money: function(m) {
            if(!game.gd['$sys_money']) {
                game.gd['$sys_money'] = 0;
            }
            if(m)
                game.gd['$sys_money'] += m;
            return game.gd['$sys_money'];
        }


        //兼容旧代码！！！

        readonly property var fighting: function(fightScript) {
            fight.fighting(fightScript);
        }

        readonly property var fighton: function(fightScript, probability=5, flag=3, interval=1000) {
            fight.fighton(fightScript, probability, flag, interval);
        }

        readonly property var fightoff: function() {
            fight.fightoff();
        }


        //创建定时器；
        //timerName：定时器名称；interval：定时器间隔；times：触发次数（-1为无限）；bGlobal：是否是全局定时器；params为自定义参数（回调时传入）；
        //成功返回true；如果已经有定时器则返回false；
        readonly property var addtimer: function(timerName, interval, times=1, bGlobal=false, params=null) {
            let objTimer;
            if(bGlobal)
                objTimer = _private.objGlobalTimers;
            else
                objTimer = _private.objTimers;

            if(objTimer[timerName] !== undefined)
                return false;

            //0：剩余时长（每帧减）；1：剩余次数（每次减）；2：时长（备份）；3：回调参数；
            objTimer[timerName] = [interval, times, interval, params];

            //game.gd['$sys_timer'][timerName] = {Name: timerName, Interval: interval, Times: times, Global: bGlobal, Params: params};

            return true;
        }

        //删除定时器；
        //成功返回true；如果没有则返回false；
        readonly property var deltimer: function(timerName, bGlobal=false) {
            let objTimer;
            if(bGlobal)
                objTimer = _private.objGlobalTimers;
            else
                objTimer = _private.objTimers;

            //delete game.gd['$sys_timer'][timerName];

            if(objTimer[timerName]) {
                delete objTimer[timerName];

                return true;
            }

            return false;
        }


        //播放音乐；
        //musicParams是音乐名或对象（包含RID）；为空表示开始播放之前停止的；
        //  musicParams为对象包含两个属性：
        //    $loops为循环次数，空或0表示无限循环；
        //    $callback为状态回调函数；
        //成功返回true；
        readonly property var playmusic: function(musicParams) {
            if(GlobalLibraryJS.isString(musicParams)) {
                musicParams = {RID: musicParams};
            }
            else if(GlobalLibraryJS.isObject(musicParams)) {

            }
            else {
                itemBackgroundMusic.play();
                return true;
            }

            musicParams.$rid = musicParams.RID ?? musicParams.RId;


            let fileURL = GameMakerGlobal.musicResourceURL(musicParams.$rid);
            //if(!FrameManager.sl_qml_FileExists(GlobalJS.toPath(fileURL))) {
            //    console.warn('[!GameScene]video no exist：', video, fileURL)
            //    return false;
            //}

            //if(_private.objMusic[musicRID] === undefined)
            //    return false;

            audioBackgroundMusic.source = fileURL;
            audioBackgroundMusic.loops = musicParams.$loops || Audio.Infinite;
            itemBackgroundMusic.fStateCallback = musicParams.$callback;
            itemBackgroundMusic.play();

            game.gd['$sys_music'] = musicParams.$rid;

            //console.debug('~~~playmusic:', _private.objMusic[musicRID], GameMakerGlobal.musicResourceURL(_private.objMusic[musicRID]));
            //console.debug('~~~playmusic:', audioBackgroundMusic.source, audioBackgroundMusic.source.toString());

            return true;
        }

        //停止音乐；
        readonly property var stopmusic: function() {
            itemBackgroundMusic.stop();
        }

        //暂停音乐；
        //参数name为暂停名称；如果为true，表示引擎级关闭音乐；如果为false，表示存档级关闭音乐；
        readonly property var pausemusic: function(name='$user') {
            itemBackgroundMusic.pause(name);
        }

        //恢复播放音乐；
        //参数name为恢复名称；如果为true，表示引擎级恢复播放音乐；如果为false，表示存档级恢复播放音乐；如果为-1，打开全部强制恢复；
        readonly property var resumemusic: function(name='$user') {
            itemBackgroundMusic.resume(name);
        }
        //将音乐暂停并存栈；一般用在需要播放战斗音乐前；
        readonly property var pushmusic: function() {
            itemBackgroundMusic.arrMusicStack.push([game.gd['$sys_music'], audioBackgroundMusic.position]);
            itemBackgroundMusic.stop();
        }
        //播放上一次存栈的音乐；一般用在战斗结束后（$commonFightEndScript已调用，不用写在战斗结束脚本中）；
        readonly property var popmusic: function() {
            if(itemBackgroundMusic.arrMusicStack.length === 0)
                return;
            let m = itemBackgroundMusic.arrMusicStack.pop();
            game.gd['$sys_music'] = m[0];
            audioBackgroundMusic.source = GameMakerGlobal.musicResourceURL(game.gd['$sys_music']);
            audioBackgroundMusic.seek(m[1]);
            //if(m[2])
                itemBackgroundMusic.play();
            //else
            //    itemBackgroundMusic.stop();
        }
        //跳到播放进度（毫秒）；
        readonly property var seekmusic: function(offset=0) {
            audioBackgroundMusic.seek(offset);
        }

        //状态；
        readonly property var musicplaying: function() {
            return itemBackgroundMusic.isPlaying();
        }
        readonly property var musicpausing: function() {
            //return itemBackgroundMusic.objMusicPause[$name] !== undefined;
            if(GlobalLibraryJS.objectIsEmpty(itemBackgroundMusic.objMusicPause) &&
                //!GameMakerGlobal.settings.value('$PauseMusic') &&
                !game.cd['$PauseMusic'] &&
                (game.gd['$sys_sound'] & 0b1)
            )
                return false;

            return true;
        }


        //暂停音效；
        //参数name为暂停名称；如果为true，表示引擎级关闭音效；如果为false，表示存档级关闭音效；
        readonly property var pausesoundeffect: function(name='$user') {
            rootSoundEffect.pause(name);
        }

        //恢复播放音效；
        //参数name为恢复名称；如果为true，表示引擎级恢复播放音效；如果为false，表示存档级恢复播放音效；如果为-1，打开全部强制恢复；
        readonly property var resumesoundeffect: function(name='$user') {
            rootSoundEffect.resume(name);
        }

        readonly property var soundeffectpausing: function() {
            //return _private.config.nSoundConfig !== 0;
            if(GlobalLibraryJS.objectIsEmpty(rootSoundEffect.objSoundEffectPause) &&
                //!GameMakerGlobal.settings.value('$PauseSound') &&
                !game.cd['$PauseSound'] &&
                (game.gd['$sys_sound'] & 0b10)
            )
                return false;
            return true;
        }


        //播放视频；
        //videoParams是视频名或对象（包含RID）；
        //  videoParams为对象包含两个属性：$videoOutput（包括x、y、width、height等） 和 $mediaPlayer；
        //  也可以修改 $x、$y、$width、$height。
        //pauseGame同msg的参数；
        readonly property var playvideo: function(videoParams, pauseGame=true) {
            if(GlobalLibraryJS.isString(videoParams)) {
                videoParams = {RID: videoParams};
            }
            else if(GlobalLibraryJS.isObject(videoParams)) {

            }
            else
                return false;

            videoParams.$rid = videoParams.RID ?? videoParams.RId;

            itemVideo.fStateCallback = videoParams.$callback;


            let fileURL = GameMakerGlobal.videoResourceURL(videoParams.$rid);
            //if(!FrameManager.sl_qml_FileExists(GlobalJS.toPath(fileURL))) {
            //    console.warn('[!GameScene]video no exist：', videoParams.$rid, fileURL)
            //    return false;
            //}

            //if(_private.objVideos[videoRID] === undefined)
            //    return false;

            if(videoParams.$videoOutput === undefined)
                videoParams.$videoOutput = {};
            if(videoParams.$mediaPlayer === undefined)
                videoParams.$mediaPlayer = {};


            if(videoParams.$videoOutput.$width === undefined && videoParams.$width === undefined)
                videoOutput.width = Qt.binding(function(){return videoOutput.implicitWidth});
            else if(videoParams.$width === -1)
                videoOutput.width = rootGameScene.width;
            else if(GlobalLibraryJS.isValidNumber(videoParams.$width)) {
                videoOutput.width = videoParams.$width * Screen.pixelDensity;
            }

            if(videoParams.$videoOutput.$height === undefined && videoParams.$height === undefined)
                videoOutput.height = Qt.binding(function(){return videoOutput.implicitHeight});
            else if(videoParams.$height === -1)
                videoOutput.height = rootGameScene.height;
            else if(GlobalLibraryJS.isValidNumber(videoParams.$height)) {
                videoOutput.height = videoParams.$height * Screen.pixelDensity;
            }


            mediaPlayer.source = fileURL;

            GlobalLibraryJS.copyPropertiesToObject(videoOutput, videoParams.$videoOutput, {onlyCopyExists: true});
            GlobalLibraryJS.copyPropertiesToObject(mediaPlayer, videoParams.$mediaPlayer, {onlyCopyExists: true});
            /*
            let tKeys = Object.keys(videoOutput);
            for(let tp in videoParams)
                if(tKeys.indexOf(tp) >= 0)
                    videoOutput[tp] = videoParams[tp];
            */

            itemVideo.pauseGame = pauseGame;
            itemVideo.play();

            //itemViewPort.gameScene.color='#CCFFFFFF';
            //console.debug(itemViewPort.gameScene.color)
            //console.debug(itemViewPort.gameScene.color==='#ccffffff');
        }
        //结束播放；
        readonly property var stopvideo: function() {
            itemVideo.stop();
        }

        //显示图片；
        //imageParams为图片名或对象（包含RID）；
        //imageParams为对象：包含 Image组件 的所有属性 和 $x、$y、$width、$height、$parent、RID、$id  等属性；还包括 $pressed、$released、$clicked、$doubleClicked、$pressAndHold 事件的回调函数；
        //  x、y、width、height 和 $x、$y、$width、$height 是坐标和宽高，每组（带$和不带$）只需填一种；
        //    不带$表示按像素；
        //    带$的属性有以下几种格式：
        //      $x、$y：如果为数字，则表示坐标是按固定长度（厘米）为单位的长度（跨平台用）；
        //        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填x、y 和 $x、$y 作用相同；为2表示父组件的百分比；为3表示居中父组件后偏移多少像素，为4表示居中父组件后偏移多少固定长度；
        //      $width、$height：如果为数字，则表示按固定长度（厘米）为单位的长度（跨平台用）；
        //        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填width、height 和 $width、$height 作用 相同；为2表示父组件的多少倍；为3表示自身的多少倍；为4表示是 固定宽高比 的多少倍；
        //  $parent：0表示显示在屏幕上（默认）；1表示显示在视窗上；2表示显示在场景上（受scale影响）；3表示显示在地图上；4表示显示在地图地板层上；字符串表示显示在某个角色上；也可以是一个组件对象；
        //  $id为标识（用来控制、删除和重用）；
        //  $component：用户自己提供的组件，一般$parent也为组件时使用，由用户自己控制使用。
        readonly property var showimage: function(imageParams, id=undefined) {
            if(GlobalLibraryJS.isString(imageParams)) {
                imageParams = {RID: imageParams};
            }
            else if(GlobalLibraryJS.isObject(imageParams)) {

            }
            else
                return false;

            imageParams.$rid = imageParams.RID ?? imageParams.RId;


            let fileURL = GameMakerGlobal.imageResourceURL(imageParams.$rid);
            //if(!FrameManager.sl_qml_FileExists(GlobalJS.toPath(fileURL))) {
            //    console.warn('[!GameScene]image no exist：', imageParams.$rid, fileURL)
            //    return false;
            //}

            //if(_private.objImages[imageParams.$rid] === undefined)
            //    return false;

            /*image.source = GameMakerGlobal.imageResourceURL(imageRID);
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

            //imageParams.source = fileURL;


            //父组件
            let parentComp;
            //暂存位置
            let objTmpComponents;
            //游戏视窗
            if(imageParams.$parent === 1) {
                parentComp = itemViewPort;

                objTmpComponents = _private.objTmpComponents;
            }
            //会改变大小
            else if(imageParams.$parent === 2) {
                parentComp = itemViewPort.gameScene;

                objTmpComponents = _private.objTmpComponents;
            }
            //会改变大小和随地图移动
            else if(imageParams.$parent === 3) {
                parentComp = itemViewPort.itemContainer;

                objTmpComponents = _private.objTmpMapComponents;
            }
            //会改变大小和随地图移动
            else if(imageParams.$parent === 4) {
                parentComp = itemViewPort.itemRoleContainer;

                objTmpComponents = _private.objTmpMapComponents;
            }
            //某角色上
            else if(GlobalLibraryJS.isString(imageParams.$parent)) {
                let role = game.hero(imageParams.$parent);
                if(!role)
                    role = game.role(imageParams.$parent);
                if(role) {
                    parentComp = role;

                    objTmpComponents = role.$tmpComponents;
                }
                else {
                    console.warn('[!GameScene]找不到：', imageParams.$parent);
                    //delimage(id);
                    return false;
                }
            }
            else if(GlobalLibraryJS.isObject(imageParams.$parent)) {
                parentComp = imageParams.$parent;

                //不一定存在
                objTmpComponents = parentComp.$tmpComponents;
            }
            //固定屏幕上
            else {
                parentComp = rootGameScene;

                objTmpComponents = _private.objTmpComponents;
            }


            //if(id === undefined || id === null)
            id = id ?? imageParams.$id ?? imageParams.$rid;


            let tmp = imageParams.$component || (objTmpComponents ? objTmpComponents[id] : null) || compCacheImage.createObject(null);
            if(tmp && tmp.$componentType !== 1) {
                console.exception('[!GameScene]组件类型错误：', tmp.$componentType);
                return false;
            }

            //如果缓存中没有，则创建
            //if(!tmp) {
                //let image = Qt.createQmlObject('import QtQuick 2.14; Image {}', rootGameScene);

                //tmp = compCacheImage.createObject(null);
                //随场景缩放
                //tmp = compCacheImage.createObject(itemViewPort.gameScene, {source: fileURL});
                //tmp = compCacheImage.createObject(rootGameScene, {source: fileURL});
                //随地图移动
                //tmp = compCacheImage.createObject(itemViewPort.itemContainer, {source: fileURL});

                if(objTmpComponents)
                    objTmpComponents[id] = tmp;
                tmp.$id = id;
                //tmp.anchors.centerIn = rootGameScene;
            //}

            //取出组件，循环赋值
            //else {
                tmp.visible = false;
                tmp.source = fileURL;
                //tmp.parent = imageParams.$parent;
                /*
                let tKeys = Object.keys(tmp);
                for(let tp in imageParams)
                    if(tKeys.indexOf(tp) >= 0)
                        tmp[tp] = imageParams[tp];
                */
            //}

            tmp.parent = parentComp;
            //tmp.parent = imageParams.$parent;


            //if(_private.spritesResource[imageRID] === undefined) {
            //    _private.spritesResource[imageRID].$$cache = {image: image};
            //}



            //改变大小和位置

            //宽高比固定，为1宽度适应高度，为2高度适应宽度
            let widthOrHeightAdaption = 0;

            //默认原宽度
            if(imageParams.$width === undefined && imageParams.width === undefined)
                tmp.width = tmp.implicitWidth;
            //父组件宽
            else if(imageParams.$width === -1)
                tmp.width = Qt.binding(function(){return parentComp.width});
            else if(GlobalLibraryJS.isArray(imageParams.$width)) {
                switch(imageParams.$width[1]) {
                //如果是 固定宽度
                case 1:
                    tmp.width = imageParams.$width[0] * Screen.pixelDensity;
                    break;
                //如果是 父组件百分比
                case 2:
                    tmp.width = Qt.binding(function(){return imageParams.$width[0] * parentComp.width});
                    break;
                //如果是 自身百分比
                case 3:
                    tmp.width = imageParams.$width[0] * tmp.implicitWidth;
                    break;
                //宽度适应高度
                case 4:
                    widthOrHeightAdaption = 1;
                    break;
                //跨平台宽度
                case 9:
                    tmp.width = Qt.binding(function(){return Global.vx(imageParams.$width[0])});
                    break;
                //按像素
                default:
                    tmp.width = imageParams.$width[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(imageParams.$width)) {
                tmp.width = imageParams.$width * Screen.pixelDensity;
            }

            //默认原高
            if(imageParams.$height === undefined && imageParams.height === undefined)
                tmp.height = tmp.implicitHeight;
            //父组件高
            else if(imageParams.$height === -1)
                tmp.height = Qt.binding(function(){return parentComp.height});
            else if(GlobalLibraryJS.isArray(imageParams.$height)) {
                switch(imageParams.$height[1]) {
                //如果是 固定高度
                case 1:
                    tmp.height = imageParams.$height[0] * Screen.pixelDensity;
                    break;
                //如果是 父组件百分比
                case 2:
                    tmp.height = Qt.binding(function(){return imageParams.$height[0] * parentComp.height});
                    break;
                //如果是 自身百分比
                case 3:
                    tmp.height = imageParams.$height[0] * tmp.implicitHeight;
                    break;
                //高度适应宽度
                case 4:
                    widthOrHeightAdaption = 2;
                    break;
                //跨平台高度
                case 9:
                    tmp.height = Qt.binding(function(){return Global.vy(imageParams.$height[0])});
                    break;
                //按像素
                default:
                    tmp.height = imageParams.$height[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(imageParams.$height)) {
                tmp.height = imageParams.$height * Screen.pixelDensity;
            }

            //宽度适应高度、高度适应宽度（乘以倍率）
            if(widthOrHeightAdaption === 1)
                tmp.width = tmp.height / tmp.implicitHeight * tmp.implicitWidth * imageParams.$width[0];
            else if(widthOrHeightAdaption === 2)
                tmp.height = tmp.width / tmp.implicitWidth * tmp.implicitHeight * imageParams.$height[0];


            //默认
            if(imageParams.$x === undefined && imageParams.x === undefined)
                tmp.x = 0;
            //居中
            else if(imageParams.$x === -1)
                tmp.x = Qt.binding(function(){return (parentComp.width - tmp.width) / 2});
                //tmp.x = (parentComp.width - tmp.width) / 2;
            else if(GlobalLibraryJS.isArray(imageParams.$x)) {
                switch(imageParams.$x[1]) {
                //如果是 固定长度
                case 1:
                    tmp.x = imageParams.$x[0] * Screen.pixelDensity;
                    break;
                //如果是 父组件百分比
                case 2:
                    tmp.x = Qt.binding(function(){return imageParams.$x[0] * parentComp.width});
                    break;
                //如果是 居中偏移像素
                case 3:
                    tmp.x = Qt.binding(function(){return imageParams.$x[0] + (parentComp.width - tmp.width) / 2});
                    break;
                //如果是 居中偏移固定长度
                case 4:
                    tmp.x = Qt.binding(function(){return imageParams.$x[0] * Screen.pixelDensity + (parentComp.width - tmp.width) / 2});
                    break;
                case 5:
                    tmp.x = Qt.binding(function(){return (parentComp.width - tmp.width) - imageParams.$x[0]});
                    break;
                //跨平台x
                case 9:
                    tmp.x = Qt.binding(function(){return Global.vx(imageParams.$x[0])});
                    break;
                //按像素
                default:
                    tmp.x = imageParams.$x[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(imageParams.$x)) {
                tmp.x = imageParams.$x * Screen.pixelDensity;
            }

            //默认
            if(imageParams.$y === undefined && imageParams.y === undefined)
                tmp.y = 0;
            //居中
            else if(imageParams.$y === -1)
                tmp.y = Qt.binding(function(){return (parentComp.height - tmp.height) / 2});
                //tmp.y = (parentComp.height - tmp.height) / 2;
            else if(GlobalLibraryJS.isArray(imageParams.$y)) {
                switch(imageParams.$y[1]) {
                //如果是 固定长度
                case 1:
                    tmp.y = imageParams.$y[0] * Screen.pixelDensity;
                    break;
                //如果是 父组件百分比
                case 2:
                    tmp.y = Qt.binding(function(){return imageParams.$y[0] * parentComp.height});
                    break;
                //如果是 居中偏移像素
                case 3:
                    tmp.y = Qt.binding(function(){return imageParams.$y[0] + (parentComp.height - tmp.height) / 2});
                    break;
                //如果是 居中偏移固定长度
                case 4:
                    tmp.y = Qt.binding(function(){return imageParams.$y[0] * Screen.pixelDensity + (parentComp.height - tmp.height) / 2});
                    break;
                case 5:
                    tmp.y = Qt.binding(function(){return (parentComp.height - tmp.height) - imageParams.$y[0]});
                    break;
                //跨平台y
                case 9:
                    tmp.y = Qt.binding(function(){return Global.vy(imageParams.$y[0])});
                    break;
                //按像素
                default:
                    tmp.y = imageParams.$y[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(imageParams.$y)) {
                tmp.y = imageParams.$y * Screen.pixelDensity;
            }


            if(imageParams.$clicked === null)
                tmp.clicked = function(image){game.delimage(image.$id)};
            else// if(imageParams.$clicked !== undefined)
                tmp.clicked = imageParams.$clicked;

            if(imageParams.$doubleClicked === null)
                tmp.doubleClicked = function(image){game.delimage(image.$id)};
            else// if(imageParams.$doubleClicked !== undefined)
                tmp.doubleClicked = imageParams.$doubleClicked;

            tmp.pressed = imageParams.$pressed;
            tmp.released = imageParams.$released;
            tmp.pressAndHold = imageParams.$pressAndHold;



            if(imageParams.$visible === undefined)
                imageParams.visible = true;
            else
                imageParams.visible = imageParams.$visible;



            GlobalLibraryJS.copyPropertiesToObject(tmp, imageParams, {onlyCopyExists: true, objectRecursion: 0});


            return tmp;
        }
        //删除图片；
        //idParams：-1：屏幕上的全部图片组件（包含图片和特效等）；数字：屏幕上的图片标识；字符串：角色上的图片标识；对象：包含$id（-1表示全部图片组件）和$parent属性（同showimage）；
        readonly property var delimage: function(idParams=-1) {
            if(GlobalLibraryJS.isNumber(idParams)) {
                idParams = {$id: idParams};
            }
            else if(GlobalLibraryJS.isString(idParams)) {
                idParams = {$id: idParams};
            }
            else if(GlobalLibraryJS.isObject(idParams)) {

            }
            else
                return false;


            //暂存位置
            let objTmpComponents;
            let tmpImage;
            //游戏视窗
            if(idParams.$parent === 1) {
                //idParams.$parent = itemViewPort;

                objTmpComponents = _private.objTmpComponents;
                tmpImage = objTmpComponents[idParams.$id];
            }
            //会改变大小
            else if(idParams.$parent === 2) {
                //idParams.$parent = itemViewPort.gameScene;

                objTmpComponents = _private.objTmpComponents;
                tmpImage = objTmpComponents[idParams.$id];
            }
            //会改变大小和随地图移动
            else if(idParams.$parent === 3) {
                //idParams.$parent = itemViewPort.itemContainer;

                objTmpComponents = _private.objTmpMapComponents;
                tmpImage = objTmpComponents[idParams.$id];
            }
            //会改变大小和随地图移动
            else if(idParams.$parent === 4) {
                //idParams.$parent = itemViewPort.itemRoleContainer;

                objTmpComponents = _private.objTmpMapComponents;
                tmpImage = objTmpComponents[idParams.$id];
            }
            //某角色上
            else if(GlobalLibraryJS.isString(idParams.$parent)) {
                let role = game.hero(idParams.$parent);
                if(!role)
                    role = game.role(idParams.$parent);
                if(role) {
                    //idParams.$parent = role;

                    objTmpComponents = role.$tmpComponents;
                    tmpImage = objTmpComponents[idParams.$id];
                }
                else
                    return false;
            }
            else if(GlobalLibraryJS.isObject(idParams.$parent)) {
                //不一定存在
                objTmpComponents = idParams.$parent.$tmpComponents;

                tmpImage = idParams;
            }
            //固定屏幕上
            else {
                //idParams.$parent = rootGameScene;

                objTmpComponents = _private.objTmpComponents;
                tmpImage = objTmpComponents[idParams.$id];
            }


            if(idParams['$id'] === -1) {
                for(let ti in objTmpComponents && objTmpComponents) {
                    if(objTmpComponents[ti].$componentType === 1) {
                        //自定义 释放函数
                        if(objTmpComponents[ti].Destroy)
                            objTmpComponents[ti].Destroy();
                        else if(objTmpComponents[ti].destroy)
                            objTmpComponents[ti].destroy();
                        delete objTmpComponents[ti];
                    }
                }

                return true;
            }


            if(tmpImage && tmpImage.$componentType === 1) {
                if(tmpImage.Destroy)
                    tmpImage.Destroy();
                else if(tmpImage.destroy)
                    tmpImage.destroy();

                if(objTmpComponents)
                    delete objTmpComponents[idParams.$id];

                return true;
            }
            return null;
        }

        //显示特效；
        //spriteParams为特效名或对象（包含RID）；
        //spriteParams为对象：包含 SpriteEffect组件 的所有属性、$x、$y、$width、$height、$parent、RID、$id 等属性；还包括 $pressed、$released、$clicked、$doubleClicked、$pressAndHold、$looped、$finished 事件的回调函数；
        //  x、y、width、height 和 $x、$y、$width、$height 是坐标和宽高，每组（带$和不带$）只需填一种；
        //    不带$表示按像素；
        //    带$的属性有以下几种格式：
        //      $x、$y：如果为数字，则表示坐标是按固定长度（厘米）为单位的长度（跨平台用）；
        //        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填x、y 和 $x、$y 作用相同；为2表示父组件的百分比；为3表示居中父组件后偏移多少像素，为4表示居中父组件后偏移多少固定长度；
        //      $width、$height：如果为数字，则表示按固定长度（厘米）为单位的长度（跨平台用）；
        //        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填width、height 和 $width、$height 作用 相同；为2表示父组件的多少倍；为3表示自身的多少倍；为4表示是 固定宽高比 的多少倍；
        //  $parent：0表示显示在屏幕上（默认）；1表示显示在视窗上；2表示显示在场景上（受scale影响）；3表示显示在地图上；4表示显示在地图地板层上；字符串表示显示在某个角色上；也可以是一个组件对象；
        //  $id为标识（用来控制、删除和重用）；
        //  $component：用户自己提供的组件，一般$parent也为组件时使用，由用户自己控制使用。
        readonly property var showsprite: function(spriteParams, id=undefined) {
            if(GlobalLibraryJS.isString(spriteParams)) {
                spriteParams = {RID: spriteParams};
            }
            else if(GlobalLibraryJS.isObject(spriteParams)) {

            }
            else
                return false;

            spriteParams.$rid = spriteParams.RID ?? spriteParams.RId;


            //let fileURL = GameMakerGlobal.imageResourceURL(spriteParams.$rid);
            //if(!FrameManager.sl_qml_FileExists(GlobalJS.toPath(fileURL))) {
            //    console.warn('[!GameScene]sprite no exist：', spriteParams.$rid, fileURL)
            //    return false;
            //}

            //if(_private.objSprites[spriteParams.$rid] === undefined)
            //    return false;

            /*image.source = GameMakerGlobal.imageResourceURL(spriteEffectRID);
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

            //let data = _private.spritesResource[spriteEffectRID];
            //spriteParams.strSource = GameMakerGlobal.spriteResourceURL(data.Image);


            //父组件
            let parentComp;
            //暂存位置
            let objTmpComponents;
            //游戏视窗
            if(spriteParams.$parent === 1) {
                parentComp = itemViewPort;

                objTmpComponents = _private.objTmpComponents;
            }
            //会改变大小
            if(spriteParams.$parent === 2) {
                parentComp = itemViewPort.gameScene;

                objTmpComponents = _private.objTmpComponents;
            }
            //会改变大小和随地图移动
            else if(spriteParams.$parent === 3) {
                parentComp = itemViewPort.itemContainer;

                objTmpComponents = _private.objTmpMapComponents;
            }
            //会改变大小和随地图移动
            else if(spriteParams.$parent === 4) {
                parentComp = itemViewPort.itemRoleContainer;

                objTmpComponents = _private.objTmpMapComponents;
            }
            //某角色上
            else if(GlobalLibraryJS.isString(spriteParams.$parent)) {
                let role = game.hero(spriteParams.$parent);
                if(!role)
                    role = game.role(spriteParams.$parent);
                if(role) {
                    parentComp = role;

                    objTmpComponents = role.$tmpComponents;
                }
                else {
                    console.warn('[!GameScene]找不到：', spriteParams.$parent);
                    //delsprite(id);
                    return false;
                }
            }
            else if(GlobalLibraryJS.isObject(spriteParams.$parent)) {
                parentComp = spriteParams.$parent;

                //不一定存在
                objTmpComponents = parentComp.$tmpComponents;
            }
            //固定屏幕上
            else {
                parentComp = rootGameScene;

                objTmpComponents = _private.objTmpComponents;
            }


            //if(id === undefined || id === null)
            id = id ?? spriteParams.$id ?? spriteParams.$rid;


            let spriteInfo = GameSceneJS.getSpriteResource(spriteParams.$rid);
            let sprite = spriteParams.$component || (objTmpComponents ? objTmpComponents[id] : null) || compCacheSpriteEffect.createObject(null);
            if(sprite && sprite.$componentType !== 2) {
                console.exception('[!GameScene]组件类型错误：', sprite.$componentType);
                return false;
            }
            //刷新特效属性
            sprite = GameSceneJS.loadSpriteEffect(spriteInfo, sprite, spriteParams, null);
            if(sprite === null)
                return false;

            sprite.visible = false;
            if(objTmpComponents)
                objTmpComponents[id] = sprite;
            sprite.$id = id;


            sprite.parent = parentComp;
            //sprite.parent = spriteParams.$parent;



            //改变大小和位置

            //宽高比固定，为1宽度适应高度，为2高度适应宽度
            let widthOrHeightAdaption = 0;

            //改变大小
            //默认原宽
            if(spriteParams.$width  === undefined && spriteParams.width === undefined)
                sprite.width = spriteInfo.SpriteSize[0]/*sprite.implicitWidth*/;
            //组件宽
            else if(spriteParams.$width === -1)
                sprite.width = Qt.binding(function(){return parentComp.width});
                //sprite.width = spriteInfo.SpriteSize[0];
            else if(GlobalLibraryJS.isArray(spriteParams.$width)) {
                switch(spriteParams.$width[1]) {
                //如果是 固定宽度
                case 1:
                    sprite.width = spriteParams.$width[0] * Screen.pixelDensity;
                    break;
                //如果是 父组件百分比
                case 2:
                    sprite.width = Qt.binding(function(){return spriteParams.$width[0] * parentComp.width});
                    break;
                //如果是 自身百分比
                case 3:
                    sprite.width = spriteParams.$width[0] * spriteInfo.SpriteSize[0]/*sprite.implicitWidth*/;
                    break;
                //宽度适应高度
                case 4:
                    widthOrHeightAdaption = 1;
                    break;
                //跨平台宽度
                case 9:
                    sprite.width = Qt.binding(function(){return Global.vx(spriteParams.$width[0])});
                    break;
                //按像素
                default:
                    sprite.width = spriteParams.$width[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(spriteParams.$width)) {
                sprite.width = spriteParams.$width * Screen.pixelDensity;
            }

            //默认原高
            if(spriteParams.$height === undefined && spriteParams.height === undefined)
                sprite.height = spriteInfo.SpriteSize[1]/*sprite.implicitHeight*/;
            //组件高
            else if(spriteParams.$height === -1)
                sprite.height = Qt.binding(function(){return parentComp.height});
                //sprite.height = spriteInfo.SpriteSize[1];
            else if(GlobalLibraryJS.isArray(spriteParams.$height)) {
                switch(spriteParams.$height[1]) {
                //如果是 固定高度
                case 1:
                    sprite.height = spriteParams.$height[0] * Screen.pixelDensity;
                    break;
                //如果是 父组件百分比
                case 2:
                    sprite.height = Qt.binding(function(){return spriteParams.$height[0] * parentComp.height});
                    break;
                //如果是 自身百分比
                case 3:
                    sprite.height = spriteParams.$height[0] * spriteInfo.SpriteSize[1]/*sprite.implicitHeight*/;
                    break;
                //高度适应宽度
                case 4:
                    widthOrHeightAdaption = 2;
                    break;
                //跨平台高度
                case 9:
                    sprite.height = Qt.binding(function(){return Global.vy(spriteParams.$height[0])});
                    break;
                //按像素
                default:
                    sprite.height = spriteParams.$height[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(spriteParams.$height)) {
                sprite.height = spriteParams.$height * Screen.pixelDensity;
            }

            //宽度适应高度、高度适应宽度（乘以倍率）
            if(widthOrHeightAdaption === 1)
                sprite.width = sprite.height / spriteInfo.SpriteSize[1] * spriteInfo.SpriteSize[0]/*sprite.implicitHeight * sprite.implicitWidth*/ * spriteParams.$width[0];
            else if(widthOrHeightAdaption === 2)
                sprite.height = sprite.width / spriteInfo.SpriteSize[0] * spriteInfo.SpriteSize[1]/*sprite.implicitWidth * sprite.implicitHeight*/ * spriteParams.$height[0];


            //默认
            if(spriteParams.$x === undefined && spriteParams.x === undefined)
                sprite.x = 0;
            //居中
            else if(spriteParams.$x === -1)
                sprite.x = Qt.binding(function(){return (parentComp.width - sprite.width) / 2});
                //sprite.x = (parentComp.width - sprite.width) / 2;
            else if(GlobalLibraryJS.isArray(spriteParams.$x)) {
                switch(spriteParams.$x[1]) {
                //如果是 固定长度
                case 1:
                    sprite.x = spriteParams.$x[0] * Screen.pixelDensity;
                    break;
                //如果是 父组件百分比
                case 2:
                    sprite.x = Qt.binding(function(){return spriteParams.$x[0] * parentComp.width});
                    break;
                //如果是 居中偏移像素
                case 3:
                    sprite.x = Qt.binding(function(){return spriteParams.$x[0] + (parentComp.width - sprite.width) / 2});
                    break;
                //如果是 居中偏移固定长度
                case 4:
                    sprite.x = Qt.binding(function(){return spriteParams.$x[0] * Screen.pixelDensity + (parentComp.width - sprite.width) / 2});
                    break;
                case 5:
                    sprite.x = Qt.binding(function(){return (parentComp.width - sprite.width) - spriteParams.$x[0]});
                    break;
                //跨平台x
                case 9:
                    sprite.x = Qt.binding(function(){return Global.vx(spriteParams.$x[0])});
                    break;
                //按像素
                default:
                    sprite.x = spriteParams.$x[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(spriteParams.$x)) {
                sprite.x = spriteParams.$x * Screen.pixelDensity;
            }

            //默认
            if(spriteParams.$y === undefined && spriteParams.y === undefined)
                sprite.y = 0;
            //居中
            else if(spriteParams.$y === -1)
                sprite.y = Qt.binding(function(){return (parentComp.height - sprite.height) / 2});
                //sprite.y = (parentComp.height - sprite.height) / 2;
            else if(GlobalLibraryJS.isArray(spriteParams.$y)) {
                switch(spriteParams.$y[1]) {
                //如果是 固定长度
                case 1:
                    sprite.y = spriteParams.$y[0] * Screen.pixelDensity;
                    break;
                //如果是 父组件百分比
                case 2:
                    sprite.y = Qt.binding(function(){return spriteParams.$y[0] * parentComp.height});
                    break;
                //如果是 居中偏移像素
                case 3:
                    sprite.y = Qt.binding(function(){return spriteParams.$y[0] + (parentComp.height - sprite.height) / 2});
                    break;
                //如果是 居中偏移固定长度
                case 4:
                    sprite.y = Qt.binding(function(){return spriteParams.$y[0] * Screen.pixelDensity + (parentComp.height - sprite.height) / 2});
                    break;
                case 5:
                    sprite.y = Qt.binding(function(){return (parentComp.height - sprite.height) - spriteParams.$y[0]});
                    break;
                //跨平台y
                case 9:
                    sprite.y = Qt.binding(function(){return Global.vy(spriteParams.$y[0])});
                    break;
                //按像素
                default:
                    sprite.y = spriteParams.$y[0];
                }
            }
            else if(GlobalLibraryJS.isValidNumber(spriteParams.$y)) {
                sprite.y = spriteParams.$y * Screen.pixelDensity;
            }


            if(spriteParams.$clicked === null)
                sprite.clicked = function(sprite){game.delsprite(sprite.$id)};
            else// if(spriteParams.$clicked !== undefined)
                sprite.clicked = spriteParams.$clicked;

            if(spriteParams.$doubleClicked === null)
                sprite.doubleClicked = function(sprite){game.delsprite(sprite.$id)};
            else// if(spriteParams.$doubleClicked !== undefined)
                sprite.doubleClicked = spriteParams.$doubleClicked;

            sprite.pressed = spriteParams.$pressed;
            sprite.released = spriteParams.$released;
            sprite.pressAndHold = spriteParams.$pressAndHold;


            if(spriteParams.$looped === null)
                //sprite.looped = function(sprite){game.delsprite(sprite.$id)};
                sprite.looped = null;
            else// if(spriteParams.$looped !== undefined)
                sprite.looped = spriteParams.$looped;

            if(spriteParams.$finished === null)
                //sprite.finished = function(sprite){game.delsprite(sprite.$id)};
                sprite.finished = null;
            else// if(spriteParams.$finished !== undefined)
                sprite.finished = spriteParams.$finished;



            if(spriteParams.$visible === undefined)
                spriteParams.visible = true;
            else
                spriteParams.visible = spriteParams.$visible;



            GlobalLibraryJS.copyPropertiesToObject(sprite, spriteParams, {onlyCopyExists: true, objectRecursion: 0});
            /*/复制属性
            let tKeys = Object.keys(sprite);
            for(let tp in spriteParams)
                if(tKeys.indexOf(tp) >= 0)
                    sprite[tp] = spriteParams[tp];
            */

            //if(_private.spritesResource[spriteEffectRID] === undefined) {
            //    _private.spritesResource[spriteEffectRID].$$cache = {sprite: sprite};
            //}

            //sprite.visible = true;


            if(spriteParams.$start === undefined || spriteParams.$start === 2)
                sprite.restart();
            else if(spriteParams.$start === 1)
                sprite.start();
            else if(spriteParams.$start === 0)
                sprite.stop();


            return sprite;
        }

        //删除特效；
        //idParams：-1：屏幕上的全部特效组件（包含图片和特效等）；数字：屏幕上的特效标识；字符串：角色上的特效标识；对象：包含$id（-1表示全部特效组件）和$parent属性（同showsprite）；
        readonly property var delsprite: function(idParams=-1) {
            if(GlobalLibraryJS.isNumber(idParams)) {
                idParams = {$id: idParams};
            }
            else if(GlobalLibraryJS.isString(idParams)) {
                idParams = {$id: idParams};
            }
            else if(GlobalLibraryJS.isObject(idParams)) {

            }
            else
                return false;


            //暂存位置
            let objTmpComponents;
            let tmpSprites;
            //游戏视窗
            if(idParams.$parent === 1) {
                //idParams.$parent = itemViewPort;

                objTmpComponents = _private.objTmpComponents;
                tmpSprites = objTmpComponents[idParams.$id];
            }
            //会改变大小
            else if(idParams.$parent === 2) {
                //idParams.$parent = itemViewPort.gameScene;

                objTmpComponents = _private.objTmpComponents;
                tmpSprites = objTmpComponents[idParams.$id];
            }
            //会改变大小和随地图移动
            else if(idParams.$parent === 3) {
                //idParams.$parent = itemViewPort.itemContainer;

                objTmpComponents = _private.objTmpMapComponents;
                tmpSprites = objTmpComponents[idParams.$id];
            }
            //会改变大小和随地图移动
            else if(idParams.$parent === 4) {
                //idParams.$parent = itemViewPort.itemContainer;

                objTmpComponents = _private.objTmpMapComponents;
                tmpSprites = objTmpComponents[idParams.$id];
            }
            //某角色上
            else if(GlobalLibraryJS.isString(idParams.$parent)) {
                let role = game.hero(idParams.$parent);
                if(!role)
                    role = game.role(idParams.$parent);
                if(role) {
                    //idParams.$parent = role;

                    objTmpComponents = role.$tmpComponents;
                    tmpSprites = objTmpComponents[idParams.$id];
                }
                else
                    return false;

            }
            else if(GlobalLibraryJS.isObject(idParams.$parent)) {
                //不一定存在
                objTmpComponents = idParams.$parent.$tmpComponents;

                tmpSprites = idParams;
            }
            //固定屏幕上
            else {
                //idParams.$parent = rootGameScene;

                objTmpComponents = _private.objTmpComponents;
                tmpSprites = objTmpComponents[idParams.$id];
            }


            if(idParams['$id'] === -1 && objTmpComponents) {
                for(let ti in objTmpComponents) {
                    if(objTmpComponents[ti].$componentType === 2) {
                        //自定义 释放函数
                        if(objTmpComponents[ti].Destroy)
                            objTmpComponents[ti].Destroy();
                        else if(objTmpComponents[ti].destroy)
                            objTmpComponents[ti].destroy();
                        delete objTmpComponents[ti];
                    }
                }

                return true;
            }


            if(tmpSprites && tmpSprites.$componentType === 2) {
                if(tmpSprites.Destroy)
                    tmpSprites.Destroy();
                else if(tmpSprites.destroy)
                    tmpSprites.destroy();

                //_private.cacheSprites.release(tmpSprites);
                if(objTmpComponents)
                    delete objTmpComponents[idParams.$id];

                return true;
            }

            return null;
        }


        //设置操作（遥感可用和可见、键盘可用）；
        //参数$gamepad的$visible和$enabled，$keyboard的$enabled；
        //  也可以是 二进制数字
        //参数为空则返回遥感组件，可自定义；
        readonly property var control: function(config={}) {
            if(!config)
                return itemGamePad;

            if(config && config.$gamepad !== undefined) {
                if(GlobalLibraryJS.isNumber(config.$gamepad)) {
                    itemGamePad.enabled = config.$gamepad & 0b1;
                    itemGamePad.visible = config.$gamepad & 0b10;
                }
                else {
                    if(config.$gamepad.$enabled !== undefined)
                        itemGamePad.enabled = config.$gamepad.$enabled;
                    if(config.$gamepad.$visible !== undefined)
                        itemGamePad.visible = config.$gamepad.$visible;
                }
            }
            if(config && config.$keyboard !== undefined) {
                if(GlobalLibraryJS.isNumber(config.$keyboard)) {
                    _private.config.bKeyboard = config.$keyboard & 0b1;
                }
                else if(config.$keyboard.$enabled !== undefined)
                    _private.config.bKeyboard = config.$keyboard.$enabled;
            }
        }

        //将场景缩放n倍；可以是小数。
        readonly property var scale: function(n) {
            itemViewPort.gameScene.scale = parseFloat(n);
            setSceneToRole(_private.sceneRole);

            game.gd['$sys_scale'] = parseFloat(n);
        }

        //场景跟随某个角色 或 自由移动
        //r为字符串表示跟随角色；为数字，则表示进入自由移动地图模式且设置为速度
        readonly property var setscenerole: function(r=0.2) {
            let role;

            if(GlobalLibraryJS.isString(r)) {
                role = game.hero(r);
                if(!role)
                    role = game.role(r);
                if(!role)
                    return false;

                _private.sceneRole = role;
                setSceneToRole(_private.sceneRole);
            }
            else if(GlobalLibraryJS.isNumber(r)) {
                _private.sceneRole = null;
                _private.config.rSceneMoveSpeed = r;
            }
            else if(GlobalLibraryJS.isObject(r)) {
                _private.sceneRole = r;
            }
            else
                _private.sceneRole = null;
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
            _private.stopMove(0);

            if(_private.config.objPauseNames[name] > 0) {
                _private.config.objPauseNames[name] += times;
                console.warn('[!GameScene]游戏被(%1)多次暂停 %2 次，请检查是否有暂停游戏的指令（比如msg、menu等）没有使用yield？'.arg(name).arg(_private.config.objPauseNames[name]));
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

            //rootGameScene.forceActiveFocus();
        }

        //设置游戏刷新率（interval毫秒）。
        readonly property var interval: function(interval=16) {
            if(GlobalLibraryJS.isValidNumber(interval)) {
                _private.config.nInterval = interval;
            }
            else
                return game.gd['$sys_fps'];

            if(_private.config.nInterval <= 0)
                _private.config.nInterval = 16;
            timer.interval = _private.config.nInterval;
            game.gd['$sys_fps'] = _private.config.nInterval;
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
        //  $visible：为false表示关闭窗口；
        //  $value：战斗人物信息（0b10）时为下标；
        //style：样式，包括MaskColor、BorderColor、BackgroundColor、ItemFontSize、ItemFontColor、ItemBackgroundColor1、ItemBackgroundColor2、TitleFontSize、TitleBackgroundColor、TitleFontColor、ItemBorderColor；
        //pauseGame同msg的参数；
        readonly property var window: function(params=null, style={}, pauseGame=true, callback=true) {
            if(GlobalLibraryJS.isValidNumber(params))
                params = {$id: params, $visible: true};
            else if(!params) {
                params = {$id: 0b1111, $visible: true};
            }


            //显示
            if(params.$visible !== false) {
                gameMenuWindow.show(params.$id, params.$value, style, pauseGame, callback);
            }
            else
                gameMenuWindow.closeWindow(params.$id);


            return gameMenuWindow;
        }

        //检测存档是否存在且正确，失败返回false，成功返回存档对象（包含Name和Data）。
        readonly property var checksave: function(fileName) {
            fileName = fileName.trim();
            let filePath = GlobalJS.toPath(GameMakerGlobal.config.strSaveDataPath + GameMakerGlobal.separator + fileName + '.json');
            if(!FrameManager.sl_qml_FileExists(filePath))
                return false;

            let data = FrameManager.sl_qml_ReadFile(filePath);
            //let cfg = File.read(filePath);
            //console.debug('musicInfo', filePath, musicInfo)
            //console.debug('cfg', cfg, filePath);

            if(data) {
                data = JSON.parse(data);

                //压缩
                if(data.Type === 1) {
                    //debug下不检测存档
                    if(GameMakerGlobal.config.debug === false && data.Verify !== Qt.md5(_private.config.strSaveDataSalt + data.Data)) {
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
                    if(GameMakerGlobal.config.debug === false && data.Verify !== Qt.md5(_private.config.strSaveDataSalt + JSON.stringify(data.Data))) {
                        return false;
                    }
                    return data;
                }
            }
            return false;
        }

        //存档（将game.gd存为 文件，开头为 $$ 的键不会保存；同时保存 引擎变量）
        //showName为显示名；
        //type为0普通保存，为1启用压缩；compressionLevel为压缩级别（1-9，-1为默认）；
        //成功返回true（生成器返回 写入字节数）
        readonly property var save: function*(fileName='autosave', showName='', type=1, compressionLevel=-1) {
            //asyncScript.runNextEventLoop('save');


            fileName = fileName.trim();
            if(!fileName)
                fileName = 'autosave';



            //game.run(function*(){
            //载入before_save脚本
            if(_private.objCommonScripts['before_save']) {
                let r = _private.objCommonScripts['before_save']();
                if(GlobalLibraryJS.isGenerator(r))yield *r;
                //game.run([_private.objCommonScripts['before_save']() ?? null, 'before_save'], {Priority: -3, Type: 0, Running: 1});
            }



            let filePath = GameMakerGlobal.config.strSaveDataPath + GameMakerGlobal.separator + fileName + '.json';

            let outputData = {};
            let fileData;

            //过滤掉 $$ 开头的所有键
            let fSaveFilter = function(k, v) {
                if(k.indexOf('$$') === 0)
                    return undefined;
                return v;
            }

            outputData.Version = '0.6';
            outputData.Name = showName;
            outputData.Type = type;
            outputData.Time = GlobalLibraryJS.formatDate();
            if(type === 1) {    //压缩
                let GlobalDataString = JSON.stringify(game.gd, fSaveFilter);
                outputData.Data = FrameManager.sl_qml_Compress(GlobalDataString, compressionLevel, 1).toString();
                outputData.Verify = Qt.md5(_private.config.strSaveDataSalt + outputData.Data);
                fileData = JSON.stringify(outputData, fSaveFilter);
            }
            else {
                let GlobalDataString = JSON.stringify(game.gd, fSaveFilter);
                outputData.Data = game.gd;
                outputData.Verify = Qt.md5(_private.config.strSaveDataSalt + GlobalDataString);
                fileData = JSON.stringify(outputData, fSaveFilter);
            }



            //!!!导出为文件
            //console.debug(JSON.stringify(outputData));
            //let ret = File.write(path + GameMakerGlobal.separator + 'map.json', JSON.stringify(outputData));
            let ret = FrameManager.sl_qml_WriteFile(fileData, GlobalJS.toPath(filePath), 0);
            //console.debug(itemViewPort.itemContainer.arrCanvasMap[2].toDataURL())


            //写入引擎变量
            GameMakerGlobal.settings.setValue("$RPG/" + GameMakerGlobal.config.strCurrentProjectName, game.cd);



            //载入after_save脚本
            if(_private.objCommonScripts['after_save']) {
                let r = _private.objCommonScripts['after_save'](ret);
                if(GlobalLibraryJS.isGenerator(r))yield *r;
                //game.run([_private.objCommonScripts['after_save']() ?? null, 'after_save'], {Priority: -1, Type: 0, Running: 1});
            }


            return ret;


            //}, {Priority: -2, Type: 0, Running: 1, Tips: 'save'});
            //return true;
        }

        //读档（读取数据到 game.gd），成功返回true（生成器返回true），失败返回false。
        readonly property var load: function*(fileName='autosave') {

            fileName = fileName.trim();
            if(!fileName)
                fileName = 'autosave';

            let ret = checksave(fileName)
            if(!ret) {
                //asyncScript.runNextEventLoop('game.load');
                return false;
            }


            //！！！鹰：注意：load是异步调用；且将 Priority 设置为顺序的（保证 game.load 的所有异步脚本执行完毕 再执行 game.load 的下一个命令）
            //let priority = 0;


            //game.run(function*() {

            //载入after_load脚本
            if(_private.objCommonScripts['before_load']) {
                let r = _private.objCommonScripts['before_load']();
                if(GlobalLibraryJS.isGenerator(r))yield *r;
                //game.run([_private.objCommonScripts['before_load']() ?? null, 'before_load'], {Priority: priority++, Type: 0, Running: 1});
            }


            //let filePath = GameMakerGlobal.config.strSaveDataPath + GameMakerGlobal.separator + fileName + '.json';


            yield *release(false);
            yield *_init(false, false, ret['Data']);


            //game.gd = ret['Data'];
            //GlobalLibraryJS.copyPropertiesToObject(game.gd, ret['Data']);


            game.$sys.reloadFightRoles();

            //刷新战斗时人物数据
            //fight.$sys.refreshCombatant(-1);

            game.$sys.reloadGoods();


            //读取主角
            for(let th of game.gd['$sys_main_roles']) {
                let mainRole = game.createhero(th.$rid);
                mainRole.$$nActionType = 0;
                mainRole.$$arrMoveDirection = [0, 0];
                //game.hero(mainRole, th);
            }

            //开始移动地图
            //setSceneToRole(_private.sceneRole);

            //其他
            game.interval(game.gd['$sys_fps']);
            game.scale(game.gd['$sys_scale']);

            game.playmusic(game.gd['$sys_music']);

            /*if(game.gd['$sys_sound'] & 0b10)
                _private.config.nSoundConfig = 0;
            else
                _private.config.nSoundConfig = 1;
            */


            /*/写在钩子函数里了
            if(game.gd['$sys_random_fight']) {
                game.fighton(...game.gd['$sys_random_fight']);
            }
            */

            //地图
            if(game.gd['$sys_map'].$name)
                yield *game.loadmap(game.gd['$sys_map'].$name, null, true);


            //载入after_load脚本
            if(_private.objCommonScripts['after_load']) {
                let r = _private.objCommonScripts['after_load']();
                if(GlobalLibraryJS.isGenerator(r))yield *r;
                //game.run([_private.objCommonScripts['after_load']() ?? null, 'after_load'], {Priority: priority++, Type: 0, Running: 1});
            }


            return true;


            //}, {Priority: -2, Type: 0, Running: 1, Tips: 'load'});
            //return true;
        }

        //游戏结束（调用游戏结束脚本）；
        readonly property var gameover: function*(params) {
            //asyncScript.runNextEventLoop('gameover');


            //game.run(_private.objCommonScripts['game_over_script'](params) ?? null,
            //    {Priority: -1, Type: 0, Running: 1, Tips: 'gameover'});

            let r = _private.objCommonScripts['game_over_script'](params);
            if(GlobalLibraryJS.isGenerator(r))yield *r;
        }


        //返回插件
        //参数0是组织/开发者名，参数1是插件名
        readonly property var plugin: function*(...params) {

            if(params.length < 2) {
                //asyncScript.runNextEventLoop('plugin');
                return _private.objPlugins;
            }


            //let plugin = _private.objPlugins[params[0]][params[1]];
            let plugin = GlobalLibraryJS.getObjectValue(_private.objPlugins, params[0], params[1]);
            if(plugin && plugin.$autoLoad === false) {
                plugin.$autoLoad = true;

                //game.run(function*(){
                if(plugin.$load) {
                    let r = plugin.$load(params[0] + GameMakerGlobal.separator + params[1]);
                    if(GlobalLibraryJS.isGenerator(r))yield *r;
                }
                if(plugin.$init) {
                    let r = plugin.$init();
                    if(GlobalLibraryJS.isGenerator(r))yield *r;
                }

                return plugin;

                //}, {Priority: -2, Type: 0, Running: 1, Tips: 'plugin'});

                //game.run([plugin.$load() ?? null, 'plugin_load:' + params[0] + params[1]]);
                //game.run([plugin.$init() ?? null, 'plugin_init:' + params[0] + params[1]]);
            }
            else {
                if(!plugin) {
                    console.warn('[!GameScene]No Plugin:', params[0], params[1], Object.keys(_private.objPlugins));
                    return;
                }
                //asyncScript.runNextEventLoop('plugin');
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
        readonly property var loadjson: function(fileName, filePath='') {
            fileName = fileName.trim();
            if(!fileName)
                return null;

            if(!filePath)
                filePath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + fileName);
            else
                filePath = GlobalJS.toPath(filePath + GameMakerGlobal.separator + fileName);

            let data = FrameManager.sl_qml_ReadFile(filePath);

            if(!data) {
                console.warn('[!GameScene]loadjson Fail:', filePath);
                return null;
            }
            return JSON.parse(data);
        }


        //将代码放入 系统脚本引擎（asyncScript）中 等候执行；
        //  vScript 为执行脚本（字符串、函数、生成器函数、生成器对象都可以），如果为false则表示强制执行队列，为true表示下次js事件循环再运行，为null直接返回，为undefined报错后返回；
        //    可以为数组（vScript是执行脚本时 为 第二个下标为tips，是null或true时为给_private.asyncScript.lastEscapeValue值）；
        //  scriptProps：
        //    如果为数字，表示优先级Priority；
        //      Type默认为0，Running默认为1，Value默认为无；
        //    如果为对象，则有以下参数：
        //      Priority为优先级；>=0为插入到对应的事件队列下标位置（0为挂到第一个）；-1为追加到队尾（默认）；-2为立即执行（此时代码前必须有yield）；-3为将此 函数/生成器 执行完毕再返回（注意：代码里yield不能返回到游戏中了，所以最好别用生成器或yield）；
        //      Type为运行类型（如果为0（默认），表示为代码，否则表示vScript为JS文件名，而scriptProps.Path为路径）；
        //      Running为1或2，表示如果队列里如果为空则：1（默认）是发送一个JS事件在下一个JS事件循环里执行，2是立即执行；为0时不处理；
        //      Value：传递给事件队列的值，无则默认上一次的；
        //      AsyncScript：脚本队列，无则默认 本脚本队列；
        //      Tips：
        readonly property var run: function(vScript, scriptProps=-1, ...params) {
            if(vScript === undefined || (GlobalLibraryJS.isArray(vScript) && vScript[0] === undefined)) {
                console.warn('[!GameScene]运行脚本未定义（可忽略）');
                console.debug(new Error().stack);
                //console.exception('[!GameScene]运行脚本未定义（可忽略）');

                return undefined;
            }
            if(vScript === null) {
                return null;
            }


            //参数
            let priority, runType = 0, running = 1, value, asyncScript, tips;
            if(GlobalLibraryJS.isValidNumber(scriptProps)) {   //如果是数字，则默认是优先级
                scriptProps = {Priority: scriptProps};
            }
            if(GlobalLibraryJS.isObject(scriptProps)) { //如果是参数对象
                asyncScript = scriptProps.AsyncScript || _private.asyncScript;
                priority = GlobalLibraryJS.isValidNumber(scriptProps.Priority) ? scriptProps.Priority : -1;
                runType = GlobalLibraryJS.isValidNumber(scriptProps.Type) ? scriptProps.Type : 0;
                running = GlobalLibraryJS.isValidNumber(scriptProps.Running) ? scriptProps.Running : 1;
                value = Object.keys(scriptProps).indexOf('Value') < 0 ? asyncScript.lastEscapeValue : scriptProps.Value;
                tips = scriptProps.Tips;
            }
            else {
                console.warn('[!GameScene]运行脚本属性错误!!!');
                return null;
            }



            //下次js循环运行
            if(vScript === true) {
                /*GlobalLibraryJS.runNextEventLoop(function() {
                    //game.goon('$event');
                        asyncScript.run(asyncScript.lastEscapeValue);
                    }, 'game.run1');
                */
                asyncScript.lastEscapeValue = value;
                asyncScript.runNextEventLoop('game.run1');

                return 1;
            }
            //直接运行
            else if(vScript === false) {
                asyncScript.run(value);
                return 0;
            }
            else if(GlobalLibraryJS.isArray(vScript)) {
                tips = vScript[1] ?? tips;
                vScript = vScript[0];
            }
            //else {
            //    console.warn('[!GameScene]运行脚本属性错误!!!');
            //    return null;
            //}


            if(runType === 0) { //vScript是代码

            }
            else {  //vScript是文件名
                if(!scriptProps.Path)
                    scriptProps.Path = game.$projectpath;
                vScript = GlobalJS.toPath(scriptProps.Path + GameMakerGlobal.separator + vScript.trim());
            }

            //可以立刻执行
            let ret = GlobalJS.createScript(asyncScript, {Type: runType, Priority: priority, Script: vScript, Tips: tips}, ...params);
            if(ret === 0) {
                //暂停游戏主Timer，否则有可能会Timer先超时并运行game.run(false)，导致执行两次
                //game.pause('$event');

                if(running === 1) {
                    //GlobalLibraryJS.setTimeout(function() {
                    /*GlobalLibraryJS.runNextEventLoop(function() {
                        //game.goon('$event');
                            asyncScript.run(asyncScript.lastEscapeValue);
                        }, 'game.run');
                    */
                    asyncScript.lastEscapeValue = value;
                    asyncScript.runNextEventLoop('game.run');

                    return 1;
                }
                else if(running === 2) {
                    asyncScript.run(value);
                    return 0;
                }
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

            if(GlobalJS.createScript(_private.asyncScript, {Type: 1, Priority: priority, Script: filePath, Tips: filePath}, ) === 0)
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
        readonly property var evalcode: function(data, filePath='', envs={}) {
            return GlobalJS._eval(data, filePath, envs);
        }

        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var evalfile: function(fileName, filePath='', envs={}) {
            fileName = fileName.trim();
            if(!filePath)
                filePath = game.$projectpath + GameMakerGlobal.separator + fileName;
            else
                filePath = filePath + GameMakerGlobal.separator + fileName;

            GlobalJS._evalFile(filePath, envs);
        }

        //用C++执行脚本；已注入game和fight环境
        readonly property var evaluate: function(program, filePath='', lineNumber = 1) {
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


        //局部/全局 数据/方法
        //d和f是地图变量，切换地图时清空
        property var d: ({})
        property var f: ({})
        //gd和gf是全局变量，读档会清空；gd会自动存档读档
        property var gd: ({})
        property var gf: ({})
        //cd是共享变量，进入游戏时初始化，读档不会清空
        property var cd: ({})
        //在f和gf中定义某些特定功能的函数，系统会自动触发（优先级：地图脚本高于f高于gf）
        //  比如地图事件、地图离开事件、NPC交互事件、地图点击事件、NPC点击事件、定时器事件、NPC抵达事件、NPC触碰事件



        //项目根目录
        property string $projectpath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.separator + GameMakerGlobal.config.strCurrentProjectName


        //用户脚本（用户 common_script.js，如果没有则指向 GameMakerGlobalJS）
        property var $userscripts: null


        //几个脚本（需要重新定义变量指向，否则外部qml和js无法使用）
        readonly property var $globalLibraryJS: GlobalLibraryJS
        readonly property var $global: Global
        readonly property var $globalJS: GlobalJS
        readonly property var $gameMakerGlobal: GameMakerGlobal
        readonly property var $gameMakerGlobalJS: GameMakerGlobalJS
        readonly property var $config: GameMakerGlobal.config

        //!!兼容旧代码；插件（直接访问，不推荐）
        readonly property alias $plugins: _private.objPlugins


        /*property var $fight: QtObject {
            //我方和敌方数据
            //内容为：$Combatant() 返回的对象（包含各种数据）
            property alias myCombatants: _myCombatants
            property alias enemies: _enemies
        }*/


        //系统 数据 和 函数（一般特殊需求）
        readonly property var $sys: ({
            release: release,
            init: _init,
            exit: _private.exitGame,

            screen: rootGameScene,          //屏幕（组件位置和大小固定）（所有，包含战斗场景）
            viewport: itemViewPort,         //游戏视窗，组件位置和大小固定
            scene: itemViewPort.gameScene,              //场景（组件位置和大小固定，但会被scale影响）
            map: itemViewPort.itemContainer,            //地图（组件会改变大小和随地图移动），会覆盖所有地图上的元素
            ground: itemViewPort.itemRoleContainer,     //地图地面（组件会改变大小和随地图移动），会根据z值判断是否覆盖元素

            interact: GameSceneJS.buttonAClicked,  //交互函数

            //重新创建战斗人物（修复继承链），并计算新属性
            reloadFightRoles: function() {

                let tFightHeros = game.gd['$sys_fight_heros'];
                game.gd['$sys_fight_heros'] = [];

                for(let tfh of tFightHeros) {
                    //let tfh = tFightHeros[tIndex];
                    if(tfh) {
                        tfh = GameSceneJS.getFightRoleObject(tfh, true);
                        game.gd['$sys_fight_heros'].push(tfh);
                        _private.objCommonScripts['refresh_combatant'](tfh);
                    }
                    else {
                        console.warn('[!GameScene]跳过存档中错误的战斗人物：', tfh);
                    }


                    /*let t = game.gd['$sys_fight_heros'][tIndex];
                    game.gd['$sys_fight_heros'][tIndex] = new _private.objCommonScripts['combatant_class'](t.$rid, t.$name);
                    GlobalLibraryJS.copyPropertiesToObject(game.gd['$sys_fight_heros'][tIndex], t);

                    //game.gd['$sys_fight_heros'][tIndex].__proto__ = _private.objCommonScripts['combatant_class'].prototype;
                    //game.gd['$sys_fight_heros'][tIndex].$$fightData = {};
                    //game.gd['$sys_fight_heros'][tIndex].$$fightData.$buffs = {};
                    */
                }
            },

            //重新创建背包（修复继承链）
            reloadGoods: function() {

                let tGoods = game.gd['$sys_goods'];
                game.gd['$sys_goods'] = [];

                for(let tg of tGoods) {
                    //let tg = tGoods[tIndex];
                    if(tg) {
                        tg = GameSceneJS.getGoodsObject(tg, true);
                        game.gd['$sys_goods'].push(tg);
                    }
                    else {
                        console.warn('[!GameScene]跳过存档中错误的道具：', tg);
                    }
                }
            },

            playSoundEffect: rootSoundEffect.playSoundEffect,

            getSkillObject: GameSceneJS.getSkillObject,
            getGoodsObject: GameSceneJS.getGoodsObject,
            getFightRoleObject: GameSceneJS.getFightRoleObject,
            getFightScriptObject: GameSceneJS.getFightScriptObject,

            getCommonScriptResource: GameSceneJS.getCommonScriptResource,
            getSkillResource: GameSceneJS.getSkillResource,
            getGoodsResource: GameSceneJS.getGoodsResource,
            getFightRoleResource: GameSceneJS.getFightRoleResource,
            getFightScriptResource: GameSceneJS.getFightScriptResource,
            getSpriteResource: GameSceneJS.getSpriteResource,
            getRoleResource: GameSceneJS.getRoleResource,
            getMapResource: GameSceneJS.getMapResource,

            loadSpriteEffect: GameSceneJS.loadSpriteEffect,
            unloadSpriteEffect: GameSceneJS.unloadSpriteEffect,
            loadRole: GameSceneJS.loadRole,

            delay: GlobalLibraryJS.runNextEventLoop,
            timeout: GlobalLibraryJS.setTimeout,


            //组件 和 组件模板
            components: {
                joystick: joystick,
                buttons: itemButtons,
                fps: itemFPS,
                map: [itemViewPort.canvasBackMap, itemViewPort.canvasFrontMap],
                msgs: itemGameMsgs,
                talk: itemRootRoleMsg,
                menus: itemGameMenus,
                input: itemRootGameInput,
                trade: dialogTrade,
                window: gameMenuWindow,
                video: itemVideo,
                gamePad: itemGamePad,

                compSprite: compCacheSpriteEffect,
                compMsg: compGameMsg,
                compMenu: compGameMenu,
                compRole: compRole,
                compSound: compCacheSoundEffect,
                compImage: compCacheImage,
                compWordMove: compCacheWordMove,
            },

            //资源
            resources: $resources,
            caches: $caches,

            //4个对象（fightRole、goods、skill、fightScript）的根prototype对象，从通用脚本中读取
            protoObjects: {},

            //钩子函数
            hooks: {
                init: {},   //初始化函数（参数为bLoadResources）
                release: {},    //释放函数（参数为bUnloadResources）
            },
        })


        //注意：除了通用脚本，其他资源有可能还没有载入，所以应该使用 getXxx 函数来返回；
        readonly property QtObject $resources: QtObject {
            readonly property alias goods: _private.goodsResource
            readonly property alias fightRoles: _private.fightRolesResource
            readonly property alias skills: _private.skillsResource
            readonly property alias fightScripts: _private.fightScriptsResource
            readonly property alias sprites: _private.spritesResource
            readonly property alias roles: _private.rolesResource
            readonly property alias maps: _private.mapsResource

            readonly property alias plugins: _private.objPlugins

            readonly property alias commonScripts: _private.objCommonScripts
        }

        //缓存
        readonly property QtObject $caches: QtObject {
            readonly property alias jsEngine: _private.jsEngine
            readonly property alias asyncScript: _private.asyncScript


            readonly property alias mainRoles: _private.arrMainRoles
            readonly property alias roles: _private.objRoles

            readonly property alias globalTimers: _private.objGlobalTimers
            readonly property alias timers: _private.objTimers


            readonly property alias cacheSoundEffects: rootSoundEffect.objCacheSoundEffects


            readonly property alias tmpComponents: _private.objTmpComponents
            readonly property alias tmpMapComponents: _private.objTmpMapComponents

            //readonly property alias objImages: _private.objImages
            //readonly property alias objMusic: _private.objMusic
            //readonly property alias objVideos: _private.objVideos

        }


        //上次帧间隔时长
        property int $frameDuration: 0

        property alias pointWalkDeviation: _private.pointWalkDeviation

        //property real fAspectRatio: Screen.width / Screen.height



        //地图大小和视窗大小
        //readonly property size $mapSize: Qt.size(itemViewPort.itemContainer.width, itemViewPort.itemContainer.height)
        //readonly property size $sceneSize: Qt.size(itemViewPort.width, itemViewPort.height)



        readonly property var date: ()=>{return new Date();}
        readonly property var math: Math
        readonly property var request: GlobalLibraryJS.request
        readonly property var http: XMLHttpRequest



        //资源（!!!鹰：过时：兼容旧代码）
        readonly property alias objGoods: _private.goodsResource
        readonly property alias objFightRoles: _private.fightRolesResource
        readonly property alias objSkills: _private.skillsResource
        readonly property alias objFightScripts: _private.fightScriptsResource
        readonly property alias objSprites: _private.spritesResource

        readonly property alias objCommonScripts: _private.objCommonScripts

        readonly property alias objCacheSoundEffects: rootSoundEffect.objCacheSoundEffects
    }


    property Item mainRole
    //property alias mainRole: mainRole


    property alias _public: _public

    property alias config: _private.config
    //property alias _private: _private

    property alias fightScene: loaderFightScene

    property alias asyncScript: _private.asyncScript



    //是否是测试模式（不会调用 游戏开始、初始化、结束脚本）
    property bool bTest: false


    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    //anchors.fill: parent

    focus: true
    clip: true

    //color: 'black'



    Mask {
        anchors.fill: parent
        color: 'black'
        //opacity: 0
    }


    //地图和视窗
    GameMapView {
        id: itemViewPort


        //地图脚本（map.js）
        property var mapScript: null


        //anchors.fill: parent
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

        clip: true

        bSmooth: GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$map', '$smooth'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$map', '$smooth'), true)


        //mouseArea.hoverEnabled: true
        mouseArea.onClicked: {
            GameSceneJS.mapClickEvent(mouse.x, mouse.y);
        }

        /*mouseArea.onPositionChanged: {
            let blockPixel = Qt.point(Math.floor(mouse.x / itemViewPort.sizeMapBlockScaledSize.width) * itemViewPort.sizeMapBlockScaledSize.width, Math.floor(mouse.y / itemViewPort.sizeMapBlockScaledSize.height) * itemViewPort.sizeMapBlockScaledSize.height);
            console.warn(blockPixel.x, blockPixel.y);
        }*/
    }


    //游戏FPS
    Timer {
        id: timer


        property var nLastTime: 0


        repeat: true
        interval: 16
        triggeredOnStart: false
        running: false
        onRunningChanged: {
            if(running === true)
                nLastTime = new Date().getTime();
        }


        onTriggered: {
            GameSceneJS.onTriggered();
            //使用脚本队列的话，人物移动就不能在asyncScript.wait下使用了
            //game.run(GameSceneJS.onTriggered);
            //game.run(true);
        }
    }



    //操控杆
    Item {
        id: itemGamePad


        anchors.fill: parent
        z: 1


        Joystick {
            id: joystick

            //忽略的最大偏移比
            property real rJoystickMinimumProportion: 0.2   //开启摇杆加速功能（最低速度使能）

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
                    _private.stopMove(0);
                }
                //console.debug('[GameScene]Joystick onPressedChanged:', pressed)
            }

            onPointInputChanged: {
                //console.debug('[GameScene]onPointInputChanged', pointInput);
                //if(pointInput === Qt.point(0,0))
                //    return;

                if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                    return;

                if(!pressed)    //如果没按下
                    return;

                if(mainRole.$$nActionType === -1)
                    return;


                //忽略
                if(Math.abs(pointInput.x) < rJoystickMinimumProportion && Math.abs(pointInput.y) < rJoystickMinimumProportion) { //小于使能
                    _private.pointWalkDeviation = Qt.point(0, 0);
                    return;
                }

                _private.pointWalkDeviation = pointInput;

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


            color: 'red'

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


            color: 'blue'

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

        source: './FightScene.qml'
        asynchronous: false


    */
    FightScene {
        id: loaderFightScene


        visible: false
        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 2


        Connections {
            target: loaderFightScene

            ignoreUnknownSignals: true

            function onS_FightOver() {
            }
        }

        Component.onCompleted: {
            //loaderFightScene.asyncScript = _private.asyncScript;
        }
    }



    //菜单
    GameMenuWindow {
        id: gameMenuWindow


        function show(id, value, style={}, _pauseGame=true, callback=true) {

            gameMenuWindow.pauseGame = _pauseGame;
            gameMenuWindow.fCallback = callback;


            if(pauseGame === true)
                pauseGame = '$menu_window';
            //是否暂停游戏
            if(GlobalLibraryJS.isString(pauseGame)) {
                //loaderGameMsg.bPauseGame = true;
                game.pause(pauseGame);
            }


            /*switch(params.$id) {
            case 1:
                break;
            case 2:
                break;
            }*/
            gameMenuWindow.showWindow(id, value, style);
        }


        property var pauseGame
        property var fCallback: null


        visible: false
        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 3


        onS_close: {

            //默认回调函数
            let callback = function(itemWindow) {

                itemWindow.visible = false;

                //game.pause(true)[pauseGame]
                if(GlobalLibraryJS.isString(pauseGame) && _private.config.objPauseNames[pauseGame] !== undefined) {
                    //如果没有使用yield来中断代码，可以不要game.run(true)
                    game.goon(pauseGame);
                    game.run(true);
                    //_private.asyncScript.run(_private.asyncScript.lastEscapeValue);


                    //rootGameScene.forceActiveFocus();
                }
            }


            if(GlobalLibraryJS.isFunction(gameMenuWindow.fCallback)) {  //用户自定义回调函数（这个是高级函数，其他地方可以自定义它来实现新功能）
                if(gameMenuWindow.fCallback(gameMenuWindow) !== true)   //如果返回 非true，则继续调用默认回调函数
                    callback(gameMenuWindow);
            }
            else if(gameMenuWindow.fCallback === true) {    //默认回调函数
                callback(gameMenuWindow);
            }
            else if(gameMenuWindow.fCallback) {   //其他类型的回调函数（比如生成器），因为游戏暂停中所以必须先调用默认回调函数（作为简单使用）；
                callback(gameMenuWindow);
                game.run(gameMenuWindow.fCallback, -1, gameMenuWindow);
            }
            else {   //不使用 回调函数
                //gameMap.focus = true;

                gameMenuWindow.visible = false;


                /* /*if(gameMenuWindow.bPauseGame && _private.config.bPauseGame) {
                    game.goon();
                    gameMenuWindow.bPauseGame = false;
                }* /*/

                /*if(_private.config.objPauseNames['$msg'] !== undefined) {
                    game.goon('$msg');
                    _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                }*/



                //gameMenuWindow.destroy();
                ////FrameManager.goon();
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


        function show(goods=[], mygoodsinclude=true, _pauseGame=true, callback=true) {

            dialogTrade.pauseGame = _pauseGame;
            dialogTrade.fCallback = callback;


            if(pauseGame === true)
                pauseGame = '$trade';

            //是否暂停游戏
            if(GlobalLibraryJS.isString(pauseGame)) {
                //loaderGameMsg.bPauseGame = true;
                game.pause(pauseGame);

                //loaderGameMsg.focus = true;
            }
            else {
            }


            init(goods, mygoodsinclude);
            visible = true;
        }


        property var pauseGame
        property var fCallback


        visible: false
        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 4


        onS_close: {

            //默认回调函数
            let callback = function(itemTrade) {

                itemTrade.visible = false;

                //game.pause(true)[pauseGame]
                if(GlobalLibraryJS.isString(pauseGame) && _private.config.objPauseNames[pauseGame] !== undefined) {
                    //如果没有使用yield来中断代码，可以不要game.run(true)
                    game.goon(pauseGame);
                    game.run(true);
                    //_private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                }


                //itemTrade.destroy();


                //rootGameScene.forceActiveFocus();
            };


            if(GlobalLibraryJS.isFunction(dialogTrade.fCallback)) {  //用户自定义回调函数（这个是高级函数，其他地方可以自定义它来实现新功能）
                if(dialogTrade.fCallback(dialogTrade) !== true)   //如果返回 非true，则继续调用默认回调函数
                    callback(dialogTrade);
            }
            else if(dialogTrade.fCallback === true) {    //默认回调函数
                callback(dialogTrade);
            }
            else if(dialogTrade.fCallback) {   //其他类型的回调函数（比如生成器），因为游戏暂停中所以必须先调用默认回调函数（作为简单使用）；
                callback(dialogTrade);
                game.run(dialogTrade.fCallback, -1, dialogTrade);
            }
            else {   //不使用 回调函数
                //gameMap.focus = true;

                dialogTrade.visible = false;


                /* /*if(dialogTrade.bPauseGame && _private.config.bPauseGame) {
                    game.goon();
                    dialogTrade.bPauseGame = false;
                }* /*/

                /*if(_private.config.objPauseNames['$msg'] !== undefined) {
                    game.goon('$msg');
                    _private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                }*/



                //dialogTrade.destroy();
                ////FrameManager.goon();
            }
        }
    }



    //角色对话框
    Item {
        id: itemRootRoleMsg


        //显示完全后延时
        property int nKeepTime: 0
        //显示状态：-1：停止；0：显示完毕；1：正在显示
        property int nShowStatus: -1

        //是否暂停
        property var pauseGame: true
        //回调函数
        property var fCallback


        //signal accepted();
        //signal rejected();


        function over(code) {
            itemRootRoleMsg.nShowStatus = -1;


            //默认回调函数
            let callback = function(code, itemMsg) {

                itemMsg.visible = false;

                //game.pause(true)[pauseGame]
                if(GlobalLibraryJS.isString(pauseGame) && _private.config.objPauseNames[pauseGame] !== undefined) {
                    //如果没有使用yield来中断代码，可以不要game.run(true)
                    game.goon(pauseGame);
                    game.run(true);
                    //_private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                }


                //itemMsg.destroy();


                //rootGameScene.forceActiveFocus();
            };


            if(GlobalLibraryJS.isFunction(itemRootRoleMsg.fCallback)) {    //用户自定义回调函数（这个是高级函数，其他地方可以自定义它来实现新功能）
                if(itemRootRoleMsg.fCallback(code, itemRootRoleMsg) !== true)   //如果返回 非true，则继续调用默认回调函数
                    callback(code, itemRootRoleMsg);
            }
            else if(itemRootRoleMsg.fCallback === true) {    //默认回调函数
                callback(code, itemRootRoleMsg);
            }
            else if(itemRootRoleMsg.fCallback) {   //其他类型的回调函数（比如生成器），因为游戏暂停中所以必须先调用默认回调函数（作为简单使用）；
                callback(code, itemRootRoleMsg);
                game.run(itemRootRoleMsg.fCallback, -1, code, itemRootRoleMsg);
            }
            else {   //不使用 回调函数
                //gameMap.focus = true;

                itemRootRoleMsg.visible = false;


                /* /*if(itemRootRoleMsg.bPauseGame && _private.config.bPauseGame) {
                    game.goon();
                    itemRootRoleMsg.bPauseGame = false;
                }* / */

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

        function show(role=null, msg='', interval=20, pretext='', keeptime=0, style=null, _pauseGame=true, callback=true) {

            itemRootRoleMsg.pauseGame = _pauseGame;
            itemRootRoleMsg.fCallback = callback;



            let name = '', avatar = '', avatarSize = null;
            if(role && GlobalLibraryJS.isString(role)) {
                do {
                    let roleName = role;
                    role = game.hero(roleName);
                    if(role !== null) {
                        name = role.$data.$name;
                        avatar = role.$data.$avatar;
                        avatarSize = role.$data.$avatarSize;
                        break;
                    }
                    role = game.role(roleName);
                    if(role !== null) {
                        name = role.$data.$name;
                        avatar = role.$data.$avatar;
                        avatarSize = role.$data.$avatarSize;
                        break;
                    }
                    role = GameSceneJS.getRoleResource(roleName);
                    if(role !== null) {
                        name = roleName;
                        avatar = role.Avatar;
                        avatarSize = role.AvatarSize;
                        break;
                    }
                    role = null;
                }while(0);
            }



            if(pauseGame === true)
                pauseGame = '$talk';
            //是否暂停游戏
            if(GlobalLibraryJS.isString(pauseGame)) {
                //loaderGameMsg.bPauseGame = true;
                game.pause(pauseGame);

                //loaderGameMsg.focus = true;
            }
            else {
            }



            //样式
            if(!style)
                style = {};
            let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$talk') || {};
            let styleSystem = game.$gameMakerGlobalJS.$config.$styles.$talk;


            let bShowName = GlobalLibraryJS.shortCircuit(0b1, style.Name, styleUser.$name, styleSystem.$name);
            let bShowAvatar = GlobalLibraryJS.shortCircuit(0b1, style.Avatar, styleUser.$avatar, styleSystem.$avatar);
            //let bShowName = GlobalLibraryJS.shortCircuit(0b1, style.Name, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$talk', '$name'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$styles', '$talk', '$name'));
            //let bShowAvatar = GlobalLibraryJS.shortCircuit(0b1, style.Avatar, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$talk', '$avatar'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$styles', '$talk', '$avatar'));
            if(name && bShowName)
                pretext = name + '：' + pretext;
            if(avatar && bShowAvatar)
                pretext = GlobalLibraryJS.showRichTextImage(GameMakerGlobal.imageResourceURL(avatar), avatarSize[0], avatarSize[1]) + pretext;


            messageRole.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
            messageRole.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
            messageRole.textArea.font.pointSize = style.FontSize || styleUser.$fontSize || styleSystem.$fontSize;
            messageRole.textArea.color = style.FontColor || styleUser.$fontColor || styleSystem.$fontColor;
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
        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 5


        Mask {
            id: maskMessageRole

            anchors.fill: parent

            visible: color.a !== 0

            color: 'transparent'

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
            textArea.readOnly: true

            textArea.onReleased: {
                itemRootRoleMsg.clicked();
                ////rootGameScene.forceActiveFocus();
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
                ////rootGameScene.forceActiveFocus();
                //console.debug('MultiPointTouchArea1')
                itemRootRoleMsg.over();
                //console.debug('MultiPointTouchArea2')
            }
        }*/

    }


    /*Loader {
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
        * /

        onLoaded: {
        }
    }
    */
    //临时存放创建的Menus
    Item {
        id: itemGameMsgs


        //创建一个自增1
        property int nIndex: 0


        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 6

    }


    //临时存放创建的Menus
    Item {
        id: itemGameMenus


        //创建一个自增1
        property int nIndex: 0


        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 7

    }

    //游戏 输入框
    Item {
        id: itemRootGameInput


        function show(title='', pretext='', style={}, _pauseGame=true, callback=true) {
            itemRootGameInput.pauseGame = _pauseGame;
            itemRootGameInput.fCallback = callback;

            if(pauseGame === true)
                pauseGame = '$input';
            //是否暂停游戏
            if(GlobalLibraryJS.isString(pauseGame)) {
                //loaderGameMsg.bPauseGame = true;
                game.pause(pauseGame);
            }
            else {
            }



            //样式
            if(style === undefined || style === null)
                style = {};
            let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$input') || {};
            let styleSystem = game.$gameMakerGlobalJS.$config.$styles.$input;

            rectGameInput.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
            rectGameInput.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
            textGameInput.font.pointSize = style.FontSize || styleUser.$fontSize || styleSystem.$fontSize;
            textGameInput.textArea.color = style.FontColor || styleUser.$fontColor || styleSystem.$fontColor;

            rectGameInputTitle.color = style.TitleBackgroundColor || styleUser.$titleBackgroundColor || styleSystem.$titleBackgroundColor;
            rectGameInputTitle.border.color = style.TitleBorderColor || styleUser.$titleBorderColor || styleSystem.$titleBorderColor;
            textGameInputTitle.font.pointSize = style.TitleFontSize || styleUser.$titleFontSize || styleSystem.$titleFontSize;
            textGameInputTitle.color = style.TitleFontColor || styleUser.$titleFontColor || styleSystem.$titleFontColor;

            maskGameInput.color = style.MaskColor || styleUser.$maskColor || styleSystem.$maskColor;


            textGameInputTitle.text = title;
            textGameInput.text = pretext;

            textGameInput.textArea.focus = true;


            visible = true;
        }



        property var pauseGame
        //回调函数
        property var fCallback


        visible: false
        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 8



        Mask {
            id: maskGameInput

            anchors.fill: parent

            visible: color.a !== 0

            color: '#7FFFFFFF'

            mouseArea.onPressed: {
                //itemRootGameInput.visible = false;
                //game.goon('$input');
                //_private.asyncScript.run(textGameInput.text);
            }
        }

        Rectangle {
            id: rectGameInputBack

            anchors.centerIn: parent
            width: parent.width * 0.8
            height: gameinput_columnlayout.implicitHeight

            clip: true


            radius: 6
            color: '#303030'


            ColumnLayout {
                id: gameinput_columnlayout
                anchors.fill: parent
                //height: parent.height * 0.6

                Rectangle {
                    id: rectGameInputTitle

                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: parent.width
                    //Layout.preferredHeight: 36
                    implicitHeight: Math.max(textGameInputTitle.implicitHeight, 60)

                    color: '#FF0035A8'
                    //color: '#EE00CC99'
                    //radius: itemMenu.radius

                    Text {
                        id: textGameInputTitle

                        anchors.fill: parent

                        color: 'white'

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.pointSize: 16
                        font.bold: true

                        wrapMode: Text.Wrap
                    }

                }


                Rectangle {
                    id: rectGameInput
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: textGameInput.implicitHeight


                    color: Global.style.backgroundColor

                    border {
                        color: '#60000000'
                    }


                    Notepad {
                        id: textGameInput

                        anchors.fill: parent


                        //color: 'white'

                        //horizontalAlignment: Text.AlignHCenter
                        //verticalAlignment: Text.AlignVCenter

                        //textArea.enabled: false
                        //textArea.readOnly: true
                        textArea.font.pointSize: 16
                        textArea.font.bold: true
                        textArea.textFormat: TextArea.PlainText

                        /*placeholderTextColor: '#7F7F7F7F'

                        selectByKeyboard: true
                        selectByMouse: true
                        wrapMode: Text.Wrap


                        //padding : nPadding
                        leftPadding : 6
                        rightPadding : 6
                        topPadding : 6
                        bottomPadding: 6
                        background: Item {
                            //color: 'transparent'
                            implicitHeight: 0
                            //color: Global.style.backgroundColor
                            //border.color: textGameInput.focus ? Global.style.accent : Global.style.hintTextColor
                            //border.width: textGameInput.focus ? 2 : 1
                        }
                        */
                    }
                }

                Button {

                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                    text: '确定'
                    onClicked: {

                        //默认回调函数
                        let callback = function(itemInput) {

                            itemInput.visible = false;

                            //game.pause(true)[pauseGame]
                            if(GlobalLibraryJS.isString(itemInput.pauseGame) && _private.config.objPauseNames[itemInput.pauseGame] !== undefined) {
                                //如果没有使用yield来中断代码，可以不要game.run(true)
                                game.goon(itemInput.pauseGame);
                                game.run(true, {Value: textGameInput.text});
                                //_private.asyncScript.run(textGameInput.text);
                            }


                            //rootGameScene.forceActiveFocus();
                        }


                        if(GlobalLibraryJS.isFunction(itemRootGameInput.fCallback)) {  //用户自定义回调函数（这个是高级函数，其他地方可以自定义它来实现新功能）
                            if(itemRootGameInput.fCallback(itemRootGameInput) !== true)
                                callback(itemRootGameInput);
                        }
                        //默认回调函数
                        else if(itemRootGameInput.fCallback === true) {
                            callback(itemRootGameInput);
                        }
                        else if(itemRootGameInput.fCallback) {   //其他类型的回调函数（比如生成器），因为游戏暂停中所以必须先调用默认回调函数（作为简单使用）；
                            callback(itemRootGameInput);
                            game.run(itemRootGameInput.fCallback, -1, itemRootGameInput);
                        }
                        else {   //不使用 回调函数
                            //gameMap.focus = true;

                            itemRootGameInput.visible = false;


                            /* /*if(itemRootGameInput.bPauseGame && _private.config.bPauseGame) {
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
    }

    //视频播放
    Mask {
        id: itemVideo


        function play() {
            if(pauseGame === true)
                pauseGame = '$video';

            //是否暂停游戏
            if(GlobalLibraryJS.isString(pauseGame)) {
                //loaderGameMsg.bPauseGame = true;
                game.pause(pauseGame);

                //loaderGameMsg.focus = true;
            }
            else {
            }

            playOrPause();
        }

        function playOrPause() {
            if(mediaPlayer.playbackState === MediaPlayer.PlayingState)
                mediaPlayer.pause();
            else
                mediaPlayer.play();

            visible = true;
            sliderMovie.forceActiveFocus();
        }

        function stop() {
            visible = false;
            mediaPlayer.stop();
            mediaPlayer.source = '';


            //game.pause(true)[pauseGame]
            if(GlobalLibraryJS.isString(pauseGame) && _private.config.objPauseNames[pauseGame] !== undefined) {
                //如果没有使用yield来中断代码，可以不要game.run(true)
                game.goon(pauseGame);
                game.run(true);
                //_private.asyncScript.run(_private.asyncScript.lastEscapeValue);
            }

            rootGameScene.forceActiveFocus();
        }


        property var pauseGame
        //property var fCallback
        property var fStateCallback


        visible: false
        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 9

        color: Global.style.backgroundColor



        ColumnLayout {
            anchors.fill: parent

            //渲染视频
            VideoOutput{
                id: videoOutput

                //anchors.centerIn: parent
                //anchors.fill: parent
                Layout.fillWidth: true
                Layout.fillHeight: true

                source: MediaPlayer {
                    id: mediaPlayer

                    //source: ''
                    //loops: MediaPlayer.Infinite
                    notifyInterval: 200
                    //playbackRate: 0.1

                    onStopped: {
                        game.stopvideo();
                    }

                    onPlaybackStateChanged: {
                        let eventName = `$video_state`;
                        let tScript;
                        do {
                            if(tScript = itemVideo.fStateCallback)
                                break;
                            /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
                                break;
                            */
                            if(tScript = game.f[eventName])
                                break;
                            if(tScript = game.gf[eventName])
                                break;
                        } while(0);

                        if(tScript)
                            game.run([tScript.call(mediaPlayer, playbackState, mediaPlayer, videoOutput) ?? null, eventName]);
                    }
                }

                //fillMode: VideoOutput.Stretch
                //x: 0
                //y: 0

                //width: rootGameScene.width
                //height: rootGameScene.height


                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.AllButtons  /*Qt.LeftButton | Qt.RightButton*/

                    onClicked: {
                        itemVideo.playOrPause();
                    }
                    onDoubleClicked: {
                        game.stopvideo();
                    }
                }
            }

            Slider {
                id: sliderMovie

                Layout.fillWidth: true
                //Layout.preferredHeight: 36


                from: 0
                to: mediaPlayer.duration
                stepSize: 5000
                value: mediaPlayer.position


                onMoved: {
                    //if(mediaPlayer.seekable)
                    //    mediaPlayer.position = value;
                    mediaPlayer.seek(value);

                    //console.debug(value, position);
                }
                /*onValueChanged: {
                    if(mediaPlayer.seekable)
                        mediaPlayer.position = value;

                }
                */
            }
        }

        Keys.onEscapePressed: {
            game.stopvideo();
            event.accepted = true;
            //Qt.quit();
        }
        Keys.onBackPressed: {
            game.stopvideo();
            event.accepted = true;
            //Qt.quit();
        }
    }



    //背景音乐
    Item {
        id: itemBackgroundMusic


        property var arrMusicStack: []  //播放音乐栈

        property var objMusicPause: ({})    //暂停类型

        property var fStateCallback


        function isPlaying() {
            return audioBackgroundMusic.playbackState === Audio.PlayingState;
        }

        function play(force=false) {
            if(force) {
                resume(-1);
            }
            else {
                //bPlay = true;
                if(!game.musicpausing())
                    //if(audioBackgroundMusic.playbackState !== Audio.StoppedState)
                    audioBackgroundMusic.play();
                //nPauseTimes = 0;
            }
        }

        function stop() {
            //bPlay = false;
            audioBackgroundMusic.stop();
            //nPauseTimes = 0;
        }

        function pause(name='$user') {
            if(name === true) { //引擎全局
                //GameMakerGlobal.settings.setValue('$PauseMusic', 1);
                game.cd['$PauseMusic'] = 1;
            }
            else if(name === false) { //存档
                game.gd['$sys_sound'] &= ~0b1;
            }
            else if(name && GlobalLibraryJS.isString(name)) {
                //if(objMusicPause[name] === 1)
                //    console.warn('游戏被多次暂停，请检查是否有暂停游戏的指令（比如msg、menu等）没有使用yield？');
                objMusicPause[name] = (objMusicPause[name] ? objMusicPause[name] + 1 : 1);
                //objMusicPause[name] = 1;
            }
            else
                return;


            if(audioBackgroundMusic.playbackState !== Audio.StoppedState)
                audioBackgroundMusic.pause();


            //console.debug('!!!pause', nPauseTimes)
        }

        function resume(name='$user') {
            if(name === true) { //引擎全局
                //GameMakerGlobal.settings.setValue('$PauseMusic', 0);
                game.cd['$PauseMusic'] = 0;
            }
            else if(name === false) { //存档
                game.gd['$sys_sound'] |= 0b1;
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
            else if(name === -1) {
                game.cd['$PauseMusic'] = 0;
                game.gd['$sys_sound'] |= 0b1;
                objMusicPause = {};
            }
            else
                return;


            if(audioBackgroundMusic.playbackState === Audio.PausedState)
                itemBackgroundMusic.play();

            //console.debug('!!!resume', nPauseTimes, bPlay)

        }

        Audio {
            id: audioBackgroundMusic

            loops: Audio.Infinite


            onPlaybackStateChanged: {
                let eventName = `$music_state`;
                let tScript;
                do {
                    if(tScript = itemBackgroundMusic.fStateCallback)
                        break;
                    /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
                        break;
                    */
                    if(tScript = game.f[eventName])
                        break;
                    if(tScript = game.gf[eventName])
                        break;
                } while(0);

                if(tScript)
                    game.run([tScript.call(audioBackgroundMusic, playbackState, audioBackgroundMusic) ?? null, eventName]);
            }
        }
    }

    //音效（特效的）
    QtObject {
        id: rootSoundEffect


        property var objCacheSoundEffects: ({})       //所有特效的音效组件

        property var objSoundEffectPause: ({})    //暂停类型


        function pause(name='$user') {
            if(name === true) { //引擎全局
                //GameMakerGlobal.settings.setValue('$PauseSound', 1);
                game.cd['$PauseSound'] = 1;
            }
            else if(name === false) { //存档
                game.gd['$sys_sound'] &= ~0b10;
            }
            else if(name && GlobalLibraryJS.isString(name)) {
                //if(objSoundEffectPause[name] === 1)
                //    console.warn('游戏被多次暂停，请检查是否有暂停游戏的指令（比如msg、menu等）没有使用yield？');
                objSoundEffectPause[name] = (objSoundEffectPause[name] ? objSoundEffectPause[name] + 1 : 1);
                //objSoundEffectPause[name] = 1;
            }
            else
                return;

            //console.debug('!!!pause', nPauseTimes)
        }

        function resume(name='$user') {
            if(name === true) { //引擎全局
                //GameMakerGlobal.settings.setValue('$PauseSound', 0);
                game.cd['$PauseSound'] = 0;
            }
            else if(name === false) { //存档
                game.gd['$sys_sound'] |= 0b10;
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
            else if(name === -1) {
                game.cd['$PauseSound'] = 0;
                game.gd['$sys_sound'] |= 0b10;
                objSoundEffectPause = {};
            }
            else
                return;

            //console.debug('!!!resume', nPauseTimes, bPlay)
        }



        function playSoundEffect(soundeffectSource) {
            if(rootSoundEffect.objCacheSoundEffects[soundeffectSource]) {
                if(game.soundeffectpausing())
                    return;

                //!!!鹰：手机上，如果状态为playing，貌似后面play就没声音了。。。
                if(rootSoundEffect.objCacheSoundEffects[soundeffectSource].isPlaying)
                    rootSoundEffect.objCacheSoundEffects[soundeffectSource].stop();
                rootSoundEffect.objCacheSoundEffects[soundeffectSource].play();
            }
        }

    }



    //调试
    Rectangle {
        id: itemFPS

        //width: Platform.compileType() === 'debug' ? rootGameScene.width / 3 : rootGameScene.width / 2
        //width: textFPS.width + textPos.width
        width: 150
        height: Platform.compileType() === 'debug' ? textFPS.implicitHeight : textFPS.implicitHeight
        color: '#90FFFFFF'


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

                //visible: Platform.compileType() === 'debug'
            }
        }

        Text {
            id: textPos1
            y: 15
            //width: 200
            width: 120
            height: 15

            visible: Platform.compileType() === 'debug'
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

        visible: false
        width: parent.width * 0.9
        height: Math.max(200, Math.min(parent.height, textScript.implicitHeight + 160))

        title: '执行脚本'
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: true

        anchors.centerIn: parent


        TextArea {
            id: textScript

            width: parent.width

            placeholderText: '输入脚本命令'

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
            //console.log('Cancel clicked');
        }
    }



    QtObject {  //公有数据,函数,对象等
        id: _public

    }


    QtObject {  //私有数据,函数,对象等
        id: _private


        //游戏配置/设置
        property var config: QtObject {
            //存档m5的盐
            readonly property string strSaveDataSalt: '深林孤鹰@鹰歌联盟Leamus_' + GameMakerGlobal.config.strCurrentProjectName

            //最大地图像素数
            property int nMapMaxPixelCount: 70*70*32*32


            //下面是游戏中可以修改的
            property int nInterval: 16

            property var objPauseNames: ({})     //暂停游戏（只停止游戏timer主循环，不会停止事件队列）

            //键盘是否可以操作
            property bool bKeyboard: true

            //场景移动速度
            property real rSceneMoveSpeed: 0.2


            //下面是从配置中读取的：
            //是否游戏提前载入所有资源
            property int nLoadAllResources: 0
            //万向移动
            property bool bWalkAllDirections: true


            //角色切换状态时长（毫秒）
            property int nRoleChangeActionDuration: 500
            //切换上右下左的概率（叠加概率，非概率值）（剩下是继续停止状态概率）
            property var arrRoleChangeActionProbability: [10, 20, 30, 40]
            //从行动 切换 停止状态概率
            property int arrRoleChangeStopProbability: 60

        }

        //主角移动偏移
        property point pointWalkDeviation
        onPointWalkDeviationChanged: {
            //移动为0
            if(_private.pointWalkDeviation.x === 0 && _private.pointWalkDeviation.y === 0) {
                _private.stopMove(0);
                return;
            }

            if(Math.abs(_private.pointWalkDeviation.x) > Math.abs(_private.pointWalkDeviation.y)) {

                if(_private.pointWalkDeviation.x > 0)
                    _private.startMove(0, Qt.Key_Right);
                else
                    _private.startMove(0, Qt.Key_Left);
            }
            else {
                if(_private.pointWalkDeviation.y > 0)
                    _private.startMove(0, Qt.Key_Down);
                else
                    _private.startMove(0, Qt.Key_Up);
            }

            //mainRole.$$nActionType = 10;
        }

        //场景跟踪角色
        property var sceneRole: mainRole

        //游戏目前阶段（0：正常；1：战斗）
        property int nStage: 0


        //临时保存屏幕旋转
        property int lastOrient: -1



        //资源（外部读取） 信息

        property var goodsResource: ({})         //所有道具信息；格式：key为 道具资源名，每个对象属性：$rid为 道具资源名，其他是脚本返回值（$commons）
        property var fightRolesResource: ({})        //所有战斗角色信息
        property var skillsResource: ({})        //所有技能信息
        property var fightScriptsResource: ({})        //所有战斗脚本信息

        property var spritesResource: ({})       //所有特效信息；格式：key为 特效资源名，每个对象属性：$rid为 为特效资源名，$$cache为缓存{image: Image组件, music: SoundEffect组件}
        property var rolesResource: ({})       //所有角色信息；格式：key为 角色资源名
        property var mapsResource: ({})       //所有地图信息；格式：key为 角色资源名

        property var objCommonScripts: ({})     //系统用到的 通用脚本（外部脚本优先，如果没有使用 GameMakerGlobal.js的）

        //所有插件脚本
        property var objPlugins: ({})

        //JS引擎，用来载入外部JS文件
        property var jsEngine: new GlobalJS.JSEngine(rootGameScene)

        //媒体列表 信息
        //property var objImages: ({})         //{图片名: 图片路径}
        //property var objMusic: ({})         //{音乐名: 音乐路径}
        //property var objVideos: ({})         //{视频名: 视频路径}


        //异步脚本（整个游戏的脚本队列系统）
        property var asyncScript: new GlobalLibraryJS.Async(rootGameScene)


        //创建的 主角 和 角色NPC 组件容器
        property var arrMainRoles: []
        property var objRoles: ({})

        //定时器
        property var objGlobalTimers: ({})        //{定时器名: [间隔,触发次数,是否全局,剩余时长]}
        property var objTimers: ({})        //{定时器名: [间隔,触发次数,是否全局,剩余时长]}


        property var objTmpComponents: ({})      //临时组件（特效和图片，用户创建，退出游戏删除用）
        //依附在地图上的图片和特效，切换地图时删除
        property var objTmpMapComponents: ({})

        //特效缓存类
        //  目前只有战斗的特效使用，地图场景的特效因为会挂载到 对应对象的tmp缓存中，和其他组件混在一起，只能使用destroy来释放，所以不适用。
        property var cacheSprites: new GlobalLibraryJS.Cache({
            Create: function(p){
                let o = compCacheSpriteEffect.createObject(p);
                o.s_playEffect.connect(rootSoundEffect.playSoundEffect);
                return o;
            },
            Init: function(o, p) {
                o.visible = true;
                o.parent=p;
                return o;
            },
            Release: function(o){o.visible = false; o.sprite.stop();return o;},
            Destroy: function(o){o.destroy();},
        })

        //地图缓存（目前没用到）
        //property var objCacheMaps: ({})



        //键盘处理
        property var arrPressedKeys: ([]) //保存按下的方向键

        //处理主角移动时的横纵方向的速率
        //type为操作类型，0为摇杆，1为键盘，2为定向移动
        //direction为方向
        function doMove(type, direction) {
            mainRole.$$arrMoveDirection = [0, 0];

            //摇杆
            if(type === 0) {
                mainRole.$$nActionType = 10;

                //四向
                if(!_private.config.bWalkAllDirections) {
                    //判断x、y的偏移哪个大
                    if(Math.abs(_private.pointWalkDeviation.x) > Math.abs(_private.pointWalkDeviation.y)) {
                        mainRole.$$arrMoveDirection[0] = Math.abs(_private.pointWalkDeviation.x) < joystick.rJoystickMinimumProportion ? 0 : _private.pointWalkDeviation.x;
                    }
                    else {
                        mainRole.$$arrMoveDirection[1] = Math.abs(_private.pointWalkDeviation.y) < joystick.rJoystickMinimumProportion ? 0 : _private.pointWalkDeviation.y;
                    }
                }
                //多向
                else {
                    mainRole.$$arrMoveDirection[0] = Math.abs(_private.pointWalkDeviation.x) < joystick.rJoystickMinimumProportion ? 0 : _private.pointWalkDeviation.x;
                    mainRole.$$arrMoveDirection[1] = Math.abs(_private.pointWalkDeviation.y) < joystick.rJoystickMinimumProportion ? 0 : _private.pointWalkDeviation.y;
                }
            }
            //键盘
            else if(type === 1) {
                mainRole.$$nActionType = 1;

                //四向
                if(!_private.config.bWalkAllDirections) {
                    switch(_private.arrPressedKeys[_private.arrPressedKeys.length - 1]) {
                    case Qt.Key_Down:
                        mainRole.$$arrMoveDirection[1] = 1;
                        break;
                    case Qt.Key_Left:
                        mainRole.$$arrMoveDirection[0] = -1;
                        break;
                    case Qt.Key_Right:
                        mainRole.$$arrMoveDirection[0] = 1;
                        break;
                    case Qt.Key_Up:
                        mainRole.$$arrMoveDirection[1] = -1;
                        break;
                    default:
                        break;
                    }
                }
                //多向
                else {
                    if(_private.arrPressedKeys.indexOf(Qt.Key_Left) >= 0 && _private.arrPressedKeys.indexOf(Qt.Key_Right) >= 0) {
                        mainRole.$$arrMoveDirection[0] = 0;
                    }
                    else if(_private.arrPressedKeys.indexOf(Qt.Key_Left) < 0 && _private.arrPressedKeys.indexOf(Qt.Key_Right) < 0) {
                        mainRole.$$arrMoveDirection[0] = 0;
                    }
                    else {
                        if(_private.arrPressedKeys.indexOf(Qt.Key_Left) >= 0)
                            mainRole.$$arrMoveDirection[0] = -1;
                        else
                            mainRole.$$arrMoveDirection[0] = 1;
                    }

                    if(_private.arrPressedKeys.indexOf(Qt.Key_Up) >= 0 && _private.arrPressedKeys.indexOf(Qt.Key_Down) >= 0) {
                        mainRole.$$arrMoveDirection[1] = 0;
                    }
                    else if(_private.arrPressedKeys.indexOf(Qt.Key_Up) < 0 && _private.arrPressedKeys.indexOf(Qt.Key_Down) < 0) {
                        mainRole.$$arrMoveDirection[1] = 0;
                    }
                    else {
                        if(mainRole.$$arrMoveDirection[0] !== 0) {
                            mainRole.$$arrMoveDirection[0] = mainRole.$$arrMoveDirection[0] === -1 ? -0.7 : 0.7;
                        }

                        if(_private.arrPressedKeys.indexOf(Qt.Key_Up) >= 0) {
                            if(mainRole.$$arrMoveDirection[0] !== 0) {
                                mainRole.$$arrMoveDirection[1] = -0.7;
                            }
                            else
                                mainRole.$$arrMoveDirection[1] = -1;
                        }
                        else {
                            if(mainRole.$$arrMoveDirection[0] !== 0) {
                                mainRole.$$arrMoveDirection[1] = 0.7;
                            }
                            else
                                mainRole.$$arrMoveDirection[1] = 1;
                        }
                    }
                }
            }
            //定向移动
            else if(type === 2) {
                mainRole.$$nActionType = 2;

                //四向
                if(!_private.config.bWalkAllDirections || 1) {
                    switch(direction) {
                    case Qt.Key_Down:
                        mainRole.$$arrMoveDirection[1] = 1;
                        break;
                    case Qt.Key_Left:
                        mainRole.$$arrMoveDirection[0] = -1;
                        break;
                    case Qt.Key_Right:
                        mainRole.$$arrMoveDirection[0] = 1;
                        break;
                    case Qt.Key_Up:
                        mainRole.$$arrMoveDirection[1] = -1;
                        break;
                    default:
                        break;
                    }
                }
                //多向
                else {
                    //人物的占位最中央 所在地图的坐标
                    let centerX = mainRole.x + mainRole.x1 + parseInt(mainRole.width1 / 2);
                    let centerY = mainRole.y + mainRole.y1 + parseInt(mainRole.height1 / 2);

                    if(mainRole.$$targetsPos[0].x - centerX === 0) {
                        mainRole.$$arrMoveDirection[0] = -1;
                        if(mainRole.$$targetsPos[0].y - centerY > 0) {
                            mainRole.$$arrMoveDirection[1] = 2;
                        }
                        else {
                            mainRole.$$arrMoveDirection[1] = 0;
                        }
                        return;
                    }
                    else if(mainRole.$$targetsPos[0].y - centerY === 0) {
                        mainRole.$$arrMoveDirection[1] = -1;
                        if(mainRole.$$targetsPos[0].x - centerX > 0) {
                            mainRole.$$arrMoveDirection[0] = 1;
                        }
                        else {
                            mainRole.$$arrMoveDirection[0] = 3;
                        }
                        return;
                    }

                    //!!!！！！有问题
                    let tPos = itemViewPort.getMapBlockPos(mainRole.$$targetsPos[0].x, mainRole.$$targetsPos[0].y);
                    var angle = Math.atan2(tPos[0] - centerY, tPos[1] - centerX);

                    mainRole.$$arrMoveDirection[0] = Math.cos(angle);
                    mainRole.$$arrMoveDirection[1] = Math.sin(angle);

                    //console.warn(angle, mainRole.$$arrMoveDirection)
                }
            }
        }

        //type为0表示摇杆，type为1表示键盘，2为自动行走
        function startMove(type, direction) {
            switch(direction) {
            case Qt.Key_Down:
                doMove(type, Qt.Key_Down);
                mainRole.start(Qt.Key_Down);
                //_private.startSprite(mainRole, Qt.Key_Down);
                //mainRole.$$nMoveDirectionFlag = Qt.Key_Down; //移动方向
                //mainRole.start();
                //timer.start();  //开始移动
                break;
            case Qt.Key_Left:
                doMove(type, Qt.Key_Left);
                mainRole.start(Qt.Key_Left);
                //_private.startSprite(mainRole, Qt.Key_Left);
                //mainRole.$$nMoveDirectionFlag = Qt.Key_Left;
                //mainRole.start();
                //timer.start();
                break;
            case Qt.Key_Right:
                doMove(type, Qt.Key_Right);
                mainRole.start(Qt.Key_Right);
                //_private.startSprite(mainRole, Qt.Key_Right);
                //mainRole.$$nMoveDirectionFlag = Qt.Key_Right;
                //mainRole.start();
                //timer.start();
                break;
            case Qt.Key_Up:
                doMove(type, Qt.Key_Up);
                mainRole.start(Qt.Key_Up);
                //_private.startSprite(mainRole, Qt.Key_Up);
                //mainRole.$$nMoveDirectionFlag = Qt.Key_Up;
                //mainRole.start();
                //timer.start();
                break;
            default:
                break;
            }
        }

        function stopMove(type, direction) {

            if(type === 1) {
                switch(direction) {
                case Qt.Key_Up:
                case Qt.Key_Right:
                case Qt.Key_Left:
                case Qt.Key_Down:
                    //获取下一个已经按下的键
                    //let l = Object.keys(arrPressedKeys);
                    let l = arrPressedKeys;
                    //console.debug(l);



                    //if(l.length === 0) {    //如果没有键被按下
                    if(l.length === 0) {
                        //timer.stop();
                        mainRole.stopMoving();
                        //mainRole.stop();
                        //console.debug('[GameScene]_private.stopMove stop');
                    }
                    else {
                        if(mainRole.$$nActionType === -1)
                            return;


                        startMove(type, parseInt(l[0]));
                        //doMove(type, parseInt(l[0]));
                        //mainRole.start(parseInt(l[0]));

                        //_private.startSprite(mainRole, l[0]);
                        //mainRole.$$nMoveDirectionFlag = l[0];    //弹出第一个按键
                        //mainRole.start();
                        //console.debug('[GameScene]_private.stopMove nextKey');
                    }
                    break;

                default:    //-1
                    arrPressedKeys = [];

                    mainRole.stopMoving();

                    //mainRole.stop();
                    //console.debug('[GameScene]_private.stopMove stop1');
                }
            }
            else {
                mainRole.stopMoving();
                //mainRole.stop();
                //console.debug('[GameScene]_private.stopMove stop2');
            }
        }


        /*function buttonMenuClicked() {
            console.debug('[GameScene]buttonMenuClicked');


            game.window(1);

        }*/



        //退出游戏
        function showExitDialog() {

            dialogCommon.show({
                Msg: '确认退出游戏？',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    exitGame();
                },
                OnRejected: ()=>{
                    if(rootGameScene)rootGameScene.forceActiveFocus();
                },
            });
        }

        function exitGame() {
            //！！放在下一次执行（必须跳出事件队列，因为 _private.asyncScript.clear(6); 会导致生成器重入）
            GlobalLibraryJS.runNextEventLoop(function() {
                game.run([function*() {

                    let err;
                    try {
                        yield *release();
                    }
                    catch(e) {
                        err = e;
                    }

                    console.debug('[GameScene]Close');

                    if(err) {
                        console.warn('[!GameScene]游戏没有正常退出，但并不碍事：', err);
                        //throw err;
                    }

                    //console.debug(_private.asyncScript.getGeneratorScriptArray().toJson());
                    _private.asyncScript.clear(0);
                    //console.debug(_private.asyncScript.getGeneratorScriptArray().toJson());


                    s_close();


                }, 'exitGame']);

                _private.asyncScript.clear(6);
            }, 'exitGame');
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

            //是否暂停
            property var pauseGame: true
            //回调函数
            property var fCallback


            //signal accepted();
            //signal rejected();


            function over(code) {
                rootGameMsgDialog.nShowStatus = -1;


                //默认回调函数
                let callback = function(code, itemMsg) {

                    itemMsg.visible = false;

                    //game.pause(true)[pauseGame]
                    if(GlobalLibraryJS.isString(pauseGame) && _private.config.objPauseNames[pauseGame] !== undefined) {
                        //如果没有使用yield来中断代码，可以不要game.run(true)
                        game.goon(pauseGame);
                        game.run(true);
                        //_private.asyncScript.run(_private.asyncScript.lastEscapeValue);
                    }


                    itemMsg.destroy();


                    //rootGameScene.forceActiveFocus();
                };


                if(GlobalLibraryJS.isFunction(rootGameMsgDialog.fCallback)) {  //用户自定义回调函数（这个是高级函数，其他地方可以自定义它来实现新功能）
                    if(rootGameMsgDialog.fCallback(code, rootGameMsgDialog) !== true)   //如果返回 非true，则继续调用默认回调函数
                        callback(code, rootGameMsgDialog);
                }
                else if(rootGameMsgDialog.fCallback === true) {    //默认回调函数
                    callback(code, rootGameMsgDialog);
                }
                else if(rootGameMsgDialog.fCallback) {   //其他类型的回调函数（比如生成器），因为游戏暂停中所以必须先调用默认回调函数（作为简单使用）；
                    callback(code, rootGameMsgDialog);
                    game.run(rootGameMsgDialog.fCallback, -1, code, rootGameMsgDialog);
                }
                else {   //不使用 回调函数
                    //gameMap.focus = true;

                    rootGameMsgDialog.visible = false;


                    /* /*if(rootGameMsgDialog.bPauseGame && _private.config.bPauseGame) {
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

            function show(msg='', interval=20, pretext='', keeptime=0, style={Type: 0b10}, _pauseGame=true, callback=true) {
                rootGameMsgDialog.pauseGame = _pauseGame;
                rootGameMsgDialog.fCallback = callback;

                if(pauseGame === true)
                    pauseGame = '$msg_' + itemGameMsgs.nIndex;
                //是否暂停游戏
                if(GlobalLibraryJS.isString(pauseGame)) {
                    //loaderGameMsg.bPauseGame = true;
                    game.pause(pauseGame);

                    //loaderGameMsg.focus = true;
                }
                else {
                    //loaderGameMsg.bPauseGame = false;
                }


                //样式
                if(style === undefined || style === null)
                    style = {};
                else if(GlobalLibraryJS.isValidNumber(style))
                    style = {Type: style};


                let styleUser = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$styles', '$msg') || {};
                let styleSystem = game.$gameMakerGlobalJS.$config.$styles.$msg;

                messageGame.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
                messageGame.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
                messageGame.textArea.font.pointSize = style.FontSize || styleUser.$fontSize || styleSystem.$fontSize;
                messageGame.textArea.color = style.FontColor || styleUser.$fontColor || styleSystem.$fontColor;
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
            //anchors.fill: parent
            width: parent.width
            height: parent.height
            //z: 0


            Mask {
                id: maskMessageGame

                anchors.fill: parent

                visible: color.a !== 0

                color: '#7FFFFFFF'

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
                textArea.readOnly: true

                textArea.onReleased: {
                    rootGameMsgDialog.clicked();
                    ////rootGameScene.forceActiveFocus();
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
                    ////rootGameScene.forceActiveFocus();
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


            function show(title='', items=[], style={}, _pauseGame=true, callback=true) {
                rootGameMenu.pauseGame = _pauseGame;
                rootGameMenu.fCallback = callback;

                if(pauseGame === true)
                    pauseGame = '$menu_' + itemGameMenus.nIndex;
                //是否暂停游戏
                if(GlobalLibraryJS.isString(pauseGame)) {
                    //loaderGameMsg.bPauseGame = true;
                    game.pause(pauseGame);
                }
                else {
                }


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


                visible = true;
                menuGame.strTitle = title;
                menuGame.show(items);
            }


            //signal s_Choice(int index)


            //第几个Menu
            property int nIndex

            property var pauseGame: true
            property var fCallback   //点击后的回调函数，true为缺省

            property alias maskMenu: maskMenu
            property alias menuGame: menuGame


            //anchors.fill: parent
            width: parent.width
            height: parent.height
            visible: false



            Mask {
                id: maskMenu

                anchors.fill: parent

                visible: color.a !== 0

                color: '#60000000'
            }

            Rectangle {
                //width: parent.width * 0.5
                width: Screen.width > Screen.height ? parent.width * 0.6 : parent.width * 0.9
                //height: parent.height * 0.5
                height: Math.min(menuGame.implicitHeight, parent.height * 0.5)
                anchors.centerIn: parent

                clip: true
                color: '#00000000'
                border.color: 'white'
                radius: height / 20


                GameMenu {
                    id: menuGame

                    //radius: rootGameMenu.radius

                    width: parent.width
                    height: parent.height

                    colorTitleColor: '#EE00CC99'
                    strTitle: ''

                    //height: parent.height / 2
                    //anchors.centerIn: parent

                    onS_Choice: {

                        //默认回调函数
                        let callback = function(index, itemMenu) {
                            //gameMap.focus = true;

                            itemMenu.visible = false;
                            //menuGame.hide();

                            //game.pause(true)[pauseGame]
                            if(GlobalLibraryJS.isString(rootGameMenu.pauseGame) && _private.config.objPauseNames[rootGameMenu.pauseGame] !== undefined) {
                                //如果没有使用yield来中断代码，可以不要game.run(true)
                                game.goon(rootGameMenu.pauseGame);
                                game.run(true, {Value: index});
                                //_private.asyncScript.run(index);
                            }


                            itemMenu.destroy();
                            //FrameManager.goon();


                            //rootGameScene.forceActiveFocus();

                            //console.debug('!!!asyncScript.run', index);
                        }


                        if(GlobalLibraryJS.isFunction(rootGameMenu.fCallback)) {   //用户自定义回调函数（这个是高级函数，其他地方可以自定义它来实现新功能）
                            if(rootGameMenu.fCallback(index, rootGameMenu) !== true)
                                callback(index, rootGameMenu);
                        }
                        //默认回调函数
                        else if(rootGameMenu.fCallback === true) {
                            callback(index, rootGameMenu);
                        }
                        else if(rootGameMenu.fCallback) {   //其他类型的回调函数（比如生成器），因为游戏暂停中所以必须先调用默认回调函数（作为简单使用）；
                            callback(index, rootGameMenu);
                            game.run(rootGameMenu.fCallback, -1, index, rootGameMenu);
                        }
                        else {  //不使用 回调函数
                            //gameMap.focus = true;

                            rootGameMenu.visible = false;
                            //menuGame.hide();



                            rootGameMenu.destroy();
                            //FrameManager.goon();
                            //console.debug('!!!asyncScript.run', index);
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


            //返回各种坐标
            function pos(tPos) {
                return game.rolepos(rootRole, tPos);
            }


            //某角色是否在移动
            function isMoving() {
                //return role.sprite.bRunning;
                return (rootRole.$$nActionType !== 0 && rootRole.$$nActionType !== -1);
            }

            //停止移动
            function stopMoving() {
                //role.$$nMoveDirectionFlag = 0;
                rootRole.$$nActionType = rootRole.$$nActionType === -1 ? -1 : 0;
                rootRole.$$arrMoveDirection = [0, 0];
                rootRole.stop();
            }


            /*/播放一个动作
            function playSprite(data) {
                if(GlobalLibraryJS.isString(data))
                    data = {RID: data};

                GameSceneJS.loadSpriteEffect(data, rootRole.customSprite, {Loops: data.$loops ?? 1});

                if(GlobalLibraryJS.isValidNumber(data.$width))
                    rootRole.customSprite.width = data.$width;
                if(GlobalLibraryJS.isValidNumber(data.$height))
                    rootRole.customSprite.height = data.$height;
                rootRole.customSprite.x = data.$x ?? 0;
                rootRole.customSprite.y = data.$y ?? 0;

                rootRole.customSprite.playSprite();
            }
            */
            function playSprite(data) {
                if(GlobalLibraryJS.isString(data))
                    data = {RID: data};

                data.$parent ?? (data.$parent = rootRole.$data.$id);
                data.$finished ?? (data.$finished = function(sprite) {
                    rootRole.sprite.visible = true;
                    sprite.visible = false;

                    return false;
                });

                rootRole.sprite.visible = false;
                game.showsprite(data, '$Sprite');
                //let sprite = compCacheSpriteEffect.createObject(null);
                //GameSceneJS.loadSpriteEffect(data, sprite, {Loops: data.$loops ?? 1});
            }

            function startAction(actionName, loops) {
                start(actionName, loops);
            }
            function pauseAction() {
                pause();
            }
            function stopAction() {
                stop();
            }



            //头顶消息
            property Message message: Message {
                parent: rootRole
                visible: false
                enabled: false
                width: parent.width
                height: parent.height * 0.2
                anchors.bottom: rootRole.textName.top
                anchors.horizontalCenter: parent.horizontalCenter

                textArea.enabled: false
                textArea.readOnly: true

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

                color: 'white'

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font.pointSize: 9
                font.bold: true
                text: (rootRole.$data && rootRole.$data.$name) ? rootRole.$data.$name : ''
                wrapMode: Text.NoWrap
            }


            //依附在角色上的图片和特效
            property var $tmpComponents: ({})

            //属性
            //property int $index: -1
            //property string $id: ''


            //自定义属性（也包含系统一些常用属性，比如$id、$index、$name、$showName、$avatar、$avatarSize等）
            //主角的会被保存，NPC不会
            property var $data: null
            //其他属性（用户自定义）
            //目前没用到
            property var $props: ({})

            property var $info: null
            property var $script: null
            //property string $name: ''
            //property string $avatar: ''
            //property size $avatarSize: Qt.size(0, 0)



            property int $$type: -1  //不要修改（只读）；角色类型（1为主角，2为NPC）

            //property int $penetrate: 0  //可穿透
            property real $$speed: 0    //移动速度（每秒多少像素），角色自身速度+所有装备速度属性

            //行动类别；
            //0为停止；1为正常行走；2为定向移动；10为摇杆行走；-1为禁止操作
            property int $$nActionType: 0

            property var $$arrMoveDirection: [0, 0]   //移动方向的速率（横方向、竖方向的2各数组，-1~1）
            //property int stopDirection: moveDirection === -1 ? stopDirection : moveDirection    //停止方向

            //目标坐标
            property var $$targetsPos: []

            //状态持续时间
            property int $$nActionStatusKeepTime: 0

            //保存上个Interval碰撞的角色名（包含主角）
            property var $$collideRoles: ({})

            property var $$mapEventsTriggering: ({})    //保存正在触发的地图事件


            z: y + y1

            //x、y是 图片 在 地图 中的坐标；
            //占位坐标：x + x1；y + y1
            //在 场景 中的 占位坐标：x + x1 + itemViewPort.itemContainer.x
            //x: 180
            //y: 100
            //width: 50
            //height: 100


            //缩放效果是否平滑过度
            bSmooth: GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$role', '$smooth'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$role', '$smooth'), true)
            //customSprite.bSmooth: GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$role', '$smooth'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$role', '$smooth'), true)


            //strSource: './Role2.png'
            //sizeFrame: Qt.size(32, 48)
            //nFrameCount: 4
            //arrActionsData: [[0,3],[0,2],[0,0],[0,1]]


            sprite.onS_started: {
                if(!$data)
                    return;
                let eventName;
                if($$type === 1)
                    eventName = `$hero_${$data.$id}_action_start`;
                else
                    eventName = `$role_${$data.$id}_action_start`;
                let tScript;
                do {
                    /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
                        break;
                    */
                    if(tScript = game.f[eventName])
                        break;
                    if(tScript = game.gf[eventName])
                        break;
                    if($script && (tScript = $script['$action_start']))
                        break;
                } while(0);

                if(tScript)
                    game.run([tScript.call(rootRole, strActionName, rootRole) ?? null, eventName]);
            }

            sprite.onS_refreshed: {
                if(!$data)
                    return;
                let eventName;
                if($$type === 1)
                    eventName = `$hero_${$data.$id}_action_refresh`;
                else
                    eventName = `$role_${$data.$id}_action_refresh`;
                let tScript;
                do {
                    /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
                        break;
                    */
                    if(tScript = game.f[eventName])
                        break;
                    if(tScript = game.gf[eventName])
                        break;
                    if($script && (tScript = $script['$action_refresh']))
                        break;
                } while(0);

                if(tScript)
                    game.run([tScript.call(rootRole, currentFrame, strActionName, rootRole) ?? null, eventName]);
            }

            sprite.onS_looped: {
                if(!$data)
                    return;
                let eventName;
                if($$type === 1)
                    eventName = `$hero_${$data.$id}_action_loop`;
                else
                    eventName = `$role_${$data.$id}_action_loop`;
                let tScript;
                do {
                    /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
                        break;
                    */
                    if(tScript = game.f[eventName])
                        break;
                    if(tScript = game.gf[eventName])
                        break;
                    if($script && (tScript = $script['$action_loop']))
                        break;
                } while(0);

                if(tScript)
                    game.run([tScript.call(rootRole, strActionName, rootRole) ?? null, eventName]);
            }

            sprite.onS_finished: {
                if(!$data)
                    return;
                let eventName;
                if($$type === 1)
                    eventName = `$hero_${$data.$id}_action_finish`;
                else
                    eventName = `$role_${$data.$id}_action_finish`;
                let tScript;
                do {
                    /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
                        break;
                    */
                    if(tScript = game.f[eventName])
                        break;
                    if(tScript = game.gf[eventName])
                        break;
                    if($script && (tScript = $script['$action_finish']))
                        break;
                } while(0);

                if(tScript)
                    game.run([tScript.call(rootRole, strActionName, rootRole) ?? null, eventName]);
            }

            sprite.onS_paused: {
                if(!$data)
                    return;
                let eventName;
                if($$type === 1)
                    eventName = `$hero_${$data.$id}_action_pause`;
                else
                    eventName = `$role_${$data.$id}_action_pause`;
                let tScript;
                do {
                    /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
                        break;
                    */
                    if(tScript = game.f[eventName])
                        break;
                    if(tScript = game.gf[eventName])
                        break;
                    if($script && (tScript = $script['$action_pause']))
                        break;
                } while(0);

                if(tScript)
                    game.run([tScript.call(rootRole, strActionName, rootRole) ?? null, eventName]);
            }

            sprite.onS_stoped: {
                if(!$data)
                    return;
                let eventName;
                if($$type === 1)
                    eventName = `$hero_${$data.$id}_action_stop`;
                else
                    eventName = `$role_${$data.$id}_action_stop`;
                let tScript;
                do {
                    /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
                        break;
                    */
                    if(tScript = game.f[eventName])
                        break;
                    if(tScript = game.gf[eventName])
                        break;
                    if($script && (tScript = $script['$action_stop']))
                        break;
                } while(0);

                if(tScript)
                    game.run([tScript.call(rootRole, strActionName, rootRole) ?? null, eventName]);
            }


            mouseArea.onClicked: {
                GameSceneJS.roleClickEvent(rootRole, mouse.x, mouse.y);
            }


            Component.onCompleted: {
                //console.debug('[GameScene]Role Component.onCompleted');
            }
        }
    }

    //音效
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
            onPlaybackStateChanged: {
            }
        }
    }

    //地图图片
    Component {
        id: compCacheImage

        //Image {
        AnimatedImage {
            //id号 和 父组件代号
            property var $id
            property var $parent
            //组件类型（用来识别）
            readonly property int $componentType: 1

            //回调函数
            property var clicked
            property var doubleClicked
            property var pressed
            property var released
            property var pressAndHold


            visible: false



            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons  /*Qt.LeftButton | Qt.RightButton*/

                onPressed: {
                    if(parent.pressed)
                        game.run(parent.pressed.call(parent, parent) ?? null, -1, );
                }

                onReleased: {
                    if(parent.released)
                        game.run(parent.released.call(parent, parent) ?? null, -1, );
                }

                onPressAndHold: {
                    if(parent.pressAndHold)
                        game.run(parent.pressAndHold.call(parent, parent) ?? null, -1, );
                }

                onClicked: {
                    //console.debug('clicked: parent.$id', parent.$id)
                    if(parent.clicked)
                        game.run(parent.clicked.call(parent, parent) ?? null, -1, );
                }

                onDoubleClicked: {
                    //game.delimage(parent.$id);
                    if(parent.doubleClicked)
                        game.run(parent.doubleClicked.call(parent, parent) ?? null, -1, );
                }
            }
        }
    }

    //地图特效
    Component {
        id: compCacheSpriteEffect

        SpriteEffect {
            //id号 和 父组件代号
            property var $id
            property var $parent
            //组件类型（用来识别）
            readonly property int $componentType: 2

            property var $info: null
            property var $script: null
            //property bool bUsing: false

            //回调函数
            property var clicked
            property var doubleClicked
            property var pressed
            property var released
            property var pressAndHold

            property var looped
            property var finished


            //visible: false

            smooth: GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$spriteEffect', '$smooth'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$spriteEffect', '$smooth'), true)


            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons  /*Qt.LeftButton | Qt.RightButton*/

                onPressed: {
                    if(parent.pressed)
                        game.run(parent.pressed.call(parent, parent) ?? null, -1, );
                }

                onReleased: {
                    if(parent.released)
                        game.run(parent.released.call(parent, parent) ?? null, -1, );
                }

                onPressAndHold: {
                    if(parent.pressAndHold)
                        game.run(parent.pressAndHold.call(parent, parent) ?? null, -1, );
                }

                onClicked: {
                    //console.debug('clicked: parent.$id', parent.$id)
                    if(parent.clicked)
                        game.run(parent.clicked.call(parent, parent) ?? null, -1, );
                }

                onDoubleClicked: {
                    //game.delsprite(parent.$id);
                    if(parent.doubleClicked)
                        game.run(parent.doubleClicked.call(parent, parent) ?? null, -1, );
                }
            }

            onS_looped: {
                //console.debug('clicked: parent.$id', parent.$id)
                if(looped)
                    game.run(looped.call(this, this) ?? null, -1, );
            }

            onS_finished: {
                //game.delsprite(parent.$id);
                if(finished)
                    game.run(finished.call(this, this) ?? null, -1, );
                else
                    visible = false;
            }


            onS_playEffect: {
                rootSoundEffect.playSoundEffect(soundeffectSource);
            }

        }
    }

    //文字移动
    Component {
        id: compCacheWordMove

        WordMove {
            //visible: true
        }
    }



    //应用程序信号
    Connections {
        target: Qt.application

        function onStateChanged() {
            switch(Qt.application.state) {
            case Qt.ApplicationActive:   //每次窗口激活时触发
                _private.arrPressedKeys = [];
                //mainRole.$$nMoveDirectionFlag = 0;

                itemBackgroundMusic.resume('$sys_inactive');
                rootSoundEffect.resume('$sys_inactive');

                break;
            case Qt.ApplicationInactive:    //每次窗口非激活时触发
                _private.arrPressedKeys = [];
                //mainRole.$$nMoveDirectionFlag = 0;

                itemBackgroundMusic.pause('$sys_inactive');
                rootSoundEffect.pause('$sys_inactive');

                break;
            case Qt.ApplicationSuspended:   //程序挂起（比如安卓的后台运行、息屏）
                _private.arrPressedKeys = [];
                //mainRole.$$nMoveDirectionFlag = 0;
                //itemBackgroundMusic.pause();

                break;
            case Qt.ApplicationHidden:
                _private.arrPressedKeys = [];
                //mainRole.$$nMoveDirectionFlag = 0;
                //itemBackgroundMusic.pause();

                break;
            }
        }
    }



    /*onFocusChanged: {
        if(focus === false) {
            _private.arrPressedKeys = [];
            _private.stopMove(1, -1);
        }
        console.warn(focus)
    }
    */


    //Keys.forwardTo: [itemViewPort.itemContainer]

    Keys.onEscapePressed: {
        _private.showExitDialog();
        event.accepted = true;

        console.debug('[GameScene]Escape Key');
    }
    Keys.onBackPressed: {
        _private.showExitDialog();
        event.accepted = true;

        console.debug('[GameScene]Back Key');
    }
    Keys.onTabPressed: {
        rootGameScene.forceActiveFocus();
        event.accepted = true;

        console.debug('[GameScene]Tab Key');
    }
    Keys.onSpacePressed: {
        event.accepted = true;
    }



    Keys.onPressed: {   //键盘按下
        //console.debug('[GameScene]Keys.onPressed:', event.key, event.isAutoRepeat);

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

            //_private.arrPressedKeys[key] = true; //保存键盘按下
            if(_private.arrPressedKeys.indexOf(event.key) === -1)
                _private.arrPressedKeys.push(event.key);

            if(mainRole.$$nActionType === -1)
                return;


            if(GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames)) {
                //mainRole.$$nActionType = 1;

                _private.startMove(1, event.key);
            }

            event.accepted = true;

            break;

        case Qt.Key_Return:
            if(event.isAutoRepeat === true) { //如果是按住不放的事件，则返回（只记录第一次按）
                event.accepted = true;
                return;
            }

            if(mainRole.$$nActionType === -1)
                return;


            if(GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                GameSceneJS.buttonAClicked();


            event.accepted = true;

            break;

        default:
            event.accepted = true;
        }
    }

    Keys.onReleased: {
        //console.debug('[GameScene]Keys.onReleased', event.isAutoRepeat);

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

            //delete arrPressedKeys[key]; //从键盘保存中删除
            _private.arrPressedKeys.splice(_private.arrPressedKeys.indexOf(event.key), 1);


            if(mainRole.$$nActionType === -1)
                return;


            if(GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames)) {
                _private.stopMove(1, event.key);
            }

            event.accepted = true;

            break;

        default:
            event.accepted = true;
        }


        //console.debug('[GameScene]timer', timer.running);
    }



    Component.onCompleted: {
        mainRole = compRole.createObject(itemViewPort.itemRoleContainer);
        mainRole.sprite.s_playEffect.connect(rootSoundEffect.playSoundEffect);
        //mainRole.customSprite.s_playEffect.connect(rootSoundEffect.playSoundEffect);


        //console.debug('[GameScene]globalObject：', FrameManager.globalObject().game);

        FrameManager.globalObject().game = game;
        FrameManager.globalObject().g = game;
        //FrameManager.globalObject().g = g;

        //console.debug('[GameScene]globalObject：', FrameManager.globalObject().game);

        console.debug('[GameScene]Component.onCompleted');
    }

    Component.onDestruction: {
        //release();
        //console.warn('!!!', Object.keys(_private.config.objPauseNames));
        //console.warn('!!!3', _private.asyncScript.getGeneratorScriptArray().toJson());


        //鹰：有可能多次创建GameScene，所以要删除最后一次赋值的（比如热重载地图测试时，不过已经解决了）；
        if(FrameManager.globalObject().game === game) {
            delete FrameManager.globalObject().game;
            delete FrameManager.globalObject().g;
        }

        console.debug('[GameScene]Component.onDestruction');
    }
}
