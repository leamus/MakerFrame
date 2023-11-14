
//载入资源
function loadResources() {

    let projectpath = game.$projectpath + GameMakerGlobal.separator;



    //读通用算法脚本
    let tCommoncript;
    if(FrameManager.sl_qml_FileExists(Global.toPath(projectpath + 'common_script.js')))
        tCommoncript = _private.jsEngine.load('common_script.js', Global.toURL(projectpath));
    if(tCommoncript) {
        _private.objCommonScripts["game_init"] = tCommoncript.$gameInit;
        _private.objCommonScripts["before_save"] = tCommoncript.$beforeSave;
        _private.objCommonScripts["before_load"] = tCommoncript.$beforeLoad;
        _private.objCommonScripts["after_save"] = tCommoncript.$afterSave;
        _private.objCommonScripts["after_load"] = tCommoncript.$afterLoad;
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
        _private.objCommonScripts["fight_role_choice_skills_or_goods_algorithm"] = tCommoncript.$fightRoleChoiceSkillsOrGoodsAlgorithm;
        _private.objCommonScripts["fight_init_script"] = tCommoncript.$commonFightInitScript;
        _private.objCommonScripts["fight_start_script"] = tCommoncript.$commonFightStartScript;
        _private.objCommonScripts["fight_round_script"] = tCommoncript.$commonFightRoundScript;
        _private.objCommonScripts["fight_end_script"] = tCommoncript.$commonFightEndScript;
        _private.objCommonScripts["fight_combatant_position_algorithm"] = tCommoncript.$fightCombatantPositionAlgorithm;
        _private.objCommonScripts["fight_combatant_melee_position_algorithm"] = tCommoncript.$fightCombatantMeleePositionAlgorithm;
        _private.objCommonScripts["fight_skill_melee_position_algorithm"] = tCommoncript.$fightSkillMeleePositionAlgorithmt;
        _private.objCommonScripts["fight_combatant_set_choice"] = tCommoncript.$fightCombatantSetChoice;
        _private.objCommonScripts["fight_menus"] = tCommoncript.$fightMenus;
        _private.objCommonScripts["fight_buttons"] = tCommoncript.$fightButtons;
        //_private.objCommonScripts["resume_event_script"] = tCommoncript.$resumeEventScript;
        //_private.objCommonScripts["get_goods_script"] = tCommoncript.commonGetGoodsScript;
        //_private.objCommonScripts["use_goods_script"] = tCommoncript.commonUseGoodsScript;
        _private.objCommonScripts["equip_reserved_slots"] = tCommoncript.$equipReservedSlots;
        _private.objCommonScripts["fight_roles_round"] = tCommoncript.$fightRolesRound;
        _private.objCommonScripts["combatant_round_script"] = tCommoncript.$combatantRoundScript;

        //_private.objCommonScripts["events"] = tCommoncript.$events;
        //_private.objCommonScripts["get_buff"] = tCommoncript.$getBuff;

        game.$userscripts = tCommoncript;
    }
    else
        game.$userscripts = GameMakerGlobalJS;

    /*data = game.loadjson("common_algorithm.json");
    if(data) {
        let ret = GlobalJS._eval(data["FightAlgorithm"]);
        _private.objCommonScripts["game_over_script"] = ret.$gameOverScript;
        _private.objCommonScripts["common_run_away_algorithm"] = ret.$commonRunAwayAlgorithm;
        _private.objCommonScripts["fight_skill_algorithm"] = ret.$skillEffectAlgorithm;
        _private.objCommonScripts["fight_role_choice_skills_or_goods_algorithm"] = ret.$fightRoleChoiceSkillsOrGoodsAlgorithm;
        _private.objCommonScripts["fight_start_script"] = ret.$commonFightStartScript;
        _private.objCommonScripts["fight_round_script"] = ret.$commonFightRoundScript;
        _private.objCommonScripts["fight_end_script"] = ret.$commonFightEndScript;
        //_private.objCommonScripts["resume_event_script"] = ret.$resumeEventScript;
        _private.objCommonScripts["get_goods_script"] = ret.commonGetGoodsScript;
        _private.objCommonScripts["use_goods_script"] = ret.commonUseGoodsScript;
        _private.objCommonScripts["equip_reserved_slots"] = ret.$equipReservedSlots;
    }*/
    if(!_private.objCommonScripts["game_init"]) {
        _private.objCommonScripts["game_init"] = GameMakerGlobalJS.$gameInit;
        console.debug("[!GameScene]载入系统游戏初始化脚本");
    }
    else
        console.debug("[GameScene]载入游戏初始化脚本OK");

    if(!_private.objCommonScripts["before_save"]) {
        _private.objCommonScripts["before_save"] = GameMakerGlobalJS.$beforeSave;
        console.debug("[!GameScene]载入系统存档前脚本");
    }
    else
        console.debug("[GameScene]载入存档前脚本OK");

    if(!_private.objCommonScripts["before_load"]) {
        _private.objCommonScripts["before_load"] = GameMakerGlobalJS.$beforeLoad;
        console.debug("[!GameScene]载入系统读档前脚本");
    }
    else
        console.debug("[GameScene]载入读档前脚本OK");

    if(!_private.objCommonScripts["after_save"]) {
        _private.objCommonScripts["after_save"] = GameMakerGlobalJS.$afterSave;
        console.debug("[!GameScene]载入系统存档后脚本");
    }
    else
        console.debug("[GameScene]载入存档后脚本OK");

    if(!_private.objCommonScripts["after_load"]) {
        _private.objCommonScripts["after_load"] = GameMakerGlobalJS.$afterLoad;
        console.debug("[!GameScene]载入系统读档后脚本");
    }
    else
        console.debug("[GameScene]载入读档后脚本OK");


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

    if(!_private.objCommonScripts["fight_role_choice_skills_or_goods_algorithm"]) {
        _private.objCommonScripts["fight_role_choice_skills_or_goods_algorithm"] = GameMakerGlobalJS.$fightRoleChoiceSkillsOrGoodsAlgorithm;
        console.debug("[!GameScene]载入战斗人物选择技能或物品算法");
    }
    else
        console.debug("[GameScene]载入战斗人物选择技能或物品算法OK");


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

    if(!_private.objCommonScripts["fight_combatant_set_choice"]) {
        _private.objCommonScripts["fight_combatant_set_choice"] = GameMakerGlobalJS.$fightCombatantSetChoice;
        console.debug("[!GameScene]载入系统设置 战斗人物的 初始化 或 休息");
    }
    else
        console.debug("[GameScene]载入设置 战斗人物的 初始化 或 休息OK");

    if(!_private.objCommonScripts["fight_menus"]) {
        _private.objCommonScripts["fight_menus"] = GameMakerGlobalJS.$fightMenus;
        console.debug("[!GameScene]载入系统战斗菜单");
    }
    else
        console.debug("[GameScene]载入战斗菜单OK");

    if(!_private.objCommonScripts["fight_buttons"]) {
        _private.objCommonScripts["fight_buttons"] = GameMakerGlobalJS.$fightButtons;
        console.debug("[!GameScene]载入系统战斗按钮");
    }
    else
        console.debug("[GameScene]载入战斗按钮OK");

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

    if(!_private.objCommonScripts["fight_roles_round"]) {
        _private.objCommonScripts["fight_roles_round"] = GameMakerGlobalJS.$fightRolesRound;
        console.debug("[!GameScene]载入系统战斗人物回合顺序");
    }
    else
        console.debug("[GameScene]载入战斗人物回合顺序OK");

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



//读取配置：

    //是否提前载入所有资源
    _private.config.nLoadAllResources = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$game', '$loadAllResources'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$game', '$loadAllResources'), 0);

    //地图遮挡透明度
    _private.config.rMapOpacity = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$map', '$opacity'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$map', '$opacity'), 0.6);


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


    //摇杆 默认值

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
            GameSceneJS.buttonAClicked();
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



    //起始脚本
    if(FrameManager.sl_qml_FileExists(Global.toPath(projectpath + 'start.js'))) {
        //载入初始脚本
        let ts = _private.jsEngine.load('start.js', Global.toURL(projectpath));
        if(ts) {
            _private.objCommonScripts["game_start"] = ts.$start || ts.start;
            //_private.objCommonScripts["game_init"] = ts.$init || ts.init;
            //_private.objCommonScripts["game_save_script"] = ts.$save || ts.save;
            //_private.objCommonScripts["game_load_script"] = ts.$load || ts.load;
        }
    }



