
//载入资源
function *loadResources() {
    //读取引擎变量
    game.cd = GameMakerGlobal.settings.value("$RPG/" + GameMakerGlobal.config.strCurrentProjectName);
    if(!game.cd)
        game.cd = {};



    //读通用算法脚本
    let tCommoncript;
    if(FrameManager.sl_fileExists(GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + 'common_script.js')))
        tCommoncript = _private.jsEngine.load(GlobalJS.toURL(game.$projectpath + GameMakerGlobal.separator + 'common_script.js'));
    if(tCommoncript) {
        _private.objCommonScripts["game_init"] = tCommoncript.$gameInit;
        _private.objCommonScripts['game_release'] = tCommoncript.$gameRelease;
        _private.objCommonScripts["before_save"] = tCommoncript.$beforeSave;
        _private.objCommonScripts["before_load"] = tCommoncript.$beforeLoad;
        _private.objCommonScripts["after_save"] = tCommoncript.$afterSave;
        _private.objCommonScripts["after_load"] = tCommoncript.$afterLoad;
        _private.objCommonScripts["combatant_class"] = tCommoncript.$Combatant;
        _private.objCommonScripts["combatant_info"] = tCommoncript.$combatantInfo;
        _private.objCommonScripts["show_goods_name"] = tCommoncript.$showGoodsName;
        _private.objCommonScripts["show_combatant_name"] = tCommoncript.$showCombatantName;
        _private.objCommonScripts["refresh_combatant"] = tCommoncript.$refreshCombatant;
        _private.objCommonScripts['combatant_is_valid'] = tCommoncript.$combatantIsValid;
        _private.objCommonScripts["game_over_script"] = tCommoncript.$gameOverScript;
        //_private.objCommonScripts["resume_event_script"] = tCommoncript.$resumeEventScript;
        //_private.objCommonScripts["get_goods_script"] = tCommoncript.commonGetGoodsScript;
        //_private.objCommonScripts["use_goods_script"] = tCommoncript.commonUseGoodsScript;

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
        _private.objCommonScripts["fight_skill_algorithm"] = ret.$fightSkillAlgorithm;
        _private.objCommonScripts["fight_role_choice_skills_or_goods_algorithm"] = ret.$fightRoleChoiceSkillsOrGoodsAlgorithm;
        _private.objCommonScripts["fight_start_script"] = ret.$commonFightStartScript;
        _private.objCommonScripts["fight_round_script"] = ret.$commonFightRoundScript;
        _private.objCommonScripts["fight_end_script"] = ret.$commonFightEndScript;
        //_private.objCommonScripts["resume_event_script"] = ret.$resumeEventScript;
        _private.objCommonScripts["get_goods_script"] = ret.commonGetGoodsScript;
        _private.objCommonScripts["use_goods_script"] = ret.commonUseGoodsScript;
    }*/
    if(!_private.objCommonScripts["game_init"]) {
        _private.objCommonScripts["game_init"] = GameMakerGlobalJS.$gameInit;
        console.debug("[GameScene]!载入系统游戏初始化脚本");
    }
    else
        console.debug("[GameScene]载入游戏初始化脚本OK");

    if(!_private.objCommonScripts["game_release"]) {
        _private.objCommonScripts["game_release"] = GameMakerGlobalJS.$gameRelease;
        console.debug("[GameScene]!载入系统游戏结束脚本");
    }
    else
        console.debug("[GameScene]载入游戏结束脚本OK");

    if(!_private.objCommonScripts["before_save"]) {
        _private.objCommonScripts["before_save"] = GameMakerGlobalJS.$beforeSave;
        console.debug("[GameScene]!载入系统存档前脚本");
    }
    else
        console.debug("[GameScene]载入存档前脚本OK");

    if(!_private.objCommonScripts["before_load"]) {
        _private.objCommonScripts["before_load"] = GameMakerGlobalJS.$beforeLoad;
        console.debug("[GameScene]!载入系统读档前脚本");
    }
    else
        console.debug("[GameScene]载入读档前脚本OK");

    if(!_private.objCommonScripts["after_save"]) {
        _private.objCommonScripts["after_save"] = GameMakerGlobalJS.$afterSave;
        console.debug("[GameScene]!载入系统存档后脚本");
    }
    else
        console.debug("[GameScene]载入存档后脚本OK");

    if(!_private.objCommonScripts["after_load"]) {
        _private.objCommonScripts["after_load"] = GameMakerGlobalJS.$afterLoad;
        console.debug("[GameScene]!载入系统读档后脚本");
    }
    else
        console.debug("[GameScene]载入读档后脚本OK");


    if(!_private.objCommonScripts["combatant_class"]) {
        _private.objCommonScripts["combatant_class"] = GameMakerGlobalJS.$Combatant;
        console.debug("[GameScene]!载入系统创建战斗角色脚本");
    }
    else
        console.debug("[GameScene]载入创建战斗角色脚本OK");

    if(!_private.objCommonScripts["refresh_combatant"]) {
        _private.objCommonScripts["refresh_combatant"] = GameMakerGlobalJS.$refreshCombatant;
        console.debug("[GameScene]!载入系统计算属性脚本");
    }
    else
        console.debug("[GameScene]载入计算属性脚本OK");

    if(!_private.objCommonScripts["combatant_is_valid"]) {
        _private.objCommonScripts["combatant_is_valid"] = GameMakerGlobalJS.$combatantIsValid;
        console.debug("[GameScene]!载入系统战斗人物可用脚本");
    }
    else
        console.debug("[GameScene]载入战斗人物可用脚本OK");

    if(!_private.objCommonScripts["game_over_script"]) {
        _private.objCommonScripts["game_over_script"] = GameMakerGlobalJS.$gameOverScript;
        console.debug("[GameScene]!载入系统游戏结束脚本");
    }
    else
        console.debug("[GameScene]载入游戏结束脚本OK");

    /*if(!_private.objCommonScripts["resume_event_script"]) {
        _private.objCommonScripts["resume_event_script"] = GameMakerGlobalJS.$resumeEventScript;
        console.debug("[GameScene]!载入系统恢复脚本");
    }
    else
        console.debug("[GameScene]载入恢复算法脚本OK");  //, _private.objCommonScripts["resume_timer"], data, eval("()=>{}"));
    */

    /*if(!_private.objCommonScripts["get_goods_script"]) {
        _private.objCommonScripts["get_goods_script"] = GameMakerGlobalJS.commonGetGoodsScript;
        console.debug("[GameScene]!载入系统通用获得道具脚本");
    }
    else
        console.debug("[GameScene]载入通用获得道具脚本OK");
    if(!_private.objCommonScripts["use_goods_script"]) {
        _private.objCommonScripts["use_goods_script"] = GameMakerGlobalJS.commonUseGoodsScript;
        console.debug("[GameScene]!载入系统通用使用道具脚本");
    }
    else
        console.debug("[GameScene]载入通用使用道具脚本OK");
    */

    if(!_private.objCommonScripts["combatant_info"]) {
        _private.objCommonScripts["combatant_info"] = GameMakerGlobalJS.$combatantInfo;
        console.debug("[GameScene]!载入系统战斗人物信息");
    }
    else
        console.debug("[GameScene]载入战斗人物信息OK");

    if(!_private.objCommonScripts["show_goods_name"]) {
        _private.objCommonScripts["show_goods_name"] = GameMakerGlobalJS.$showGoodsName;
        console.debug("[GameScene]!载入系统显示道具名称信息");
    }
    else
        console.debug("[GameScene]载入显示道具名称信息OK");

    if(!_private.objCommonScripts["show_combatant_name"]) {
        _private.objCommonScripts["show_combatant_name"] = GameMakerGlobalJS.$showCombatantName;
        console.debug("[GameScene]!载入系统显示战斗人物名称信息");
    }
    else
        console.debug("[GameScene]载入显示战斗人物名称信息OK");

    /*
    if(!_private.objCommonScripts["events"]) {
        _private.objCommonScripts["events"] = GameMakerGlobalJS.$events;
        console.debug("[GameScene]!载入系统通用events");
    }
    else
        console.debug("[GameScene]载入通用eventsOK");
        */



    //创建一个主角
    const tf = function(soundeffectSource){
        game.playsoundeffect(soundeffectSource, -1);
    }
    mainRole = compRole.createObject(itemViewPort.itemRoleContainer);
    mainRole.sprite.sg_playEffect.connect(tf);
    //mainRole.customSprite.sg_playEffect.connect(tf);



//读取配置：

    //是否提前载入所有资源
    _private.config.nLoadAllResources = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$game', '$loadAllResources'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$game', '$loadAllResources'), 0);
    //万向移动
    _private.config.bWalkAllDirections = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$game', '$walkAllDirections'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$game', '$walkAllDirections'), true);

    //地图遮挡透明度
    itemViewPort.rMapOpacity = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$map', '$opacity'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$map', '$opacity'), 0.6);


    //安卓配置
    do {
        if(Qt.platform.os !== "android")
            break;

        _private.lastOrient = Platform.sl_getScreenOrientation();

        //旋转配置
        Platform.sl_setScreenOrientation(GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$android', '$orient'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$android', '$orient'), 4));

    }while(0);


    //摇杆 默认值

    /*let joystickConfig = {
        $left: 6,
        $bottom: 7,
        $size: 20,
        $opacity: 0.6,
        $image: '',
        $backgroundImage: '',
        $joystickMinimumProportion: 0.2,    //使能最低的比例
    };
    let buttonAConfig = {
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

    //摇杆 配置
    const joystickDefaultConfig = GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$joystick');
    const joystickConfig = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$joystick'), /*GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$joystick'), */joystickDefaultConfig);

    joystick.width = (joystickConfig.$size ?? joystickDefaultConfig.$size) * rootWindow.aliasComponents.Screen.pixelDensity;
    joystick.height = (joystickConfig.$size ?? joystickDefaultConfig.$size)  * rootWindow.aliasComponents.Screen.pixelDensity;
    joystick.anchors.leftMargin = (joystickConfig.$left ?? joystickDefaultConfig.$left) * rootWindow.aliasComponents.Screen.pixelDensity;
    joystick.anchors.bottomMargin = (joystickConfig.$bottom ?? joystickDefaultConfig.$bottom) * rootWindow.aliasComponents.Screen.pixelDensity;
    joystick.opacity = (joystickConfig.$opacity ?? joystickDefaultConfig.$opacity);
    joystick.rJoystickMinimumProportion = (joystickConfig.$joystickMinimumProportion ?? joystickDefaultConfig.$joystickMinimumProportion);
    joystick.imageHandle.source = (joystickConfig.$image ?? joystickDefaultConfig.$image);
    joystick.imageBackground.source = (joystickConfig.$backgroundImage ?? joystickDefaultConfig.$backgroundImage);
    if(joystick.imageHandle.source.toString())
        joystick.rectHandle.visible = false;
    if(joystick.imageBackground.source.toString())
        joystick.rectBackground.visible = false;


    //按键配置
    do {
        const buttonsConfig = GlobalLibraryJS.shortCircuit(0b1, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$buttons'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$buttons'), null);
        if(!buttonsConfig)
            break;

        /*/A键
        do {
            if(buttonsConfig[0] === undefined)
                break;
            let tConfig = buttonsConfig[0];
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
            if(buttonsConfig[1] === undefined)
                break;
            let tConfig = buttonsConfig[1];
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
        for(let tb = 0; tb < buttonsConfig.length; ++tb) {
            let tConfig = buttonsConfig[tb];
            let button = compButtons.createObject(itemButtons);
            button.width = tConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
            button.height = tConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
            if(tConfig.$color !== undefined)
                button.color = tConfig.$color;
            if(tConfig.$opacity !== undefined)
                button.opacity = tConfig.$opacity;
            if(tConfig.$image)
                button.image.source = GameMakerGlobal.imageResourceURL(tConfig.$image);
            button.anchors.rightMargin = tConfig.$right * rootWindow.aliasComponents.Screen.pixelDensity;
            button.anchors.bottomMargin = tConfig.$bottom * rootWindow.aliasComponents.Screen.pixelDensity;

            if(tConfig.$pressed)
                button.sg_pressed.connect(function() {
                    //if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                    //    return;
                    game.async(tConfig.$pressed.call(button) ?? null);
            });
            //！！！兼容旧代码
            else if(tConfig.$clicked)
                button.sg_pressed.connect(function() {
                    //if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                    //    return;
                    game.async(tConfig.$clicked.call(button) ?? null);
            });
            if(tConfig.$released)
                button.sg_released.connect(function() {
                    //if(!GlobalLibraryJS.objectIsEmpty(_private.config.objPauseNames))
                    //    return;
                    game.async(tConfig.$released.call(button) ?? null);
            });
        }

    }while(0);

    /*buttonA.width = buttonAConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonA.height = buttonAConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonA.color = buttonAConfig.$color;
    buttonA.opacity = buttonAConfig.$opacity;
    if(buttonAConfig.$image)
        buttonA.image.source = GameMakerGlobal.imageResourceURL(buttonAConfig.$image);
    buttonA.anchors.rightMargin = buttonAConfig.$right * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonA.anchors.bottomMargin = buttonAConfig.$bottom * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonA.buttonClicked = buttonAConfig.$clicked;

    buttonMenu.width = buttonMenuConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonMenu.height = buttonMenuConfig.$size * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonMenu.color = buttonMenuConfig.$color;
    buttonMenu.opacity = buttonMenuConfig.$opacity;
    if(buttonMenuConfig.$image)
        buttonMenu.image.source = GameMakerGlobal.imageResourceURL(buttonMenuConfig.$image);
    buttonMenu.anchors.rightMargin = buttonMenuConfig.$right * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonMenu.anchors.bottomMargin = buttonMenuConfig.$bottom * rootWindow.aliasComponents.Screen.pixelDensity;
    buttonMenu.buttonClicked = buttonMenuConfig.$clicked;
    */



    game.$sys.protoObjects.fightRole = GlobalLibraryJS.shortCircuit(0b1111, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$protoObjects', '$fightRole'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$protoObjects', '$fightRole'));
    game.$sys.protoObjects.goods = GlobalLibraryJS.shortCircuit(0b1111, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$protoObjects', '$goods'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$protoObjects', '$goods'));
    game.$sys.protoObjects.skill = GlobalLibraryJS.shortCircuit(0b1111, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$protoObjects', '$skill'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$protoObjects', '$skill'));
    game.$sys.protoObjects.fightScript = GlobalLibraryJS.shortCircuit(0b1111, GlobalLibraryJS.getObjectValue(game, '$userscripts', '$config', '$protoObjects', '$fightScript'), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', '$config', '$protoObjects', '$fightScript'));



    //起始脚本
    {
        let ts;
        if(FrameManager.sl_fileExists(GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + 'main.js'))) {
            ts = _private.jsEngine.load(GlobalJS.toURL(game.$projectpath + GameMakerGlobal.separator + 'main.js'));
        }
        //!!!兼容旧代码
        else if(FrameManager.sl_fileExists(GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + 'start.js'))) {
            ts = _private.jsEngine.load(GlobalJS.toURL(game.$projectpath + GameMakerGlobal.separator + 'start.js'));
        }
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
        path = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName);
        items = FrameManager.sl_dirList(path, "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let info = getGoodsResource(item, true);
            if(info) {
                //console.debug("[GameScene]载入Goods", item);
            }
            else {
                //console.warn("[!GameScene]载入Goods ERROR", item);
            }


            /*let filePath = path + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "goods.json";
            //console.debug(path, items, item, filePath)
            let info = FrameManager.sl_fileRead(GlobalJS.toPath(filePath));

            if(info) {
                info = JSON.parse(info);
                let t = GlobalJS._eval(info["Goods"]);
                if(t) {
                    _private.goodsResource[item] = t;
                    _private.goodsResource[item].$rid = item;
                    console.debug("[GameScene]载入Goods", item);
                }
            }
            if(!info)
                console.warn("[!GameScene]载入Goods ERROR", item);
            */
        }
    }


    if(_private.config.nLoadAllResources) {
        //读技能信息
        path = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName);
        items = FrameManager.sl_dirList(path, "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let info = getSkillResource(item, true);
            if(info) {
                //console.debug("[GameScene]载入FightSkill", item);
            }
            else {
                //console.warn("[!GameScene]载入FightSkill ERROR", item);
            }


            /*let filePath = path + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "fight_skill.json";
            //console.debug(path, items, item, filePath)
            let info = FrameManager.sl_fileRead(GlobalJS.toPath(filePath));

            if(info) {
                info = JSON.parse(info);
                let t = GlobalJS._eval(info["FightSkill"]);
                if(t) {
                    _private.skillsResource[item] = t;
                    _private.skillsResource[item].$rid = item;
                    console.debug("[GameScene]载入FightSkill", item);
                }
            }
            if(!info)
                console.warn("[!GameScene]载入FightSkill ERROR", item);
            */
        }
    }


    if(_private.config.nLoadAllResources) {
        //读战斗脚本信息
        path = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName);
        items = FrameManager.sl_dirList(path, "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let info = getFightScriptResource(item, true);
            if(info) {
                //console.debug("[GameScene]载入FightScript", item);
            }
            else {
                //console.warn("[!GameScene]载入FightScript ERROR", item);
            }

        }
    }



    if(_private.config.nLoadAllResources) {
        //读战斗角色信息
        path = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName);
        items = FrameManager.sl_dirList(path, "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            let info = getFightRoleResource(item, true);
            if(info) {
                //console.debug("[GameScene]载入FightRole Script", item);
            }
            else {
                //console.warn("[!GameScene]载入FightRole Script ERROR", item);
            }



            //let info = File.read(filePath);
            /*let info = FrameManager.sl_fileRead(GlobalJS.toPath(path + GameMakerGlobal.separator + item + GameMakerGlobal.separator + "fight_role.json"));

            if(info) {
                info = JSON.parse(info);

                //_private.fightRolesResource[item] = info;
                _private.fightRolesResource[item].ActionData = info.ActionData;
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
        path = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName);
        items = FrameManager.sl_dirList(path, "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            //console.debug(path, items, item)
            let info = getSpriteResource(item, true);
            if(info) {
                //console.debug("[GameScene]载入Sprite", item);
            }
            else {
                //console.warn("[!GameScene]载入Sprite ERROR", item);
            }
        }
    }

    if(_private.config.nLoadAllResources) {
        //读角色信息
        path = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName);
        items = FrameManager.sl_dirList(path, "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            //console.debug(path, items, item)
            let info = getRoleResource(item, true);
            if(info) {
                //console.debug("[GameScene]载入Role", item);
            }
            else {
                //console.warn("[!GameScene]载入Role ERROR", item);
            }
        }
    }

    if(_private.config.nLoadAllResources) {
        //读地图信息
        path = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName);
        items = FrameManager.sl_dirList(path, "*", 0x001 | 0x2000 | 0x4000, 0x00);

        for(let item of items) {
            //console.debug(path, items, item)
            let info = getMapResource(item, true);
            if(info) {
                //console.debug("[GameScene]载入Map", item);
            }
            else {
                //console.warn("[!GameScene]载入Map ERROR", item);
            }
        }
    }



    //let info;

    /*/读图片信息
    filePath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator +  "images.json");
    //let cfg = File.read(filePath);
    info = FrameManager.sl_fileRead(filePath);
    //console.debug("info", filePath, info)
    //console.debug("cfg", cfg, filePath);

    if(info) {
        info = JSON.parse(info)["List"];
        for(let m in info) {
            _private.objImages[info[m]["Name"]] = info[m]["URL"];
        }
        console.debug("[GameScene]载入图片OK");
    }

    //读音乐信息
    filePath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator +  "music.json");
    //let cfg = File.read(filePath);
    info = FrameManager.sl_fileRead(filePath);
    //console.debug("info", filePath, info)
    //console.debug("cfg", cfg, filePath);

    if(info) {
        info = JSON.parse(info)["List"];
        for(let m in info) {
            _private.objMusic[info[m]["Name"]] = info[m]["URL"];
        }
        console.debug("[GameScene]载入音乐OK");
    }

    //读视频信息
    filePath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator +  "videos.json");
    //let cfg = File.read(filePath);
    info = FrameManager.sl_fileRead(filePath);
    //console.debug("info", filePath, info)
    //console.debug("cfg", cfg, filePath);

    if(info) {
        info = JSON.parse(info)["List"];
        for(let m in info) {
            _private.objVideos[info[m]["Name"]] = info[m]["URL"];
        }
        console.debug("[GameScene]载入视频OK");
    }
    */




    /*if(!_private.objCommonScripts["get_buff"]) {
        _private.objCommonScripts["get_buff"] = GameMakerGlobalJS.$getBuff;
        console.debug("[GameScene]!载入系统通用获得Buff脚本");
    }
    else
        console.debug("[GameScene]载入通用获得Buff脚本OK");
    */



    /*/读升级链
    filePath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator);
    let tlevelChainScript;
    if(FrameManager.sl_fileExists(filePath + 'level_chain.js'))
        tlevelChainScript = _private.jsEngine.load(GlobalJS.toURL(filePath + 'level_chain.js'));
    if(tlevelChainScript) {
        _private.objCommonScripts["levelup_script"] = tlevelChainScript.$commonLevelUpScript;
        _private.objCommonScripts["level_Algorithm"] = tlevelChainScript.$commonLevelAlgorithm;
    }*/

    /*info = game.loadjson("level_chain.json");
    if(info) {
        let ret = GlobalJS._eval(info["LevelChainScript"]);
        _private.objCommonScripts["levelup_script"] = ret.$commonLevelUpScript;
        _private.objCommonScripts["level_Algorithm"] = ret.$commonLevelAlgorithm;
    }

    if(!_private.objCommonScripts["levelup_script"]) {
        _private.objCommonScripts["levelup_script"] = GameMakerGlobalJS.$commonLevelUpScript;
        console.debug("[GameScene]!载入系统升级脚本");
    }
    else
        console.debug("[GameScene]载入升级脚本OK");  //, _private.objCommonScripts["levelup_script"], info, eval("()=>{}"));


    if(!_private.objCommonScripts["level_Algorithm"]) {
        _private.objCommonScripts["level_Algorithm"] = GameMakerGlobalJS.$commonLevelAlgorithm;
        console.debug("[GameScene]!载入系统升级算法");
    }
    else
        console.debug("[GameScene]载入升级算法OK");  //, _private.objCommonScripts["level_Algorithm"], info, eval("()=>{}"));
    */



    //console.debug("_private.objMusic", JSON.stringify(_private.objMusic))


    for(let i = 0; i < 10; ++i)
        rootSoundEffect.arrCacheSoundEffects[i] = compCacheSoundEffect.createObject(rootGameScene, {});


    loaderFightScene.load();



