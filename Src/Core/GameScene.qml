import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import QtQuick.Dialogs 1.3 as Dialog1
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.0
import QtMultimedia 5.14
import Qt.labs.settings 1.1
//import QtTest 1.14


//引入Qt定义的类
import cn.Leamus.MakerFrame 1.0


import _Global 1.0
import _Global.Button 1.0


//import GameComponents 1.0
import 'GameComponents'


import 'qrc:/QML'


//import 'GameMakerGlobal.js' as GameMakerGlobalJS

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

  脚本设计：
    1、game.run、game.async、$CommonLibJS.asyncScript 的区别：
      game.run：系统脚本队列，只能按顺序执行；
      game.async：异步脚本对象，可以运行生成器，无顺序限制，可以控制所有的生成器（waitAll和terminateAll）；
      $CommonLibJS.asyncScript：异步脚本函数，类似game.async，但不能控制所有生成器；
      上面3个可以任意组合使用，但：游戏事件尽量放在game.run里运行；$CommonLibJS.asyncScript必须运行带有release的生成器（因为里面有清空 系统脚本队列 和 异步脚本对象 的代码）；
    2、loadmap、usegoods、equip、unload、save、load、plugin 这些命令有脚本的，必须要立即运行，所以可以用 game.run 的 Priority: -2，也可以使用 game.async，但最好不要用 异步脚本函数（因为release不能清空它）；
    3、很多命令返回Promise对象，除了上述还有6+1个（msg、talk、menu、input、window、trade、wait）：
      所以这些命令用yield都有暂停效果，loadmap、usegoods等这些命令要立即运行代码并完成才能激活Promise对象，而msg、talk等这些是通过交互后调用回调函数来激活Promise对象）；

  说明：占用的全局属性、事件和定时器：
    game.gd['$sys_fight_heros']：我方所有战斗人员列表
    //game.gd['$sys_hidden_fight_heros']：我方所有隐藏了的战斗人员列表
    game.gd['$sys_money']: 金钱
    game.gd['$sys_goods']: 道具道具 列表（存的是{$rid: goodsRID, $count: count}）
    game.gd['$sys_map']、game.d['$sys_map']: 当前地图信息
    game.gd['$sys_fps']: 当前FPS
    game.gd['$sys_main_roles']: 当前主角列表，保存了主角属性（{$rid、$id、$name、$index、$showName、$scale、$speed、$avatar、$avatarSize、$x、$y 等}）
    game.gd['$sys_music']: 当前播放的音乐名
    game.gd['$sys_sound']: 从右到左：音乐、音效 播放状态
    game.gd['$sys_volume']: 从右到左：音乐、音效 播放音量
    game.gd['$sys_scale']: 当前缩放大小
    game.gd['$sys_random_fight']：随机战斗


    game.f：地图函数，地图定时器、地图事件、人物事件会搜索调用；
    game.gf：全局函数，全局定时器、地图事件、人物事件会搜索调用；
      例子：
        game.addtimer('$sys_random_fight_timer', 1000, -1, 0b11)：战斗定时
        game.gf['$sys_random_fight_timer']：战斗事件
        //game.addtimer('resume_event', 1000, -1, 0b11)：恢复定时
        //game.gf['resume_timer']：恢复事件
      .$map：全局地图事件
      .$map_leave：全局地图离开事件
      .$collide：全局碰撞事件
      .$collide_obstacle：全局碰撞障碍事件



    game.$sys.resources.commonScripts.：通用脚本
      .$gameStart = *$start;
      .$gameInit;
      .$gameRelease;
      .$beforeSave;
      .$beforeLoad;
      .$afterSave;
      .$afterLoad;
      .$Combatant;
      .$refreshCombatant;
      .$combatantIsValid;
      .$gameOverScript //游戏结束脚本
      .$combatantInfo
      .$showGoodsName
      .$showCombatantName

      .$commonRunAwayAlgorithm：逃跑算法
      .$fightSkillAlgorithm：战斗算法
      .$fightRoleChoiceSkillsOrGoodsAlgorithm：战斗人物选择技能或物品算法
      .$commonFightInitScript
      .$commonFightStartScript：战斗开始通用脚本
      .$commonFightRoundScript：战斗回合通用脚本
      .$commonFightEndScript：战斗结束通用脚本（升级经验、获得金钱）
      .$fightCombatantPositionAlgorithm：获取 某战斗角色 中心位置
      .$fightCombatantMeleePositionAlgorithm：战斗角色近战 坐标
      .$fightSkillMeleePositionAlgorithm：特效在战斗角色的 坐标
      .$fightCombatantSetChoice：//设置 战斗人物的 初始化 或 休息
      .$fightMenus：战斗菜单
      .$fightRolesRound：一个大回合内 每次返回一个战斗人物的回合
      .$combatantRoundScript
      .$checkAllCombatants;
      .$commonCheckScript

      //.$commonLevelUpScript：升级脚本（经验等条件达到后升级和结果）
      //.$commonLevelAlgorithm：升级算法（直接升级对经验等条件的影响）

*/