//各资源

    let path;
    let items;


    if(_private.config.nLoadAllResources) {
        //读道具信息
        path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName;
        items = FrameManager.sl_qml_listDir(Global.toPath(path), "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let data = getGoodsResource(item, true);
            if(data) {
                console.debug("[GameScene]载入Goods", item);
            }
            else
                console.warn("[!GameScene]载入Goods ERROR", item);


            /*let filePath = path + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "goods.json";
            //console.debug(path, items, item, filePath)
            let data = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));

            if(data !== "") {
                data = JSON.parse(data);
                let t = GlobalJS._eval(data["Goods"]);
                if(t) {
                    _private.goodsResource[item] = t;
                    _private.goodsResource[item].$rid = item;
                    console.debug("[GameScene]载入Goods", item);
                }
            }
            if(!data)
                console.warn("[!GameScene]载入Goods ERROR", item);
            */
        }
    }


    if(_private.config.nLoadAllResources) {
        //读技能信息
        path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName;
        items = FrameManager.sl_qml_listDir(Global.toPath(path), "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let data = getSkillResource(item, true);
            if(data) {
                console.debug("[GameScene]载入FightSkill", item);
            }
            else
                console.warn("[!GameScene]载入FightSkill ERROR", item);


            /*let filePath = path + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "fight_skill.json";
            //console.debug(path, items, item, filePath)
            let data = FrameManager.sl_qml_ReadFile(Global.toPath(filePath));

            if(data !== "") {
                data = JSON.parse(data);
                let t = GlobalJS._eval(data["FightSkill"]);
                if(t) {
                    _private.skillsResource[item] = t;
                    _private.skillsResource[item].$rid = item;
                    console.debug("[GameScene]载入FightSkill", item);
                }
            }
            if(!data)
                console.warn("[!GameScene]载入FightSkill ERROR", item);
            */
        }
    }


    if(_private.config.nLoadAllResources) {
        //读战斗脚本信息
        path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName;
        items = FrameManager.sl_qml_listDir(Global.toPath(path), "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let data = getFightScriptResource(item, true);
            if(data) {
                console.debug("[GameScene]载入FightScript", item);
            }
            else
                console.warn("[!GameScene]载入FightScript ERROR", item);


        }
    }



    if(_private.config.nLoadAllResources) {
        //读战斗角色信息
        path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName;
        items = FrameManager.sl_qml_listDir(Global.toPath(path), "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let data = getFightRoleResource(item, true);
            if(data) {
                console.debug("[GameScene]载入FightRole Script", item);
            }
            else
                console.warn("[!GameScene]载入FightRole Script ERROR", item);



            //let data = File.read(filePath);
            /*let data = FrameManager.sl_qml_ReadFile(Global.toPath(path + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "fight_role.json"));

            if(data) {
                data = JSON.parse(data);

                //_private.fightRolesResource[item] = data;
                _private.fightRolesResource[item].ActionData = data.ActionData;
                console.debug("[GameScene]载入FightRole", item);
            }
            else {
                console.warn("[!GameScene]载入FightRole ERROR：" + item);
                continue;
            }
            */

        }
    }



    if(_private.config.nLoadAllResources) {
        //读特效信息
        path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName;
        items = FrameManager.sl_qml_listDir(Global.toPath(path), "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            //console.debug(path, items, item)
            let data = getSpriteResource(item, true);
            if(data) {
                console.debug("[GameScene]载入Sprite", item);
            }
            else
                console.warn("[!GameScene]载入Sprite ERROR", item);
        }
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
        let ret = GlobalJS._eval(data["LevelChainScript"]);
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


    loaderFightScene.load();



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
                //if(ts.$pluginId !== undefined) {    //插件有ID
                //    _private.objPlugins[ts.$pluginId] = ts;
                //}
                if(!GlobalLibraryJS.isObject(_private.objPlugins[tc0]))
                    _private.objPlugins[tc0] = {};
                _private.objPlugins[tc0][tc1] = ts;


                if(ts.$load && ts.$autoLoad !== false) {
                    ts.$load();
                }
            }
            catch(e) {
                console.error('[!GameScene]', e);
                continue;
            }
        }
    }



    game.setinterval(16);
    game.scale(1);

}


//卸载资源
function unloadResources() {

    //卸载扩展 插件、组件
    for(let tc in _private.objPlugins)
        for(let tp in _private.objPlugins[tc])
            if(_private.objPlugins[tc][tp].$unload && _private.objPlugins[tc][tp].$autoLoad !== false)
                _private.objPlugins[tc][tp].$unload();


    loaderFightScene.unload();


    if(Qt.platform.os === "android") {
        Platform.setScreenOrientation(_private.lastOrient);
        //if(game.$userscripts.$config && game.$userscripts.$config.$android)
    }


    for(let i in _private.spritesResource) {
        _private.spritesResource[i].$$cache.image.destroy();
        if(_private.spritesResource[i].$$cache.audio)
            _private.spritesResource[i].$$cache.audio.destroy();
    }
    _private.spritesResource = {};

    _private.goodsResource = {};
    _private.fightRolesResource = {};
    _private.skillsResource = {};
    _private.fightScriptsResource = {};

    _private.objCommonScripts = {};

    _private.objCacheSoundEffects = {};

    //_private.objImages = {};
    //_private.objMusic = {};
    //_private.objVideos = {};

    game.$userscripts = null;

    _private.objPlugins = {};

    _private.jsEngine.clear();



    for(let tb in itemButtons.children) {
        itemButtons.children[tb].destroy();
    }

}