//载入扩展 插件/组件
    let pluginPath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + "Plugins") + GameMakerGlobal.separator;

    //循环三方根目录
    for(let tc0 of FrameManager.sl_dirList(pluginPath, '*', 0x001 | 0x2000 | 0x4000, 0)) {
        //if(tc0 === '$Leamus')
        //    continue;

        //循环三方插件目录
        for(let tc1 of FrameManager.sl_dirList(pluginPath + tc0 + GameMakerGlobal.separator, '*', 0x001 | 0x2000 | 0x4000, 0)) {

            let jsPath = pluginPath + tc0 + GameMakerGlobal.separator + tc1 + GameMakerGlobal.separator + 'Components' + GameMakerGlobal.separator + 'main.js';
            if(!FrameManager.sl_fileExists(jsPath))
                continue;

            try {
                let ts = _private.jsEngine.load(GlobalJS.toURL(jsPath));


                //放入 _private.objPlugins 中
                //if(ts.$pluginId !== undefined) {    //插件有ID
                //    _private.objPlugins[ts.$pluginId] = ts;
                //}
                if(!GlobalLibraryJS.isObject(_private.objPlugins[tc0]))
                    _private.objPlugins[tc0] = {};
                _private.objPlugins[tc0][tc1] = ts;


                if(ts.$load && ts.$autoLoad !== false) {
                    try {
                        //ts.$load();
                        //game.run(ts.$load() ?? null, 'plugin_load:' + tc0 + tc1);
                        const r = ts.$load(tc0 + GameMakerGlobal.separator + tc1);
                        if(GlobalLibraryJS.isGenerator(r))yield* r;
                    } catch(e) {
                        GlobalLibraryJS.printException(e);
                        console.warn('[!GameScene]插件$load函数调用错误：', tc0, tc1);
                        //throw err;
                    }
                }
            }
            catch(e) {
                //console.error('[!GameScene]加载插件错误：', e);
                GlobalLibraryJS.printException(e, jsPath);
                continue;
            }
        }
    }
}


//卸载资源
function *unloadResources() {

    //卸载扩展 插件、组件
    for(let tc in _private.objPlugins)
        for(let tp in _private.objPlugins[tc])
            if(_private.objPlugins[tc][tp].$unload && _private.objPlugins[tc][tp].$autoLoad !== false) {
                try {
                    //_private.objPlugins[tc][tp].$unload();
                    //game.run(_private.objPlugins[tc][tp].$unload() ?? null, 'plugin_unload:' + tc + tp);
                    const r = _private.objPlugins[tc][tp].$unload();
                    if(GlobalLibraryJS.isGenerator(r))yield* r;
                } catch(e) {
                    GlobalLibraryJS.printException(e);
                    console.warn('[!GameScene]插件$unload函数调用错误：', tc, tp);
                    //throw err;
                }
            }


    loaderFightScene.unload();


    if(Qt.platform.os === "android") {
        Platform.sl_setScreenOrientation(_private.lastOrient);
        //if(game.$userscripts.$config && game.$userscripts.$config.$android)
    }


    for(let tse of rootSoundEffect.arrCacheSoundEffects) {
        tse.destroy();
    }
    rootSoundEffect.arrCacheSoundEffects = [];


    _private.objCacheSoundEffects = {};
    _private.objCacheImages = {};


    for(let i in _private.spritesResource) {
        if(_private.spritesResource[i].$$cache.image)
            _private.spritesResource[i].$$cache.image.destroy();
        if(_private.spritesResource[i].$$cache.audio)
            _private.spritesResource[i].$$cache.audio.destroy();
    }
    _private.spritesResource = {};

    _private.rolesResource = {};
    _private.mapsResource = {};
    _private.goodsResource = {};
    _private.fightRolesResource = {};
    _private.skillsResource = {};
    _private.fightScriptsResource = {};

    _private.objCommonScripts = {};

    //_private.objImages = {};
    //_private.objMusic = {};
    //_private.objVideos = {};

    game.$userscripts = null;

    _private.objPlugins = {};

    _private.jsEngine.clear();

    //写入引擎变量
    GameMakerGlobal.settings.setValue("$RPG/" + GameMakerGlobal.config.strCurrentProjectName, game.cd);
    game.cd = {};



    for(let tb in itemButtons.children) {
        itemButtons.children[tb].destroy();
    }



    if(mainRole)
        mainRole.destroy();
}



//返回 通用脚本中的某个函数或变量，如果没有则返回系统的
function getCommonScriptResource(...names) {
    let flags = 0b1;
    return GlobalLibraryJS.shortCircuit(flags, GlobalLibraryJS.getObjectValue(game, '$userscripts', ...names), GlobalLibraryJS.getObjectValue(game, '$gameMakerGlobalJS', ...names));
}


//获取 Goods 资源
function getGoodsResource(item, forceLoad=false) {

    //读取
    if(_private.goodsResource[item]) //如果有
        return _private.goodsResource[item];
    else if(_private.config.nLoadAllResources && !forceLoad)  //如果已经加载了所有的资源
        return null;


    //读道具信息
    let path = GlobalJS.toURL(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strGoodsDirName + GameMakerGlobal.separator + item + GameMakerGlobal.separator + 'goods.js');

    let ts = _private.jsEngine.load(path);
    let info = ts.data;

    //写入
    if(info) {
        _private.goodsResource[item] = ts.data;
        _private.goodsResource[item].$rid = item;
        let _proto_ = game.$sys.protoObjects.goods;
        if(_private.goodsResource[item].$commons) {
            _private.goodsResource[item].$commons.__proto__ = _proto_;
            _private.goodsResource[item].__proto__ = _private.goodsResource[item].$commons;
        }
        else
            _private.goodsResource[item].__proto__ = _proto_;

        console.debug("[GameScene]getGoodsResource:", item);
        return info;
    }

    console.warn("[!GameScene]getGoodsResource ERROR:", item);
    return null;
}

//获取 Skills 资源
function getSkillResource(item, forceLoad=false) {

    //读取
    if(_private.skillsResource[item]) //如果有
        return _private.skillsResource[item];
    else if(_private.config.nLoadAllResources && !forceLoad)  //如果已经加载了所有的资源
        return null;


    //读技能信息
    let path = GlobalJS.toURL(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightSkillDirName + GameMakerGlobal.separator + item + GameMakerGlobal.separator + 'fight_skill.js');

    let ts = _private.jsEngine.load(path);
    let info = ts.data;

    //写入
    if(info) {
        _private.skillsResource[item] = ts.data;
        _private.skillsResource[item].$rid = item;
        let _proto_ = game.$sys.protoObjects.skill;
        if(_private.skillsResource[item].$commons) {
            _private.skillsResource[item].$commons.__proto__ = _proto_;
            _private.skillsResource[item].__proto__ = _private.skillsResource[item].$commons;
        }
        else
            _private.skillsResource[item].__proto__ = _proto_;

        console.debug("[GameScene]getSkillResource:", item);
        return info;
    }

    console.warn("[!GameScene]getSkillResource ERROR:", item);
    return null;
}

//获取 FightScript 资源
function getFightScriptResource(item, forceLoad=false) {

    //读取
    if(_private.fightScriptsResource[item]) //如果有
        return _private.fightScriptsResource[item];
    else if(_private.config.nLoadAllResources && !forceLoad)  //如果已经加载了所有的资源
        return null;


    //读战斗脚本信息
    let path = GlobalJS.toURL(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightScriptDirName + GameMakerGlobal.separator + item + GameMakerGlobal.separator + 'fight_script.js');

    let ts = _private.jsEngine.load(path);
    let info = ts.data;

    //写入
    if(info) {
        _private.fightScriptsResource[item] = ts.data;
        _private.fightScriptsResource[item].$rid = item;
        let _proto_ = game.$sys.protoObjects.fightScript;
        if(_private.fightScriptsResource[item].$commons) {
            _private.fightScriptsResource[item].$commons.__proto__ = _proto_;
            _private.fightScriptsResource[item].__proto__ = _private.fightScriptsResource[item].$commons;
        }
        else
            _private.fightScriptsResource[item].__proto__ = _proto_;

        console.debug("[GameScene]getFightScriptResource:", item);
        return info;
    }

    console.warn("[!GameScene]getFightScriptResource ERROR:", item);
    return null;
}

