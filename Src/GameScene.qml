import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.2 as Dialog1
import QtQuick.Layouts 1.14
import QtMultimedia 5.14
import Qt.labs.settings 1.1


import _Global 1.0
import _Global.Button 1.0


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
    game.addgtimer("$sys_random_fight_timer", 1000, -1)：战斗定时
    game.gf["$sys_random_fight_timer"]：战斗事件
    game.addgtimer("$sys_resume_timer", 1000, -1)：恢复定时
    game.gf["$sys_resume_timer"]：恢复事件
    game.gf["$sys_fight_skill_algorithm"]：战斗算法
    game.gf["$sys_fight_start_stript"]：战斗开始通用脚本
    game.gf["$sys_fight_round_stript"]：战斗回合通用脚本
    game.gf["$sys_fight_end_stript"]：战斗结束通用脚本（升级经验、获得金钱）
    game.gf["$sys_levelup_script"]：升级脚本（经验等条件达到后升级和结果）
    game.gf["$sys_level_Algorithm"]：升级算法（直接升级对经验等条件的影响）

    game.gd["$sys_fight_heros"]：我方所有战斗人员列表
    game.gd["$sys_money"]: 金钱
    game.gd["$sys_goods"]: 道具道具 列表（存的是{id: goodsId, count: count}）
    game.gd["$sys_map"]: 当前地图名
    game.gd["$sys_pos"]: 主角当前坐标
    game.gd["$sys_main_roles"]: 当前主角文件名列表
    game.gd["$music"]: 当前播放的音乐名
    game.gd["$scale"]: 当前缩放大小
*/