//返回 通用脚本中的某个函数或变量，如果没有则返回系统的
function getCommonScriptResource(flags=0b1, defaultValue, ...names) {
    return GlobalLibraryJS.shortCircuit(flags, GlobalLibraryJS.getObjectValue(game, '$userscripts', ...names), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', ...names), defaultValue);
}


//获取 Goods 资源
function getGoodsResource(item, forceReload=false) {

    //读取
    if(_private.goodsResource[item]) //如果有
        return _private.goodsResource[item];
    else if(_private.config.nLoadAllResources && !forceReload)  //如果已经加载了所有的资源
        return null;


    //读道具信息
    let path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName;

    let ts = _private.jsEngine.load('goods.js', Global.toURL(path + GameMakerGlobal.separator + item));
    let data = ts.data;

    //写入
    if(data) {
        _private.goodsResource[item] = ts.data;
        _private.goodsResource[item].$rid = item;
        let _proto_ = GlobalLibraryJS.shortCircuit(0b1111, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$prototypeGoods'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$prototypeGoods'), {});
        if(_private.goodsResource[item].$commons) {
            _private.goodsResource[item].$commons.__proto__ = _proto_;
            _private.goodsResource[item].__proto__ = _private.goodsResource[item].$commons;
        }
        else
            _private.goodsResource[item].__proto__ = _proto_;

        return data;
    }

    return null;
}

//获取 Skills 资源
function getSkillResource(item, forceReload=false) {

    //读取
    if(_private.skillsResource[item]) //如果有
        return _private.skillsResource[item];
    else if(_private.config.nLoadAllResources && !forceReload)  //如果已经加载了所有的资源
        return null;


    //读技能信息
    let path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName;

    let ts = _private.jsEngine.load('fight_skill.js', Global.toURL(path + GameMakerGlobal.separator + item));
    let data = ts.data;

    //写入
    if(data) {
        _private.skillsResource[item] = ts.data;
        _private.skillsResource[item].$rid = item;
        let _proto_ = GlobalLibraryJS.shortCircuit(0b1111, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$prototypeSkill'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$prototypeSkill'), {});
        if(_private.skillsResource[item].$commons) {
            _private.skillsResource[item].$commons.__proto__ = _proto_;
            _private.skillsResource[item].__proto__ = _private.skillsResource[item].$commons;
        }
        else
            _private.skillsResource[item].__proto__ = _proto_;

        return data;
    }

    return null;
}

//获取 FightScript 资源
function getFightScriptResource(item, forceReload=false) {

    //读取
    if(_private.fightScriptsResource[item]) //如果有
        return _private.fightScriptsResource[item];
    else if(_private.config.nLoadAllResources && !forceReload)  //如果已经加载了所有的资源
        return null;


    //读战斗脚本信息
    let path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName;

    let ts = _private.jsEngine.load('fight_script.js', Global.toURL(path + GameMakerGlobal.separator + item));
    let data = ts.data;

    //写入
    if(data) {
        _private.fightScriptsResource[item] = ts.data;
        _private.fightScriptsResource[item].$rid = item;
        let _proto_ = GlobalLibraryJS.shortCircuit(0b1111, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$prototypeFightScript'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$prototypeFightScript'), {});
        if(_private.fightScriptsResource[item].$commons) {
            _private.fightScriptsResource[item].$commons.__proto__ = _proto_;
            _private.fightScriptsResource[item].__proto__ = _private.fightScriptsResource[item].$commons;
        }
        else
            _private.fightScriptsResource[item].__proto__ = _proto_;

        return data;
    }

    return null;
}

//获取 FightRole 资源
function getFightRoleResource(item, forceReload=false) {

    //读取
    if(_private.fightRolesResource[item]) //如果有
        return _private.fightRolesResource[item];
    else if(_private.config.nLoadAllResources && !forceReload)  //如果已经加载了所有的资源
        return null;


    //读战斗角色信息
    let path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName;

    let ts = _private.jsEngine.load('fight_role.js', Global.toURL(path + GameMakerGlobal.separator + item));
    let data = ts.data;

    //写入
    if(data) {
        //_private.fightRolesResource[item].$createData = ts.$createData;
        //_private.fightRolesResource[item].$commons = ts.$commons;

        _private.fightRolesResource[item] = ts.data;
        _private.fightRolesResource[item].$rid = item;
        if(_private.fightRolesResource[item].$commons) {
            _private.fightRolesResource[item].__proto__ = _private.fightRolesResource[item].$commons;
            _private.fightRolesResource[item].$commons.__proto__ = _private.objCommonScripts["combatant_class"].prototype;
        }
        else {
            _private.fightRolesResource[item].__proto__ = _private.objCommonScripts["combatant_class"].prototype;
        }

        return data;
    }

    return null;
}


//获取 Sprite 资源
function getSpriteResource(item, forceReload=false) {

    //读取
    if(_private.spritesResource[item]) //如果有
        return _private.spritesResource[item];
    else if(_private.config.nLoadAllResources && !forceReload)  //如果已经加载了所有的资源
        return null;


    //读特效信息
    let path = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName;

    let data = FrameManager.sl_qml_ReadFile(Global.toPath(path + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "sprite.json"));
    if(data)
        data = JSON.parse(data);

    //写入
    if(data) {
        _private.spritesResource[item] = data;
        _private.spritesResource[item].$rid = item;
        //_private.spritesResource[item].__proto__ = _private.spritesResource[item].$commons;

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
        _private.spritesResource[item].$$cache = {image: cacheImage, audio: cacheSoundEffect};

        return data;
    }

    return null;
}