//获取 FightRole 资源
function getFightRoleResource(item, forceLoad=false) {

    //读取
    if(_private.fightRolesResource[item]) //如果有
        return _private.fightRolesResource[item];
    else if(_private.config.nLoadAllResources && !forceLoad)  //如果已经加载了所有的资源
        return null;


    //读战斗角色信息
    let path = GlobalJS.toURL(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strFightRoleDirName + GameMakerGlobal.separator + item + GameMakerGlobal.separator + 'fight_role.js');

    let ts = _private.jsEngine.load(path);
    let info = ts.data;

    //写入
    if(info) {
        //_private.fightRolesResource[item].$createData = ts.$createData;
        //_private.fightRolesResource[item].$commons = ts.$commons;

        _private.fightRolesResource[item] = ts.data;
        _private.fightRolesResource[item].$rid = item;
        let _proto_ = game.$sys.protoObjects.fightRole;
        if(_private.fightRolesResource[item].$commons) {
            _private.fightRolesResource[item].$commons.__proto__ = _proto_;
            _private.fightRolesResource[item].__proto__ = _private.fightRolesResource[item].$commons;
        }
        else {
            _private.fightRolesResource[item].__proto__ = _proto_;
        }

        console.debug("[GameScene]getFightRoleResource:", item);
        return info;
    }

    console.warn("[!GameScene]getFightRoleResource ERROR:", item);
    return null;
}



//获取 Sprite 资源
function getSpriteResource(item, forceLoad=false) {

    //读取
    if(_private.spritesResource[item]) //如果有
        return _private.spritesResource[item];
    else if(_private.config.nLoadAllResources && !forceLoad)  //如果已经加载了所有的资源
        return null;


    //读特效信息
    let spriteDirPath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + item);

    let info = FrameManager.sl_fileRead(spriteDirPath + GameMakerGlobal.separator + "sprite.json");
    if(info)
        info = JSON.parse(info);

    //写入
    if(info) {
        _private.spritesResource[item] = info;
        _private.spritesResource[item].$rid = item;
        //_private.spritesResource[item].__proto__ = _private.spritesResource[item].$commons;

        let cacheSoundEffect;
        if(info.Sound && FrameManager.sl_isFile(GameMakerGlobal.soundResourcePath(info.Sound))) {
            if(_private.objCacheSoundEffects[info.Sound])
                cacheSoundEffect = _private.objCacheSoundEffects[info.Sound];
            else {
                cacheSoundEffect = compCacheSoundEffect.createObject(rootGameScene, {source: GameMakerGlobal.soundResourceURL(info.Sound)});
                _private.objCacheSoundEffects[info.Sound] = cacheSoundEffect;
            }
        }
        //let cacheImage = Qt.createQmlObject("import QtQuick 2.14;import QtMultimedia 5.14; Audio {}", parent);
        let cacheImage;
        if(FrameManager.sl_isFile(GameMakerGlobal.spriteResourcePath(info.Image))) {
            if(_private.objCacheImages[info.Image])
                cacheImage = _private.objCacheImages[info.Image];
            else {
                cacheImage = compCacheImage.createObject(rootGameScene, {source: GameMakerGlobal.spriteResourceURL(info.Image)});
                _private.objCacheImages[info.Image] = cacheImage;
            }
        }

        _private.spritesResource[item].$$cache = {image: cacheImage, audio: cacheSoundEffect};


        if(FrameManager.sl_fileExists(spriteDirPath + GameMakerGlobal.separator + 'sprite.js')) {
            _private.spritesResource[item].$script = _private.jsEngine.load(GlobalJS.toURL(spriteDirPath + GameMakerGlobal.separator + 'sprite.js'));
        }


        console.debug("[GameScene]getSpriteResource:", item);
        return info;
    }

    console.warn("[!GameScene]getSpriteResource ERROR:", item);
    return null;
}

//获取 Role 资源
function getRoleResource(item, forceLoad=false) {

    //读取
    if(_private.rolesResource[item]) //如果有
        return _private.rolesResource[item];
    else if(_private.config.nLoadAllResources && !forceLoad)  //如果已经加载了所有的资源
        return null;


    //读角色信息
    let roleDirPath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + item);

    let info = FrameManager.sl_fileRead(roleDirPath + GameMakerGlobal.separator + "role.json");
    if(info)
        info = JSON.parse(info);

    if(info) {
        _private.rolesResource[item] = info;
        _private.rolesResource[item].$rid = item;
        //_private.rolesResource[item].__proto__ = _private.rolesResource[item].$commons;


        if(FrameManager.sl_fileExists(roleDirPath + GameMakerGlobal.separator + 'role.js')) {
            _private.rolesResource[item].$script = _private.jsEngine.load(GlobalJS.toURL(roleDirPath + GameMakerGlobal.separator + 'role.js'));
        }


        console.debug("[GameScene]getRoleResource:", item);
        return info;
    }

    console.warn("[!GameScene]getRoleResource ERROR:", item);
    return null;
}

//获取 Map 资源
function getMapResource(item, forceLoad=false) {

    //读取
    if(_private.mapsResource[item]) //如果有
        return _private.mapsResource[item];
    else if(_private.config.nLoadAllResources && !forceLoad)  //如果已经加载了所有的资源
        return null;


    //读地图信息
    let mapDirPath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + item);

    let info = FrameManager.sl_fileRead(mapDirPath + GameMakerGlobal.separator + "map.json");
    if(info)
        info = JSON.parse(info);

    if(info) {
        _private.mapsResource[item] = info;
        _private.mapsResource[item].$rid = item;
        //_private.mapsResource[item].__proto__ = _private.mapsResource[item].$commons;


        if(FrameManager.sl_fileExists(mapDirPath + GameMakerGlobal.separator + 'map.js')) {
            _private.mapsResource[item].$script = _private.jsEngine.load(GlobalJS.toURL(mapDirPath + GameMakerGlobal.separator + 'map.js'));
        }


        console.debug("[GameScene]getMapResource:", item);
        return info;
    }

    console.warn("[!GameScene]getMapResource ERROR:", item);
    return null;
}