Item {
    id: rootGameScene


    //关闭退出
    signal sg_close();



    function $load(startScript=true, bLoadResources=true, gameData=null) {

        //console.debug(_private.scriptQueue.getScriptInfos().$$toJson());
        _private.scriptQueue.clear(5);
        //console.debug(_private.scriptQueue.getScriptInfos().$$toJson());


        //scriptQueue.runNextEventLoop('init');


        //！！！鹰：注意：load是异步调用；且将 Priority 设置为顺序的（保证 game.load 的所有异步脚本执行完毕 再执行 game.load 的下一个命令）
        //let priority = 0;


        game.run({Script: init(startScript, bLoadResources, gameData) ?? null, Priority: -1, Running: 1, Tips: 'init'});
    }

    //游戏初始化脚本
    //startScript为true，则载入main.js；为函数/生成器，则直接运行startScript；为false则不执行；
    //bLoadResources为是否载入资源（刚进入游戏时为true，其他情况比如读档为false，gameData为读档的数据）；
    //必须用yield*标记来让它运行完毕（第一次使用则不必）；
    function* init(startScript=true, bLoadResources=true, gameData=null) {
        console.debug('[GameScene]init:', startScript, bLoadResources, gameData);

        //game.run({Script: function*() {


        if(bLoadResources) {
            yield* GameSceneJS.loadResources();
            _private.nStage = 1;
        }


        //恢复游戏数据
        if(gameData) //！！！注意测试有没有问题（250623）
            //$CommonLibJS.copyPropertiesToObject(game.gd, gameData);
            game.gd = gameData;
        else {
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
        }


        game.$sys.reloadFightRoles();

        game.$sys.reloadGoods();

        //其他
        game.interval(game.gd['$sys_fps']);
        game.scale(game.gd['$sys_scale']);

        if(game.gd['$sys_music'])
            game.playmusic(game.gd['$sys_music']);

        /*if(game.gd['$sys_sound'] & 0b10)
            _private.config.nSoundConfig = 0;
        else
            _private.config.nSoundConfig = 1;
        */


        //读取主角
        for(let th of game.gd['$sys_main_roles']) {
            let mainRole = game.createhero(th.$rid);
            mainRole.$$nActionType = 0;
            mainRole.$$arrMoveDirection = [0, 0];
            //game.hero(mainRole, th);
        }
        //开始移动地图
        //setSceneToRole();


        //计算新属性
        for(let tfh of game.gd['$sys_fight_heros'])
            _private.objCommonScripts.$refreshCombatant(tfh);
        //刷新战斗时人物数据
        //fight.$sys.refreshCombatant(-1);



        if(_private.objCommonScripts.$gameInit) { //$CommonLibJS.checkCallable
            try {
                //game.run({Script: _private.objCommonScripts.$gameInit(bLoadResources) ?? null,
                //    Priority: priority++, Type: 0, Running: 1, Tips: '$gameInit'});
                let r = _private.objCommonScripts.$gameInit(bLoadResources);
                if($CommonLibJS.isGenerator(r))r = yield* r;
            }
            catch(e) {
                $CommonLibJS.printException(e);
                console.warn('[!GameScene]游戏init函数调用错误');
                //throw err;
            }
        }


        //所有插件初始化
        for(let tc in _private.objPlugins)
            for(let tp in _private.objPlugins[tc]) {
                const plugin = _private.objPlugins[tc][tp];
                //if(plugin.$autoLoad === 1) {
                if(_private.objPluginsStatus[tc][tp] === 1) {
                    if(plugin.$init) { //$CommonLibJS.checkCallable
                        try {
                            //console.warn(plugin.$init)
                            let r = plugin.$init(bLoadResources);
                            if($CommonLibJS.isGenerator(r))r = yield* r;
                        }
                        catch(e) {
                            $CommonLibJS.printException(e);
                            console.warn('[!GameScene]插件$init函数调用错误：', tc, tp);
                            //throw err;
                        }
                    }

                    _private.objPluginsStatus[tc][tp] = 2;
                }
            }


        //钩子函数调用
        for(let vfInit in game.$sys.hooks.init) { //$CommonLibJS.checkCallable
            try {
                let r = game.$sys.hooks.init[vfInit](bLoadResources);
                if($CommonLibJS.isGenerator(r))r = yield* r;
            }
            catch(e) {
                $CommonLibJS.printException(e);
                console.warn('[!GameScene]钩子init函数调用错误：', vfInit);
                //throw err;
            }
        }


        _private.nStage = 2;


        //game.pause();
        game.goon('$release');


        //game.run({Script: function*() {
        //读取 main.js 脚本
        if(startScript === true) {
            /*
            let filePath = game.$projectpath + GameMakerGlobal.separator + 'main.js';
            //let cfg = File.read(filePath);
            let data = $Frame.sl_fileRead($GlobalJS.toPath(filePath));
            //if(!data)
            //    return false;
            if(_private.scriptQueue.create([eval(data) ?? null, 0, true, ''], ) === 0)
            ///if($GlobalJS.createScript(_private.scriptQueue, 0, 0, eval(data)) === 0)
                _private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
            */

            const gameStart = /*game.$sys.getCommonScriptResource('$start') || */_private.objCommonScripts['$gameStart'];
            if(gameStart) { //$CommonLibJS.checkCallable
                //game.run({Script: function*() {
                    try {
                        let r = gameStart();
                        if($CommonLibJS.isGenerator(r))r = yield* r;
                    }
                    catch(e) {
                        $CommonLibJS.printException(e);
                        console.warn('[!GameScene]游戏start函数调用错误');
                        //throw err;
                    }
                //}(), Tips: 'start'});
            }
        }
        else if(startScript === false) {
        }
        else if(startScript === null) {
        }
        else {  //$CommonLibJS.checkCallable
            //game.run({Script: function*() {
                try {
                    let r = startScript();
                    if($CommonLibJS.isGenerator(r))r = yield* r;
                }
                catch(e) {
                    $CommonLibJS.printException(e);
                    console.warn('[!GameScene]游戏start函数调用错误2');
                    //throw err;
                }
            //}(), Tips: 'start'});
        }

        //}(), Tips: 'start'});


        //}(), Priority: -2, Type: 0, Running: 1, Tips: 'init'});



        //进游戏时如果设置了屏幕旋转，则x、y坐标会互换导致出错，所以重新刷新一下屏幕；
        //!!!屏幕旋转会导致 itemContainer 的x、y坐标互换!!!???
        //$CommonLibJS.setTimeout([function() {
        //    setSceneToRole();
        //},1,rootGameScene], 10);


        _private.nStage = 3;


        console.debug('[GameScene]init over');
    }



    //释放所有资源
    //必须用yield标记来让它运行完毕
    function* release(bUnloadResources=true) {
        console.debug('[GameScene]release');

        _private.nStage = 10;

        //scriptQueue.runNextEventLoop('release');


        //！！！鹰：注意：load是异步调用；且将 Priority 设置为顺序的（保证 game.load 的所有异步脚本执行完毕 再执行 game.load 的下一个命令）
        //let priority = 0;

        //game.run({Script: function*(){
        //timer.stop();
        _private.config.objPauseNames = {};
        game.pause('$release');


        $CommonLibJS.$asyncScript.terminateAll(1, null, 1);
        _private.scriptQueue.clear(5);


        //钩子函数调用
        for(let vfRelease in game.$sys.hooks.release) { //$CommonLibJS.checkCallable
            try {
                let r = game.$sys.hooks.release[vfRelease](bUnloadResources);
                if($CommonLibJS.isGenerator(r))r = yield* r;
            }
            catch(e) {
                $CommonLibJS.printException(e);
                console.warn('[!GameScene]钩子release函数调用错误：', vfRelease);
                //throw err;
            }
        }


        //所有插件释放
        for(let tc in _private.objPlugins)
            for(let tp in _private.objPlugins[tc]) {
                const plugin = _private.objPlugins[tc][tp];
                //if(plugin.$autoLoad === 2) {
                if(_private.objPluginsStatus[tc][tp] === 2) {
                    if(plugin.$release) { //$CommonLibJS.checkCallable
                        try {
                            let r = plugin.$release(bUnloadResources);
                            if($CommonLibJS.isGenerator(r))r = yield* r;
                        }
                        catch(e) {
                            $CommonLibJS.printException(e);
                            console.warn('[!GameScene]插件$release函数调用错误：', tc, tp);
                            //throw err;
                        }
                    }

                    _private.objPluginsStatus[tc][tp] = 1;
                }
            }


        if(_private.objCommonScripts.$gameRelease) { //$CommonLibJS.checkCallable
            try {
                let r = _private.objCommonScripts.$gameRelease(bUnloadResources);
                if($CommonLibJS.isGenerator(r))r = yield* r;
            }
            catch(e) {
                $CommonLibJS.printException(e);
                console.warn('[!GameScene]游戏release函数调用错误');
                //throw err;
            }
        }


        game.scale(1);

        //！！不能清空事件队列，因为有可能 game.load() 调用后下面还有其他代码！！
        //_private.scriptQueue.clear(4);
        //_private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);

        //loaderGameMsg.item.stop();
        //messageRole.stop();

        game.delhero(-1);
        game.delrole(-1);
        game.delimage();
        game.delsprite();
        game.stopvideo(-1);
        game.stopmusic();
        game.resumemusic(null);
        game.stopsoundeffect(-1);
        game.resumesoundeffect(-1);


        //$Frame.goon();


        gameMenuWindow.closeWindow(-1);
        //gameMenuWindow.visible = false;
        dialogTrade.close();

        //loaderGameMsg.item.visible = false;
        //itemRootRoleMsg.visible = false;
        //itemRootGameInput.visible = false;
        //itemMenu.visible = false;
        //menuGame.hide();

        itemGameMsgs.nIndex = 0;
        for(let ti in itemGameMsgs.children) {
            itemGameMsgs.children[ti].destroy();
        }
        itemRoleMsgs.nIndex = 0;
        for(let ti in itemRoleMsgs.children) {
            itemRoleMsgs.children[ti].destroy();
        }
        itemGameMenus.nIndex = 0;
        for(let ti in itemGameMenus.children) {
            itemGameMenus.children[ti].destroy();
        }
        itemGameInputs.nIndex = 0;
        for(let ti in itemGameInputs.children) {
            itemGameInputs.children[ti].destroy();
        }
        //停止并触发所有定时器，让异步脚本/队列继续运行不要等待；
        for(let ti in itemWaitTimers.children) {
            //itemWaitTimers.children[ti].destroy();
            itemWaitTimers.children[ti].stop();
            itemWaitTimers.children[ti].triggered();
            itemWaitTimers.children[ti].destroy();
        }


        game.d = {};
        game.f = {};
        game.gd = {};
        game.gf = {};




        _private.objRoles = {};
        _private.arrMainRoles = [];
        if(_private.objTmpComponents.$$keys.length > 0) {
            console.warn('[!GameScene]存在未释放的组件：', _private.objTmpComponents.$$keys);

            for(let tc in _private.objTmpComponents) {
                const c = _private.objTmpComponents[tc];
                if($CommonLibJS.isQtObject(c)) {
                    (c.$destroy ?? c.Destroy ?? c.destroy)();
                }
            }

            _private.objTmpComponents = {};
        }


        _private.objTimers = {};
        _private.objGlobalTimers = {};


        _private.sceneRole = null; //mainRole;
        mainRole.$$collideRoles = {};
        mainRole.$$mapEventsTriggering = {};


        _private.nStatus = 0;


        loaderFightScene.visible = false;


        itemViewPort.release();


        _private.nStage = 11;


        if(bUnloadResources) {
            yield* GameSceneJS.unloadResources();
            _private.nStage = 12;
        }
        //}(), Priority: -2, Type: 0, Running: 1, Tips: 'release'});



        //console.debug(_private.scriptQueue.getScriptInfos().$$toJson());
        //_private.scriptQueue.clear(0);
        ///_private.scriptQueue.clear(4);
        //console.debug(_private.scriptQueue.getScriptInfos().$$toJson());

        console.debug('[GameScene]release over');
    }


    function updateAllRolesPos() {

    }



    //设置角色坐标（块坐标）
    function setRolePos(bx, by, role) {
        if(!itemViewPort.mapInfo)
            return false;


        let [targetX, targetY] = itemViewPort.getMapBlockPos(bx, by);

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

        if(role === _private.sceneRole)setSceneToRole();


        return true;
    }

    //设置主角坐标（块坐标）
    function setMainRolePos(bx, by, index=0) {
        let mainRole = _private.arrMainRoles[index];

        if(mainRole === undefined)
            return false;

        setRolePos(bx, by, mainRole);
        //setSceneToRole();
        if(mainRole === _private.sceneRole)setSceneToRole();

        game.gd['$sys_main_roles'][index].$x = mainRole.x + mainRole.x1 + parseInt(mainRole.width1 / 2);
        game.gd['$sys_main_roles'][index].$y = mainRole.y + mainRole.y1 + parseInt(mainRole.height1 / 2);
    }

    //场景移动到某角色
    function setSceneToRole(role=_private.sceneRole) {
        if(!role)
            return false;

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

        return true;
    }



    //property alias g: rootGameScene.game
    property QtObject game: QtObject {

        //功能：载入地图，并执行地图载入事件$start、地图离开事件$end（如果有）、通用脚本的$beforeLoadmap和$afterLoadmap。
        //参数：
        //  map：地图资源名，或对象（属性有RID、$name、$scale）；
        //  flags：从右到左：是否强制重绘（如果map与已载入的相同，则不重绘）；是否清空所有npc；
        //  userData：用户传入数据，后期调用的钩子函数会传入；
        //返回：Promise对象（完全运行完毕后状态改变；携带值为地图信息；出错会抛出错误）；
        //示例：yield game.loadmap('地图资源名')；
        function loadmap(map, flags=0b10, ...userData) {
            if(flags === true) //兼容旧代码forceRepaint
                flags = 0b11;
            else if(!$CommonLibJS.isValidNumber(flags))
                flags = 0b10;
            else
                flags = parseInt(flags);
            const forceRepaint = !!(flags & 0b1);

            //let _resolve, _reject;

            //！如果使用生成器方式，则将 resolve 和 reject 删除即可，再用return返回数据；
            //！使用async是因为返回的是Promise（脚本队列必须等待Promise才能继续执行，如果用game.run则互相等造成死锁，下同）；
            const _loadmap = function(resolve, reject) {
                //_resolve = resolve; _reject = reject;

                //game.run({Script: function*() {
                game.async([function*() { //效果和run一样，但使用async能更好的在async函数里使用；

                    if($CommonLibJS.isString(map)) {
                        map = {RID: map};
                    }
                    map.$rid = map.RID ?? map.RId;
                    if(!map || !map.$rid) {
                        //scriptQueue.runNextEventLoop('loadmap');
                        console.exception('[!GameScene]loadmap FAIL:', map.$rid);
                        return reject('loadmap FAIL');
                    }


                    //！！！鹰：注意：loadmap是异步调用；且将 Priority 设置为顺序的（保证 game.loadmap 的所有异步脚本执行完毕 再执行 game.loadmap 的下一个命令）
                    //let priority = 0;


                    //game.run({Script: function*() {

                    //执行之前地图的 $end 函数
                    if(game.d['$sys_map'] && game.d['$sys_map'].$rid) {
                        //const ts = _private.jsLoader.load($GlobalJS.toURL(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + game.d['$sys_map'].$rid + GameMakerGlobal.separator + 'map.js'));
                        //if(ts.$end) { //$CommonLibJS.checkCallable
                        if(itemViewPort.mapScript && itemViewPort.mapScript.$end) {
                            let r = itemViewPort.mapScript.$end(...userData);
                            if($CommonLibJS.isGenerator(r))r = yield* r;
                            //game.run({Script: itemViewPort.mapScript.$end(...userData) ?? null, Priority: priority++, Type: 0, Running: 1, Tips: 'map $end'});
                        }
                    }


                    //载入beforeLoadmap脚本
                    const beforeLoadmap = _private.objCommonScripts.$beforeLoadmap;
                    if(beforeLoadmap) { //$CommonLibJS.checkCallable
                        let r = beforeLoadmap(map, ...userData);
                        if($CommonLibJS.isGenerator(r))r = yield* r;
                        //game.run({Script: beforeLoadmap(map, ...userData) ?? null, Priority: priority++, Type: 0, Running: 1, Tips: 'beforeLoadmap'});
                    }


                    //清理工作

                    timer.running = false;


                    for(let tc in _private.objTmpMapComponents) {
                        const c = _private.objTmpMapComponents[tc];
                        if($CommonLibJS.isQtObject(c)) {
                            (c.$destroy ?? c.Destroy ?? c.destroy)();
                        }
                    }
                    _private.objTmpMapComponents = {};

                    if(flags & 0b10)
                        game.delrole(-1);

                    _private.objTimers = {};

                    mainRole.$$collideRoles = {};
                    mainRole.$$mapEventsTriggering = {};
                    if(GameSceneJS.getCommonScriptResource('$config', '$game', '$changeMapStopAction') ?? true)
                        _private.stopMove(0); //加上可以让主角停止，重新操作才可以移动

                    game.d = {};
                    game.f = {};


                    //itemViewPort.itemRoleContainer.visible = false;
                    const mapInfo = GameSceneJS.openMap(map, forceRepaint);
                    //itemViewPort.itemRoleContainer.visible = true;

                    setSceneToRole();


                    //载入地图会卡顿，重新开始计时会顺滑一点
                    timer.running = true;
                    timer.nLastTime = 0;


                    //let priority = 0;


                    while(itemViewPort.mapScript) {
                        let start;
                        if($CommonLibJS.checkCallable(start = itemViewPort.mapScript.$start)) {
                        }
                        else if($CommonLibJS.checkCallable(start = itemViewPort.mapScript.start)) {
                        }
                        else
                            break;

                        let r = start(...userData);
                        if($CommonLibJS.isGenerator(r))r = yield* r;
                        //game.run({Script: itemViewPort.mapScript.$start(...userData) ?? null, Priority: priority++, Type: 0, Running: 1, Tips: 'map $start'});
                        break;
                    }


                    //载入after_loadmap脚本
                    const afterLoadmap = _private.objCommonScripts.$afterLoadmap;
                    if(afterLoadmap) { //$CommonLibJS.checkCallable
                        let r = afterLoadmap(map, ...userData);
                        if($CommonLibJS.isGenerator(r))r = yield* r;
                        //game.run({Script: afterLoadmap(map, ...userData) ?? null, Priority: priority++, Type: 0, Running: 1, Tips: 'afterLoadmap'});
                    }


                    return resolve(mapInfo);

                    //}(), Priority: -2, Type: 0, Running: 1, Tips: 'map load'});
                    //return true;

                }(), 'loadmap']);
                //}(), Priority: -2, Type: 0, Running: 0, Tips: 'loadmap'});
            };

            const ret = $CommonLibJS.getPromise(_loadmap);
            //ret.$resolve = _resolve; ret.$reject = _reject;
            return ret;
        }

        /*readonly property var map: {
            name: ''
        }*/

        //功能：在屏幕中间显示提示信息；命令用yield关键字修饰表示命令完全运行完毕后再进行下一步。
        //参数：msg为提示文字，支持HTML标签；
        //  interval为文字显示间隔，为0则不使用；
        //  pretext为预显示的文字；
        //  keeptime：如果为-1，表示点击后对话框会立即显示全部，为0表示等待显示完毕，为>0表示显示完毕后再延时KeepTime毫秒然后自动消失；
        //  style为样式，包括BackgroundColor、BorderColor、FontSize、FontColor、MaskColor、MinWidth、MaxWidth、MinHeight、MaxHeight；
        //      分别表示 背景色、边框色、字体颜色、字体大小、遮盖色、最小/大宽度、最小/大高度（为小数则百分比）；
        //  pauseGame为显示时是否暂停游戏（游戏主循环暂停，并暂停产生游戏事件）；值为true、false或字符串。如果为true或字符串则游戏会暂停（字符串表示暂停值，不同的暂停值互不影响，只要有暂停值游戏就会暂停；true表示给个随机暂停值）；
        //  callback是结束时回调函数，如果为非函数则表示让系统默认处理（销毁组件并继续游戏）；
        //    如果是自定义函数，参数为cb, ...params，cb表示系统默认处理（销毁组件并继续游戏），请在合适的地方调用 cb(...params)；
        //      params为code, rootGameMsgDialog；
        ////  buttonNum为按钮数量（0-2，目前没用）；
        //  p为父组件，默认挂在系统提供的组件上（itemGameMsgs）；
        //返回：Promise对象（完全运行完毕后状态改变；出错会抛出错误），$params属性为消息框组件对象；如果参数msg为true，则直接创建组件对象并返回（需要自己调用显示函数）；
        //示例：yield game.msg('你好，鹰歌')；
        function msg(msg='', interval=20, pretext='', keeptime=0, style={}, pauseGame=true/*, buttonNum=0*/, callback=true, p=null) {

            const itemGameMsg = compGameMsg.createObject(p || itemGameMsgs, {nIndex: itemGameMsgs.nIndex});

            ++itemGameMsgs.nIndex;


            //按钮数
            //buttonNum = parseInt(buttonNum);

            /*if(buttonNum === 1)
                loaderGameMsg.standardButtons = Dialog.Ok;
            else if(buttonNum === 2)
                loaderGameMsg.standardButtons = Dialog.Ok | Dialog.Cancel;
            else
                loaderGameMsg.standardButtons = Dialog.NoButton;
            */


            let ret = itemGameMsg;

            //如果为true，则返回 组件，用户自己配置并调用show
            if(msg !== true) {
                /*if(callback === true || callback === 1)
                    //cb为默认回调函数，params为cb所需的参数，cb返回true表示有暂停；
                    callback = function(cb, ...params) {
                        if(cb(...params)) {
                            game.run(true);
                        }
                    }
                */

                //let _resolve, _reject;
                let _callback;
                //如果callback是自定义函数，则调用自定义函数，否则调用默认函数（cb）
                ret = $CommonLibJS.getPromise(function(resolve, reject) {
                    //_resolve = resolve; _reject = reject;
                    _callback = (cb, ...params)=>{
                        if($CommonLibJS.isFunction(callback))
                            callback(cb, ...params);
                        else
                            cb(...params);
                        resolve(params[0]);
                        //reject(params[0]);
                    };
                });
                //ret.$resolve = _resolve; ret.$reject = _reject;
                ret.$params = itemGameMsg;

                itemGameMsg.show(msg.toString(), interval, pretext.toString(), keeptime, style, pauseGame, _callback);
            }
            //loaderGameMsg.item.fCallback = _callback;
            //loaderGameMsg.item.show(msg.toString(), pretext.toString(), interval, keeptime, style);


            return ret;

            //！如果定义为生成器的写法：
            //return yield ret;
        }

        //功能：在屏幕下方显示对话信息；命令用yield关键字修饰表示命令完全运行完毕后再进行下一步。
        //参数：role为角色名或角色对象（会显示名字和头像），可以为null（不显示名字和头像）；
        //  msg同命令msg的参数；
        //  interval同命令msg的参数；
        //  pretext同命令msg的参数；
        //  keeptime同命令msg的参数；
        //  style为样式，包括BackgroundColor、BorderColor、FontSize、FontColor、MaskColor、MinWidth、MaxWidth、MinHeight、MaxHeight、Name、Avatar；
        //    分别表示 背景色、边框色、字体颜色、字体大小、遮盖色、最小/大高度（为小数则百分比）、是否显示名字、是否显示头像；
        //  pauseGame同命令msg的参数；
        //  callback同命令msg的参数；回调函数的params为code, rootRoleMsg；
        //  p为父组件，默认挂在系统提供的组件上（itemRoleMsgs）；
        //返回：同命令msg的返回值；
        //示例：yield game.talk('你好，鹰歌')；
        function talk(role=null, msg='', interval=20, pretext='', keeptime=0, style=null, pauseGame=true, callback=true, p=null) {

            const itemRoleMsg = compRoleMsg.createObject(p || itemRoleMsgs, {nIndex: itemRoleMsgs.nIndex});

            ++itemRoleMsgs.nIndex;


            let ret = itemRoleMsg;

            //如果为true，则返回 组件，用户自己配置并调用show
            if(role !== true) {
                /*if(callback === true || callback === 1)
                    //cb为默认回调函数，params为cb所需的参数，cb返回true表示有暂停；
                    callback = function(cb, ...params) {
                        if(cb(...params)) {
                            game.run(true);
                        }
                    }
                */

                //let _resolve, _reject;
                let _callback;
                //如果callback是自定义函数，则调用自定义函数，否则调用默认函数（cb）
                ret = $CommonLibJS.getPromise(function(resolve, reject) {
                    //_resolve = resolve; _reject = reject;
                    _callback = (cb, ...params)=>{
                        if($CommonLibJS.isFunction(callback))
                            callback(cb, ...params);
                        else
                            cb(...params);
                        resolve(params[0]);
                        //reject(params[0]);
                    };
                });
                //ret.$resolve = _resolve; ret.$reject = _reject;
                ret.$params = itemRoleMsg;

                itemRoleMsg.show(role, msg.toString(), interval, pretext.toString(), keeptime, style, pauseGame, _callback);
            }


            return ret;

            //！如果定义为生成器的写法：
            //return yield ret;
        }

        //功能：角色头顶显示文字信息。
        //参数：role为角色名或角色对象；
        //  msg同命令msg的参数；
        //  interval同命令msg的参数；
        //  pretext同命令msg的参数；
        //  keeptime：同命令msg的参数；
        //  style为样式，包括BackgroundColor、BorderColor、FontSize、FontColor；
        //    分别表示 背景色、边框色、字体颜色、字体大小；
        //返回：角色组件对象；
        //示例：game.say('角色名', '你好')；
        function say(role, msg, interval=60, pretext='', keeptime=1000, style={}) {
            if(!role)
                return false;

            if($CommonLibJS.isNumber(role))
                role = role.toString();
            if($CommonLibJS.isString(role)) {
                do {
                    const roleName = role;
                    role = game.hero(roleName);
                    if(role !== null)
                        break;
                    role = game.role(roleName);
                    if(role !== null)
                        break;
                    return false;
                } while(0);

            }
            else if(!$CommonLibJS.isQtObject(role))
                return false;

            //样式
            if(!style)
                style = {};
            const styleSystem = $GameMakerGlobalJS.$config.$role.$say;
            const styleUser = $CommonLibJS.getObjectValue(game.$userscripts, '$config', '$role', '$say') || styleSystem;
            let tn;

            role.message.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
            role.message.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
            //role.message.textArea.font.pointSize = style.FontSize || styleUser.$fontSize || styleSystem.$fontSize;
            tn = style.FontSize || styleUser.$fontSize || styleSystem.$fontSize;
            if(tn < 0)
                role.message.textArea.font.pixelSize = -tn;
            else
                role.message.textArea.font.pixelSize = tn * $fontPointRatio;
                //role.message.textArea.font.pointSize = tn;
            role.message.textArea.color = style.FontColor || styleUser.$fontColor || styleSystem.$fontColor;

            //role.message.visible = true;
            role.message.show($CommonLibJS.convertToHTML(msg.toString()), $CommonLibJS.convertToHTML(pretext.toString()), interval, keeptime, 0b11);


            return role;
        }


        //功能：显示一个菜单；命令用yield关键字修饰表示命令完全运行完毕后再进行下一步。
        //参数：title为显示文字；
        //  items为选项数组；
        //  style为样式，包括MaskColor、BorderColor、BackgroundColor、ItemFontSize、ItemFontColor、ItemBackgroundColor1、ItemBackgroundColor2、TitleFontSize、TitleBackgroundColor、TitleFontColor、ItemBorderColor、ItemHeight、TitleHeight；
        //  pauseGame同命令msg的参数；
        //  callback同命令msg的参数；回调函数的params为index, rootGameMenu；
        //  p为父组件，默认挂在系统提供的组件上（itemGameMenus）；
        //返回：Promise对象（完全运行完毕后状态改变；携带值为选择的下标，0起始；出错会抛出错误），$params属性为消息框组件对象；如果参数title为true，则直接创建组件对象并返回（需要自己调用显示函数）；
        //示例：let choiceIndex = yield game.menu('标题', ['选项A', '选项B'])；
        function menu(title='', items=[], style={}, pauseGame=true, callback=true, p=null) {

            const itemMenu = compGameMenu.createObject(p || itemGameMenus, {nIndex: itemGameMenus.nIndex});
            //let maskMenu = itemMenu.maskMenu;
            //let menuGame = itemMenu.menuGame;

            /*itemMenu.sg_choice.connect(function(index) {
            });*/

            ++itemGameMenus.nIndex;


            let ret = itemMenu;

            //如果为true，则返回 组件，用户自己配置并调用show
            if(title !== true) {
                /*if(callback === true || callback === 1)
                    //cb为默认回调函数，params为cb所需的参数，cb返回true表示有暂停；
                    callback = function(cb, ...params) {
                        if(cb(...params)) {
                            game.run({Script: true, Value: params[0]});
                        }
                    }
                */

                //let _resolve, _reject;
                let _callback;
                //如果callback是自定义函数，则调用自定义函数，否则调用默认函数（cb）
                ret = $CommonLibJS.getPromise(function(resolve, reject) {
                    //_resolve = resolve; _reject = reject;
                    _callback = (cb, ...params)=>{
                        if($CommonLibJS.isFunction(callback))
                            callback(cb, ...params);
                        else
                            cb(...params);
                        resolve(params[0]);
                        //reject(params[0]);
                    };
                });
                //ret.$resolve = _resolve; ret.$reject = _reject;
                ret.$params = itemMenu;

                itemMenu.show(title, items, style, pauseGame, _callback);
            }


            return ret;

            //！如果定义为生成器的写法：
            //return yield ret;
        }

        //功能：显示一个输入框；命令用yield关键字修饰表示命令完全运行完毕后再进行下一步。
        //参数：title为显示文字；
        //  pretext为预设文字；
        //  style为自定义样式；
        //  pauseGame同msg的参数；
        //  callback同命令msg的参数；回调函数的params为text, rootGameInput；
        //  p为父组件，默认挂在系统提供的组件上（itemGameInputs）；
        //返回：Promise对象（完全运行完毕后状态改变；携带值为输入的字符串；出错会抛出错误），$params属性为消息框组件对象；如果参数title为true，则直接创建组件对象并返回（需要自己调用显示函数）；
        //示例：let inputText = yield game.input('标题')；
        function input(title='', pretext='', style={}, pauseGame=true, callback=true, p=null) {

            const itemGameInput = compGameInput.createObject(p || itemGameInputs, {nIndex: itemGameInputs.nIndex});

            ++itemGameInputs.nIndex;


            let ret = itemGameInput;

            //如果为true，则返回 组件，用户自己配置并调用show
            if(title !== true) {
                /*if(callback === true || callback === 1)
                    //cb为默认回调函数，params为cb所需的参数，cb返回true表示有暂停；
                    callback = function(cb, ...params) {
                        if(cb(...params)) {
                            game.run({Script: true, Value: params[0]});
                        }
                    }
                */

                //let _resolve, _reject;
                let _callback;
                //如果callback是自定义函数，则调用自定义函数，否则调用默认函数（cb）
                ret = $CommonLibJS.getPromise(function(resolve, reject) {
                    //_resolve = resolve; _reject = reject;
                    _callback = (cb, ...params)=>{
                        if($CommonLibJS.isFunction(callback))
                            callback(cb, ...params);
                        else
                            cb(...params);
                        resolve(params[0]);
                        //reject(params[0]);
                    };
                });
                //ret.$resolve = _resolve; ret.$reject = _reject;
                ret.$params = itemGameInput;

                itemGameInput.show(title, pretext, style, pauseGame, _callback);
            }


            return ret;

            //！如果定义为生成器的写法：
            //return yield ret;
        }


        //功能：创建地图主角。
        //参数：
        //  role为 角色资源名 或 标准创建格式的对象。
        //    参数对象属性：$id、$name、$showName、$scale、$speed、$penetrate、$realSize、$avatar、$avatarSize、$x、$y、$bx、$by、$direction、$frame、$action、$targetBx、$targetBy、$targetX、$targetY、$targetBlocks、$targetPositions、$targetBlockAuto；
        //    RID为要创建的角色资源名；
        //    $id为角色对象id（默认为$name值），id存在则会复用组件；$name为游戏显示名（默认为RID值）；
        //    $showName为是否头顶显示名字；$scale为缩放倍率数组（横竖坐标轴方向）；$speed为移动速度；$penetrate为是否可穿透；$realSize为影子大小；$avatar为头像文件名；$avatarSize为头像大小；这几个属性会替换已设置好的角色资源的属性；
        //    $x、$y是像素坐标；$bx、$by是地图块坐标（像素坐标和块坐标设置二选一）；此种坐标设置自动会将角色阴影的中心点放在对应坐标上；
        //    $direction表示面向方向（0、1、2、3分别表示上右下左）；
        //    $frame表示第几帧（0起始）；
        //    $action：
        //      为0表示暂时静止；为1表示随机移动；为-1表示禁止移动和操作；
        //      为2表示定向移动；此时（用其中一个即可）：
        //        $targetBx、$targetBy为定向的地图块坐标
        //        $targetX、$targetY为定向的像素坐标；
        //        $targetBlocks为定向的地图块坐标数组；
        //        $targetPositions为定向的像素坐标数组；
        //        $targetBlockAuto为定向的地图块自动寻路坐标数组；
        //    $start表示角色是否自动动作（true或false)；
        //返回：成功为组件对象，失败为false；
        //示例：let h = game.createhero({RID: '角色资源名', 。。。其他属性})；
        //  let h = game.createhero('角色资源名');   //全部使用默认属性；
        function createhero(role={}) {
            if($CommonLibJS.isString(role)) {
                role = {RID: role, $id: role};
            }
            role.$rid = role.RID ?? role.RId;
            role.$type = 1;
            if(!role.$id) {
                if(role.$name)
                    role.$id = role.$name;
                else
                    role.$id = role.$rid + $CommonLibJS.randomString(6, 6, '0123456789');
            }
            /*if(!role.$name) {
                role.$name = role.$id;
            }*/


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


            const roleComp = GameSceneJS.createRole(role.$rid, mainRole, role, itemViewPort.itemRoleContainer);
            if(!roleComp) {
                return false;
            }
            _private.sceneRole = mainRole;


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
            //role.$x = role.$x ?? role.x ?? roleComp.x;
            //role.$y = role.$y ?? role.y ?? roleComp.y;

            role.$speed = role.$speed ?? parseFloat(roleComp.$info.MoveSpeed);
            role.$scale = role.$scale ?? [((roleComp.$info.Scale && roleComp.$info.Scale[0] !== undefined) ? roleComp.$info.Scale[0] : 1), ((roleComp.$info.Scale && roleComp.$info.Scale[1] !== undefined) ? roleComp.$info.Scale[1] : 1)];
            role.$avatar = role.$avatar || roleComp.$info.Avatar || '';
            role.$avatarSize = role.$avatarSize || [((roleComp.$info.AvatarSize && roleComp.$info.AvatarSize[0] !== undefined) ? roleComp.$info.AvatarSize[0] : 0), ((roleComp.$info.AvatarSize && roleComp.$info.AvatarSize[1] !== undefined) ? roleComp.$info.AvatarSize[1] : 0)];
            role.$name = role.$name ?? (roleComp.$info.RoleName || role.$id);
            role.$showName = role.$showName ?? !!roleComp.$info.ShowName ?? true;
            role.$penetrate = role.$penetrate ?? (isNaN(parseInt(roleComp.$info.Penetrate)) ? 0 : parseInt(roleComp.$info.Penetrate));

            role.__proto__ = roleComp.$info;

            //$CommonLibJS.copyPropertiesToObject(trole, role, {objectRecursion: 0});

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

                $CommonLibJS.copyPropertiesToObject(role, game.gd['$sys_main_roles'][index], {objectRecursion: 0});
            }
            game.gd['$sys_main_roles'][index] = role;


            //if(role.$direction === undefined)
            //    role.$direction = 2;



            //发送一次停止信号，来调用相关回调函数
            roleComp.sprite.sg_stoped();

            game.hero(index, role);


            //console.debug('[GameScene]createhero：roleComp：', JSON.stringify(roleComp.$info));


            return roleComp;
        }

        //功能：返回/修改 地图主角组件对象。
        //参数：hero可以是下标，或字符串（主角的$id），或主角组件对象，-1表示返回所有主角组件对象数组；
        //  props：hero不是-1时，为修改单个主角的属性，同 createhero 的第二个参数对象；
        //返回：经过props修改的 主角 或 所有主角的列表；如果没有则返回null；出错返回false；
        //示例：let h = game.hero('主角名')；
        //  let h = game.hero(0, {$bx: 10, $by: 10, $showName: 0, 。。。其他属性})；
        function hero(hero=-1, props={}) {
            if(hero === -1)
                return _private.arrMainRoles;


            //找到index

            let index = -1;
            if($CommonLibJS.isString(hero)) {
                for(index = 0; index < _private.arrMainRoles.length; ++index) {
                    if(_private.arrMainRoles[index].$data.$id === hero) {
                        break;
                    }
                }
            }
            else if($CommonLibJS.isValidNumber(hero)) {
                index = hero;
            }
            else if($CommonLibJS.isObject(hero)) {
                //如果是组件直接用
                if($CommonLibJS.isQtObject(hero))
                    index = hero.$data.$index;
                else {
                    //找出符合过滤条件的
                    let tret = [];
                    for(let tr of game.gd['$sys_main_roles']) {
                        if($CommonLibJS.filterObject(tr, hero))
                            tret.push(tr);
                    }
                    if(tret.length === 0)
                        return false;
                    else if(tret.length > 1)
                        return tret;
                    index = tret[0].$data.$index;
                }
            }
            else {
                return false;
            }

            if(index >= _private.arrMainRoles.length)
                return null;
            else if(index < 0)
                return false;



            hero = game.gd['$sys_main_roles'][index];
            const heroComp = _private.arrMainRoles[index];

            if(!$CommonLibJS.objectIsEmpty(props)) {
                //修改属性
                //$CommonLibJS.copyPropertiesToObject(hero, props, true);

                //!!!后期想办法把reset去掉
                //mainRole.reset();

                //$CommonLibJS.copyPropertiesToObject(hero, props, true);
                if(props.$name !== undefined)   //修改名字
                    hero.$name = heroComp.textName.text = props.$name;
                if(props.$showName !== undefined)   //名字可见
                    hero.$showName = heroComp.rectName.visible = props.$showName;
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
                    //hero.$avatarSize[0]/* = heroComp.$avatarSize.width*/ = props.$avatarSize[0];
                    //hero.$avatarSize[1]/* = heroComp.$avatarSize.height*/ = props.$avatarSize[1];
                    hero.$avatarSize = props.$avatarSize;
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
                if($CommonLibJS.isArray(props.$targetBlockAuto) && props.$targetBlockAuto.length === 2) {
                    let rolePos = heroComp.pos();
                    //heroComp.$$targetsPos = $GameMakerGlobalJS.computePath([rolePos.bx, rolePos.by], [props.$targetBlockAuto[0], props.$targetBlockAuto[1]]);
                    props.$targetBlocks = $GameMakerGlobalJS.computePath([rolePos.bx, rolePos.by], [props.$targetBlockAuto[0], props.$targetBlockAuto[1]]);
                }
                if($CommonLibJS.isArray(props.$targetBlocks)) {
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
                if($CommonLibJS.isArray(props.$targetPositions) && props.$targetPositions.length > 0) {
                    heroComp.$$targetsPos = props.$targetPositions;
                }

                if(props.$action !== undefined)
                    heroComp.$$nActionType = props.$action;

                //如果没有定向目标，则停止
                //if(heroComp.$$targetsPos.length === 0 && props.$action === 2)
                //    props.$action = 0;


                if(props.$bx || props.$by)
                    setMainRolePos(parseInt(props.$bx), parseInt(props.$by), hero.$index);

                if(props.$x !== undefined) { //修改x坐标
                    hero.$x = props.$x;
                    heroComp.x = props.$x - heroComp.x1 - heroComp.width1 / 2;
                }
                if(props.$y !== undefined) { //修改y坐标
                    hero.$y = props.$y;
                    heroComp.y = props.$y - heroComp.y1 - heroComp.height1 / 2;
                }


                if(props.$direction !== undefined)
                    heroComp.changeAction(props.$direction);
                    /*/貌似必须10ms以上才可以使其转向（鹰：使用AnimatedSprite就不用延时了）
                    $CommonLibJS.setTimeout([function() {
                        if(heroComp)
                            heroComp.start(props.$direction, null);
                    }, 1, rootGameScene], 20);
                    */

                if(props.$frame !== undefined)
                    heroComp.sprite.setCurrentFrame(props.$frame);

                if(props.$realSize !== undefined) {
                    heroComp.width1 = props.$realSize[0];
                    heroComp.height1 = props.$realSize[1];
                    //console.debug('', props.$realSize)
                }


                //如果不是从 createhero 过来的（createhero过来的，hero和props是一个对象）
                if(props !== hero) {
                    //其他属性直接赋值
                    let usedProps = ['RID', '$id', '$name', '$showName', '$penetrate', '$speed', '$scale', '$avatar', '$avatarSize', '$targetBx', '$targetBy', '$targetX', '$targetY', '$targetBlocks', '$targetPositions', '$targetBlockAuto', '$action', '$x', '$y', '$bx', '$by', '$direction', '$frame', '$realSize', '$start'];
                    //for(let tp in props) {
                    for(let tp of Object.keys(props)) {
                        if(usedProps.indexOf(tp) >= 0)
                            continue;
                        heroComp[tp]/* = hero[tp]*/ = props[tp];
                    }
                }

                //if(props.$x !== undefined || props.$y !== undefined || props.$bx !== undefined || props.$by !== undefined)
                    if(heroComp === _private.sceneRole)setSceneToRole();


                if(props.$start === true) {
                    /*
                    $CommonLibJS.setTimeout([function() {
                        roleComp.start();
                    }, 1, rootGameScene, 'fight.continueFight'], 1);

                    $CommonLibJS.runNextEventLoop([function() {
                        roleComp.start();
                        }, 'game.run1']);
                    */
                    heroComp.start();
                }
                else if(props.$start === false)
                    heroComp.stop();

            }


            return heroComp;
        }

        //功能：删除地图主角；
        //参数：hero可以是下标，或主角的$id，或主角组件对象，-1表示所有主角；
        //返回：删除成功返回true；没有或错误返回false；
        //示例：game.delhero('地图主角名');
        function delhero(hero=-1) {

            const tmpDelHero = function(mainRole) {
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

                _private.sceneRole = null;
            }


            if(hero === -1) {
                for(let tr of _private.arrMainRoles) {
                    //tr.destroy();
                    tr.visible = false;
                    tmpDelHero(mainRole);

                    for(let tc in tr.$tmpComponents) {
                        let c = tr.$tmpComponents[tc];
                        if($CommonLibJS.isQtObject(c)) {
                            (c.$destroy ?? c.Destroy ?? c.destroy)();
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
            if($CommonLibJS.isString(hero)) {
                for(index = 0; index < _private.arrMainRoles.length; ++index) {
                    if(_private.arrMainRoles[index].$data.$id === hero) {
                        break;
                    }
                }
            }
            else if($CommonLibJS.isValidNumber(hero))
                index = hero;
            else if($CommonLibJS.isObject(hero)) {
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
                const c = _private.arrMainRoles[index].$tmpComponents[tc];
                if($CommonLibJS.isQtObject(c)) {
                    (c.$destroy ?? c.Destroy ?? c.destroy)();
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

        //功能：将主角移动到地图 bx、by 位置。
        //参数：bx、by为目标地图块；如果超出地图，则自动调整；
        //示例：game.movehero(6,6);
        function movehero(...args) {
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


        //功能：创建地图NPC。
        //参数：role为 角色资源名 或 标准创建格式的对象（RID为角色资源名）；
        //  参数对象属性：同createhero参数；
        //成功为组件对象，失败为false。
        function createrole(role={}) {

            if($CommonLibJS.isString(role)) {
                role = {RID: role, $id: role};
            }
            role.$rid = role.RID ?? role.RId;
            role.$type = 2;
            if(!role.$id) {
                if(role.$name)
                    role.$id = role.$name;
                else
                    role.$id = role.$rid + $CommonLibJS.randomString(6, 6, '0123456789');
            }
            /*if(!role.$name) {
                role.$name = role.$id;
            }*/


            if(_private.objRoles[role.$id] !== undefined)
                return false;


            let roleComp = GameSceneJS.createRole(role.$rid, null, role, itemViewPort.itemRoleContainer);
            if(!roleComp) {
                return false;
            }


            roleComp.$data = role;
            roleComp.$$type = 2;
            //roleComp.$id = role.$id;


            _private.objRoles[role.$id] = roleComp;


            //role.$x = role.$x ?? role.x; // ?? roleComp.x;
            //role.$y = role.$y ?? role.y; // ?? roleComp.y;

            //roleComp.$name = role.$name;
            role.$speed = role.$speed ?? parseFloat(roleComp.$info.MoveSpeed);
            role.$scale = role.$scale ?? [((roleComp.$info.Scale && roleComp.$info.Scale[0] !== undefined) ? roleComp.$info.Scale[0] : 1), ((roleComp.$info.Scale && roleComp.$info.Scale[1] !== undefined) ? roleComp.$info.Scale[1] : 1)];
            role.$avatar = role.$avatar || roleComp.$info.Avatar || '';
            role.$avatarSize = role.$avatarSize || [((roleComp.$info.AvatarSize && roleComp.$info.AvatarSize[0] !== undefined) ? roleComp.$info.AvatarSize[0] : 0), ((roleComp.$info.AvatarSize && roleComp.$info.AvatarSize[1] !== undefined) ? roleComp.$info.AvatarSize[1] : 0)];
            role.$name = role.$name ?? (roleComp.$info.RoleName || role.$id);
            role.$showName = role.$showName ?? !!roleComp.$info.ShowName ?? true;
            role.$penetrate = role.$penetrate ?? (isNaN(parseInt(roleComp.$info.Penetrate)) ? 0 : parseInt(roleComp.$info.Penetrate));

            role.__proto__ = roleComp.$info;

            //if(role.$direction === undefined)
            //    role.$direction = 2;



            //发送一次停止信号，来调用相关回调函数
            roleComp.sprite.sg_stoped();

            game.role(roleComp, role);


            return roleComp;

        }

        //功能：返回/修改 地图NPC组件对象。
        //参数：role可以是字符串（NPC的$id），或NPC组件对象，-1表示返回所有NPC组件对象数组；
        //  props：role不是-1时，为修改单个NPC的属性，同 createhero 的第二个参数对象；
        //返回：经过props修改的 NPC 或 所有NPC的列表；如果没有则返回null；出错返回false；
        //示例：let h = game.role('NPC的$id');
        //  let h = game.role('NPC的$id', {$bx: 10, $by: 10, $showName: 0, 。。。其他属性});
        function role(role=-1, props={}) {
            if(role === -1/* || role === undefined || role === null*/)
                return _private.objRoles;


            let roleComp;

            if($CommonLibJS.isString(role)) {
                roleComp = _private.objRoles[role];
                if(roleComp === undefined)
                    return null;
            }
            else if($CommonLibJS.isValidNumber(role))
                return false;
            else if($CommonLibJS.isObject(role)) {
                //如果是组件直接用
                if($CommonLibJS.isQtObject(role))
                    roleComp = role;
                else {
                    //找出符合过滤条件的
                    let tret = [];
                    for(let ti in _private.objRoles) {
                        const tr = _private.objRoles[ti]
                        if($CommonLibJS.filterObject(tr, role))
                            tret.push(tr);
                    }
                    if(tret.length === 0)
                        return false;
                    else if(tret.length > 1)
                        return tret;
                    roleComp = tret[0];
                }
            }
            else
                return false;


            role = roleComp.$data;


            if(!$CommonLibJS.objectIsEmpty(props)) {
                //修改属性
                //$CommonLibJS.copyPropertiesToObject(roleComp, props, true);

                //!!!后期想办法把reset去掉
                //roleComp.reset();

                if(props.$name !== undefined)   //修改名字
                    role.$name = roleComp.textName.text = props.$name;
                if(props.$showName !== undefined)   //名字可见
                    role.$showName = roleComp.rectName.visible = props.$showName;
                if(props.$penetrate !== undefined)   //可穿透
                    role.$penetrate = /*roleComp.$penetrate = */props.$penetrate;
                if(props.$speed !== undefined)   //修改速度
                    role.$speed = roleComp.$$speed = parseFloat(props.$speed);
                if(props.$scale && props.$scale[0] !== undefined) { //缩放
                    role.$scale[0] = roleComp.rXScale = props.$scale[0];
                }
                if(props.$scale && props.$scale[1] !== undefined) {
                    role.$scale[1] = roleComp.rYScale = props.$scale[1];
                }

                //!!!这里要加入名字是否重复
                if(props.$avatar !== undefined)   //修改头像
                    role.$avatar/* = roleComp.$avatar*/ = props.$avatar;
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
                if($CommonLibJS.isArray(props.$targetBlockAuto) && props.$targetBlockAuto.length === 2) {
                    let rolePos = roleComp.pos();
                    //roleComp.$$targetsPos = $GameMakerGlobalJS.computePath([rolePos.bx, rolePos.by], [props.$targetBlockAuto[0], props.$targetBlockAuto[1]]);
                    props.$targetBlocks = $GameMakerGlobalJS.computePath([rolePos.bx, rolePos.by], [props.$targetBlockAuto[0], props.$targetBlockAuto[1]]);
                }
                if($CommonLibJS.isArray(props.$targetBlocks) && props.$targetBlocks.length > 0) {
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
                if($CommonLibJS.isArray(props.$targetPositions)) {
                    roleComp.$$targetsPos = props.$targetPositions;
                }

                if(props.$action !== undefined)
                    roleComp.$$nActionType = props.$action;

                //如果没有定向目标，则停止
                //if(roleComp.$$targetsPos.length === 0 && props.$action === 2)
                //    props.$action = 0;


                if(props.$bx !== undefined || props.$by !== undefined)
                    setRolePos(props.$bx, props.$by, roleComp);
                    //moverole(roleComp, bx, by);

                if(props.$x !== undefined) { //修改x坐标
                    roleComp.x = props.$x - roleComp.x1 - roleComp.width1 / 2;
                }
                if(props.$y !== undefined) { //修改y坐标
                    roleComp.y = props.$y - roleComp.y1 - roleComp.height1 / 2;
                }


                if(props.$direction !== undefined)
                    roleComp.changeAction(props.$direction);
                    /*/貌似必须10ms以上才可以使其转向（鹰：使用AnimatedSprite就不用延时了）
                    $CommonLibJS.setTimeout([function() {
                        if(roleComp)
                            roleComp.start(props.$direction, null);
                    }, 1, rootGameScene], 20);
                    */

                if(props.$frame !== undefined)
                    roleComp.sprite.setCurrentFrame(props.$frame);

                if(props.$realSize !== undefined) {
                    roleComp.width1 = props.$realSize[0];
                    roleComp.height1 = props.$realSize[1];
                    //console.debug('', props.$realSize)
                }


                //如果不是从 createrole 过来的（createrole过来的，role和props是一个对象）
                if(props !== role) {
                    //其他属性直接赋值
                    let usedProps = ['RID', '$id', '$name', '$showName', '$penetrate', '$speed', '$scale', '$avatar', '$avatarSize', '$targetBx', '$targetBy', '$targetX', '$targetY', '$targetBlocks', '$targetPositions', '$targetBlockAuto', '$action', '$x', '$y', '$bx', '$by', '$direction', '$frame', '$realSize', '$start'];
                    //for(let tp in props) {
                    for(let tp of Object.keys(props)) {
                        if(usedProps.indexOf(tp) >= 0)
                            continue;
                        roleComp[tp]/* = role[tp]*/ = props[tp];
                    }
                }

                //if(props.$x !== undefined || props.$y !== undefined || props.$bx !== undefined || props.$by !== undefined)
                    if(roleComp === _private.sceneRole)setSceneToRole();


                if(props.$start === true) {
                    /*
                    $CommonLibJS.setTimeout([function() {
                        roleComp.start();
                    }, 1, rootGameScene, 'fight.continueFight'], 1);

                    $CommonLibJS.runNextEventLoop([function() {
                        roleComp.start();
                        }, 'game.run1']);
                    */
                    roleComp.start();
                }
                else if(props.$start === false)
                    roleComp.stop();

            }


            return roleComp;
        }

        //功能：删除地图NPC；
        //参数：role可以是NPC的$id，或NPC组件对象，-1表示当前地图所有NPC；
        //返回：删除成功返回true；没有或错误返回false；
        //示例：game.delhero('地图NPC的$id');
        function delrole(role=-1) {
            if(role === -1) {
                for(let r in _private.objRoles) {
                    for(let tc in _private.objRoles[r].$tmpComponents) {
                        let c = _private.objRoles[r].$tmpComponents[tc];
                        if($CommonLibJS.isQtObject(c)) {
                            (c.$destroy ?? c.Destroy ?? c.destroy)();
                        }
                    }

                    _private.objRoles[r].destroy();
                }
                _private.objRoles = {};

                return true;
            }



            if($CommonLibJS.isNumber(role))
                role = role.toString();
            if($CommonLibJS.isString(role)) {
                role = _private.objRoles[role];
                if(role === undefined)
                    return false;
            }
            else if(!$CommonLibJS.isQtObject(role))
                return false;


            delete _private.objRoles[role.$data.$id];

            for(let tc in role.$tmpComponents) {
                let c = role.$tmpComponents[tc];
                if($CommonLibJS.isQtObject(c)) {
                    (c.$destroy ?? c.Destroy ?? c.destroy)();
                }
            }
            role.destroy();



            return true;
        }

        //功能：将NPC移动到地图 bx、by 位置。
        //参数：bx、by为目标地图块；如果超出地图，则自动调整；
        //示例：game.moverole('NPC的$id',6,6);
        function moverole(role, bx, by) {

            if($CommonLibJS.isNumber(role))
                role = role.toString();
            if($CommonLibJS.isString(role)) {
                role = _private.objRoles[role];
                if(role === undefined)
                    return false;
            }
            else if(!$CommonLibJS.isQtObject(role))
                return false;


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


        //功能：返回角色的各种坐标，或判断是否在某个地图块坐标上；
        //参数：
        //  role为角色组件（可用hero和role命令返回的组件）；
        //    如果为数字或空，则是主角；如果是字符串表示$id，会在 主角和NPC 中查找；
        //  pos为[bx,by]，返回角色是否在这个地图块坐标上；如果为空则表示返回角色中心所在各种坐标；
        //返回：如果是判断，返回true或false；如果返回是坐标，则包括bx、by（地图块坐标）、cx、cy（或x、y，中心坐标）、rx1、ry2、rx2、ry2（影子的左上和右下坐标）、sx、sy（视窗中的坐标）；出错返回false；
        function rolepos(role, pos=null) {
            if($CommonLibJS.isValidNumber(role)) {
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
                    //x: role.x,
                    //y: role.y,
                    //中心坐标
                    x: centerX,
                    y: centerY,
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



        //功能：创建一个战斗主角，并放入我方战斗队伍。
        //参数：fightrole为战斗主角资源名 或 标准创建格式的参数对象（具有RID、Params和其他属性）。
        //返回：战斗主角对象。
        //示例：game.createfighthero('战斗角色1'); game.createfighthero({RID: '战斗角色2', Params: {级别: 6}, $name: '鹰战士'});
        function createfighthero(fightrole) {
            if(game.gd['$sys_fight_heros'] === undefined)
                game.gd['$sys_fight_heros'] = [];


            let newFightRole = GameSceneJS.getFightRoleObject(fightrole, true);
            if(newFightRole === null)
                return false;
            //newFightRole.$rid = fightRoleRID;
            newFightRole.$index = game.gd['$sys_fight_heros'].length;
            game.gd['$sys_fight_heros'].push(newFightRole);


            return newFightRole;
        }

        //功能：删除我方战斗队伍中的一个战斗主角。
        //参数：fighthero为下标，或战斗角色的$name，或战斗角色对象，或-1（删除所有战斗主角）。
        //返回：成功返回true；错误或没找到返回false。
        //示例：game.delfighthero(0); game.delfighthero('鹰战士');
        function delfighthero(fighthero) {

            if(fighthero === -1) {
                game.gd['$sys_fight_heros'] = [];
                return true;
            }


            if(fighthero >= 0 || $CommonLibJS.isString(fighthero) || $CommonLibJS.isObject(fighthero))
                fighthero = game.fighthero(fighthero);
            else
                fighthero = null;
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
            loaderFightScene.enemies.push(new _private.objCommonScripts.$Combatant(name));

        }*/

        //功能：返回我方战斗队伍中的战斗主角；
        //参数：fighthero为下标，或战斗角色$id，或战斗角色对象，或-1（返回所有战斗主角）；
        //  type为0表示返回 对象，为1表示只返回名字（可用作选择组件）；
        //返回：战斗角色对象、名字字符串或数组；false表示没找到或出错；
        //示例：let h = game.fighthero('鹰战士');
        //  let h = game.fighthero(0);
        //  let arrNames = game.fighthero(-1, 1);
        readonly property var fighthero: function(fighthero=-1, type=0) {
            if(game.gd['$sys_fight_heros'] === undefined || game.gd['$sys_fight_heros'] === null)
                return false;

            if(fighthero === null)
                return null;
            //else if(fighthero === undefined)
            //    fighthero = -1;

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


            if($CommonLibJS.isString(fighthero)) {
                for(let fightheroIndex = 0; fightheroIndex < game.gd['$sys_fight_heros'].length; ++fightheroIndex) {
                    if(game.gd['$sys_fight_heros'][fightheroIndex].$id === fighthero) {
                        fighthero = game.gd['$sys_fight_heros'][fightheroIndex];
                        break;
                    }
                }
            }
            if($CommonLibJS.isObject(fighthero)) {
                //fightHero = fighthero;
                //fightheroIndex = fighthero.$index;
            }
            else if($CommonLibJS.isValidNumber(fighthero)) {
                if(fighthero >= game.gd['$sys_fight_heros'].length)
                    return false;
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



            if(fighthero >= 0 || $CommonLibJS.isString(fighthero) || $CommonLibJS.isObject(fighthero))
                fighthero = game.fighthero(fighthero);
            else
                fighthero = null;
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



            if(fighthero >= 0 || $CommonLibJS.isString(fighthero) || $CommonLibJS.isObject(fighthero))
                fighthero = game.fighthero(fighthero);
            else
                fighthero = null;
            if(!fighthero)
                return false;



            //如果直接是 字符串或全部，则 按 过滤条件 找出所有
            if($CommonLibJS.isString(skill) || skill === -1) {
                let deletedSkills = [];
                let tSkills = fighthero.$skills;
                fighthero.$skills = [];

                //循环每个技能
                for(let tskill of tSkills) {
                    //如果找到技能rid
                    if($CommonLibJS.isString(skill) && tskill.$rid !== skill) {
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
            else if($CommonLibJS.isValidNumber(skill)) {
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
        //fighthero为下标，或战斗角色的$id，或战斗角色对象；
        //skill：技能下标（-1为所有 并符合filters 的 技能），或 技能$id（并符合filters 的 技能）；
        //filters：技能条件筛选；
        //成功返回 技能数组；
        readonly property var skill: function(fighthero, skill=-1, filters={}) {
            if(skill === undefined || skill === null)
                skill = -1;
            //if(type === undefined || type === null)
            //    type = -1;
            //if(skillIndex >= objFightRoles.$skills.length || fightheroIndex < 0)
            //    return null;



            if(fighthero >= 0 || $CommonLibJS.isString(fighthero) || $CommonLibJS.isObject(fighthero))
                fighthero = game.fighthero(fighthero);
            else
                fighthero = null;
            if(!fighthero)
                return false;



            //如果直接是 字符串或全部，则 按 过滤条件 找出所有
            if($CommonLibJS.isString(skill) || skill === -1) {

                let tSkills = [];

                //循环每个技能
                for(let tskill of fighthero.$skills) {
                    //如果找到技能rid
                    if($CommonLibJS.isString(skill) && tskill.$id !== skill) {
                        //fighthero.$skills.push(tskill);
                        continue;
                    }

                    //有筛选
                    if(filters && $CommonLibJS.filterObject(tskill, filters)) {
                        tSkills.push(tskill);
                    }
                }

                if(tSkills.length === 0)
                    return null;
                return tSkills;
            }
            else if($CommonLibJS.isValidNumber(skill)) {
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
            else if($CommonLibJS.isObject(skill)) { //如果直接是对象
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
        //  type如果为数组，第一个值为上面的含义，第二个表示乘的时候 参考属性（0为properties（默认），1为propertiesWithExtra）；
        //  flags：从左到右：是否检测升级，是否调用刷新函数（如果修改一些不用刷新的属性，就不用刷新）；
        //  成功返回战斗角色对象；失败返回false；
        readonly property var addprops: function(fighthero, props={}, type=[1,1], flags=0b11) {
            if(fighthero >= 0 || $CommonLibJS.isString(fighthero) || $CommonLibJS.isObject(fighthero))
                fighthero = game.fighthero(fighthero);
            else
                fighthero = null;
            if(!fighthero)
                return false;


            //先刷新一次（主要是$$propertiesWithExtra）
            if(flags & 0b1)
                _private.objCommonScripts.$refreshCombatant(fighthero, false);

            //参考属性（乘以比例时的参考属性）
            let propertyFlag;
            if($CommonLibJS.isNumber(type)) {
                //properties2 = fighthero.$properties; //fighthero.$$propertiesWithExtra;
                propertyFlag = false;
            }
            else {
                if(type[1] === 1)
                    //properties2 = fighthero.$$propertiesWithExtra;
                    propertyFlag = true;
                else
                    //properties2 = fighthero.$properties;
                    propertyFlag = false;

                type = type[0];
            }

            $GameMakerGlobalJS.addProps(fighthero, props, type, propertyFlag);

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
                _private.objCommonScripts.$refreshCombatant(fighthero, !!(flags & 0b10));


            return fighthero;
        }

        //从 goods 中给 背包 转移 count个道具；返回背包中 改变后 道具个数，返回false表示不够或其他错误。
        //goods可以为 道具资源名、 或 标准创建格式的对象（带有RID、Params和其他属性），或道具本身（带有$rid），或 下标；
        //  如果为 下标，则直接加减；如果为 字符串（默认1个数量）、对象（数量要提供），则获取道具对象后，从这个对象中转移；
        //count为>0表示转移个数，为0表示返回数量；<0（或非数字）表示将goods的$count全部转移（默认）。
        readonly property var getgoods: function(goods, count) {
            if(!$CommonLibJS.isNumber(count))
                count = $CommonLibJS.shortCircuit(0b1, $CommonLibJS.getObjectValue(goods, '$count'), -1);

            if($CommonLibJS.isObject(goods)) { //如果直接是对象
                if(count > 0 && goods.$count === undefined)
                    goods.$count = count;
                goods = GameSceneJS.getGoodsObject(goods, false);
                if(!goods)
                    return null;

                if(!goods.$count)
                    goods.$count = 0;
                /*else {
                    count += goods.$count;
                    goods.$count = 0;
                }*/

            }
            else if($CommonLibJS.isString(goods)) { //如果直接是字符串
                goods = GameSceneJS.getGoodsObject(goods, count > 0 ? {$count: count} : undefined);
                if(!goods)
                    return null;

                if(!goods.$count)
                    goods.$count = 0;

            }
            else if($CommonLibJS.isValidNumber(goods)) { //如果直接是数字
                if(goods < 0 || goods >= game.gd['$sys_goods'].length)
                    return false;

                goods = game.gd['$sys_goods'][goods];
                if(goods.$count + count > 0)
                    goods.$count += count;
                //if(goodsProps)
                //    $CommonLibJS.copyPropertiesToObject(goods, goodsProps/*, true*/);  //!!更改对象属性

                return goods.$count;
            }
            else
                return false;


            if(count > 0 && goods.$count - count < 0)
                return false;


            //如果count为0（返回个数） 或 stackable（可叠加），则查找
            if(count === 0 || goods.$stackable) {
                //循环查找goods
                for(let tg of game.gd['$sys_goods']) {
                    //找到
                    if(tg && tg.$rid === goods.$rid) {
                        //返回个数
                        if(count === 0) {
                            return tg.$count;
                        }

                        //如果都可叠加
                        if(tg.$stackable && goods.$stackable) {
                            //如果不是同一个物品，则把goods减一下（其他地方可能有用）
                            //if(tg !== goods)
                            //    goods.$count -= count;

                            if(count > 0)
                                tg.$count += count;
                            else
                                tg.$count += goods.$count;

                            return tg.$count;
                        }
                    }
                }
            }


            //如果没有找到 或 要叠加

            if(count === 0)
                return 0;
            else if(count > 0)
                goods.$count = count;

            goods.$location = 1;
            game.gd['$sys_goods'].push(goods);

            return goods.$count;
        }

        //背包内 减去count个道具，返回背包中 改变后 道具个数；
        //goods可以为 道具资源名、道具对象 和 下标；
        //count为个数，如果为true则表示道具的所有；
        //如果 装备数量不够，则返回<0（相差数），原道具数量不变化；
        //返回 false 表示错误；
        readonly property var removegoods: function(goods, count=1) {
            if(!$CommonLibJS.isValidNumber(count) || count < 0)   //如果直接是数字
                return false;


            if($CommonLibJS.isObject(goods)) { //如果是 道具对象
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
            else if($CommonLibJS.isValidNumber(goods)) { //如果直接是数字
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
            else if($CommonLibJS.isString(goods)) { //如果直接是字符串
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

        //获得背包中某项道具信息；
        //参数：
        //  goodsFilter为-1表示返回所有道具的数组；
        //  goodsFilter为数字（下标），则返回单个道具信息的数组；
        //  goodsFilter为字符串（道具$id），返回所有符合道具信息的数组；
        //  goodsFilter为对象：1、如果是道具对象，则查找是否在背包中，2、如果是普通对象，则goodsFilter为过滤条件（可判断$rid、$id、$name等所有道具属性）；
        //返回格式：道具数组、null（不存在）或false（错误）；
        function goods(goodsFilter=-1) {
            if(goodsFilter === -1)
                return game.gd['$sys_goods'];
            //如果是对象
            else if($CommonLibJS.isObject(goodsFilter)) {
                //如果已经是道具对象，则判断是否存在
                if(goodsFilter.$rid && GameSceneJS.getGoodsResource(goodsFilter.$rid)) {
                    for(let tg of game.gd['$sys_goods']) {
                        if(tg === goodsFilter)
                            return [tg];
                    }
                    return null;
                }
            }
            //如果是数字，则为下标
            else if($CommonLibJS.isValidNumber(goodsFilter)) {
                if(goodsFilter >= game.gd['$sys_goods'].length)
                    return null;
                else if(goodsFilter < 0)
                    return false;
                else {
                    let tg = game.gd['$sys_goods'][goodsFilter];
                    return tg ? [tg] : null;
                }
                //else
                //    return game.gd['$sys_goods'];
            }
            //如果直接是 字符串，则为id
            else if($CommonLibJS.isString(goodsFilter)) {
                goodsFilter = {$id: goodsFilter};
            }
            else
                return false;

            //按 过滤条件 找出所有
            let ret = [];

            for(let tg of game.gd['$sys_goods']) {
                //有筛选
                if(!$CommonLibJS.objectIsEmpty(goodsFilter) && $CommonLibJS.filterObject(tg, goodsFilter))
                    ret.push(tg);
            }

            if(ret.length === 0)
                return null;
            return ret;
        }

        //使用道具（会执行道具$useScript）；
        //fighthero为下标，或战斗角色的name，或战斗角色对象，或战斗对象数组，也可以为null或undefined；
        //goods可以为 道具id、筛选对象、背包下标（这三种会从背包筛选） 或 标准创建格式的对象（必须带有RID、Params，其他属性可选）、道具对象（这两种会直接使用不从背包筛选）；如果筛选出多个，按第一个找到的来；
        //params是给$useScript的自定义参数，默认功能是 回调函数 或 减去的数量（数字）；
        //返回：脚本的返回值（为受影响的 战斗角色数组）；false表示错误；null表示脚本不存在；
        //示例：yield usegoods(0, '道具');
        function usegoods(fighthero, goods, params=1) {
            //let _resolve, _reject;

            //！如果定义为生成器格式，则将 resolve 和 reject 删除即可（用return返回数据）；
            const _usegoods = function(resolve, reject) {
                //_resolve = resolve; _reject = reject;

                //game.run({Script: function*() {
                game.async([function*() { //效果和run一样，但使用async能更好的在async函数里使用；
                    //let copyedNewProps;
                    //if($CommonLibJS.isObject(params)) {
                        //copyedNewProps = params.NewProps ?? {$count: 1};
                    //}

                    //如果已经是道具对象，则直接使用
                    if($CommonLibJS.isObject(goods) && goods.$rid && GameSceneJS.getGoodsResource(goods.$rid)) {
                    }
                    //创建道具对象
                    else if($CommonLibJS.isObject(goods) && (goods.RID ?? goods.RId) !== undefined) {
                        goods = GameSceneJS.getGoodsObject(goods);
                    }
                    //否则从背包中查找
                    else {
                        goods = game.goods(goods);
                        if(!goods) {
                            //scriptQueue.runNextEventLoop('usegoods');
                            //return reject(false);
                            return resolve(false);
                        }
                        else
                            goods = goods[0];
                    }
                    /*
                    if($CommonLibJS.isValidNumber(goods)) { //如果直接是数字
                        if(goods < 0 || goods >= game.gd['$sys_goods'].length) {
                            //scriptQueue.runNextEventLoop('usegoods');
                            //return reject(false);
                            return resolve(false);
                        }

                        goods = game.gd['$sys_goods'][goods];
                        //goods = GameSceneJS.getGoodsObject(goods/*, copyedNewProps* /);
                        //goodsInfo = GameSceneJS.getGoodsResource(goods.$rid);
                    }
                    else {
                        goods = GameSceneJS.getGoodsObject(goods, false/*, copyedNewProps* /);
                    }
                    */
                    /*else if($CommonLibJS.isObject(goods)) { //如果直接是对象
                        goodsInfo = GameSceneJS.getGoodsResource(goods.$rid);
                    }
                    else if($CommonLibJS.isString(goods)) { //如果直接是字符串
                        goodsInfo = GameSceneJS.getGoodsResource(goods);
                        goods = GameSceneJS.getGoodsObject(goods);
                    }
                    else {
                        //scriptQueue.runNextEventLoop('usegoods');
                        //return reject(false);
                        return resolve(false);
                    }
                    if(!goods) {
                        //scriptQueue.runNextEventLoop('equip');
                        //return reject(false);
                        return resolve(false);
                    }
                    */

                    let goodsInfo = GameSceneJS.getGoodsResource(goods.$rid);
                    if(!goodsInfo) {
                        //scriptQueue.runNextEventLoop('usegoods');
                        //return reject(false);
                        return resolve(false);
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

                    if(fighthero >= 0 || $CommonLibJS.isString(fighthero) || $CommonLibJS.isObject(fighthero))
                        fighthero = game.fighthero(fighthero);
                    //else if($CommonLibJS.isArray(fighthero))
                    //    ;
                    //else
                    //    fighthero = null;
                    //if(!fighthero)
                    //    return resolve(false);


                    let useScript;
                    if($CommonLibJS.checkCallable(useScript = goodsInfo.$commons.$useScript)) {
                    }
                    else if($CommonLibJS.checkCallable(useScript = _private.objCommonScripts.$commonUseScript)) {
                    }
                    else
                        return resolve(null);

                    let r = useScript.call(goods, goods, fighthero, params);
                    if($CommonLibJS.isGenerator(r))r = yield* r;

                    //计算新属性
                    //for(let fighthero of game.gd['$sys_fight_heros'])
                    _private.objCommonScripts.$refreshCombatant(r);
                    //刷新战斗时人物数据
                    //fight.$sys.refreshCombatant(-1);

                    return resolve(r);

                }(), 'usegoods']);
                //}(), Priority: -2, Type: 0, Running: 0, Tips: 'usegoods'});
            };

            let ret = $CommonLibJS.getPromise(_usegoods);
            //ret.$resolve = _resolve; ret.$reject = _reject;
            return ret;
        }

        //装备道具（会执行道具的$equipScript）；
        //fighthero为下标，或战斗角色的name，或战斗角色对象，或战斗对象数组，也可以为null或undefined；
        //goods可以为 道具id、筛选对象、背包下标（这三种会从背包筛选） 或 标准创建格式的对象（必须带有RID、Params，其他属性可选）、道具对象（这两种会直接使用不从背包筛选）；如果筛选出多个，按第一个找到的来；
        //params是给$useScript的自定义参数，默认功能是 回调函数 或 减去的数量（数字）；
        //返回：脚本的返回值（默认为true）；false表示错误；null表示脚本不存在；
        //示例：yield equip(0, '道具');
        function equip(fighthero, goods, params=1) {
            //let _resolve, _reject;

            //！如果定义为生成器格式，则将 resolve 和 reject 删除即可（用return返回数据）；
            const _equip = function(resolve, reject) {
                //_resolve = resolve; _reject = reject;

                //game.run({Script: function*() {
                game.async([function*() { //效果和run一样，但使用async能更好的在async函数里使用；
                    //let copyedNewProps;
                    //if($CommonLibJS.isObject(params)) {
                        //copyedNewProps = params.NewProps ?? {$count: 1};
                    //}

                    //如果已经是道具对象，则直接使用
                    if($CommonLibJS.isObject(goods) && goods.$rid && GameSceneJS.getGoodsResource(goods.$rid)) {
                    }
                    //创建道具对象
                    else if($CommonLibJS.isObject(goods) && (goods.RID ?? goods.RId) !== undefined) {
                        goods = GameSceneJS.getGoodsObject(goods);
                    }
                    //否则从背包中查找
                    else {
                        goods = game.goods(goods);
                        if(!goods) {
                            //scriptQueue.runNextEventLoop('equip');
                            //return reject(false);
                            return resolve(false);
                        }
                        else
                            goods = goods[0];
                    }
                    /*if($CommonLibJS.isValidNumber(goods)) { //如果直接是数字
                        if(goods < 0 || goods >= game.gd['$sys_goods'].length) {
                            //scriptQueue.runNextEventLoop('equip');
                            //return reject(false);
                            return resolve(false);
                        }

                        goods = game.gd['$sys_goods'][goods];
                        //goods = GameSceneJS.getGoodsObject(goods/*, copyedNewProps* /);
                        //goodsInfo = GameSceneJS.getGoodsResource(goods.$rid);
                    }
                    else {
                        goods = GameSceneJS.getGoodsObject(goods, false/*, copyedNewProps* /);
                    }
                    */
                    /*else if($CommonLibJS.isObject(goods)) { //如果直接是对象
                        goodsInfo = GameSceneJS.getGoodsResource(goods.$rid);
                    }
                    else if($CommonLibJS.isString(goods)) { //如果直接是字符串
                        goodsInfo = GameSceneJS.getGoodsResource(goods);
                        goods = GameSceneJS.getGoodsObject(goods);
                    }
                    else {
                        //scriptQueue.runNextEventLoop('equip');
                        //return reject(false);
                        return resolve(false);
                    }
                    if(!goods) {
                        //scriptQueue.runNextEventLoop('equip');
                        //return reject(false);
                        return resolve(false);
                    }
                    */

                    let goodsInfo = GameSceneJS.getGoodsResource(goods.$rid);
                    if(!goodsInfo) {
                        //scriptQueue.runNextEventLoop('equip');
                        //return reject(false);
                        return resolve(false);
                    }


                    if(fighthero >= 0 || $CommonLibJS.isString(fighthero) || $CommonLibJS.isObject(fighthero))
                        fighthero = game.fighthero(fighthero);
                    //else if($CommonLibJS.isArray(fighthero))
                    //    ;
                    //else
                    //    fighthero = null;
                    //if(!fighthero)
                    //    return resolve(false);


                    let equipScript;
                    if($CommonLibJS.checkCallable(equipScript = goodsInfo.$commons.$equipScript)) {
                    }
                    else if($CommonLibJS.checkCallable(equipScript = _private.objCommonScripts.$commonEquipScript)) {
                    }
                    else
                        return resolve(null);

                    let r = equipScript.call(goods, goods, fighthero, params);
                    if($CommonLibJS.isGenerator(r))r = yield* r;

                    //计算新属性
                    //for(let fighthero of game.gd['$sys_fight_heros'])
                    _private.objCommonScripts.$refreshCombatant(r);
                    //刷新战斗时人物数据
                    //fight.$sys.refreshCombatant(-1);

                    return resolve(r);
                    //return resolve(goods.$count);

                }(), 'equip']);
                //}(), Priority: -2, Type: 0, Running: 0, Tips: 'equip'});
            };

            let ret = $CommonLibJS.getPromise(_equip);
            //ret.$resolve = _resolve; ret.$reject = _reject;
            return ret;
        }

        //卸下某装备（所有个数）；
        //fighthero为下标，或战斗角色的name，或战斗角色对象；
        //positionName为部位名称；
        //params是给$useScript的自定义参数，默认功能是 回调函数 或 减去的数量（数字）；
        //返回：脚本的返回值（默认为旧装备或undefined）；false表示错误；null表示脚本不存在；
        //示例：yield unload(0, '部位');
        function unload(fighthero, positionName, params=-1) {
            //let _resolve, _reject;

            //！如果定义为生成器格式，则将 resolve 和 reject 删除即可（用return返回数据）；
            const _unload = function(resolve, reject) {
                //_resolve = resolve; _reject = reject;

                //game.run({Script: function*() {
                game.async([function*() { //效果和run一样，但使用async能更好的在async函数里使用；
                    if(fighthero >= 0 || $CommonLibJS.isString(fighthero) || $CommonLibJS.isObject(fighthero))
                        fighthero = game.fighthero(fighthero);
                    else
                        fighthero = null;
                    if(!fighthero)
                        return resolve(false);


                    if(!$CommonLibJS.isObject(fighthero.$equipment))
                        fighthero.$equipment = {};


                    let oldEquip = fighthero.$equipment[positionName];
                    if(!oldEquip)
                        return resolve(null);

                    let goodsInfo = GameSceneJS.getGoodsResource(oldEquip.$rid);
                    if(!goodsInfo) {
                        //scriptQueue.runNextEventLoop('unload');
                        //return reject(false);
                        return resolve(false);
                    }


                    let unloadScript;
                    if($CommonLibJS.checkCallable(unloadScript = goodsInfo.$commons.$unloadScript)) {
                    }
                    else if($CommonLibJS.checkCallable(unloadScript = _private.objCommonScripts.$commonUnloadScript)) {
                    }
                    else
                        return resolve(null);

                    let r = unloadScript.call(oldEquip, positionName, fighthero, params);
                    if($CommonLibJS.isGenerator(r))r = yield* r;

                    //计算新属性
                    //for(let fighthero of game.gd['$sys_fight_heros'])
                    _private.objCommonScripts.$refreshCombatant(fighthero);
                    //刷新战斗时人物数据
                    //fight.$sys.refreshCombatant(-1);

                    return resolve(r);

                }(), 'unload']);
                //}(), Priority: -2, Type: 0, Running: 0, Tips: 'unload'});
            };

            let ret = $CommonLibJS.getPromise(_unload);
            //ret.$resolve = _resolve; ret.$reject = _reject;
            return ret;
        }

        //返回某 fighthero 的 positionName 部位的 装备；如果positionName为null，则返回所有装备的数组；
        //fighthero为下标，或战斗角色的name，或战斗角色对象；
        //返回格式：全部装备的数组 或 某一个位置的装备；错误返回false。
        readonly property var equipment: function(fighthero, positionName=null) {
            if(fighthero >= 0 || $CommonLibJS.isString(fighthero) || $CommonLibJS.isObject(fighthero))
                fighthero = game.fighthero(fighthero);
            else
                fighthero = null;
            if(!fighthero)
                return false;


            if(!$CommonLibJS.isObject(fighthero.$equipment))
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
        //callback同命令msg的参数；回调函数的params为dialogTrade；
        //pauseGame同msg的参数；
        readonly property var trade: function(goods=[], mygoodsinclude=true, pauseGame=true, callback=true) {

            let ret = dialogTrade;

            //如果为true，则返回 组件，用户自己配置并调用show
            if(goods !== true) {
                /*if(callback === true || callback === 1)
                    //cb为默认回调函数，params为cb所需的参数，cb返回true表示有暂停；
                    callback = function(cb, ...params) {
                        if(cb(...params)) {
                            game.run(true);
                        }
                    }
                */

                //let _resolve, _reject;
                let _callback;
                //如果callback是自定义函数，则调用自定义函数，否则调用默认函数（cb）
                ret = $CommonLibJS.getPromise(function(resolve, reject) {
                    //_resolve = resolve; _reject = reject;
                    _callback = (cb, ...params)=>{
                        if($CommonLibJS.isFunction(callback))
                            callback(cb, ...params);
                        else
                            cb(...params);
                        resolve(params[0]);
                        //reject(params[0]);
                    };
                });
                //ret.$resolve = _resolve; ret.$reject = _reject;
                ret.$params = dialogTrade;

                dialogTrade.show(goods, mygoodsinclude, pauseGame, _callback);
            }

            return ret;

            //！如果定义为生成器的写法：
            //return yield ret;
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


        //创建定时器；
        //timerName：定时器名称；
        //interval：定时器间隔；times：触发次数（-1为无限）；
        //flags：从右到左，是否是全局定时器（否则地图定时器），是否在脚本队列里运行（否则在game.async）；
        //params：为自定义参数（回调时传入）；
        //成功返回true；如果已经有定时器则返回false；
        readonly property var addtimer: function(timerName, interval, times=1, flags=0b10, ...params) {
            //！！兼容旧代码
            if(flags === true)
                flags = 0b11;
            else if(flags === false)
                flags = 0b10;


            let objTimer;
            if(flags & 0b1)
                objTimer = _private.objGlobalTimers;
            else
                objTimer = _private.objTimers;

            if(objTimer[timerName] !== undefined)
                return false;

            //0：剩余时长（每帧减）；1：剩余次数（每次减）；2：flags；3：时长（备份）；4：回调参数；
            objTimer[timerName] = [interval, times, flags, interval, params];

            //game.gd['$sys_timer'][timerName] = {Name: timerName, Interval: interval, Times: times, Flags: flags, Params: params};

            return true;
        }

        //删除定时器；
        //flags：从右到左，是否是全局定时器（否则地图定时器）；
        //成功返回true；如果没有则返回false；
        readonly property var deltimer: function(timerName, flags=0b0) {
            //！！兼容旧代码
            if(flags === true)
                flags = 0b1;
            else if(flags === false)
                flags = 0b0;


            let objTimer;
            if(flags & 0b1)
                objTimer = _private.objGlobalTimers;
            else
                objTimer = _private.objTimers;

            //delete game.gd['$sys_timer'][timerName];

            if(objTimer[timerName] !== undefined) {
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
            if($CommonLibJS.isString(musicParams)) {
                musicParams = {RID: musicParams};
            }
            else if($CommonLibJS.isObject(musicParams)) {

            }
            else {
                return itemBackgroundMusic.play();
            }

            musicParams.$rid = musicParams.RID ?? musicParams.RId;


            let fileURL = GameMakerGlobal.musicResourceURL(musicParams.$rid);
            //if(!$Frame.sl_fileExists($GlobalJS.toPath(fileURL))) {
            //    console.warn('[!GameScene]video no exist：', video, fileURL)
            //    return false;
            //}

            //if(_private.objMusic[musicRID] === undefined)
            //    return false;

            //console.debug('~~~:', _private.objMusic[musicRID], GameMakerGlobal.musicResourceURL(_private.objMusic[musicRID]));
            //console.debug('~~~:', audioBackgroundMusic.source, audioBackgroundMusic.source.toString());

            const res = itemBackgroundMusic.play(fileURL, musicParams.$loops || Audio.Infinite);
            if(res) {
                itemBackgroundMusic.fStateCallback = musicParams.$stateCallback;
                //itemBackgroundMusic.fCallback = musicParams.$callback;
                game.gd['$sys_music'] = musicParams.$rid;
            }

            return res;
        }

        //停止音乐；
        readonly property var stopmusic: function() {
            itemBackgroundMusic.stop();
            itemBackgroundMusic.arrMusicStack = [];
        }

        //暂停音乐；
        //参数name为暂停名称；如果为true，表示引擎级关闭音乐；如果为false，表示存档级关闭音乐；
        function pausemusic(name='$user') {
            itemBackgroundMusic.pause(name);
        }

        //恢复播放音乐；
        //参数name为恢复名称；如果为true，表示引擎级恢复播放音乐；如果为false，表示存档级恢复播放音乐；如果为-1，打开全部强制恢复；
        function resumemusic(name='$user') {
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
            return audioBackgroundMusic.seek(offset);
        }
        //音乐音量大小；
        //volume为0~1的浮点数，如果非数字则不变；
        //返回当前音量大小；
        function musicvolume(volume=null) {
            if($CommonLibJS.isValidNumber(volume, 0b1))
                audioBackgroundMusic.volume = parseFloat(volume);

            return audioBackgroundMusic.volume;
        }

        //状态；
        readonly property var musicplaying: function() {
            return audioBackgroundMusic.isPlaying();
        }
        readonly property var musicpausing: function() {
            //return itemBackgroundMusic.objMusicPause[$name] !== undefined;
            if($CommonLibJS.objectIsEmpty(itemBackgroundMusic.objMusicPause) &&
                //!GameMakerGlobal.settings.value('$PauseMusic') &&
                (game.cd['$sys_sound'] & 0b1) &&
                (game.gd['$sys_sound'] & 0b1)
            )
                return false;

            return true;
        }


        //播放音效；
        //参数：channel为通道（目前0~9，-1为随机挑选没有播放的通道，如果没有则返回；-2为随机挑选没有播放的通道，如果没有则随机强制选择一个）；
        function playsoundeffect(soundeffectName, channel=-1, loops=1, forcePlay=false) {
            if(!forcePlay && game.soundeffectpausing())
                return -10;

            return rootSoundEffect.play(GameMakerGlobal.soundResourceURL(soundeffectName), channel, loops);
        }

        function stopsoundeffect(channel=-1) {
            return rootSoundEffect.stop(channel);
        }

        //暂停音效；
        //参数name为暂停名称；如果为true，表示引擎级关闭音效；如果为false，表示存档级关闭音效；
        function pausesoundeffect(name='$user') {
            rootSoundEffect.pause(name);
        }

        //恢复播放音效；
        //参数name为恢复名称；如果为true，表示引擎级恢复播放音效；如果为false，表示存档级恢复播放音效；如果为-1，打开全部强制恢复；
        function resumesoundeffect(name='$user') {
            rootSoundEffect.resume(name);
        }

        //音乐音量大小；
        //volume为0~1的浮点数，如果非数字则不变；
        //返回当前音量大小；
        function soundeffectvolume(volume=null) {
            if($CommonLibJS.isValidNumber(volume, 0b1))
                rootSoundEffect.rVolume = parseFloat(volume);

            return rootSoundEffect.rVolume;
        }

        readonly property var soundeffectpausing: function() {
            //return _private.config.nSoundConfig !== 0;
            if($CommonLibJS.objectIsEmpty(rootSoundEffect.objSoundEffectPause) &&
                //!GameMakerGlobal.settings.value('$PauseSound') &&
                (game.cd['$sys_sound'] & 0b10) &&
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
        //$callback同命令msg的参数；回调函数的params为code, itemVideo；
        readonly property var playvideo: function(videoParams, pauseGame=true) {
            let ret = videoOutput;

            if($CommonLibJS.isString(videoParams)) {
                videoParams = {RID: videoParams};
            }
            else if($CommonLibJS.isObject(videoParams)) {

            }
            else
                return ret;

            videoParams.$rid = videoParams.RID ?? videoParams.RId;

            itemVideo.fStateCallback = videoParams.$stateCallback;
            itemVideo.fCallback = videoParams.$callback;


            let fileURL = GameMakerGlobal.videoResourceURL(videoParams.$rid);
            //if(!$Frame.sl_fileExists($GlobalJS.toPath(fileURL))) {
            //    console.warn('[!GameScene]video no exist：', videoParams.$rid, fileURL)
            //    return false;
            //}

            //if(_private.objVideos[videoRID] === undefined)
            //    return false;

            if(!videoParams.$videoOutput)
                videoParams.$videoOutput = {};
            if(!videoParams.$mediaPlayer)
                videoParams.$mediaPlayer = {};


            if(videoParams.$videoOutput.$width === undefined && videoParams.$width === undefined)
                videoOutput.width = Qt.binding(function(){return videoOutput.implicitWidth});
            else if(videoParams.$width === -1)
                videoOutput.width = rootGameScene.width;
            else if($CommonLibJS.isValidNumber(videoParams.$width)) {
                videoOutput.width = videoParams.$width * $Global.pixelDensity;
            }

            if(videoParams.$videoOutput.$height === undefined && videoParams.$height === undefined)
                videoOutput.height = Qt.binding(function(){return videoOutput.implicitHeight});
            else if(videoParams.$height === -1)
                videoOutput.height = rootGameScene.height;
            else if($CommonLibJS.isValidNumber(videoParams.$height)) {
                videoOutput.height = videoParams.$height * $Global.pixelDensity;
            }


            mediaPlayer.source = fileURL;

            $CommonLibJS.copyPropertiesToObject(videoOutput, videoParams.$videoOutput, {onlyCopyExists: true});
            $CommonLibJS.copyPropertiesToObject(mediaPlayer, videoParams.$mediaPlayer, {onlyCopyExists: true});
            /*
            let tKeys = Object.keys(videoOutput);
            for(let tp in videoParams)
                if(tKeys.indexOf(tp) >= 0)
                    videoOutput[tp] = videoParams[tp];
            */

            itemVideo.pauseGame = pauseGame;
            itemVideo.play();



            const callback = itemVideo.fCallback;

            //let _resolve, _reject;
            let _callback;
            //如果callback是自定义函数，则调用自定义函数，否则调用默认函数（cb）
            ret = $CommonLibJS.getPromise(function(resolve, reject) {
                //_resolve = resolve; _reject = reject;
                _callback = (cb, ...params)=>{
                    if($CommonLibJS.isFunction(callback))
                        callback(cb, ...params);
                    else
                        cb(...params);
                    resolve(params[0]);
                    //reject(params[0]);
                };
            });
            //ret.$resolve = _resolve; ret.$reject = _reject;
            ret.$params = itemVideo;

            itemVideo.fCallback = _callback;


            return ret;

            //！如果定义为生成器的写法：
            //return yield ret;


            //itemViewPort.gameScene.color='#CCFFFFFF';
            //console.debug(itemViewPort.gameScene.color)
            //console.debug(itemViewPort.gameScene.color==='#ccffffff');
        }
        //结束播放；
        //code为-1表示释放退出；为0表示播放结束；为1表示用户退出；
        readonly property var stopvideo: function(code=1) {
            itemVideo.stop(code);
        }

        //显示图片；
        //imageParams为图片名或对象（包含RID）；
        //imageParams为对象：包含 Image组件 的所有属性 和 $x、$y、$width、$height、$parent、$collection、RID、$id 等属性；还包括 $pressed、$released、$clicked、$doubleClicked、$pressAndHold 事件的回调函数；
        //  x、y、width、height 和 $x、$y、$width、$height 是坐标和宽高，每组（带$和不带$）只需填一种；
        //    不带$表示按像素；
        //    带$的属性有以下几种格式：
        //      $x、$y：如果为数字，则表示坐标是按固定长度（厘米）为单位的长度（跨平台用）；
        //        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填x、y 和 $x、$y 作用相同；为2表示父组件的百分比；为3表示居中父组件后偏移多少像素，为4表示居中父组件后偏移多少固定长度，为5表示居中父组件后偏移多少父组件的百分比；为6、7、8表示右、下对其后偏移多少像素、固定长度、父组件百分比；为9表示使用虚拟坐标系；
        //      $width、$height：如果为数字，则表示按固定长度（厘米）为单位的长度（跨平台用）；
        //        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填width、height 和 $width、$height 作用 相同；为2表示父组件的多少倍；为3表示自身的多少倍；为4表示是 固定宽高比 的多少倍；
        //  $parent：0表示显示在屏幕上（默认）；1表示显示在视窗上；2表示显示在场景上（受scale影响）；3表示显示在地图上；4表示显示在地图地板层上；字符串表示显示在某个角色上；也可以是一个组件对象；
        //  $id为标识（用来控制、删除和重用）；
        //  $component：用户自己提供的组件，一般$parent也为组件时使用，由用户自己控制使用。
        readonly property var showimage: function(imageParams, id=undefined) { //id可以删掉，直接用$id
            if($CommonLibJS.isString(imageParams)) {
                imageParams = {RID: imageParams};
            }
            else if($CommonLibJS.isObject(imageParams)) {

            }
            else
                return false;

            imageParams.$rid = imageParams.RID ?? imageParams.RId;


            let fileURL = GameMakerGlobal.imageResourceURL(imageParams.$rid);
            //if(!$Frame.sl_fileExists($GlobalJS.toPath(fileURL))) {
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
            let collection;
            //屏幕上
            if(imageParams.$parent === 0 || imageParams.$parent === undefined) {
                parentComp = rootGameScene;
                collection = _private.objTmpComponents;
            }
            //游戏视窗
            else if(imageParams.$parent === 1) {
                parentComp = itemViewPort;
                collection = _private.objTmpComponents;
            }
            //会改变大小
            else if(imageParams.$parent === 2) {
                parentComp = itemViewPort.gameScene;
                collection = _private.objTmpComponents;
            }
            //会改变大小和随地图移动
            else if(imageParams.$parent === 3) {
                parentComp = itemViewPort.itemContainer;
                collection = _private.objTmpMapComponents;
            }
            //会改变大小和随地图移动
            else if(imageParams.$parent === 4) {
                parentComp = itemViewPort.itemRoleContainer;
                collection = _private.objTmpMapComponents;
            }
            //某角色上
            else if($CommonLibJS.isString(imageParams.$parent)) {
                let role = game.hero(imageParams.$parent);
                if(!role)
                    role = game.role(imageParams.$parent);
                if(role) {
                    parentComp = role;
                    collection = role.$tmpComponents;
                }
                else {
                    console.warn('[!GameScene]showimage:找不到parent:', imageParams.$parent);
                    //delimage(id);
                    return false;
                }
            }
            else if($CommonLibJS.isObject(imageParams.$parent)) {
                parentComp = imageParams.$parent;
                collection = parentComp.$tmpComponents; //不一定存在
            }
            //屏幕上
            else {
                parentComp = rootGameScene;
                collection = _private.objTmpComponents;

                //imageParams.$parent = 0;

                console.info('[GameScene]showimage:$parent参数不符，默认挂载在gameScene上');
            }
            collection = imageParams.$collection ?? collection;


            //if(id === undefined || id === null)
            id = id ?? imageParams.$id ?? imageParams.$rid;


            let tmp = imageParams.$component || $CommonLibJS.getObjectValue(collection, 'id') || compCacheImage.createObject(null);
            if(tmp && tmp.$componentType !== 1) {
                console.exception('[!GameScene]组件类型错误：', tmp, tmp.$componentType);
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

                if(collection)
                    collection[id] = tmp;
                tmp.$id = id;
                tmp.$collection = collection;
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
            else if($CommonLibJS.isArray(imageParams.$width)) {
                switch(imageParams.$width[1]) {
                //如果是 固定宽度
                case 1:
                    tmp.width = imageParams.$width[0] * $Global.pixelDensity;
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
                    tmp.width = Qt.binding(function(){return $vx(imageParams.$width[0])});
                    break;
                //按像素
                default:
                    tmp.width = imageParams.$width[0];
                }
            }
            else if($CommonLibJS.isValidNumber(imageParams.$width)) {
                tmp.width = imageParams.$width * $Global.pixelDensity;
            }

            //默认原高
            if(imageParams.$height === undefined && imageParams.height === undefined)
                tmp.height = tmp.implicitHeight;
            //父组件高
            else if(imageParams.$height === -1)
                tmp.height = Qt.binding(function(){return parentComp.height});
            else if($CommonLibJS.isArray(imageParams.$height)) {
                switch(imageParams.$height[1]) {
                //如果是 固定高度
                case 1:
                    tmp.height = imageParams.$height[0] * $Global.pixelDensity;
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
                    tmp.height = Qt.binding(function(){return $vy(imageParams.$height[0])});
                    break;
                //按像素
                default:
                    tmp.height = imageParams.$height[0];
                }
            }
            else if($CommonLibJS.isValidNumber(imageParams.$height)) {
                tmp.height = imageParams.$height * $Global.pixelDensity;
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
            else if($CommonLibJS.isArray(imageParams.$x)) {
                switch(imageParams.$x[1]) {
                //如果是 固定长度
                case 1:
                    tmp.x = imageParams.$x[0] * $Global.pixelDensity;
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
                    tmp.x = Qt.binding(function(){return imageParams.$x[0] * $Global.pixelDensity + (parentComp.width - tmp.width) / 2});
                    break;
                //如果是 居中偏移父组件的百分比
                case 5:
                    tmp.x = Qt.binding(function(){return imageParams.$x[0] * parentComp.width + (parentComp.width - tmp.width) / 2});
                    break;
                //如果是 右对齐偏移像素
                case 6:
                    tmp.x = Qt.binding(function(){return imageParams.$x[0] + (parentComp.width - tmp.width);});
                    break;
                //如果是 右对齐偏移固定长度
                case 7:
                    tmp.x = Qt.binding(function(){return imageParams.$x[0] * $Global.pixelDensity + (parentComp.width - tmp.width)});
                    break;
                //如果是 右对齐偏移父组件的百分比
                case 8:
                    tmp.x = Qt.binding(function(){return imageParams.$x[0] * parentComp.width + (parentComp.width - tmp.width)});
                    break;
                //跨平台x
                case 9:
                    tmp.x = Qt.binding(function(){return $vx(imageParams.$x[0])});
                    break;
                //按像素
                default:
                    tmp.x = imageParams.$x[0];
                }
            }
            else if($CommonLibJS.isValidNumber(imageParams.$x)) {
                tmp.x = imageParams.$x * $Global.pixelDensity;
            }

            //默认
            if(imageParams.$y === undefined && imageParams.y === undefined)
                tmp.y = 0;
            //居中
            else if(imageParams.$y === -1)
                tmp.y = Qt.binding(function(){return (parentComp.height - tmp.height) / 2});
                //tmp.y = (parentComp.height - tmp.height) / 2;
            else if($CommonLibJS.isArray(imageParams.$y)) {
                switch(imageParams.$y[1]) {
                //如果是 固定长度
                case 1:
                    tmp.y = imageParams.$y[0] * $Global.pixelDensity;
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
                    tmp.y = Qt.binding(function(){return imageParams.$y[0] * $Global.pixelDensity + (parentComp.height - tmp.height) / 2});
                    break;
                //如果是 居中偏移父组件的百分比
                case 5:
                    tmp.y = Qt.binding(function(){return imageParams.$y[0] * parentComp.height + (parentComp.height - tmp.height) / 2});
                    break;
                //如果是 下对齐偏移像素
                case 6:
                    tmp.y = Qt.binding(function(){return imageParams.$y[0] + (parentComp.height - tmp.height);});
                    break;
                //如果是 下对齐偏移固定长度
                case 7:
                    tmp.y = Qt.binding(function(){return imageParams.$y[0] * $Global.pixelDensity + (parentComp.height - tmp.height)});
                    break;
                //如果是 下对齐偏移父组件的百分比
                case 8:
                    tmp.y = Qt.binding(function(){return imageParams.$y[0] * parentComp.height + (parentComp.height - tmp.height)});
                    break;
                //跨平台y
                case 9:
                    tmp.y = Qt.binding(function(){return $vy(imageParams.$y[0])});
                    break;
                //按像素
                default:
                    tmp.y = imageParams.$y[0];
                }
            }
            else if($CommonLibJS.isValidNumber(imageParams.$y)) {
                tmp.y = imageParams.$y * $Global.pixelDensity;
            }


            if(imageParams.$clicked === null)
                tmp.clicked = function(image){game.delimage(image)};
            else// if(imageParams.$clicked !== undefined)
                tmp.clicked = imageParams.$clicked;

            if(imageParams.$doubleClicked === null)
                tmp.doubleClicked = function(image){game.delimage(image)};
            else// if(imageParams.$doubleClicked !== undefined)
                tmp.doubleClicked = imageParams.$doubleClicked;

            tmp.pressed = imageParams.$pressed;
            tmp.released = imageParams.$released;
            tmp.pressAndHold = imageParams.$pressAndHold;



            if(imageParams.$visible === undefined)
                imageParams.visible = true;
            else
                imageParams.visible = imageParams.$visible;



            $CommonLibJS.copyPropertiesToObject(tmp, imageParams, {onlyCopyExists: true, objectRecursion: 0});


            return tmp;
        }
        //删除图片；
        //idParams：-1：屏幕上的全部图片组件（包含图片和特效等）；数字：屏幕上的图片标识；字符串：角色上的图片标识；对象：包含$id（-1表示全部图片组件）和$parent属性（同showimage）；
        readonly property var delimage: function(idParams=-1) {
            let parent;
            let collection;
            let tmpImage;

            if($CommonLibJS.isNumber(idParams)) {
                idParams = {$id: idParams};
            }
            else if($CommonLibJS.isString(idParams)) {
                idParams = {$id: idParams};
            }
            else if($CommonLibJS.isObject(idParams)) {
                if($CommonLibJS.isQtObject(idParams)) {
                    tmpImage = idParams;
                    parent = null;
                }
                else
                    parent = idParams.$parent;
            }
            else
                return false;


            //屏幕上
            if(parent === 0 || parent === undefined) {
                //parent = rootGameScene;

                collection = _private.objTmpComponents;
            }
            //游戏视窗
            else if(parent === 1) {
                //parent = itemViewPort;

                collection = _private.objTmpComponents;
            }
            //会改变大小
            else if(parent === 2) {
                //parent = itemViewPort.gameScene;

                collection = _private.objTmpComponents;
            }
            //会改变大小和随地图移动
            else if(parent === 3) {
                //parent = itemViewPort.itemContainer;

                collection = _private.objTmpMapComponents;
            }
            //会改变大小和随地图移动
            else if(parent === 4) {
                //parent = itemViewPort.itemRoleContainer;

                collection = _private.objTmpMapComponents;
            }
            //某角色上
            else if($CommonLibJS.isString(parent)) {
                let role = game.hero(parent);
                if(!role)
                    role = game.role(parent);
                if(role) {
                    //parent = role;

                    collection = role.$tmpComponents;
                }
                else
                    return false;
            }
            else if($CommonLibJS.isObject(parent)) {
                collection = parent.$tmpComponents; //不一定存在
            }
            else if(parent === null)
                ;
            else {
                collection = _private.objTmpComponents;

                console.info('[!GameScene]delimage:$parent参数不符');
            }
            collection = idParams.$collection ?? collection;
            tmpImage = tmpImage ?? collection[idParams.$id];

            //console.debug('[GameScene]测试:', tmpImage, idParams.$id, collection, idParams.$collection);

            //删除所有
            if(idParams.$id === -1 && collection) {
                for(let ti in collection) {
                    if(collection[ti].$componentType === 1) {
                        //自定义 释放函数
                        (collection[ti].$destroy ?? collection[ti].Destroy ?? collection[ti].destroy)();
                        delete collection[ti];
                    }
                }

                return true;
            }


            if(tmpImage && tmpImage.$componentType === 1) {
                (tmpImage.$destroy ?? tmpImage.Destroy ?? tmpImage.destroy)();

                if(collection)
                    if(idParams.$id !== undefined && idParams.$id !== null && collection[idParams.$id]) {
                        delete collection[idParams.$id];
                        //console.debug('[GameScene]delimage:成功:', idParams.$id);
                    }
                    else
                        console.warn('[!GameScene]delimage:父组件中找不到:', idParams.$id, collection, idParams, idParams.$collection);

                return true;
            }
            else
                console.warn('[!GameScene]delimage:找不到:', idParams.$id);

            return false;
        }

        //显示特效；
        //spriteParams为特效名或对象（包含RID）；
        //spriteParams为对象：包含 SpriteEffect组件 的所有属性、$x、$y、$width、$height、$parent、$collection、RID、$id 等属性；还包括 $pressed、$released、$clicked、$doubleClicked、$pressAndHold、$looped、$finished 事件的回调函数；
        //  x、y、width、height 和 $x、$y、$width、$height 是坐标和宽高，每组（带$和不带$）只需填一种；
        //    不带$表示按像素；
        //    带$的属性有以下几种格式：
        //      $x、$y：如果为数字，则表示坐标是按固定长度（厘米）为单位的长度（跨平台用）；
        //        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填x、y 和 $x、$y 作用相同；为2表示父组件的百分比；为3表示居中父组件后偏移多少像素，为4表示居中父组件后偏移多少固定长度，为5表示居中父组件后偏移多少父组件的百分比；为6、7、8表示右、下对其后偏移多少像素、固定长度、父组件百分比；为9表示使用虚拟坐标系；
        //      $width、$height：如果为数字，则表示按固定长度（厘米）为单位的长度（跨平台用）；
        //        如果为 数组[n, t]，则n表示值，t表示类型：t为0、1分别和直接填width、height 和 $width、$height 作用 相同；为2表示父组件的多少倍；为3表示自身的多少倍；为4表示是 固定宽高比 的多少倍；
        //  $parent：0表示显示在屏幕上（默认）；1表示显示在视窗上；2表示显示在场景上（受scale影响）；3表示显示在地图上；4表示显示在地图地板层上；字符串表示显示在某个角色上；也可以是一个组件对象；
        //  $id为标识（用来控制、删除和重用）；
        //  $component：用户自己提供的组件，一般$parent也为组件时使用，由用户自己控制使用。
        readonly property var showsprite: function(spriteParams, id=undefined) { //id可以删掉，直接用$id
            if($CommonLibJS.isString(spriteParams)) {
                spriteParams = {RID: spriteParams};
            }
            else if($CommonLibJS.isObject(spriteParams)) {

            }
            else
                return false;

            spriteParams.$rid = spriteParams.RID ?? spriteParams.RId;


            //let fileURL = GameMakerGlobal.imageResourceURL(spriteParams.$rid);
            //if(!$Frame.sl_fileExists($GlobalJS.toPath(fileURL))) {
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
            let collection;
            //屏幕上
            if(spriteParams.$parent === 0 || spriteParams.$parent === undefined) {
                parentComp = rootGameScene;
                collection = _private.objTmpComponents;
            }
            //游戏视窗
            else if(spriteParams.$parent === 1) {
                parentComp = itemViewPort;
                collection = _private.objTmpComponents;
            }
            //会改变大小
            else if(spriteParams.$parent === 2) {
                parentComp = itemViewPort.gameScene;
                collection = _private.objTmpComponents;
            }
            //会改变大小和随地图移动
            else if(spriteParams.$parent === 3) {
                parentComp = itemViewPort.itemContainer;
                collection = _private.objTmpMapComponents;
            }
            //会改变大小和随地图移动
            else if(spriteParams.$parent === 4) {
                parentComp = itemViewPort.itemRoleContainer;
                collection = _private.objTmpMapComponents;
            }
            //某角色上
            else if($CommonLibJS.isString(spriteParams.$parent)) {
                let role = game.hero(spriteParams.$parent);
                if(!role)
                    role = game.role(spriteParams.$parent);
                if(role) {
                    parentComp = role;
                    collection = role.$tmpComponents;
                }
                else {
                    console.warn('[!GameScene]showsprite:找不到parent:', spriteParams.$parent);
                    //delsprite(id);
                    return false;
                }
            }
            else if($CommonLibJS.isObject(spriteParams.$parent)) {
                parentComp = spriteParams.$parent;
                collection = parentComp.$tmpComponents; //不一定存在
            }
            //屏幕上
            else {
                parentComp = rootGameScene;
                collection = _private.objTmpComponents;

                //spriteParams.$parent = 0;

                console.info('[GameScene]showsprite:$parent参数不符，默认挂载在gameScene上');
            }
            collection = spriteParams.$collection ?? collection;


            //if(id === undefined || id === null)
            id = id ?? spriteParams.$id ?? spriteParams.$rid;


            let spriteInfo = GameSceneJS.getSpriteResource(spriteParams.$rid);
            let sprite = spriteParams.$component || $CommonLibJS.getObjectValue(collection, 'id') || compCacheSpriteEffect.createObject(null);
            if(sprite && sprite.$componentType !== 2) {
                console.exception('[!GameScene]组件类型错误：', sprite.$componentType);
                return false;
            }
            //刷新特效属性
            sprite = GameSceneJS.getSpriteEffect(spriteInfo, sprite, spriteParams, null);
            if(sprite === null)
                return false;

            sprite.visible = false;
            if(collection)
                collection[id] = sprite;
            sprite.$id = id;
            sprite.$collection = collection;


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
            else if($CommonLibJS.isArray(spriteParams.$width)) {
                switch(spriteParams.$width[1]) {
                //如果是 固定宽度
                case 1:
                    sprite.width = spriteParams.$width[0] * $Global.pixelDensity;
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
                    sprite.width = Qt.binding(function(){return $vx(spriteParams.$width[0])});
                    break;
                //按像素
                default:
                    sprite.width = spriteParams.$width[0];
                }
            }
            else if($CommonLibJS.isValidNumber(spriteParams.$width)) {
                sprite.width = spriteParams.$width * $Global.pixelDensity;
            }

            //默认原高
            if(spriteParams.$height === undefined && spriteParams.height === undefined)
                sprite.height = spriteInfo.SpriteSize[1]/*sprite.implicitHeight*/;
            //组件高
            else if(spriteParams.$height === -1)
                sprite.height = Qt.binding(function(){return parentComp.height});
                //sprite.height = spriteInfo.SpriteSize[1];
            else if($CommonLibJS.isArray(spriteParams.$height)) {
                switch(spriteParams.$height[1]) {
                //如果是 固定高度
                case 1:
                    sprite.height = spriteParams.$height[0] * $Global.pixelDensity;
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
                    sprite.height = Qt.binding(function(){return $vy(spriteParams.$height[0])});
                    break;
                //按像素
                default:
                    sprite.height = spriteParams.$height[0];
                }
            }
            else if($CommonLibJS.isValidNumber(spriteParams.$height)) {
                sprite.height = spriteParams.$height * $Global.pixelDensity;
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
            else if($CommonLibJS.isArray(spriteParams.$x)) {
                switch(spriteParams.$x[1]) {
                //如果是 固定长度
                case 1:
                    sprite.x = spriteParams.$x[0] * $Global.pixelDensity;
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
                    sprite.x = Qt.binding(function(){return spriteParams.$x[0] * $Global.pixelDensity + (parentComp.width - sprite.width) / 2});
                    break;
                //如果是 居中偏移父组件的百分比
                case 5:
                    sprite.x = Qt.binding(function(){return spriteParams.$x[0] * parentComp.width + (parentComp.width - sprite.width) / 2});
                    break;
                //如果是 右对齐偏移像素
                case 6:
                    sprite.x = Qt.binding(function(){return spriteParams.$x[0] + (parentComp.width - sprite.width);});
                    break;
                //如果是 右对齐偏移固定长度
                case 7:
                    sprite.x = Qt.binding(function(){return spriteParams.$x[0] * $Global.pixelDensity + (parentComp.width - sprite.width)});
                    break;
                //如果是 右对齐偏移父组件的百分比
                case 8:
                    sprite.x = Qt.binding(function(){return spriteParams.$x[0] * parentComp.width + (parentComp.width - sprite.width)});
                    break;
                //跨平台x
                case 9:
                    sprite.x = Qt.binding(function(){return $vx(spriteParams.$x[0])});
                    break;
                //按像素
                default:
                    sprite.x = spriteParams.$x[0];
                }
            }
            else if($CommonLibJS.isValidNumber(spriteParams.$x)) {
                sprite.x = spriteParams.$x * $Global.pixelDensity;
            }

            //默认
            if(spriteParams.$y === undefined && spriteParams.y === undefined)
                sprite.y = 0;
            //居中
            else if(spriteParams.$y === -1)
                sprite.y = Qt.binding(function(){return (parentComp.height - sprite.height) / 2});
                //sprite.y = (parentComp.height - sprite.height) / 2;
            else if($CommonLibJS.isArray(spriteParams.$y)) {
                switch(spriteParams.$y[1]) {
                //如果是 固定长度
                case 1:
                    sprite.y = spriteParams.$y[0] * $Global.pixelDensity;
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
                    sprite.y = Qt.binding(function(){return spriteParams.$y[0] * $Global.pixelDensity + (parentComp.height - sprite.height) / 2});
                    break;
                //如果是 居中偏移父组件的百分比
                case 5:
                    sprite.y = Qt.binding(function(){return spriteParams.$y[0] * parentComp.height + (parentComp.height - sprite.height) / 2});
                    break;
                //如果是 下对齐偏移像素
                case 6:
                    sprite.y = Qt.binding(function(){return spriteParams.$y[0] + (parentComp.height - sprite.height);});
                    break;
                //如果是 下对齐偏移固定长度
                case 7:
                    sprite.y = Qt.binding(function(){return spriteParams.$y[0] * $Global.pixelDensity + (parentComp.height - sprite.height)});
                    break;
                //如果是 下对齐偏移父组件的百分比
                case 8:
                    sprite.y = Qt.binding(function(){return spriteParams.$y[0] * parentComp.height + (parentComp.height - sprite.height)});
                    break;
                //跨平台y
                case 9:
                    sprite.y = Qt.binding(function(){return $vy(spriteParams.$y[0])});
                    break;
                //按像素
                default:
                    sprite.y = spriteParams.$y[0];
                }
            }
            else if($CommonLibJS.isValidNumber(spriteParams.$y)) {
                sprite.y = spriteParams.$y * $Global.pixelDensity;
            }


            if(spriteParams.$clicked === null)
                sprite.clicked = function(sprite){game.delsprite(sprite)};
            else// if(spriteParams.$clicked !== undefined)
                sprite.clicked = spriteParams.$clicked;

            if(spriteParams.$doubleClicked === null)
                sprite.doubleClicked = function(sprite){game.delsprite(sprite)};
            else// if(spriteParams.$doubleClicked !== undefined)
                sprite.doubleClicked = spriteParams.$doubleClicked;

            sprite.pressed = spriteParams.$pressed;
            sprite.released = spriteParams.$released;
            sprite.pressAndHold = spriteParams.$pressAndHold;


            if(spriteParams.$looped === null)
                //sprite.looped = function(sprite){game.delsprite(sprite)};
                sprite.looped = null;
            else// if(spriteParams.$looped !== undefined)
                sprite.looped = spriteParams.$looped;

            if(spriteParams.$finished === null)
                //sprite.finished = function(sprite){game.delsprite(sprite)};
                sprite.finished = null;
            else// if(spriteParams.$finished !== undefined)
                sprite.finished = spriteParams.$finished;



            if(spriteParams.$visible === undefined)
                spriteParams.visible = true;
            else
                spriteParams.visible = spriteParams.$visible;



            $CommonLibJS.copyPropertiesToObject(sprite, spriteParams, {onlyCopyExists: true, objectRecursion: 0});
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
            let parent;
            let collection;
            let tmpSprites;

            if($CommonLibJS.isNumber(idParams)) {
                idParams = {$id: idParams};
            }
            else if($CommonLibJS.isString(idParams)) {
                idParams = {$id: idParams};
            }
            else if($CommonLibJS.isObject(idParams)) {
                if($CommonLibJS.isQtObject(idParams)) {
                    tmpSprites = idParams;
                    parent = null;
                }
                else
                    parent = idParams.$parent;
            }
            else
                return false;


            //屏幕上
            if(parent === 0 || parent === undefined) {
                //parent = rootGameScene;

                collection = _private.objTmpComponents;
            }
            //游戏视窗
            else if(parent === 1) {
                //parent = itemViewPort;

                collection = _private.objTmpComponents;
            }
            //会改变大小
            else if(parent === 2) {
                //parent = itemViewPort.gameScene;

                collection = _private.objTmpComponents;
            }
            //会改变大小和随地图移动
            else if(parent === 3) {
                //parent = itemViewPort.itemContainer;

                collection = _private.objTmpMapComponents;
            }
            //会改变大小和随地图移动
            else if(parent === 4) {
                //parent = itemViewPort.itemContainer;

                collection = _private.objTmpMapComponents;
            }
            //某角色上
            else if($CommonLibJS.isString(parent)) {
                let role = game.hero(parent);
                if(!role)
                    role = game.role(parent);
                if(role) {
                    //parent = role;

                    collection = role.$tmpComponents;
                }
                else
                    return false;
            }
            else if($CommonLibJS.isObject(parent)) {
                collection = parent.$tmpComponents; //不一定存在
            }
            else if(parent === null)
                ;
            else {
                collection = _private.objTmpComponents;

                console.info('[!GameScene]delsprite:$parent参数不符');
            }
            collection = idParams.$collection ?? collection;
            tmpSprites = tmpSprites ?? collection[idParams.$id];

            //console.debug('[GameScene]测试:', tmpSprites, idParams.$id, collection, idParams.$collection);

            //删除所有
            if(idParams.$id === -1 && collection) {
                for(let ti in collection) {
                    if(collection[ti].$componentType === 2) {
                        //自定义 释放函数
                        (collection[ti].$destroy ?? collection[ti].Destroy ?? collection[ti].destroy)();
                        delete collection[ti];
                    }
                }

                return true;
            }


            if(tmpSprites && tmpSprites.$componentType === 2) {
                (tmpSprites.$destroy ?? tmpSprites.Destroy ?? tmpSprites.destroy)();

                //_private.cacheSprites.put(tmpSprites);
                if(collection)
                    if(idParams.$id !== undefined && idParams.$id !== null && collection[idParams.$id]) {
                        delete collection[idParams.$id];
                        //console.debug('[GameScene]delsprite:成功:', idParams.$id);
                    }
                    else
                        console.warn('[!GameScene]delsprite:父组件中找不到:', idParams.$id, collection, idParams, idParams.$collection);

                return true;
            }
            else
                console.warn('[!GameScene]delsprite:找不到:', idParams.$id);

            return false;
        }


        //设置操作（遥感可用和可见、键盘可用）；
        //参数$gamepad的$visible和$enabled，$keyboard的$enabled；
        //  也可以是 二进制数字
        //参数为空则返回遥感组件，可自定义；
        readonly property var control: function(config={}) {
            if(!config)
                return itemGamePad;

            if(config && config.$gamepad !== undefined) {
                if($CommonLibJS.isNumber(config.$gamepad)) {
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
                if($CommonLibJS.isNumber(config.$keyboard)) {
                    _private.config.bKeyboard = config.$keyboard & 0b1;
                }
                else if(config.$keyboard.$enabled !== undefined)
                    _private.config.bKeyboard = config.$keyboard.$enabled;
            }
        }

        //将场景缩放n倍；可以是小数。
        readonly property var scale: function(n) {
            if($CommonLibJS.isValidNumber(n)) {
                game.gd['$sys_scale'] = itemViewPort.gameScene.scale = parseFloat(n);
                setSceneToRole();
            }
            return game.gd['$sys_scale'];
        }

        //场景跟随某个角色 或 自由移动
        //r为字符串表示跟随角色；为数字，则表示进入自由移动地图模式且设置为速度
        readonly property var setscenerole: function(r=0.2) {
            let role;

            if($CommonLibJS.isString(r)) {
                role = game.hero(r);
                if(!role)
                    role = game.role(r);
                if(!role)
                    return false;

                _private.sceneRole = role;
                setSceneToRole();
            }
            else if($CommonLibJS.isObject(r)) {
                _private.sceneRole = r;
                setSceneToRole();
            }
            else if($CommonLibJS.isNumber(r)) {
                _private.sceneRole = null;
                _private.config.rSceneMoveSpeed = r;
            }
            else
                _private.sceneRole = null;
        }

        //暂停游戏。
        readonly property var pause: function(name='$user_pause', times=1) {
            if(name === false || name === null)
                return !$CommonLibJS.objectIsEmpty(_private.config.objPauseNames);
            if(name === true)
                return _private.config.objPauseNames;

            //战斗模式不能设置
            //if(_private.nStatus === 1)
            //    return;

            timer.stop();
            _private.stopMove(0);

            //暂停所有人物动作
            for(let tr in _private.arrMainRoles) {
                const role = _private.arrMainRoles[tr];
                if(role.$props.$$running_backup === undefined) {
                    role.$props.$$running_backup = role.sprite.sprite.bRunning;
                    role.sprite.sprite.bRunning = false;
                }
            }
            for(let tr in _private.objRoles) {
                const role = _private.objRoles[tr];
                if(role.$props.$$running_backup === undefined) {
                    role.$props.$$running_backup = role.sprite.sprite.bRunning;
                    role.sprite.sprite.bRunning = false;
                }
            }

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
            //if(_private.nStatus === 1)
            //    return;


            if(name === true) {
                _private.config.objPauseNames = {};
            }
            else if(name === false || name === null)
                return $CommonLibJS.objectIsEmpty(_private.config.objPauseNames);
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


            if($CommonLibJS.objectIsEmpty(_private.config.objPauseNames)) {
                timer.start();
                //_private.config.bPauseGame = false;

                //恢复所有人物动作
                for(let tr in _private.arrMainRoles) {
                    const role = _private.arrMainRoles[tr];
                    if(role.$props.$$running_backup !== undefined) {
                        role.sprite.sprite.bRunning = role.$props.$$running_backup;
                        delete role.$props.$$running_backup;
                    }
                }
                for(let tr in _private.objRoles) {
                    const role = _private.objRoles[tr];
                    if(role.$props.$$running_backup !== undefined) {
                        role.sprite.sprite.bRunning = role.$props.$$running_backup;
                        delete role.$props.$$running_backup;
                    }
                }
            }

            //joystick.enabled = true;
            //buttonA.enabled = true;

            //rootGameScene.forceActiveFocus();
        }

        //设置游戏刷新率（interval毫秒）。
        readonly property var interval: function(interval=16) {
            if($CommonLibJS.isValidNumber(interval)) {
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

            /*if(callback === true || callback === 1)
                _private.scriptQueue.wait(ms);
            else if(callback === 0)
                return $CommonLibJS.asyncSleep(ms);
            */
            return $CommonLibJS.asyncSleep(ms, itemWaitTimers);

            //！如果定义为生成器的写法：
            //return yield ret;
        }

        //返回start~end之间的随机整数（包含start，不包含end）。
        readonly property var rnd: function(start, end) {
            return $CommonLibJS.random(start, end);
        }

        //显示窗口；
        //params：
        //  $id：0b1为主菜单；0b10为战斗人物信息；0b100为道具信息；0b1000为系统菜单；
        //  $visible：为false表示关闭窗口；
        //  $value：战斗人物信息（0b10）时为下标；
        //style：样式，包括MaskColor、BorderColor、BackgroundColor、ItemFontSize、ItemFontColor、ItemBackgroundColor1、ItemBackgroundColor2、TitleFontSize、TitleBackgroundColor、TitleFontColor、ItemBorderColor；
        //pauseGame同msg的参数；
        //callback同命令msg的参数；回调函数的params为gameMenuWindow；
        readonly property var window: function(params=null, style={}, pauseGame=true, callback=true) {
            if($CommonLibJS.isValidNumber(params))
                params = {$id: params, $visible: true};
            else if(!params) {
                params = {$id: 0b1111, $visible: true};
            }


            let ret = gameMenuWindow;

            //显示
            if(params.$visible !== false) {
                /*if(callback === true || callback === 1)
                    //cb为默认回调函数，params为cb所需的参数，cb返回true表示有暂停；
                    callback = function(cb, ...params) {
                        if(cb(...params)) {
                            game.run(true);
                        }
                    }
                */

                //let _resolve, _reject;
                let _callback;
                //如果callback是自定义函数，则调用自定义函数，否则调用默认函数（cb）
                ret = $CommonLibJS.getPromise(function(resolve, reject) {
                    //_resolve = resolve; _reject = reject;
                    _callback = (cb, ...params)=>{
                        if($CommonLibJS.isFunction(callback))
                            callback(cb, ...params);
                        else
                            cb(...params);
                        resolve(params[0]);
                        //reject(params[0]);
                    };
                });
                //ret.$resolve = _resolve; ret.$reject = _reject;
                ret.$params = gameMenuWindow;

                gameMenuWindow.show(params.$id, params.$value, style, pauseGame, _callback);
            }
            else
                gameMenuWindow.closeWindow(params.$id);


            return ret;

            //！如果定义为生成器的写法：
            //return yield ret;
        }

        //检测存档是否存在 且 验证是否正确；
        //data为字符串（本地存档文件路径）或存档数据（对象，此时仅验证和解压Data字段）；
        //失败返回false；成功返回 存档对象（包含Name和解压后的Data）。
        readonly property var checksave: function(data) {
            if($CommonLibJS.isString(data)) {
                data = data.trim();
                let filePath = $GlobalJS.toPath(GameMakerGlobal.config.strSaveDataPath + data + '.json');
                if(!$Frame.sl_fileExists(filePath))
                    return false;

                data = $Frame.sl_fileRead(filePath);
                //let cfg = File.read(filePath);
                //console.debug('musicInfo', filePath, musicInfo)
                //console.debug('cfg', cfg, filePath);

                if(data) {
                    try {
                        data = JSON.parse(data);
                    }
                    catch(e) {
                        console.warn('[!GameScene]checksave:', data, data.$$type, e);
                        return false;
                    }
                }
            }
            else if($CommonLibJS.isObject(data)) {
            }
            else {
                return false;
            }

            if(data) {

                //压缩
                if(data.Type === 1) {
                    //debug下不检测存档
                    if(GameMakerGlobal.config.bDebug === false && data.Verify !== Qt.md5(_private.config.strSaveDataSalt + data.Data)) {
                        return false;
                    }
                    try {
                        data.Data = JSON.parse($Frame.sl_uncompress(data.Data, 1).toString());
                    }
                    catch(e) {
                        return false;
                    }

                    //兼容旧存档！！！
                    if(data.Data['$sys_map'].$rid === undefined && data.Data['$sys_map'].$name !== undefined) {
                        data.Data['$sys_map'].$rid = data.Data['$sys_map'].$name;
                        delete data.Data['$sys_map'].$name;
                    }

                    return data;
                }
                else {
                    //debug下不检测存档
                    if(GameMakerGlobal.config.bDebug === false && data.Verify !== Qt.md5(_private.config.strSaveDataSalt + JSON.stringify(data.Data))) {
                        return false;
                    }

                    //兼容旧存档！！！
                    if(data.Data['$sys_map'].$rid === undefined && data.Data['$sys_map'].$name !== undefined) {
                        data.Data['$sys_map'].$rid = data.Data['$sys_map'].$name;
                        delete data.Data['$sys_map'].$name;
                    }

                    return data;
                }
            }
            return false;
        }

        //存档（将game.gd存为 文件，开头为 $$ 的键不会保存；同时保存 引擎变量）
        //fileName为字符串（本地存档文件路径）或true（返回存档字符串数据）；
        //showName为显示名；
        //compressionLevel为压缩级别（1-9，-1为默认，0为不压缩）；
        //成功返回 存档序列化字符串，失败返回false；
        //game.async(function*(){game.save('存档3')})
        readonly property var save: function(fileName='autosave', showName='', compressionLevel=-1) {
            //scriptQueue.runNextEventLoop('save');

            //let _resolve, _reject;

            //！如果定义为生成器格式，则将 resolve 和 reject 删除即可（用return返回数据）；
            const _save = function(resolve, reject) {
                //_resolve = resolve; _reject = reject;

                //game.run({Script: function*() {
                game.async([function*() { //效果和run一样，但使用async能更好的在async函数里使用；

                    if($CommonLibJS.isString(fileName)) {
                        fileName = fileName.trim();
                        if(!fileName)
                            fileName = 'autosave';
                    }
                    else if(fileName === true) {

                    }
                    else
                        return resolve(false);



                    //game.run({Script: function*() {
                    //载入beforeSave脚本
                    if(_private.objCommonScripts.$beforeSave) { //$CommonLibJS.checkCallable
                        let r = _private.objCommonScripts.$beforeSave();
                        if($CommonLibJS.isGenerator(r))r = yield* r;
                        //game.run({Script: _private.objCommonScripts.$beforeSave() ?? null, Priority: -3, Type: 0, Running: 1, Tips: '$beforeSave'});
                    }



                    const outputData = {};
                    let fileData;

                    //过滤掉 $$ 开头的所有键
                    const fSaveFilter = function(k, v) {
                        if(k.trim().startsWith('$$'))
                            return undefined;
                        return v;
                    }

                    outputData.Version = '0.6';
                    outputData.Name = showName;
                    outputData.Type = compressionLevel === 0 ? 0 : 1;
                    outputData.Time = $CommonLibJS.formatDate('YYYY-mm-dd HH:MM:SS'); //'YYYY-mm-dd HH:MM:SS sss'
                    if(compressionLevel !== 0) {    //压缩
                        const GlobalDataString = JSON.stringify(game.gd, fSaveFilter);
                        outputData.Data = $Frame.sl_compress(GlobalDataString, compressionLevel, 1).toString();
                        outputData.Verify = Qt.md5(_private.config.strSaveDataSalt + outputData.Data);
                        fileData = JSON.stringify(outputData, fSaveFilter);
                    }
                    else {
                        const GlobalDataString = JSON.stringify(game.gd, fSaveFilter);
                        outputData.Data = game.gd;
                        outputData.Verify = Qt.md5(_private.config.strSaveDataSalt + GlobalDataString);
                        fileData = JSON.stringify(outputData, fSaveFilter);
                    }


                    let ret;
                    if($CommonLibJS.isString(fileName)) {
                        const filePath = GameMakerGlobal.config.strSaveDataPath + fileName + '.json';

                        //!!!导出为文件
                        //console.debug(JSON.stringify(outputData));
                        //let ret = File.write(path + GameMakerGlobal.separator + 'map.json', JSON.stringify(outputData));
                        ret = $Frame.sl_fileWrite(fileData, $GlobalJS.toPath(filePath), 0);
                        //console.debug(itemViewPort.itemContainer.arrCanvasMap[2].toDataURL())
                        if(ret < 0) {
                            console.warn('[!GameScene]save ERROR:', fileName, ret);
                            return resolve(false);
                        }
                        ret = fileData;
                    }
                    else if(fileName === true) {
                        ret = fileData;
                    }
                    else
                        return resolve(false);


                    //写入引擎变量
                    //GameMakerGlobal.settings.setValue('Projects/' + GameMakerGlobal.config.strCurrentProjectName, game.cd);



                    //载入afterSave脚本
                    if(_private.objCommonScripts.$afterSave) { //$CommonLibJS.checkCallable
                        let r = _private.objCommonScripts.$afterSave(ret);
                        if($CommonLibJS.isGenerator(r))r = yield* r;
                        //game.run({Script: _private.objCommonScripts.$afterSave() ?? null, Priority: -1, Type: 0, Running: 1, Tips: '$afterSave'});
                    }


                    return resolve(ret);

                    //}(), Priority: -2, Type: 0, Running: 1, Tips: 'save'});
                    //return true;

                }(), 'save']);
                //}(), Priority: -2, Type: 0, Running: 0, Tips: 'save'});
            };

            const ret = $CommonLibJS.getPromise(_save);
            //ret.$resolve = _resolve; ret.$reject = _reject;
            return ret;
        }

        //读档（读取数据到 game.gd）；
        //data为字符串（本地存档文件路径）或对象；
        //成功返回true（生成器返回true），失败返回false。
        readonly property var load: function(data='autosave') {
            //let _resolve, _reject;

            //执行顺序：game.run(game.load())->load()->new Promise(_load)->_load()->$CommonLibJS.asyncScript()的函数（因为是生成器，所以直接进入运行）->...->release()->game.run()（将init等代码放入队列第一个）->resolve(true)->进入game.run()执行队列第一个脚本（也就是init等代码）运行完毕->队列第二个脚本继续（game.run(game.load())下一条指令）。。。
            //！如果定义为生成器格式，则将 resolve 和 reject 删除即可（用return返回数据）；
            const _load = function(resolve, reject) {
                //_resolve = resolve; _reject = reject;

                //用asyncScript的原因是：release需要清空scriptQueue 和 $asyncScript，可能会导致下面脚本执行时中断而导致没有执行完毕；
                $CommonLibJS.asyncScript([function*() {
                //game.run({Script: function*() {
                //game.async([function*() { //效果和run一样，但使用async能更好的在async函数里使用；

                    if($CommonLibJS.isString(data)) {
                        data = data.trim();
                        if(!data)
                            data = 'autosave';
                    }
                    else if($CommonLibJS.isObject(data)) { //如果是参数对象
                    }
                    else
                        return resolve(false);


                    let ret = checksave(data);
                    if(!ret) {
                        //scriptQueue.runNextEventLoop('game.load');
                        return resolve(false);
                    }


                    //！！！鹰：注意：load是异步调用；且将 Priority 设置为顺序的（保证 game.load 的所有异步脚本执行完毕 再执行 game.load 的下一个命令）
                    //let priority = 0;


                    //game.run({Script: function*() {

                    //载入beforeLoad脚本
                    if(_private.objCommonScripts.$beforeLoad) { //$CommonLibJS.checkCallable
                        let r = _private.objCommonScripts.$beforeLoad();
                        if($CommonLibJS.isGenerator(r))r = yield* r;
                        //game.run({Script: _private.objCommonScripts.$beforeLoad() ?? null, Priority: priority++, Type: 0, Running: 1, Tips: '$beforeLoad'});
                    }


                    //const filePath = GameMakerGlobal.config.strSaveDataPath + fileName + '.json';


                    yield* release(false);
                    game.run({Script: function*() { //这样写是因为要把下面代码放入系统scriptQueue中运行（不是必须但我建议这样），且放在队列最前面，运行完毕后再进行下一个脚本（因为要求load要运行完毕）；
                        yield* init(false, false, ret['Data']);



                        /*/写在钩子函数里了
                        if(game.gd['$sys_random_fight']) {
                            fight.fighton(...game.gd['$sys_random_fight']);
                        }
                        */

                        //地图
                        if(game.gd['$sys_map'].$rid)
                            yield game.loadmap(game.gd['$sys_map'].$rid, /*true*/);


                        //载入afterLoad脚本
                        if(_private.objCommonScripts.$afterLoad) { //$CommonLibJS.checkCallable
                            let r = _private.objCommonScripts.$afterLoad();
                            if($CommonLibJS.isGenerator(r))r = yield* r;
                            //game.run({Script: _private.objCommonScripts.$afterLoad() ?? null, Priority: priority++, Type: 0, Running: 1, Tips: '$afterLoad'});
                        }
                    }(), Priority: -2, Type: 0, Running: 0, Tips: 'load2'});   //鹰：Priority为0也可以，只是会黑屏一下体验不太好，因为在下一个事件循环中执行代码了


                    return resolve(true);

                    //}(), Priority: -2, Type: 0, Running: 1, Tips: 'load'});
                    //return true;

                }(), 'load']);
                //}(), Priority: -2, Type: 0, Running: 0, Tips: 'load'});
            };

            const ret = $CommonLibJS.getPromise(_load);
            //ret.$resolve = _resolve; ret.$reject = _reject;
            return ret;
        }

        //重新开始游戏；
        function restart() {
            //scriptQueue.runNextEventLoop('restart');

            //！如果定义为生成器格式，则将 resolve 和 reject 删除即可（用return返回数据）；
            //const _restart = function(resolve, reject) {
                //用asyncScript的原因是：release需要清空scriptQueue 和 $asyncScript，可能会导致下面脚本执行时中断而导致没有执行完毕；
                $CommonLibJS.asyncScript([function*() {
                //game.run({Script: function*() {
                //game.async([function*() { //效果和run一样，但使用async能更好的在async函数里使用；

                    yield* release(false);
                    //yield* game.$sys.init(true, false);
                    game.run({Script: function*() {
                        yield* init(true, false);
                    }, Priority: -2, Type: 0, Running: 0, Tips: 'restart'});

                    //return resolve(true);

                }(), 'restart']);
                //}(), Priority: -2, Type: 0, Running: 0, Tips: 'restart'});
            //};

            //return new Promise(_restart);
        }


        //返回插件
        //参数0是组织/开发者名，参数1是插件名
        readonly property var plugin: function(...params) {
            //let _resolve, _reject;

            //！如果定义为生成器格式，则将 resolve 和 reject 删除即可（用return返回数据）；
            const _plugin = function(resolve, reject) {
                //_resolve = resolve; _reject = reject;

                //game.run({Script: function*() {
                game.async([function*() { //效果和run一样，但使用async能更好的在async函数里使用；

                    if(params.length < 2) {
                        //scriptQueue.runNextEventLoop('plugin');
                        return resolve(_private.objPlugins);
                    }


                    //const plugin = _private.objPlugins[params[0]][params[1]];
                    const plugin = $CommonLibJS.getObjectValue(_private.objPlugins, params[0], params[1]);
                    //if(plugin && !(plugin.$autoLoad || plugin.$autoLoad === undefined)) {
                    if(plugin && _private.objPluginsStatus[params[0]][params[1]] === 0) {
                        //game.run({Script: function*() {
                        if(plugin.$load) { //$CommonLibJS.checkCallable
                            let r = plugin.$load(params[0] + GameMakerGlobal.separator + params[1]);
                            if($CommonLibJS.isGenerator(r))r = yield* r;
                        }
                        _private.objPluginsStatus[params[0]][params[1]] = 1;
                        if(_private.nStage > 0) { //必须载入全部资源后才能init
                            if(plugin.$init) { //$CommonLibJS.checkCallable
                                let r = plugin.$init(null);
                                if($CommonLibJS.isGenerator(r))r = yield* r;
                            }
                            _private.objPluginsStatus[params[0]][params[1]] = 2;
                        }

                        return resolve(plugin);

                        //}(), Priority: -2, Type: 0, Running: 1, Tips: 'plugin'});

                        //game.run({Script: plugin.$load() ?? null, Tips: 'plugin_load:' + params[0] + params[1]});
                        //game.run({Script: plugin.$init() ?? null, Tips: 'plugin_init:' + params[0] + params[1]});
                    }
                    else {
                        if(!plugin) {
                            console.warn('[!GameScene]No Plugin:', params[0], params[1], Object.keys(_private.objPlugins));
                            return reject('No Plugin');
                        }
                        //scriptQueue.runNextEventLoop('plugin');
                    }


                    return resolve(plugin);

                }(), 'plugin']);
                //}(), Priority: -2, Type: 0, Running: 0, Tips: 'plugin'});
            };

            const ret = $CommonLibJS.getPromise(_plugin);
            //ret.$resolve = _resolve; ret.$reject = _reject;
            return ret;
        }


        //设置游戏阶段（地图0、战斗1），内部使用
        readonly property var status: function(s=null) {
            if(s === undefined || s === null)
                return _private.nStatus;
            return (_private.nStatus = s);
        }



        //读取json文件，返回解析后对象
        //filePath为 绝对或相对路径 的文件名，如果filePath以/开头，则相对于本项目根路径；
        readonly property var loadjson: function(filePath) {
            filePath = filePath.trim();
            if(!filePath)
                return null;

            if(filePath.indexOf('/') === 0)
                filePath = game.$projectpath + GameMakerGlobal.separator + filePath;
            
            const data = $Frame.sl_fileRead(filePath);
            if(!data) {
                console.warn('[!GameScene]loadjson FAIL:', filePath);
                return null;
            }

            return JSON.parse(data);
        }


        //异步脚本（协程运行）
        //readonly property var async: $CommonLibJS.asyncScript
        function async(...params) {return $CommonLibJS.$asyncScript.async(...params);}

        //将代码放入 系统脚本引擎（scriptQueue）中 等候执行；
        //参数：
        //  scriptInfo：
        //    如果为Script脚本（字符串、函数、生成器函数、生成器对象都可）；
        //    如果为对象，则有以下参数：
        //      Script 为脚本，除了上述类型外，还可以：
        //        如果为false则表示强制执行队列，为true表示下次js事件循环再运行，为null直接返回，为undefined报错后返回；
        //      Priority为优先级；>=0为插入到对应的事件队列下标位置（0为挂到第一个）；-1为追加到队尾（缺省）；-2为立即执行（此时代码前必须有yield）；-3为将此 函数/生成器 执行完毕再返回（注意：代码里yield不能返回到游戏中了，所以最好别用生成器或yield）；
        //      Type为运行类型（如果为0（缺省），表示为代码，否则表示Script为JS文件名，而scriptInfo.Path为路径）；
        //      Running为0、1、2或-1。表示如果队列里如果为空则：0是不处理；1是立即执行；2是发送一个JS事件在下一个JS事件循环里执行；-1（缺省）是自动选择（函数类是-2，非函数类是1）；但这除了Priority为-2、-3的情况下，如果Priority为-2或-3则都会立刻运行；
        //      Value：传递给事件队列的值，缺省上一次的；
        //      ScriptQueue：脚本队列，缺省 本脚本队列；
        //      Tips：简要说明 或 文件路径；
        //    如果为数组（下标0为Script脚本时，下标1为Tips，是null或true时为给_private.scriptQueue.lastEscapeValue值）；
        //  如果需要清空 异步脚本队列：game.$caches.scriptQueue.clear(n);
        //返回：-9<ret<9：run的返回值；其他为scriptQueue.create的返回值+-10；
        //  1：立刻运行了；2：下一次事件循环中运行；0：只是加入；null、undefined：没有作用；-1：参数错误；
        readonly property var run: function(scriptInfo, ...params) {
            /*if($CommonLibJS.isValidNumber(scriptInfo)) {   //如果是数字，则默认是优先级
                scriptInfo = {Priority: scriptInfo};
            }
            else if($CommonLibJS.isString(scriptInfo)) {   //如果是数字，则默认是Tips
                scriptInfo = {Tips: scriptInfo};
            }
            */
            if($CommonLibJS.isObject(scriptInfo)) { //如果是参数对象
            }
            //!!兼容旧代码
            else if($CommonLibJS.isArray(scriptInfo)) {
                scriptInfo = {
                    Script: scriptInfo[0],
                    //Priority: ,
                    Tips: scriptInfo[1],
                };
            }
            else {
                scriptInfo = {Script: scriptInfo};
            }
            //if($CommonLibJS.isObject(scriptInfo)) { //如果是参数对象
            scriptInfo = {
                Script: scriptInfo.Script,
                Priority: $CommonLibJS.isValidNumber(scriptInfo.Priority) ? parseInt(scriptInfo.Priority) : -1,
                Type: $CommonLibJS.isValidNumber(scriptInfo.Type) ? parseInt(scriptInfo.Type) : 0,
                Running: $CommonLibJS.isValidNumber(scriptInfo.Running) ? parseInt(scriptInfo.Running) : -1,
                Tips: scriptInfo.Tips ?? 'game.run',
                AutoRunNext: scriptInfo.AutoRunNext ?? true,
                ScriptQueue: scriptInfo.ScriptQueue || _private.scriptQueue,
            };
            scriptInfo.Value = Object.keys(scriptInfo).indexOf('Value') < 0 ? scriptInfo.ScriptQueue.lastEscapeValue : scriptInfo.Value;
            //}
            //else {
            //    console.warn('[!GameScene]run参数错误');
            //    return -1;
            //}


            if(scriptInfo.Script === null) {
                return null;
            }
            //直接运行
            else if(scriptInfo.Script === false) {
                scriptInfo.ScriptQueue.run(scriptInfo.Value);
                return 1;
            }
            //下次js循环运行
            else if(scriptInfo.Script === true) {
                /*$CommonLibJS.runNextEventLoop([function() {
                    //game.goon('$event');
                        scriptInfo.ScriptQueue.run(scriptInfo.ScriptQueue.lastEscapeValue);
                    }, 'game.run1']);
                */
                scriptInfo.ScriptQueue.lastEscapeValue = scriptInfo.Value;
                scriptInfo.ScriptQueue.runNextEventLoop(scriptInfo.Tips);

                return 2;
            }
            else if($CommonLibJS.isString(scriptInfo.Script)) {
            }
            //返回1个Promise对象；队列运行结束时，会将这个Promise激活；作用：可以实现两个ScriptQueue互等；
            else if($CommonLibJS.isNumber(scriptInfo.Script)) {
                return new Promise(
                    function(resolve, reject) {
                        function __next() {
                            if(scriptInfo.Script <= 0)
                                resolve(scriptInfo.ScriptQueue.lastEscapeValue);
                            else
                                $CommonLibJS.setTimeout([function() {   //鹰：可以延时
                                    resolve(scriptInfo.ScriptQueue.lastEscapeValue);
                                }, 1, rootGameScene, 'Promise resolve'], scriptInfo.Script);
                        }
                        if(scriptInfo.ScriptQueue.isEmpty())
                            __next();
                        else
                            scriptInfo.ScriptQueue.create([__next, scriptInfo.Priority, true, scriptInfo.Tips],/* ...params*/);
                    });
            }
            else if(scriptInfo.Script === undefined) {
                //console.warn('[!GameScene]game.run脚本参数错误（可忽略）');
                //console.debug(new Error().stack);
                ///console.exception('[!GameScene]game.run脚本参数错误（可忽略）');

                return undefined;
            }
            //else {


            if(scriptInfo.Type === 0) { //scriptInfo.Script是代码
                if(typeof(scriptInfo.Script) === 'string') {
                    //console.debug('[GameScene]Script:', scriptInfo.Script, params, scriptInfo.ScriptQueue.getScriptInfos());

                    //方案1：做简单的异常处理，且提前执行可以绑定环境上下文
                    ///scriptInfo.Script = '(function*(){' + scriptInfo.Script + '})()';
                    //scriptInfo.Script = '(function*(){try{' + scriptInfo.Script + '}catch(e){$CommonLibJS.printException(e);}})';
                    /*try {
                        scriptInfo.Script = eval(scriptInfo.Script);
                    }
                    catch(e) {
                        console.warn(data);
                        $CommonLibJS.printException(e);
                        return false;
                    }*/

                    //方案2：或使用这个：
                    scriptInfo.Script = _eval(scriptInfo.Script);
                    if(!scriptInfo.Script)
                        return -2;

                    //console.debug('[GameScene]ret', ret);
                }
            }
            else {  //scriptInfo.Script是文件名
                if(!scriptInfo.Path)
                    scriptInfo.Path = game.$projectpath;
                scriptInfo.Script = $GlobalJS.toPath(scriptInfo.Path + GameMakerGlobal.separator + scriptInfo.Script.trim());

                //console.debug('scriptInfo.Script:', scriptInfo.Script);

                //scriptInfo.Script = GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName + GameMakerGlobal.separator + scriptInfo.Script;
                //此脚本所在路径 注入到全局上下文环境（如果使用evaluateFile只能这样全局上下文环境，目前再没有给evaluate传递上下文环境的办法）
                $Frame.sl_globalObject().evaluateFilePath = $Frame.sl_absolutePath(scriptInfo.Script);
                //执行脚本，必须返回3种类型之一
                scriptInfo.Script = $Frame.sl_evaluateFile(scriptInfo.Script); //!!用这个好处是自带提供错误的文件路径（我做的Eval也可以了）

                //scriptInfo.Script = $CommonLibJS._evalFile(scriptInfo.Script, {evaluateFilePath: $Frame.sl_absolutePath(scriptInfo.Script)});//!!用这个好处是有 导入此JS的QML的 上下文环境
            }

            //如果是当前脚本，则立即运行，否则等正在执行脚本完毕
            //if(ret === 0)
            //    scriptInfo.ScriptQueue.run(scriptInfo.ScriptQueue.lastEscapeValue);
            //create('(function*(){console.debug(root);})()');

            //可以立刻执行
            let ret = scriptInfo.ScriptQueue.create([scriptInfo.Script, scriptInfo.Priority, scriptInfo.AutoRunNext, scriptInfo.Tips], ...params);
            ///let ret = $GlobalJS.createScript(scriptInfo.ScriptQueue, {Type: scriptInfo.Type, Priority: scriptInfo.Priority, Script: scriptInfo.Script, Tips: scriptInfo.Tips}, ...params);
            if(ret === 0) {
                //暂停游戏主Timer，否则有可能会Timer先超时并运行game.run(false)，导致执行两次
                //game.pause('$event');

                //自动判断
                if(scriptInfo.Running === -1) {
                    switch(Object.prototype.toString.call(scriptInfo.Script)) {
                    case '[object GeneratorFunction]':
                    case '[object Function]':
                        scriptInfo.Running = 2;
                        break;
                    default:
                        scriptInfo.Running = 1;
                    }
                }

                if(scriptInfo.Running === 0) {
                    return 0;
                }
                else if(scriptInfo.Running === 1) {
                    scriptInfo.ScriptQueue.run(scriptInfo.Value);
                    return 1;
                }
                else if(scriptInfo.Running === 2) {
                    //$CommonLibJS.setTimeout([function() {
                    /*$CommonLibJS.runNextEventLoop([function() {
                        //game.goon('$event');
                            scriptInfo.ScriptQueue.run(scriptInfo.ScriptQueue.lastEscapeValue);
                        }, 'game.run']);
                    */
                    scriptInfo.ScriptQueue.lastEscapeValue = scriptInfo.Value;
                    scriptInfo.ScriptQueue.runNextEventLoop('runNextEventLoop2:' + scriptInfo.Tips);

                    return 2;
                }
            }
            else if(ret === 3) {
                scriptInfo.ScriptQueue.runNextEventLoop('runNextEventLoop3:' + scriptInfo.Tips);
            }
            else if(ret < 0)
                return ret - 10;

            return ret + 10;
        }

        /*/鹰：NO：已废弃
        //将脚本放入 系统脚本引擎（scriptQueue）中 等候执行；一般用在编辑器中载入外部脚本文件
        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var script: function(fileName, priority, filePath) {
            fileName = fileName.trim();
            if(!filePath)
                filePath = game.$projectpath + GameMakerGlobal.separator + fileName;
            else
                filePath = filePath + GameMakerGlobal.separator + fileName;

            if($GlobalJS.createScript(_private.scriptQueue, {Type: 1, Priority: priority, Script: filePath, Tips: filePath}, ) === 0)
                return _private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
        }
        */

        //脚本上次返回的值
        readonly property var lastreturn: ()=>_private.scriptQueue.lastReturnedValue
        //脚本上次返回的值（return+yield）
        readonly property var lastvalue: ()=>_private.scriptQueue.lastEscapeValue

        //运行代码；
        //在这里执行会有上下文环境
        readonly property var evalcode: function(data, filePath='', envs={}) {
            return _eval(data, filePath, envs);
        }

        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var evalfile: function(fileName, filePath='', envs={}) {
            fileName = fileName.trim();
            if(!filePath)
                filePath = game.$projectpath + GameMakerGlobal.separator + fileName;
            else
                filePath = filePath + GameMakerGlobal.separator + fileName;


            //return $CommonLibJS._evalFile(filePath, envs);


            if(!$Frame.sl_fileExists(filePath))
                throw new Error('不存在文件:' + filePath);

            const data = $Frame.sl_fileRead(filePath);
            //const cfg = File.read(filePath);

            //if(!data)
            //    return false;
            return _eval(data, envs);
        }

        //用C++执行脚本；已注入game和fight环境
        readonly property var evaluate: function(program, filePath='', lineNumber = 1) {
            return $Frame.sl_evaluate(program, filePath, lineNumber);
        }
        readonly property var evaluateFile: function(file, path, lineNumber = 1) {
            if(path === undefined) {
                if($Frame.sl_globalObject().evaluateFilePath === undefined)
                    $Frame.sl_globalObject().evaluateFilePath = game.$projectpath;
                path = $Frame.sl_globalObject().evaluateFilePath;
            }
            else
                $Frame.sl_globalObject().evaluateFilePath = path;
            return $Frame.sl_evaluateFile(path + GameMakerGlobal.separator + file, lineNumber);
        }
        readonly property var importModule: function(filePath) {
            return $Frame.sl_importModule(filePath);
        }


        //手动写入引擎变量（默认退出游戏时写入）
        function savecd() {
            GameMakerGlobal.settings.setValue('Projects/' + GameMakerGlobal.config.strCurrentProjectName, game.cd);
            //return true;
        }

        //局部/全局 数据/方法
        //d和f是地图变量，切换地图时清空；
        property var d: ({})
        property var f: ({})
        //gd和gf是全局变量，读档会清空；gd会自动存档读档；
        property var gd: ({})
        property var gf: ({})
        //cd是引擎变量，整个游戏可用，进入游戏引擎时会读取，退出游戏时保存，读档不会清空；
        property var cd: ({})
        //引擎函数，整个游戏可用，游戏退出后清空；（可以保存与运行工程生命周期一致的数据）
        property var cf: ({})
        //在f和gf中定义某些特定功能的函数，系统会自动触发（优先级：地图脚本高于f高于gf）
        //  比如地图事件、地图离开事件、NPC交互事件、地图点击事件、NPC点击事件、定时器事件、NPC抵达事件、NPC触碰事件



        //项目根目录
        property string $projectpath: GameMakerGlobal.config.strProjectRootPath + GameMakerGlobal.config.strCurrentProjectName


        //用户脚本（用户 common_script.js，如果没有则指向 $GameMakerGlobalJS）
        property var $userscripts: null


        //！！！兼容旧代码
        /*/几个脚本（需要重新定义变量指向，否则外部qml和js无法使用）
        readonly property var $commonLibJS: $CommonLibJS
        readonly property var $global: Global
        readonly property var $globalJS: $GlobalJS
        readonly property var $gameMakerGlobal: GameMakerGlobal
        readonly property var $gameMakerGlobalJS: $GameMakerGlobalJS
        //readonly property var $config: GameMakerGlobal.config
        */

        //！！！兼容旧代码；插件（直接访问，不推荐）
        readonly property alias $plugins: _private.objPlugins


        /*property var $fight: QtObject {
            //我方和敌方数据
            //内容为：$Combatant() 返回的对象（包含各种数据）
            property alias myCombatants: _myCombatants
            property alias enemies: _enemies
        }*/


        //系统 数据 和 函数（特殊需要）
        readonly property var $sys: ({
            release: release,
            init: init,
            exit: _private.exitGame,
            showExitDialog: _private.showExitDialog,

            screen: rootGameScene,          //屏幕，创建的组件位置和大小固定（包含所有系统组件，包括战斗场景、摇杆、消息框、对话框等）
            viewport: itemViewPort,         //视窗，创建的组件位置和大小固定
            scene: itemViewPort.gameScene,              //场景，组件位置和大小固定，但会被scale影响
            map: itemViewPort.itemContainer,            //地图，创建的组件会改变大小和随地图移动（一般只做挂载）
            ground: itemViewPort.itemRoleContainer,     //地图地板，创建的组件会改变大小和随地图移动（一般只做挂载）

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
                        _private.objCommonScripts.$refreshCombatant(tfh);
                    }
                    else {
                        console.warn('[!GameScene]跳过错误的战斗人物：', tfh);
                    }


                    /*let t = game.gd['$sys_fight_heros'][tIndex];
                    game.gd['$sys_fight_heros'][tIndex] = new _private.objCommonScripts.$Combatant(t.$rid, t.$name);
                    $CommonLibJS.copyPropertiesToObject(game.gd['$sys_fight_heros'][tIndex], t);

                    //game.gd['$sys_fight_heros'][tIndex].__proto__ = _private.objCommonScripts.$Combatant.prototype;
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
                        tg.$location = 1;
                        game.gd['$sys_goods'].push(tg);
                    }
                    else {
                        console.warn('[!GameScene]跳过错误的道具：', tg);
                    }
                }
            },

            playSoundEffect: rootSoundEffect.play,

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

            getSpriteEffect: GameSceneJS.getSpriteEffect,
            putSpriteEffect: GameSceneJS.putSpriteEffect,
            createRole: GameSceneJS.createRole,

            equip: GameSceneJS.equip,

            delay: $CommonLibJS.runNextEventLoop,
            timeout: $CommonLibJS.setTimeout,


            //组件 和 组件模板
            components: {
                /*joystick: joystick,
                buttons: itemButtons,
                fps: itemFPS,
                map: [itemViewPort.canvasBackMap, itemViewPort.canvasFrontMap],
                msgs: itemGameMsgs,
                talks: itemRoleMsgs,
                menus: itemGameMenus,
                inputs: itemGameInputs,
                timers: itemWaitTimers,
                trade: dialogTrade,
                window: gameMenuWindow,
                video: itemVideo,
                gamePad: itemGamePad,
                */

                Sprite: compCacheSpriteEffect,
                Msg: compGameMsg,
                RoleMsg: compRoleMsg,
                Menu: compGameMenu,
                Input: compGameInput,
                Role: compRole,
                Audio: compCacheAudio,
                SoundEffect: compCacheSoundEffect,
                Image: compCacheImage,
                WordMove: compCacheWordMove,
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
            readonly property alias jsLoader: _private.jsLoader
            readonly property alias jsEngine: _private.jsLoader //！！！兼容旧代码
            readonly property alias asyncScript: _private.asyncScript
            readonly property alias scriptQueue: _private.scriptQueue


            readonly property var map: [itemViewPort.canvasBackMap, itemViewPort.canvasFrontMap]

            readonly property alias components: _private.arrGameComponents
            readonly property alias msgs: itemGameMsgs
            readonly property alias talks: itemRoleMsgs
            readonly property alias menus: itemGameMenus
            readonly property alias inputs: itemGameInputs
            readonly property alias waitTimers: itemWaitTimers

            readonly property alias buttons: itemButtons

            readonly property alias trade: dialogTrade
            readonly property alias window: gameMenuWindow
            readonly property alias video: itemVideo
            readonly property alias gamePad: itemGamePad
            readonly property alias joystick: joystick
            readonly property alias fps: itemFPS


            /*readonly*/ property alias mainRoles: _private.arrMainRoles
            /*readonly*/ property alias roles: _private.objRoles

            /*readonly*/ property alias globalTimers: _private.objGlobalTimers
            /*readonly*/ property alias timers: _private.objTimers

            /*readonly*/ property alias cacheSoundEffects: _private.objCacheSoundEffects
            /*readonly*/ property alias cacheImages: _private.objCacheImages

            /*readonly*/ property alias tmpComponents: _private.objTmpComponents
            /*readonly*/ property alias tmpMapComponents: _private.objTmpMapComponents

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



        function request(params={}, verifyType=0, type=1) {
            return $CommonLibJS.requestEx(params, verifyType, type).catch((e)=>{
                //throw e;
                $CommonLibJS.printException(e);
                return e.$params;
            });
        }
        readonly property var http: ()=>new XMLHttpRequest;
        readonly property var date: (...args)=>$CommonLibJS.formatDate(...args);
        //readonly property var math: Math

    }


    property Item mainRole
    //property alias mainRole: mainRole


    property alias _public: _public

    property alias config: _private.config
    //property alias _private: _private

    property alias fightScene: loaderFightScene

    property alias scriptQueue: _private.scriptQueue



    //是否是测试模式（不会调用 游戏开始、初始化、结束脚本）
    property bool bTest: false


    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    //anchors.fill: parent

    focus: true
    clip: true

    transform: [
        Scale { //缩放，如果为负则是镜像
            //origin { //缩放围绕的 原点坐标
                //x: width / 2
                //y: height / 2
            //}
            //xScale: 1
            //yScale: 1
        },
        Rotation { //旋转
        },
        Translate { //平移
        }
    ]


    //color: 'black'



    Mask {
        anchors.fill: parent
        //opacity: 0
        //color: Global.style.backgroundColor
        color: 'black'
        //radius: 9
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

        bSmooth: GameSceneJS.getCommonScriptResource('$config', '$map', '$smooth') ?? true;


        //mouseArea.hoverEnabled: true
        mouseArea.onClicked: {
            GameSceneJS.mapClickEvent(mouse.x, mouse.y);
        }

        /*mouseArea.onPositionChanged: {
            let blockPixel = Qt.point(Math.floor(mouse.x / itemViewPort.sizeMapBlockScaledSize.width) * itemViewPort.sizeMapBlockScaledSize.width, Math.floor(mouse.y / itemViewPort.sizeMapBlockScaledSize.height) * itemViewPort.sizeMapBlockScaledSize.height);
            console.warn(blockPixel.x, blockPixel.y);
        }*/


        Component.onCompleted: {
        }
    }


    //游戏FPS
    Timer {
        id: timer


        property var nLastTime: 0

        //计算FPS
        property int nDuration: 0
        property int nFrameCount: 0


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
            //使用脚本队列的话，人物移动就不能在scriptQueue.wait下使用了
            //game.run(GameSceneJS.onTriggered() ?? null);
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
            anchors.leftMargin: 6 * $Global.pixelDensity
            anchors.bottomMargin: 7 * $Global.pixelDensity
            //anchors.verticalCenterOffset: -100
            //anchors.horizontalCenterOffset: -100
            //anchors.margins: 1 * $Global.pixelDensity

            width: 20 * $Global.pixelDensity
            height: 20 * $Global.pixelDensity

            transformOrigin: Item.BottomLeft

            opacity: 0.6
            scale: 1

            //imageBackground.source: ''
            //imageHandle.source: ''


            onPressedChanged: {
                if(!$CommonLibJS.objectIsEmpty(_private.config.objPauseNames))
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

                if(!$CommonLibJS.objectIsEmpty(_private.config.objPauseNames))
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

            anchors.rightMargin: 10 * $Global.pixelDensity
            anchors.bottomMargin: 16 * $Global.pixelDensity

            //anchors.verticalCenterOffset: -100
            //anchors.horizontalCenterOffset: -100

            width: 6 * $Global.pixelDensity
            height: 6 * $Global.pixelDensity


            color: 'red'

            onSg_pressed: {
                //if(!$CommonLibJS.objectIsEmpty(_private.config.objPauseNames))
                //    return;
                game.run(buttonClicked() ?? null);
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

            anchors.rightMargin: 16 * $Global.pixelDensity
            anchors.bottomMargin: 8 * $Global.pixelDensity

            //anchors.verticalCenterOffset: -100
            //anchors.horizontalCenterOffset: -100

            width: 6 * $Global.pixelDensity
            height: 6 * $Global.pixelDensity


            color: 'blue'

            onSg_pressed: {
                //if(!$CommonLibJS.objectIsEmpty(_private.config.objPauseNames))
                //    return;
                game.run(buttonClicked() ?? null);
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
            //忽略没有的信号
            ignoreUnknownSignals: true

            function onSg_fightOver() {
            }
        }

        Component.onCompleted: {
            //loaderFightScene.scriptQueue = _private.scriptQueue;
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
            if($CommonLibJS.isString(pauseGame)) {
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


        onSg_close: {

            //默认回调函数
            let callback = function(itemWindow) {

                itemWindow.visible = false;

                //game.pause(true)[pauseGame]
                if($CommonLibJS.isString(pauseGame) && pauseGame && _private.config.objPauseNames[pauseGame] !== undefined) {
                    //如果没有使用yield来中断代码，可以不要game.run(true)
                    game.goon(pauseGame);
                    //game.run(true);
                    //_private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
                    return true;
                }
                //rootGameScene.forceActiveFocus();

                return false;
            }


            if($CommonLibJS.checkCallable(gameMenuWindow.fCallback, 0b11)) {   //用户自定义回调函数，参数为callback和它所需要的参数
                game.async([gameMenuWindow.fCallback.call(gameMenuWindow, callback, gameMenuWindow) ?? null, 'GameMenuWindow callback']);
            }
            else {   //默认回调函数
                callback(gameMenuWindow);


                //gameMenuWindow.visible = false;
                //gameMenuWindow.destroy();


                /* /*if(gameMenuWindow.bPauseGame && _private.config.bPauseGame) {
                    game.goon();
                    gameMenuWindow.bPauseGame = false;
                }* /*/

                /*if(_private.config.objPauseNames['$msg'] !== undefined) {
                    game.goon('$msg');
                    _private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
                }*/


                ////$Frame.goon();
            }
        }
        onSg_show: {
            let show = GameSceneJS.getCommonScriptResource('$config', '$window', '$show');
            if(show)
                show(newFlags, windowFlags);
        }
        onSg_hide: {
            let hide = GameSceneJS.getCommonScriptResource('$config', '$window', '$hide');
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
            if($CommonLibJS.isString(pauseGame)) {
                //loaderGameMsg.bPauseGame = true;
                game.pause(pauseGame);

                //loaderGameMsg.focus = true;
            }
            else {
            }


            init(goods, mygoodsinclude);
            visible = true;
        }

        function close() {
            if(visible) {

                //默认回调函数
                let callback = function(itemTrade) {

                    itemTrade.visible = false;
                    //itemTrade.destroy();

                    //game.pause(true)[pauseGame]
                    if($CommonLibJS.isString(pauseGame) && pauseGame && _private.config.objPauseNames[pauseGame] !== undefined) {
                        //如果没有使用yield来中断代码，可以不要game.run(true)
                        game.goon(pauseGame);
                        //game.run(true);
                        //_private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
                        return true;
                    }
                    //rootGameScene.forceActiveFocus();

                    return false;
                };


                if($CommonLibJS.checkCallable(dialogTrade.fCallback, 0b11)) {   //用户自定义回调函数，参数为callback和它所需要的参数
                    game.async([dialogTrade.fCallback.call(dialogTrade, callback, dialogTrade) ?? null, 'Trade callback']);
                }
                else {   //默认回调函数
                    callback(dialogTrade);


                    //dialogTrade.visible = false;
                    //dialogTrade.destroy();


                    /* /*if(dialogTrade.bPauseGame && _private.config.bPauseGame) {
                        game.goon();
                        dialogTrade.bPauseGame = false;
                    }* /*/

                    /*if(_private.config.objPauseNames['$msg'] !== undefined) {
                        game.goon('$msg');
                        _private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
                    }*/


                    ////$Frame.goon();
                }
            }

            rootGameScene.forceActiveFocus();
        }



        property var pauseGame
        property var fCallback


        visible: false
        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 4


        onSg_close: {
            close();
        }
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
            //忽略没有的信号
            ignoreUnknownSignals: true

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

    //临时存放创建的RoleMsgs
    Item {
        id: itemRoleMsgs


        //创建的下标
        property int nIndex: 0


        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 5

    }

    //临时存放创建的Messages
    Item {
        id: itemGameMsgs


        //创建的下标
        property int nIndex: 0


        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 6

    }

    //临时存放创建的Menus
    Item {
        id: itemGameMenus


        //创建的下标
        property int nIndex: 0


        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 7

    }

    //临时存放创建的输入框
    Item {
        id: itemGameInputs


        //创建的下标
        property int nIndex: 0


        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 8

    }


    //临时存放创建的定时器（wait命令创建的）
    Item {
        id: itemWaitTimers

    }


    //视频播放
    Mask {
        id: itemVideo


        function play() {
            if(pauseGame === true)
                pauseGame = '$video';

            //是否暂停游戏
            if($CommonLibJS.isString(pauseGame)) {
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

        function stop(code=0) {
            //if(mediaPlayer.playbackState !== MediaPlayer.StoppedState) {

                //默认回调函数
                let callback = function(code, itemVideo) {

                    itemVideo.visible = false;
                    mediaPlayer.stop();
                    mediaPlayer.source = '';
                    //itemMsg.destroy();

                    //game.pause(true)[pauseGame]
                    if($CommonLibJS.isString(pauseGame) && pauseGame && _private.config.objPauseNames[pauseGame] !== undefined) {
                        //如果没有使用yield来中断代码，可以不要game.run(true)
                        game.goon(pauseGame);
                        //game.run(true);
                        //_private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
                        return true;
                    }
                    //rootGameScene.forceActiveFocus();

                    return false;
                };


                if($CommonLibJS.checkCallable(itemVideo.fCallback, 0b11)) {   //用户自定义回调函数，参数为callback和它所需要的参数
                    game.async([itemVideo.fCallback.call(itemVideo, callback, code, itemVideo) ?? null, 'Video callback']);
                }
                else {   //默认回调函数
                    callback(code, itemVideo);


                    //rootRoleMsg.visible = false;
                    //rootRoleMsg.destroy();


                    /* /*if(rootRoleMsg.bPauseGame && _private.config.bPauseGame) {
                        game.goon();
                        rootRoleMsg.bPauseGame = false;
                    }* / */

                    /*if(_private.config.objPauseNames['$talk'] !== undefined) {
                        game.goon('$talk');
                        _private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
                    }*/


                    ////$Frame.goon();
                }
            //}

            rootGameScene.forceActiveFocus();
        }


        property var pauseGame
        property var fCallback
        property var fStateCallback


        visible: false
        //opacity: 0
        //anchors.fill: parent
        width: parent.width
        height: parent.height
        z: 9

        color: Global.style.backgroundColor
        //radius: 9



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
                        game.stopvideo(0);
                    }

                    onPlaybackStateChanged: {
                        const eventName = `$video_state`;
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
                            //也可以用game.run
                            game.async([tScript.call(mediaPlayer, playbackState, mediaPlayer, videoOutput) ?? null, eventName]);
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
                        game.stopvideo(1);
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

        Keys.onEscapePressed: function(event) {
            event.accepted = true;
            game.stopvideo(1);
        }
        Keys.onBackPressed: function(event) {
            event.accepted = true;
            game.stopvideo(1);
        }

        Component.onCompleted: {

        }
        Component.onDestruction: {
            //game.stopvideo(-1); //加上可能会在 释放环境后 才运行用户回调函数，然后导致报错；
        }
    }



    //背景音乐
    Item {
        id: itemBackgroundMusic



        function play(musicURL=undefined, loops=undefined, force=false) {
            if(musicURL !== undefined) {
                if(!$Frame.sl_fileExists($GlobalJS.toPath(musicURL))) {
                    console.warn('[!GameScene]音乐文件不存在：', musicURL);
                    return false;
                }
                audioBackgroundMusic.source = musicURL;
            }
            if(loops)
                audioBackgroundMusic.loops = loops;

            if(force) {
                resume(-1);
            }
            else {
                //bPlay = true;
                if(!game.musicpausing())
                    //if(audioBackgroundMusic.playbackState !== Audio.StoppedState)
                    audioBackgroundMusic.play();
                else
                    audioBackgroundMusic.pause();
                //nPauseTimes = 0;
            }

            return true;
        }

        function stop() {
            //bPlay = false;
            audioBackgroundMusic.stop();
            //nPauseTimes = 0;
        }

        function pause(name='$user') {
            if(name === true) { //引擎全局
                //GameMakerGlobal.settings.setValue('$PauseMusic', 1);
                game.cd['$sys_sound'] &= ~0b1;
            }
            else if(name === false) { //存档
                game.gd['$sys_sound'] &= ~0b1;
            }
            else if(name && $CommonLibJS.isString(name)) {
                //if(objMusicPause[name] === 1)
                //    console.warn('游戏被多次暂停，请检查是否有暂停游戏的指令（比如msg、menu等）没有使用yield？');
                objMusicPause[name] = (objMusicPause[name] ? objMusicPause[name] + 1 : 1);
                //objMusicPause[name] = 1;
            }
            else
                return;


            if(audioBackgroundMusic.playbackState !== Audio.StoppedState)
                audioBackgroundMusic.pause();


            //console.debug('pause', nPauseTimes)
        }

        function resume(name='$user') {
            if(name === true) { //引擎全局
                //GameMakerGlobal.settings.setValue('$PauseMusic', 0);
                game.cd['$sys_sound'] |= 0b1;
            }
            else if(name === false) { //存档
                game.gd['$sys_sound'] |= 0b1;
            }
            else if(name === null) {    //清空
                objMusicPause = {};
            }
            else if(name && $CommonLibJS.isString(name)) {
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
                game.cd['$sys_sound'] |= 0b1;
                game.gd['$sys_sound'] |= 0b1;
                objMusicPause = {};
            }
            else
                return;


            if(audioBackgroundMusic.playbackState === Audio.PausedState)
                itemBackgroundMusic.play();

            //console.debug('resume', nPauseTimes, bPlay)

        }



        property var arrMusicStack: []  //播放音乐栈

        property var objMusicPause: ({})    //暂停类型

        property var fStateCallback



        Audio {
            id: audioBackgroundMusic


            function isPlaying() {
                return audioBackgroundMusic.playbackState === Audio.PlayingState;
            }


            loops: Audio.Infinite


            onPlaybackStateChanged: {
                const eventName = `$music_state`;
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
                    //也可以用game.run
                    game.async([tScript.call(audioBackgroundMusic, playbackState, audioBackgroundMusic) ?? null, eventName]);
            }

            onPlaying: {

            }
            onStopped: {

            }
            onPaused: {

            }
        }
    }


    //音效（特效的）
    Item {
        id: rootSoundEffect



        //播放音效；
        //参数：完整URL；index为通道（目前0~9，-1为随机挑选没有播放的通道，如果没有则返回；-2为随机挑选没有播放的通道，如果没有则随机强制选择一个）；
        function play(playSoundEffectURL=undefined, index=-1, loops=1) {
            if(!$Frame.sl_fileExists($GlobalJS.toPath(playSoundEffectURL))) {
                console.warn('[!GameScene]音效文件不存在：', playSoundEffectURL);
                return -1;
            }

            if(index < 0) {
                for(let ti = 0; ti < arrCacheSoundEffects.length; ++ti) {
                    const se = arrCacheSoundEffects[ti];
                    if(se.isPlaying())
                        continue;
                    index = ti;
                    break;
                }
            }
            //如果index === -1，且都在播放，则返回
            if(index === -1)
                return -2;
            //如果如果index < -1，且都在播放，则任选一个强制播放
            else if(index < -1)
                index = $CommonLibJS.random(0, arrCacheSoundEffects.length);

            const se = arrCacheSoundEffects[index];
            if(!se)
                return -3;

            //!!!鹰：手机上，如果状态为playing，貌似后面play就没声音了。。。
            if(se.isPlaying()) {
                se.stop();
            }
            if(playSoundEffectURL) {
                se.source = playSoundEffectURL;
                se.loops = loops;
                se.play();
            }

            //let _resolve, _reject;
            const ret = $CommonLibJS.getPromise(function(resolve, reject) {
                //_resolve = resolve; _reject = reject;
                se.fnStoppedCallback = function() {
                    resolve(se.source);
                    se.source = '';
                }
            });
            //ret.$resolve = _resolve; ret.$reject = _reject;
            ret.$params = se;
            return ret;
        }

        function stop(index=-1) {
            let ret = 0;
            if(index < 0) {
                for(let ti = 0; ti < arrCacheSoundEffects.length; ++ti) {
                    const se = arrCacheSoundEffects[ti];
                    if(se.isPlaying()) {
                        se.stop();
                        ++ret;
                    }
                }
                return ret;
            }

            const se = arrCacheSoundEffects[index];
            if(!se)
                return -1;

            if(se.isPlaying()) {
                se.stop();
                return 1;
            }
            return 0;
        }

        function pause(name='$user') {
            if(name === true) { //引擎全局
                //GameMakerGlobal.settings.setValue('$PauseSound', 1);
                game.cd['$sys_sound'] &= ~0b10;
            }
            else if(name === false) { //存档
                game.gd['$sys_sound'] &= ~0b10;
            }
            else if(name && $CommonLibJS.isString(name)) {
                //if(objSoundEffectPause[name] === 1)
                //    console.warn('游戏被多次暂停，请检查是否有暂停游戏的指令（比如msg、menu等）没有使用yield？');
                objSoundEffectPause[name] = (objSoundEffectPause[name] ? objSoundEffectPause[name] + 1 : 1);
                //objSoundEffectPause[name] = 1;
            }
            else if($CommonLibJS.isNumber(name)) { //某个通道（-1为全部）
                if(name >= 0 && name < arrCacheSoundEffects.length) {
                    const se = arrCacheSoundEffects[name];
                    if(!se)
                        return false;
                    if(se.isPlaying())
                        se.pause();
                    return true;
                }
                else if(name < 0) {
                    for(let se of arrCacheSoundEffects.length) {
                        if(!se)
                            continue;
                        if(se.isPlaying())
                            se.pause();
                    }
                    return true;
                }
                return false;
            }
            else
                return false;

            //console.debug('pause:', nPauseTimes);


            for(let tse of arrCacheSoundEffects) {
                if(tse.isPlaying())
                    tse.pause();
            }


            return true;
        }

        function resume(name='$user') {
            if(name === true) { //引擎全局
                //GameMakerGlobal.settings.setValue('$PauseSound', 0);
                game.cd['$sys_sound'] |= 0b10;
            }
            else if(name === false) { //存档
                game.gd['$sys_sound'] |= 0b10;
            }
            else if(name === null) {    //清空
                objSoundEffectPause = {};
            }
            else if($CommonLibJS.isNumber(name) && name >= 0 && name < arrCacheSoundEffects.length) {
                const se = arrCacheSoundEffects[name];
                if(!se)
                    return false;
                if(se.isPaused())
                    se.play();
                return true;
            }
            else if(name && $CommonLibJS.isString(name)) {
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
                game.cd['$sys_sound'] |= 0b10;
                game.gd['$sys_sound'] |= 0b10;
                objSoundEffectPause = {};
            }
            else
                return false;

            //console.debug('resume', nPauseTimes, bPlay);


            for(let tse of arrCacheSoundEffects) {
                if(tse.isPaused())
                    tse.play();
            }
        }



        /*function playSoundEffect(soundeffectSource) {

            play(GameMakerGlobal.soundResourceURL(soundeffectSource), -1);

            /*const se = _private.objCacheSoundEffects[soundeffectSource];
            if(!se)
                return false;

            //!!!鹰：手机上，如果状态为playing，貌似后面play就没声音了。。。
            if(se.isPlaying())
                se.stop();
            se.play();
            * /
        }
        */



        property real rVolume: 1.0
        property bool bMuted: false

        property var arrCacheSoundEffects: ([]) //音效组件

        property var objSoundEffectPause: ({}) //暂停类型



        /*Repeater {
            id: repeaterSoundEffects

            delegate: compCacheSoundEffect
            model: 10
        }
        */
    }



    //调试
    Rectangle {
        id: itemFPS

        ///width: $Platform.compileType === 'debug' ? rootGameScene.width / 3 : rootGameScene.width / 2
        //width: GameMakerGlobal.config.bDebug === true ? rootGameScene.width / 3 : rootGameScene.width / 2
        //width: textFPS.width + textPos.width
        width: 150
        //height: $Platform.compileType === 'debug' ? textFPS.implicitHeight : textFPS.implicitHeight
        height: GameMakerGlobal.config.bDebug === true ? textFPS.implicitHeight : textFPS.implicitHeight

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

                ///visible: $Platform.compileType === 'debug'
                //visible: GameMakerGlobal.config.bDebug === true
            }
        }

        Text {
            id: textPos1
            y: 15
            //width: 200
            width: 120
            height: 15

            //visible: $Platform.compileType === 'debug'
            visible: GameMakerGlobal.config.bDebug === true
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
            textFormat: TextArea.PlainText
            wrapMode: TextEdit.Wrap

            selectByKeyboard: true
            selectByMouse: true
        }

        onAccepted: {
            console.debug(eval(textScript.text));
            //$GlobalJS.runScript(_private.scriptQueue, 0, textScript.text);

            rootGameScene.forceActiveFocus();
        }
        onRejected: {
            //console.log('Cancel clicked');

            rootGameScene.forceActiveFocus();
        }
    }



    QtObject {  //公有数据,函数,对象等
        id: _public

    }


    QtObject {  //私有数据,函数,对象等
        id: _private


        //游戏配置/设置
        readonly property var config: QtObject {
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
            //游戏地图场景速度
            property real rGameSpeed: 1


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

        //游戏状态（0：刚开始；1：资源载入（loadResources）结束；2：游戏初始化（init）结束；3、起始脚本载入结束，正式开始；10：开始释放资源；11：释放资源结束（release）；12：资源卸载结束（unloadResources）；）
        property int nStage: 0

        //场景跟踪角色
        property var sceneRole: null //mainRole

        //游戏目前阶段（0：正常；1：战斗）
        property int nStatus: 0


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

        property var objCommonScripts: ({})     //系统 和 用户 合并后的 通用脚本（用户脚本优先，没有的使用 GameMakerGlobal.js，注意只包含函数和var变量，不包含let/const变量）；

        property var objPlugins: ({}) //所有插件脚本对象
        property var objPluginsStatus: ({}) //所有插件脚本状态
        property var arrGameComponents: [] //存储所有游戏组件（4种：GameMsg、RoleMsg、GameMenu、GameInput）

        //JS引擎，用来载入外部JS文件
        readonly property var jsLoader: new $CommonLibJS.JSLoader(rootGameScene, (qml, parent, fileURL)=>Qt.createQmlObject(qml, parent, fileURL))

        //媒体列表 信息
        //property var objImages: ({})         //{图片名: 图片路径}
        //property var objMusic: ({})         //{音乐名: 音乐路径}
        //property var objVideos: ({})         //{视频名: 视频路径}


        readonly property var asyncScript: $CommonLibJS.$asyncScript

        //异步脚本（整个游戏的脚本队列系统）
        readonly property var scriptQueue: new $CommonLibJS.ScriptQueue()


        //创建的 主角 和 角色NPC 组件容器
        property var arrMainRoles: []
        property var objRoles: ({})

        //定时器
        property var objGlobalTimers: ({})        //{定时器名: [间隔,触发次数,是否全局,剩余时长]}
        property var objTimers: ({})        //{定时器名: [间隔,触发次数,是否全局,剩余时长]}


        property var objTmpComponents: ({})      //临时组件（特效和图片，用户创建，退出游戏删除用）
        //依附在地图上的图片和特效，切换地图时删除
        property var objTmpMapComponents: ({})


        //特效的音效和图片 缓存（组件）
        property var objCacheSoundEffects: ({})
        property var objCacheImages: ({})

        //特效缓存类
        //  目前只有战斗的特效使用，地图场景的特效因为会挂载到 对应对象的tmp缓存中，和其他组件混在一起，只能使用destroy来释放，所以不适用。
        readonly property var cacheSprites: new $CommonLibJS.Cache({
            //创建时回调
            $create: function(p) {
                let o = compCacheSpriteEffect.createObject(p);
                /*o.sg_playSoundEffect.connect(function(soundeffectSource) {
                    game.playsoundeffect(soundeffectSource, -1);
                });
                */
                return o;
            },
            //初始化回调
            $init: function(o, p){o.visible = true; o.parent = p; return o;},
            //释放回调
            $release: function(o){o.visible = false; o.sprite.stop(); return o;},
            //销毁回调
            $destroy: function(o){o.destroy();},
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
                    switch(_private.arrPressedKeys.$$value(-1)) {
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

            $dialog.show({
                Msg: '确认退出游戏？',
                Buttons: Dialog.Ok | Dialog.Cancel,
                OnAccepted: function() {
                    exitGame(false);

                    //if(rootGameScene)rootGameScene.forceActiveFocus();
                },
                OnRejected: ()=>{
                    //if(rootGameScene)rootGameScene.forceActiveFocus();
                },
            });
        }

        function exitGame(force=false) {
            if(!force) {
                ///！！放在下一次执行（因为exitGame有可能在事件队列中运行，此时 _private.scriptQueue.clear(6) 会导致生成器重入，所以必须跳出事件队列）。
                //$CommonLibJS.runNextEventLoop([function() {

                //用asyncScript的原因是：release需要清空scriptQueue 和 $asyncScript，可能会导致下面脚本执行时中断而导致没有执行完毕；
                $CommonLibJS.asyncScript([function*() {
                //game.run({Script: function*() {
                //game.async([function*() { //效果和run一样，但使用async能更好的在async函数里使用；

                    //将队列中的脚本强制运行完毕（不等待）
                    //_private.scriptQueue.clear(6);
                    try {
                        yield* release();
                    }
                    catch(e) {
                        $CommonLibJS.printException(e);
                        console.warn('[!GameScene]游戏退出报错');
                        //throw err;
                    }

                    console.debug('[GameScene]Close:',
                        JSON.stringify(_private.scriptQueue.getScriptInfos(), function(k, v){switch(k){case 'Script': case 'Running': case 'Args': case 'EscapeValue': if(typeof v === 'object')return undefined;}return v;})
                    );

                    //console.debug(_private.scriptQueue.getScriptInfos().$$toJson());
                    //_private.scriptQueue.clear(0);
                    //console.debug(_private.scriptQueue.getScriptInfos().$$toJson());


                    //等待组件都释放完毕，再关闭（Loader释放时会直接析构rootGameScene和所有组件）；
                    $CommonLibJS.runNextEventLoop([function(...params) {
                        sg_close();
                    }, 'sg_close']);


                }(), 'exitGame']);
                //}, Tips: 'exitGame']});
                //}, 'exitGame']);
            }
            else
                sg_close();
        }
    }



    //角色对话框
    Component {
        id: compRoleMsg

        Item {
            id: rootRoleMsg
            objectName: 'RoleMessage'



            //signal accepted();
            //signal rejected();


            //code是关闭方式：1为点击关闭，2为自动关闭
            function over(code=-2) {
                if(rootRoleMsg.nShowStatus === -1)
                    return;

                rootRoleMsg.nShowStatus = -1;


                //默认回调函数
                let callback = function(code, itemMsg) {

                    itemMsg.visible = false;
                    itemMsg.destroy();

                    //game.pause(true)[pauseGame]
                    if($CommonLibJS.isString(pauseGame) && pauseGame && _private.config.objPauseNames[pauseGame] !== undefined) {
                        //如果没有使用yield来中断代码，可以不要game.run(true)
                        game.goon(pauseGame);
                        //game.run(true);
                        //_private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
                        return true;
                    }
                    //rootGameScene.forceActiveFocus();

                    return false;
                };


                if($CommonLibJS.checkCallable(rootRoleMsg.fCallback, 0b11)) {   //用户自定义回调函数，参数为callback和它所需要的参数
                    game.async([rootRoleMsg.fCallback.call(rootRoleMsg, callback, code, rootRoleMsg) ?? null, 'Role message callback']);
                }
                else {   //默认回调函数
                    callback(code, rootRoleMsg);


                    //rootRoleMsg.visible = false;
                    //rootRoleMsg.destroy();


                    /* /*if(rootRoleMsg.bPauseGame && _private.config.bPauseGame) {
                        game.goon();
                        rootRoleMsg.bPauseGame = false;
                    }* / */

                    /*if(_private.config.objPauseNames['$talk'] !== undefined) {
                        game.goon('$talk');
                        _private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
                    }*/


                    ////$Frame.goon();
                }
            }

            function stop(type=0) {
                messageRole.stop(type);
            }

            function show(role=null, msg='', interval=20, pretext='', keeptime=0, style=null, _pauseGame=true, callback=true) {

                let name = '', avatar = '', avatarSize = null;
                if(role && $CommonLibJS.isString(role)) {
                    do {
                        const roleName = role;
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
                            //name = roleName;
                            name = role.RoleName;
                            avatar = role.Avatar;
                            avatarSize = role.AvatarSize;
                            break;
                        }
                        role = null;
                    } while(0);
                }



                rootRoleMsg.pauseGame = _pauseGame;
                rootRoleMsg.fCallback = callback;

                if(pauseGame === true)
                    pauseGame = '$talk';
                //是否暂停游戏
                if($CommonLibJS.isString(pauseGame)) {
                    //loaderGameMsg.bPauseGame = true;
                    game.pause(pauseGame);

                    //loaderGameMsg.focus = true;
                }
                else {
                }



                //样式
                if(!style)
                    style = {};
                const styleSystem = $GameMakerGlobalJS.$config.$styles.$talk;
                const styleUser = $CommonLibJS.getObjectValue(game.$userscripts, '$config', '$styles', '$talk') || styleSystem;
                let tn;


                let bShowName = $CommonLibJS.shortCircuit(0b1, style.Name, styleUser.$name, styleSystem.$name);
                let bShowAvatar = $CommonLibJS.shortCircuit(0b1, style.Avatar, styleUser.$avatar, styleSystem.$avatar);
                //let bShowName = $CommonLibJS.shortCircuit(0b1, style.Name, $CommonLibJS.getObjectValue(game.$userscripts, '$config', '$styles', '$talk', '$name'), $CommonLibJS.getObjectValue($GameMakerGlobalJS, '$config', '$styles', '$talk', '$name'));
                //let bShowAvatar = $CommonLibJS.shortCircuit(0b1, style.Avatar, $CommonLibJS.getObjectValue(game.$userscripts, '$config', '$styles', '$talk', '$avatar'), $CommonLibJS.getObjectValue($GameMakerGlobalJS, '$config', '$styles', '$talk', '$avatar'));
                if(name && bShowName)
                    pretext = name + '：' + pretext;
                if(avatar && bShowAvatar)
                    pretext = $CommonLibJS.showRichTextImage(GameMakerGlobal.imageResourceURL(avatar), avatarSize[0], avatarSize[1]) + pretext;


                messageRole.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
                messageRole.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
                tn = style.FontSize || styleUser.$fontSize || styleSystem.$fontSize;
                if(tn < 0)
                    messageRole.textArea.font.pixelSize = -tn;
                else
                    messageRole.textArea.font.pixelSize = tn * $fontPointRatio;
                    //messageRole.textArea.font.pointSize = tn;
                messageRole.textArea.color = style.FontColor || styleUser.$fontColor || styleSystem.$fontColor;
                maskMessageRole.color = style.MaskColor || styleUser.$maskColor || styleSystem.$maskColor;

                //let type = $CommonLibJS.shortCircuit(0b1, style.Type, styleUser.$type, styleSystem.$type);
                tn = style.MinWidth || styleUser.$minWidth || styleSystem.$minWidth || messageRole.nMinWidth;
                if(tn > 0 && tn < 1)
                    tn = tn * parent.width;
                messageRole.nMinWidth = tn;
                tn = style.MaxWidth || styleUser.$maxWidth || styleSystem.$maxWidth || messageRole.nMaxWidth;
                if(!$CommonLibJS.isValidNumber(tn, 0b1) || tn <= 0) {
                    messageRole.nMaxWidth = Qt.binding(()=>parent.width);
                }
                else {
                    if(tn > 0 && tn < 1)
                        tn = tn * parent.width;
                    messageRole.nMaxWidth = tn;
                }
                tn = style.MinHeight || styleUser.$minHeight || styleSystem.$minHeight || messageRole.nMinHeight;
                if(tn > 0 && tn < 1)
                    tn = tn * parent.height;
                else if(tn.toString().indexOf('.') >= 0)
                    tn = parseInt((messageRole.textArea.contentHeight) / messageRole.textArea.lineCount) * parseFloat(tn) + messageRole.textArea.nPadding * 2;
                messageRole.nMinHeight = tn;
                tn = style.MaxHeight || styleUser.$maxHeight || styleSystem.$maxHeight || messageRole.nMaxHeight;
                if(!$CommonLibJS.isValidNumber(tn, 0b1) || tn <= 0) {
                    messageRole.nMaxHeight = Qt.binding(()=>parent.height);
                }
                else {
                    if(tn > 0 && tn < 1)
                        tn = tn * parent.height;
                    else if(tn.toString().indexOf('.') >= 0)
                        tn = parseInt((messageRole.textArea.contentHeight) / messageRole.textArea.lineCount) * parseFloat(tn) + messageRole.textArea.nPadding * 2;
                    messageRole.nMaxHeight = tn;
                }

                //-1：即点即关闭；0：等待显示完毕(需点击）；>0：显示完毕后过keeptime毫秒自动关闭（不需点击）；
                rootRoleMsg.nKeepTime = keeptime || 0;


                rootRoleMsg.nShowStatus = 1;

                rootRoleMsg.visible = true;
                //touchAreaRoleMsg.enabled = false;


                messageRole.show($CommonLibJS.convertToHTML(msg), $CommonLibJS.convertToHTML(pretext), interval, keeptime, 0b10);
                //$Frame.wait(-1);

            }

            function clicked() {
                //显示完毕，则关闭
                if(rootRoleMsg.nShowStatus === 0)
                    rootRoleMsg.over(1);
                //如果正在显示，且nKeepTime为-1（表示点击后显示全部）；
                else if(rootRoleMsg.nShowStatus === 1 && rootRoleMsg.nKeepTime === -1) {
                    rootRoleMsg.nShowStatus = 0;
                    messageRole.stop(1);
                }
            }



            //显示完全后延时
            property int nKeepTime: 0
            //显示状态：-1：停止；0：显示完毕；1：正在显示
            property int nShowStatus: -1

            //是否暂停
            property var pauseGame: true
            //回调函数
            property var fCallback

            property alias message: messageRole
            property alias mask: maskMessageRole


            visible: false
            //anchors.fill: parent
            width: parent.width
            height: parent.height
            //z: 5


            Mask {
                id: maskMessageRole

                anchors.fill: parent

                visible: color.a !== 0
                //opacity: 0

                //color: Global.style.backgroundColor
                color: 'transparent'
                //radius: 9

                mouseArea.onPressed: {
                    rootRoleMsg.clicked();
                }
            }


            Message {
                id: messageRole

                width: parent.width
                height: parent.height * 0.1
                //height: 90
                anchors.bottom: parent.bottom


                nScrollHorizontal: 0
                nScrollVertical: 1


                textArea.enabled: false
                textArea.readOnly: true
                //textArea.font.pointSize: 16

                textArea.onReleased: {
                    rootRoleMsg.clicked();
                    ////rootGameScene.forceActiveFocus();
                }


                nMinWidth: parent.width
                nMaxWidth: -1
                //最小为2行，最大为3.5行
                nMinHeight: parseInt((textArea.contentHeight) / textArea.lineCount) * 2 + textArea.nPadding * 2
                nMaxHeight: parseInt((textArea.contentHeight) / textArea.lineCount) * 3.5 + textArea.nPadding * 2
                //nMaxHeight: 90


                onSg_over: {
                    //自动关闭
                    if(rootRoleMsg.nKeepTime > 0)
                        rootRoleMsg.over(2);
                    else
                        rootRoleMsg.nShowStatus = 0;
                }
            }


            /*MultiPointTouchArea {
                id: touchAreaRoleMsg
                anchors.fill: parent
                enabled: false
                //enabled: rootRoleMsg.standardButtons === Dialog.NoButton

                //onPressed: {
                onReleased: {
                    ////rootGameScene.forceActiveFocus();
                    //console.debug('MultiPointTouchArea1')
                    rootRoleMsg.over();
                    //console.debug('MultiPointTouchArea2')
                }
            }*/


            Component.onCompleted: {
                _private.arrGameComponents.unshift(this);
            }
            Component.onDestruction: {
                //over(-1); //加上可能会在 释放环境后 才运行用户回调函数，然后导致报错；


                for(let i in _private.arrGameComponents) {
                    if(_private.arrGameComponents[i] === this) {
                        delete _private.arrGameComponents[i];
                        break;
                    }
                }
            }
        }
    }

    //游戏信息框
    Component {
        id: compGameMsg

        Item {
            id: rootGameMsgDialog
            objectName: 'GameMessage'


            //signal accepted();
            //signal rejected();


            //code是关闭方式：1为点击关闭，2为自动关闭
            function over(code=-2) {
                if(rootGameMsgDialog.nShowStatus === -1)
                    return;

                rootGameMsgDialog.nShowStatus = -1;


                //默认回调函数
                let callback = function(code, itemMsg) {

                    itemMsg.visible = false;
                    itemMsg.destroy();

                    //game.pause(true)[pauseGame]
                    if($CommonLibJS.isString(pauseGame) && pauseGame && _private.config.objPauseNames[pauseGame] !== undefined) {
                        //如果没有使用yield来中断代码，可以不要game.run(true)
                        game.goon(pauseGame);
                        //game.run(true);
                        //_private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
                        return true;
                    }
                    //rootGameScene.forceActiveFocus();

                    return false;
                };


                if($CommonLibJS.checkCallable(rootGameMsgDialog.fCallback, 0b11)) {   //用户自定义回调函数，参数为callback和它所需要的参数
                    game.async([rootGameMsgDialog.fCallback.call(rootGameMsgDialog, callback, code, rootGameMsgDialog) ?? null, 'Game message callback']);
                }
                else {   //默认回调函数
                    callback(code, rootGameMsgDialog);


                    //rootGameMsgDialog.visible = false;
                    //rootGameMsgDialog.destroy();


                    /* /*if(rootGameMsgDialog.bPauseGame && _private.config.bPauseGame) {
                        game.goon();
                        rootGameMsgDialog.bPauseGame = false;
                    }* /*/

                    /*if(_private.config.objPauseNames['$msg'] !== undefined) {
                        game.goon('$msg');
                        _private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
                    }*/


                    ////$Frame.goon();
                }
            }

            function stop(type=0) {
                messageGame.stop(type);
            }

            function show(msg='', interval=20, pretext='', keeptime=0, style={}, _pauseGame=true, callback=true) {

                rootGameMsgDialog.pauseGame = _pauseGame;
                rootGameMsgDialog.fCallback = callback;

                if(pauseGame === true)
                    pauseGame = '$msg_' + itemGameMsgs.nIndex;
                //是否暂停游戏
                if($CommonLibJS.isString(pauseGame)) {
                    //loaderGameMsg.bPauseGame = true;
                    game.pause(pauseGame);

                    //loaderGameMsg.focus = true;
                }
                else {
                    //loaderGameMsg.bPauseGame = false;
                }



                //样式
                if(!style)
                    style = {};
                else if($CommonLibJS.isValidNumber(style))
                    style = {};
                const styleSystem = $GameMakerGlobalJS.$config.$styles.$msg;
                const styleUser = $CommonLibJS.getObjectValue(game.$userscripts, '$config', '$styles', '$msg') || styleSystem;
                let tn;

                messageGame.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
                messageGame.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
                tn = style.FontSize || styleUser.$fontSize || styleSystem.$fontSize;
                if(tn < 0)
                    messageGame.textArea.font.pixelSize = -tn;
                else
                    messageGame.textArea.font.pixelSize = tn * $fontPointRatio;
                    //messageGame.textArea.font.pointSize = tn;
                messageGame.textArea.color = style.FontColor || styleUser.$fontColor || styleSystem.$fontColor;
                maskMessageGame.color = style.MaskColor || styleUser.$maskColor || styleSystem.$maskColor;

                //let type = $CommonLibJS.shortCircuit(0b1, style.Type, styleUser.$type, styleSystem.$type);
                tn = style.MinWidth || styleUser.$minWidth || styleSystem.$minWidth || messageGame.nMinWidth;
                if(tn > 0 && tn < 1)
                    tn = tn * parent.width;
                messageGame.nMinWidth = tn;
                tn = style.MaxWidth || styleUser.$maxWidth || styleSystem.$maxWidth || messageGame.nMaxWidth;
                if(!$CommonLibJS.isValidNumber(tn, 0b1) || tn <= 0) {
                    messageGame.nMaxWidth = Qt.binding(()=>parent.width);
                }
                else {
                    if(tn > 0 && tn < 1)
                        tn = tn * parent.width;
                    messageGame.nMaxWidth = tn;
                }
                tn = style.MinHeight || styleUser.$minHeight || styleSystem.$minHeight || messageGame.nMinHeight;
                if(tn > 0 && tn < 1)
                    tn = tn * parent.height;
                else if(tn.toString().indexOf('.') >= 0)
                    tn = parseInt((messageGame.textArea.contentHeight) / messageGame.textArea.lineCount) * parseFloat(tn) + messageGame.textArea.nPadding * 2;
                messageGame.nMinHeight = tn;
                tn = style.MaxHeight || styleUser.$maxHeight || styleSystem.$maxHeight || messageGame.nMaxHeight;
                if(!$CommonLibJS.isValidNumber(tn, 0b1) || tn <= 0) {
                    messageGame.nMaxHeight = Qt.binding(()=>parent.height);
                }
                else {
                    if(tn > 0 && tn < 1)
                        tn = tn * parent.height;
                    else if(tn.toString().indexOf('.') >= 0)
                        tn = parseInt((messageGame.textArea.contentHeight) / messageGame.textArea.lineCount) * parseFloat(tn) + messageGame.textArea.nPadding * 2;
                    messageGame.nMaxHeight = tn;
                }

                //-1：即点即关闭；0：等待显示完毕(需点击）；>0：显示完毕后过keeptime毫秒自动关闭（不需点击）；
                rootGameMsgDialog.nKeepTime = keeptime || 0;


                rootGameMsgDialog.nShowStatus = 1;

                rootGameMsgDialog.visible = true;
                //touchAreaGameMsg.enabled = false;


                messageGame.show($CommonLibJS.convertToHTML(msg), $CommonLibJS.convertToHTML(pretext), interval, rootGameMsgDialog.nKeepTime, 0b11);
                //$Frame.wait(-1);

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

            property alias message: messageGame
            property alias mask: maskMessageGame


            visible: false
            //anchors.fill: parent
            width: parent.width
            height: parent.height
            //z: 0


            Mask {
                id: maskMessageGame

                anchors.fill: parent

                visible: color.a !== 0
                //opacity: 0

                //color: Global.style.backgroundColor
                color: '#7FFFFFFF'
                //radius: 9

                mouseArea.onPressed: {
                    rootGameMsgDialog.clicked();
                }
            }


            Message {
                id: messageGame

                width: parent.width * 0.7
                height: parent.height * 0.7
                anchors.centerIn: parent


                nScrollHorizontal: 0
                nScrollVertical: 1


                textArea.enabled: false
                textArea.readOnly: true
                //textArea.font.pointSize: 16

                textArea.onReleased: {
                    rootGameMsgDialog.clicked();
                    ////rootGameScene.forceActiveFocus();
                }


                nMinWidth: 0
                nMaxWidth: parent.width * 0.7
                nMinHeight: 0
                nMaxHeight: parent.height * 0.7
                //最小为2行，最大为3.5行
                //nMinHeight: parseInt((textArea.contentHeight) / textArea.lineCount) * 2 + textArea.nPadding * 2
                //nMaxHeight: parseInt((textArea.contentHeight) / textArea.lineCount) * 3.5 + textArea.nPadding * 2


                onSg_over: {
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


            Component.onCompleted: {
                _private.arrGameComponents.unshift(this);
            }
            Component.onDestruction: {
                //over(-1); //加上可能会在 释放环境后 才运行用户回调函数，然后导致报错；


                for(let i in _private.arrGameComponents) {
                    if(_private.arrGameComponents[i] === this) {
                        delete _private.arrGameComponents[i];
                        break;
                    }
                }
            }
        }
    }

    //游戏选择菜单
    Component {
        id: compGameMenu

        Item {
            id: rootGameMenu
            objectName: 'GameMenu'


            function over(index=-2) {
                if(rootGameMenu.nShowStatus === -1)
                    return;

                rootGameMenu.nShowStatus = -1;


                //默认回调函数
                let callback = function(index, itemMenu) {

                    itemMenu.visible = false;
                    itemMenu.destroy();

                    //game.pause(true)[pauseGame]
                    if($CommonLibJS.isString(pauseGame) && pauseGame && _private.config.objPauseNames[pauseGame] !== undefined) {
                        //如果没有使用yield来中断代码，可以不要game.run(true)
                        game.goon(pauseGame);
                        //game.run({Script: true, Value: index});
                        //_private.scriptQueue.run(index);
                        return true;
                    }
                    //rootGameScene.forceActiveFocus();

                    return false;
                };


                if($CommonLibJS.checkCallable(rootGameMenu.fCallback, 0b11)) {   //用户自定义回调函数，参数为callback和它所需要的参数
                    game.async([rootGameMenu.fCallback.call(rootGameMenu, callback, index, rootGameMenu) ?? null, 'Game menu callback']);
                }
                else {  //默认回调函数
                    callback(index, rootGameMenu);


                    //rootGameMenu.visible = false;
                    //rootGameMenu.destroy();


                    ////$Frame.goon();
                }
            }

            function show(title='', items=[], style={}, _pauseGame=true, callback=true) {
                rootGameMenu.pauseGame = _pauseGame;
                rootGameMenu.fCallback = callback;

                if(pauseGame === true)
                    pauseGame = '$menu_' + itemGameMenus.nIndex;
                //是否暂停游戏
                if($CommonLibJS.isString(pauseGame)) {
                    //loaderGameMsg.bPauseGame = true;
                    game.pause(pauseGame);
                }
                else {
                }


                //样式
                if(!style)
                    style = {};
                const styleSystem = $GameMakerGlobalJS.$config.$styles.$menu;
                const styleUser = $CommonLibJS.getObjectValue(game.$userscripts, '$config', '$styles', '$menu') || styleSystem;
                let tn;

                maskMenu.color = style.MaskColor || styleUser.$maskColor || styleSystem.$maskColor;
                menuGame.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
                menuGame.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
                tn = style.ItemHeight || styleUser.$itemHeight || styleSystem.$itemHeight;
                if(tn > 0)
                    menuGame.nItemHeight = tn;
                tn = style.ItemMaxHeight || styleUser.$itemMaxHeight || styleSystem.$itemMaxHeight;
                if(tn > 0)
                    menuGame.nItemMaxHeight = tn;
                tn = style.ItemMinHeight || styleUser.$itemMinHeight || styleSystem.$itemMinHeight;
                if(tn > 0)
                    menuGame.nItemMinHeight = tn;
                tn = style.TitleHeight || styleUser.$titleHeight || styleSystem.$titleHeight;
                if(tn > 0)
                    menuGame.nTitleHeight = tn;
                tn = style.ItemFontSize || style.FontSize || styleUser.$itemFontSize || styleSystem.$itemFontSize;
                //if(tn > 0)
                menuGame.rItemFontSize = tn;
                menuGame.colorItemFontColor = style.ItemFontColor || style.FontColor || styleUser.$itemFontColor || styleSystem.$itemFontColor;
                menuGame.colorItemColor1 = style.ItemBackgroundColor1 || style.BackgroundColor || styleUser.$itemBackgroundColor1 || styleSystem.$itemBackgroundColor1;
                menuGame.colorItemColor2 = style.ItemBackgroundColor2 || style.BackgroundColor || styleUser.$itemBackgroundColor2 || styleSystem.$itemBackgroundColor2;
                tn = style.TitleFontSize || style.FontSize || styleUser.$titleFontSize || styleSystem.$titleFontSize;
                //if(tn > 0)
                menuGame.rTitleFontSize = tn;
                menuGame.colorTitleColor = style.TitleBackgroundColor || style.BackgroundColor || styleUser.$titleBackgroundColor || styleSystem.$titleBackgroundColor;
                menuGame.colorTitleFontColor = style.TitleFontColor || style.FontColor || styleUser.$titleFontColor || styleSystem.$titleFontColor;
                menuGame.colorItemBorderColor = style.ItemBorderColor || style.BorderColor || styleUser.$itemBorderColor || styleSystem.$itemBorderColor;

                menuGame.strTitle = title;


                rootGameMenu.nShowStatus = 1;

                rootGameMenu.visible = true;


                menuGame.show(items);

            }


            //signal sg_choice(int index)


            //第几个Menu
            //property int nIndex
            //显示状态：-1：停止；1：正在显示
            property int nShowStatus: -1

            property var pauseGame: true
            property var fCallback   //点击后的回调函数，true为缺省

            property alias mask: maskMenu
            property alias menu: menuGame
            property alias background: rectMenuGameBackground


            //anchors.fill: parent
            width: parent.width
            height: parent.height
            visible: false



            Mask {
                id: maskMenu

                anchors.fill: parent

                visible: color.a !== 0
                //opacity: 0

                //color: Global.style.backgroundColor
                color: '#60000000'
                //radius: 9
            }

            Rectangle {
                id: rectMenuGameBackground
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

                    width: parent.width
                    height: parent.height
                    //height: parent.height / 2
                    //anchors.centerIn: parent

                    //radius: rootGameMenu.radius

                    nTitleHeight: implicitHeight
                    nItemMinHeight: 50
                    nItemHeight: -1 //implicitHeight
                    colorTitleColor: '#EE00CC99'
                    strTitle: ''
                    nWrapMode: TextEdit.WordWrap

                    onSg_choice: rootGameMenu.over(index);
                }
            }


            Component.onCompleted: {
                _private.arrGameComponents.unshift(this);
            }
            Component.onDestruction: {
                //over(-1); //加上可能会在 释放环境后 才运行用户回调函数，然后导致报错；


                for(let i in _private.arrGameComponents) {
                    if(_private.arrGameComponents[i] === this) {
                        delete _private.arrGameComponents[i];
                        break;
                    }
                }
            }
        }
    }

    //游戏 输入框
    Component {
        id: compGameInput

        Item {
            id: rootGameInput
            objectName: 'GameInput'


            function over(text=null) {
                if(rootGameInput.nShowStatus === -1)
                    return;

                rootGameInput.nShowStatus = -1;


                //默认回调函数
                let callback = function(text, itemInput) {

                    itemInput.visible = false;
                    //itemInput.destroy();

                    //game.pause(true)[pauseGame]
                    if($CommonLibJS.isString(pauseGame) && pauseGame && _private.config.objPauseNames[pauseGame] !== undefined) {
                        //如果没有使用yield来中断代码，可以不要game.run(true)
                        game.goon(pauseGame);
                        //game.run({Script: true, Value: text});
                        //_private.scriptQueue.run(text);
                        return true;
                    }
                    //rootGameScene.forceActiveFocus();

                    return false;
                };


                if($CommonLibJS.checkCallable(rootGameInput.fCallback, 0b11)) {   //用户自定义回调函数，参数为callback和它所需要的参数
                    game.async([rootGameInput.fCallback.call(rootGameInput, callback, text, rootGameInput) ?? null, 'Game input callback']);
                }
                else {   //默认回调函数
                    callback(text, rootGameInput);


                    //rootGameInput.visible = false;
                    //rootGameInput.destroy();


                    /* /*if(rootGameInput.bPauseGame && _private.config.bPauseGame) {
                        game.goon();
                        rootGameInput.bPauseGame = false;
                    }* /*/

                    /*if(_private.config.objPauseNames['$input'] !== undefined) {
                        game.goon('$input');
                        _private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
                    }*/


                    ////$Frame.goon();
                }
            }

            function show(title='', pretext='', style={}, _pauseGame=true, callback=true) {
                rootGameInput.pauseGame = _pauseGame;
                rootGameInput.fCallback = callback;

                if(pauseGame === true)
                    pauseGame = '$input';
                //是否暂停游戏
                if($CommonLibJS.isString(pauseGame)) {
                    //loaderGameMsg.bPauseGame = true;
                    game.pause(pauseGame);
                }
                else {
                }



                //样式
                if(!style)
                    style = {};
                const styleSystem = $GameMakerGlobalJS.$config.$styles.$input;
                const styleUser = $CommonLibJS.getObjectValue(game.$userscripts, '$config', '$styles', '$input') || styleSystem;
                let tn;

                rectGameInput.color = style.BackgroundColor || styleUser.$backgroundColor || styleSystem.$backgroundColor;
                rectGameInput.border.color = style.BorderColor || styleUser.$borderColor || styleSystem.$borderColor;
                tn = style.FontSize || styleUser.$fontSize || styleSystem.$fontSize;
                if(tn < 0)
                    textGameInput.font.pixelSize = -tn;
                else
                    textGameInput.font.pixelSize = tn * $fontPointRatio;
                    //textGameInput.font.pointSize = tn;
                textGameInput.textArea.color = style.FontColor || styleUser.$fontColor || styleSystem.$fontColor;

                tn = style.TitleHeight || styleUser.$titleHeight || styleSystem.$titleHeight;
                if(tn > 0)
                    rectGameInputTitle.Layout.preferredHeight = tn;
                else
                    rectGameInputTitle.Layout.preferredHeight = -1;

                rectGameInputTitle.color = style.TitleBackgroundColor || styleUser.$titleBackgroundColor || styleSystem.$titleBackgroundColor;
                rectGameInputTitle.border.color = style.TitleBorderColor || styleUser.$titleBorderColor || styleSystem.$titleBorderColor;

                tn = style.TitleFontSize || styleUser.$titleFontSize || styleSystem.$titleFontSize;
                if(tn < 0)
                    textGameInputTitle.font.pixelSize = -tn;
                else
                    textGameInputTitle.font.pixelSize = tn * $fontPointRatio;
                    //textGameInputTitle.font.pointSize = tn;
                textGameInputTitle.color = style.TitleFontColor || styleUser.$titleFontColor || styleSystem.$titleFontColor;

                maskGameInput.color = style.MaskColor || styleUser.$maskColor || styleSystem.$maskColor;

                textGameInputTitle.text = title;
                textGameInput.text = pretext;
                textGameInput.textArea.cursorPosition = textGameInput.text.length;

                textGameInput.textArea.focus = true;


                rootGameInput.nShowStatus = 1;

                rootGameInput.visible = true;
            }



            //显示状态：-1：停止；1：正在显示
            property int nShowStatus: -1

            property var pauseGame
            //回调函数
            property var fCallback

            property alias input: textGameInput
            property alias mask: maskGameInput


            visible: false
            //anchors.fill: parent
            width: parent.width
            height: parent.height



            Mask {
                id: maskGameInput

                anchors.fill: parent

                visible: color.a !== 0
                //opacity: 0

                //color: Global.style.backgroundColor
                color: '#7FFFFFFF'
                //radius: 9

                mouseArea.onPressed: {
                    //rootGameInput.visible = false;
                    //game.goon('$input');
                    //_private.scriptQueue.run(textGameInput.text);
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

                        //！！如果preferredHeight为-1，则先用implicitHeight，如果没有（貌似包括为0）则用height
                        //Layout.preferredHeight: 39
                        Layout.preferredHeight: implicitHeight
                        implicitHeight: Math.max(textGameInputTitle.implicitHeight, 39)
                        //height: Math.max(textGameInputTitle.implicitHeight, 39)

                        color: '#FF0035A8'
                        //color: '#EE00CC99'
                        //radius: itemMenu.radius

                        Text {
                            id: textGameInputTitle

                            anchors.fill: parent


                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            color: 'white'
                            textFormat: TextArea.RichText
                            wrapMode: Text.Wrap

                            //font.pointSize: 16
                            font.bold: true
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


                            //textArea.color: Global.style.foreground
                            //textArea.placeholderTextColor: '#7F7F7F7F'

                            //textArea.enabled: false
                            //textArea.readOnly: true
                            //textArea.wrapMode: Text.Wrap
                            textArea.textFormat: TextArea.PlainText

                            textArea.selectByKeyboard: true
                            textArea.selectByMouse: true


                            //textArea.font.pointSize: 16
                            textArea.font.bold: true


                            /*
                            //implicitWidth: 200
                            //implicitHeight: 40
                            //color: 'transparent'
                            //color: Global.style.backgroundColor
                            border.color: parent.parent.textArea.activeFocus ? Global.style.accent : Global.style.hintTextColor
                            border.width: parent.parent.textArea.activeFocus ? 2 : 1
                            */
                        }
                    }

                    Button {

                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                        text: '确　定'
                        onClicked: rootGameInput.over(textGameInput.text);
                    }
                }
            }


            Component.onCompleted: {
                _private.arrGameComponents.unshift(this);
            }
            Component.onDestruction: {
                //over(''); //加上可能会在 释放环境后 才运行用户回调函数，然后导致报错；


                for(let i in _private.arrGameComponents) {
                    if(_private.arrGameComponents[i] === this) {
                        delete _private.arrGameComponents[i];
                        break;
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

            anchors.rightMargin: 16 * $Global.pixelDensity
            anchors.bottomMargin: 8 * $Global.pixelDensity

            //anchors.verticalCenterOffset: -100
            //anchors.horizontalCenterOffset: -100

            width: 6 * $Global.pixelDensity
            height: 6 * $Global.pixelDensity


            color: 'white'
        }

    }


    //角色
    Component {
        id: compRole

        Role {
            id: rootRole


            //返回各种坐标
            function pos(tPos=null) {
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
                if($CommonLibJS.isString(data))
                    data = {RID: data};

                GameSceneJS.getSpriteEffect(data, rootRole.customSprite, {Loops: data.$loops ?? 1});

                if($CommonLibJS.isValidNumber(data.$width))
                    rootRole.customSprite.width = data.$width;
                if($CommonLibJS.isValidNumber(data.$height))
                    rootRole.customSprite.height = data.$height;
                rootRole.customSprite.x = data.$x ?? 0;
                rootRole.customSprite.y = data.$y ?? 0;

                rootRole.customSprite.playSprite();
            }
            */
            function playSprite(data) {
                if($CommonLibJS.isString(data))
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
                //GameSceneJS.getSpriteEffect(data, sprite, {Loops: data.$loops ?? 1});
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
                anchors.bottom: rootRole.rectName.top
                anchors.horizontalCenter: parent.horizontalCenter


                nScrollHorizontal: 0
                nScrollVertical: 1


                textArea.enabled: false
                textArea.readOnly: true
                //textArea.font.pointSize: 16
                //textArea.font.pixelSize: 16


                nMinWidth: 0
                //nMaxWidth: parent.width
                nMinHeight: 0
                //nMaxHeight: 66
                //最小为1行，最大为1.5行
                //nMinHeight: parseInt((textArea.contentHeight) / textArea.lineCount) * 1 + textArea.nPadding * 2
                nMaxHeight: parseInt((textArea.contentHeight) / textArea.lineCount) * 1.5 + textArea.nPadding * 2


                onSg_over: {
                    visible = false;
                }
            }

            //名字背景
            property Rectangle rectName: Rectangle {
                parent: rootRole
                visible: true
                //width: parent.width
                width: textName.implicitWidth
                height: textName.implicitHeight
                anchors.bottom: parent.top
                anchors.horizontalCenter: parent.horizontalCenter

                color: 'transparent'
            }

            //名字
            property Text textName: Text {
                parent: rectName
                /*visible: true
                width: parent.width
                height: implicitHeight
                anchors.bottom: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                */
                anchors.fill: parent


                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                text: (rootRole.$data && rootRole.$data.$name) ? rootRole.$data.$name : ''
                color: 'white'
                textFormat: Text.RichText
                wrapMode: Text.NoWrap

                //font.pointSize: 9
                font.bold: true
            }


            //依附在角色上的图片和特效
            property var $tmpComponents: ({})

            //属性
            //property int $index: -1
            //property string $id: ''


            //自定义属性（也包含系统一些常用属性，比如$id、$index、$name、$showName、$avatar、$avatarSize等）
            //主角的会被保存到存档，NPC不会
            property var $data: null
            //其他属性（用户自定义）
            //目前只用到 $$running_backup
            property var $props: ({})

            property var $info: null //json文件
            property var $script: null //js脚本
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
            //bSmooth: true


            //strSource: './Role2.png'
            //sizeFrame: Qt.size(32, 48)
            //nFrameCount: 4
            //objActionsData: {'$Up': [0,3],'$Right': [0,2],'$Down': [0,0],'$Left': [0,1]}


            sprite.onSg_started: {
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

                if(tScript) //$CommonLibJS.checkCallable(tScript, 0b11)
                    game.async([tScript.call(rootRole, strActionName, rootRole) ?? null, eventName]);
            }

            sprite.onSg_refreshed: {
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

                if(tScript) //$CommonLibJS.checkCallable(tScript, 0b11)
                    game.async([tScript.call(rootRole, currentFrame, strActionName, rootRole) ?? null, eventName]);
            }

            sprite.onSg_looped: {
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

                if(tScript) //$CommonLibJS.checkCallable(tScript, 0b11)
                    game.async([tScript.call(rootRole, strActionName, rootRole) ?? null, eventName]);
            }

            sprite.onSg_finished: {
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

                if(tScript) //$CommonLibJS.checkCallable(tScript, 0b11)
                    game.async([tScript.call(rootRole, strActionName, rootRole) ?? null, eventName]);
            }

            sprite.onSg_paused: {
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

                if(tScript) //$CommonLibJS.checkCallable(tScript, 0b11)
                    game.async([tScript.call(rootRole, strActionName, rootRole) ?? null, eventName]);
            }

            sprite.onSg_stoped: {
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

                if(tScript) //$CommonLibJS.checkCallable(tScript, 0b11)
                    game.async([tScript.call(rootRole, strActionName, rootRole) ?? null, eventName]);
            }


            mouseArea.onClicked: {
                GameSceneJS.roleClickEvent(rootRole, mouse.x, mouse.y);
            }


            Component.onCompleted: {
                //console.debug('[GameScene]Role Component.onCompleted');


                const styleSystem = $GameMakerGlobalJS.$config.$role;
                const styleUser = $CommonLibJS.getObjectValue(game.$userscripts, '$config', '$role') || styleSystem;
                let tn;

                bSmooth = $CommonLibJS.shortCircuit(0b1, $CommonLibJS.getObjectValue(styleUser, '$smooth'), $CommonLibJS.getObjectValue(styleSystem, '$smooth'), true);


                textName.color = $CommonLibJS.getObjectValue(styleUser, '$name', '$fontColor') ?? styleSystem.$name.$fontColor;
                tn = $CommonLibJS.getObjectValue(styleUser, '$name', '$fontSize') ?? styleSystem.$name.$fontSize;
                if(tn < 0)
                    textName.font.pixelSize = -tn;
                else
                    textName.font.pixelSize = tn * $fontPointRatio;
                    //textName.font.pointSize = tn;

                rectName.color = $CommonLibJS.getObjectValue(styleUser, '$name', '$backgroundColor') ?? styleSystem.$name.$backgroundColor;
                rectName.border.color = $CommonLibJS.getObjectValue(styleUser, '$name', '$borderColor') ?? styleSystem.$name.$borderColor;
            }
        }
    }


    //音效（目前引擎没用到）
    Component {
        id: compCacheSoundEffect

        SoundEffect { //wav格式，实时性高
            function isPlaying() {
                return playing;
            }


            //volume: rootSoundEffect.rVolume

            property var fnPlayingCallback: null
            property var fnStatusChangedCallback: null


            //property bool isPlaying: playbackState === Audio.PlayingState
            onPlayingChanged: {
                if(fnPlayingCallback)
                    fnPlayingCallback(playing);
            }
            onStatusChanged: {
                if(fnStateChangedCallback)
                    fnStateChangedCallback(status);
            }
        }
    }
    Component {
        id: compCacheAudio

        Audio { //支持各种格式
            function isPlaying() {
                return playbackState === Audio.PlayingState;
            }
            function isPaused() {
                return playbackState === Audio.PausedState;
            }
            function isStopped() {
                return playbackState === Audio.StoppedState;
            }


            //volume: rootSoundEffect.rVolume

            property var fnPlayingCallback: null
            property var fnStoppedCallback: null
            property var fnPausedCallback: null
            property var fnPlaybackStateChangedCallback: null


            //property bool isPlaying: playbackState === Audio.PlayingState
            onPlaying: {
                if(fnPlayingCallback)
                    fnPlayingCallback();
            }
            onStopped: {
                if(fnStoppedCallback)
                    fnStoppedCallback();
            }
            onPaused: {
                if(fnPausedCallback)
                    fnPausedCallback();
            }
            onPlaybackStateChanged: {
                if(fnPlaybackStateChangedCallback)
                    fnPlaybackStateChangedCallback(playbackState);
            }
        }
    }


    //图片
    Component {
        id: compCacheImage

        //Image {
        AnimatedImage {
            property var $id //一个collection内唯一标识
            //property var $parent //父组件（可以是数字、字符串代号 或 组件）
            property var $collection //哪个集合内
            //组件类型（用来识别）
            readonly property int $componentType: 1

            //回调函数
            property var clicked
            property var doubleClicked
            property var pressed
            property var released
            property var pressAndHold


            visible: false

            smooth: true



            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons  /*Qt.LeftButton | Qt.RightButton*/

                onPressed: {
                    if(parent.pressed) //$CommonLibJS.checkCallable(parent.pressed, 0b11)
                        game.async([parent.pressed.call(parent, parent) ?? null, 'Image onPressed'], );
                }

                onReleased: {
                    if(parent.released) //$CommonLibJS.checkCallable(parent.released, 0b11)
                        game.async([parent.released.call(parent, parent) ?? null, 'Image onReleased'], );
                }

                onPressAndHold: {
                    if(parent.pressAndHold) //$CommonLibJS.checkCallable(parent.pressAndHold, 0b11)
                        game.async([parent.pressAndHold.call(parent, parent) ?? null, 'Image onPressAndHold'], );
                }

                onClicked: {
                    if(parent.clicked) //$CommonLibJS.checkCallable(parent.clicked, 0b11)
                        game.async([parent.clicked.call(parent, parent) ?? null, 'Image onClicked'], );
                }

                onDoubleClicked: {
                    //game.delimage(parent);
                    if(parent.doubleClicked) //$CommonLibJS.checkCallable(parent.doubleClicked, 0b11)
                        game.async([parent.doubleClicked.call(parent, parent) ?? null, 'Image onDoubleClicked'], );
                }
            }


            Component.onCompleted: {
                smooth = GameSceneJS.getCommonScriptResource('$config', '$image', '$smooth') ?? true;
            }
            Component.onDestruction: {
                //console.debug('[GameScene]Component.onDestruction:CacheImage', $id, $collection);
            }
        }
    }

    //特效
    Component {
        id: compCacheSpriteEffect

        SpriteEffect {
            property var $id //一个collection内唯一标识
            //property var $parent //父组件（可以是数字、字符串代号 或 组件）
            property var $collection //哪个集合内
            //组件类型（用来识别）
            readonly property int $componentType: 2

            property var $info: null //json文件
            property var $script: null //js脚本
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

            smooth: true


            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons  /*Qt.LeftButton | Qt.RightButton*/

                onPressed: {
                    if(parent.pressed) //$CommonLibJS.checkCallable(parent.pressed, 0b11)
                        game.async([parent.pressed.call(parent, parent) ?? null, 'SpriteEffect onPressed'], );
                }

                onReleased: {
                    if(parent.released) //$CommonLibJS.checkCallable(parent.released, 0b11)
                        game.async([parent.released.call(parent, parent) ?? null, 'SpriteEffect onReleased'], );
                }

                onPressAndHold: {
                    if(parent.pressAndHold) //$CommonLibJS.checkCallable(parent.pressAndHold, 0b11)
                        game.async([parent.pressAndHold.call(parent, parent) ?? null, 'SpriteEffect onPressAndHold'], );
                }

                onClicked: {
                    if(parent.clicked) //$CommonLibJS.checkCallable(parent.clicked, 0b11)
                        game.async([parent.clicked.call(parent, parent) ?? null, 'SpriteEffect onClicked'], );
                }

                onDoubleClicked: {
                    //game.delsprite(parent);
                    if(parent.doubleClicked) //$CommonLibJS.checkCallable(parent.doubleClicked, 0b11)
                        game.async([parent.doubleClicked.call(parent, parent) ?? null, 'SpriteEffect onDoubleClicked'], );
                }
            }

            onSg_looped: {
                if(looped) //$CommonLibJS.checkCallable(looped, 0b11)
                    game.async([looped.call(this, this) ?? null, 'SpriteEffect onSg_looped'], );
            }

            onSg_finished: {
                //game.delsprite(parent);
                if(finished) //$CommonLibJS.checkCallable(finished, 0b11)
                    game.async([finished.call(this, this) ?? null, 'SpriteEffect onSg_finished'], );
                else
                    visible = false;
            }


            onSg_playSoundEffect: {
                game.playsoundeffect(soundeffectSource, -1);
            }

            Component.onCompleted: {
                smooth = GameSceneJS.getCommonScriptResource('$config', '$spriteEffect', '$smooth') ?? true;
            }
            Component.onDestruction: {
                //console.debug('[GameScene]Component.onDestruction:CacheSpriteEffect', $id, $collection);
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
        //忽略没有的信号
        ignoreUnknownSignals: true

        function onStateChanged() {
            switch(Qt.application.state) {
            case Qt.ApplicationActive: { //每次窗口激活时触发
                    _private.arrPressedKeys = [];
                    //mainRole.$$nMoveDirectionFlag = 0;


                    let value;
                    if(!(GameSceneJS.getCommonScriptResource('$config', '$game', '$inactiveBackgroundMusic') ?? false))
                        itemBackgroundMusic.resume('$sys_inactive');

                    value = GameSceneJS.getCommonScriptResource('$config', '$game', '$inactiveSoundEffect') ?? 0b10;
                    if((value & 0b1) === 0)
                        rootSoundEffect.resume('$sys_inactive');
                    if((value & 0b10) === 0)
                        rootSoundEffect.bMuted = false;

                    value = GameSceneJS.getCommonScriptResource('$config', '$game', '$inactiveVideo') ?? 1;
                    if(value === 0)
                        mediaPlayer.play(); //!这里应该改为和 music 和 soundeffect 一样的暂停，但无所谓了
                    else if(value === 1)
                        mediaPlayer.muted = false;
                }

                break;
            case Qt.ApplicationInactive: { //每次窗口非激活时触发
                    _private.arrPressedKeys = [];
                    //mainRole.$$nMoveDirectionFlag = 0;


                    let value;
                    if(!(GameSceneJS.getCommonScriptResource('$config', '$game', '$inactiveBackgroundMusic') ?? false))
                        itemBackgroundMusic.pause('$sys_inactive');

                    value = GameSceneJS.getCommonScriptResource('$config', '$game', '$inactiveSoundEffect') ?? 0b10;
                    if((value & 0b1) === 0)
                        rootSoundEffect.pause('$sys_inactive');
                    if((value & 0b10) === 0)
                        rootSoundEffect.bMuted = true;

                    value = GameSceneJS.getCommonScriptResource('$config', '$game', '$inactiveVideo') ?? 1;
                    if(value === 0)
                        mediaPlayer.pause(); //!这里应该改为和 music 和 soundeffect 一样的暂停，但无所谓了
                    else if(value === 1)
                        mediaPlayer.muted = true;
                }

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

    Connections {
        target: rootWindow
        //忽略没有的信号
        ignoreUnknownSignals: true

        //function onSg_signalHandler(v) {
        //}
        function onSg_messageHandler(msgType, msg) {
        }
        function onRAspectRatioChanged() {
            setSceneToRole();
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

    /*Keys.onEscapePressed: function(event) {
        //sg_close();
        _private.showExitDialog();
        event.accepted = true;

        console.debug('[GameScene]Keys.onEscapePressed');
    }
    Keys.onBackPressed: function(event) {
        //sg_close();
        _private.showExitDialog();
        event.accepted = true;

        console.debug('[GameScene]Keys.onBackPressed');
    }
    */

    Keys.onTabPressed: {
        rootGameScene.forceActiveFocus();
        event.accepted = true;

        console.debug('[GameScene]Keys.onTabPressed');
    }
    Keys.onSpacePressed: {
        event.accepted = true;

        //if(game.pause(null) && $Frame.sl_simulatedMouseClick)
        //    $Frame.sl_simulatedMouseClick(game.$sys.screen.width / 2, game.$sys.screen.height / 2);
        console.debug('[GameScene]Keys.onSpacePressed');
    }



    Keys.onPressed: function(event) {   //键盘按下
        console.debug('[GameScene]Keys.onPressed:', event, event.key, event.text, event.isAutoRepeat);

        //if(!_private.config.bKeyboard)
        //    return;


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


            if(mainRole.$$nActionType !== -1 &&
                    $CommonLibJS.objectIsEmpty(_private.config.objPauseNames)) {
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


            GameSceneJS.buttonAClicked();


            event.accepted = true;

            break;

        default:
            const fn = GameSceneJS.getCommonScriptResource('$config', '$keys', event.key) ?? null;
            if(fn) //$CommonLibJS.checkCallable(fn, 0b11)
                game.async([fn(true, event) ?? null, 'Keys.onPressed:' + event.key]);
            else {
                if(event.key === Qt.Key_Escape || event.key === Qt.Key_Back)
                    _private.exitGame();
            }

            event.accepted = true;
        }
    }

    Keys.onReleased: function(event) {
        console.debug('[GameScene]Keys.onReleased:', event.key, event.isAutoRepeat);

        //if(!_private.config.bKeyboard)
        //    return;


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


            if(mainRole.$$nActionType !== -1 &&
                    $CommonLibJS.objectIsEmpty(_private.config.objPauseNames)) {
                _private.stopMove(1, event.key);
            }

            event.accepted = true;

            break;

        default:
            const fn = GameSceneJS.getCommonScriptResource('$config', '$keys', event.key) ?? null;
            if(fn) //$CommonLibJS.checkCallable(fn, 0b11)
                game.async([fn(false, event) ?? null, 'Keys.onReleased:' + event.key]);

            event.accepted = true;
        }


        //console.debug('[GameScene]timer', timer.running);
    }



    Component.onCompleted: {
        $Frame.sl_globalObject().game = game;
        $Frame.sl_globalObject().g = game;

        Object.defineProperty(game, 'time', {
            enumerable: false,
            configurable: true,
            get() {
                //return Number(new Date());
                return new Date().getTime();
            },
            //set(value) {},
        });
        /*Object.defineProperty(game, 'http', {
            enumerable: false,
            configurable: true,
            get() {
                return new XMLHttpRequest;
            },
            //set(value) {},
        });
        */

        //console.debug('[GameScene]sl_globalObject：', $Frame.sl_globalObject());

        console.debug('[GameScene]Component.onCompleted:', Qt.resolvedUrl('.'), game, $Frame.sl_globalObject().game);
    }

    Component.onDestruction: {
        //release();
        //console.warn('', Object.keys(_private.config.objPauseNames));
        //console.warn('3', _private.scriptQueue.getScriptInfos().$$toJson());


        //鹰：有可能多次创建GameScene，所以要删除最后一次赋值的（比如热重载地图测试时，不过已经解决了）；
        if($Frame.sl_globalObject().game === game) {
            delete $Frame.sl_globalObject().game;
            delete $Frame.sl_globalObject().g;
        }
        else
            console.warn('[!GameScene]game被多次创建？');

        console.debug('[GameScene]Component.onDestruction:', Qt.resolvedUrl('.'));
    }
}