//创建Skill对象
//forceNew：当skill为技能对象时，forceNew为true或对象（会复制它的属性）则表示再新建一个相同的技能对象返回；skill为其他类型，则会复制forceNew的属性；
function getSkillObject(skill, forceNew=true) {
    let retSkill = null;
    if(GlobalLibraryJS.isString(skill)) {
        let resSkill = GameSceneJS.getSkillResource(skill);
        if(!resSkill) {
            console.warn('[!GameScene]没有技能：', skill);
            return null;
        }

        //创建技能
        retSkill = {$rid: skill};
        if(resSkill.$createData)
            GlobalLibraryJS.copyPropertiesToObject(retSkill, resSkill.$createData());
        if(GlobalLibraryJS.isObject(forceNew))
            GlobalLibraryJS.copyPropertiesToObject(retSkill, forceNew/*, true*/);
        retSkill.__proto__ = resSkill;
    }
    else if(GlobalLibraryJS.isObject(skill)) {
        let resSkill;
        //如果已是 技能对象，直接返回
        if(skill.$rid && (resSkill = GameSceneJS.getSkillResource(skill.$rid))) {
            if(forceNew === false) {
                skill.__proto__ = resSkill;
                retSkill = skill;
                //return skill;
            }
            else {
                /*if(resSkill.$createData)
                    retSkill = resSkill.$createData();
                else
                    retSkill = {};
                */
                retSkill = {};
                GlobalLibraryJS.copyPropertiesToObject(retSkill, skill/*, true*/);
                if(GlobalLibraryJS.isObject(forceNew))
                    GlobalLibraryJS.copyPropertiesToObject(retSkill, forceNew/*, true*/);
                retSkill.__proto__ = resSkill;

                //return retSkill;
            }
        }

        else {
            resSkill = GameSceneJS.getSkillResource(skill.RId);
            if(!resSkill) {
                console.warn('[!GameScene]没有技能：', skill.RId);
                return null;
            }

            //创建技能
            retSkill = {$rid: skill.RId};
            if(resSkill.$createData)
                GlobalLibraryJS.copyPropertiesToObject(retSkill, resSkill.$createData(skill.Params));
            //delete skill.RId;
            //delete skill.Params;
            GlobalLibraryJS.copyPropertiesToObject(retSkill, skill, {filterExcept: {RId: undefined, Params: undefined}, filterRecursion: false});
            if(GlobalLibraryJS.isObject(forceNew))
                GlobalLibraryJS.copyPropertiesToObject(retSkill, forceNew/*, true*/);
            retSkill.__proto__ = resSkill;
        }
    }
    else
        return null;


    return retSkill;
}

//创建Goods对象
//forceNew：当goods为道具对象时，forceNew为true或对象（会复制它的属性）则表示再新建一个相同的道具对象返回；goods为其他类型，则会复制forceNew的属性；
function getGoodsObject(goods, forceNew=true) {
    let retGoods = null;
    if(GlobalLibraryJS.isString(goods)) {
        let resGoods = GameSceneJS.getGoodsResource(goods);
        if(!resGoods) {
            console.warn('[!GameScene]没有道具：', goods);
            return null;
        }

        retGoods = {$rid: goods};
        if(resGoods.$createData)
            GlobalLibraryJS.copyPropertiesToObject(retGoods, resGoods.$createData());
        if(GlobalLibraryJS.isObject(forceNew))
            GlobalLibraryJS.copyPropertiesToObject(retGoods, forceNew/*, true*/);
        retGoods.__proto__ = resGoods;
    }
    else if(GlobalLibraryJS.isObject(goods)) {
        let resGoods;
        //如果已是 道具对象
        if(goods.$rid && (resGoods = GameSceneJS.getGoodsResource(goods.$rid))) {
            if(forceNew === false) {
                goods.__proto__ = resGoods;
                retGoods = goods;
                //return goods;
            }
            else {
                /*
                if(resGoods.$createData)
                    retGoods = resGoods.$createData();
                else
                    retGoods = {};
                */
                retGoods = {};
                GlobalLibraryJS.copyPropertiesToObject(retGoods, goods/*, true*/);
                if(GlobalLibraryJS.isObject(forceNew))
                    GlobalLibraryJS.copyPropertiesToObject(retGoods, forceNew/*, true*/);
                retGoods.__proto__ = resGoods;

                //return retGoods;
            }
        }

        else {
            resGoods = GameSceneJS.getGoodsResource(goods.RId);
            if(!resGoods) {
                console.warn('[!GameScene]没有道具：', goods.RId);
                return null;
            }

            retGoods = {$rid: goods.RId};
            if(resGoods.$createData)
                GlobalLibraryJS.copyPropertiesToObject(retGoods, resGoods.$createData(goods.Params));
            //delete goods.RId;
            //delete goods.Params;
            GlobalLibraryJS.copyPropertiesToObject(retGoods, goods, {filterExcept: {RId: undefined, Params: undefined}, filterRecursion: false});
            if(GlobalLibraryJS.isObject(forceNew))
                GlobalLibraryJS.copyPropertiesToObject(retGoods, forceNew/*, true*/);
            retGoods.__proto__ = resGoods;
        }
    }
    else
        return null;


    //得到道具所有的skill对象 并替换到skills
    if(retGoods.$skills) {
        let tskills = [];
        for(let tskill in retGoods.$skills) {
            let t = GameSceneJS.getSkillObject(retGoods.$skills[tskill], forceNew);
            if(t)
                tskills.push(t);
        }
        retGoods.$skills = tskills;
    }
    else
        retGoods.$skills = [];

    if(retGoods.$fight) {
        let tskills = [];
        for(let tfight in retGoods.$fight) {
            let t = GameSceneJS.getSkillObject(retGoods.$fight[tfight], forceNew);
            if(t)
                tskills.push(t);
        }
        retGoods.$fight = tskills;
    }
    else
        retGoods.$fight = [];


    return retGoods;
}