//创建Skill对象
//forceNew：当skill为技能对象时，forceNew为true或对象（会复制它的属性）则表示再新建一个相同的技能对象返回；skill为其他类型，则会复制forceNew的属性；
function getSkillObject(skill, forceNew=true) {
    let retSkill = null;
    if(GlobalLibraryJS.isString(skill)) {
        let resSkill = GameSceneJS.getSkillResource(skill);
        if(!resSkill) {
            //console.warn('[!GameScene]没有技能：', skill);
            return null;
        }

        //创建技能
        retSkill = {$rid: skill, $id: skill};
        if(resSkill.$createData)
            GlobalLibraryJS.copyPropertiesToObject(retSkill, resSkill.$createData());
        if(GlobalLibraryJS.isObject(forceNew))
            GlobalLibraryJS.copyPropertiesToObject(retSkill, forceNew/*, true*/);
        retSkill.__proto__ = resSkill;
    }
    else if(GlobalLibraryJS.isObject(skill)) {
        let resSkill;
        if(skill.$rid && (resSkill = GameSceneJS.getSkillResource(skill.$rid))) {
            //如果已是 技能对象 且 不需要新建
            if(!forceNew && skill.__proto__ === resSkill) {    //直接返回
                retSkill = skill;
                //skill.__proto__ = resSkill;
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
            skill.RID = skill.RID ?? skill.RId;
            resSkill = GameSceneJS.getSkillResource(skill.RID);
            if(!resSkill) {
                //console.warn('[!GameScene]没有技能：', skill.RID);
                return null;
            }

            //创建技能
            retSkill = {$rid: skill.RID};
            if(resSkill.$createData)
                GlobalLibraryJS.copyPropertiesToObject(retSkill, resSkill.$createData(skill.Params));
            //delete skill.RID;
            //delete skill.Params;
            GlobalLibraryJS.copyPropertiesToObject(retSkill, skill, {filterExcept: {RID: undefined, Params: undefined}, filterRecursion: false});
            if(GlobalLibraryJS.isObject(forceNew))
                GlobalLibraryJS.copyPropertiesToObject(retSkill, forceNew/*, true*/);
            retSkill.__proto__ = resSkill;
        }
    }
    else
        return null;

    if(!retSkill.$id)
        retSkill.$id = retSkill.$rid + GlobalLibraryJS.randomString(6, 6, '0123456789');


    return retSkill;
}

//创建Goods对象
//forceNew：当goods为道具对象时，forceNew为true或对象（会复制它的属性）则表示再新建一个相同的道具对象返回；goods为其他类型，则会复制forceNew的属性；
function getGoodsObject(goods, forceNew=true) {
    let retGoods = null;
    if(GlobalLibraryJS.isString(goods)) {
        let resGoods = GameSceneJS.getGoodsResource(goods);
        if(!resGoods) {
            //console.warn('[!GameScene]没有道具：', goods);
            return null;
        }

        retGoods = {$rid: goods, $count: 1, $id: goods};
        if(resGoods.$createData)
            GlobalLibraryJS.copyPropertiesToObject(retGoods, resGoods.$createData());
        if(GlobalLibraryJS.isObject(forceNew))
            GlobalLibraryJS.copyPropertiesToObject(retGoods, forceNew/*, true*/);
        retGoods.__proto__ = resGoods;
    }
    else if(GlobalLibraryJS.isObject(goods)) {
        let resGoods;
        if(goods.$rid && (resGoods = GameSceneJS.getGoodsResource(goods.$rid))) {
            //如果已是 道具对象 且 不需要新建
            if(!forceNew && goods.__proto__ === resGoods) {    //直接返回
                retGoods = goods;
                //goods.__proto__ = resGoods;
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
            goods.RID = goods.RID ?? goods.RId;
            resGoods = GameSceneJS.getGoodsResource(goods.RID);
            if(!resGoods) {
                //console.warn('[!GameScene]没有道具：', goods.RID);
                return null;
            }

            retGoods = {$rid: goods.RID, $count: 0};
            if(resGoods.$createData)
                GlobalLibraryJS.copyPropertiesToObject(retGoods, resGoods.$createData(goods.Params));
            //delete goods.RID;
            //delete goods.Params;
            GlobalLibraryJS.copyPropertiesToObject(retGoods, goods, {filterExcept: {RID: undefined, Params: undefined}, filterRecursion: false});
            if(GlobalLibraryJS.isObject(forceNew))
                GlobalLibraryJS.copyPropertiesToObject(retGoods, forceNew/*, true*/);
            retGoods.__proto__ = resGoods;
        }
    }
    else
        return null;


    if(!retGoods.$id)
        retGoods.$id = retGoods.$rid + GlobalLibraryJS.randomString(6, 6, '0123456789');

    if(GlobalLibraryJS.isNumber(retGoods.$price))
        retGoods.$price = [retGoods.$price, retGoods.$price];


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
//!!!注意：战斗人物的比较特殊，因为有 $Combatant 作为构造函数，会构造 $$开头的属性（比如$$fightData），所以判断 fightrole已经是战斗人物时 有可能不是构建好的战斗人物，所以最好参数是true，或者false时自己判断是否已经创建好
function getFightRoleObject(fightrole, forceNew=true) {
    let retFightRole = null;
    if(GlobalLibraryJS.isString(fightrole)) {
        let resFightRole = GameSceneJS.getFightRoleResource(fightrole);
        if(!resFightRole) {
            //console.warn('[!GameScene]没有战斗角色：', fightrole);
            return null;
        }

        //创建战斗人物
        retFightRole = {$rid: fightrole, $id: fightrole};
        GlobalLibraryJS.copyPropertiesToObject(retFightRole, new _private.objCommonScripts["combatant_class"](fightrole));
        if(resFightRole.$createData)
            GlobalLibraryJS.copyPropertiesToObject(retFightRole, resFightRole.$createData());
        if(GlobalLibraryJS.isObject(forceNew))
            GlobalLibraryJS.copyPropertiesToObject(retFightRole, forceNew/*, true*/);
        retFightRole.__proto__ = resFightRole;
    }
    else if(GlobalLibraryJS.isObject(fightrole)) {
        let resFightRole;
        if(fightrole.$rid && (resFightRole = GameSceneJS.getFightRoleResource(fightrole.$rid))) {
            //如果已是 战斗人物对象 且 不需要新建（!!!注意这里有可能判断错误）
            if(!forceNew && fightrole.__proto__ === resFightRole) {    //直接返回
                retFightRole = fightrole;
                //fightrole.__proto__ = resFightRole;
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
            fightrole.RID = fightrole.RID ?? fightrole.RId;
            resFightRole = GameSceneJS.getFightRoleResource(fightrole.RID);
            if(!resFightRole) {
                //console.warn('[!GameScene]没有战斗角色：', fightrole.RID);
                return null;
            }
            //创建战斗人物
            retFightRole = {$rid: fightrole.RID};
            GlobalLibraryJS.copyPropertiesToObject(retFightRole, new _private.objCommonScripts["combatant_class"](fightrole.RID));
            if(resFightRole.$createData)
                GlobalLibraryJS.copyPropertiesToObject(retFightRole, resFightRole.$createData(fightrole.Params));
            //delete fightrole.RID;
            //delete fightrole.Params;
            GlobalLibraryJS.copyPropertiesToObject(retFightRole, fightrole, {filterExcept: {RID: undefined, Params: undefined, $$fightData: undefined}, filterRecursion: false});
            if(GlobalLibraryJS.isObject(forceNew))
                GlobalLibraryJS.copyPropertiesToObject(retFightRole, forceNew/*, true*/);
            retFightRole.__proto__ = resFightRole;
        }
    }
    else
        return null;

    if(!retFightRole.$id)
        retFightRole.$id = retFightRole.$rid + GlobalLibraryJS.randomString(6, 6, '0123456789');


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
                tequipment[t.$position] = t;
        }
        retFightRole.$equipment = tequipment;
    }
    else
        retFightRole.$equipment = {};


    //刷新
    _private.objCommonScripts["refresh_combatant"](retFightRole, false);


    return retFightRole;
}

function getFightScriptObject(fightscript, forceNew=true) {
    let retFightScript = null;
    if(GlobalLibraryJS.isString(fightscript)) {
        let resFightScript = GameSceneJS.getFightScriptResource(fightscript);
        if(!resFightScript) {
            //console.warn('[!GameScene]没有战斗脚本：', fightscript);
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
        if(fightscript.$rid && (resFightScript = GameSceneJS.getFightScriptResource(fightscript.$rid))) {
            //如果已是 战斗脚本对象 且 不需要新建
            if(!forceNew && fightscript.__proto__ === resFightScript) {    //直接返回
                retFightScript = fightscript;
                //fightscript.__proto__ = resFightScript;
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
            fightscript.RID = fightscript.RID ?? fightscript.RId;
            resFightScript = GameSceneJS.getFightScriptResource(fightscript.RID);
            if(!resFightScript) {
                //console.warn('[!GameScene]没有战斗脚本：', fightscript.RID);
                return null;
            }

            //创建战斗脚本
            retFightScript = {$rid: fightscript.RID};
            if(resFightScript.$createData)
                GlobalLibraryJS.copyPropertiesToObject(retFightScript, resFightScript.$createData(fightscript.Params));
            //delete fightscript.RID;
            //delete fightscript.Params;
            GlobalLibraryJS.copyPropertiesToObject(retFightScript, fightscript, {filterExcept: {RID: undefined, Params: undefined}, filterRecursion: false});
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
//spriteEffectParams是 特效的资源名（会读取对应特效的信息）或 特效的信息（不会再次读取）；
//如果 spriteEffectComp 为null，则 从缓存获取1个 SpriteEffect 组件并返回（这个一般用在 角色动作上）
function loadSpriteEffect(spriteEffectParams, spriteEffectComp, newParams={}, parent=itemViewPort.itemRoleContainer) {
    //console.debug("[FightScene]loadSpriteEffect0");

    /*if(GlobalLibraryJS.isString(spriteEffectParams))
        spriteEffectParams = {RID: spriteEffectParams};
    spriteEffectParams.RID = spriteEffectParams.RID ?? spriteEffectParams.RID ?? spriteEffectParams.RId;

    /*let filePath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strSpriteDirName + GameMakerGlobal.separator + spriteEffectParams + GameMakerGlobal.separator + "sprite.json");
    //console.debug("[FightScene]filePath2：", filePath);
    let spriteResourceInfo = FrameManager.sl_fileRead(filePath);
    * /
    let spriteResourceInfo = GameSceneJS.getSpriteResource(spriteEffectParams.RID);
    GlobalLibraryJS.copyPropertiesToObject(spriteResourceInfo, spriteEffectParams, {onlyCopyExists: true});
    */

    let spriteResourceInfo;
    if(GlobalLibraryJS.isString(spriteEffectParams))
        spriteResourceInfo = GameSceneJS.getSpriteResource(spriteEffectParams);
    else
        spriteResourceInfo = spriteEffectParams;

    if(spriteResourceInfo) {
        if(!spriteEffectComp) {
            //spriteEffectComp = compCacheSpriteEffect.createObject(parent);
            let bNew;
            [spriteEffectComp, bNew] = _private.cacheSprites.get(parent);
            spriteEffectComp.nSpriteType = newParams.SpriteType ?? spriteResourceInfo.SpriteType;
        }
        else {//if(spriteEffectComp.bRunning === true)
            spriteEffectComp.nSpriteType = newParams.SpriteType ?? spriteResourceInfo.SpriteType;
            spriteEffectComp.sprite.stop();
        }


        spriteEffectComp.$info = spriteResourceInfo;
        spriteEffectComp.$script = newParams.$script ?? spriteResourceInfo.$script;


        /*switch(spriteResourceInfo.SpriteType) {
        case 1:
            spriteEffectComp.sourceComponent = compSpriteEffect;
            break;
        case 2:
            spriteEffectComp.sourceComponent = compDirSpriteEffect;
            break;
        }
        */


        spriteEffectComp.strSource = GameMakerGlobal.spriteResourceURL(newParams.Image ?? spriteResourceInfo.Image);

        //spriteEffectComp.sprite.width = parseInt(spriteResourceInfo.SpriteSize[0]);
        //spriteEffectComp.sprite.height = parseInt(spriteResourceInfo.SpriteSize[1]);
        spriteEffectComp.rXOffset = newParams.XOffset ?? spriteResourceInfo.XOffset ?? 0;
        spriteEffectComp.rYOffset = newParams.YOffset ?? spriteResourceInfo.YOffset ?? 0;
        spriteEffectComp.opacity = newParams.Opacity ?? spriteResourceInfo.Opacity ?? 1;
        spriteEffectComp.rXScale = newParams.XScale ?? spriteResourceInfo.XScale ?? 1;
        spriteEffectComp.rYScale = newParams.YScale ?? spriteResourceInfo.YScale ?? 1;

        spriteEffectComp.strSoundeffectName = newParams.Sound ?? spriteResourceInfo.Sound ?? '';

        spriteEffectComp.nSoundeffectDelay = newParams.SoundDelay ?? spriteResourceInfo.SoundDelay ?? 0;

        spriteEffectComp.nLoops = newParams.Loops ?? newParams.$loops/* ?? spriteResourceInfo.Loops*/ ?? 1;
        //spriteEffectComp.restart();

        let t = newParams.SpriteSize ?? spriteResourceInfo.SpriteSize;
        spriteEffectComp.width = parseInt((t && t[0]) ? t[0] : 0);
        spriteEffectComp.height = parseInt((t && t[1]) ? t[1] : 0);


        //！！！兼容旧代码
        if(spriteEffectComp.nSpriteType === 1) {
            spriteEffectComp.nFrameCount = GlobalLibraryJS.shortCircuit(0b1,
                GlobalLibraryJS.getObjectValue(newParams.FrameData, 'FrameCount'),
                GlobalLibraryJS.getObjectValue(newParams, 'FrameCount'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo.FrameData, 'FrameCount'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo, 'FrameCount'),
            0);
            spriteEffectComp.nInterval = GlobalLibraryJS.shortCircuit(0b1,
                GlobalLibraryJS.getObjectValue(newParams.FrameData, 'FrameInterval'),
                GlobalLibraryJS.getObjectValue(newParams, 'FrameInterval'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo.FrameData, 'FrameInterval'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo, 'FrameInterval'),
            0);

            //注意这个放在 spriteEffectComp.sprite.width 和 spriteEffectComp.sprite.height 之前
            let t = GlobalLibraryJS.shortCircuit(0b1,
                GlobalLibraryJS.getObjectValue(newParams.FrameData, 'FrameSize'),
                GlobalLibraryJS.getObjectValue(newParams, 'FrameSize'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo.FrameData, 'FrameSize'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo, 'FrameSize'),
            );
            spriteEffectComp.sprite.sizeFrame = Qt.size((t && t[0]) ? t[0] : 0, (t && t[1]) ? t[1] : 0);

            t = GlobalLibraryJS.shortCircuit(0b1,
                GlobalLibraryJS.getObjectValue(newParams.FrameData, 'OffsetIndex'),
                GlobalLibraryJS.getObjectValue(newParams, 'OffsetIndex'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo.FrameData, 'OffsetIndex'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo, 'OffsetIndex'),
            );
            spriteEffectComp.sprite.pointOffsetIndex = Qt.point((t && t[0]) ? t[0] : 0, (t && t[1]) ? t[1] : 0);
        }
        else if(spriteEffectComp.nSpriteType === 2) {
            let t = newParams.FrameData ?? spriteResourceInfo.FrameData;

            //！！！兼容旧代码
            spriteEffectComp.nFrameCount = GlobalLibraryJS.shortCircuit(0b1,
                GlobalLibraryJS.getObjectValue(newParams.FrameData, 'FrameCount'),
                GlobalLibraryJS.getObjectValue(newParams, 'FrameCount'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo.FrameData, 'FrameCount'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo.FrameData, '1'),
            0);
            spriteEffectComp.nInterval = GlobalLibraryJS.shortCircuit(0b1,
                GlobalLibraryJS.getObjectValue(newParams.FrameData, 'FrameInterval'),
                GlobalLibraryJS.getObjectValue(newParams, 'FrameInterval'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo.FrameData, 'FrameInterval'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo.FrameData, '2'),
            0);
            spriteEffectComp.sprite.nFrameStartIndex = GlobalLibraryJS.shortCircuit(0b1,
                GlobalLibraryJS.getObjectValue(newParams.FrameData, 'FrameStartIndex'),
                GlobalLibraryJS.getObjectValue(newParams, 'FrameStartIndex'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo.FrameData, 'FrameStartIndex'),
                GlobalLibraryJS.getObjectValue(spriteResourceInfo.FrameData, '0'),
            0);


            if(spriteEffectComp.$script)
                spriteEffectComp.sprite.fnRefresh = spriteEffectComp.$script.$refresh;
        }


        return spriteEffectComp;
    }
    else {
        console.exception('[!GameScene]loadSpriteEffect Fail:', spriteEffectParams);
    }

    return null;
}

function unloadSpriteEffect(spriteEffectComp) {
    //spriteEffectComp.destroy();
    if(!spriteEffectComp) {
        console.warn('[!GameScene]unloadSpriteEffect Fail:', spriteEffectComp);
        return;
    }
    _private.cacheSprites.put(spriteEffectComp);
}


//载入角色，返回角色对象；
//roleParams是 角色的资源名（会读取对应角色的信息）或 角色的信息（不会再次读取）；
//如果 roleComp 为null，则 创建1个 roleComp 组件并返回；
function loadRole(roleParams, roleComp, newParams={}, parent=itemViewPort.itemRoleContainer) {
    //console.debug('[GameScene]loadRole:', roleParams);

    /*let filePath = GlobalJS.toPath(game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strRoleDirName + GameMakerGlobal.separator + roleParams + GameMakerGlobal.separator + "role.json");
    //console.debug("[FightScene]filePath2：", filePath);
    let roleResourceInfo = FrameManager.sl_fileRead(filePath);
    */

    let roleResourceInfo;
    if(GlobalLibraryJS.isString(roleParams))
        roleResourceInfo = GameSceneJS.getRoleResource(roleParams);
    else
        roleResourceInfo = roleParams;

    if(roleResourceInfo) {
        if(!roleComp) {
            roleComp = compRole.createObject(parent);
            const tf = function(soundeffectSource){
                game.playsoundeffect(soundeffectSource, -1);
            }
            roleComp.sprite.sg_playEffect.connect(tf);
            //roleComp.customSprite.sg_playEffect.connect(tf);
        }


        roleComp.$info = roleResourceInfo;
        roleComp.$script = newParams.$script ?? roleResourceInfo.$script;


        roleComp.nSpriteType = newParams.SpriteType ?? roleResourceInfo.SpriteType ?? 1;
        if(roleComp.nSpriteType === 0) {
            let t = newParams.FrameIndex ?? roleResourceInfo.FrameIndex;
            for(let ta in t) {
                const info = getSpriteResource(t[ta][0]);
                roleComp.objActionsData[ta] = {Info: info, Script: info.$script};
            }
        }
        else if(roleComp.nSpriteType === 1) {
            roleComp.strSource = GameMakerGlobal.spriteResourceURL(newParams.Image ?? roleResourceInfo.Image);

            roleComp.nFrameCount = newParams.FrameCount ?? roleResourceInfo.FrameCount;
            roleComp.nInterval = newParams.FrameInterval ?? roleResourceInfo.FrameInterval;

            //注意这个放在 roleComp.sprite.sprite.width 和 roleComp.sprite.sprite.height 之前
            let t = newParams.FrameSize ?? roleResourceInfo.FrameSize;
            roleComp.sprite.sprite.sizeFrame = Qt.size((t && t[0]) ? t[0] : 0, (t && t[1]) ? t[1] : 0);

            //roleComp.implicitWidth = roleResourceInfo.RoleSize[0];
            //roleComp.implicitHeight = roleResourceInfo.RoleSize[1];
            //roleComp.width = roleResourceInfo.RoleSize[0];
            //roleComp.height = roleResourceInfo.RoleSize[1];
            t = newParams.RoleSize ?? roleResourceInfo.RoleSize;
            roleComp.width = (t && t[0]) ? t[0] : 0;
            roleComp.height = (t && t[1]) ? t[1] : 0;
            t = newParams.RoleOffset ?? roleResourceInfo.RoleOffset;
            roleComp.rXOffset = (t && t[0]) ? t[0] : 0;
            roleComp.rYOffset = (t && t[1]) ? t[1] : 0;
            t = newParams.Scale ?? roleResourceInfo.Scale;
            roleComp.rXScale = (t && t[0]) ? t[0] : 1;
            roleComp.rYScale = (t && t[1]) ? t[1] : 1;

            const frameIndex = newParams.FrameIndex ?? roleResourceInfo.FrameIndex;
            if(GlobalLibraryJS.isArray(frameIndex))
                roleComp.objActionsData = {'$Up': frameIndex[0], '$Right': frameIndex[1], '$Down': frameIndex[2], '$Left': frameIndex[3]};
            if(GlobalLibraryJS.isObject(frameIndex))
                roleComp.objActionsData = frameIndex;
        }
        else if(roleComp.nSpriteType === 2) {
            roleComp.strSource = GameMakerGlobal.spriteResourceURL(newParams.Image ?? roleResourceInfo.Image);

            //roleComp.implicitWidth = roleResourceInfo.RoleSize[0];
            //roleComp.implicitHeight = roleResourceInfo.RoleSize[1];
            //roleComp.width = roleResourceInfo.RoleSize[0];
            //roleComp.height = roleResourceInfo.RoleSize[1];
            let t = newParams.RoleSize ?? roleResourceInfo.RoleSize;
            roleComp.width = (t && t[0]) ? t[0] : 0;
            roleComp.height = (t && t[1]) ? t[1] : 0;
            t = newParams.RoleOffset ?? roleResourceInfo.RoleOffset;
            roleComp.rXOffset = (t && t[0]) ? t[0] : 0;
            roleComp.rYOffset = (t && t[1]) ? t[1] : 0;
            t = newParams.Scale ?? roleResourceInfo.Scale;
            roleComp.rXScale = (t && t[0]) ? t[0] : 1;
            roleComp.rYScale = (t && t[1]) ? t[1] : 1;


            //roleComp.sprite.strOffsetPositionsFile = GameMakerGlobal.spriteResourcePath(roleResourceInfo.Image + GameMakerGlobal.separator + roleResourceInfo.OffsetPositionsFile);
            roleComp.objActionsData = newParams.FrameIndex ?? roleResourceInfo.FrameIndex;
            /*nFrameStartIndex = ;
            fGetImageName = ;
            fGetImageFixPosition = ;
            fGetImageFixPositions = ;
            */


            if(roleComp.$script)
                roleComp.sprite.sprite.fnRefresh = roleComp.$script.$refresh;
        }
        let t = newParams.RealOffset ?? roleResourceInfo.RealOffset;
        roleComp.x1 = (t && t[0]) ? t[0] : 0;
        roleComp.y1 = (t && t[1]) ? t[1] : 0;
        t = newParams.RealSize ?? roleResourceInfo.RealSize;
        roleComp.width1 = (t && t[0]) ? t[0] : 0;
        roleComp.height1 = (t && t[1]) ? t[1] : 0;
        roleComp.rectShadow.opacity = newParams.ShadowOpacity ?? roleResourceInfo.ShadowOpacity ?? 0.3;

        //roleComp.bTest = true;

        roleComp.reset();


        return roleComp;
    }
    else {
        console.exception('[!GameScene]loadRole Fail:', roleParams);
    }

    return null;
}



//打开地图
function openMap(mapName, forceRepaint=false) {
    game.d['$sys_map'] = {};

    let mapPath = game.$projectpath + GameMakerGlobal.separator + GameMakerGlobal.config.strMapDirName + GameMakerGlobal.separator + mapName;

    //如果强制绘制、或地图名称不同、或没有载入过地图，则绘制
    if(forceRepaint || game.gd['$sys_map'].$name !== mapName || !itemViewPort.mapInfo) {

        if(!itemViewPort.openMap(mapPath, GameSceneJS.getMapResource(mapName))) {
            game.gd['$sys_map'].$name = null;

            game.d['$sys_map'].$info = {};
            game.d['$sys_map'].$name = null;
            game.d['$sys_map'].$columns = 0;
            game.d['$sys_map'].$rows = 0;
            game.d['$sys_map'].$specials = {};
            game.d['$sys_map'].$obstacles = [];


            //!!!兼容旧代码
            game.gd['$sys_map'].$$info = {};
            game.gd['$sys_map'].$$columns = 0;
            game.gd['$sys_map'].$$rows = 0;
            game.gd['$sys_map'].$$obstacles = [];


            //console.warn('[!GameScene]Map Load Error:', mapName, mapPath);
            return false;
        }
    }

    //game.$sys_map.$name = itemViewPort.mapInfo.MapName;
    game.gd['$sys_map'].$name = itemViewPort.mapInfo.MapName;

    game.d['$sys_map'].$info = itemViewPort.mapInfo;
    game.d['$sys_map'].$name = itemViewPort.mapInfo.MapName;
    game.d['$sys_map'].$columns = itemViewPort.mapInfo.MapSize[0];
    game.d['$sys_map'].$rows = itemViewPort.mapInfo.MapSize[1];

    game.d['$sys_map'].$obstacles = [];
    for(let mb in itemViewPort.mapInfo.MapBlockSpecialData) {
        if(itemViewPort.mapInfo.MapBlockSpecialData[mb] & 0b1) {
            game.d['$sys_map'].$obstacles.push(mb.split(','));
        }
    }
    game.d['$sys_map'].$specials = itemViewPort.mapInfo.MapBlockSpecialData;


    //!!!兼容旧代码
    game.gd['$sys_map'].$$info = itemViewPort.mapInfo;
    game.gd['$sys_map'].$$columns = itemViewPort.mapInfo.MapSize[0];
    game.gd['$sys_map'].$$rows = itemViewPort.mapInfo.MapSize[1];
    game.gd['$sys_map'].$$obstacles = game.d['$sys_map'].$obstacles;



    //执行载入地图脚本

    //之前的
    //if(itemViewPort.mapInfo.SystemEventData !== undefined && itemViewPort.mapInfo.SystemEventData['$1'] !== undefined) {
    //    if(GlobalJS.createScript(_private.scriptQueue, 0, 0, itemViewPort.mapInfo.SystemEventData['$1']) === 0)
    //        return _private.scriptQueue.run(_private.scriptQueue.lastEscapeValue);
    //}

    //使用Component（太麻烦）
    //let scriptComp = Qt.createComponent(GlobalJS.toURL(filePath + GameMakerGlobal.separator + 'map.qml'));
    //console.debug('!!!999', GlobalJS.toURL(filePath + GameMakerGlobal.separator + 'map.qml'), scriptComp)
    //let script = scriptComp.createObject({}, rootGameScene);

    //let script = Qt.createQmlObject('import QtQuick 2.14;import 'map.js' as Script;Item {property var script: Script}', rootGameScene, GlobalJS.toURL(filePath + GameMakerGlobal.separator));
    //script.destroy();

    //let ts = _private.jsEngine.load(GlobalJS.toURL(mapPath + GameMakerGlobal.separator + 'map.js'));
    //itemViewPort.mapScript = ts;
    itemViewPort.mapScript = _private.mapsResource[mapName].$script;

    //GlobalLibraryJS.copyPropertiesToObject(game.f, itemViewPort.mapScript/*, true*/);
    Object.assign(game.f, itemViewPort.mapScript);



    //test();

    return itemViewPort.mapInfo;
}





function buttonAClicked() {
    console.debug("[GameScene]buttonAClicked");

    let bScriptQueueIsEmpty = _private.scriptQueue.isEmpty();


    //计算是否触发地图事件

    //人物面向的有效矩形
    let usePos = Qt.rect(0,0,0,0);

    //可以触发事件的最远距离
    let maxDistance;

    //人物方向
    switch(mainRole.direction()) {
    case 0:
        maxDistance = Math.ceil(itemViewPort.sizeMapBlockScaledSize.height / 3);
        usePos = Qt.rect(mainRole.x + mainRole.x1, mainRole.y + mainRole.y1 - maxDistance, mainRole.width1, maxDistance);
        break;
    case 1:
        maxDistance = Math.ceil(itemViewPort.sizeMapBlockScaledSize.width / 3);
        usePos = Qt.rect(mainRole.x + mainRole.x2, mainRole.y + mainRole.y1, maxDistance, mainRole.height1);
        break;
    case 2:
        maxDistance = Math.ceil(itemViewPort.sizeMapBlockScaledSize.height / 3);
        usePos = Qt.rect(mainRole.x + mainRole.x1, mainRole.y + mainRole.y2, mainRole.width1, maxDistance);
        break;
    case 3:
        maxDistance = Math.ceil(itemViewPort.sizeMapBlockScaledSize.width / 3);
        usePos = Qt.rect(mainRole.x + mainRole.x1 - maxDistance, mainRole.y + mainRole.y1, maxDistance, mainRole.height1);
        break;
    default:
        return;
    }

    //计算人物所占的地图块
    let usedMapBlocks = itemViewPort.fComputeUseBlocks(usePos.x, usePos.y, usePos.x + usePos.width, usePos.y + usePos.height);


    let mainRoleUseBlocks = [];

    for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
        for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
            mainRoleUseBlocks.push(xb + yb * itemViewPort.mapInfo.MapSize[0]);
        }
    }

    //console.debug("人物占用图块：", usedMapBlocks,mainRoleUseBlocks)

    //循环地图事件（优先）
    for(let event in itemViewPort.mapEventBlocks) {
        //console.debug("[GameScene]检测事件：", event, mainRoleUseBlocks);
        if(mainRoleUseBlocks.indexOf(parseInt(event)) > -1) {  //如果事件触发
            //console.debug("[GameScene]mapEvent触发:", event, mainRoleUseBlocks, itemViewPort.mapEventBlocks[event]);    //触发
            GameSceneJS.mapEvent(itemViewPort.mapEventBlocks[event], mainRole);   //触发事件

            //放在这里运行事件，因为 loadmap 的地图事件会改掉所有原来的事件；
            //如果异步脚本 初始为空，且现在不为空
            if(bScriptQueueIsEmpty && !_private.scriptQueue.isEmpty())
                game.run(true);

            return; //!!只执行一次事件
        }
        //console.debug("event:", event, mainRoleUseBlocks, mainRoleUseBlocks.indexOf(event), typeof(event), typeof(itemViewPort.mapInfo.events[0]), typeof(mainRoleUseBlocks[0]))
    }

    //循环NPC
    for(let r in _private.objRoles) {
        let role = _private.objRoles[r];
        if(GlobalLibraryJS.checkRectangleClashed(
            usePos,
            Qt.rect(role.x + role.x1, role.y + role.y1, role.width1, role.height1),
            0
        )) {
            console.debug("[GameScene]触发NPC事件：", role.$data.$id);

            //获得脚本（地图脚本优先级 > game.f定义的）
            let tScript;
            do {
                /*if(itemViewPort.mapScript) {
                    if(tScript = itemViewPort.mapScript['$' + role.$data.$id])
                        break;
                    if(tScript = itemViewPort.mapScript[role.$data.$id])
                        break;
                }
                */
                if(tScript = game.f['$' + role.$data.$id])
                    break;
                if(tScript = game.f[role.$data.$id])    //!!!兼容旧的
                    break;
                if(tScript = game.gf['$' + role.$data.$id])
                    break;
                if(tScript = game.gf[role.$data.$id])    //!!!兼容旧的
                    break;
                if(role.$script && (tScript = role.$script['$interactive']))
                    break;
            } while(0);

            if(tScript) {
                game.run(tScript.call(role, role) ?? null, '$interactive:' + role.$data.$id);
                //GlobalJS.runScript(_private.scriptQueue, 0, "game.f['%1']()".arg(role.$data.$id));

                return; //!!只执行一次事件
            }
        }
    }
}


//地图事件触发
function mapEvent(eventName, role) {
    let tScript;


    //主角和NPC的事件名不同
    do {
        /*if(role.$$type === 1)
            if(tScript = itemViewPort.mapScript['$' + eventName])
                break;
        else
            if(tScript = itemViewPort.mapScript['$' + role.$data.$id + '_' + eventName + '_map'])
                break;
        if(role.$$type === 1 && (tScript = itemViewPort.mapScript[eventName]))    //!!兼容旧的
            break;
        */
        if(role.$$type === 1)
            if(tScript = game.f['$' + eventName])
                break;
        else
            if(tScript = game.f['$' + role.$data.$id + '_' + eventName + '_map'])
                break;
        if(role.$$type === 1 && (tScript = game.f[eventName]))    //!!兼容旧的
            break;
        if(role.$script && (tScript = role.$script['$' + eventName + '_map']))
            break;
    } while(0);

    if(tScript)
        GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(role, role) ?? null, Tips: '地图事件:' + role.$data.$id + '_' + eventName + '_map'}, );
    //game.run(tScript() ?? null, '地图事件:' + eventName);


    //调用总事件处理
    tScript = game.gf['$' + eventName + '_map'];
    if(tScript)
        GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(role, role) ?? null, Tips: '地图事件:map_' + eventName}, );



    console.debug("[GameScene]mapEvent:", role.$data.$id + '_' + eventName + '_map');
}

//离开事件触发
function mapEventCanceled(eventName, role) {
    let tScript;


    //主角和NPC的事件名不同
    do {
        /*if(role.$$type === 1)
            if(tScript = itemViewPort.mapScript['$' + eventName + '_map_leave'])
                break;
        else
            if(tScript = itemViewPort.mapScript['$' + role.$data.$id + '_' + eventName + '_map_leave'])
                break;
        */
        if(role.$$type === 1)
            if(tScript = game.f['$' + eventName + '_map_leave'])
                break;
        else
            if(tScript = game.f['$' + role.$data.$id + '_' + eventName + '_map_leave'])
                break;
        if(role.$script && (tScript = role.$script['$' + eventName + '_map_leave']))
            break;
    } while(0);

    if(tScript)
        GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(role, role) ?? null, Tips: '地图离开事件:' + role.$data.$id + '_' + eventName + '_map_leave'}, );
    //game.run(tScript() ?? null, '地图事件离开:' + eventName + '_leave');


    //调用总事件处理
    tScript = game.gf['$' + eventName + '_map_leave'];
    if(tScript)
        GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(role, role) ?? null, Tips: '地图离开事件:map_leave_' + eventName}, );



    console.debug("[GameScene]mapEventCanceled:", role.$data.$id + '_' + eventName + '_map_leave');    //触发
}


