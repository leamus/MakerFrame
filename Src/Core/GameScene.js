//.pragma library //单例（只有一个实例的共享脚本，且没有任何QML文件的环境。如果不加这句，则每个引入此文件的QML都有一个此文件的实例，且环境为引入的QML文件环境）。
//库文件不能使用 导入它的QML的上下文环境，包括C++注入的对象 和 注册的类，但全局对象可以（比如Qt）；给js全局对象注入的属性也可以（比如FrameManager.globalObject().game = game）。


//.import "xxx.js" as Abc       //导入另一个js文件（必须有as，必须首字母大写）
//.import "GlobalLibrary.js" as GlobalLibraryJS
//.import "Global.js" as GlobalJS
//let jsLevelChain = JSLevelChain;    //让外部可访问


//.import QtQuick.Window 2.14 as Window   //导入QML模块（必须有as，必须首字母大写）
//  （非库文件：如果没有任何.import语句，则貌似可以直接使用 QML组件，如果有一个.import，则必须导入每个对应组件才可以使用QML组件!!!）



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
        _private.objCommonScripts["fight_combatant_position_algorithm"] = tCommoncript.$fightCombatantPositionAlgorithm;
        _private.objCommonScripts["fight_combatant_melee_position_algorithm"] = tCommoncript.$fightCombatantMeleePositionAlgorithm;
        _private.objCommonScripts["fight_skill_melee_position_algorithm"] = tCommoncript.$fightSkillMeleePositionAlgorithmt;
        _private.objCommonScripts["fight_menu"] = tCommoncript.$fightMenu;
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

    if(!_private.objCommonScripts["fight_combatant_position_algorithm"]) {
        _private.objCommonScripts["fight_combatant_position_algorithm"] = GameMakerGlobalJS.$fightCombatantPositionAlgorithm;
        console.debug("[!GameScene]载入系统战斗坐标算法");
    }
    else
        console.debug("[GameScene]载入战斗坐标算法OK");

    if(!_private.objCommonScripts["fight_combatant_melee_position_algorithm"]) {
        _private.objCommonScripts["fight_combatant_melee_position_algorithm"] = GameMakerGlobalJS.$fightCombatantMeleePositionAlgorithm;
        console.debug("[!GameScene]载入系统战斗近战坐标算法");
    }
    else
        console.debug("[GameScene]载入战斗近战坐标算法OK");

    if(!_private.objCommonScripts["fight_skill_melee_position_algorithm"]) {
        _private.objCommonScripts["fight_skill_melee_position_algorithm"] = GameMakerGlobalJS.$fightSkillMeleePositionAlgorithm;
        console.debug("[!GameScene]载入系统战斗特效坐标算法");
    }
    else
        console.debug("[GameScene]载入战斗特效坐标算法OK");

    if(!_private.objCommonScripts["fight_menu"]) {
        _private.objCommonScripts["fight_menu"] = GameMakerGlobalJS.$fightMenu;
        console.debug("[!GameScene]载入系统战斗菜单");
    }
    else
        console.debug("[GameScene]载入战斗菜单OK");

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
            if(_private.objGoods[item].$commons)
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
            //_private.objFightRoles[item].__proto__ = _private.objCommonScripts["combatant_class"].prototype;
            _private.objFightRoles[item].__proto__ = _private.objFightRoles[item].$commons;
            _private.objFightRoles[item].$commons.__proto__ = _private.objCommonScripts["combatant_class"].prototype;

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



    let mapOpacity = GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$map', 'opacity');
    if(GlobalLibraryJS.isValidNumber(mapOpacity))
        _private.config.rMapOpacity = mapOpacity;
    else
        _private.config.rMapOpacity = 0.6;

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
                button.width = tConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
                button.height = tConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
                if(tConfig.$color !== undefined)
                    button.color = tConfig.$color;
                if(tConfig.$opacity !== undefined)
                    button.opacity = tConfig.$opacity;
                if(tConfig.$image)
                    button.image.source = Global.toURL(GameMakerGlobal.imageResourceURL(tConfig.$image));
                button.anchors.rightMargin = tConfig.$right * rootWindow.aliasComponents.Screen.pixelDensity;
                button.anchors.bottomMargin = tConfig.$bottom * rootWindow.aliasComponents.Screen.pixelDensity;
                button.s_pressed.connect(function(){
                    //if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                    //    return;
                    game.run(tConfig.$clicked);
                });
            }

        }while(0);
    }while(0);

    joystick.width = joystickConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
    joystick.height = joystickConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
    joystick.anchors.leftMargin = joystickConfig.$left * rootWindow.aliasComponents.Screen.pixelDensity;
    joystick.anchors.bottomMargin = joystickConfig.$bottom * rootWindow.aliasComponents.Screen.pixelDensity;
    joystick.opacity = joystickConfig.$opacity;

    /*buttonA.width = buttonAConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonA.height = buttonAConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonA.color = buttonAConfig.$color;
    buttonA.opacity = buttonAConfig.$opacity;
    if(buttonAConfig.$image)
        buttonA.image.source = Global.toURL(GameMakerGlobal.imageResourceURL(buttonAConfig.$image));
    buttonA.anchors.rightMargin = buttonAConfig.$right * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonA.anchors.bottomMargin = buttonAConfig.$bottom * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonA.buttonClicked = buttonAConfig.$clicked;

    buttonMenu.width = buttonMenuConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonMenu.height = buttonMenuConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonMenu.color = buttonMenuConfig.$color;
    buttonMenu.opacity = buttonMenuConfig.$opacity;
    if(buttonMenuConfig.$image)
        buttonMenu.image.source = Global.toURL(GameMakerGlobal.imageResourceURL(buttonMenuConfig.$image));
    buttonMenu.anchors.rightMargin = buttonMenuConfig.$right * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonMenu.anchors.bottomMargin = buttonMenuConfig.$bottom * rootWindow.aliasComponents.Screen.pixelDensity;
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


function onTriggered() {

    //如果是0，则重新赋值
    if(timer.nLastTime <= 0) {
        timer.nLastTime = game.date().getTime();
        return;
    }

    let bAsyncScriptIsEmpty = _private.asyncScript.isEmpty();

    //获取精确时间差
    let realinterval = game.date().getTime() - timer.nLastTime;
    timer.nLastTime = timer.nLastTime + realinterval;

    game.$frameDuration = realinterval;

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


                let eventName = `$${role.$data.$id}_arrive`;
                let tScript = itemContainer.mapInfo.$$Script[eventName];
                if(!tScript)
                    tScript = game.f[eventName];
                if(!tScript)
                    tScript = game.gf[eventName];
                if(tScript)
                    GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '角色事件:' + role.$data.$id], role);
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
                let eventName = `$${role.$data.$id}_collide`;
                let tScript = itemContainer.mapInfo.$$Script[eventName];
                if(!tScript)
                    tScript = game.f[eventName];
                if(!tScript)
                    tScript = game.gf[eventName];
                if(tScript) {
                    //keep：是否是持续碰撞；
                    //key：
                    let keep = false;
                    let key = 'role_' + _private.objRoles[r].$data.$id;
                    if(role.$$collideRoles[key] !== undefined) {
                        keep = true;
                        collideRoles[key] = role.$$collideRoles[key] + realinterval;
                    }
                    else
                        collideRoles[key] = realinterval;

                    GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '角色碰撞角色事件:' + role.$data.$id], role, _private.objRoles[r], keep);
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
                let eventName = `$${role.$data.$id}_collide`;
                let tScript = itemContainer.mapInfo.$$Script[eventName];
                if(!tScript)
                    tScript = game.f[eventName];
                if(!tScript)
                    tScript = game.gf[eventName];
                if(tScript) {
                    //keep：是否是持续碰撞；
                    //key：
                    let keep = false;
                    let key = 'hero_' + _private.arrMainRoles[r].$data.$id;
                    if(role.$$collideRoles[key] !== undefined) {
                        keep = true;
                        collideRoles[key] = role.$$collideRoles[key] + realinterval;
                    }
                    else
                        collideRoles[key] = realinterval;
                    GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '角色碰撞主角事件:' + role.$data.$id], role, _private.arrMainRoles[r], keep);
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
                _private.doAction(2, Qt.Key_Left);
            }
            else if(mainRole.targetPos.x > centerX) {
                _private.doAction(2, Qt.Key_Right);
            }
            else if(mainRole.targetPos.y < centerY) {
                _private.doAction(2, Qt.Key_Up);
            }
            else if(mainRole.targetPos.y > centerY) {
                _private.doAction(2, Qt.Key_Down);
            }
            else {
                mainRole.nActionType = 0;

                _private.stopAction(1, -1);


                let eventName = `$${mainRole.$data.$id}_arrive`;
                let tScript = itemContainer.mapInfo.$$Script[eventName];
                if(!tScript)
                    tScript = game.f[eventName];
                if(!tScript)
                    tScript = game.gf[eventName];
                if(tScript)
                    GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '主角事件:' + mainRole.$data.$id], mainRole);
                    //game.run([tScript, mainRole.$name]);

                //console.debug('!!!ok, getup')
            }
        }

        //console.debug('moveDirection:', mainRole.moveDirection)


        //如果主角不移动，则跳出移动部分
        if(!mainRole.sprite.running)
            break;


        //下面是移动代码

        //计算真实移动偏移，初始为 角色速度 * 时间差
        let offsetMove = Math.round(mainRole.moveSpeed * realinterval);

        //如果开启摇杆加速，且用的不是键盘，则乘以摇杆偏移
        if(_private.config.rJoystickSpeed > 0 && mainRole.nActionType === 10 && GlobalLibraryJS.objectIsEmpty(_private.keys)) {
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


    //开始移动地图
    setMapToRole(_private.sceneRole);



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
    let runinterval = game.date().getTime() - timer.nLastTime;
    if(runinterval >= _private.config.nInterval) {
        timer.interval = 1;
    }
    else {
        timer.interval = _private.config.nInterval + _private.config.nInterval - runinterval;
    }

    //console.debug("!!!runinterval", runinterval, timer.interval);
    */

    //timer.nLastTime = timer.nLastTime + realinterval;

    //timer.start();

}