//创建FightRole对象
//forceNew：当FightRole为战斗人物对象时，forceNew为true或对象（会复制它的属性）则表示再新建一个相同的战斗人物对象返回；FightRole为其他类型，则会复制forceNew的属性；
function getFightRoleObject(fightrole, forceNew=true) {
    let retFightRole = null;
    if(GlobalLibraryJS.isString(fightrole)) {
        let resFightRole = GameSceneJS.getFightRoleResource(fightrole);
        if(!resFightRole) {
            console.warn('[!GameScene]没有战斗角色：', fightrole);
            return null;
        }

        //创建战斗人物
        retFightRole = {$rid: fightrole};
        GlobalLibraryJS.copyPropertiesToObject(retFightRole, new _private.objCommonScripts["combatant_class"](fightrole));
        if(resFightRole.$createData)
            GlobalLibraryJS.copyPropertiesToObject(retFightRole, resFightRole.$createData());
        if(GlobalLibraryJS.isObject(forceNew))
            GlobalLibraryJS.copyPropertiesToObject(retFightRole, forceNew/*, true*/);
        retFightRole.__proto__ = resFightRole;
    }
    else if(GlobalLibraryJS.isObject(fightrole)) {
        let resFightRole;
        //如果已是 战斗人物对象，直接返回
        if(fightrole.$rid && (resFightRole = GameSceneJS.getFightRoleResource(fightrole.$rid))) {
            if(forceNew === false) {
                fightrole.__proto__ = resFightRole;
                retFightRole = fightrole;
                //return fightrole;
            }
            else {
                retFightRole = new _private.objCommonScripts["combatant_class"](fightrole.$rid);
                //if(resFightRole.$createData)
                //    GlobalLibraryJS.copyPropertiesToObject(retFightRole, resFightRole.$createData());
                GlobalLibraryJS.copyPropertiesToObject(retFightRole, fightrole, {filterExcept: {$$fightData: undefined, Params: undefined}}/*, true*/);
                if(GlobalLibraryJS.isObject(forceNew))
                    GlobalLibraryJS.copyPropertiesToObject(retFightRole, forceNew/*, true*/);
                retFightRole.__proto__ = resFightRole;

                //return retFightRole;
            }
        }

        else {
            resFightRole = GameSceneJS.getFightRoleResource(fightrole.RId);
            if(!resFightRole) {
                console.warn('[!GameScene]没有战斗角色：', fightrole.RId);
                return null;
            }
            //创建战斗人物
            retFightRole = {$rid: fightrole.RId};
            GlobalLibraryJS.copyPropertiesToObject(retFightRole, new _private.objCommonScripts["combatant_class"](fightrole.RId));
            if(resFightRole.$createData)
                GlobalLibraryJS.copyPropertiesToObject(retFightRole, resFightRole.$createData(fightrole.Params));
            //delete fightrole.RId;
            //delete fightrole.Params;
            GlobalLibraryJS.copyPropertiesToObject(retFightRole, fightrole, {filterExcept: {RId: undefined, Params: undefined, $$fightData: undefined}, filterRecursion: false});
            if(GlobalLibraryJS.isObject(forceNew))
                GlobalLibraryJS.copyPropertiesToObject(retFightRole, forceNew/*, true*/);
            retFightRole.__proto__ = resFightRole;
        }
    }
    else
        return null;


    //替换所有equip、goods、skills 为对象
    if(retFightRole.$skills) {
        let tskills = [];
        for(let tt in retFightRole.$skills) {
            let t = GameSceneJS.getSkillObject(retFightRole.$skills[tt], forceNew);
            if(t)
                tskills.push(t);
        }
        retFightRole.$skills = tskills;
    }
    else
        retFightRole.$skills = [];

    if(retFightRole.$goods) {
        let tGoods = [];
        for(let tt in retFightRole.$goods) {
            let t = GameSceneJS.getGoodsObject(retFightRole.$goods[tt], forceNew);
            if(t)
                tGoods.push(t);
        }
        retFightRole.$goods = tGoods;
    }
    else
        retFightRole.$goods = [];

    if(retFightRole.$equipment) {
        let tequipment = {};
        for(let tt in retFightRole.$equipment) {
            let t = GameSceneJS.getGoodsObject(retFightRole.$equipment[tt], forceNew);
            if(t)
                tequipment[tt] = t;
        }
        retFightRole.$equipment = tequipment;
    }
    else
        retFightRole.$equipment = {};


    //刷新
    _private.objCommonScripts["refresh_combatant"](retFightRole);


    return retFightRole;
}