//地图点击事件
function mapClickEvent(x, y) {

    let eventName = '$map_click';
    let tScript;
    do {
        /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
            break;
        */
        if(tScript = game.f[eventName])
            break;
        if(tScript = game.gf[eventName])
            break;
    } while(0);

    if(tScript)
        game.run(tScript(Math.floor(x / itemViewPort.sizeMapBlockScaledSize.width), Math.floor(y / itemViewPort.sizeMapBlockScaledSize.height), x, y) ?? null, eventName);

    //console.debug(mouse.x, mouse.y,
    //              Math.floor(mouse.x / itemViewPort.sizeMapBlockScaledSize.width), Math.floor(mouse.y / itemViewPort.sizeMapBlockScaledSize.height))

}

//角色点击
function roleClickEvent(role, dx, dy) {
    console.debug("[GameScene]触发NPC点击事件：", role.$data.$id);

    let eventName = `$${role.$data.$id}_click`;
    //获得脚本（地图脚本优先级 > game.f定义的）
    let tScript;
    do {
        /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
            break;
        */
        if(tScript = game.f[eventName])
            break;
        if(tScript = game.gf[eventName])
            break;
        if(role.$script && (tScript = role.$script['$click']))
            break;
    } while(0);

    if(tScript) {
        game.run(tScript.call(role, role) ?? null, eventName);
        //GlobalJS.runScript(_private.scriptQueue, 0, "game.f['%1']()".arg(_private.objRoles[r].$name));

        return; //!!只执行一次事件
    }
    else {
        GameSceneJS.mapClickEvent(role.x + dx, role.y + dy);
        //mouse.accepted = false;
    }
}