Rectangle {

    id: root


    signal s_close();
    onS_close: {
        if(!bTest)
            game.save("");  //存档

        //GameManager.goon();
        dialogGameMsg.visible = false;
        dialogRoleMsg.visible = false;
        gameMenuWindow.visible = false;
        gameMenuWindow.init();
        rectMenu.visible = false;

        game.d = {};
        game.f = {};
        game.gd = {};
        game.gf = {};
        game.delallroles();
        _private.objTimers = {};
        _private.arrMainRoles = [];
        _private.objSkills = {};
        _private.objGoods = {};
        _private.objSprites = {};

        _private.asyncScript.clear();

        mainRole.spriteSrc = "";
        mainRole.nFrameCount = 0;
        mainRole.width = 0;
        mainRole.height = 0;
        mainRole.x1 = 0;
        mainRole.y1 = 0;
        mainRole.width1 = 0;
        mainRole.height1 = 0;
        mainRole.offsetMove = 0.3;
        mainRole.refresh();

        loaderFightScene.visible = false;
        itemBackgroundMusic.stop();
        timer.stop();
        game.scale(1);


        for(let tc in itemBackMapContainer.arrCanvas) {
            itemBackMapContainer.arrCanvas[tc].unloadImage(imageMapBlock.source);
            _private.clearCanvas(itemBackMapContainer.arrCanvas[tc]);
        }
        for(let tc in itemFrontMapContainer.arrCanvas) {
            itemFrontMapContainer.arrCanvas[tc].unloadImage(imageMapBlock.source);
            _private.clearCanvas(itemFrontMapContainer.arrCanvas[tc]);
        }

        //canvasBackMap.unloadImage(imageMapBlock.source);
        //canvasFrontMap.unloadImage(imageMapBlock.source);
        imageMapBlock.source = "";

        console.debug("[GameScene]Close");
    }


    property alias g: root.game
    property QtObject game: QtObject {
        readonly property var loadmap: function(mapName) {
            game.d = {};
            game.f = {};
            game.delallroles();
            _private.objTimers = {};

            openMap(mapName);
            game.gd["$sys_map"] = mapName;


            //执行载入地图脚本
            if(itemContainer.mapInfo.SystemEventData !== undefined && itemContainer.mapInfo.SystemEventData["$1"] !== undefined) {
                if(GlobalJS.createScript(_private.asyncScript, 0, itemContainer.mapInfo.SystemEventData["$1"]) === 0)
                    return _private.asyncScript.run();
            }
        }
        readonly property var setmap: setMainRolePos
        readonly property var map: {
            name: ""
        }

        readonly property var msg: function(msg, pauseGame=true, buttonNum) {

            //是否暂停游戏
            if(pauseGame) {
                game.pause();

                //dialogGameMsg.focus = true;
            }
            else {
            }



            //按钮数
            buttonNum = parseInt(buttonNum);

            /*if(buttonNum === 1)
                dialogGameMsg.standardButtons = Dialog.Ok;
            else if(buttonNum === 2)
                dialogGameMsg.standardButtons = Dialog.Ok | Dialog.Cancel;
            else
                dialogGameMsg.standardButtons = Dialog.NoButton;
            */



            dialogGameMsg.show(msg, "", 100, 1);
        }

        readonly property var menu: function(title, items, pauseGame=true) {

            //是否暂停游戏
            if(pauseGame) {
                game.pause();
            }
            else {
            }

            rectMenu.visible = true;
            textMenuTitle.text = title;
            menuGame.show(items);

        }

        readonly property var say: function(msg, role, pauseGame=true) {
            //console.debug("say1")

            //是否暂停游戏
            if(pauseGame) {
                game.pause();

                //dialogGameMsg.focus = true;
            }
            else {
            }


            if(role) {
                dialogRoleMsg.show(msg, _private.objRoles[role].name + "：", 100, 1);
            }
            else
                dialogRoleMsg.show(msg, "", 100, 1);

            //console.debug("say2")
        }

        readonly property var createhero: function(heroName, gameName) {

            let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strRoleDirName + Platform.separator() + heroName + Platform.separator() + "role.json";
            //let cfg = File.read(filePath);
            let cfg = GameManager.sl_qml_ReadFile(filePath);
            console.debug("[GameScene]createhero：filePath：", filePath);

            if(cfg === "") {
                console.warn("[!GameScene]角色读取失败：", cfg);
                return false;
            }
            cfg = JSON.parse(cfg);


            if(_private.arrMainRoles[0] !== undefined) {
                console.warn("[!GameScene]已经有主角：", cfg);
                return false;
            }

            //let role = compRole.createObject(itemRoleContainer);
            _private.arrMainRoles[0] = mainRole;
            game.gd["$sys_main_roles"][0] = {HeroName: heroName, GameName: gameName};


            mainRole.name = gameName || cfg.RoleName;

            mainRole.spriteSrc = Global.toQMLPath(GameMakerGlobal.roleResourceURL(cfg.Image));
            mainRole.sizeFrame = Qt.size(parseInt(cfg.FrameSize[0]), parseInt(cfg.FrameSize[1]));
            mainRole.nFrameCount = parseInt(cfg.FrameCount);
            mainRole.arrFrameDirectionIndex = cfg.FrameIndex;
            mainRole.interval = parseInt(cfg.FrameInterval);
            //mainRole.implicitWidth = parseInt(cfg.RoleSize[0]);
            //mainRole.implicitHeight = parseInt(cfg.RoleSize[1]);
            mainRole.width = parseInt(cfg.RoleSize[0]);
            mainRole.height = parseInt(cfg.RoleSize[1]);
            mainRole.x1 = parseInt(cfg.RealOffset[0]);
            mainRole.y1 = parseInt(cfg.RealOffset[1]);
            mainRole.width1 = parseInt(cfg.RealSize[0]);
            mainRole.height1 = parseInt(cfg.RealSize[1]);
            mainRole.offsetMove = parseFloat(cfg.MoveSpeed);

            mainRole.refresh();

            //console.debug("[GameScene]createhero：mainRole：", JSON.stringify(cfg));

            return true;
        }

        readonly property var createrole: function(roleName, gameName, bx, by, actionType=1, direction=undefined) {

            let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strRoleDirName + Platform.separator() + roleName + Platform.separator() + "role.json";
            //let cfg = File.read(filePath);
            let cfg = GameManager.sl_qml_ReadFile(filePath);
            //console.debug("[GameScene]createRole：filePath：", filePath);

            if(cfg === "")
                return false;
            cfg = JSON.parse(cfg);


            let name = gameName || cfg.RoleName || roleName;

            if(_private.objRoles[name] !== undefined)
                return false;

            let role = compRole.createObject(itemRoleContainer);
            role.direction = -1;

            role.name = name;

            role.spriteSrc = Global.toQMLPath(GameMakerGlobal.roleResourceURL(cfg.Image));
            role.sizeFrame = Qt.size(parseInt(cfg.FrameSize[0]), parseInt(cfg.FrameSize[1]));
            role.nFrameCount = parseInt(cfg.FrameCount);
            role.arrFrameDirectionIndex = cfg.FrameIndex;
            role.interval = parseInt(cfg.FrameInterval);
            //role.implicitWidth = parseInt(cfg.RoleSize[0]);
            //role.implicitHeight = parseInt(cfg.RoleSize[1]);
            role.width = parseInt(cfg.RoleSize[0]);
            role.height = parseInt(cfg.RoleSize[1]);
            role.x1 = parseInt(cfg.RealOffset[0]);
            role.y1 = parseInt(cfg.RealOffset[1]);
            role.width1 = parseInt(cfg.RealSize[0]);
            role.height1 = parseInt(cfg.RealSize[1]);
            role.offsetMove = parseFloat(cfg.MoveSpeed);
            role.nActionType = actionType;
            role.test = true;

            role.refresh();
            role.changeDirection(direction);

            _private.objRoles[name] = role;


            if(bx !== undefined && by !== undefined) {
                moverole(name, bx, by);
            }

            return true;

        }

        readonly property var moverole: function(roleGameName, bx, by) {

            //边界检测

            if(bx < 0)
                bx = 0;
            else if(bx >= itemContainer.mapInfo.MapSize[0])
                bx = itemContainer.mapInfo.MapSize[0] - 1;

            if(by < 0)
                by = 0;
            else if(by >= itemContainer.mapInfo.MapSize[1])
                by = itemContainer.mapInfo.MapSize[1] - 1;


            let role = _private.objRoles[roleGameName];

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

        readonly property var delrole: function(roleGameName) {
            let role = _private.objRoles[roleGameName];
            if(role === undefined)
                return false;

            role.destroy();
            delete _private.objRoles[roleGameName];

            return true;
        }

        readonly property var delallroles: function() {
            for(let r in _private.objRoles) {
                _private.objRoles[r].destroy();
            }
            _private.objRoles = {};
        }

        readonly property var money: function(m) {
            if(!game.gd["$sys_money"]) {
                game.gd["$sys_money"] = 0;
            }
            if(m)
                game.gd["$sys_money"] += m;
            return game.gd["$sys_money"];
        }

        readonly property var createfighthero: function(name, showName) {
            if(game.gd["$sys_fight_heros"] === undefined)
                game.gd["$sys_fight_heros"] = [];

            let tfh = GameMakerGlobalJS.createCombatants(name);
            tfh.id = name;
            game.gd["$sys_fight_heros"].push(tfh);
            return tfh;
        }
        readonly property var deletefighthero: function(n) {
            if(n === -1) {
                game.gd["$sys_fight_heros"] = [];
                return true;
            }

            if(game.gd["$sys_fight_heros"] === undefined)
                return false;

            if(GlobalLibraryJS.isValidNumber(n)) {
                game.gd["$sys_fight_heros"].splice(n,1);
                return true;
            }
            else
                return false;
        }

        /*readonly property var createfightenemy: function(name) {
            loaderFightScene.item.enemies.push(GameMakerGlobalJS.createCombatants(name));

        }*/

        readonly property var fighthero: function(n=null, type=1) {
            if(game.gd["$sys_fight_heros"] === undefined)
                return [];


            if(type === 0) {//只返回名字
                if(GlobalLibraryJS.isValidNumber(n))    //1个
                    return game.gd["$sys_fight_heros"][n].name;
                else    //所有
                {
                    let arrName = [];
                    for(let th of game.gd["$sys_fight_heros"])
                        arrName.push(th.name);
                    return arrName;
                }
            }
            else {  //返回所有信息

                if(GlobalLibraryJS.isValidNumber(n))//返回hero对象
                    return game.gd["$sys_fight_heros"][n];
                else {//返回所有heros对象的列表
                    return game.gd["$sys_fight_heros"];
                }
            }
        }

        readonly property var getskill: function(heroIndex, skillName, skillIndex=-1) {
            if(heroIndex >= game.gd["$sys_fight_heros"].length || heroIndex < 0)
                return false;
            if(skillIndex < 0 || skillIndex >= game.gd["$sys_fight_heros"][heroIndex].skills.length)
                game.gd["$sys_fight_heros"][heroIndex].skills.push({id: skillName});
            else
                game.gd["$sys_fight_heros"][heroIndex].skills[skillIndex] = skillName;
            return true;
        }
        readonly property var removeskill: function(heroIndex, skillIndex=-1) {
            if(heroIndex >= game.gd["$sys_fight_heros"].length || heroIndex < 0)
                return false;
            if(skillIndex < 0)
                game.gd["$sys_fight_heros"][heroIndex].skills = [];
            else if(skillIndex >= game.gd["$sys_fight_heros"][heroIndex].skills.length)
                return false;
            else
                game.gd["$sys_fight_heros"][heroIndex].skills.splice(skillIndex, 1);
            return true;
        }
        readonly property var removeskillname: function(heroIndex, skillName) {
            if(heroIndex >= game.gd["$sys_fight_heros"].length || heroIndex < 0)
                return false;
            /*let skillIndex = game.gd["$sys_fight_heros"][heroIndex].skills.indexOf(skillName);
            if(skillIndex >= 0) {
                game.gd["$sys_fight_heros"][heroIndex].skills.splice(skillIndex, 1);
                return true;
            }*/
            for(let skillIndex = 0; skillIndex < game.gd["$sys_fight_heros"][heroIndex].skills.length; ++skillIndex) {
                if(game.gd["$sys_fight_heros"][heroIndex].skills[skillIndex].id === skillName) {
                    game.gd["$sys_fight_heros"][heroIndex].skills.splice(skillIndex, 1);
                    return true;
                }
            }

            return false;
        }
        readonly property var getexp: function(heroIndex, exp=0) {
            if(heroIndex >= game.gd["$sys_fight_heros"].length || heroIndex < 0)
                return null;
            if(exp) {
                game.gd["$sys_fight_heros"][heroIndex].properties.EXP += exp;
                if(GlobalJS.createScript(_private.asyncScript, 0, game.gf["$sys_levelup_script"](game.gd["$sys_fight_heros"][heroIndex])) === 0)
                    _private.asyncScript.run();
            }

            return game.gd["$sys_fight_heros"][heroIndex].properties.EXP;
        }
        //直接升1级
        readonly property var levelup: function(heroIndex) {
            if(heroIndex >= game.gd["$sys_fight_heros"].length || heroIndex < 0)
                return null;
            let result = game.gf["$sys_level_Algorithm"](game.gd["$sys_fight_heros"][heroIndex],  game.gd["$sys_fight_heros"][heroIndex].properties.level + 1);
            for(let r in result) {  //提取所有条件并设置为满足
                game.gd["$sys_fight_heros"][heroIndex][result[r]] = result[r];
            }
            //升级
            if(GlobalJS.createScript(_private.asyncScript, 0, game.gf["$sys_levelup_script"](game.gd["$sys_fight_heros"][heroIndex])) === 0)
                _private.asyncScript.run();
        }

        //获得或减去count个道具，返回背包中 改变后 道具个数；count为0则直接返回背包中道具个数。
        //如果count<0，且装备数量不够，则返回<0（相差数），原道具数量不变化。
        //返回null表示错误。
        readonly property var getgoods: function(goodsId, count=0) {
            if(goodsId === undefined || goodsId === null)
                return null;
            if(GlobalLibraryJS.isObject(goodsId)) { //如果直接是对象
                count = goodsId.count;
                goodsId = goodsId.id;
            }

            //循环查找goods
            for(let tg in game.gd["$sys_goods"]) {
                //找到
                if(game.gd["$sys_goods"][tg].id === goodsId) {
                    let newCount = game.gd["$sys_goods"][tg].count + count;  //剩余数量

                    if(newCount < 0)  //少于
                        return newCount;
                    else if(newCount === 0)
                        game.gd["$sys_goods"].splice(tg, 1);
                    else
                        game.gd["$sys_goods"][tg].count = newCount;

                    return newCount;
                }
            }

            //如果没有
            if(count <= 0)
                return count;

            game.gd["$sys_goods"].push({id: goodsId, count: count});
            return count;
        }

        //使用道具（会执行道具use脚本）
        readonly property var usegoods: function(goodsId) {
            if(goodsId === undefined || goodsId === null)
                return null;

            /*let heroProperty, heroPropertyNew;

            if(heroIndex === null || heroIndex === undefined || (heroIndex >= game.gd["$sys_fight_heros"].length || heroIndex < 0))
                ;
            else {
                heroProperty = game.gd["$sys_fight_heros"][heroIndex].properties;
                heroPropertyNew = game.gd["$sys_fight_heros"][heroIndex].$$propertiesWithEquipment;
            }*/

            if(_private.objGoods[goodsId]["useScript"])
                game.run(_private.objGoods[goodsId]["useScript"](_private.objGoods[goodsId]));
                //game.run(_private.objGoods[goodsId]["useScript"](_private.objGoods[goodsId]));

            //计算装备后属性
            game.run('for(let heroIndex in game.gd["$sys_fight_heros"])GameMakerGlobalJS.CombatantsPropsWidthGoodsAndEquip(game.gd["$sys_fight_heros"][heroIndex]);');
        }

        //获得道具列表中某项道具详细信息；index为-1表示返回所有道具（此时filterkey和filtervalue是过滤条件）
        //返回格式：单个：{id,count,property}，多个：单个的数组
        readonly property var goods: function(index=-1, filterkey=null, filtervalue=null) {
            if(index >= game.gd["$sys_goods"].length)
                return null;

            if(index > -1)
                return {id: game.gd["$sys_goods"][index].id,
                    count: game.gd["$sys_goods"][index].count,
                    property: game.objGoods[game.gd["$sys_goods"][index].id],
                };


            let ret = [];

            for(let goods of game.gd["$sys_goods"]) {
                if(filterkey && game.objGoods[goods.id][filterkey] === filtervalue)
                ret.push({id: goods.id,
                    count: goods.count,
                    property: game.objGoods[goods.id],
                });
            }

            return ret;
        }

        //背包中是否有某道具，如果有则返回详细信息（getgoods只是返回个数），没有返回null；
        //返回格式：{id,count,property}
        readonly property var hasgoods: function(goodsid=null) {
            if(goodsid)
                return null;

            let ret = [];

            for(let goods of game.gd["$sys_goods"]) {
                if(goodsid === goods.id)

                    return {id: goods.id,
                        count: goods.count,
                        property: game.objGoods[goods.id],
                    };
            }

            return null;
        }


        //获得 或 减去count个道具，返回背包中 改变后 道具个数；count为0则直接返回背包中道具个数；goodsId为物品对象或物品ID。
        //如果positionName为空，则使用 goodsId 的 position 属性来装备；
        //如果count<0，且装备数量不够，则返回<0（相差数），原道具数量不变化。
        //返回null表示错误。
        //注意，会将不同源装备删除，需要保存则先unload
        readonly property var equip: function(heroIndex, positionName, goodsId, count=1) {
            if(heroIndex >= game.gd["$sys_fight_heros"].length || heroIndex < 0)
                return null;
            if(goodsId === undefined || goodsId === null)
                return null;

            if(GlobalLibraryJS.isObject(goodsId)) { //如果直接是对象
                count = goodsId.count;
                goodsId = goodsId.id;
            }


            if(positionName === false || positionName === null || positionName === undefined)
                positionName = objGoods[goodsId].position;


            let oldEquip = game.gd["$sys_fight_heros"][heroIndex].equipment[positionName];

            //如果有相同装备
            if(oldEquip !== undefined && oldEquip.id === goodsId) {   //如果id相同
                let newCount = oldEquip.count + count;
                if(newCount < 0)
                    return newCount;
                else if(newCount === 0) {
                    game.gd["$sys_fight_heros"][heroIndex].equipment[positionName] = {};
                }
                else
                    oldEquip.count = newCount;

                GameMakerGlobalJS.CombatantsPropsWidthGoodsAndEquip(game.gd["$sys_fight_heros"][heroIndex]);
                return newCount;
            }

            //if(oldEquip === undefined || oldEquip.id !== goodsId) {    //如果原来没有装备
            if(count > 0) {
                game.gd["$sys_fight_heros"][heroIndex].equipment[positionName] = {id: goodsId, count: count};
                GameMakerGlobalJS.CombatantsPropsWidthGoodsAndEquip(game.gd["$sys_fight_heros"][heroIndex]);
            }
            return count;
            //}
        }

        //卸下某装备（所有的），返回装备对象，没有返回undefined
        readonly property var unload: function(heroIndex, positionName) {
            if(heroIndex >= game.gd["$sys_fight_heros"].length || heroIndex < 0)
                return null;

            //if(goodsId === undefined || goodsId === null)
            //    return null;


            let oldEquip = game.gd["$sys_fight_heros"][heroIndex].equipment[positionName];
            delete game.gd["$sys_fight_heros"][heroIndex].equipment[positionName];

            GameMakerGlobalJS.CombatantsPropsWidthGoodsAndEquip(game.gd["$sys_fight_heros"][heroIndex]);

            return oldEquip;
        }

        //返回某 heroIndex 的装备；如果positionName为null，则返回所有装备；
        //返回格式：单个：{id,count,property}，多个：单个的数组；错误返回null
        readonly property var equipment: function(heroIndex, positionName=null) {
            if(heroIndex >= game.gd["$sys_fight_heros"].length || heroIndex < 0)
                return null;

            if(positionName !== null)
                return {id: game.gd["$sys_goods"][index].id,
                    count: game.gd["$sys_goods"][index].count,
                    property: game.objGoods[game.gd["$sys_goods"][index].id],
                };


            let ret = [];

            for(let te of game.gd["$sys_fight_heros"][heroIndex].equipment) {
                ret.push({id: te.id,
                    count: te.count,
                    property: game.objGoods[te.id],
                });
            }

            return ret;
        }


        readonly property var fight: function(fightScriptName) {
            if(game.fighthero().length === 0) {
                if(GlobalJS.createScript(_private.asyncScript, 0, function *(){yield game.msg("没有战斗人物");}) === 0)
                    _private.asyncScript.run();
                return;
            }

            //loaderFightScene.item.test();
            loaderFightScene.item.myCombatants = [...game.fighthero()];
            loaderFightScene.item.init(fightScriptName);
            loaderFightScene.visible = true;
            loaderFightScene.focus = true;


            itemBackgroundMusic.pause();
            game.pause();
        }

        readonly property var fighton: function(fightScriptName, interval=1000, probability=20) {
            game.addgtimer("$sys_random_fight_timer", interval, -1);
            game.gf["$sys_random_fight_timer"] = function() {
                if(GlobalLibraryJS.randTarget(1, probability) === 1) {
                    //game.createfightenemy();
                    game.fight(fightScriptName);
                }
            }
        }

        readonly property var fightoff: function() {
            game.delgtimer("$sys_random_fight_timer");
            delete game.gf["$sys_random_fight_timer"];
        }

        readonly property var addtimer: function(timerName, interval, times) {
            if(_private.objTimers[timerName] !== undefined)
                return false;

            _private.objTimers[timerName] = [interval, times, interval];
            return true;
        }

        readonly property var deltimer: function(timerName) {
            delete _private.objTimers[timerName];
        }
        readonly property var addgtimer: function(timerName, interval, times) {
            if(_private.objGlobalTimers[timerName] !== undefined)
                return false;

            _private.objGlobalTimers[timerName] = [interval, times, interval];
            return true;
        }

        readonly property var delgtimer: function(timerName) {
            delete _private.objGlobalTimers[timerName];
        }


        readonly property var playmusic: function(musicName) {
            if(_private.objMusic[musicName] === undefined)
                return false;

            audioBackgroundMusic.source = Global.toQMLPath(GameMakerGlobal.musicResourceURL(_private.objMusic[musicName]));
            itemBackgroundMusic.play();

            game.gd["$music"] = musicName;

            //console.debug("playmusic:", _private.objMusic[musicName], audioBackgroundMusic.play());

            return true;
        }

        readonly property var stopmusic: function() {
            itemBackgroundMusic.stop();
        }

        readonly property var pausemusic: function() {
            itemBackgroundMusic.pause();
        }

        readonly property var resumemusic: function() {
            itemBackgroundMusic.resume();
        }
        readonly property var pushmusic: function() {
            itemBackgroundMusic.arrMusicStack.push([audioBackgroundMusic.source, audioBackgroundMusic.position, itemBackgroundMusic.bPlay]);
            itemBackgroundMusic.stop();
        }
        readonly property var popmusic: function() {
            if(itemBackgroundMusic.arrMusicStack.length === 0)
                return;
            let m = itemBackgroundMusic.arrMusicStack.pop();
            audioBackgroundMusic.source = m[0];
            audioBackgroundMusic.seek(m[1]);
            if(m[2])
                itemBackgroundMusic.play();
            else
                itemBackgroundMusic.stop();
        }


        readonly property var scale: function(n) {
            gameScene.scale = parseFloat(n);
            setMapToRole(mainRole);

            game.gd["$scale"] = n;
        }

        readonly property var pause: function() {
            timer.stop();
            _private.stopAction(1, -1);

            _private.config.bPauseGame = true;

            //joystick.enabled = false;
            //buttonA.enabled = false;
        }
        readonly property var goon: function() {
            timer.start();

            _private.config.bPauseGame = false;

            //joystick.enabled = true;
            //buttonA.enabled = true;

            root.forceActiveFocus();
        }
        readonly property var setinterval: function(interval) {
            _private.config.nInterval = interval > 0 ? interval : 60;
            timer.interval = _private.config.nInterval;
        }

        readonly property var wait: function(ms) {
            _private.asyncScript.wait(ms);
        }

        readonly property var rnd: function(start, end) {
            return GlobalLibraryJS.random(start, end);
        }
        readonly property var toast: function(msg) {
            Platform.showToast(msg);
        }

        readonly property var checksave: function(fileName) {
            let filePath = GameMakerGlobal.config.strSaveDataPath + Platform.separator() + fileName + ".json";
            if(!GameManager.sl_qml_FileExists(filePath))
                return false;

            let data = GameManager.sl_qml_ReadFile(filePath);
            //let cfg = File.read(filePath);
            //console.debug("musicInfo", filePath, musicInfo)
            //console.debug("cfg", cfg, filePath);

            if(data !== "") {
                data = JSON.parse(data);
                if(data.Verify !== Qt.md5(_private.strSaveDataSalt + JSON.stringify(data["Data"])))
                    return false;
                return data;
            }
            return false;
        }

        //!!存档，开头为 $$ 的键不会保存
        readonly property var save: function(fileName="autosave", showName='') {
            if(!fileName)
                fileName = "autosave";

            let fSaveFilter = function(k, v) {
                if(k.indexOf("$$") === 0)
                    return undefined;
                return v;
            }

            let filePath = GameMakerGlobal.config.strSaveDataPath + Platform.separator() + fileName + ".json";

            let GlobalDataString = JSON.stringify(game.gd, fSaveFilter);

            let outputData = {};

            outputData.Version = "0.6";
            outputData.Data = game.gd;
            outputData.Name = showName;
            outputData.Verify = Qt.md5(_private.strSaveDataSalt + GlobalDataString);


            //!!!导出为文件
            //console.debug(JSON.stringify(outputData));
            //let ret = File.write(path + Platform.separator() + 'map.json', JSON.stringify(outputData));
            let ret = GameManager.sl_qml_WriteFile(JSON.stringify(outputData, fSaveFilter), filePath, 0);
            //console.debug(itemContainer.arrCanvasMap[2].toDataURL())

            return ret;

        }

        readonly property var load: function(fileName) {
            //let filePath = GameMakerGlobal.config.strSaveDataPath + Platform.separator() + fileName + ".json";

            let ret = checksave(fileName)
            if(ret === false)
                return false;

            game.gd = ret['Data'];


            //计算装备后属性
            for(let heroIndex in game.gd["$sys_fight_heros"])
                GameMakerGlobalJS.CombatantsPropsWidthGoodsAndEquip(game.gd["$sys_fight_heros"][heroIndex]);

            game.loadmap(game.gd["$sys_map"]);
            for(let th of game.gd["$sys_main_roles"])
                game.createhero(th.HeroName, th.GameName);
            mainRole.x = game.gd["$sys_pos"].x;
            mainRole.y = game.gd["$sys_pos"].y;
            //开始移动地图
            //setMapToRole(mainRole);
            game.scale(game.gd["$scale"]);
            game.playmusic(game.gd["$music"]);


            return true;
        }


        //读取json文件，返回解析后对象
        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var loadjson: function(fileName, filePath="") {
            if(!fileName)
                return null;

            if(!filePath)
                filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + fileName;
            else
                filePath = filePath + Platform.separator() + fileName;

            let data = GameManager.sl_qml_ReadFile(filePath);

            if(!data) {
                console.warn("[!GameScene]loadjson Fail:", filePath);
                return null;
            }
            return JSON.parse(data);
        }


        //将代码放入 系统脚本引擎（asyncScript）中 等候执行
        readonly property var run: function(strScript, ...params) {
            if(GlobalJS.createScript(_private.asyncScript, 0, strScript, ...params) === 0)
                return _private.asyncScript.run();
        }
        //将脚本放入 系统脚本引擎（asyncScript）中 等候执行；一般用在编辑器中载入外部脚本文件
        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var script: function(fileName, filePath) {
            if(!filePath)
                filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + fileName;
            else
                filePath = filePath + Platform.separator() + fileName;

            if(GlobalJS.createScript(_private.asyncScript, 1, filePath) === 0)
                return _private.asyncScript.run();
        }

        //运行代码；
        //在这里执行会有上下文环境
        readonly property var evalcode: function(data, filePath="", envs={}) {
            return GlobalJS.Eval(data, filePath, envs);
        }

        //fileName为 绝对或相对路径 的文件名；filePath为文件的绝对路径，如果为空，则 fileName 为相对于本项目根路径
        readonly property var evalfile: function(fileName, filePath="", envs={}) {
            if(!filePath)
                filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + fileName;
            else
                filePath = filePath + Platform.separator() + fileName;

            GlobalJS.EvalFile(filePath, envs);
        }

        //用C++执行脚本；已注入game和fight环境
        readonly property var evaluate: function(program, filePath="", lineNumber = 1) {
            return GameManager.evaluate(program, filePath, lineNumber);
        }
        readonly property var evaluateFile: function(file, path, lineNumber = 1) {
            if(path === undefined) {
                if(GameManager.globalObject().evaluateFilePath === undefined)
                    GameManager.globalObject().evaluateFilePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName;
                path = GameManager.globalObject().evaluateFilePath;
            }
            else
                GameManager.globalObject().evaluateFilePath = path;
            return GameManager.evaluateFile(path + Platform.separator() + file, lineNumber);
        }
        readonly property var importModule: function(filePath) {
            return GameManager.importModule(filePath);
        }


        readonly property var date: ()=>{return new Date();}

        readonly property var math: Math

        property var d: ({})
        property var f: ({})
        property var gd: ({})
        property var gf: ({})



        readonly property alias objRoles: _private.objRoles
        readonly property alias arrMainRoles: _private.arrMainRoles

        readonly property alias objGoods: _private.objGoods
        readonly property alias objSkills: _private.objSkills
        readonly property alias objSprites: _private.objSprites

    }


    //property alias mainRole: mainRole

    //地图块大小（用于缩放地图块）
    property size sizeMapBlockSize
    //是否是测试模式
    property bool bTest: false



    //游戏开始脚本
    function init(cfg) {
        game.gd["$sys_fight_heros"] = [];
        game.gd["$sys_money"] = 0;
        game.gd["$sys_goods"] = [];
        game.gd["$sys_map"] = '';
        game.gd["$sys_pos"] = Qt.point(0,0);
        game.gd["$sys_main_roles"] = [];
        game.gd["$music"] = "";
        game.gd["$scale"] = 1;


        //读道具信息
        let path = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strGoodsDirName;
        let items = GameManager.sl_qml_listDir(path, "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let filePath = path + Platform.separator() + item + Platform.separator() + "goods.json";
            //console.debug(path, items, item, filePath)
            let data = GameManager.sl_qml_ReadFile(filePath);

            if(data !== "") {
                data = JSON.parse(data);
                _private.objGoods[item] = GlobalJS.Eval(data["Goods"]);
                _private.objGoods[item].id = item;
                console.debug("[GameScene]载入Goods", item, "OK");
            }
            if(!data)
                console.warn("[!GameScene]载入Goods", item, "ERROR");
        }


        //读技能信息
        path = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strFightSkillDirName;
        items = GameManager.sl_qml_listDir(path, "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let filePath = path + Platform.separator() + item + Platform.separator() + "fight_skill.json";
            //console.debug(path, items, item, filePath)
            let data = GameManager.sl_qml_ReadFile(filePath);

            if(data !== "") {
                data = JSON.parse(data);
                _private.objSkills[item] = GlobalJS.Eval(data["FightSkill"]);
                _private.objSkills[item].id = item;
                console.debug("[GameScene]载入FightSkill", item, "OK");
            }
            if(!data)
                console.warn("[!GameScene]载入FightSkill", item, "ERROR");
        }


        //读特效信息
        path = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strSpriteDirName;
        items = GameManager.sl_qml_listDir(path, "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let filePath = path + Platform.separator() + item + Platform.separator() + "sprite.json";
            //console.debug(path, items, item, filePath)
            let data = GameManager.sl_qml_ReadFile(filePath);

            if(data !== "") {
                data = JSON.parse(data);
                _private.objSprites[item] = data;
                _private.objSprites[item].id = item;
                console.debug("[GameScene]载入Sprite", item, "OK");
            }
            if(!data)
                console.warn("[!GameScene]载入Sprite", item, "ERROR");
        }


        //读音乐信息
        let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() +  "music.json";
        //let cfg = File.read(filePath);
        let data = GameManager.sl_qml_ReadFile(filePath);
        //console.debug("data", filePath, data)
        //console.debug("cfg", cfg, filePath);

        if(data !== "") {
            data = JSON.parse(data)["MusicData"];
            for(let m in data) {
                _private.objMusic[data[m]["MusicName"]] = data[m]["MusicURL"];
            }
            console.debug("[GameScene]载入音乐OK");
        }



        //读通用算法脚本
        data = game.loadjson("common_algorithm.json");
        if(data) {
            let ret = GlobalJS.Eval(data["FightAlgorithm"]);
            game.gf["$sys_fight_skill_algorithm"] = ret.skillEffectAlgorithm;
            game.gf["$sys_fight_start_stript"] = ret.commonFightStartScript;
            game.gf["$sys_fight_round_stript"] = ret.commonFightRoundScript;
            game.gf["$sys_fight_end_stript"] = ret.commonFightEndScript;
            game.gf["$sys_resume_event_stript"] = ret.resumeEventScript;
            game.gf["$sys_get_goods_script"] = ret.commonGetGoodsScript;
            game.gf["$sys_use_goods_stript"] = ret.commonUseGoodsScript;
        }
        if(!game.gf["$sys_fight_skill_algorithm"]) {
            game.gf["$sys_fight_skill_algorithm"] = GameMakerGlobalJS.skillEffectAlgorithm;
            console.warn("[!GameScene]载入战斗算法错误");
        }
        else
            console.debug("[GameScene]载入战斗算法OK");  //, game.gf["$sys_fight_skill_algorithm"], data, eval("()=>{}"));

        if(!game.gf["$sys_fight_start_stript"]) {
            game.gf["$sys_fight_start_stript"] = GameMakerGlobalJS.commonFightStartScript;
            console.warn("[!GameScene]载入战斗开始脚本错误");
        }
        else
            console.debug("[GameScene]载入战斗开始脚本OK");
        if(!game.gf["$sys_fight_round_stript"]) {
            game.gf["$sys_fight_round_stript"] = GameMakerGlobalJS.commonFightRoundScript;
            console.warn("[!GameScene]载入战斗回合脚本错误");
        }
        else
            console.debug("[GameScene]载入战斗回合脚本OK");
        if(!game.gf["$sys_fight_end_stript"]) {
            game.gf["$sys_fight_end_stript"] = GameMakerGlobalJS.commonFightEndScript;
            console.warn("[!GameScene]载入战斗结束脚本错误");
        }
        else
            console.debug("[GameScene]载入战斗结束脚本OK");

        if(!game.gf["$sys_resume_event_stript"]) {
            game.gf["$sys_resume_event_stript"] = GameMakerGlobalJS.resumeEventScript;
            console.warn("[!GameScene]载入恢复脚本错误");
        }
        else
            console.debug("[GameScene]载入恢复算法脚本OK");  //, game.gf["$sys_resume_timer"], data, eval("()=>{}"));

        if(!game.gf["$sys_get_goods_script"]) {
            game.gf["$sys_get_goods_script"] = GameMakerGlobalJS.commonGetGoodsScript;
            console.warn("[!GameScene]载入通用获得道具脚本错误");
        }
        else
            console.debug("[GameScene]载入通用获得道具脚本OK");
        if(!game.gf["$sys_use_goods_stript"]) {
            game.gf["$sys_use_goods_stript"] = GameMakerGlobalJS.commonUseGoodsScript;
            console.warn("[!GameScene]载入通用使用道具脚本错误");
        }
        else
            console.debug("[GameScene]载入通用使用道具脚本OK");



        //读升级链
        data = game.loadjson("level_chain.json");
        if(data) {
            let ret = GlobalJS.Eval(data["LevelChainScript"]);
            game.gf["$sys_levelup_script"] = ret.levelUpScript;
            game.gf["$sys_level_Algorithm"] = ret.levelAlgorithm;
        }
        if(!game.gf["$sys_levelup_script"]) {
            game.gf["$sys_levelup_script"] = GameMakerGlobalJS.levelUpScript;
            console.warn("[!GameScene]载入升级脚本错误");
        }
        else
            console.debug("[GameScene]载入升级脚本OK");  //, game.gf["$sys_levelup_script"], data, eval("()=>{}"));

        if(!game.gf["$sys_level_Algorithm"]) {
            game.gf["$sys_level_Algorithm"] = GameMakerGlobalJS.levelAlgorithm;
            console.warn("[!GameScene]载入升级算法错误");
        }
        else
            console.debug("[GameScene]载入升级算法OK");  //, game.gf["$sys_level_Algorithm"], data, eval("()=>{}"));



        //每秒恢复事件
        game.addgtimer("$sys_resume_timer", 1000, -1);
        game.gf["$sys_resume_timer"] = function() {
            for(let h in game.gd["$sys_fight_heros"]) {
                game.gf["$sys_resume_event_stript"](game.gd["$sys_fight_heros"][h]);
                //console.debug("!!!666health", game.gd["$sys_fight_heros"][h].remainHP);
            }
        }

        //console.debug("_private.objMusic", JSON.stringify(_private.objMusic))


        game.setinterval(cfg.GameFPS);
        game.goon();
        if(GlobalJS.createScript(_private.asyncScript, 0, cfg.GameStartScript) === 0)
            _private.asyncScript.run();
    }



    //打开地图
    function openMap(mapName) {
        itemBackMapContainer.visible = false;
        itemFrontMapContainer.visible = false;

        let filePath = GameMakerGlobal.config.strProjectPath + Platform.separator() + GameMakerGlobal.config.strCurrentProjectName + Platform.separator() + GameMakerGlobal.config.strMapDirName + Platform.separator() + mapName + Platform.separator() + "map.json";
        //let cfg = File.read(filePath);
        let mapInfo = GameManager.sl_qml_ReadFile(filePath);
        //console.debug("cfg", cfg, filePath);

        if(mapInfo === "")
            return false;
        mapInfo = JSON.parse(mapInfo);
        //console.debug("cfg", cfg);
        //loader.setSource("./MapEditor_1.qml", {});


        //地图数据
        //itemContainer.mapInfo = JSON.parse(File.read(mapFilePath));
        itemContainer.mapInfo = mapInfo;

        let nMapBlockScale = parseFloat(itemContainer.mapInfo.MapScale) || 1;
        sizeMapBlockSize.width = itemContainer.mapInfo.MapBlockSize[0] * nMapBlockScale;
        sizeMapBlockSize.height = itemContainer.mapInfo.MapBlockSize[1] * nMapBlockScale;

        itemContainer.width = itemContainer.mapInfo.MapSize[0] * sizeMapBlockSize.width;
        itemContainer.height = itemContainer.mapInfo.MapSize[1] * sizeMapBlockSize.height;

        //如果地图小于场景，则将地图居中
        if(itemContainer.width * gameScene.scale < root.width)
            itemContainer.x = (root.width - itemContainer.width * gameScene.scale) / 2 / gameScene.scale;
        if(itemContainer.height * gameScene.scale < root.height)
            itemContainer.y = (root.height - itemContainer.height * gameScene.scale) / 2 / gameScene.scale;

        //console.debug("!!!", itemContainer.width, gameScene.scale, root.width, itemContainer.x);
        //console.debug("!!!", itemContainer.height, gameScene.scale, root.height, itemContainer.y);


        //卸载原地图块图片
        for(let tc in itemBackMapContainer.arrCanvas) {
            itemBackMapContainer.arrCanvas[tc].unloadImage(imageMapBlock.source);
        }
        for(let tc in itemFrontMapContainer.arrCanvas) {
            itemFrontMapContainer.arrCanvas[tc].unloadImage(imageMapBlock.source);
        }

        imageMapBlock.source = Global.toQMLPath(GameMakerGlobal.mapResourceURL(mapInfo.MapBlockImage[0]));

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



        game.map.name = mapInfo.MapName;


        console.debug("[GameScene]openMap", itemContainer.width, itemContainer.height)

        //test();

        return true;
    }

    function updateAllRolesPos() {

    }

    //设置角色坐标（块坐标）
    function setRolePos(role, bx, by) {
        //边界检测

        if(bx < 0)
            bx = 0;
        else if(bx >= itemContainer.mapInfo.MapSize[0])
            bx = itemContainer.mapInfo.MapSize[0] - 1;

        if(by < 0)
            by = 0;
        else if(by >= itemContainer.mapInfo.MapSize[1])
            by = itemContainer.mapInfo.MapSize[1] - 1;


        //设置角色坐标

        //人物占位 所在目标图块最中央的 地图的坐标
        let targetX = parseInt((bx + 0.5) * sizeMapBlockSize.width);
        let targetY = parseInt((by + 0.5) * sizeMapBlockSize.height);
        //let targetX = parseInt(role.x + role.x1 + role.width1 / 2);
        //let targetY = parseInt(role.y + role.y1 + role.height1 / 2);


        //如果在最右边的图块，且人物宽度超过图块，则会超出地图边界
        if(bx === itemContainer.mapInfo.MapSize[0] - 1 && role.width1 > sizeMapBlockSize.width)
            role.x = itemContainer.width - role.x2 - 1;
        else
            role.x = targetX - role.x1 - role.width1 / 2;

        //如果在最下边的图块，且人物高度超过图块，则会超出地图边界
        if(by === itemContainer.mapInfo.MapSize[1] - 1 && role.height1 > sizeMapBlockSize.height)
            role.y = itemContainer.height - role.y2 - 1;
        else
            role.y = targetY - role.y1 - role.height1 / 2;
    }

    //设置主角坐标（块坐标）
    function setMainRolePos(bx, by) {
        setRolePos(mainRole, bx, by);
        setMapToRole(mainRole);

        game.gd["$sys_pos"] = Qt.point(mainRole.x, mainRole.y);
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
        //else  //如果地图小于场景则不动
        //    itemContainer.x = 0;


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
        //else  //如果地图小于场景则不动
        //    itemContainer.y = 0;

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

    Keys.forwardTo: [itemContainer]



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
        width: root.width / scale
        height: root.height / scale

        clip: true
        color: "black"

        transformOrigin: Item.TopLeft



        Item {    //所有东西的容器
            id: itemContainer


            property var eventsTriggered: []    //保存触发的事件

            property var mapInfo: ({})          //地图数据
            property var mapEventBlocks: ({})   //有事件的地图块ID（换算后的）

            //property var image1: "1.jpg"
            //property var image2: "2.png"


            //地图事件触发
            function gameEvent(eventName) {
                if(GlobalJS.createScript(_private.asyncScript, 0, mapInfo.EventData[eventName]) === 0)
                    _private.asyncScript.run();
                console.debug("[GameScene]gameEvent:", eventName);    //触发
            }
            //离开事件触发
            function gameEventCanceled(eventName) {
                //GlobalJS.runScript(_private.asyncScript, 0, mapInfo.EventData[eventName]);
                console.debug("[GameScene]gameEventCanceled:", eventName);    //触发
            }



            //width: 800
            //height: 600

            //scale: 2



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


                Role {
                    id: mainRole

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

                            if(GlobalJS.createScript(_private.asyncScript, 0, game.gf[tt]) === 0)
                                _private.asyncScript.run();
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

                            if(GlobalJS.createScript(_private.asyncScript, 0, game.f[tt]) === 0)
                                _private.asyncScript.run();
                            //GlobalJS.runScript(_private.asyncScript, 0, "game.f['%1']()".arg(tt));
                        }
                    }


                    //NPC操作

                    //遍历每个NPC
                    for(let r in _private.objRoles) {
                        if(_private.objRoles[r].nActionType === 0)
                            continue;

                        //增加状态时间
                        _private.objRoles[r].nActionStatusKeepTime += realinterval;

                        //走路状态
                        if(_private.objRoles[r].direction !== -1) {
                            //console.debug("walk status")

                            //如果到达切换状态阈值
                            if(_private.objRoles[r].nActionStatusKeepTime > 500) {
                                _private.objRoles[r].nActionStatusKeepTime = 0;

                                //概率停止
                                if(GlobalLibraryJS.randTarget(5, 6) !== 0) {
                                    _private.stopSprite(_private.objRoles[r]);
                                    //_private.objRoles[r].direction = -1;
                                    //_private.objRoles[r].stop();
                                    //console.debug("Stop");
                                    continue;
                                }

                            }

                            //计算走路
                            let offsetMove = Math.round(_private.objRoles[r].offsetMove * realinterval);
                            offsetMove = _private.fComputeRoleMoveOffset(_private.objRoles[r], _private.objRoles[r].direction, offsetMove);
                            if(offsetMove === 0) {
                                _private.stopSprite(_private.objRoles[r]);
                                //_private.objRoles[r].direction = -1;
                                //_private.objRoles[r].stop();
                                //console.debug("Stop2...");
                                continue;
                            }

                            //console.debug("Start...", _private.objRoles[r].direction, offsetMove);
                            //人物移动计算（值为按键值）
                            switch(_private.objRoles[r].direction) {
                            case Qt.Key_Left:
                                _private.objRoles[r].x -= offsetMove;
                                break;

                            case Qt.Key_Right:
                                _private.objRoles[r].x += offsetMove;
                                break;

                            case Qt.Key_Up: //同Left
                                _private.objRoles[r].y -= offsetMove;
                                break;

                            case Qt.Key_Down:   //同Right
                                _private.objRoles[r].y += offsetMove;
                                break;

                            default:
                                break;
                            }
                        }
                        //站立状态
                        else {
                            //如果到达切换状态阈值
                            if(_private.objRoles[r].nActionStatusKeepTime > 500) {
                                _private.objRoles[r].nActionStatusKeepTime = 0;

                                //移动（概率）
                                //console.debug("stop status")
                                let tn = GlobalLibraryJS.random(1, 10)
                                if(tn === 1) {
                                    _private.startSprite(_private.objRoles[r], Qt.Key_Up);
                                    //_private.objRoles[r].direction = Qt.Key_Up;
                                    //_private.objRoles[r].start();
                                }
                                else if(tn === 2) {
                                    _private.startSprite(_private.objRoles[r], Qt.Key_Down);
                                    //_private.objRoles[r].direction = Qt.Key_Down;
                                    //_private.objRoles[r].start();
                                }
                                else if(tn === 3) {
                                    _private.startSprite(_private.objRoles[r], Qt.Key_Left);
                                    //_private.objRoles[r].direction = Qt.Key_Left;
                                    //_private.objRoles[r].start();
                                }
                                else if(tn === 4) {
                                    _private.startSprite(_private.objRoles[r], Qt.Key_Right);
                                    //_private.objRoles[r].direction = Qt.Key_Right;
                                    //_private.objRoles[r].start();
                                }
                            }
                            //console.debug("status:", _private.objRoles[r].direction)
                        }
                    }



                    //主角操作
                    do {

                        if(mainRole.direction === -1)
                            break;

                        //计算真实移动偏移，初始为 角色速度 * 时间差
                        let offsetMove = Math.round(mainRole.offsetMove * realinterval);

                        //如果开启摇杆加速，且用的不是键盘，则乘以摇杆便宜
                        if(_private.config.rJoystickSpeed > 0 && GlobalLibraryJS.objectIsEmpty(_private.keys)) {
                            let tOffset;    //遥感百分比
                            if(mainRole.direction === Qt.Key_Left|| mainRole.direction === Qt.Key_Right) {
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
                        offsetMove = _private.fComputeRoleMoveToObstacleOffset(mainRole, mainRole.direction, offsetMove);
                        if(offsetMove === 0) {  //如果碰墙

                            if(!_private.fChangeMainRoleDirection())
                                break;
                        }

                        //计算与其他角色距离
                        offsetMove = _private.fComputeRoleMoveToRolesOffset(mainRole, mainRole.direction, offsetMove);

                        if(offsetMove !== undefined && offsetMove !== 0) {
                            //console.debug("offsetMove:", offsetMove);
                        }
                        else
                            break;


                        //存主角的新坐标
                        let roleNewX = mainRole.x, roleNewY = mainRole.y;

                        //人物移动计算（值为按键值）
                        switch(mainRole.direction) {
                        case Qt.Key_Left:
                            roleNewX -= offsetMove;
                            break;

                        case Qt.Key_Right:
                            roleNewX += offsetMove;
                            break;

                        case Qt.Key_Up: //同Left
                            roleNewY -= offsetMove;
                            break;

                        case Qt.Key_Down:   //同Right
                            roleNewY += offsetMove;
                            break;

                        default:
                            return;
                        }



                        mainRole.x = roleNewX;
                        mainRole.y = roleNewY;

                        game.gd["$sys_pos"] = Qt.point(mainRole.x, mainRole.y);





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
                                    if(mainRole.direction === Qt.Key_Left) {

                                        let v = (px + 1) * sizeMapBlockSize.width - (mainRole.x + mainRole.x1);
                                        let rolePos = _private.fComputeRoleMoveOffset(mainRole, mainRole.direction, v);
                                        roleNewX = rolePos[0];
                                        checkover = true;

                                        console.debug("碰到左边墙壁", px, (px + 1) * sizeMapBlockSize.width, (mainRole.x + mainRole.x1), v);
                                    }
                                    if(mainRole.direction === Qt.Key_Right) {

                                        let rolePos = _private.fComputeRoleMoveOffset(mainRole, mainRole.direction, (px) * sizeMapBlockSize.width - (mainRole.x + mainRole.x2));
                                        roleNewX = rolePos[0];
                                        checkover = true;

                                        console.debug("碰到右边障碍");
                                    }
                                    if(mainRole.direction === Qt.Key_Up) {

                                        let rolePos = _private.fComputeRoleMoveOffset(mainRole, mainRole.direction, (py + 1) * sizeMapBlockSize.height - (mainRole.y + mainRole.y1));
                                        roleNewX = rolePos[1];
                                        checkover = true;

                                        console.debug("碰到上方障碍");
                                    }
                                    if(mainRole.direction === Qt.Key_Down) {

                                        let rolePos = _private.fComputeRoleMoveOffset(mainRole, mainRole.direction, (py) * sizeMapBlockSize.height - (mainRole.y + mainRole.y2));
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
                        let usedMapBlocks = _private.fComputeUseBlocks(mainRole.x + mainRole.x1, mainRole.y + mainRole.y1, mainRole.x + mainRole.x2, mainRole.y + mainRole.y2);

                        for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
                            for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
                                mainRoleUseBlocks.push(xb + yb * itemContainer.mapInfo.MapSize[0]);
                            }
                        }

                        let tEvents = [];   //暂存这次触发的事件
                        //循环事件
                        for(let event in itemContainer.mapEventBlocks) {
                            //console.debug("[GameScene]检测事件：", event, mainRoleUseBlocks);
                            if(mainRoleUseBlocks.indexOf(parseInt(event)) > -1) {  //如果事件触发
                                tEvents.push(parseInt(event));  //加入
                                let index = itemContainer.eventsTriggered.indexOf(parseInt(event));
                                if(index > -1) {    //如果已经被触发过
                                    itemContainer.eventsTriggered.splice(index, 1); //将触发的事件删除（剩下的就是取消触发的事件了）
                                    continue;
                                }
                                //console.debug("[GameScene]gameEvent触发:", event, mainRoleUseBlocks, itemContainer.mapEventBlocks[event]);    //触发
                                itemContainer.gameEvent(itemContainer.mapEventBlocks[event]);   //触发事件
                            }
                            //console.debug("event:", event, mainRoleUseBlocks, mainRoleUseBlocks.indexOf(event), typeof(event), typeof(itemContainer.mapInfo.events[0]), typeof(mainRoleUseBlocks[0]))
                        }
                        //检测离开事件区域
                        for(let event in itemContainer.eventsTriggered) {
                            //console.debug("[GameScene]gameEventCanceled触发:", event, mainRoleUseBlocks, itemContainer.mapEventBlocks[event]);    //触发
                            itemContainer.gameEventCanceled(itemContainer.mapEventBlocks[event]);   //触发事件
                            //console.debug("event:", event, mainRoleUseBlocks, mainRoleUseBlocks.indexOf(event), typeof(event), typeof(itemContainer.mapInfo.events[0]), typeof(mainRoleUseBlocks[0]))
                        }
                        itemContainer.eventsTriggered = tEvents;




                        //人物的占位最中央 所在地图的坐标
                        let centerX = mainRole.x + mainRole.x1 + mainRole.width1 / 2;
                        let centerY = mainRole.y + mainRole.y1 + mainRole.height1 / 2;


                        textPos.text = "(%1),(%2),(%3),(%4)".
                            arg([centerX, centerY]).
                            arg([mainRole.x, mainRole.y]).
                            arg([mainRole.x + mainRole.x1, mainRole.y + mainRole.y1]).
                            arg([mainRole.x + mainRole.x2, mainRole.y + mainRole.y2])
                        ;

                        textPos1.text = "(%1),[%2]".
                            arg([Math.floor(centerX / sizeMapBlockSize.width), Math.floor(centerY / sizeMapBlockSize.height)]).
                            arg(mainRoleUseBlocks)
                            //.arg(itemContainer.mapInfo.data.length)
                            ;
                    }while(0);


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


            Keys.onEscapePressed:  {
                s_close();
                event.accepted = true;

                console.debug("[GameScene]Escape Key");
            }
            Keys.onBackPressed: {
                s_close();
                event.accepted = true;

                console.debug("[GameScene]Back Key");
            }
            Keys.onTabPressed: {
                root.forceActiveFocus();

                event.accepted = true;
                console.debug("[GameScene]Tab Key");
            }
            Keys.onSpacePressed: {
                event.accepted = true;

                console.debug("------------------");
            }

            Keys.onPressed: {   //键盘按下
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

                    if(!_private.config.bPauseGame)
                        _private.doAction(1, event.key);

                    event.accepted = true;

                    break;

                case Qt.Key_Return:
                    if(event.isAutoRepeat === true) { //如果是按住不放的事件，则返回（只记录第一次按）
                        event.accepted = true;
                        return;
                    }

                    if(!_private.config.bPauseGame)
                        _private.buttonAClicked();

                    event.accepted = true;

                    break;

                default:
                    event.accepted = true;
                }

                console.debug("[GameScene]Keys.onPressed:", event.key, event.isAutoRepeat);
            }

            Keys.onReleased: {

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

                console.debug("[GameScene]Keys.onReleased", event.isAutoRepeat);
            }
        }

        Rectangle {
            id: rectMenu

            visible: false

            width: parent.width / 2
            height: parent.height / 3
            anchors.centerIn: parent

            color: "#CF6699FF"
            border.color: "white"
            radius: height / 20
            clip: true

            ColumnLayout {
                anchors.fill: parent

                Rectangle {
                    color: "#9900CC99"
                    //radius: rectMenu.radius

                    Layout.alignment: Qt.AlignCenter | Qt.AlignHCenter
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 60

                    Text {
                        id: textMenuTitle

                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 16
                        font.bold: true
                        color: "white"
                        text: ""
                    }

                }

                GameMenu {
                    id: menuGame

                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height

                    //height: parent.height / 2
                    //anchors.centerIn: parent

                    onS_Choice: {
                        //gameMap.focus = true;
                        if(_private.config.bPauseGame)
                            game.goon();
                        rectMenu.visible = false;

                        //GameManager.goon();
                        //console.debug("!!!asyncScript.run", index);
                        _private.asyncScript.run(index);
                    }
                }
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
                //root.forceActiveFocus();
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

    //游戏对话框
    Item {
        id: dialogGameMsg

        //property alias textGameMsg: textGameMsg.text
        //property int standardButtons: Dialog.Ok | Dialog.Cancel


        signal accepted();
        signal rejected();


        function show(msg, pretext, interval, type) {
            visible = true;
            touchAreaGameMsg.enabled = false;
            messageGame.show(msg, pretext, interval, type);
            //GameManager.wait(-1);
        }


        anchors.fill: parent
        visible: false


        Mask {
            anchors.fill: parent
            color: "lightgray"
        }


        Message {
            id: messageGame

            width: parent.width * 0.7
            height: parent.height * 0.3
            anchors.centerIn: parent

            onS_over: {
                touchAreaGameMsg.enabled = true;
            }
        }


        MultiPointTouchArea {
            id: touchAreaGameMsg
            anchors.fill: parent
            //enabled: dialogGameMsg.standardButtons === Dialog.NoButton
            enabled: false
            onPressed: {
                //root.forceActiveFocus();
                dialogGameMsg.rejected();
            }
        }


        onAccepted: {
            //gameMap.focus = true;
            if(_private.config.bPauseGame)
                game.goon();
            visible = false;

            //GameManager.goon();
            _private.asyncScript.run();
        }
        onRejected: {
            //gameMap.focus = true;
            if(_private.config.bPauseGame)
                game.goon();
            visible = false;

            //GameManager.goon();
            _private.asyncScript.run();
        }
    }



    Joystick {
        id: joystick

        property real rJoystickIgnore: 0.1  //忽略的最大偏移比

        anchors.left: parent.left
        anchors.bottom: parent.bottom

        //anchors.margins: 1 * Screen.pixelDensity
        transformOrigin: Item.BottomLeft
        anchors.leftMargin: 6 * Screen.pixelDensity
        anchors.bottomMargin: 7 * Screen.pixelDensity
        //anchors.verticalCenterOffset: -100
        //anchors.horizontalCenterOffset: -100

        opacity: 0.6
        scale: 1

        onPressedChanged: {
            if(_private.config.bPauseGame)
                return;

            if(pressed === false) {
                _private.stopAction(0);
            }
            //console.debug("[GameScene]Joystick onPressedChanged:", pressed)
        }

        onPointInputChanged: {
            //if(pointInput === Qt.point(0,0))
            //    return;

            if(_private.config.bPauseGame)
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


    //A键
    GameButton {
        id: buttonA

        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.rightMargin: 10 * Screen.pixelDensity
        anchors.bottomMargin: 16 * Screen.pixelDensity

        //anchors.verticalCenterOffset: -100
        //anchors.horizontalCenterOffset: -100

        color: "red"

        onS_pressed: {
            if(_private.config.bPauseGame)
                return;

            _private.buttonAClicked();
        }
    }


    //Menu键
    GameButton {
        id: buttonMenu

        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.rightMargin: 16 * Screen.pixelDensity
        anchors.bottomMargin: 8 * Screen.pixelDensity

        //anchors.verticalCenterOffset: -100
        //anchors.horizontalCenterOffset: -100

        color: "blue"

        onS_pressed: {
            if(_private.config.bPauseGame)
                return;

            _private.buttonMenuClicked();
        }
    }

    GameMenuWindow {
        id: gameMenuWindow

        visible: false
        anchors.fill: parent
    }

    //角色对话框
    Item {
        id: dialogRoleMsg


        signal accepted();
        signal rejected();


        function show(msg, pretext, interval, type) {
            //console.debug("show1")
            dialogRoleMsg.visible = true;
            touchAreaRoleMsg.enabled = false;
            messageRole.show(msg, pretext, interval, type);
            //console.debug("show2")
            //GameManager.wait(-1);
        }


        anchors.fill: parent
        visible: false


        Mask {
            visible: false
            anchors.fill: parent
            color: "lightgray"
        }


        Message {
            id: messageRole
            width: parent.width
            height: parent.height * 0.3
            anchors.bottom: parent.bottom

            onS_over: {
                touchAreaRoleMsg.enabled = true;
            }
        }


        MultiPointTouchArea {
            id: touchAreaRoleMsg
            anchors.fill: parent
            enabled: false
            //enabled: dialogRoleMsg.standardButtons === Dialog.NoButton
            onPressed: {
                //root.forceActiveFocus();
                //console.debug("MultiPointTouchArea1")
                dialogRoleMsg.rejected();
                //console.debug("MultiPointTouchArea2")
            }
        }


        onAccepted: {
            //gameMap.focus = true;
            if(_private.config.bPauseGame)
                game.goon();
            visible = false;

            //GameManager.goon();
            _private.asyncScript.run();
        }
        onRejected: {

            //console.debug("onRejected1")
            //gameMap.focus = true;
            if(_private.config.bPauseGame)
                game.goon();
            visible = false;

            //GameManager.goon();
            _private.asyncScript.run();
            //console.debug("onRejected2")
        }
    }



    //调试
    Rectangle {
        width: Platform.compileType() === "debug" ? root.width : 80
        height: Platform.compileType() === "debug" ? 45 : 15
        color: "white"

        Text {
            id: textPos
            y: 30
            width: 200
            height: 15

            visible: Platform.compileType() === "debug"
        }
        Text {
            id: textPos1
            y: 15
            width: 200
            height: 15

            visible: Platform.compileType() === "debug"
        }
        Text {
            id: textFPS
            y: 0
            width: 200
            height: 15
        }

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
                dialogScript.open();
            }
        }
    }



    Loader {
        id: loaderFightScene
        anchors.fill: parent

        visible: false

        source: "./FightScene.qml"


        Connections {
            target: loaderFightScene.item

            //!鹰：Loader每次载入的时候都会重新Connection一次，所以没有的会出现警告
            function onS_FightOver() {
                root.focus = true;
                loaderFightScene.visible = false;

                itemBackgroundMusic.resume();
                game.goon();

                //升级检测
                if(game.gf["$sys_levelup_script"]) {
                    for(let h in game.gd["$sys_fight_heros"]) {
                        if(GlobalJS.createScript(_private.asyncScript, 0, game.gf["$sys_levelup_script"](game.gd["$sys_fight_heros"][h])) === 0)
                            _private.asyncScript.run();
                    }
                }
            }
        }
    }



    //测试脚本对话框
    Dialog {
        id: dialogScript

        title: "执行脚本"
        width: 300
        height: 200
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
            root.forceActiveFocus();
            console.debug(eval(textScript.text));
            //GlobalJS.runScript(_private.asyncScript, 0, textScript.text);
        }
        onRejected: {
            //gameMap.focus = true;
            root.forceActiveFocus();
            //console.log("Cancel clicked");
        }
    }




    Item {
        id: itemBackgroundMusic

        property var arrMusicStack: []
        property bool bPlay: false
        property int nPauseTimes: 0

        function play() {
            bPlay = true;
            audioBackgroundMusic.play();
            nPauseTimes = 0;
        }

        function stop() {
            bPlay = false;
            audioBackgroundMusic.stop();
            nPauseTimes = 0;
        }

        function pause() {
            ++nPauseTimes;
            audioBackgroundMusic.pause();
            //console.debug("!!!pause", nPauseTimes)
        }

        function resume() {
            --nPauseTimes;
            if(bPlay && nPauseTimes <= 0) {
                audioBackgroundMusic.play();
                nPauseTimes = 0;
            }
            //console.debug("!!!resume", nPauseTimes, bPlay)
        }

        Audio {
            id: audioBackgroundMusic
            loops: Audio.Infinite

        }
    }


    QtObject {  //私有数据,函数,对象等
        id: _private


        //游戏配置/设置
        property var config: QtObject {
            property int nInterval: 16
            property bool bPauseGame: false     //暂停游戏
            property real rJoystickSpeed: 0.2   //开启摇杆加速功能（最低速度比例）
        }

        //存档m5的盐
        readonly property string strSaveDataSalt: "深林孤鹰@鹰歌联盟Leamus_" + GameMakerGlobal.config.strCurrentProjectName



        //音乐列表
        property var objMusic: ({})         //{音乐名: 音乐路径}

        //角色NPC 和 主角
        property var objRoles: ({})
        property var arrMainRoles: []

        property var objSkills: ({})        //所有技能
        property var objGoods: ({})         //所有道具（key为道具名（json名），value：id为key，其他是脚本返回值（包括name、description等）
        property var objSprites: ({})       //所有特效



        //定时器
        property var objTimers: ({})        //{定时器名: [间隔,触发次数,是否全局,剩余时长]}
        property var objGlobalTimers: ({})        //{定时器名: [间隔,触发次数,是否全局,剩余时长]}



        //异步脚本
        property var asyncScript: new GlobalJS.Async(root)



        property var keys: ({}) //保存按下的方向键

        //type为0表示按钮，type为1表示键盘（会保存key）
        function doAction(type, key) {
            switch(key) {
            case Qt.Key_Down:
                _private.startSprite(mainRole, Qt.Key_Down);
                //mainRole.direction = Qt.Key_Down; //移动方向
                //mainRole.start();
                //timer.start();  //开始移动
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            case Qt.Key_Left:
                _private.startSprite(mainRole, Qt.Key_Left);
                //mainRole.direction = Qt.Key_Left;
                //mainRole.start();
                //timer.start();
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            case Qt.Key_Right:
                _private.startSprite(mainRole, Qt.Key_Right);
                //mainRole.direction = Qt.Key_Right;
                //mainRole.start();
                //timer.start();
                if(type === 1)
                    keys[key] = true; //保存键盘按下
                //keys.push(key);
                break;
            case Qt.Key_Up:
                _private.startSprite(mainRole, Qt.Key_Up);
                //mainRole.direction = Qt.Key_Up;
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
                        //mainRole.direction = l[0];    //弹出第一个按键
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
        }


        function buttonMenuClicked() {
            gameMenuWindow.show();
            console.debug("[GameScene]buttonMenuClicked");
        }

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
                if(GlobalLibraryJS.testRectangleClashed(
                            usePos,
                            Qt.rect(objRoles[r].x + objRoles[r].x1, objRoles[r].y + objRoles[r].y1, objRoles[r].width1, objRoles[r].height1)
                            )) {
                    if(game.f[objRoles[r].name] !== undefined) {
                        if(GlobalJS.createScript(_private.asyncScript, 0, game.f[objRoles[r].name]) === 0)
                            _private.asyncScript.run();
                        //GlobalJS.runScript(_private.asyncScript, 0, "game.f['%1']()".arg(objRoles[r].name));

                        console.debug("[GameScene]触发NPC事件：", objRoles[r].name);
                        return; //!!只执行一次事件
                    }
                }
            }
        }


        function startSprite(role, key) {
            role.direction = key; //移动方向
            role.start();
        }
        function stopSprite(role) {
            role.direction = -1;
            role.stop();
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


        //计算 role 在 direction 方向 在 offsetMove 距离中碰到障碍的距离
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
                    if(role === objRoles[r])
                        continue;
                    if(GlobalLibraryJS.testRectangleClashed(
                                Qt.rect(role.x + role.x1 - offsetMove, role.y + role.y1, offsetMove, role.height1),
                                Qt.rect(objRoles[r].x + objRoles[r].x1, objRoles[r].y + objRoles[r].y1, objRoles[r].width1, objRoles[r].height1)
                                ))
                        offsetMove = (role.x + role.x1) - (objRoles[r].x + objRoles[r].x2) - 1;
                }
                //与主角碰撞
                for(let r in arrMainRoles) {
                    if(role === arrMainRoles[r])
                        continue;
                    if(GlobalLibraryJS.testRectangleClashed(
                                Qt.rect(role.x + role.x1 - offsetMove, role.y + role.y1, offsetMove, role.height1),
                                Qt.rect(arrMainRoles[r].x + arrMainRoles[r].x1, arrMainRoles[r].y + arrMainRoles[r].y1, arrMainRoles[r].width1, arrMainRoles[r].height1)
                                ))
                        offsetMove = (role.x + role.x1) - (arrMainRoles[r].x + arrMainRoles[r].x2) - 1;
                }

                return offsetMove;

                break;

            case Qt.Key_Right:

                for(let r in objRoles) {
                    if(role === objRoles[r])
                        continue;
                    if(GlobalLibraryJS.testRectangleClashed(
                                Qt.rect(role.x + role.x2 + 1, role.y + role.y1, offsetMove, role.height1),
                                Qt.rect(objRoles[r].x + objRoles[r].x1, objRoles[r].y + objRoles[r].y1, objRoles[r].width1, objRoles[r].height1)
                                ))
                        offsetMove = (objRoles[r].x + objRoles[r].x1) - (role.x + role.x2) - 1;
                }
                for(let r in arrMainRoles) {
                    if(role === arrMainRoles[r])
                        continue;
                    if(GlobalLibraryJS.testRectangleClashed(
                                Qt.rect(role.x + role.x2 + 1, role.y + role.y1, offsetMove, role.height1),
                                Qt.rect(arrMainRoles[r].x + arrMainRoles[r].x1, arrMainRoles[r].y + arrMainRoles[r].y1, arrMainRoles[r].width1, arrMainRoles[r].height1)
                                ))
                        offsetMove = (arrMainRoles[r].x + arrMainRoles[r].x1) - (role.x + role.x2) - 1;
                }

                return offsetMove;

                break;

            case Qt.Key_Up: //同Left

                for(let r in objRoles) {
                    if(role === objRoles[r])
                        continue;
                    if(GlobalLibraryJS.testRectangleClashed(
                                Qt.rect(role.x + role.x1, role.y + role.y1 - offsetMove, role.width1, offsetMove),
                                Qt.rect(objRoles[r].x + objRoles[r].x1, objRoles[r].y + objRoles[r].y1, objRoles[r].width1, objRoles[r].height1)
                                ))
                        offsetMove = (role.y + role.y1) - (objRoles[r].y + objRoles[r].y2) - 1;
                }
                for(let r in arrMainRoles) {
                    if(role === arrMainRoles[r])
                        continue;
                    if(GlobalLibraryJS.testRectangleClashed(
                                Qt.rect(role.x + role.x1, role.y + role.y1 - offsetMove, role.width1, offsetMove),
                                Qt.rect(arrMainRoles[r].x + arrMainRoles[r].x1, arrMainRoles[r].y + arrMainRoles[r].y1, arrMainRoles[r].width1, arrMainRoles[r].height1)
                                ))
                        offsetMove = (role.y + role.y1) - (arrMainRoles[r].y + arrMainRoles[r].y2) - 1;
                }

                return offsetMove;

                break;

            case Qt.Key_Down:   //同Right

                for(let r in objRoles) {
                    if(role === objRoles[r])
                        continue;
                    if(GlobalLibraryJS.testRectangleClashed(
                                Qt.rect(role.x + role.x1, role.y + role.y2 + 1, role.width1, offsetMove),
                                Qt.rect(objRoles[r].x + objRoles[r].x1, objRoles[r].y + objRoles[r].y1, objRoles[r].width1, objRoles[r].height1)
                                ))
                        offsetMove = (objRoles[r].y + objRoles[r].y1) - (role.y + role.y2) - 1;
                }
                for(let r in arrMainRoles) {
                    if(role === arrMainRoles[r])
                        continue;
                    if(GlobalLibraryJS.testRectangleClashed(
                                Qt.rect(role.x + role.x1, role.y + role.y2 + 1, role.width1, offsetMove),
                                Qt.rect(arrMainRoles[r].x + arrMainRoles[r].x1, arrMainRoles[r].y + arrMainRoles[r].y1, arrMainRoles[r].width1, arrMainRoles[r].height1)
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

            offsetMove = _private.fComputeRoleMoveToObstacleOffset(role, direction, offsetMove);

            if(offsetMove <= 0)
                return 0;

            offsetMove = _private.fComputeRoleMoveToRolesOffset(role, direction, offsetMove);

            return offsetMove;
        }

        function fChangeMainRoleDirection() {
            return;

            console.debug("！！碰墙返回", mainRole.direction);
            if(mainRole.props.$tmpDirection !== undefined) {
                _private.startSprite(mainRole, mainRole.props.$tmpDirection);
                delete mainRole.props.$tmpDirection;
                return;
            }

            //人物的占位最中央 所在地图的坐标
            let bx = Math.floor((mainRole.x + mainRole.x1 + mainRole.width1 / 2) / sizeMapBlockSize.width);
            let by = Math.floor((mainRole.y + mainRole.y1 + mainRole.height1 / 2) / sizeMapBlockSize.height);

            switch(mainRole.direction) {
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

                    console.debug("！！转方向Left", mainRole.direction, Qt.Key_Left)
                    mainRole.props.$tmpDirection = mainRole.direction;
                    _private.startSprite(mainRole, Qt.Key_Left);
                    if(offsetMove > toffset1)
                        offsetMove = toffset1;
                }
                else {
                    if(toffset2 < _private.fComputeRoleMoveOffset(mainRole, Qt.Key_Right, toffset2)) {
                        console.debug("！！右有障碍返回")
                        return;
                    }

                    console.debug("！！转方向Right", mainRole.direction, Qt.Key_Right)
                    mainRole.props.$tmpDirection = mainRole.direction;
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


        //清空canvas
        function clearCanvas(canvas) {
            let ctx = canvas.getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height);
        }

    }


    Component {
        id: compRole

        Role {
            //在场景中的坐标
            readonly property int sceneX: x + itemContainer.x
            readonly property int sceneY: y + itemContainer.y

            //行动类别；
            //0为停止；1为缓慢走；2为。。。
            property int nActionType: 1
            //状态持续时间
            property int nActionStatusKeepTime: 0

            //其他属性（用户自定义）
            property var props: ({})


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



            Component.onCompleted: {
                //console.debug("[GameScene]Role Component.onCompleted");
            }
        }

    }



    Connections {
        target: Qt.application
        function onStateChanged() {
            switch(Qt.application.state){
            case Qt.ApplicationActive:   //每次窗口激活时触发
                _private.keys = {};
                mainRole.direction = -1;
                itemBackgroundMusic.resume();
                break;
            case Qt.ApplicationInactive:    //每次窗口非激活时触发
                _private.keys = {};
                mainRole.direction = -1;
                itemBackgroundMusic.pause();
                break;
            case Qt.ApplicationSuspended:   //程序挂起（比如安卓的后台运行、息屏）
                _private.keys = {};
                mainRole.direction = -1;
                itemBackgroundMusic.pause();
                break;
            case Qt.ApplicationHidden:
                _private.keys = {};
                mainRole.direction = -1;
                itemBackgroundMusic.pause();
                break;
            }
        }
    }


    Component.onCompleted: {

        //console.debug("[GameScene]globalObject：", GameManager.globalObject().game);
        GameManager.globalObject().game = game;
        //GameManager.globalObject().g = g;
        //console.debug("[GameScene]globalObject：", GameManager.globalObject().game);

        console.debug("[GameScene]Component.onCompleted");
    }
}