function getFightScriptObject(fightscript, forceNew=true) {
    let retFightScript = null;
    if(GlobalLibraryJS.isString(fightscript)) {
        let resFightScript = GameSceneJS.getFightScriptResource(fightscript);
        if(!resFightScript) {
            console.warn('[!GameScene]没有战斗脚本：', fightscript);
            return null;
        }

        //创建战斗脚本
        retFightScript = {$rid: fightscript};
        if(resFightScript.$createData)
            GlobalLibraryJS.copyPropertiesToObject(retFightScript, resFightScript.$createData());
        if(GlobalLibraryJS.isObject(forceNew))
            GlobalLibraryJS.copyPropertiesToObject(retFightScript, forceNew/*, true*/);
        retFightScript.__proto__ = resFightScript;
    }
    else if(GlobalLibraryJS.isObject(fightscript)) {
        let resFightScript;
        //如果已是 战斗脚本对象，直接返回
        if(fightscript.$rid && (resFightScript = GameSceneJS.getFightScriptResource(fightscript.$rid))) {
            if(forceNew === false) {
                fightscript.__proto__ = resFightScript;
                retFightScript = fightscript;
                //return fightscript;
            }
            else {
                /*
                if(resFightScript.$createData)
                    retFightScript = resFightScript.$createData(fightscript.Params);
                else
                    retFightScript = {};
                */
                retFightScript = {};
                //GlobalLibraryJS.copyPropertiesToObject(retFightScript, new _private.objCommonScripts["combatant_class"](fightscript.$rid));
                GlobalLibraryJS.copyPropertiesToObject(retFightScript, fightscript/*, true*/);
                if(GlobalLibraryJS.isObject(forceNew))
                    GlobalLibraryJS.copyPropertiesToObject(retFightScript, forceNew/*, true*/);
                retFightScript.__proto__ = resFightScript;

                //return retFightScript;
            }
        }

        else {
            resFightScript = GameSceneJS.getFightScriptResource(fightscript.RId);
            if(!resFightScript) {
                console.warn('[!GameScene]没有战斗脚本：', fightscript.RId);
                return null;
            }

            //创建战斗脚本
            retFightScript = {$rid: fightscript.RId};
            if(resFightScript.$createData)
                GlobalLibraryJS.copyPropertiesToObject(retFightScript, resFightScript.$createData(fightscript.Params));
            //delete fightscript.RId;
            //delete fightscript.Params;
            GlobalLibraryJS.copyPropertiesToObject(retFightScript, fightscript, {filterExcept: {RId: undefined, Params: undefined}, filterRecursion: false});
            if(GlobalLibraryJS.isObject(forceNew))
                GlobalLibraryJS.copyPropertiesToObject(retFightScript, forceNew/*, true*/);
            retFightScript.__proto__ = resFightScript;
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

    let data = GameSceneJS.getSpriteResource(spriteEffectRId);

    if(data) {
        if(!spriteEffect) {
            spriteEffect = compCacheSpriteEffect.createObject(parent);
            spriteEffect.s_playEffect.connect(rootSoundEffect.playSoundEffect);
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

    console.warn("[!GameScene]载入特效失败：" + spriteEffectRId);
    return null;
}




function buttonAClicked() {
    console.debug("[GameScene]buttonAClicked");

    let bAsyncScriptIsEmpty = _private.asyncScript.isEmpty();


    //计算是否触发地图事件

    //人物面向的有效矩形
    let usePos = Qt.rect(0,0,0,0);

    //可以触发事件的最远距离
    let maxDistance;

    //人物方向
    switch(mainRole.moveDirection) {
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
            //console.debug("[GameScene]mapEvent触发:", event, mainRoleUseBlocks, itemContainer.mapEventBlocks[event]);    //触发
            GameSceneJS.mapEvent(itemContainer.mapEventBlocks[event], mainRole);   //触发事件

            //放在这里运行事件，因为 loadmap 的地图事件会改掉所有原来的事件；
            //如果异步脚本 初始为空，且现在不为空
            if(bAsyncScriptIsEmpty && !_private.asyncScript.isEmpty())
                game.run(true);

            return; //!!只执行一次事件
        }
        //console.debug("event:", event, mainRoleUseBlocks, mainRoleUseBlocks.indexOf(event), typeof(event), typeof(itemContainer.mapInfo.events[0]), typeof(mainRoleUseBlocks[0]))
    }

    //循环NPC
    for(let r in _private.objRoles) {
        if(GlobalLibraryJS.checkRectangleClashed(
            usePos,
            Qt.rect(_private.objRoles[r].x + _private.objRoles[r].x1, _private.objRoles[r].y + _private.objRoles[r].y1, _private.objRoles[r].width1, _private.objRoles[r].height1),
            0
        )) {
            console.debug("[GameScene]触发NPC事件：", _private.objRoles[r].$data.$id);

            //获得脚本（地图脚本优先级 > game.f定义的）
            let tScript = itemContainer.mapInfo.$$Script[_private.objRoles[r].$data.$id];
            if(!tScript)
                tScript = game.f[_private.objRoles[r].$data.$id];
            if(tScript) {
                game.run([tScript, _private.objRoles[r].$data.$id], _private.objRoles[r]);
                //GlobalJS.runScript(_private.asyncScript, 0, "game.f['%1']()".arg(_private.objRoles[r].$data.$id));

                return; //!!只执行一次事件
            }
        }
    }
}


//地图事件触发
function mapEvent(eventName, role) {
    let tScript;


    //主角和NPC的事件名不同
    if(role.$type === 1)
        tScript = itemContainer.mapInfo.$$Script['$' + eventName];
    else
        tScript = itemContainer.mapInfo.$$Script['$' + role.$data.$id + '_' + eventName + '_map'];
    if(!tScript && role.$type === 1)    //!!兼容旧的
        tScript = itemContainer.mapInfo.$$Script[eventName];
    if(!tScript)
        if(role.$type === 1)
            tScript = game.f['$' + eventName];
        else
            tScript = game.f['$' + role.$data.$id + '_' + eventName + '_map'];
    if(!tScript && role.$type === 1)    //!!兼容旧的
        tScript = game.f[eventName];

    if(tScript)
        GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '地图事件:' + role.$data.$id + '_' + eventName + '_map'], role);
    //game.run([tScript, '地图事件:' + eventName]);


    //调用一个总的
    tScript = itemContainer.mapInfo.$$Script['$map_' + eventName];
    if(tScript)
        GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '地图事件:map_' + eventName], role);



    console.debug("[GameScene]mapEvent:", role.$data.$id + '_' + eventName + '_map');    //触发
}
//离开事件触发
function mapEventCanceled(eventName, role) {
    let tScript;


    //主角和NPC的事件名不同
    if(role.$type === 1)
        tScript = itemContainer.mapInfo.$$Script['$' + eventName + '_map_leave'];
    else
        tScript = itemContainer.mapInfo.$$Script['$' + role.$data.$id + '_' + eventName + '_map_leave'];
    //if(!tScript)    //!!兼容旧的
    //    tScript = itemContainer.mapInfo.$$Script[eventName + '_map_leave'];
    if(!tScript)
        if(role.$type === 1)
            tScript = game.f['$' + eventName + '_map_leave'];
        else
            tScript = game.f['$' + role.$data.$id + '_' + eventName + '_map_leave'];
    //if(!tScript)    //!!兼容旧的
    //    tScript = game.f[eventName + '_map_leave'];


    if(tScript)
        GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '地图离开事件:' + role.$data.$id + '_' + eventName + '_map_leave'], role);
    //game.run([tScript, '地图事件离开:' + eventName + '_leave']);


    //调用一个总的
    tScript = itemContainer.mapInfo.$$Script['$_map_leave_' + eventName];
    if(tScript)
        GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '地图离开事件:map_leave_' + eventName], role);



    console.debug("[GameScene]mapEventCanceled:", role.$data.$id + '_' + eventName + '_map_leave');    //触发
}


//地图点击事件
function mapClickEvent(x, y) {

    let eventName = '$map_click';
    let tScript = itemContainer.mapInfo.$$Script[eventName];
    if(!tScript)
        tScript = game.f[eventName];
    if(!tScript)
        tScript = game.gf[eventName];
    if(tScript)
        game.run([tScript, eventName], -1, Math.floor(x / sizeMapBlockSize.width), Math.floor(y / sizeMapBlockSize.height), x, y);

    //console.debug(mouse.x, mouse.y,
    //              Math.floor(mouse.x / sizeMapBlockSize.width), Math.floor(mouse.y / sizeMapBlockSize.height))

}

//角色点击
function roleClickEvent(role, dx, dy) {
    console.debug("[GameScene]触发NPC点击事件：", role.$data.$id);

    let eventName = `$${role.$data.$id}_click`;
    //获得脚本（地图脚本优先级 > game.f定义的）
    let tScript = itemContainer.mapInfo.$$Script[eventName];
    if(!tScript)
        tScript = game.f[eventName];
    if(!tScript)
        tScript = game.gf[eventName];
    if(tScript) {
        game.run([tScript, role.$data.$id], role);
        //GlobalJS.runScript(_private.asyncScript, 0, "game.f['%1']()".arg(_private.objRoles[r].$name));

        return; //!!只执行一次事件
    }
    else {
        GameSceneJS.mapClickEvent(role.x + dx, role.y + dy);
        //mouse.accepted = false;
    }
}