//游戏主定时器
function onTriggered() {
    //console.time('all')

    //如果是0，则重新赋值
    if(timer.nLastTime <= 0) {
        timer.nLastTime = new Date().getTime();
        return;
    }

    let bScriptQueueIsEmpty = _private.scriptQueue.isEmpty();

    //获取精确时间差
    let realinterval = new Date().getTime() - timer.nLastTime;
    timer.nLastTime = timer.nLastTime + realinterval;

    game.$frameDuration = realinterval;

    //console.debug("!!!realinterval", realinterval)


    if(realinterval > 0)
        textFPS.text = "FPS:" + Math.round(1000 / realinterval);


    //定时器操作

    //遍历全局定时器
    for(let tt in _private.objGlobalTimers) {
        const objTimer = _private.objGlobalTimers[tt];
        objTimer[0] -= realinterval;

        //触发
        if(objTimer[0] <= 0) {
            //如果次数完毕
            if(objTimer[1] === 0) {
                delete _private.objGlobalTimers[tt];
                continue;
            }
            else if(objTimer[1] > 0) {
                --objTimer[1];
            }
            objTimer[0] = objTimer[3];


            let tScript;
            do {
                /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[tt]))
                    break;
                */
                if(tScript = game.f[tt])
                    break;
                if(tScript = game.gf[tt])
                    break;
            } while(0);

            if(objTimer[2] & 0b10) {
                GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript(objTimer[4], objTimer[1], realinterval) ?? null, Tips: '全局定时器事件1:' + tt});
                //game.run(tScript() ?? null, tt);
                //GlobalJS.runScript(_private.scriptQueue, 0, "game.gf['%1']()".arg(tt));
            }
            else
                game.async(tScript.call(objTimer, objTimer[4], objTimer[1], realinterval) ?? null, '全局定时器事件:' + tt, );


            //如果次数完毕
            if(objTimer[1] === 0)
                delete _private.objGlobalTimers[tt];
        }
    }
    //遍历定时器
    for(let tt in _private.objTimers) {
        const objTimer = _private.objTimers[tt];
        objTimer[0] -= realinterval;

        //触发
        if(objTimer[0] <= 0) {
            //如果次数完毕
            if(objTimer[1] === 0) {
                delete _private.objTimers[tt];
                continue;
            }
            else if(objTimer[1] > 0) {
                --objTimer[1];
            }
            objTimer[0] = objTimer[3];


            let tScript;
            do {
                /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[tt]))
                    break;
                */
                if(tScript = game.f[tt])
                    break;
                if(tScript = game.gf[tt])
                    break;
            } while(0);

            if(objTimer[2] & 0b10) {
                GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript(objTimer[4], objTimer[1], realinterval) ?? null, Tips: '定时器事件1:' + tt}, );
                //game.run(tScript() ?? null, tt);
                //GlobalJS.runScript(_private.scriptQueue, 0, "game.f['%1']()".arg(tt));
            }
            else
                game.async(tScript.call(objTimer, objTimer[4], objTimer[1], realinterval) ?? null, '定时器事件:' + tt, );


            //如果次数完毕
            if(objTimer[1] === 0)
                delete _private.objTimers[tt];
        }
    }


    //NPC操作

    //遍历每个NPC
    for(let r in _private.objRoles) {
        let role = _private.objRoles[r];

        //停止状态
        //if(role.$$nActionType === 0)
        //    continue;


        let centerX = role.x + role.x1 + parseInt(role.width1 / 2);
        let centerY = role.y + role.y1 + parseInt(role.height1 / 2);

        //定向移动
        if(role.$$nActionType === 2) {

            do {
                if(role.$$targetsPos[0] && role.$$targetsPos[0].x >= 0 && role.$$targetsPos[0].x < centerX) {
                    role.$$arrMoveDirection = [-1, 0];
                    role.start(Qt.Key_Left);
                    //_private.startSprite(role, Qt.Key_Left);
                }
                else if(role.$$targetsPos[0] && role.$$targetsPos[0].x >= 0 && role.$$targetsPos[0].x > centerX) {
                    role.$$arrMoveDirection = [1, 0];
                    role.start(Qt.Key_Right);
                    //_private.startSprite(role, Qt.Key_Right);
                }
                else if(role.$$targetsPos[0] && role.$$targetsPos[0].y >= 0 && role.$$targetsPos[0].y < centerY) {
                    role.$$arrMoveDirection = [0, -1];
                    role.start(Qt.Key_Up);
                    //_private.startSprite(role, Qt.Key_Up);
                }
                else if(role.$$targetsPos[0] && role.$$targetsPos[0].y >= 0 && role.$$targetsPos[0].y > centerY) {
                    role.$$arrMoveDirection = [0, 1];
                    role.start(Qt.Key_Down);
                    //_private.startSprite(role, Qt.Key_Down);
                }
                else {
                    role.$$targetsPos.shift();
                    if(role.$$targetsPos.length === 0) {
                        role.stopMoving();


                        let eventName = `$${role.$data.$id}_arrive`;
                        let tScript;
                        do {
                            /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
                                break;
                            */
                            if(tScript = game.f[eventName])
                                break;
                            if(tScript = game.gf[eventName])
                                break;
                            if(role.$script && (tScript = role.$script['$arrive']))
                                break;
                        } while(0);

                        if(tScript)
                            GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(role, role) ?? null, Tips: eventName}, );
                            //game.run(tScript() ?? null, role.$name);
                    }
                    else
                        continue;

                    //console.debug('!!!ok, getup')
                }
                break;
            } while(1);
        }


        //增加状态时间
        role.$$nActionStatusKeepTime += realinterval;


        //如果没有 移动方向，则 停止移动
        if(role.$$arrMoveDirection.length !== 2) {
            role.stopMoving();
            //continue;
        }

        //走路状态
        if(role.$$nActionType === 1 || role.$$nActionType === 2) {
            //console.debug("walk status")

            do {
                //随机走
                if(role.$$nActionType === 1) {
                    //如果到达切换状态阈值
                    if(role.$$nActionStatusKeepTime > _private.config.nRoleChangeActionDuration) {
                        role.$$nActionStatusKeepTime = 0;

                        //概率停止
                        if(GlobalLibraryJS.randTarget(_private.config.arrRoleChangeStopProbability, 100) !== 0) {
                            role.stopMoving();
                            break;
                        }
                    }
                }


                //计算走路
                //x、y轴上移动的距离（乘以比率）
                let offsetMoveX = Math.round(role.$$speed * realinterval);
                let offsetMoveY = Math.round(role.$$speed * realinterval);
                offsetMoveX = Math.round(offsetMoveX * Math.abs(role.$$arrMoveDirection[0]));
                offsetMoveY = Math.round(offsetMoveY * Math.abs(role.$$arrMoveDirection[1]));
                //如果有移动，至少移动1
                //offsetMoveX = role.$$arrMoveDirection[0] !== 0 ? (offsetMoveX || 1) : 0;
                //offsetMoveY = role.$$arrMoveDirection[1] !== 0 ? (offsetMoveY || 1) : 0;

                //x、y轴上移动的方向（x为1、3表示右、左；y为0、2表示上、下）
                let directionX = offsetMoveX === 0 ? -1 : role.$$arrMoveDirection[0] > 0 ? 1 : 3;
                let directionY = offsetMoveY === 0 ? -1 : role.$$arrMoveDirection[1] > 0 ? 2 : 0;

                let ret = fComputeRoleMultiMoveOffset(role, directionX, directionY, offsetMoveX, offsetMoveY, centerX, centerY);

                if(role.$$nActionType === 1) {
                    if(ret === false) {
                        role.stopMoving();
                        break;
                        //continue;
                    }
                }
            }while(0);
        }
        //站立状态
        else if(role.$$nActionType === 0) {
            //如果到达切换状态阈值
            if(role.$$nActionStatusKeepTime > _private.config.nRoleChangeActionDuration) {
                role.$$nActionStatusKeepTime = 0;

                //移动（概率）
                //console.debug("stop status")
                let tn = GlobalLibraryJS.random(0, 100)
                if(tn < _private.config.arrRoleChangeActionProbability[0]) {
                    role.$$nActionType = 1;
                    role.$$arrMoveDirection = [0, -1];
                    role.start(Qt.Key_Up);

                    //_private.startSprite(role, Qt.Key_Up);
                    //role.moveDirection = Qt.Key_Up;
                    //role.start();
                }
                else if(tn < _private.config.arrRoleChangeActionProbability[1]) {
                    role.$$nActionType = 1;
                    role.$$arrMoveDirection = [1, 0];
                    role.start(Qt.Key_Right);

                    //_private.startSprite(role, Qt.Key_Right);
                    //role.moveDirection = Qt.Key_Right;
                    //role.start();
                }
                else if(tn < _private.config.arrRoleChangeActionProbability[2]) {
                    role.$$nActionType = 1;
                    role.$$arrMoveDirection = [0, 1];
                    role.start(Qt.Key_Down);

                    //_private.startSprite(role, Qt.Key_Down);
                    //role.moveDirection = Qt.Key_Down;
                    //role.start();
                }
                else if(tn < _private.config.arrRoleChangeActionProbability[3]) {
                    role.$$nActionType = 1;
                    role.$$arrMoveDirection = [-1, 0];
                    role.start(Qt.Key_Left);

                    //_private.startSprite(role, Qt.Key_Left);
                    //role.moveDirection = Qt.Key_Left;
                    //role.start();
                }
            }
            //console.debug("status:", role.moveDirection)
        }



        //和其他角色触碰，key为$role_角色名或$hero_角色名，value为触碰时长
        let collideRoles = {};

        //与其他角色碰撞
        for(let r in _private.objRoles) {
            //跳过自身
            if(role === _private.objRoles[r])
                continue;
            //跳过没有大小的
            //if(_private.objRoles[r].width1 === 0 || _private.objRoles[r].height1 === 0)
            //    continue;


            let key = '$role_' + _private.objRoles[r].$data.$id;
            let eventName = `$${role.$data.$id}_collide`;
            let tScript;
            do {
                /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
                    break;
                */
                if(tScript = game.f[eventName])
                    break;
                if(tScript = game.gf[eventName])
                    break;
                if(role.$script && (tScript = role.$script['$collide']))
                    break;
            } while(0);

            //如果有碰撞
            if(
                //(role.$data.$penetrate === 0 && _private.objRoles[r].$data.$penetrate === 0) &&
                GlobalLibraryJS.checkRectangleClashed(
                    Qt.rect(role.x + role.x1 - 1, role.y + role.y1 - 1, role.width1 + 2, role.height1 + 2),
                    Qt.rect(_private.objRoles[r].x + _private.objRoles[r].x1, _private.objRoles[r].y + _private.objRoles[r].y1, _private.objRoles[r].width1, _private.objRoles[r].height1),
                )
            ) {
                if(tScript) {
                    let keep = 0;   //是否是持续碰撞；
                    if(role.$$collideRoles[key] !== undefined) {
                        keep = 1;
                        collideRoles[key] = role.$$collideRoles[key] + realinterval;
                    }
                    else
                        collideRoles[key] = realinterval;

                    GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(role, _private.objRoles[r], role, keep, collideRoles[key]) ?? null, Tips: eventName}, );
                }
            }
            //这次没有碰撞 且 上次有碰撞
            else if(key in role.$$collideRoles) {
                if(tScript) {
                    GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(role, _private.objRoles[r], role, -1, role.$$collideRoles[key]) ?? null, Tips: eventName}, );
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


            let key = '$hero_' + _private.arrMainRoles[r].$data.$id;
            let eventName = `$${role.$data.$id}_collide`;
            let tScript;
            do {
                /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
                    break;
                */
                if(tScript = game.f[eventName])
                    break;
                if(tScript = game.gf[eventName])
                    break;
                if(role.$script && (tScript = role.$script['$collide']))
                    break;
            } while(0);

            if(
                //(role.$data.$penetrate === 0 && _private.arrMainRoles[r].$data.$penetrate === 0) &&
                GlobalLibraryJS.checkRectangleClashed(
                    Qt.rect(role.x + role.x1 - 1, role.y + role.y1 - 1, role.width1 + 2, role.height1 + 2),
                    Qt.rect(_private.arrMainRoles[r].x + _private.arrMainRoles[r].x1, _private.arrMainRoles[r].y + _private.arrMainRoles[r].y1, _private.arrMainRoles[r].width1, _private.arrMainRoles[r].height1),
                )
            ) {
                let keep = 0;   //是否是持续碰撞；
                if(tScript) {
                    if(role.$$collideRoles[key] !== undefined) {
                        keep = 1;
                        collideRoles[key] = role.$$collideRoles[key] + realinterval;
                    }
                    else
                        collideRoles[key] = realinterval;
                    GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(role, _private.arrMainRoles[r], role, keep, collideRoles[key]) ?? null, Tips: eventName}, );
                }


                //主角脚本
                if(_private.arrMainRoles[r].$script && (tScript = _private.arrMainRoles[r].$script['$collide'])) {
                    GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(_private.arrMainRoles[r], role, _private.arrMainRoles[r], keep, collideRoles[key]) ?? null, Tips: eventName}, );
                }

                //调用总事件处理
                tScript = game.gf['$collide'];
                if(tScript) {
                    GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(_private.arrMainRoles[r], role, _private.arrMainRoles[r], keep, collideRoles[key]) ?? null, Tips: eventName}, );
                }
            }
            //这次没有碰撞 且 上次有碰撞
            else if(key in role.$$collideRoles) {
                if(tScript) {
                    GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(role, _private.arrMainRoles[r], role, -1, role.$$collideRoles[key]) ?? null, Tips: eventName}, );
                }


                //主角脚本
                if(_private.arrMainRoles[r].$script && (tScript = _private.arrMainRoles[r].$script['$collide'])) {
                    GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(_private.arrMainRoles[r], role, _private.arrMainRoles[r], -1, role.$$collideRoles[key]) ?? null, Tips: eventName}, );
                }

                //调用总事件处理
                tScript = game.gf['$collide'];
                if(tScript) {
                    GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(_private.arrMainRoles[r], role, _private.arrMainRoles[r], -1, role.$$collideRoles[key]) ?? null, Tips: eventName}, );
                }
            }
        }

        role.$$collideRoles = collideRoles;



        //计算是否触发地图事件

        let roleUseBlocks = [];

        //计算人物所占的地图块

        //返回 地图块坐标（左上和右下）
        let usedMapBlocks = itemViewPort.fComputeUseBlocks(role.x + role.x1, role.y + role.y1, role.x + role.x2, role.y + role.y2);

        //转换为 每个地图块ID
        for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
            for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
                roleUseBlocks.push(xb + yb * itemViewPort.mapInfo.MapSize[0]);
            }
        }

        let tEvents = {};   //暂存这次触发的所有事件
        //循环事件
        for(let event in itemViewPort.mapEventBlocks) {
            //console.debug("[GameScene]检测事件：", event, roleUseBlocks);
            //如果占用块包含事件块，则事件触发
            if(roleUseBlocks.indexOf(parseInt(event)) > -1) {
                let isTriggered = role.$$mapEventsTriggering[itemViewPort.mapEventBlocks[event]] ||
                    tEvents[itemViewPort.mapEventBlocks[event]];

                tEvents[itemViewPort.mapEventBlocks[event]] = event;  //加入

                //如果已经被触发过
                if(isTriggered) {

                    ////将触发的事件删除（role.$$mapEventsTriggering剩下的就是 下面要取消触发的事件 了）
                    delete role.$$mapEventsTriggering[itemViewPort.mapEventBlocks[event]];
                    continue;
                }
                //console.debug("[GameScene]mapEvent触发:", event, roleUseBlocks, itemViewPort.mapEventBlocks[event]);    //触发
                GameSceneJS.mapEvent(itemViewPort.mapEventBlocks[event], role);   //触发事件
            }
            //console.debug("event:", event, roleUseBlocks, roleUseBlocks.indexOf(event), typeof(event), typeof(itemViewPort.mapInfo.events[0]), typeof(roleUseBlocks[0]))
        }

        //检测离开事件区域
        for(let event in role.$$mapEventsTriggering) {
            //console.debug("[GameScene]mapEventCanceled触发:", event, roleUseBlocks, itemViewPort.mapEventBlocks[event]);    //触发
            GameSceneJS.mapEventCanceled(itemViewPort.mapEventBlocks[role.$$mapEventsTriggering[event]], role);   //触发事件
            //console.debug("event:", event, roleUseBlocks, roleUseBlocks.indexOf(event), typeof(event), typeof(itemViewPort.mapInfo.events[0]), typeof(roleUseBlocks[0]))
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
        if(mainRole.$$nActionType === 2) {

            do {
                if(mainRole.$$targetsPos[0] && mainRole.$$targetsPos[0].x >= 0 && mainRole.$$targetsPos[0].x < centerX) {
                    _private.startMove(2, Qt.Key_Left);
                }
                else if(mainRole.$$targetsPos[0] && mainRole.$$targetsPos[0].x >= 0 && mainRole.$$targetsPos[0].x > centerX) {
                    _private.startMove(2, Qt.Key_Right);
                }
                else if(mainRole.$$targetsPos[0] && mainRole.$$targetsPos[0].y >= 0 && mainRole.$$targetsPos[0].y < centerY) {
                    _private.startMove(2, Qt.Key_Up);
                }
                else if(mainRole.$$targetsPos[0] && mainRole.$$targetsPos[0].y >= 0 && mainRole.$$targetsPos[0].y > centerY) {
                    _private.startMove(2, Qt.Key_Down);
                }
                else {
                    mainRole.$$targetsPos.shift();
                    if(mainRole.$$targetsPos.length === 0) {
                        _private.stopMove(1, -1);


                        let eventName = `$${mainRole.$data.$id}_arrive`;
                        let tScript;
                        do {
                            /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
                                break;
                            */
                            if(tScript = game.f[eventName])
                                break;
                            if(tScript = game.gf[eventName])
                                break;
                            if(mainRole.$script && (tScript = mainRole.$script['$arrive']))
                                break;
                        } while(0);

                        if(tScript)
                            GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(mainRole, mainRole) ?? null, Tips: eventName}, );
                            //game.run(tScript() ?? null, mainRole.$name);
                    }
                    else
                        continue;

                    //console.debug('!!!ok, getup')
                }
                break;
            }while(1);
        }

        //console.debug('moveDirection:', mainRole.moveDirection)


        //如果主角不移动，则跳出移动部分
        if(mainRole.$$nActionType === 0 || mainRole.$$nActionType === -1)
            break;


        //下面是移动代码

        //计算 真实移动偏移，初始为 角色速度 * 时间差
        let offsetMoveX = Math.round(mainRole.$$speed * realinterval);
        let offsetMoveY = Math.round(mainRole.$$speed * realinterval);

        //如果开启摇杆加速，且用的不是键盘，则乘以摇杆偏移
        //鹰：摇杆、键盘统一 放在 doMove 中处理
        if(joystick.rJoystickMinimumProportion > 0 && mainRole.$$nActionType === 10 && _private.arrPressedKeys.length === 0) {
            /*let tOffset;    //遥感百分比
            if(mainRole.direction() === 3 || mainRole.direction() === 1) {
                tOffset = Math.abs(_private.pointWalkDeviation.x);
            }
            else {
                tOffset = Math.abs(_private.pointWalkDeviation.y);
            }
            //小于最小值
            if(tOffset < joystick.rJoystickMinimumProportion)
                tOffset = joystick.rJoystickMinimumProportion;
            offsetMove = Math.round(offsetMove * tOffset);
            */

            /*let tOffsetX = Math.abs(_private.pointWalkDeviation.x), tOffsetY = Math.abs(_private.pointWalkDeviation.y);
            //小于最小值
            if(tOffsetX < joystick.rJoystickMinimumProportion)
                tOffsetX = 0;
            if(tOffsetY < joystick.rJoystickMinimumProportion)
                tOffsetY = 0;
            offsetMoveX = Math.round(offsetMoveX * tOffsetX);
            offsetMoveY = Math.round(offsetMoveY * tOffsetY);
            */
        }

        //x、y轴上移动的距离（乘以比率）
        offsetMoveX = Math.round(offsetMoveX * Math.abs(mainRole.$$arrMoveDirection[0]));
        offsetMoveY = Math.round(offsetMoveY * Math.abs(mainRole.$$arrMoveDirection[1]));
        //如果有移动，至少移动1
        //offsetMoveX = mainRole.$$arrMoveDirection[0] !== 0 ? (offsetMoveX || 1) : 0;
        //offsetMoveY = mainRole.$$arrMoveDirection[1] !== 0 ? (offsetMoveY || 1) : 0;

        //x、y轴上移动的方向（x为1、3表示右、左；y为0、2表示上、下）
        let directionX = offsetMoveX === 0 ? -1 : mainRole.$$arrMoveDirection[0] > 0 ? 1 : 3;
        let directionY = offsetMoveY === 0 ? -1 : mainRole.$$arrMoveDirection[1] > 0 ? 2 : 0;

        //console.warn(mainRole.$$arrMoveDirection, directionX, directionY);

        //计算最终移动的x、y距离
        fComputeRoleMultiMoveOffset(mainRole, directionX, directionY, offsetMoveX, offsetMoveY, centerX, centerY);
        ///if(offsetMoveX === 0 && offsetMoveY === 0)
        ///    break;


        //存主角的新坐标
        //let roleNewX = mainRole.x, roleNewY = mainRole.y;


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
            let px = roleUseBlocks[i] % itemViewPort.mapInfo.MapSize[0];
            let py = parseInt(roleUseBlocks[i] / itemViewPort.mapInfo.MapSize[0]);
            let strP = [px, py].toString();

            console.debug("检测障碍：", strP, itemViewPort.mapInfo.MapBlockSpecialData)
            //存在障碍
            if(itemViewPort.mapInfo.MapBlockSpecialData[strP] !== undefined) {
                switch(itemViewPort.mapInfo.MapBlockSpecialData[strP]) {
                    //!!!这里需要修改
                case -1:
                    if(mainRole.moveDirection === Qt.Key_Left) {

                        let v = (px + 1) * itemViewPort.sizeMapBlockScaledSize.width - (mainRole.x + mainRole.x1);
                        let rolePos = fComputeRoleMoveOffset(mainRole, mainRole.moveDirection, v);
                        roleNewX = rolePos[0];
                        checkover = true;

                        console.debug("碰到左边墙壁", px, (px + 1) * itemViewPort.sizeMapBlockScaledSize.width, (mainRole.x + mainRole.x1), v);
                    }
                    if(mainRole.moveDirection === Qt.Key_Right) {

                        let rolePos = fComputeRoleMoveOffset(mainRole, mainRole.moveDirection, (px) * itemViewPort.sizeMapBlockScaledSize.width - (mainRole.x + mainRole.x2));
                        roleNewX = rolePos[0];
                        checkover = true;

                        console.debug("碰到右边障碍");
                    }
                    if(mainRole.moveDirection === Qt.Key_Up) {

                        let rolePos = fComputeRoleMoveOffset(mainRole, mainRole.moveDirection, (py + 1) * itemViewPort.sizeMapBlockScaledSize.height - (mainRole.y + mainRole.y1));
                        roleNewX = rolePos[1];
                        checkover = true;

                        console.debug("碰到上方障碍");
                    }
                    if(mainRole.moveDirection === Qt.Key_Down) {

                        let rolePos = fComputeRoleMoveOffset(mainRole, mainRole.moveDirection, (py) * itemViewPort.sizeMapBlockScaledSize.height - (mainRole.y + mainRole.y2));
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

        //返回 地图块坐标（4个元素的数组，左上和右下）
        let usedMapBlocks = itemViewPort.fComputeUseBlocks(mainRole.x + mainRole.x1, mainRole.y + mainRole.y1, mainRole.x + mainRole.x2, mainRole.y + mainRole.y2);

        //转换为 每个地图块ID
        for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
            for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
                mainRoleUseBlocks.push(xb + yb * itemViewPort.mapInfo.MapSize[0]);
            }
        }

        let tEvents = {};   //暂存这次触发的所有事件
        //循环事件
        for(let event in itemViewPort.mapEventBlocks) {
            //console.debug("[GameScene]检测事件：", event, mainRoleUseBlocks);
            //如果占用块包含事件块，则事件触发
            if(mainRoleUseBlocks.indexOf(parseInt(event)) > -1) {
                let isTriggered = mainRole.$$mapEventsTriggering[itemViewPort.mapEventBlocks[event]] ||
                    tEvents[itemViewPort.mapEventBlocks[event]];

                tEvents[itemViewPort.mapEventBlocks[event]] = event;  //加入

                //如果已经被触发过
                if(isTriggered) {

                    ////将触发的事件删除（mainRole.$$mapEventsTriggering剩下的就是 下面要取消触发的事件 了）
                    delete mainRole.$$mapEventsTriggering[itemViewPort.mapEventBlocks[event]];
                    continue;
                }
                //console.debug("[GameScene]mapEvent触发:", event, mainRoleUseBlocks, itemViewPort.mapEventBlocks[event]);    //触发
                GameSceneJS.mapEvent(itemViewPort.mapEventBlocks[event], mainRole);   //触发事件
            }
            //console.debug("event:", event, mainRoleUseBlocks, mainRoleUseBlocks.indexOf(event), typeof(event), typeof(itemViewPort.mapInfo.events[0]), typeof(mainRoleUseBlocks[0]))
        }

        //检测离开事件区域
        for(let event in mainRole.$$mapEventsTriggering) {
            //console.debug("[GameScene]mapEventCanceled触发:", event, mainRoleUseBlocks, itemViewPort.mapEventBlocks[event]);    //触发
            GameSceneJS.mapEventCanceled(itemViewPort.mapEventBlocks[mainRole.$$mapEventsTriggering[event]], mainRole);   //触发事件
            //console.debug("event:", event, mainRoleUseBlocks, mainRoleUseBlocks.indexOf(event), typeof(event), typeof(itemViewPort.mapInfo.events[0]), typeof(mainRoleUseBlocks[0]))
        }

        mainRole.$$mapEventsTriggering = tEvents;



        textPos.text = " 【%1】".
            arg([Math.floor(centerX / itemViewPort.sizeMapBlockScaledSize.width), Math.floor(centerY / itemViewPort.sizeMapBlockScaledSize.height)])
            //.arg(itemViewPort.mapInfo.data.length)
        ;

        textPos1.text = "[%1](%2),(%3),(%4),(%5)".
            arg(mainRoleUseBlocks).
            arg([centerX, centerY]).
            arg([mainRole.x, mainRole.y]).
            arg([mainRole.x + mainRole.x1, mainRole.y + mainRole.y1]).
            arg([mainRole.x + mainRole.x2, mainRole.y + mainRole.y2])
        ;

    }while(0);

    //console.timeEnd('all')


    //如果有跟随目标
    if(_private.sceneRole)
        //开始移动地图
        setSceneToRole(_private.sceneRole);
    //移动地图
    else {
        //下面是移动代码

        //计算真实移动偏移，初始为 角色速度 * 时间差
        let offsetMoveX = 0;
        let offsetMoveY = 0;

        const dta = _private.config.rSceneMoveSpeed * realinterval;

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
        else {  // if(joystick.rJoystickMinimumProportion > 0) {
            offsetMoveX = Math.round(dta);
            offsetMoveY = Math.round(dta);

            let tOffset;    //遥感百分比
            //if(Math.abs(_private.pointWalkDeviation.x) < joystick.rJoystickMinimumProportion) {
                offsetMoveX = Math.round(offsetMoveX * _private.pointWalkDeviation.x);
            //}
            //if(Math.abs(_private.pointWalkDeviation.y) < joystick.rJoystickMinimumProportion) {
                offsetMoveY = Math.round(offsetMoveY * _private.pointWalkDeviation.y);
            //}
        }

        if(offsetMoveX || offsetMoveY) {
            itemViewPort.setScenePos(parseInt(-itemViewPort.itemContainer.x + itemViewPort.gameScene.width / 2 + offsetMoveX), parseInt(-itemViewPort.itemContainer.y + itemViewPort.gameScene.height / 2 + offsetMoveY));
            //console.warn(-itemViewPort.itemContainer.x, itemViewPort.gameScene.width, itemViewPort.itemContainer.width)
            //itemViewPort.itemContainer.x -= offsetMoveX;
            //itemViewPort.itemContainer.y -= offsetMoveY;
        }
    }



    //放在这里运行事件，因为 loadmap 的地图事件会改掉所有原来的事件；
    //如果异步脚本 初始为空，且现在不为空
    if(bScriptQueueIsEmpty && !_private.scriptQueue.isEmpty())
        game.run(true);



    //插件
    for(let tc in _private.objPlugins)
        for(let tp in _private.objPlugins[tc])
            if(_private.objPlugins[tc][tp].$timerTriggered && _private.objPlugins[tc][tp].$autoLoad !== false)
                game.run(_private.objPlugins[tc][tp].$timerTriggered(realinterval) ?? null, 'plugin $timerTriggered:' + tc + tp);

    /*/精确控制下一帧（有问题）
    let runinterval = new Date().getTime() - timer.nLastTime;
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



//计算角色多方向行动时的偏移
//direction：x、y轴上移动的方向（x为1、3表示右、左；y为0、2表示上、下）
//注意：当 单向移动时，返回可以移动的偏移（因为定向移动还需要判断一次）；
function fComputeRoleMultiMoveOffset(role, directionX, directionY, offsetMoveX, offsetMoveY, centerX, centerY) {
    let collideObstacle = 0;

    //运行触碰边界脚本
    let runScript = function() {
        let keep = 0;
        //此次有触碰
        if(collideObstacle !== 0) {
            //如果和上次触碰一样，重复触碰
            if(collideObstacle === role.$$collideRoles['$obstacle'])
                keep = 1;
            //不一样，视为新触碰
            else
                keep = 0;
        }
        //上次有触碰
        else if(role.$$collideRoles['$obstacle'] !== 0 && role.$$collideRoles['$obstacle'] !== undefined)
            keep = -1;
        //两次都没有触碰
        else
            return;

        //碰撞障碍
        //if(collideObstacle !== 0) {
            let eventName = `$${role.$data.$id}_collide_obstacle`;
            let tScript;
            do {
                /*if(itemViewPort.mapScript && (tScript = itemViewPort.mapScript[eventName]))
                    break;
                */
                if(tScript = game.f[eventName])
                    break;
                if(tScript = game.gf[eventName])
                    break;
                if(role.$script && (tScript = role.$script['$collide_obstacle']))
                    break;
            } while(0);

            if(tScript) {
                GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(role, role, collideObstacle, keep) ?? null, Tips: eventName}, );
            }


            //调用总事件处理
            if(role.$$type === 1) {
                tScript = game.gf['$collide_obstacle'];
                if(tScript) {
                    GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: tScript.call(role, role, collideObstacle, 0) ?? null, Tips: eventName}, );
                }
            }
        //}


        //放在这里是因为，上面的脚本使用时可以访问到原来的 role.$$collideRoles，来确定是否第一次碰撞；
        /*let continueScript = function() {
            if(GlobalLibraryJS.isComponent(role))
                role.$$collideRoles['$obstacle'] = collideObstacle;
            return null;
        }
        GlobalJS.createScript(_private.scriptQueue, {Type: 0, Priority: -1, Script: continueScript, Tips: '角色碰撞障碍事件2:' + role.$data.$id}, );
        */
        //这里不用事件队列了（因为很容易积攒事件），可以使用参数中的 collideObstacle 体现当时的状态；

        role.$$collideRoles['$obstacle'] = collideObstacle;
    }



    //如果是一个方向上移动，则简单判断即可
    if(directionX === -1 || directionY === -1) {
        if(directionX !== -1)   //如果x方向移动
            [offsetMoveX, collideObstacle] = fComputeRoleMoveOffset(role, directionX, offsetMoveX);
        else
            offsetMoveX = 0;
        if(directionY !== -1)   //如果y方向移动
            [offsetMoveY, collideObstacle] = fComputeRoleMoveOffset(role, directionY, offsetMoveY);
        else
            offsetMoveY = 0;


        runScript();


        if(offsetMoveX === 0 && offsetMoveY === 0)
            return false;


        //定向走，需要检查处理是否越过
        if(role.$$nActionType === 2) {

            //console.debug("Start...", role.moveDirection, offsetMove);
            //人物移动计算（值为按键值）
            switch(role.direction()) {
            case 3:
                //如果$$targetsPos有x值，且大于等于0、小于角色中心坐标，角色移动后会超过；
                if(role.$$targetsPos[0] && role.$$targetsPos[0].x >= 0 && role.$$targetsPos[0].x < centerX && role.$$targetsPos[0].x > centerX - offsetMoveX) {
                    //直接设置
                    role.x = role.$$targetsPos[0].x - role.x1 - parseInt(role.width1 / 2);
                }
                else
                    role.x -= offsetMoveX;
                break;

            case 1:
                //含义同上
                if(role.$$targetsPos[0] && role.$$targetsPos[0].x >= 0 && role.$$targetsPos[0].x > centerX && role.$$targetsPos[0].x < centerX + offsetMoveX) {
                    role.x = role.$$targetsPos[0].x - role.x1 - parseInt(role.width1 / 2);
                }
                else
                    role.x += offsetMoveX;
                break;

            case 0:
                //含义同上
                if(role.$$targetsPos[0] && role.$$targetsPos[0].y >= 0 && role.$$targetsPos[0].y < centerY && role.$$targetsPos[0].y > centerY - offsetMoveY)
                    role.y = role.$$targetsPos[0].y - role.y1 - parseInt(role.height1 / 2);
                else
                    role.y -= offsetMoveY;
                break;

            case 2:
                //含义同上
                if(role.$$targetsPos[0] && role.$$targetsPos[0].y >= 0 && role.$$targetsPos[0].y > centerY && role.$$targetsPos[0].y < centerY + offsetMoveY)
                    role.y = role.$$targetsPos[0].y - role.y1 - parseInt(role.height1 / 2);
                else
                    role.y += offsetMoveY;
                break;

            default:
                break;
            }
        }
        //直接处理
        else {
            /*/人物移动计算（值为按键值）
            switch(role.direction()) {
            case 3:
                role.x -= offsetMove;
                break;

            case 1:
                role.x += offsetMove;
                break;

            case 0: //同Left
                role.y -= offsetMove;
                break;

            case 2:   //同Right
                role.y += offsetMove;
                break;

            default:
                break;
            }
            */

            if(role.$$arrMoveDirection[0] > 0)
                role.x += offsetMoveX;
            else
                role.x -= offsetMoveX;
            if(role.$$arrMoveDirection[1] > 0)
                role.y += offsetMoveY;
            else
                role.y -= offsetMoveY;
        }

        return true;
    }


    let dx, dy, tCollideObstacle1, tCollideObstacle2;
    //如果x方向移动的多，则以y为步进，循环计算y和x方向的可移动偏移
    if(offsetMoveX > offsetMoveY) {
        //let tCollideObstacle = 0;   //临时接受数据

        let proportion = offsetMoveX / offsetMoveY; //倍数；y步进时，每次x都会乘以这个数
        let ox = 0; //上次的x偏差（因为计算dx时会四舍五入，下次计算时要去掉这个偏差再计算）
        //y步进循环
        for(let oy = 1; oy <= offsetMoveY; ++oy) {
            [dy, tCollideObstacle1] = fComputeRoleMoveOffset(role, directionY, 1);   //y方向偏移
            [dx, tCollideObstacle2] = fComputeRoleMoveOffset(role, directionX, Math.round(proportion + ox)); //x方向偏移


            if(directionX === 1)
                role.x += dx;
            else
                role.x -= dx;
            if(directionY === 2)
                role.y += dy;
            else
                role.y -= dy;


            //计算x偏差
            ox = proportion - Math.round(proportion + ox);
        }
    }
    else {
        //同上
        let proportion = offsetMoveY / offsetMoveX;
        let oy = 0;
        for(let ox = 1; ox <= offsetMoveX; ++ox) {
            [dx, tCollideObstacle1] = fComputeRoleMoveOffset(role, directionX, 1);
            [dy, tCollideObstacle2] = fComputeRoleMoveOffset(role, directionY, Math.round(proportion + oy));


            if(directionX === 1)
                role.x += dx;
            else
                role.x -= dx;
            if(directionY === 2)
                role.y += dy;
            else
                role.y -= dy;


            oy = proportion - Math.round(proportion + oy);
        }
    }


    collideObstacle = tCollideObstacle1 | tCollideObstacle2;
    runScript();


    return true;
}