//游戏主定时器
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


        let centerX = role.x + role.x1 + parseInt(role.width1 / 2);
        let centerY = role.y + role.y1 + parseInt(role.height1 / 2);

        //定向移动
        if(role.nActionType === 2) {

            do {
                if(role.targetsPos[0] && role.targetsPos[0].x >= 0 && role.targetsPos[0].x < centerX) {
                    role.moveDirection = Qt.Key_Left;
                    _private.startSprite(role, role.moveDirection);
                }
                else if(role.targetsPos[0] && role.targetsPos[0].x >= 0 && role.targetsPos[0].x > centerX) {
                    role.moveDirection = Qt.Key_Right;
                    _private.startSprite(role, role.moveDirection);
                }
                else if(role.targetsPos[0] && role.targetsPos[0].y >= 0 && role.targetsPos[0].y < centerY) {
                    role.moveDirection = Qt.Key_Up;
                    _private.startSprite(role, role.moveDirection);
                }
                else if(role.targetsPos[0] && role.targetsPos[0].y >= 0 && role.targetsPos[0].y > centerY) {
                    role.moveDirection = Qt.Key_Down;
                    _private.startSprite(role, role.moveDirection);
                }
                else {
                    role.targetsPos.shift();
                    if(role.targetsPos.length === 0) {
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
                            GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '角色Arrive事件:' + role.$data.$id], role);
                            //game.run([tScript, role.$name]);
                    }
                    else
                        continue;

                    //console.debug('!!!ok, getup')
                }
                break;
            } while(1);
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
                    if(role.targetsPos[0] && role.targetsPos[0].x >= 0 && role.targetsPos[0].x < centerX && role.targetsPos[0].x > centerX - offsetMove)
                        role.x = role.targetsPos[0].x - role.x1 - parseInt(role.width1 / 2);
                    else
                        role.x -= offsetMove;
                    break;

                case Qt.Key_Right:
                    if(role.targetsPos[0] && role.targetsPos[0].x >= 0 && role.targetsPos[0].x > centerX && role.targetsPos[0].x < centerX + offsetMove)
                        role.x = role.targetsPos[0].x - role.x1 - parseInt(role.width1 / 2);
                    else
                        role.x += offsetMove;
                    break;

                case Qt.Key_Up: //同Left
                    if(role.targetsPos[0] && role.targetsPos[0].y >= 0 && role.targetsPos[0].y < centerY && role.targetsPos[0].y > centerY - offsetMove)
                        role.y = role.targetsPos[0].y - role.y1 - parseInt(role.height1 / 2);
                    else
                        role.y -= offsetMove;
                    break;

                case Qt.Key_Down:   //同Right
                    if(role.targetsPos[0] && role.targetsPos[0].y >= 0 && role.targetsPos[0].y > centerY && role.targetsPos[0].y < centerY + offsetMove)
                        role.y = role.targetsPos[0].y - role.y1 - parseInt(role.height1 / 2);
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
                    Qt.rect(role.x + role.x1 - 1, role.y + role.y1 - 1, role.width1 + 2, role.height1 + 2),
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
                    let keep = false;   //是否是持续碰撞；
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
                    let keep = false;   //是否是持续碰撞；
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



        //计算是否触发地图事件

        let roleUseBlocks = [];

        //计算人物所占的地图块

        //返回 地图块坐标（左上和右下）
        let usedMapBlocks = _private.fComputeUseBlocks(role.x + role.x1, role.y + role.y1, role.x + role.x2, role.y + role.y2);

        //转换为 每个地图块ID
        for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
            for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
                roleUseBlocks.push(xb + yb * itemContainer.mapInfo.MapSize[0]);
            }
        }

        let tEvents = {};   //暂存这次触发的所有事件
        //循环事件
        for(let event in itemContainer.mapEventBlocks) {
            //console.debug("[GameScene]检测事件：", event, roleUseBlocks);
            //如果占用块包含事件块，则事件触发
            if(roleUseBlocks.indexOf(parseInt(event)) > -1) {
                let isTriggered = role.$$mapEventsTriggering[itemContainer.mapEventBlocks[event]] ||
                    tEvents[itemContainer.mapEventBlocks[event]];

                tEvents[itemContainer.mapEventBlocks[event]] = event;  //加入

                //如果已经被触发过
                if(isTriggered) {

                    ////将触发的事件删除（role.$$mapEventsTriggering剩下的就是 下面要取消触发的事件 了）
                    delete role.$$mapEventsTriggering[itemContainer.mapEventBlocks[event]];
                    continue;
                }
                //console.debug("[GameScene]mapEvent触发:", event, roleUseBlocks, itemContainer.mapEventBlocks[event]);    //触发
                GameSceneJS.mapEvent(itemContainer.mapEventBlocks[event], role);   //触发事件
            }
            //console.debug("event:", event, roleUseBlocks, roleUseBlocks.indexOf(event), typeof(event), typeof(itemContainer.mapInfo.events[0]), typeof(roleUseBlocks[0]))
        }

        //检测离开事件区域
        for(let event in role.$$mapEventsTriggering) {
            //console.debug("[GameScene]mapEventCanceled触发:", event, roleUseBlocks, itemContainer.mapEventBlocks[event]);    //触发
            GameSceneJS.mapEventCanceled(itemContainer.mapEventBlocks[role.$$mapEventsTriggering[event]], role);   //触发事件
            //console.debug("event:", event, roleUseBlocks, roleUseBlocks.indexOf(event), typeof(event), typeof(itemContainer.mapInfo.events[0]), typeof(roleUseBlocks[0]))
        }

        role.$$mapEventsTriggering = tEvents;

    }



    //主角操作
    do {
        let tIndex = 0; //mainRole下标
        let mainRole = _private.arrMainRoles[tIndex];
        if(!mainRole)
            break;



        //人物的占位最中央 所在地图的坐标
        let centerX = mainRole.x + mainRole.x1 + parseInt(mainRole.width1 / 2);
        let centerY = mainRole.y + mainRole.y1 + parseInt(mainRole.height1 / 2);


        //定向移动
        if(mainRole.nActionType === 2) {

            do {
                if(mainRole.targetsPos[0] && mainRole.targetsPos[0].x >= 0 && mainRole.targetsPos[0].x < centerX) {
                    _private.doAction(2, Qt.Key_Left);
                }
                else if(mainRole.targetsPos[0] && mainRole.targetsPos[0].x >= 0 && mainRole.targetsPos[0].x > centerX) {
                    _private.doAction(2, Qt.Key_Right);
                }
                else if(mainRole.targetsPos[0] && mainRole.targetsPos[0].y >= 0 && mainRole.targetsPos[0].y < centerY) {
                    _private.doAction(2, Qt.Key_Up);
                }
                else if(mainRole.targetsPos[0] && mainRole.targetsPos[0].y >= 0 && mainRole.targetsPos[0].y > centerY) {
                    _private.doAction(2, Qt.Key_Down);
                }
                else {
                    mainRole.targetsPos.shift();
                    if(mainRole.targetsPos.length === 0) {
                        mainRole.nActionType = 0;
                        _private.stopAction(1, -1);


                        let eventName = `$${mainRole.$data.$id}_arrive`;
                        let tScript = itemContainer.mapInfo.$$Script[eventName];
                        if(!tScript)
                            tScript = game.f[eventName];
                        if(!tScript)
                            tScript = game.gf[eventName];
                        if(tScript)
                            GlobalJS.createScript(_private.asyncScript, 0, -1, [tScript, '主角Arrive事件:' + mainRole.$data.$id], mainRole);
                            //game.run([tScript, mainRole.$name]);
                    }
                    else
                        continue;

                    //console.debug('!!!ok, getup')
                }
                break;
            } while(1);
        }

        //console.debug('moveDirection:', mainRole.moveDirection)


        //如果主角不移动，则跳出移动部分
        if(!mainRole.sprite.running)
            break;


        //下面是移动代码

        //计算真实移动偏移，初始为 角色速度 * 时间差
        let offsetMove = Math.round(mainRole.moveSpeed * realinterval);

        //如果开启摇杆加速，且用的不是键盘，则乘以摇杆偏移
        if(_private.config.rJoystickSpeed > 0 && mainRole.nActionType === 10 && _private.arrPressedKeys.length === 0) {
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
                if(mainRole.targetsPos[0] && mainRole.targetsPos[0].x >= 0 && mainRole.targetsPos[0].x < centerX && mainRole.targetsPos[0].x > centerX - offsetMove) {
                    mainRole.x = mainRole.targetsPos[0].x - mainRole.x1 - parseInt(mainRole.width1 / 2);
                }
                else
                    mainRole.x -= offsetMove;
                break;

            case Qt.Key_Right:
                if(mainRole.targetsPos[0] && mainRole.targetsPos[0].x >= 0 && mainRole.targetsPos[0].x > centerX && mainRole.targetsPos[0].x < centerX + offsetMove) {
                    mainRole.x = mainRole.targetsPos[0].x - mainRole.x1 - parseInt(mainRole.width1 / 2);
                }
                else
                    mainRole.x += offsetMove;
                break;

            case Qt.Key_Up: //同Left
                if(mainRole.targetsPos[0] && mainRole.targetsPos[0].y >= 0 && mainRole.targetsPos[0].y < centerY && mainRole.targetsPos[0].y > centerY - offsetMove)
                    mainRole.y = mainRole.targetsPos[0].y - mainRole.y1 - parseInt(mainRole.height1 / 2);
                else
                    mainRole.y -= offsetMove;
                break;

            case Qt.Key_Down:   //同Right
                if(mainRole.targetsPos[0] && mainRole.targetsPos[0].y >= 0 && mainRole.targetsPos[0].y > centerY && mainRole.targetsPos[0].y < centerY + offsetMove)
                    mainRole.y = mainRole.targetsPos[0].y - mainRole.y1 - parseInt(mainRole.height1 / 2);
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
                let isTriggered = mainRole.$$mapEventsTriggering[itemContainer.mapEventBlocks[event]] ||
                    tEvents[itemContainer.mapEventBlocks[event]];

                tEvents[itemContainer.mapEventBlocks[event]] = event;  //加入

                //如果已经被触发过
                if(isTriggered) {

                    ////将触发的事件删除（mainRole.$$mapEventsTriggering剩下的就是 下面要取消触发的事件 了）
                    delete mainRole.$$mapEventsTriggering[itemContainer.mapEventBlocks[event]];
                    continue;
                }
                //console.debug("[GameScene]mapEvent触发:", event, mainRoleUseBlocks, itemContainer.mapEventBlocks[event]);    //触发
                GameSceneJS.mapEvent(itemContainer.mapEventBlocks[event], mainRole);   //触发事件
            }
            //console.debug("event:", event, mainRoleUseBlocks, mainRoleUseBlocks.indexOf(event), typeof(event), typeof(itemContainer.mapInfo.events[0]), typeof(mainRoleUseBlocks[0]))
        }

        //检测离开事件区域
        for(let event in mainRole.$$mapEventsTriggering) {
            //console.debug("[GameScene]mapEventCanceled触发:", event, mainRoleUseBlocks, itemContainer.mapEventBlocks[event]);    //触发
            GameSceneJS.mapEventCanceled(itemContainer.mapEventBlocks[mainRole.$$mapEventsTriggering[event]], mainRole);   //触发事件
            //console.debug("event:", event, mainRoleUseBlocks, mainRoleUseBlocks.indexOf(event), typeof(event), typeof(itemContainer.mapInfo.events[0]), typeof(mainRoleUseBlocks[0]))
        }

        mainRole.$$mapEventsTriggering = tEvents;



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


    if(_private.sceneRole)
        //开始移动地图
        setSceneToRole(_private.sceneRole);
    else {
        //下面是移动代码

        //计算真实移动偏移，初始为 角色速度 * 时间差
        let offsetMoveX = 0;
        let offsetMoveY = 0;

        const dta = _private.rSceneMoveSpeed * realinterval;

        //let arrKeys = Object.keys(_private.arrPressedKeys);
        if(_private.arrPressedKeys.length > 0) {
            if(_private.arrPressedKeys.indexOf(Qt.Key_Left) >= 0)
                offsetMoveX = -Math.round(dta);
            else if(_private.arrPressedKeys.indexOf(Qt.Key_Right) >= 0)
                offsetMoveX = Math.round(dta);
            if(_private.arrPressedKeys.indexOf(Qt.Key_Up) >= 0)
                offsetMoveY = -Math.round(dta);
            else if(_private.arrPressedKeys.indexOf(Qt.Key_Down) >= 0)
                offsetMoveY = Math.round(dta);
        }
        //如果开启摇杆加速，且用的不是键盘，则乘以摇杆偏移
        else if(_private.config.rJoystickSpeed > 0) {
            offsetMoveX = Math.round(dta);
            offsetMoveY = Math.round(dta);

            let tOffset;    //遥感百分比
            //if(Math.abs(joystick.pointInput.x) < _private.config.rJoystickSpeed) {
                offsetMoveX = Math.round(offsetMoveX * joystick.pointInput.x);
            //}
            //if(Math.abs(joystick.pointInput.y) < _private.config.rJoystickSpeed) {
                offsetMoveY = Math.round(offsetMoveY * joystick.pointInput.y);
            //}
        }

        if(offsetMoveX || offsetMoveY) {
            setScenePos(parseInt(-itemContainer.x + gameScene.width / 2 + offsetMoveX), parseInt(-itemContainer.y + gameScene.height / 2 + offsetMoveY));
            //console.warn(-itemContainer.x, gameScene.width, itemContainer.width)
            //itemContainer.x -= offsetMoveX;
            //itemContainer.y -= offsetMoveY;
        }
    }



    //放在这里运行事件，因为 loadmap 的地图事件会改掉所有原来的事件；
    //如果异步脚本 初始为空，且现在不为空
    if(bAsyncScriptIsEmpty && !_private.asyncScript.isEmpty())
        game.run(true);



    //插件
    for(let tc in _private.objPlugins)
        for(let tp in _private.objPlugins[tc])
            if(_private.objPlugins[tc][tp].$timerTriggered && _private.objPlugins[tc][tp].$autoLoad !== false)
                _private.objPlugins[tc][tp].$timerTriggered(realinterval);

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