//计算 role 在 derect方向 在 offsetMove 距离中最多能移动的距离
//  Role向direction方向移动offsetMove，如果遇到障碍或其他role，则返回离最近障碍的距离
function fComputeRoleMoveOffset(role, direction, offsetMove) {
    let collideObstacle = 0;

    if(offsetMove <= 0)
        return [0, 0];

    //如果影子为0 或 全部可穿透，直接判断地图距离即可
    if(role.width1 <= 0 || role.height1 <= 0 || (role.$data.$penetrate & 0b11) === 0b11) {
        [offsetMove, collideObstacle] = fComputeRoleMoveToMapBound(role, direction, offsetMove);
        return [offsetMove, collideObstacle];
    }


    //判断 角色的距离（角色的碰撞不在这里检测）
    if((role.$data.$penetrate & 0b1) === 0) {
        offsetMove = fComputeRoleMoveToRolesOffset(role, direction, offsetMove);
    }

    if(offsetMove <= 0)
        return [0, 0];


    //判断角色离障碍的距离（必须放在最后，因为这里有检测碰撞）
    if((role.$data.$penetrate & 0b10) === 0) {
        [offsetMove, collideObstacle] = fComputeRoleMoveToObstacleOffset(role, direction, offsetMove);
    }
    //否则只检测边界
    else
        [offsetMove, collideObstacle] = fComputeRoleMoveToMapBound(role, direction, offsetMove);


    return [offsetMove, collideObstacle];
}

//计算 role 在 direction 方向 在 offsetMove 距离中碰到其他roles的距离
function fComputeRoleMoveToRolesOffset(role, direction, offsetMove) {

    let objRoles = _private.objRoles;
    let arrMainRoles = _private.arrMainRoles;

    if(offsetMove <= 0)
        return 0;

    switch(direction) {
    case 3:

        //与其他角色碰撞
        for(let r in objRoles) {
            //跳过自身
            if(role === objRoles[r])
                continue;
            //跳过没有大小的
            //if(objRoles[r].width1 === 0 || objRoles[r].height1 === 0)
            //    continue;

            if(
                (role.$data.$penetrate === 0 && objRoles[r].$data.$penetrate === 0) &&
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
                (role.$data.$penetrate === 0 && arrMainRoles[r].$data.$penetrate === 0) &&
                GlobalLibraryJS.checkRectangleClashed(
                    Qt.rect(role.x + role.x1 - offsetMove, role.y + role.y1, offsetMove, role.height1),
                    Qt.rect(arrMainRoles[r].x + arrMainRoles[r].x1, arrMainRoles[r].y + arrMainRoles[r].y1, arrMainRoles[r].width1, arrMainRoles[r].height1),
            ))
                offsetMove = (role.x + role.x1) - (arrMainRoles[r].x + arrMainRoles[r].x2) - 1;
        }

        return offsetMove;

        break;

    case 1:

        for(let r in objRoles) {
            //跳过自身
            if(role === objRoles[r])
                continue;
            //跳过没有大小的
            //if(objRoles[r].width1 === 0 || objRoles[r].height1 === 0)
            //    continue;

            if(
                (role.$data.$penetrate === 0 && objRoles[r].$data.$penetrate === 0) &&
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
                (role.$data.$penetrate === 0 && arrMainRoles[r].$data.$penetrate === 0) &&
                GlobalLibraryJS.checkRectangleClashed(
                    Qt.rect(role.x + role.x2 + 1, role.y + role.y1, offsetMove, role.height1),
                    Qt.rect(arrMainRoles[r].x + arrMainRoles[r].x1, arrMainRoles[r].y + arrMainRoles[r].y1, arrMainRoles[r].width1, arrMainRoles[r].height1),
            ))
                offsetMove = (arrMainRoles[r].x + arrMainRoles[r].x1) - (role.x + role.x2) - 1;
        }

        return offsetMove;

        break;

    case 0: //同Left

        for(let r in objRoles) {
            //跳过自身
            if(role === objRoles[r])
                continue;
            //跳过没有大小的
            //if(objRoles[r].width1 === 0 || objRoles[r].height1 === 0)
            //    continue;

            if(
                (role.$data.$penetrate === 0 && objRoles[r].$data.$penetrate === 0) &&
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
                (role.$data.$penetrate === 0 && arrMainRoles[r].$data.$penetrate === 0) &&
                GlobalLibraryJS.checkRectangleClashed(
                    Qt.rect(role.x + role.x1, role.y + role.y1 - offsetMove, role.width1, offsetMove),
                    Qt.rect(arrMainRoles[r].x + arrMainRoles[r].x1, arrMainRoles[r].y + arrMainRoles[r].y1, arrMainRoles[r].width1, arrMainRoles[r].height1),
            ))
                offsetMove = (role.y + role.y1) - (arrMainRoles[r].y + arrMainRoles[r].y2) - 1;
        }

        return offsetMove;

        break;

    case 2:   //同Right

        for(let r in objRoles) {
            //跳过自身
            if(role === objRoles[r])
                continue;
            //跳过没有大小的
            //if(objRoles[r].width1 === 0 || objRoles[r].height1 === 0)
            //    continue;

            if(
                (role.$data.$penetrate === 0 && objRoles[r].$data.$penetrate === 0) &&
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
                (role.$data.$penetrate === 0 && arrMainRoles[r].$data.$penetrate === 0) &&
                GlobalLibraryJS.checkRectangleClashed(
                    Qt.rect(role.x + role.x1, role.y + role.y2 + 1, role.width1, offsetMove),
                    Qt.rect(arrMainRoles[r].x + arrMainRoles[r].x1, arrMainRoles[r].y + arrMainRoles[r].y1, arrMainRoles[r].width1, arrMainRoles[r].height1),
            ))
                offsetMove = (arrMainRoles[r].y + arrMainRoles[r].y1) - (role.y + role.y2) - 1;
        }

        return offsetMove;

        break;

    default:
        //console.warn("[!GameScene]fComputeRoleMoveOffset:", direction);
        return;
    }

}


//计算地图边界
function fComputeRoleMoveToMapBound(role, direction, offsetMove) {
    let collideObstacle = 0;

    //计算距离
    switch(direction) {
    case 3:

        //如果超过地图左，则返回到左边的距离
        if(role.x + role.x1 - offsetMove < 0) {
            offsetMove = role.x + role.x1;
            collideObstacle = 0b1000;
        }
        break;
    case 1:

        //如果超过地图右，则返回到右边的距离
        if(role.x + role.x2 + offsetMove >= itemViewPort.itemContainer.width) {
            offsetMove = itemViewPort.itemContainer.width - (role.x + role.x2) - 1;
            collideObstacle = 0b0010;
        }
        break;
    case 0: //同Left

        //如果超过地图上，则返回到上边的距离
        if(role.y + role.y1 - offsetMove < 0) {
            offsetMove = role.y + role.y1;
            collideObstacle = 0b0001;
        }
        break;
    case 2:   //同Right

        //如果超过地图下，则返回到下边的距离
        if(role.y + role.y2 + offsetMove >= itemViewPort.itemContainer.height) {
            offsetMove = itemViewPort.itemContainer.height - (role.y + role.y2) - 1;
            collideObstacle = 0b0100;
        }
        break;
    }

    return [offsetMove, collideObstacle];
}

//计算 role 在 moveDirection 方向 在 offsetMove 距离中碰到障碍的距离
//返回碰到障碍的距离和是否碰到障碍
//  障碍算法：从direction方向依次循环每个地图块，如果遇到障碍就返回距离（肯定是最近）
function fComputeRoleMoveToObstacleOffset(role, direction, offsetMove) {
    let collideObstacle = 0;

    if(offsetMove <= 0)
        return [0, 0];

    let computeOver = false;//是否计算完毕（遇到图块就停止）
    //计算移动后占用图块
    let usedMapBlocks;

    [offsetMove, collideObstacle] = fComputeRoleMoveToMapBound(role, direction, offsetMove);

    //计算障碍距离
    switch(direction) {
    case 3:

        /*/如果超过地图左，则返回到左边的距离
        if(role.x + role.x1 - offsetMove < 0) {
            offsetMove = role.x + role.x1;
            collideObstacle = 0b1000;
        }*/

        usedMapBlocks = itemViewPort.fComputeUseBlocks(role.x + role.x1 - offsetMove, role.y + role.y1, role.x + role.x1, role.y + role.y2);

        //console.debug("usedMapBlocks:", usedMapBlocks);

        //从上到下，从右到左（由近到远） 检测障碍
        for(let xb = usedMapBlocks[2]; usedMapBlocks[0] <= xb; --xb) {
            for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
                let strP = [xb, yb].toString();

                //console.debug("检测障碍：", strP, itemViewPort.mapInfo.MapBlockSpecialData)
                //存在特殊图块
                if(itemViewPort.mapInfo.MapBlockSpecialData[strP] !== undefined) {
                    //障碍
                    if(itemViewPort.mapInfo.MapBlockSpecialData[strP] & 0b1) {
                        //计算离障碍距离
                        offsetMove = (role.x + role.x1) - (xb + 1) * itemViewPort.sizeMapBlockScaledSize.width;    //计算人物与障碍距离
                        collideObstacle = 0b1000;
                        computeOver = true;
                    }
                    if(computeOver)
                        break;
                }
            }
            if(computeOver)
                break;
        }
        break;

    case 1:

        /*/如果超过地图右，则返回到右边的距离
        if(role.x + role.x2 + offsetMove >= itemViewPort.itemContainer.width) {
            offsetMove = itemViewPort.itemContainer.width - (role.x + role.x2) - 1;
            collideObstacle = 0b0010;
        }*/

        usedMapBlocks = itemViewPort.fComputeUseBlocks(role.x + role.x2, role.y + role.y1, role.x + role.x2 + offsetMove, role.y + role.y2);

        //console.debug("usedMapBlocks:", usedMapBlocks);
        //从上到下，从左到右
        for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
            for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
                let strP = [xb, yb].toString();

                //console.debug("检测障碍：", strP, itemViewPort.mapInfo.MapBlockSpecialData)
                //存在特殊图块
                if(itemViewPort.mapInfo.MapBlockSpecialData[strP] !== undefined) {
                    //障碍
                    if(itemViewPort.mapInfo.MapBlockSpecialData[strP] & 0b1) {
                        offsetMove = (xb) * itemViewPort.sizeMapBlockScaledSize.width - (role.x + role.x2) - 1;    //计算人物与障碍距离
                        collideObstacle = 0b0010;
                        computeOver = true;
                    }
                    if(computeOver)
                        break;
                }
            }
            if(computeOver)
                break;
        }
        break;

    case 0: //同Left

        /*/如果超过地图上，则返回到上边的距离
        if(role.y + role.y1 - offsetMove < 0) {
            offsetMove = role.y + role.y1;
            collideObstacle = 0b0001;
        }*/

        usedMapBlocks = itemViewPort.fComputeUseBlocks(role.x + role.x1, role.y + role.y1 - offsetMove, role.x + role.x2, role.y + role.y1);

        //console.debug("usedMapBlocks:", usedMapBlocks);
        //从左到右，从下到上
        for(let yb = usedMapBlocks[3]; yb >= usedMapBlocks[1]; --yb) {
            for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
                let strP = [xb, yb].toString();

                //console.debug("检测障碍：", strP, itemViewPort.mapInfo.MapBlockSpecialData)
                //存在特殊图块
                if(itemViewPort.mapInfo.MapBlockSpecialData[strP] !== undefined) {
                    //障碍
                    if(itemViewPort.mapInfo.MapBlockSpecialData[strP] & 0b1) {
                        offsetMove = (role.y + role.y1) - (yb + 1) * itemViewPort.sizeMapBlockScaledSize.height;    //计算人物与障碍距离
                        collideObstacle = 0b0001;
                        computeOver = true;
                    }
                    if(computeOver)
                        break;
                }
            }
            if(computeOver)
                break;
        }
        break;

    case 2:   //同Right

        /*/如果超过地图下，则返回到下边的距离
        if(role.y + role.y2 + offsetMove >= itemViewPort.itemContainer.height) {
            offsetMove = itemViewPort.itemContainer.height - (role.y + role.y2) - 1;
            collideObstacle = 0b0100;
        }*/

        usedMapBlocks = itemViewPort.fComputeUseBlocks(role.x + role.x1, role.y + role.y2, role.x + role.x2, role.y + role.y2 + offsetMove);

        //console.debug("usedMapBlocks:", usedMapBlocks);
        //从左到右，从上到下
        for(let yb = usedMapBlocks[1]; yb <= usedMapBlocks[3]; ++yb) {
            for(let xb = usedMapBlocks[0]; usedMapBlocks[2] >= xb; ++xb) {
                let strP = [xb, yb].toString();

                //console.debug("检测障碍：", strP, itemViewPort.mapInfo.MapBlockSpecialData)
                //存在特殊图块
                if(itemViewPort.mapInfo.MapBlockSpecialData[strP] !== undefined) {
                    //障碍
                    if(itemViewPort.mapInfo.MapBlockSpecialData[strP] & 0b1) {
                        offsetMove = (yb) * itemViewPort.sizeMapBlockScaledSize.height - (role.y + role.y2) - 1;    //计算人物与障碍距离
                        collideObstacle = 0b0100;
                        computeOver = true;
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

    return [offsetMove, collideObstacle];
}





//转换方向（碰墙后）
function fChangeMainRoleDirection() {
    return;

    console.debug("！！碰墙返回", mainRole.moveDirection);
    if(mainRole.$props.$tmpDirection !== undefined) {
        _private.startSprite(mainRole, mainRole.$props.$tmpDirection);
        delete mainRole.$props.$tmpDirection;
        return;
    }

    //人物的占位最中央 所在地图的坐标
    let bx = Math.floor((mainRole.x + mainRole.x1 + mainRole.width1 / 2) / itemViewPort.sizeMapBlockScaledSize.width);
    let by = Math.floor((mainRole.y + mainRole.y1 + mainRole.height1 / 2) / itemViewPort.sizeMapBlockScaledSize.height);

    switch(mainRole.moveDirection) {
    case Qt.Key_Left:
        if(mainRole.x + mainRole.x1 === 0) {
            return;
        }

        break;

    case Qt.Key_Right:
        if(mainRole.x + mainRole.x2 === itemViewPort.itemContainer.width - 1) {
            return;
        }

        break;

    case Qt.Key_Up:
        if(mainRole.y + mainRole.y1 === 0) {
            console.debug("！！碰边界返回2")
            return;
        }

        //左边距离和右边距离
        let toffset1 = (mainRole.x + mainRole.x2) % itemViewPort.sizeMapBlockScaledSize.width + 1;
        let toffset2 = itemViewPort.sizeMapBlockScaledSize.width - (mainRole.x + mainRole.x1) % itemViewPort.sizeMapBlockScaledSize.width;
        if(toffset1 > itemViewPort.sizeMapBlockScaledSize.width / 3 && toffset2 > itemViewPort.sizeMapBlockScaledSize.width / 3 ) {
            //_private.startSprite(mainRole, Qt.Key_Up);
            console.debug("！！不能转方向返回")
            return;
        }
        if(toffset1 < toffset2) {
            if(toffset1 < fComputeRoleMoveOffset(mainRole, Qt.Key_Left, toffset1)) {
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
            if(toffset2 < fComputeRoleMoveOffset(mainRole, Qt.Key_Right, toffset2)) {
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
        if(mainRole.y + mainRole.y2 === itemViewPort.itemContainer.height - 1)
            return offsetMove;

        break;

    }

    return offsetMove;
}



function test() {

    /*itemViewPort.mapInfo = {
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


    //itemViewPort.mapInfo.events = [1, 40];

    //mainRole.x1 = 0;
    //mainRole.y1 = mainRole.height - itemViewPort.sizeMapBlockScaledSize.height;
    //mainRole.width1 = 50;
    //mainRole.width1 = mainRole.width;
    //mainRole.height1 = itemViewPort.sizeMapBlockScaledSize.height;
    //mainRole.height1 = mainRole.height;
}
