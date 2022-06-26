-- @region: script information
    -- @ Half-life parody.
    -- @ Created by попросил скрыть ник, но все мы его знаем
    -- @ Version: 0.3.0 [debug].
    -- @ Last update: 01.0.1.2022.
-- @endregion

local screen_size = EngineClient.GetScreenSize()
local sauron_text = {}

local __main__ = function()
    -- @region: ffi elements
    local ffi = require("ffi")
    ffi.cdef[[
        typedef struct {
            uint8_t r; uint8_t g; uint8_t b; uint8_t a;
        } color_struct_t;

        typedef void (*console_color_print)(const color_struct_t&, const char*, ...);
        void* GetProcAddress(void* hModule, const char* lpProcName);
        void* GetModuleHandleA(const char* lpModuleName);

        typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
        struct Animstate_t
        {
            char pad[3];
            char m_bForceWeaponUpdate;
            char pad1[91];
            void* m_pBaseEntity;
            void* m_pActiveWeapon;
            void* m_pLastActiveWeapon;
            float m_flLastClientSideAnimationUpdateTime;
            int m_iLastClientSideAnimationUpdateFramecount;
            float m_flAnimUpdateDelta;
            float m_flEyeYaw;
            float m_flPitch;
            float m_flGoalFeetYaw;
            float m_flCurrentFeetYaw;
            float m_flCurrentTorsoYaw;
            float m_flUnknownVelocityLean;
            float m_flLeanAmount;
            char pad2[4];
            float m_flFeetCycle;
            float m_flFeetYawRate;
            char pad3[4];
            float m_fDuckAmount;
            float m_fLandingDuckAdditiveSomething;
            char pad4[4];
            float m_vOriginX;
            float m_vOriginY;
            float m_vOriginZ;
            float m_vLastOriginX;
            float m_vLastOriginY;
            float m_vLastOriginZ;
            float m_vVelocityX;
            float m_vVelocityY;
            char pad5[4];
            float m_flUnknownFloat1;
            char pad6[8];
            float m_flUnknownFloat2;
            float m_flUnknownFloat3;
            float m_flUnknown;
            float m_flSpeed2D;
            float m_flUpVelocity;
            float m_flSpeedNormalized;
            float m_flFeetSpeedForwardsOrSideWays;
            float m_flFeetSpeedUnknownForwardOrSideways;
            float m_flTimeSinceStartedMoving;
            float m_flTimeSinceStoppedMoving;
            bool m_bOnGround;
            bool m_bInHitGroundAnimation;
            float m_flTimeSinceInAir;
            float m_flLastOriginZ;
            float m_flHeadHeightOrOffsetFromHittingGroundAnimation;
            float m_flStopToFullRunningFraction;
            char pad7[4];
            float m_flMagicFraction;
            char pad8[60];
            float m_flWorldForce;
            char pad9[462];
            float m_flMaxYaw;
        };

        int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);
        void* VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);
        int VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);

        typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
        typedef struct
        {
            float x;
            float y;
            float z;
        } Vector_t;

        typedef struct
        {
            char    pad0[0x60]; // 0x00
            void* pEntity; // 0x60
            void* pActiveWeapon; // 0x64
            void* pLastActiveWeapon; // 0x68
            float        flLastUpdateTime; // 0x6C
            int            iLastUpdateFrame; // 0x70
            float        flLastUpdateIncrement; // 0x74
            float        flEyeYaw; // 0x78
            float        flEyePitch; // 0x7C
            float        flGoalFeetYaw; // 0x80
            float        flLastFeetYaw; // 0x84
            float        flMoveYaw; // 0x88
            float        flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
            float        flLeanAmount; // 0x90
            char    pad1[0x4]; // 0x94
            float        flFeetCycle; // 0x98 0 to 1
            float        flMoveWeight; // 0x9C 0 to 1
            float        flMoveWeightSmoothed; // 0xA0
            float        flDuckAmount; // 0xA4
            float        flHitGroundCycle; // 0xA8
            float        flRecrouchWeight; // 0xAC
            Vector_t        vecOrigin; // 0xB0
            Vector_t        vecLastOrigin;// 0xBC
            Vector_t        vecVelocity; // 0xC8
            Vector_t        vecVelocityNormalized; // 0xD4
            Vector_t        vecVelocityNormalizedNonZero; // 0xE0
            float        flVelocityLenght2D; // 0xEC
            float        flJumpFallVelocity; // 0xF0
            float        flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1
            float        flRunningSpeed; // 0xF8
            float        flDuckingSpeed; // 0xFC
            float        flDurationMoving; // 0x100
            float        flDurationStill; // 0x104
            bool        bOnGround; // 0x108
            bool        bHitGroundAnimation; // 0x109
            char    pad2[0x2]; // 0x10A
            float        flNextLowerBodyYawUpdateTime; // 0x10C
            float        flDurationInAir; // 0x110
            float        flLeftGroundHeight; // 0x114
            float        flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
            float        flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
            char    pad3[0x4]; // 0x120
            float        flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
            char    pad4[0x208]; // 0x128
            float        flMinBodyYaw; // 0x330
            float        flMaxBodyYaw; // 0x334
            float        flMinPitch; //0x338
            float        flMaxPitch; // 0x33C
            int            iAnimsetVersion; // 0x340
        } CCSGOPlayerAnimationState_534535_t;

        typedef struct {
            char  pad_0000[20];
            int m_nOrder; //0x0014
            int m_nSequence; //0x0018
            float m_flPrevCycle; //0x001C
            float m_flWeight; //0x0020
            float m_flWeightDeltaRate; //0x0024
            float m_flPlaybackRate; //0x0028
            float m_flCycle; //0x002C
            void *m_pOwner; //0x0030
            char  pad_0038[4]; //0x0034
        } CAnimationLayer_t;
    ]]

    local color_print_fn = ffi.cast(
        "console_color_print", ffi.C.GetProcAddress(ffi.C.GetModuleHandleA("tier0.dll"), "?ConColorMsg@@YAXABVColor@@PBDZZ")
    )

    local colored_print = function(color, text)
        local col = ffi.new("color_struct_t")
        for i, v in pairs({"r", "g", "b", "a"}) do
            col[v] = color[v] * 255
        end

        color_print_fn(col, text)
    end

    local vtable = {
        entry = function(instance, index, type)
            return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
        end,
  
        thunk = function(self, index, typestring)
            local t = ffi.typeof(typestring)
            return function(instance, ...)
                assert(instance ~= nil)
                if instance then
                    return self.entry(instance, index, t)(instance, ...)
                end
            end
        end,
  
        bind = function(self, module, interface, index, typestring)
            local instance = Utils.CreateInterface(module, interface)
            local fnptr = self.entry(instance, index, ffi.typeof(typestring))
            return function(...)
                return fnptr(instance, ...)
            end
        end
    }

    local native_GetClipboardTextCount = vtable:bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
    local native_SetClipboardText = vtable:bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
    local native_GetClipboardText = vtable:bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")
    local new_char_arr = ffi.typeof("char[?]")

    local function set_clipboard_text(text)
        native_SetClipboardText(text, text:len())
    end

    local function get_clipboard_text()
        local len = native_GetClipboardTextCount()
        if len > 0 then
            local char_arr = new_char_arr(len)
            native_GetClipboardText(0, char_arr, len)
            return ffi.string(char_arr, len-1)
        end
    end

    local entity_list_pointer = ffi.cast("void***", Utils.CreateInterface("client.dll", "VClientEntityList003"))
    local get_client_entity_fn = ffi.cast("GetClientEntity_4242425_t", entity_list_pointer[0][3])
    local get_entity_address = function(ent_index)
        local addr = get_client_entity_fn(entity_list_pointer, ent_index)
        return addr
    end

    local get_max_feet_yaw = function(player)
        local animstate = ffi.cast("struct Animstate_t**", get_entity_address(player:EntIndex()) + 0x9960)[0]
        if animstate ~= nil then
            local duck_amount = animstate.m_fDuckAmount
            local forward_or_sideways_speed = math.max(0, math.min(1, animstate.m_flFeetSpeedForwardsOrSideWays))
            local unknown_forward_or_sideways_speed = math.max(1, animstate.m_flFeetSpeedUnknownForwardOrSideways)
            local result_value = (animstate.m_flStopToFullRunningFraction * -0.30000001 - 0.19999999) * forward_or_sideways_speed + 1

            if duck_amount > 0 then
                result_value = result_value + duck_amount * unknown_forward_or_sideways_speed * (0.5 - result_value)
            end
      
            local return_delta_yaw = math.abs(animstate.m_flMaxYaw * result_value)
            return return_delta_yaw
        end
    end

    local hook_helpers = {
        copy = function(dst, src, len)
            return ffi.copy(ffi.cast('void*', dst), ffi.cast('const void*', src), len)
        end,
      
        virtual_protect = function(lpAddress, dwSize, flNewProtect, lpflOldProtect)
            return ffi.C.VirtualProtect(ffi.cast('void*', lpAddress), dwSize, flNewProtect, lpflOldProtect)
        end,
      
        virtual_alloc = function(lpAddress, dwSize, flAllocationType, flProtect, blFree)
            local alloc = ffi.C.VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect)
            if blFree then
                table.insert(buff.free, function()
                    ffi.C.VirtualFree(alloc, 0, 0x8000)
                end)
            end
            return ffi.cast('intptr_t', alloc)
        end
    }

    local buff = {free = {}}
    local vmt_hook = {hooks = {}}

    function vmt_hook.new(vt)
        local new_hook = {}
        local org_func = {}
        local old_prot = ffi.new('unsigned long[1]')
        local virtual_table = ffi.cast('intptr_t**', vt)[0]
  
        new_hook.this = virtual_table
        new_hook.hookMethod = function(cast, func, method)
            org_func[method] = virtual_table[method]
            hook_helpers.virtual_protect(virtual_table + method, 4, 0x4, old_prot)
  
            virtual_table[method] = ffi.cast('intptr_t', ffi.cast(cast, func))
            hook_helpers.virtual_protect(virtual_table + method, 4, old_prot[0], old_prot)
  
            return ffi.cast(cast, org_func[method])
        end
  
        new_hook.unHookMethod = function(method)
            hook_helpers.virtual_protect(virtual_table + method, 4, 0x4, old_prot)
            local alloc_addr = hook_helpers.virtual_alloc(nil, 5, 0x1000, 0x40, false)
            local trampoline_bytes = ffi.new('uint8_t[?]', 5, 0x90)
  
            trampoline_bytes[0] = 0xE9
            ffi.cast('int32_t*', trampoline_bytes + 1)[0] = org_func[method] - tonumber(alloc_addr) - 5
  
            hook_helpers.copy(alloc_addr, trampoline_bytes, 5)
            virtual_table[method] = ffi.cast('intptr_t', alloc_addr)
  
            hook_helpers.virtual_protect(virtual_table + method, 4, old_prot[0], old_prot)
            org_func[method] = nil
        end
  
        new_hook.unHookAll = function()
            for method, func in pairs(org_func) do
                new_hook.unHookMethod(method)
            end
        end
  
        table.insert(vmt_hook.hooks, new_hook.unHookAll)
        return new_hook
    end
    -- @endregion

    -- @region: menu events
    local menu_database = {
        handler = {
            elements = {},
            references = {}
        },

        update_menu = function(self)
            for _, data in pairs(self.handler.references) do
                if data.condition ~= nil then
                    data.reference:SetVisible(data.condition())
                end
            end
        end,

        add_element = function(self, element_name, reference, condition)
            if type(element_name) ~= "string" or type(reference) ~= "userdata" then
                print(('[Half-life debugger] Wrong element userdata - ["%s"].'):format(element_name))
                self.check_error()
            end

            if condition ~= nil and type(condition) ~= "function" then
                print(('[Half-life debugger] Wrong element condition - ["%s"].'):format(element_name))
                self.check_error()
            end

            if self.handler.references[element_name] ~= nil then
                print(('[Half-life debugger] Element already exists - ["%s"].'):format(element_name))
                self.check_error()
            end

            self.handler.references[element_name] = {
                reference = reference,
                name = unique_name,
                condition = condition
            }

            local execute_callbacks = function(new_value)
                self.handler.elements[element_name] = new_value
                self:update_menu()
            end

            execute_callbacks(reference:Get())
            reference:RegisterCallback(execute_callbacks)
        end,

        set_value = function(self, element_name, value)
            local execute_callbacks = function()
                self.handler.elements[element_name] = value
                self:update_menu()
            end

            self.handler.references[element_name].reference:Set(value)
            execute_callbacks()
        end,

        phases_vars = {
            phases = {},
            count = 0
        },

        all_elements = function(self)
            -- @note: strextter: ragebot tab
                -- @note: strexxter: dormant aimbot elements
                self:add_element("Enable dormant aimbot", Menu.Switch("-> Ragebot", "Dormant aimbotting", "Enable dormant aimbot", false))
                local dormant_aimbot_elements = {
                    names = {"Minimum damage"},
                    set_functions = {Menu.SliderInt},
                    values = {{5, 0, 105}}
                }

                for i = 1, #dormant_aimbot_elements.values do
                    local callback_list = {"Minimum damage"}
                    local callbacks = ("Dormant aimbot %s"):format(callback_list[i]:lower())

                    local names = dormant_aimbot_elements.names[i]
                    local functions = dormant_aimbot_elements.set_functions[i]
                    local values = dormant_aimbot_elements.values[i]

                    self:add_element(callbacks, functions("-> Ragebot", "Dormant aimbotting", names, unpack(values)), function()
                        return self.handler.elements["Enable dormant aimbot"]
                    end)
                end

                self:add_element("Enable custom DT speed", Menu.Switch("-> Ragebot", "Doubletap speed", "Enable custom DT speed", false))
                self:add_element("Custom DT speed", Menu.SliderInt("-> Ragebot", "Doubletap speed", "Custom DT speed", 16, 13, 16), function()
                    return self.handler.elements["Enable custom DT speed"]
                end)
            -- @note: strexxter: anti-aimbotting tab
                -- @note: strextter: default anti-aimbotting elements
                self:add_element("Enable anti-aimbotting", Menu.Switch(
                    "-> Anti-aimbotting", "Anti-aimbotting elements", "Enable anti-aimbotting elements", false)
                )

                self:add_element("Anti-aimbotting presets", Menu.Combo(
                    "-> Anti-aimbotting", "Anti-aimbotting elements", "Select preset:", {
                        "Default", "Safe head", "Tank AA", "Experimental", "Customizable"
                    }, 0
                ), function()
                    return self.handler.elements["Enable anti-aimbotting"]
                end)

                -- @note: strexxter: proccess of making custom aa elements
                local conditions = {
                    "Hidden", "Standing", "Moving", "Ducking", "Fakeduck", "Slow Walk", "In air"
                }

                self:add_element("Conditions", Menu.Combo("-> Anti-aimbotting", "Anti-aimbotting elements", "Conditions", conditions, 0),
                function()
                    return self.handler.elements["Enable anti-aimbotting"]
                    and self.handler.elements["Anti-aimbotting presets"] == 4
                end)

                for i = 1, #conditions do
                    local condition_name = conditions[i + 1]
                    local modes = {
                        "Yaw Add Left", "Yaw Add Right",
                        "Yaw Modifier", "Modifier Degree",
                        "Fake Limit Type", "Left Limit", "Right Limit",
                        "Fake Options", "LBY Mode", "Fake Desync", "Desync On Shot", "Inverter"
                    }
  
                    for k = 1, #modes do
                        local mode_name = modes[k]
                        local functions = {
                            Menu.SliderInt, Menu.SliderInt,
                            Menu.Combo, Menu.SliderInt,
                            Menu.Combo, Menu.SliderInt, Menu.SliderInt,
                            Menu.MultiCombo, Menu.Combo, Menu.Combo, Menu.Combo, Menu.Switch
                        }
  
                        local sub_functions = {
                            {0, -180, 180}, {0, -180, 180},
                            {{"Disabled", "Center", "Offset", "Random", "Spin"}, 0}, {0, -180, 180},
                            {{"Static", "Jitter"}, 0}, {60, 0, 60}, {60, 0, 60},
                            {{"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"}, 0},
                            {{"Disabled", "Opposite", "Sway"}, 0}, {{"Off", "Peek Fake", "Peek Real"}, 0},
                            {{"Disabled", "Opposite", "Freestanding", "Switch"}, 0}, {false}
                        }
  
                        local total = {
                            callbacks = ("%s %s"):format(condition_name, mode_name),
                            names = ("[%s] %s\n"):format(i, mode_name)
                        }

  
                        self:add_element(total.callbacks, functions[k](
                            "-> Anti-aimbotting", "Anti-aimbotting elements", total.names, unpack(sub_functions[k])
                        ), function()
                            return self.handler.elements["Enable anti-aimbotting"]
                            and self.handler.elements["Anti-aimbotting presets"] == 4
                            and self.handler.elements["Conditions"] == i
                        end)
                    end
                end

                self:add_element("Update presets", Menu.Button(
                    "-> Anti-aimbotting", "Anti-aimbotting elements", "Update alternative settings", "Load alternative settings!"
                ), function()
                    return self.handler.elements["Enable anti-aimbotting"]
                    and not (self.handler.elements["Anti-aimbotting presets"] == 4)
                end)

                local apply_presets = function()
                    local current_preset = self.handler.elements["Anti-aimbotting presets"]
                    local update_anti_bruteforce_phases = function()
                        local remove_phases = function()
                            local length = #self.phases_vars.phases
                            if length == 0 then return end
          
                            for i = 1, length do
                                local remove_name = ("Phase #%s"):format(i)
                                local directory = self.handler.references[remove_name].reference
              
                                Menu.DestroyItem(directory)
                                self.phases_vars.count = 0
              
                                local remove_key = function(table, key)
                                    local element = table[key]
                                    table[key] = nil
                                    return element
                                end
              
                                table.remove(self.phases_vars.phases)
                                remove_key(self.handler.elements, remove_name)
                                remove_key(self.handler.references, remove_name)
                            end
                        end

                        local add_phases = function()
                            local current_indexes = current_preset == 1 and 2 or 3
                            for i = 1, current_indexes do
                                self.phases_vars.count = self.phases_vars.count + 1
                                table.insert(self.phases_vars.phases, self.phases_vars.count)
              
                                local callbacks = ("Phase #%s"):format(self.phases_vars.count)
                                local name = ("Phase #%s"):format(self.phases_vars.count)
              
                                self:add_element(callbacks, Menu.SliderInt(
                                    "-> Anti-aimbotting", "Anti-bruteforce manager", name, 60, -60, 60
                                ), function()
                                    return self.handler.elements["Enable anti-aimbotting helpers"]
                                    and bit.band(self.handler.elements["Anti-aimbotting helpers"], bit.lshift(1, 0)) ~= 0
                                end)
              
                                self:set_value("Phase slider", self.phases_vars.count)
                            end

                            if current_preset == 0 then -- default
                                self:set_value("Phase #1", -60)
                                self:set_value("Phase #2", 60)
                                self:set_value("Phase #3", -47)
                            elseif current_preset == 1 then -- safe head
                                self:set_value("Phase #1", -60)
                                self:set_value("Phase #2", 60)
                            elseif current_preset == 3 then -- experimental
                                self:set_value("Phase #1", 60)
                                self:set_value("Phase #2", -47)
                                self:set_value("Phase #3", 60)
                            end
                        end

                        remove_phases()
                        add_phases()
                    end

                    local update_helpers = function(value)
                        self:set_value("Enable anti-aimbotting helpers", true)
                        self:set_value("Anti-aimbotting helpers", value)
                    end

                    if current_preset == 0 then -- default
                        update_anti_bruteforce_phases()
                        update_helpers(261)
                    elseif current_preset == 1 then -- safe head
                        update_anti_bruteforce_phases()
                        update_helpers(277)
                    elseif current_preset == 2 then -- tank aa
                        update_helpers(260)
                    elseif current_preset == 3 then -- experimental
                        update_anti_bruteforce_phases()
                        update_helpers(261)
                    end
                end

                --@note: strexxter: anti-aimbotting helpers
                self:add_element("Enable anti-aimbotting helpers", Menu.Switch(
                    "-> Anti-aimbotting", "Additional settings", "Enable additional settings", false)
                )

                self:add_element("Anti-aimbotting helpers", Menu.MultiCombo(
                    "-> Anti-aimbotting", "Additional settings", "Select helpers:", {
                        "Anti-bruteforce", "Break lagcomp in air", "Anti-backstabbing", "Bombsite E-Fix",
                        "Smart yaw ras-position", "Dynamic fake yaw", "Avoid onshoting", "Legit AA on E",
                        "Disable fakelag on HS"
                    }, 0
                ), function()
                    return self.handler.elements["Enable anti-aimbotting helpers"]
                end)

                self.handler.references["Update presets"].reference:RegisterCallback(apply_presets)
                self:add_element("Breaking lagcomp weapons", Menu.MultiCombo(
                    "-> Anti-aimbotting", "Additional settings", "Teleport weapons", {
                        "Default", "Pistols", "Heavy pistols", "Scout", "AWP", "Autosnipers", "Nades"
                    }, 0
                ), function()
                    return self.handler.elements["Enable anti-aimbotting helpers"]
                    and bit.band(self.handler.elements["Anti-aimbotting helpers"], bit.lshift(1, 1)) ~= 0
                end)

                self:add_element("Anti-aimbotting helpers text", Menu.Text(
                    "-> Anti-aimbotting", "Additional settings", "Dont use it with custom anti-aim preset!"
                ), function()
                    return self.handler.elements["Enable anti-aimbotting helpers"]
                    and self.handler.elements["Anti-aimbotting presets"] == 4
                    and (
                        bit.band(self.handler.elements["Anti-aimbotting helpers"], bit.lshift(1, 4)) ~= 0
                        or bit.band(self.handler.elements["Anti-aimbotting helpers"], bit.lshift(1, 5)) ~= 0
                        or bit.band(self.handler.elements["Anti-aimbotting helpers"], bit.lshift(1, 6)) ~= 0
                    )
                end)

                self:add_element("Copy config", Menu.Button(
                    "-> Anti-aimbotting", "Config system", "Copy your config to clipboard.", "Copy your config to clipboard.")
                )

                self:add_element("Import config", Menu.Button(
                    "-> Anti-aimbotting", "Config system", "Import config from clipboard.", "Import your config from clipboard.")
                )

                -- @note: strexxter: anti-bruteforce phases
                self:add_element("Anti-bruteforce add button", Menu.Button(
                    "-> Anti-aimbotting", "Anti-bruteforce manager", "Add new phase", "Add new phase for anti-bruteforce!"
                ), function()
                    return self.handler.elements["Enable anti-aimbotting helpers"]
                    and bit.band(self.handler.elements["Anti-aimbotting helpers"], bit.lshift(1, 0)) ~= 0
                end)

                self:add_element("Anti-bruteforce remove button", Menu.Button(
                    "-> Anti-aimbotting", "Anti-bruteforce manager", "Remove phase", "Remove phase for anti-bruteforce!"
                ), function()
                    return self.handler.elements["Enable anti-aimbotting helpers"]
                    and bit.band(self.handler.elements["Anti-aimbotting helpers"], bit.lshift(1, 0)) ~= 0
                end)

                self:add_element("Phase slider", Menu.SliderInt(
                    "-> Anti-aimbotting", "Additional settings", "Phase slider", self.phases_vars.count, 0, 15)
                )

                local add_new_phase = function()
                    if #self.phases_vars.phases > 9 then
                        table.insert(sauron_text, {
                            text = "You cant make more phases than 10.",
  
                            timer = GlobalVars.realtime,
                            smooth_y = screen_size.y + 100,
                            alpha = 0,
              
                            first_circle = 0,
                            second_circle = 0,
              
                            box_left = screen_size.x / 2,
                            box_right = screen_size.x / 2,
              
                            box_left_1 = screen_size.x / 2,
                            box_right_1 = screen_size.x / 2
                        })
  
                        print("[Half-life debugger] You cant make more than 10 phases.")
                        return
                    end
  
                    self.phases_vars.count = self.phases_vars.count + 1
                    table.insert(self.phases_vars.phases, self.phases_vars.count)
  
                    local callbacks = ("Phase #%s"):format(self.phases_vars.count)
                    local name = ("Phase #%s"):format(self.phases_vars.count)
  
                    self:add_element(callbacks, Menu.SliderInt(
                        "-> Anti-aimbotting", "Anti-bruteforce manager", name, 60, -60, 60
                    ), function()
                        return self.handler.elements["Enable anti-aimbotting helpers"]
                        and bit.band(self.handler.elements["Anti-aimbotting helpers"], bit.lshift(1, 0)) ~= 0
                    end)
  
                    self:set_value("Phase slider", self.phases_vars.count)
                end

                local remove_phase = function()
                    local length = #self.phases_vars.phases
                    if length == 0 then
                        return
                    end
  
                    local remove_name = ("Phase #%s"):format(length)
                    local directory = self.handler.references[remove_name].reference
  
                    Menu.DestroyItem(directory)
                    self.phases_vars.count = self.phases_vars.count - 1
  
                    local remove_key = function(table, key)
                        local element = table[key]
                        table[key] = nil
                        return element
                    end
  
                    table.remove(self.phases_vars.phases, length)
                    remove_key(self.handler.elements, remove_name)
                    remove_key(self.handler.references, remove_name)
                end
  
                self.handler.references["Anti-bruteforce add button"].reference:RegisterCallback(add_new_phase)
                self.handler.references["Anti-bruteforce remove button"].reference:RegisterCallback(remove_phase)

                local value_of_phases = self.handler.elements["Phase slider"]
                if value_of_phases ~= 0 then
                    for i = 1, value_of_phases do
                        self:add_element(("Phase #%s"):format(i), Menu.SliderInt(
                            "-> Anti-aimbotting", "Anti-bruteforce manager", ("Phase #%s"):format(i), 0, -60, 60
                        ), function()
                            return self.handler.elements["Enable anti-aimbotting helpers"]
                            and bit.band(self.handler.elements["Anti-aimbotting helpers"], bit.lshift(1, 0)) ~= 0
                        end)

                        self.phases_vars.count = value_of_phases
                        table.insert(self.phases_vars.phases, self.phases_vars.count)
                    end
                end

                self.handler.references["Phase slider"].reference:SetVisible(false)
                self:add_element("Enable roll angles", Menu.Switch("-> Anti-aimbotting", "Roll angles", "Enable roll angles", false))
                self:add_element("Only manual roll angles", Menu.Switch("-> Anti-aimbotting", "Roll angles", "Only on manual trigger", false), function()
                    return self.handler.elements["Enable roll angles"]
                end)

                self:add_element("Manual roll angles", Menu.Combo(
                    "-> Anti-aimbotting", "Roll angles", "Select yaw base", {"Disabled", "Left", "Right"}, 0, "Select yaw base or bind them!"
                ), function()
                    return self.handler.elements["Enable roll angles"]
                    and self.handler.elements["Only manual roll angles"]
                end)
            -- @note: strexxter: visuals tab
                -- @note: strexxter: all indicator elements
                self:add_element("Enable indicator list", Menu.Switch("-> Visuals", "All indicators", "Enable indicators", false))
                self:add_element("Indicator list", Menu.MultiCombo("-> Visuals", "All indicators", "Select indicators:", {
                    "Under crosshair", "Half-life watermark", "Damage indicator", "Skeet autopeek",
                    "Side skeet indicators", "Disable animation on 3rd person", "Crosshair hitmarker",
                    "Notifications", "Skeet damage markers"
                }, 0), function()
                    return self.handler.elements["Enable indicator list"]
                end)

                self:add_element("Under crosshair style", Menu.Combo("-> Visuals", "All indicators", "Under crosshair style", {
                    "Default", "Modern", "Legacy"
                }, 0), function()
                    return self.handler.elements["Enable indicator list"]
                    and bit.band(self.handler.elements["Indicator list"], bit.lshift(1, 0)) ~= 0
                end)

                self:add_element("Minimum damage position", Menu.Combo("-> Visuals", "All indicators", "Damage position", {
                    "Bottom Left", "Bottom Right", "Top Right", "Top Left", "Middle", "Far Left", "Far Right", "Far Up"
                }, 0), function()
                    return self.handler.elements["Enable indicator list"]
                    and bit.band(self.handler.elements["Indicator list"], bit.lshift(1, 2)) ~= 0
                end)

                self:add_element("Skeet autopeek color", Menu.ColorEdit(
                    "-> Visuals", "All indicators", "Skeet autopeek color", Color.RGBA(255, 255, 255, 255)
                ), function()
                    return self.handler.elements["Enable indicator list"]
                    and bit.band(self.handler.elements["Indicator list"], bit.lshift(1, 3)) ~= 0
                end)

                self:add_element("Skeet autopeek type", Menu.Combo(
                    "-> Visuals", "All indicators", "Skeet autopeek type", {"Default", "Quick peek"}, 0
                ), function()
                    return self.handler.elements["Enable indicator list"]
                    and bit.band(self.handler.elements["Indicator list"], bit.lshift(1, 3)) ~= 0
                end)

                self:add_element("Skeet indicator elements", Menu.MultiCombo("-> Visuals", "All indicators", "Indicator elements", {
                    "AA With Circle", "Shot/Miss Percent", "FL Text indicator", "Body Aim", "Exploit",
                    "Damage", "Dormant Aimbot", "Fake Ping", "Lag Compensation", "Fake Duck",
                    "Bomb Info", "Double Tap"
                }, 0), function()
                    return self.handler.elements["Enable indicator list"]
                    and bit.band(self.handler.elements["Indicator list"], bit.lshift(1, 4)) ~= 0
                end)

                self:add_element("Hit/miss type", Menu.Combo("-> Visuals", "All indicators", "Hit/miss type", {"Style 1", "Style 2"}, 0), function()
                    return self.handler.elements["Enable indicator list"]
                    and bit.band(self.handler.elements["Indicator list"], bit.lshift(1, 4)) ~= 0
                    and bit.band(self.handler.elements["Skeet indicator elements"], bit.lshift(1, 1)) ~= 0
                end)

                self:add_element("Damage type", Menu.Combo("-> Visuals", "All indicators", "Damage type", {"Damage: ", "DMG", "Damage value"}, 0), function()
                    return self.handler.elements["Enable indicator list"]
                    and bit.band(self.handler.elements["Indicator list"], bit.lshift(1, 4)) ~= 0
                    and bit.band(self.handler.elements["Skeet indicator elements"], bit.lshift(1, 5)) ~= 0
                end)

                self:add_element("Crosshair hitmarker color", Menu.ColorEdit(
                    "-> Visuals", "All indicators", "Crosshair hitmarker color", Color.RGBA(255, 255, 255, 255)
                ), function()
                    return self.handler.elements["Enable indicator list"]
                    and bit.band(self.handler.elements["Indicator list"], bit.lshift(1, 6)) ~= 0
                end)

                self:add_element("Hitmarker mode", Menu.Combo("-> Visuals", "All indicators", "Hitmarker mode", {"+", "x"}, 0),
                function()
                    return self.handler.elements["Enable indicator list"]
                    and bit.band(self.handler.elements["Indicator list"], bit.lshift(1, 8)) ~= 0
                end)
              
                self:add_element("Hitmarker color", Menu.ColorEdit("-> Visuals", "All indicators", "Hitmarker color", Color.RGBA(
                    255, 255, 255, 255
                )), function()
                    return self.handler.elements["Enable indicator list"]
                    and bit.band(self.handler.elements["Indicator list"], bit.lshift(1, 8)) ~= 0
                end)
              
                self:add_element("Hitmarker size", Menu.SliderInt("-> Visuals", "All indicators", "Hitmarker size", 1, 4, 10),
                function()
                    return self.handler.elements["Enable indicator list"]
                    and bit.band(self.handler.elements["Indicator list"], bit.lshift(1, 8)) ~= 0
                end)

                -- @note: strexxter: keybinds & watermark stuff
                self:add_element("Enable keybinds", Menu.Switch("-> Visuals", "Solus UI Elements", "Enable keybinds", false))
                self:add_element("Keybinds color", Menu.ColorEdit(
                    "-> Visuals", "Solus UI Elements", "Keybinds color", Color.RGBA(255, 255, 255, 255)
                ), function()
                    return self.handler.elements["Enable keybinds"]
                end)

                self:add_element("Keybinds x-adding", Menu.SliderInt(
                    "-> Visuals", "Solus UI Elements", "Keybinds x-adding", 325, 0, EngineClient.GetScreenSize().x)
                )

                self:add_element("Keybinds y-adding", Menu.SliderInt(
                    "-> Visuals", "Solus UI Elements", "Keybinds y-adding", 325, 0, EngineClient.GetScreenSize().y)
                )

                self:add_element("Enable watermark", Menu.Switch("-> Visuals", "Solus UI Elements", "Enable watermark", false))
                self:add_element("Watermark color", Menu.ColorEdit(
                    "-> Visuals", "Solus UI Elements", "Watermark color", Color.RGBA(255, 255, 255, 255)
                ), function()
                    return self.handler.elements["Enable watermark"]
                end)

                self:add_element("Watermark x-adding", Menu.SliderInt(
                    "-> Visuals", "Solus UI Elements", "Watermark x-adding", 1060, 0, EngineClient.GetScreenSize().x)
                )

                self:add_element("Watermark y-adding", Menu.SliderInt(
                    "-> Visuals", "Solus UI Elements", "Watermark y-adding", 30, 0, EngineClient.GetScreenSize().y)
                )

                self.handler.references["Keybinds x-adding"].reference:SetVisible(false)
                self.handler.references["Keybinds y-adding"].reference:SetVisible(false)
                self.handler.references["Watermark x-adding"].reference:SetVisible(false)
                self.handler.references["Watermark y-adding"].reference:SetVisible(false)

                self:add_element("Enable peek arrows", Menu.SwitchColor("-> Visuals", "Arrows Elements", "Enable peek arrows", false, Color.RGBA(255, 255, 255, 255)))
                self:add_element("Enable weapons in scope", Menu.Switch("-> Visuals", "Other Indicators", "Enable weapons in scope", false))
                self:add_element("Enable custom scope", Menu.SwitchColor("-> Visuals", "Other Indicators", "Enable custom scope", false, Color.RGBA(255, 255, 255, 255)))

                local custom_scope_elements = {"Initial position", "Offset"}
                for index = 1, #custom_scope_elements do
                    local current_element = custom_scope_elements[index]
                    local functions = {Menu.SliderInt, Menu.SliderInt}
                    local sub_functions = {
                        {200, 0, 400}, {15, 0, 1000}
                    }

                    local callbacks = ("Custom scope %s"):format(current_element:lower())
                    self:add_element(callbacks, functions[index]("-> Visuals", "Other Indicators", current_element, unpack(sub_functions[index])), function()
                        return self.handler.elements["Enable custom scope"]
                    end)
                end

            -- @note: strexxter: miscellaneous tab
                -- @note: strexxter: default miscellaneous elements
                self:add_element("Enable hitlogs", Menu.Switch("-> Miscellaneous", "Hitlogging information", "Enable hitlogs", false))
                self:add_element("Enable trashtalk", Menu.Switch("-> Miscellaneous", "Other functions", "Enable trashtalk", false))

                self:add_element("Enable hitsounds", Menu.Switch("-> Miscellaneous", "Other functions", "Enable hitsounds", false))
                self:add_element("Hitsound", Menu.TextBox("-> Miscellaneous", "Other functions", "Select your hitsound:", 64, "format.wav"), function()
                    return self.handler.elements["Enable hitsounds"]
                end)

                self:add_element("Hitsound text", Menu.Text("-> Miscellaneous", "Other functions", "Directory: csgo/sound/your_file.wav"), function()
                    return self.handler.elements["Enable hitsounds"]
                end)

                self:add_element("Enable anim breakers", Menu.Switch("-> Miscellaneous", "Animation breaker", "Enable animation breakers", false))
                self:add_element("Anim breakers", Menu.MultiCombo("-> Miscellaneous", "Animation breaker", "Animation breakers", {
                    "Static legs in air", "Break leg animation", "Pitch 0 on land"
                }, 0), function()
                    return self.handler.elements["Enable anim breakers"]
                end)

                self:add_element("Static legs timer", Menu.SliderFloat("-> Miscellaneous", "Animation breaker", "Static legs timer", 0.5, 0, 1), function()
                    return self.handler.elements["Enable anim breakers"]
                    and bit.band(self.handler.elements["Anim breakers"], bit.lshift(1, 0)) ~= 0
                end)

                self:add_element("Leg fucker type", Menu.Combo("-> Miscellaneous", "Animation breaker", "Leg breaker modes", {"Static", "Jitter"}, 0), function()
                    return self.handler.elements["Enable anim breakers"]
                    and bit.band(self.handler.elements["Anim breakers"], bit.lshift(1, 1)) ~= 0
                end)

                local coded_value = {}
                local extract = function(v, from, width)
                    return bit.band(bit.rshift(v, from), bit.lshift(1, width) - 1)
                end

                local function make_encoder(alphabet)
                    local encoder = {}
                    local decoder = {}

                    for i = 1, 65 do
                        local chr = string.byte(string.sub(alphabet, i, i)) or 32

                        if decoder[chr] ~= nil then
                            print("[Half-life debugger] Invalid alphabet: duplicate character " .. tostring(chr), 3)
                        end

                        encoder[i - 1] = chr
                        decoder[chr] = i - 1
                    end

                    return encoder, decoder
                end

                local encoders, decoders = {}, {}
                local base64url = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
                encoders["base64url"], decoders["base64url"] = make_encoder(base64url)

                local alphabet_mt = {
                    __index = function(tbl, key)
                        if type(key) == "string" and key:len() == 64 or key:len() == 65 then
                            encoders[key], decoders[key] = make_encoder(key)
                            return tbl[key]
                        end
                    end
                }

                setmetatable(encoders, alphabet_mt)
                setmetatable(decoders, alphabet_mt)

                function coded_value.encode(str, encoder)
                    encoder = encoders[encoder or "base64"] or print(
                        "[Half-life debugger] Invalid alphabet specified: 2"
                    )

                    str = tostring(str)
                    local t, k, n = {}, 1, #str
                    local lastn = n % 3
                    local cache = {}

                    for i = 1, n - lastn, 3 do
                        local a, b, c = string.byte(str, i, i + 2)
                        local v = a * 0x10000 + b * 0x100 + c
                        local s = cache[v]

                        if not s then
                            s = string.char(
                                encoder[extract(v, 18, 6)],
                                encoder[extract(v, 12, 6)],
                                encoder[extract(v, 6, 6)],
                                encoder[extract(v, 0, 6)]
                            )

                            cache[v] = s
                        end

                        t[k] = s
                        k = k + 1
                    end

                    if lastn == 2 then
                        local a, b = string.byte(str, n - 1, n)
                        local v = a * 0x10000 + b * 0x100

                        t[k] = string.char(
                            encoder[extract(v, 18, 6)],
                            encoder[extract(v, 12, 6)],
                            encoder[extract(v, 6, 6)],
                            encoder[64]
                        )
                    elseif lastn == 1 then
                        local v = string.byte(str, n) * 0x10000
                        t[k] = string.char(
                            encoder[extract(v, 18, 6)],
                            encoder[extract(v, 12, 6)],
                            encoder[64],
                            encoder[64]
                        )
                    end

                    return table.concat(t)
                end

                function coded_value.decode(b64, decoder)
                    decoder = decoders[decoder or "base64"] or print(
                        "[Half-life debugger] Invalid alphabet specified: 2"
                    )

                    local pattern = "[^%w%+%/%=]"
                    if decoder then
                        local s62, s63
                        for charcode, b64code in pairs(decoder) do
                            if b64code == 62 then
                                s62 = charcode
                            elseif b64code == 63 then
                                s63 = charcode
                            end
                        end

                        pattern = string.format("[^%%w%%%s%%%s%%=]", string.char(s62), string.char(s63))
                    end

                    b64 = string.gsub(tostring(b64), pattern, "")
                    local cache = {}
                    local t, k = {}, 1
                    local n = #b64
                    local padding = string.sub(b64, -2) == "==" and 2 or string.sub(b64, -1) == "=" and 1 or 0

                    for i = 1, padding > 0 and n - 4 or n, 4 do
                        local a, b, c, d = string.byte(b64, i, i + 3)

                        if not d then
                            d = string.byte(b64, i, i + 3)
                        end

                        if not c then
                            c = string.byte(b64, i, i + 3)
                        end

                        if not b then
                            c = string.byte(b64, i, i + 3)
                        end

                        if not a then
                            c = string.byte(b64, i, i + 3)
                        end

                        if not a or not b or not c or not d then
                            print("[Half-life debugger] Wrong clipboard data!")
                            return
                        end

                        local v0 = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
                        local s = cache[v0]

                        if not s then
                            if not decoder[a] or not decoder[b] or not decoder[c] or not decoder[d] then
                                print("[Half-life debugger] Wrong clipboard data!")
                                return
                            end

                            local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
                            s = string.char(
                                extract(v, 16, 8),
                                extract(v, 8, 8),
                                extract(v, 0, 8)
                            )

                            cache[v0] = s
                        end

                        t[k] = s
                        k = k + 1
                    end

                    if padding == 1 then
                        local a, b, c = string.byte(b64, n - 3, n - 1)
                        local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40
                      
                        t[k] = string.char(
                            extract(v, 16, 8),
                            extract(v, 8, 8)
                        )
                    elseif padding == 2 then
                        local a, b = string.byte(b64, n - 3, n - 2)
                        local v = decoder[a] * 0x40000 + decoder[b] * 0x1000

                        t[k] = string.char(
                            extract(v, 16, 8)
                        )
                    end
                  
                    return table.concat(t)
                end

                local copy_proccess = function()
                    set_clipboard_text("")
  
                    local to_copy = {
                        "Enable dormant aimbot", "Dormant aimbot minimum damage",
                        "Enable anti-aimbotting", "Anti-aimbotting presets",
                        "Enable anti-aimbotting helpers", "Anti-aimbotting helpers",
                        "Enable hitlogs", "Enable trashtalk"
                    }
  
                    local custom_conditions = {"Standing", "Moving", "Ducking", "Fakeduck", "Slow Walk", "In air"}                 
                    local modes = {
                        "Yaw Add Left", "Yaw Add Right",
                        "Yaw Modifier", "Modifier Degree",
                        "Fake Limit Type", "Left Limit", "Right Limit",
                        "Fake Options", "LBY Mode", "Fake Desync", "Desync On Shot", "Inverter"
                    }
  
                    for i = 1, #custom_conditions do
                        local condition_name = custom_conditions[i]
                        for k = 1, #modes do
                            local mode_name = modes[k]
                            local end_name = ("%s %s"):format(condition_name, mode_name)
  
                            table.insert(to_copy, end_name)
                        end
                    end

                    local count = "Phase slider"
                    table.insert(to_copy, count)

                    for i = 1, self.handler.elements[count] do
                        local phases_name = ("Phase #%s"):format(i)
                        table.insert(to_copy, phases_name)
                    end

                    local copied_data = {}
                    for i = 1, #to_copy do
                        local directory = self.handler.elements
                        local name = to_copy[i]
  
                        local data = ("%s"):format(directory[name])
                        table.insert(copied_data, data)
                    end

                    local concate_table = table.concat(copied_data, " ")
                    local obfuscated_data = coded_value.encode(concate_table, "base64url")

                    if set_clipboard_text ~= nil then
                        set_clipboard_text(obfuscated_data)
                    end
  
                    copied_data = {}
                end

                local import_proccess = function()
                    local exported_text = get_clipboard_text()
                    if not exported_text then
                        print("[Half-life debug] No text copied to clipboard!")
                        return
                    end
  
                    local function split_string(s, delimiter)
                        local result = {}
                        for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
                            table.insert(result, match)
                        end
  
                        return result
                    end

                    local deobfuscated_data = coded_value.decode(exported_text, "base64url")
                    if deobfuscated_data ~= nil then
                        local split_string = split_string(deobfuscated_data, " ")
                        local exported = {}

                        for i = 1, #split_string do
                            table.insert(exported, split_string[i])
                        end

                        local to_paste = {
                            "Enable dormant aimbot", "Dormant aimbot minimum damage",
                            "Enable anti-aimbotting", "Anti-aimbotting presets",
                            "Enable anti-aimbotting helpers", "Anti-aimbotting helpers",
                            "Enable hitlogs", "Enable trashtalk"
                        }
      
                        local custom_conditions = {"Standing", "Moving", "Ducking", "Fakeduck", "Slow Walk", "In air"}                 
                        local modes = {
                            "Yaw Add Left", "Yaw Add Right",
                            "Yaw Modifier", "Modifier Degree",
                            "Fake Limit Type", "Left Limit", "Right Limit",
                            "Fake Options", "LBY Mode", "Fake Desync", "Desync On Shot", "Inverter"
                        }
      
                        for i = 1, #custom_conditions do
                            local condition_name = custom_conditions[i]
                            for k = 1, #modes do
                                local mode_name = modes[k]
                                local end_name = ("%s %s"):format(condition_name, mode_name)
  
                                table.insert(to_paste, end_name)
                            end
                        end

                        local update_anti_bruteforce_phases = function()
                            local remove_phases = function()
                                local length = #self.phases_vars.phases
                                if length == 0 then return end
              
                                for i = 1, length do
                                    local remove_name = ("Phase #%s"):format(i)
                                    local directory = self.handler.references[remove_name].reference
                  
                                    Menu.DestroyItem(directory)
                                    self.phases_vars.count = 0
                  
                                    local remove_key = function(table, key)
                                        local element = table[key]
                                        table[key] = nil
                                        return element
                                    end
                  
                                    table.remove(self.phases_vars.phases)
                                    self:set_value("Phase slider", 0)

                                    remove_key(self.handler.elements, remove_name)
                                    remove_key(self.handler.references, remove_name)
                                end
                            end
  
                            local add_phases = function()
                                if tonumber(exported[81]) ~= nil then
                                    for i = 1, exported[81] do
                                        local data = exported[i + 82]
                                        data = tonumber(data)
                                        if not data then data = 60 end

                                        self.phases_vars.count = self.phases_vars.count + 1
                                        table.insert(self.phases_vars.phases, self.phases_vars.count)

                                        local callbacks = ("Phase #%s"):format(self.phases_vars.count)
                                        local name = ("Phase #%s"):format(self.phases_vars.count)

                                        self:add_element(callbacks, Menu.SliderInt(
                                            "-> Anti-aimbotting", "Anti-bruteforce manager", name, data or 60, -60, 60
                                        ), function()
                                            return self.handler.elements["Enable anti-aimbotting helpers"]
                                            and bit.band(self.handler.elements["Anti-aimbotting helpers"], bit.lshift(1, 0)) ~= 0
                                        end)

                                        self:set_value("Phase slider", self.phases_vars.count)
                                    end
                                end
                            end
  
                            remove_phases()
                            add_phases()
                        end

                        for i = 1, 80 do
                            local names = to_paste[i]
                            local data = exported[i]

                            if data == "true" then
                                data = true
                            elseif data == "false" then
                                data = false
                            else
                                data = tonumber(data)
                            end

                            if data ~= nil then
                                self:set_value(names, data)
                            end
                        end
                      
                        update_anti_bruteforce_phases()
                        exported = {}
                    end
                end

                self.handler.references["Copy config"].reference:RegisterCallback(copy_proccess)
                self.handler.references["Import config"].reference:RegisterCallback(import_proccess)
            -- @note: strexxter: the end of all menu elements
        end,

        register_callbacks = function(self)
            self:all_elements()
        end
    }

    menu_database:register_callbacks()
    -- @endregion

    -- @region: all math & vector & other operations.
    function C_BaseEntity:GetVelocity()
        local first_velocity = self:GetProp("m_vecVelocity[0]")
        local second_velocity = self:GetProp("m_vecVelocity[1]")

        local speed = math.floor(math.sqrt(first_velocity * first_velocity + second_velocity * second_velocity))
        return speed
    end

    function C_BaseEntity:GetState()
        local flags = self:GetProp("m_fFlags")
        local velocity = self:GetVelocity()

        if bit.band(flags, 1) == 1 then
            if Menu.FindVar("Aimbot", "Anti Aim", "Misc", "Fake Duck"):GetBool() then
                return "FAKEDUCKING"
            else
                if bit.band(flags, 4) == 4 then
                    if self:GetProp("m_iTeamNum") == 2 then
                        return "CROUCHING T"
                    elseif self:GetProp("m_iTeamNum") == 3 then
                        return "CROUCHING CT"
                    end
                else
                    if Menu.FindVar("Aimbot", "Anti Aim", "Misc", "Slow Walk"):GetBool() then
                        return "SLOWWALKING"
                    else
                        if velocity <= 3 then
                            return "STANDING"
                        else
                            return "MOVING"
                        end
                    end
                end
            end
        elseif bit.band(flags, 1) == 0 then
            return "IN AIR"
        end
    end

    local all_utils = {
        normalize_yaw = function(yaw)
            while yaw > 180 do yaw = yaw - 360 end
            while yaw < -180 do yaw = yaw + 360 end
            return yaw
        end,

        update_enemies = function(self)
            local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
            if not localplayer then return end
          
            local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
            if not my_index then return end

            if EngineClient.IsConnected() and my_index:IsAlive() then
                local players = EntityList.GetEntitiesByName("CCSPlayer")
                local fov_enemy, maximum_fov = nil, 180
              
                for i = 1, #players do
                    local enemy = players[i]:GetPlayer()
                    if enemy ~= my_index and not enemy:IsTeamMate() and enemy:IsAlive() then
                        local my_origin = my_index:GetRenderOrigin()
                        local enemy_origin = enemy:GetRenderOrigin()

                        local world_to_screen = (
                            my_origin.x - enemy_origin.x == 0 and my_origin.y - enemy_origin.z == 0
                        ) and 0 or math.deg(
                            math.atan2(
                                my_origin.y - enemy_origin.y, my_origin.x - enemy_origin.x
                            )
                        ) - EngineClient.GetViewAngles().yaw + 180

                        local calculated_fov = math.abs(self.normalize_yaw(world_to_screen))
                        if not fov_enemy or calculated_fov <= maximum_fov then
                            fov_enemy = enemy
                            maximum_fov = calculated_fov
                        end
                    end
                end

                return ({
                    enemy = fov_enemy,
                    fov = maximum_fov
                })
            end
        end,

        calculate_angles = function(self, local_x, local_y, enemy_x, enemy_y)
            local delta_y = local_y - enemy_y
            local delta_x = local_x - enemy_x

            local relative_yaw = math.atan(delta_y / delta_x)
            relative_yaw = self.normalize_yaw(relative_yaw * 180 / math.pi)

            if delta_x >= 0 then
                relative_yaw = self.normalize_yaw(relative_yaw + 180)
            end
          
            return relative_yaw
        end,

        angle_to_vec = function(pitch, yaw)
            local p = pitch / 180 * math.pi
            local y = yaw / 180 * math.pi

            local sin_p = math.sin(p)
            local cos_p = math.cos(p)
            local sin_y = math.sin(y)
            local cos_y = math.cos(y)

            return {
                cos_p * cos_y,
                cos_p * sin_y,
                -sin_p
            }
        end,

        easings = {
            lerp = function(start, vend, time)
                return start + (vend - start) * time
            end,

            clamp = function(val, min, max)
                if val > max then return max end
                if min > val then return min end
                return val
            end
        },

        get_hit_side = function(self)
            if menu_database.handler.elements["Enable indicator list"] then
                if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 0)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end

                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local data, current_enemy = self:update_enemies(), nil
                        if data ~= nil then
                            current_enemy = data.enemy
                        end
                      
                        if current_enemy ~= nil and current_enemy:IsAlive() then
                            local predict_damage = function(x, y, z)
                                local a, b, c = {}, {}, {}
                                local enemy_head_position = current_enemy:GetHitboxCenter(1)
                                local ticks = 40

                                a[1], b[1], c[1] = enemy_head_position.x, enemy_head_position.y, enemy_head_position.z
                                a[2], b[2], c[2] = enemy_head_position.x + ticks, enemy_head_position.y, enemy_head_position.z
                                a[3], b[3], c[3] = enemy_head_position.x - ticks, enemy_head_position.y, enemy_head_position.z
                              
                                a[4], b[4], c[4] = enemy_head_position.x, enemy_head_position.y + ticks, enemy_head_position.z
                                a[5], b[5], c[5] = enemy_head_position.x, enemy_head_position.y - ticks, enemy_head_position.z
  
                                a[6], b[6], c[6] = enemy_head_position.x, enemy_head_position.y, enemy_head_position.z + ticks
                                a[7], b[7], c[7] = enemy_head_position.x, enemy_head_position.y, enemy_head_position.z - ticks

                                for i = 1, 7, 1 do
                                    local damage = 0
                                    local trace_damage = Cheat.FireBullet(
                                        current_enemy, Vector.new(a[i], b[i], c[i]), Vector.new(x, y, z)
                                    ).damage
                          
                                    if trace_damage > damage then
                                        damage = trace_damage
                                    end
                          
                                    return damage
                                end
                            end

                            local my_eye_position = my_index:GetEyePosition()
                            local enemy_head_position = current_enemy:GetHitboxCenter(0)
                            local calculated_yaw = self:calculate_angles(
                                my_eye_position.x, my_eye_position.y, enemy_head_position.x, enemy_head_position.y
                            )

                            local left_direction_x, left_direction_y = self.angle_to_vec(
                                0, (calculated_yaw + 90)
                            ), self.angle_to_vec(0, (calculated_yaw + 90))

                            local right_direction_x, right_direction_y = self.angle_to_vec(
                                0, (calculated_yaw - 90)
                            ), self.angle_to_vec(0, (calculated_yaw - 90))
                          
                            local rend_x = my_eye_position.x + right_direction_x[1] * 10
                            local rend_y = my_eye_position.y + right_direction_y[1] * 10

                            local lend_x = my_eye_position.x + left_direction_x[1] * 10
                            local lend_y = my_eye_position.y + left_direction_y[1] * 10

                            local rend_x_2 = my_eye_position.x + right_direction_x[1] * 100
                            local rend_y_2 = my_eye_position.y + left_direction_y[1] * 100

                            local lend_x_2 = my_eye_position.x + left_direction_x[1] * 100
                            local lend_y_2 = my_eye_position.y + left_direction_y[1] * 100
                          
                            local left_trace = predict_damage(rend_x, rend_y, my_eye_position.z)
                            local right_trace = predict_damage(lend_x, lend_y, my_eye_position.z)
                            local left_trace_2 = predict_damage(rend_x_2, rend_y_2, my_eye_position.z)
                            local right_trace_2 = predict_damage(lend_x_2, lend_y_2, my_eye_position.z)

                            local hit_side = (
                                (left_trace > 0 or right_trace > 0 or left_trace_2 > 0 or right_trace_2 > 0) and
                                (
                                    left_trace > right_trace and 0.5 or right_trace > left_trace and -0.5
                                    or left_trace_2 > right_trace_2 and 1 or right_trace_2 > left_trace_2 -1
                                ) or 0.0
                            )

                            return hit_side
                        end
                    end
                end
            end
        end
    }

    -- @region: all ragebot functions
    local ragebot_functions = {
        dormant_aimbot = {
            run_autostop = function(cmd, goal_speed)
                local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                if not localplayer then return end
      
                local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                if not my_index then return end

                local minspeed = math.sqrt((cmd.forwardmove * cmd.forwardmove) + (cmd.sidemove * cmd.sidemove))
                if goal_speed <= 0 or minspeed <= 0 then return end
  
                local flags = my_index:GetProp("m_fFlags")
                if bit.band(flags, 4) == 4 then
                    goal_speed = goal_speed * 2.94117647
                end
  
                if minspeed <= goal_speed then return end
                local speed_factor = goal_speed / minspeed
  
                cmd.forwardmove = cmd.forwardmove * speed_factor
                cmd.sidemove = cmd.sidemove * speed_factor
            end,

            vars = {
                player_info_prev = {},
                round_started = 0,
                is_dormant_flag = false,

                minimal_vector = Vector.new(),
                maximal_vector = Vector.new()
            },

            calculate_angles = function(source, point)
                local world_to_screen = function(x_position, y_position)
                    if x_position == 0 and y_position == 0 then return 0 end
          
                    local atan_position = math.atan2(y_position, x_position)
                    local deg_position = math.deg(atan_position)
          
                    return deg_position
                end

                local delta_of_vectors = point - source
                local hyp = math.sqrt(delta_of_vectors.x * delta_of_vectors.x + delta_of_vectors.y * delta_of_vectors.y)
      
                local yaw = world_to_screen(delta_of_vectors.x, delta_of_vectors.y)
                local pitch = world_to_screen(hyp, -delta_of_vectors.z)
      
                return Vector.new(pitch, yaw, 0)
            end,

            get_hittable_damage = function(my_index, enemy, start_point, end_point)
                if my_index ~= nil then
                    if enemy ~= nil then
                        local bullet_data = Cheat.FireBullet(my_index, start_point, end_point)
                        local bullet_damage = bullet_data.damage

                        local minimum_damage = menu_database.handler.elements["Dormant aimbot minimum damage"]
                        local enemy_health = enemy:GetProp("m_iHealth")

                        if bullet_damage < math.min(minimum_damage, enemy_health) then
                            return 0
                        end

                        if bullet_data.trace.hit_entity ~= nil then
                            if bullet_data.trace.hit_entity:EntIndex() ~= enemy:EntIndex() then
                                return 0
                            end
                        end

                        if enemy:IsVisible(end_point) then
                            return 0
                        end

                        return bullet_damage
                    end
                end
            end,

            run_work = function(self, cmd)
                if menu_database.handler.elements["Enable dormant aimbot"] then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
          
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end
          
                    local my_weapon = my_index:GetActiveWeapon()
                    if not my_weapon then return end
          
                    local weapon_id = my_weapon:GetWeaponID()
                    if not weapon_id then return end
          
                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local get_inaccuracy = my_weapon:GetInaccuracy(my_weapon)
                        local tickcount = GlobalVars.tickcount
          
                        local player_resource = EntityList.GetPlayerResource()
                        local eye_position = my_index:GetEyePosition()
          
                        local simulation_time = my_index:GetProp("m_flSimulationTime")
                        local on_ground = bit.band(my_index:GetProp("m_fFlags"), bit.lshift(1, 0)) == 1 and true or false

                        if tickcount < self.vars.round_started then
                            return
                        end

                        local primary_attack = my_weapon:GetProp("m_flNextPrimaryAttack")
                        local next_attack = my_index:GetProp("m_flNextAttack")
                        local secondary_attack = my_weapon:GetProp("m_flNextSecondaryAttack")

                        local can_shoot = false
                        if weapon_id == 64 then -- revolver
                            can_shoot = simulation_time > primary_attack
                        elseif my_weapon:IsKnife() or my_weapon:IsGrenade() or weapon_id == 31 then
                            can_shoot = false
                        else
                            can_shoot = simulation_time > math.max(next_attack, primary_attack, secondary_attack)
                        end

                        local player_info = {}
                        local players = EntityList.GetEntitiesByName("CCSPlayer")
                      
                        for i = 1, #players do
                            local enemy = players[i]:GetPlayer()
                            if enemy ~= my_index and not enemy:IsTeamMate() and enemy:IsAlive() then
                                local network_state = enemy:GetNetworkState()
                                if enemy:IsDormant() and network_state ~= -1 then
                                    local can_hit = false
                                    local origin = enemy:GetProp("m_vecOrigin")
                                    local alpha_multiplier = enemy:GetESPAlpha()

                                    if self.vars.player_info_prev[i] ~= nil and origin.x ~= 0 and alpha_multiplier > 0 then
                                        local is_dormant_accurate = alpha_multiplier > 0.2
                                        if is_dormant_accurate then
                                            local bounds = enemy:GetRenderBounds(self.vars.minimal_vector, self.vars.maximal_vector)
                                            local all_vector_points = {
                                                origin + Vector.new(0, 0, 38),
                                                origin + Vector.new(0, 0, 40),
                                                origin + Vector.new(0, 0, 42),
                                                origin + Vector.new(0, 0, 50)
                                            }

                                            local best_damage = 0
                                            local best_point = Vector.new()
                                            local my_eye_position = my_index:GetEyePosition()
                                          
                                            for point = 1, #all_vector_points do
                                                local current_point = all_vector_points[point]
                                                local start_position = self.calculate_angles(my_eye_position, current_point)
                                                local damage = self.get_hittable_damage(my_index, enemy, my_eye_position, current_point)

                                                if damage > best_damage then
                                                    best_damage = damage
                                                    best_point = start_position
                                                    can_hit = true
                                                end
                                            end

                                            local get_max_speed = my_weapon:GetMaxSpeed()
                                            if can_shoot and can_hit then
                                                self.vars.is_dormant_flag = true
                                                self.run_autostop(cmd, get_max_speed * 0.33)

                                                if get_inaccuracy < 0.009 then
                                                    cmd.viewangles.pitch = best_point.x
                                                    cmd.viewangles.yaw = best_point.y
                                                    cmd.viewangles.roll = 0.0

                                                    cmd.buttons = bit.bor(cmd.buttons, 1)
                                                    self.vars.is_dormant_flag = true

                                                    can_shoot = false
                                                end
                                            elseif not can_hit then
                                                self.vars.is_dormant_flag = false
                                            end
                                        end
                                    end
                                    player_info[i] = {origin, alpha_multiplier, can_hit}
                                end
                            end
                        end
                        self.vars.player_info_prev = player_info
                    end
                end
            end,

            reset_data = function(self, e)
                if menu_database.handler.elements["Enable dormant aimbot"] then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
          
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end
          
                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        if e:GetName() == "round_prestart" then
                            local mp_freezetime = CVar.FindVar("mp_freezetime"):GetFloat()
                            local ticks = GlobalVars.interval_per_tick
                  
                            local freezetime = (mp_freezetime + 1) / ticks
                            local tickcount = GlobalVars.tickcount
                  
                            self.vars.round_started = tickcount + freezetime
                        end
                    end
                end
            end
        },

        doubletap_speed = function()
            if menu_database.handler.elements["Enable custom DT speed"] then
                local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                if not localplayer then return end
      
                local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                if not my_index then return end
      
                local active_weapon = my_index:GetActiveWeapon()
                if not active_weapon then return end
      
                if EngineClient.IsConnected() and my_index:IsAlive() then
                    local speed = menu_database.handler.elements["Custom DT speed"]
                    Exploits.OverrideDoubleTapSpeed(speed)
                end
            end
        end,

        load_ragebot_functions = function(self, cmd)
            self.dormant_aimbot:run_work(cmd)
            self:doubletap_speed()
        end
    }

    ESP.CustomText("Dormant aimbot status", "enemies", "DA", function(ent)
        if ragebot_functions.dormant_aimbot.vars.is_dormant_flag then
            return "DA"
        else
            return false
        end
    end)

    ESP.CustomText("Resolver state", "enemies", "Resolver state", function(ent)
        local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
        if not localplayer then return end
      
        local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
        if not my_index then return end

        local enemy = ent:GetPlayer()
        local current_text = ""

        if not enemy:IsDormant() then
            local my_position_in_world = my_index:GetProp("m_vecOrigin")
            local enemy_eye_position = enemy:GetEyePosition()

            local delta_of_vectors = my_position_in_world - enemy_eye_position
            local reverse_vector_to_angle = Cheat.VectorToAngle(delta_of_vectors)
            local trace_data = {
                left = 0,
                right = 0
            }

            for i = reverse_vector_to_angle.yaw - 90, reverse_vector_to_angle.yaw + 90, 25 do
                local radians = math.rad(i)
                local side = i < reverse_vector_to_angle.yaw and "left" or "right"

                local first_point = Vector.new(
                    enemy_eye_position.x + 50 * math.cos(radians),
                    enemy_eye_position.y + 50 * math.sin(radians),
                    enemy_eye_position.z
                )

                local last_point = Vector.new(
                    enemy_eye_position.x + 256 * math.cos(radians),
                    enemy_eye_position.y + 256 * math.sin(radians),
                    enemy_eye_position.z
                )

                local get_traced_impact = EngineTrace.TraceRay(first_point, last_point, my_index, 0xFFFFFFFF).fraction
                trace_data[side] = trace_data[side] + get_traced_impact
            end

            local current_side = trace_data.left < trace_data.right and "left" or "right"
            local current_delta = math.floor(get_max_feet_yaw(enemy))

            local pitch = enemy:GetProp("m_angEyeAngles[0]")
            local is_legit_aa = (pitch >= 0 and pitch <= 50 or pitch >= 329 and pitch <= 360) and true or false
            local legit_aa_delta = math.floor(math.max(math.min(
                enemy:GetProp("m_angEyeAngles[1]") - current_delta,
                (enemy:GetProp("m_angEyeAngles[1]") - current_delta) / 4
            ), 0))

            if legit_aa_delta > 60 then legit_aa_delta = 60 end
            if legit_aa_delta < 0 then legit_aa_delta = 0 end

            current_text = enemy:GetPlayerInfo().fakeplayer and "DEFAULT[0.0]" or ("SIDE:%s[%s]"):format(
                current_side, is_legit_aa and legit_aa_delta or current_delta
            )
        else
            current_text = "RESETING[0.0]"
        end

        return current_text
    end)
    -- @endregion

    -- @region: all anti-aimbotting functions
    local anti_aimbotting_functions = {
        anti_bruteforce = {
            vars = {
                is_anti_bruteforcing = false,
                anti_bruteforcing_timer = GlobalVars.realtime,

                anti_bruteforcing_counter = 1,
                anti_bruteforcing_side = 1,

                phases_counter = 1,
                phase_state = false
            },
  
            run_work = function(self, e)
                if menu_database.handler.elements["Enable anti-aimbotting helpers"] then
                    local directory = menu_database.handler.elements["Anti-aimbotting helpers"]
                    if bit.band(directory, bit.lshift(1, 0)) ~= 0 then
                        local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                        if not localplayer then return end
                      
                        local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                        if not my_index then return end
      
                        if EngineClient.IsConnected() and my_index:IsAlive() then
                            if e:GetName() ~= "bullet_impact" then return end
              
                            local my_index = EntityList.GetLocalPlayer()
                            local attacker = EntityList.GetPlayerForUserID(e:GetInt("userid"))
              
                            if attacker == my_index or attacker:IsTeamMate() then
                                return
                            end
              
                            local my_head_position = my_index:GetHitboxCenter(0)
                            local bullet_vector = Vector.new(e:GetInt("x"), e:GetInt("y"), e:GetInt("z"))
              
                            local my_origin = my_index:GetRenderOrigin()
                            local attacker_origin = attacker:GetRenderOrigin()
              
                            local check_for_unhittable_wall = Cheat.FireBullet(attacker, bullet_vector, my_head_position)
                            if check_for_unhittable_wall.damage < 5 then return end
              
                            local point_between_my_head_and_origin = {my_head_position.x - attacker_origin.x, my_head_position.y - attacker_origin.y}
                            local point_between_bullet_and_origin = {bullet_vector.x - attacker_origin.x, bullet_vector.y - attacker_origin.y}
              
                            local decrease_bullet_points = point_between_bullet_and_origin[1] ^ 2 + point_between_bullet_and_origin[2] ^ 2
                            local create_dot_points = (
                                point_between_my_head_and_origin[1] * point_between_bullet_and_origin[1] +
                                point_between_my_head_and_origin[2] * point_between_bullet_and_origin[2]
                            )
              
                            local final_dots = create_dot_points / decrease_bullet_points
                            local final_distance = {
                                attacker_origin.x + point_between_bullet_and_origin[1] * final_dots,
                                attacker_origin.y + point_between_bullet_and_origin[2] * final_dots
                            }
              
                            local my_delta_value = {my_head_position.x - final_distance[1], my_head_position.y - final_distance[2]}
                            local my_delta_to_world = math.abs(math.sqrt(my_delta_value[1] ^ 2 + my_delta_value[2] ^ 2))
              
                            local minimum_distance_to_trigger = my_origin:DistTo(attacker_origin) / 4
                            if my_delta_to_world <= minimum_distance_to_trigger then
                                self.vars.is_anti_bruteforcing = true
                                self.vars.phase_state = true
                              
                                self.vars.anti_bruteforcing_side = self.vars.anti_bruteforcing_side * -1
                                self.vars.anti_bruteforcing_counter = self.vars.anti_bruteforcing_counter + 1

                                if self.vars.anti_bruteforcing_counter > 10 then
                                    self.vars.anti_bruteforcing_counter = 1
                                end

                                self.vars.phases_counter = self.vars.phases_counter + 1
                                if self.vars.phases_counter > #menu_database.phases_vars.phases then
                                    self.vars.phases_counter = 1
                                end
                            else
                                self.vars.is_anti_bruteforcing = false
                            end
                        end
                    else
                        self.vars.is_anti_bruteforcing = false
                    end
                else
                    self.vars.is_anti_bruteforcing = false
                end
            end
        },
      
        run_main_anti_aim = function(self)
            if menu_database.handler.elements["Enable anti-aimbotting"] then
                local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                if not localplayer then return end
              
                local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                if not my_index then return end

                if EngineClient.IsConnected() and my_index:IsAlive() then
                    if not self.anti_bruteforce.vars.is_anti_bruteforcing then
                        local current_state = my_index:GetState()
                        local current_preset = menu_database.handler.elements["Anti-aimbotting presets"]

                        local set_values = function()
                            local set_anti_aim = function(table)
                                Menu.FindVar("Aimbot", "Anti Aim", "Main", "Yaw Add"):SetInt(table[1])
                                Menu.FindVar("Aimbot", "Anti Aim", "Main", "Yaw Modifier"):SetInt(table[2])
                                Menu.FindVar("Aimbot", "Anti Aim", "Main", "Modifier Degree"):SetInt(table[3])

                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Left Limit"):SetInt(table[4])
                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Right Limit"):SetInt(table[5])

                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Fake Options"):SetInt(table[6])
                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "LBY Mode"):SetInt(table[7])
                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Freestanding Desync"):SetInt(table[8])
                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Desync On Shot"):SetInt(table[9])
                            end

                            local all_settings = {
                                [0] = {
                                    ["STANDING"] = {GlobalVars.tickcount % 4 == 1 and -15 or 17, 1, 39, 0, 0, 2, 1, 0, 1},
                                    ["MOVING"] = {GlobalVars.tickcount % 4 == 1 and 16 or -11, 1, 52, 0, 0, 2, 1, 0, 1},

                                    ["CROUCHING T"] = {GlobalVars.tickcount % 4 == 1 and 2 or 11, 1, 39, 0, 0, 2, 0, 0, 1},
                                    ["CROUCHING CT"] = {GlobalVars.tickcount % 4 == 1 and 2 or 11, 1, 39, 0, 0, 2, 0, 0, 1},

                                    ["FAKEDUCKING"] = {0, 0, 0, 60, 60, 0, 0, 0, 0},
                                    ["SLOWWALKING"] = {GlobalVars.tickcount % 4 == 1 and -11 or 11, 1, 50, 0, 0, 2, 1, 0, 1},
                                    ["IN AIR"] = {GlobalVars.tickcount % 4 == 1 and 2 or -2, 1, 10, 0, 0, 2, 0, 0, 2},
                                },

                                [1] = {
                                    ["STANDING"] = {0, 0, 0, 56, 56, 0, 0, 1, 0},
                                    ["MOVING"] = {0, 0, 0, 56, 56, 0, 0, 1, 0},

                                    ["CROUCHING T"] = {0, 0, 0, 56, 56, 0, 0, 1, 0},
                                    ["CROUCHING CT"] = {0, 1, 25, 40, 40, 6, 0, 0, 0},

                                    ["FAKEDUCKING"] = {0, 0, 0, 56, 56, 0, 0, 0, 0},
                                    ["SLOWWALKING"] = {0, 0, 0, 56, 56, 0, 0, 1, 0},
                                    ["IN AIR"] = {0, 1, 65, 56, 56, 2, 0, 0, 0}
                                },

                                [2] = {
                                    ["STANDING"] = {7, 1, 77, 60, 60, 2, 1, 0, 1},
                                    ["MOVING"] = {7, 1, 77, 60, 60, 2, 1, 0, 1},

                                    ["CROUCHING T"] = {7, 1, 77, 60, 60, 2, 1, 0, 1},
                                    ["CROUCHING CT"] = {7, 1, 77, 60, 60, 2, 1, 0, 1},

                                    ["FAKEDUCKING"] = {7, 1, 77, 60, 60, 2, 1, 0, 1},
                                    ["SLOWWALKING"] = {7, 1, 77, 60, 60, 2, 1, 0, 1},
                                    ["IN AIR"] = {7, 1, 77, 60, 60, 2, 1, 0, 1}
                                },

                                [3] = {
                                    ["STANDING"] = {0, 1, 57, 18, 18, 2, 1, 0, 0},
                                    ["MOVING"] = {0, 1, 57, 18, 18, 2, 1, 0, 0},

                                    ["CROUCHING T"] = {0, 1, 57, 18, 18, 2, 1, 0, 0},
                                    ["CROUCHING CT"] = {0, 1, 57, 18, 18, 2, 1, 0, 0},

                                    ["FAKEDUCKING"] = {0, 0, 0, 60, 60, 0, 0, 0, 0},
                                    ["SLOWWALKING"] = {0, 1, 57, 18, 21, 2, 1, 0, 0},
                                    ["IN AIR"] = {0, 1, 57, 18, 18, 2, 1, 0, 0},
                                }
                            }

                            local current_settings = all_settings[current_preset][current_state]
                            local flags = my_index:GetProp("m_fFlags")

                            if current_preset ~= 4 then
                                if Cheat.IsMenuVisible() then
                                    set_anti_aim({0, 0, 0, 0, 0, 0, 0, 0, 0})
                                else
                                    set_anti_aim(current_settings)
                                end
                            end
                        end

                        if current_preset == 4 then
                            local set_custom_anti_aim = function(state)
                                local get_state = function(base)
                                    return menu_database.handler.elements[("%s %s"):format(state, base)]
                                end

                                Menu.FindVar("Aimbot", "Anti Aim", "Main", "Yaw Add"):SetInt(
                                    GlobalVars.tickcount % 4 >= 2 and get_state("Yaw Add Left") or get_state("Yaw Add Right")
                                )

                                Menu.FindVar("Aimbot", "Anti Aim", "Main", "Yaw Modifier"):SetInt(get_state("Yaw Modifier"))
                                Menu.FindVar("Aimbot", "Anti Aim", "Main", "Modifier Degree"):SetInt(get_state("Modifier Degree"))

                                local fake_type = get_state("Fake Limit Type")
                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Left Limit"):SetInt(
                                    fake_type == 0 and get_state("Left Limit") or (
                                        GlobalVars.tickcount % 4 >= 2 and 18 or get_state("Left Limit")
                                    )
                                )

                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Right Limit"):SetInt(
                                    fake_type == 0 and get_state("Right Limit") or (
                                        GlobalVars.tickcount % 4 >= 2 and 18 or get_state("Right Limit")
                                    )
                                )
          
                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Fake Options"):SetInt(get_state("Fake Options"))
                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "LBY Mode"):SetInt(get_state("LBY Mode"))
                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Freestanding Desync"):SetInt(get_state("Fake Desync"))
                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Desync On Shot"):SetInt(get_state("Desync On Shot"))
                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Inverter"):SetBool(get_state("Inverter"))
                            end

                            if current_state == "STANDING" then set_custom_anti_aim("Standing")
                            elseif current_state == "MOVING" then set_custom_anti_aim("Moving")
                            elseif current_state == "FAKEDUCKING" then set_custom_anti_aim("Fakeduck")
                            elseif (
                                current_state == "CROUCHING T" or current_state == "CROUCHING CT"
                            ) then set_custom_anti_aim("Ducking")
                            elseif current_state == "SLOWWALKING" then set_custom_anti_aim("Slow Walk")
                            elseif current_state == "IN AIR" then set_custom_anti_aim("In air")
                            end
                        else
                            set_values()
                        end
                    end
                end
            end

            if menu_database.handler.elements["Enable anti-aimbotting helpers"] then
                local directory = menu_database.handler.elements["Anti-aimbotting helpers"]
                if bit.band(directory, bit.lshift(1, 0)) ~= 0 then
                    if self.anti_bruteforce.vars.is_anti_bruteforcing then
                        local ab_counter = self.anti_bruteforce.vars.phases_counter
                        if ab_counter ~= 0 then
                            local get_path = ("Phase #%s"):format(ab_counter)
                            if not get_path then
                                self.anti_bruteforce.vars.is_anti_bruteforcing = false
                                self.anti_bruteforce.vars.anti_bruteforcing_timer = GlobalVars.realtime
                                return
                            end

                            local get_value = menu_database.handler.elements[get_path]
                            if not get_value then
                                self.anti_bruteforce.vars.is_anti_bruteforcing = false
                                self.anti_bruteforce.vars.anti_bruteforcing_timer = GlobalVars.realtime
                                return
                            end

                            local get_side = get_value < 0 and false or true
                            if not get_side then
                                self.anti_bruteforce.vars.is_anti_bruteforcing = false
                                self.anti_bruteforce.vars.anti_bruteforcing_timer = GlobalVars.realtime
                                return
                            end

                            AntiAim.OverrideInverter(get_side)
                            AntiAim.OverrideLimit(get_value)
                        end

                        if self.anti_bruteforce.vars.anti_bruteforcing_timer + 3 < GlobalVars.realtime then
                            self.anti_bruteforce.vars.is_anti_bruteforcing = false
                            self.anti_bruteforce.vars.anti_bruteforcing_timer = GlobalVars.realtime
                        end
                    end
                end
            end
        end,

        break_lagcomp_in_air = function()
            if menu_database.handler.elements["Enable anti-aimbotting helpers"] then
                local directory = menu_database.handler.elements["Anti-aimbotting helpers"]
                if bit.band(directory, bit.lshift(1, 1)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end

                    local active_weapon = my_index:GetActiveWeapon()
                    if not active_weapon then return end

                    local classname = active_weapon:GetClassName()
                    if not classname then return end
  
                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local is_active = function()
                            local table = {"Default", "Pistols", "Heavy pistols", "Scout", "AWP", "Autosnipers", "Nades"}
                            for i = 1, #table do
                                local directory = menu_database.handler.elements["Breaking lagcomp weapons"]
                                if bit.band(directory, bit.lshift(1, i - 1)) ~= 0 then
                                    local current_weapon = table[i]

                                    if active_weapon:IsPistol() then
                                        if current_weapon == "Heavy pistols" and classname == "CDEagle" then
                                            return true
                                        elseif current_weapon == "Pistols" and classname ~= "CDEagle" then
                                            return true
                                        end
                                    elseif classname == "CWeaponSSG08" and current_weapon == "Scout" then
                                        return true
                                    elseif classname == "CWeaponAWP" and current_weapon == "AWP" then
                                        return true
                                    elseif (
                                        classname == "CWeaponSCAR20" or
                                        classname == "CWeaponG3SG1"
                                    ) and current_weapon == "Autosnipers" then
                                        return true
                                    elseif current_weapon == "Nades" and active_weapon:IsGrenade() then
                                        return true
                                    elseif current_weapon == "Default" and active_weapon:IsRifle() then
                                        return true
                                    end
                                end
                            end
                            return false
                        end

                        if is_active() then
                            local data, current_enemy = all_utils:update_enemies(), nil
                            if data ~= nil then
                                current_enemy = data.enemy
                            end
                          
                            if current_enemy ~= nil and current_enemy:IsAlive() then
                                if not current_enemy:IsDormant() then
                                    local isDT = Menu.FindVar("Aimbot", "Ragebot", "Exploits", "Double Tap"):GetBool()
                                    local in_air = my_index:GetState() == "IN AIR"

                                    if isDT and in_air then
                                        local enemy_origin = current_enemy:GetRenderOrigin()
                                        local my_origin = my_index:GetRenderOrigin()
                                      
                                        local traced_bullet = Cheat.FireBullet(current_enemy, enemy_origin, my_origin)
                                        if traced_bullet.damage > 0 then
                                            Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Freestanding Desync"):SetInt(1)
                                            Exploits.ForceTeleport()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end,

        anti_backstabbing = function()
            if menu_database.handler.elements["Enable anti-aimbotting helpers"] then
                local directory = menu_database.handler.elements["Anti-aimbotting helpers"]
                if bit.band(directory, bit.lshift(1, 2)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end
  
                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local data, current_enemy = all_utils:update_enemies(), nil
                        if data ~= nil then
                            current_enemy = data.enemy
                        end
                      
                        if current_enemy ~= nil and current_enemy:IsAlive() then
                            if not current_enemy:IsDormant() then
                                local my_origin = my_index:GetRenderOrigin()
                                local enemy_origin = current_enemy:GetRenderOrigin()

                                local enemy_weapon = current_enemy:GetActiveWeapon()
                                if not enemy_weapon then return end

                                local our_distance = my_origin:DistTo(enemy_origin)
                                local minimum_distance = 200

                                if enemy_weapon:IsKnife() then
                                    if our_distance <= minimum_distance then
                                        AntiAim.OverrideYawOffset(180)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end,

        bombsite_fix = {
            vars = {
                is_in_bombsite = false
            },

            check_bombsite = function(self, e)
                if menu_database.handler.elements["Enable anti-aimbotting helpers"] then
                    local directory = menu_database.handler.elements["Anti-aimbotting helpers"]
                    if bit.band(directory, bit.lshift(1, 3)) ~= 0 then
                        local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                        if not localplayer then return end
                      
                        local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                        if not my_index then return end
      
                        if EngineClient.IsConnected() and my_index:IsAlive() then
                            if e:GetName() == "enter_bombzone" then
                                local user_id = EntityList.GetPlayerForUserID(e:GetInt("userid"))
                                if user_id == my_index then
                                    self.vars.is_in_bombsite = true
                                end
                            end

                            if e:GetName() == "exit_bombzone" then
                                local user_id = EntityList.GetPlayerForUserID(e:GetInt("userid"))
                                if user_id == my_index then
                                    self.vars.is_in_bombsite = false
                                end
                            end
                        end
                    else
                        self.vars.is_in_bombsite = false
                    end
                else
                    self.vars.is_in_bombsite = false
                end
            end,
          
            run_work = function(self, cmd)
                if menu_database.handler.elements["Enable anti-aimbotting helpers"] then
                    local directory = menu_database.handler.elements["Anti-aimbotting helpers"]
                    if bit.band(directory, bit.lshift(1, 3)) ~= 0 then
                        local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                        if not localplayer then return end
                      
                        local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                        if not my_index then return end
      
                        if EngineClient.IsConnected() and my_index:IsAlive() then
                            if my_index:GetProp("m_iTeamNum") == 2 then
                                local is_near_with_door = function()
                                    for yaw = 18, 360, 18 do
                                        yaw = all_utils.normalize_yaw(yaw)
                                      
                                        local my_eye_position = my_index:GetEyePosition()
                                        local final_angle = QAngle.new(0, yaw, 0)

                                        local final_point = my_eye_position + Cheat.AngleToForward(final_angle) * 0x60
                                        local trace_info = EngineTrace.TraceRay(my_eye_position, final_point, my_index, 0x200400B)
                                        local hit_entity = trace_info.hit_entity

                                        if hit_entity ~= nil then
                                            if trace_info.hit_entity:GetClassName() == "CPropDoorRotating" then
                                                return true
                                            end
                                        end
                                    end
                                    return false
                                end

                                if not is_near_with_door() then
                                    if self.vars.is_in_bombsite then
                                        if bit.band(cmd.buttons, 32) == 32 then
                                            AntiAim.OverrideYawOffset(180)
                                            AntiAim.OverridePitch(0)

                                            cmd.buttons = bit.band(cmd.buttons, bit.bnot(32))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        },

        quick_peek = function(cmd)
            if menu_database.handler.elements["Enable indicator list"] then
                if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 3)) ~= 0 then
                    if menu_database.handler.elements["Skeet autopeek type"] == 1 then
                        local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                        if not localplayer then return end
                      
                        local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                        if not my_index then return end

                        if EngineClient.IsConnected() and my_index:IsAlive() then
                            local set_movement = function(cmd, xz, yz)
                                local current_pos = my_index:GetProp("m_vecOrigin")
                                local yaw = EngineClient:GetViewAngles().yaw
  
                                local vector_forward = {
                                    x = current_pos.x - xz,
                                    y = current_pos.y - yz,
                                }
                              
                                local velocity = {
                                    x = -(vector_forward.x * math.cos(yaw / 180 * math.pi) + vector_forward.y * math.sin(
                                        yaw / 180 * math.pi)
                                    ),

                                    y = vector_forward.y * math.cos(yaw / 180 * math.pi) - vector_forward.x * math.sin(
                                        yaw / 180 * math.pi
                                    ),
                                }
  
                                cmd.forwardmove = velocity.x * 15
                                cmd.sidemove = velocity.y * 15
                            end

                            local W = bit.band(cmd.buttons, 8) == 8
                            local S = bit.band(cmd.buttons, 16) == 16
                            local D = bit.band(cmd.buttons, 512) == 512
                            local A = bit.band(cmd.buttons, 1024) == 1024
                            local moving = W or S or D or A

                            local is_peeking = Menu.FindVar("Miscellaneous", "Main", "Movement", "Auto Peek"):GetBool()
                            if not is_peeking then
                                cur_pos = my_index:GetProp("m_vecOrigin")
                            end

                            local default_origin = my_index:GetProp("m_vecOrigin")
                            local is_in_air = my_index:GetState() == "IN AIR"

                            if not is_in_air then
                                if is_peeking then
                                    if cur_pos ~= nil then
                                        if not moving and cur_pos.x ~= default_origin.x and cur_pos.y ~= default_origin.y then
                                            set_movement(cmd, cur_pos.x, cur_pos.y)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end,

        smart_yaw_position = function(self)
            if menu_database.handler.elements["Enable anti-aimbotting helpers"] then
                local directory = menu_database.handler.elements["Anti-aimbotting helpers"]
                if bit.band(directory, bit.lshift(1, 4)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end
  
                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local data, current_enemy = all_utils:update_enemies(), nil
                        if data ~= nil then
                            current_enemy = data.enemy
                        end
                      
                        if current_enemy ~= nil and current_enemy:IsAlive() then
                            local lby_fraction = math.abs(my_index:GetProp("m_flLowerBodyYawTarget") / 180)
                            local duck_amount = my_index:GetProp("m_flDuckAmount")

                            local side = all_utils:get_hit_side()
                            local yaw_path = Menu.FindVar("Aimbot", "Anti Aim", "Main", "Yaw Add")

                            if not current_enemy:IsDormant() then
                                if duck_amount > 0.4 then
                                    yaw_path:SetInt(-10)
                                else
                                    if lby_fraction > 0.5 then
                                        yaw_path:SetInt(20)
                                    else
                                        yaw_path:SetInt(-20)
                                    end
                                end
                            else
                                if duck_amount > 0.4 and not my_index:GetState(true) == "IN AIR" then
                                    yaw_path:SetInt(10)
                                else
                                    if lby_fraction > 0.5 then
                                        yaw_path:SetInt(10)
                                    else
                                        if side == 0.5 or side == -0.5 then
                                            yaw_path:SetInt(-10)
                                        elseif side == 1 or side == -1 then
                                            yaw_path:SetInt(-20)
                                        else
                                            yaw_path:SetInt(20)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end,

        dynamic_fake_yaw = function(self)
            if menu_database.handler.elements["Enable anti-aimbotting helpers"] then
                local directory = menu_database.handler.elements["Anti-aimbotting helpers"]
                if bit.band(directory, bit.lshift(1, 5)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end
  
                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local data, current_enemy = all_utils:update_enemies(), nil
                        if data ~= nil then
                            current_enemy = data.enemy
                        end
                      
                        if current_enemy ~= nil and current_enemy:IsAlive() then
                            local lby_fraction = math.abs(my_index:GetProp("m_flLowerBodyYawTarget") / 180)
                            local duck_amount = my_index:GetProp("m_flDuckAmount")
                            local side = all_utils:get_hit_side()

                            if not current_enemy:IsDormant() then
                                if duck_amount > 0.4 then
                                    Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Left Limit"):SetInt(56)
                                    Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Right Limit"):SetInt(56)
                                else
                                    if lby_fraction > 0.5 then
                                        Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Left Limit"):SetInt(25)
                                        Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Right Limit"):SetInt(25)
                                    else
                                        Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Left Limit"):SetInt(56)
                                        Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Right Limit"):SetInt(56)
                                    end
                                end
                            else
                                if duck_amount > 0.4 and not my_index:GetState(true) == "IN AIR" then
                                    Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Left Limit"):SetInt(45)
                                    Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Right Limit"):SetInt(45)
                                else
                                    if lby_fraction > 0.5 then
                                        Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Left Limit"):SetInt(
                                            math.floor(58 * lby_fraction)
                                        )

                                        Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Right Limit"):SetInt(
                                            math.floor(58 * lby_fraction)
                                        )
                                    else
                                        if side == 0.5 or side == -0.5 then
                                            Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Left Limit"):SetInt(35)
                                            Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Right Limit"):SetInt(35)
                                        elseif side == 1 or side == -1 then
                                            Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Left Limit"):SetInt(15)
                                            Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Right Limit"):SetInt(15)
                                        else
                                            Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Left Limit"):SetInt(56)
                                            Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Right Limit"):SetInt(56)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end,

        better_onshot = function()
            if menu_database.handler.elements["Enable anti-aimbotting helpers"] then
                local directory = menu_database.handler.elements["Anti-aimbotting helpers"]
                if bit.band(directory, bit.lshift(1, 6)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end

                    local active_weapon = my_index:GetActiveWeapon()
                    if not active_weapon then return end

                    local classname = active_weapon:GetClassName()
                    if not classname then return end
  
                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        if Menu.FindVar("Aimbot", "Ragebot", "Exploits", "Double Tap"):GetBool() and Exploits.GetCharge() == 1 then
                            if classname == "CWeaponSSG08" or classname == "CWeaponAWP" then
                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Desync On Shot"):SetInt(1)
                            else
                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Desync On Shot"):SetInt(3)
                            end
                        elseif Exploits.GetCharge() < 1 then
                            Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Desync On Shot"):SetInt(1)
                        end
                    end
                end
            end
        end,

        one_time_legit_aa = false,
        legit_aa_on_e = function(self, cmd)
            if menu_database.handler.elements["Enable anti-aimbotting helpers"] then
                local directory = menu_database.handler.elements["Anti-aimbotting helpers"]
                if bit.band(directory, bit.lshift(1, 7)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end
  
                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local is_active = function()
                            local maximum_distance = 99999999
                            local my_origin = my_index:GetRenderOrigin()

                            local doors = EntityList.GetEntitiesByClassID(143)
                            local bomb = EntityList.GetEntitiesByClassID(129)
                            local hostages = EntityList.GetEntitiesByClassID(97)

                            local my_view_angles = EngineClient.GetViewAngles()
                            local my_angles = Vector2.new(my_view_angles.yaw, my_view_angles.pitch)
                            my_angles.y = -my_angles.y

                            for k, v in pairs(doors) do
                                local doors_origin = v:GetRenderOrigin()
                                local current_distance = my_origin:DistTo(doors_origin)

                                if current_distance <= maximum_distance then maximum_distance = current_distance end
                            end

                            for k, v in pairs(bomb) do
                                local bomb_origin = v:GetRenderOrigin()
                                local current_distance = my_origin:DistTo(bomb_origin)

                                if current_distance <= maximum_distance then maximum_distance = current_distance end
                            end

                            for k, v in pairs(hostages) do
                                local hostages_origin = v:GetRenderOrigin()
                                local current_distance = my_origin:DistTo(hostages_origin)

                                if current_distance <= maximum_distance then maximum_distance = current_distance end
                            end

                            if maximum_distance <= 100 or (my_angles.y <= -25 and my_angles.y > -70) then
                                return false
                            end
                            return true
                        end

                        if bit.band(cmd.buttons, 32) == 32 then
                            if not self.one_time_legit_aa then
                                self.one_time_legit_aa = true
                            end

                            if is_active() then
                                if Menu.FindVar("Aimbot", "Anti Aim", "Main", "Yaw Base"):GetInt() == 5 then
                                    Menu.FindVar("Aimbot", "Anti Aim", "Main", "Yaw Base"):SetInt(4)
                                end

                                local yaw_base = Menu.FindVar("Aimbot", "Anti Aim", "Main", "Yaw Base"):GetInt()
                                local yaw_value = (
                                    yaw_base == 1 and 180 or yaw_base == 2 and 90 or yaw_base == 3 and -90 or
                                    yaw_base == 4 and 180 or 0
                                )

                                AntiAim.OverridePitch(0)
                                AntiAim.OverrideYawOffset(yaw_value)
                                AntiAim.OverrideLimit(60)

                                cmd.buttons = bit.band(cmd.buttons, bit.bnot(32))
                            end
                        else
                            if self.one_time_legit_aa then
                                self.one_time_legit_aa = false
                            end
                        end
                    end
                end
            end
        end,

        backup_fakelag = false,
        disable_fakelag = function(self)
            if menu_database.handler.elements["Enable anti-aimbotting helpers"] then
                local directory = menu_database.handler.elements["Anti-aimbotting helpers"]
                if bit.band(directory, bit.lshift(1, 8)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end
  
                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local fakelag_cache = 14
                        if not self.backup_fakelag then
                            fakelag_cache = Menu.FindVar("Aimbot", "Anti Aim", "Fake Lag", "Limit"):GetInt()
                            self.backup_fakelag = true
                        end

                        local isHS = Menu.FindVar("Aimbot", "Ragebot", "Exploits", "Hide Shots"):GetBool()
                        if isHS then
                            Menu.FindVar("Aimbot", "Anti Aim", "Fake Lag", "Limit"):SetInt(1)
                        else
                            if self.backup_fakelag then
                                Menu.FindVar("Aimbot", "Anti Aim", "Fake Lag", "Limit"):SetInt(fakelag_cache)
                                self.backup_fakelag = false
                            end
                        end
                    end
                end
            end
        end,

        roll_angles = {
            is_rolling_and_controlling = false, -- good song :)
            override_manual_settings = function()
                Menu.FindVar("Aimbot", "Anti Aim", "Main", "Yaw Base"):SetInt(4)

                Menu.FindVar("Aimbot", "Anti Aim", "Main", "Yaw Add"):SetInt(-11)
                Menu.FindVar("Aimbot", "Anti Aim", "Main", "Yaw Modifier"):SetInt(0)
                Menu.FindVar("Aimbot", "Anti Aim", "Main", "Modifier Degree"):SetInt(0)

                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Left Limit"):SetInt(60)
                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Right Limit"):SetInt(60)

                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Fake Options"):SetInt(0)
                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "LBY Mode"):SetInt(1)
                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Freestanding Desync"):SetInt(0)
                Menu.FindVar("Aimbot", "Anti Aim", "Fake Angle", "Desync On Shot"):SetInt(0)
            end,

            on_pre_prediction = function(self, cmd)
                self.is_rolling_and_controlling = false
                if menu_database.handler.elements["Enable roll angles"] then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end
  
                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local is_manuals_enabled = menu_database.handler.elements["Only manual roll angles"]
                        local current_manual = menu_database.handler.elements["Manual roll angles"]
                        local current_roll_angle = 100

                        if is_manuals_enabled then
                            if current_manual ~= 0 then
                                self.override_manual_settings()
                                AntiAim.OverrideYawOffset(current_manual == 1 and -90 or 90)
                            end

                            self.is_rolling_and_controlling = current_manual ~= 0
                        else
                            self.override_manual_settings()
                            self.is_rolling_and_controlling = current_roll_angle == 100
                        end

                        if is_manuals_enabled then
                            current_roll_angle = current_manual ~= 0 and 50 or 0
                        end

                        local current_state = my_index:GetState()
                        if current_state == "IN AIR" then
                            self.is_rolling_and_controlling = false
                        end

                        cmd.viewangles.roll = current_roll_angle
                    end
                end
            end,

            on_createmove = function(self, cmd)
                if menu_database.handler.elements["Enable roll angles"] then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end
  
                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local current_state = my_index:GetState()
                        local is_chocking = FakeLag.Choking()

                        if current_state == "IN AIR" or is_chocking then
                            cmd.viewangles.roll = 0
                        end
                    end
                end
            end
        },

        load_anti_aimbotting_functions = function(self, cmd)
            self:break_lagcomp_in_air()
            self:anti_backstabbing()
            self.bombsite_fix:run_work(cmd)
            self.quick_peek(cmd)
            self:smart_yaw_position()
            self:dynamic_fake_yaw()
            self:better_onshot()
            self:legit_aa_on_e(cmd)
            self:disable_fakelag()
        end
    }
    -- @endregion

    -- @region: all visual functions
    local visual_functions = {
        utils = {
            fonts_library = {
                ["Smallest Pixel-7"] = {
                    ["9"] = {
                        [""] = {
                            Render.InitFont("Smallest Pixel-7", 9)
                        }
                    },
                  
                    ["10"] = {
                        [""] = {
                            Render.InitFont("Smallest Pixel-7", 10)
                        }
                    }
                },

                ["Tahoma"] = {
                    ["10"] = {
                        [""] = {
                            Render.InitFont("Tahoma", 10)
                        }
                    }
                },

                ["Verdana"] = {
                    ["10"] = {
                        [""] = {
                            Render.InitFont("Verdana", 10)
                        },

                        ["b"] = {
                            Render.InitFont("Verdana", 10, {"b"})
                        }
                    },

                    ["11"] = {
                        ["r"] = {
                            Render.InitFont("Verdana", 11, {"r"})
                        }
                    },

                    ["12"] = {
                        [""] = {
                            Render.InitFont("Verdana", 12)
                        }
                    },

                    ["21"] = {
                        ["b"] = {
                            Render.InitFont("Verdana", 21, {"b"})
                        }
                    }
                },

                ["Calibri"] = {
                    ["30"] = {
                        ["b"] = {
                            Render.InitFont("Calibri", 30, {"b"})
                        }
                    }
                },

                ["Lucida Console"] = {
                    ["10"] = {
                        ["r"] = {
                            Render.InitFont("Lucida Console", 10, {"r"})
                        }
                    }
                }
            },

            get_font = function(self, font_name, font_size, flags)
                local library_names = self.fonts_library[font_name]
                local library_fonts = library_names[font_size]
                local library_flags = library_fonts[not flags and "" or flags][1]

                return library_flags
            end,

            get_desync = function(comma_index)
                local real_rotation = AntiAim.GetCurrentRealRotation()
                local fake_rotation = AntiAim.GetFakeRotation()
                local max_delta = AntiAim.GetMaxDesyncDelta()
                local delta = math.min(math.abs(real_rotation - fake_rotation), max_delta)

                return tonumber(string.format("%." .. comma_index .. "f", delta))
            end,

            draw_shadow = function(type, text, x, y, color, font_size, font, centered, shadow_color)
                local x_pos = type == 0 and 1 or type == 1 and 1 or type == 2 and 0 or 1
                local y_pos = type == 0 and 1 or type == 1 and 0 or type == 2 and 1 or 1

                Render.Text(text, Vector2.new(x + x_pos, y + y_pos), shadow_color, font_size, font, false, centered)
                Render.Text(text, Vector2.new(x + 0, y + 0), color, font_size, font, false, centered)
            end,

            hsv_to_rgb = function(h, s, v)
                local r, g, b

                local i = math.floor(h * 6);
                local f = h * 6 - i;
                local p = v * (1 - s);
                local q = v * (1 - f * s);
                local t = v * (1 - (1 - f) * s);
          
                i = i % 6
          
                if i == 0 then r, g, b = v, t, p
                elseif i == 1 then r, g, b = q, v, p
                elseif i == 2 then r, g, b = p, v, t
                elseif i == 3 then r, g, b = p, q, v
                elseif i == 4 then r, g, b = t, p, v
                elseif i == 5 then r, g, b = v, p, q
                end
          
                return Color.new(r, g, b)
            end
        },

        under_crosshair = function(self)
            if menu_database.handler.elements["Enable indicator list"] then
                if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 0)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end

                    local active_weapon = my_index:GetActiveWeapon()
                    if not active_weapon then return end

                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        if menu_database.handler.elements["Under crosshair style"] == 0 then
                            local add_y = 30
                            local alpha = math.floor(
                                math.sin(math.abs(-math.pi + (GlobalVars.curtime * (1.25 / .75)) % (math.pi * 2))) * 200
                            )

                            local font = self.utils:get_font("Smallest Pixel-7", "9")
                            local indicator_list = {}

                            local inverter = AntiAim.GetInverterState()
                            local current_fake = inverter and "R" or "L"

                            Render.Text(
                                "HALF-LIFE",
                                Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y),
                                Color.RGBA(255, 255, 255, 255),
                                9, font,
                                true, false
                            )

                            Render.Text(
                                "BETA",
                                Vector2.new(screen_size.x / 2 + 45, screen_size.y / 2 + add_y),
                                Color.RGBA(200, 200, 200, alpha),
                                9, font,
                                true, false
                            )

                            add_y = add_y + 9
                            local is_anti_bruteforce = anti_aimbotting_functions.anti_bruteforce.vars.is_anti_bruteforcing

                            local is_defensive = function()
                                local state, shifting = false, 0

                                if Menu.FindVar("Aimbot", "Ragebot", "Exploits", "Double Tap"):GetBool() then
                                    local hit_side = all_utils:get_hit_side()
                                    if hit_side == true or hit_side == false then
                                        hit_side = 0
                                        state = false
                                        shifting = nil
                                    end

                                    if hit_side ~= nil then
                                        if hit_side > 0 then
                                            state = true

                                            local tickbase = my_index:GetProp("m_nTickBase")
                                            local next_attack = my_index:GetProp("m_flNextAttack")
                                            local next_primary_attack = my_index:GetActiveWeapon():GetProp("m_flNextPrimaryAttack")

                                            local ticks = GlobalVars.interval_per_tick * (tickbase - 16)
                                            local shifting_tickbase = (ticks - next_primary_attack) * 2

                                            if shifting_tickbase <= 3 then shifting_tickbase = shifting_tickbase + (
                                                next_attack * 0.001
                                            ) * 2 end

                                            if shifting_tickbase >= 17 then shifting_tickbase = 17 end
                                            shifting_tickbase = math.floor(shifting_tickbase)

                                            shifting = shifting_tickbase
                                        else
                                            state = false
                                            shifting = nil
                                        end
                                    else
                                        state = false
                                        shifting = nil
                                    end
                                else
                                    state = false
                                    shifting = nil
                                end

                                return ({
                                    state = state,
                                    value = shifting
                                })
                            end

                            local get_dormant_players = function()
                                local ret = {}

                                local players = EntityList.GetEntitiesByName("CCSPlayer")
                                for i = 1, #players do
                                    local enemy = players[i]:GetPlayer()
                                    if enemy ~= my_index and not enemy:IsTeamMate() and enemy:IsAlive() then
                                        if enemy:IsDormant() then
                                            table.insert(ret, enemy)
                                        end
                                    end
                                end
                          
                                return #ret
                            end

                            local data, current_enemy = all_utils:update_enemies(), nil
                            if data ~= nil then
                                current_enemy = data.enemy
                            end

                            local is_rolling = anti_aimbotting_functions.roll_angles.is_rolling_and_controlling
                            if is_rolling then
                                Render.Text(
                                    "EXPLOITING:",
                                    Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y),
                                    Color.RGBA(255, 255, 255, 255),
                                    9, font,
                                    true, false
                                )

                                Render.Text(
                                    "z°",
                                    Vector2.new(screen_size.x / 2 + 50, screen_size.y / 2 + add_y),
                                    Color.RGBA(255, 255, 255, 255),
                                    9, font,
                                    true, false
                                )
                            elseif is_anti_bruteforce then
                                Render.Text(
                                    "ANTI ",
                                    Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y),
                                    Color.RGBA(255, 255, 255, 255),
                                    9, font,
                                    true, false
                                )
      
                                local counter = anti_aimbotting_functions.anti_bruteforce.vars.anti_bruteforcing_counter
                                local side = anti_aimbotting_functions.anti_bruteforce.vars.anti_bruteforcing_side
                                local timer = math.floor(
                                    anti_aimbotting_functions.anti_bruteforce.vars.anti_bruteforcing_timer % 10000 * 0.01
                                )

                                Render.Text(
                                    ("BRUTEFORCE[%s][%s][%s%%]"):format(counter, side, timer),
                                    Vector2.new(screen_size.x / 2 + 21, screen_size.y / 2 + add_y),
                                    Color.RGBA(255, 255, 255, 255),
                                    9, font,
                                    true, false
                                )
                            else
                                if is_defensive().state then
                                    if is_defensive().value ~= nil then
                                        Render.Text(
                                            "DEFENSIVE:",
                                            Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y),
                                            Color.RGBA(255, 255, 255, 255),
                                            9, font,
                                            true, false
                                        )

                                        Render.Text(
                                            ("%s"):format(is_defensive().value),
                                            Vector2.new(screen_size.x / 2 + 47, screen_size.y / 2 + add_y),
                                            Color.RGBA(255, 255, 255, 255),
                                            9, font,
                                            true, false
                                        )
                                    end
                                else
                                    Render.Text(
                                        "BODY",
                                        Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y),
                                        Color.RGBA(197, 122, 108, 255),
                                        9, font,
                                        true, false
                                    )
          
                                    Render.Text(
                                        " YAW: ",
                                        Vector2.new(screen_size.x / 2 + 16, screen_size.y / 2 + add_y),
                                        Color.RGBA(197, 122, 108, 255),
                                        9, font,
                                        true, false
                                    )
      
                                    Render.Text(
                                        current_fake,
                                        Vector2.new(screen_size.x / 2 + 40, screen_size.y / 2 + add_y),
                                        Color.RGBA(255, 255, 255, 255),
                                        9, font,
                                        true, false
                                    )
                                end
                            end

                            add_y = add_y + 9
                            Render.Text(
                                "DORMANCY:",
                                Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y),
                                Color.RGBA(255, 201, 132, 255),
                                9, font,
                                true, false
                            )

                            Render.Text(
                                ("%s"):format(get_dormant_players()),
                                Vector2.new(screen_size.x / 2 + 45, screen_size.y / 2 + add_y),
                                Color.RGBA(255, 255, 255, 255),
                                9, font,
                                true, false
                            )

                            local isDT = Menu.FindVar("Aimbot", "Ragebot", "Exploits", "Double Tap"):GetBool()
                            local isHS = Menu.FindVar("Aimbot", "Ragebot", "Exploits", "Hide Shots"):GetBool()
                          
                            local charge_color = Exploits.GetCharge() == 1 and Color.RGBA(133, 235, 89, 255) or Color.RGBA(244, 11, 12, 255)
                            local binds = Cheat.GetBinds()
                            local isDMG = false
          
                            for i = 1, #binds do
                                if binds[i]:IsActive() then
                                    if binds[i]:GetName() == "Minimum Damage" then
                                        isDMG = true
                                    end
                                end
                            end
      
                            table.insert(indicator_list, {text = isDT and "DT" or "", color = charge_color})
                            table.insert(indicator_list, {text = isHS and "HS" or "", color = Color.RGBA(255, 211, 168, 255)})
                            table.insert(indicator_list, {text = isDMG and "DMG" or "", color = Color.RGBA(255, 255, 255, 255)})

                            for k, indicator in ipairs(indicator_list) do
                                if indicator.text ~= nil and indicator.text ~= "" then
                                    add_y = add_y + 9
                                    Render.Text(
                                        indicator.text,
                                        Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y),
                                        indicator.color,
                                        9, font,
                                        true, false
                                    )
                                end
                            end
                        end

                        if menu_database.handler.elements["Under crosshair style"] == 1 then
                            local add_y = 30
                            local get_desync = self.utils.get_desync(0)

                            local font = self.utils:get_font("Smallest Pixel-7", "9")
                            local indicator_list = {}

                            Render.Text(
                                get_desync .. "",
                                Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y),
                                Color.RGBA(255, 255, 255, 255),
                                9, font,
                                true, true
                            )

                            Render.GradientBoxFilled(
                                Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y + 8),
                                Vector2.new(screen_size.x / 2 + (-math.abs(get_desync * 58 / 100)), screen_size.y / 2 + add_y + 11),
                                Color.RGBA(255, 255, 120, 255), Color.RGBA(0, 255, 153, 0),
                                Color.RGBA(255, 255, 120, 255), Color.RGBA(0, 255, 153, 0)
                            )

                            Render.GradientBoxFilled(
                                Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y + 8),
                                Vector2.new(screen_size.x / 2 + (math.abs(get_desync * 58 / 100)), screen_size.y / 2 + add_y + 11),
                                Color.RGBA(255, 255, 120, 255), Color.RGBA(153, 0, 255, 0),
                                Color.RGBA(255, 255, 120, 255), Color.RGBA(153, 0, 255, 0)
                            )

                            Render.Text(
                                "HA",
                                Vector2.new(screen_size.x / 2 - 18, screen_size.y / 2 + add_y + 20),
                                Color.RGBA(30, 251, 146, 255),
                                9, font,
                                true, true
                            )

                            Render.Text(
                                "LF",
                                Vector2.new(screen_size.x / 2 - 8, screen_size.y / 2 + add_y + 20),
                                Color.RGBA(125, 251, 146, 255),
                                9, font,
                                true, true
                            )

                            Render.Text(
                                "-",
                                Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y + 20),
                                Color.RGBA(255, 199, 49, 255),
                                9, font,
                                true, true
                            )

                            Render.Text(
                                "LI",
                                Vector2.new(screen_size.x / 2 + 8, screen_size.y / 2 + add_y + 20),
                                Color.RGBA(255, 150, 150, 255),
                                9, font,
                                true, true
                            )

                            Render.Text(
                                "FE",
                                Vector2.new(screen_size.x / 2 + 18, screen_size.y / 2 + add_y + 20),
                                Color.RGBA(255, 120, 120, 255),
                                9, font,
                                true, true
                            )

                            local isDT = Menu.FindVar("Aimbot", "Ragebot", "Exploits", "Double Tap"):GetBool()
                            local isHS = Menu.FindVar("Aimbot", "Ragebot", "Exploits", "Hide Shots"):GetBool()
                          
                            local charge_color = Exploits.GetCharge() == 1 and Color.RGBA(126, 214, 136, 255) or Color.RGBA(226, 54, 55, 255)
                            local binds = Cheat.GetBinds()
                            local isDMG = false
          
                            for i = 1, #binds do
                                if binds[i]:IsActive() then
                                    if binds[i]:GetName() == "Minimum Damage" then
                                        isDMG = true
                                    end
                                end
                            end

                            table.insert(indicator_list, {text = isDT and "DT" or "", color = charge_color})
                            table.insert(indicator_list, {text = isHS and "HS" or "", color = Color.RGBA(255, 217, 116, 255)})
                            table.insert(indicator_list, {text = isDMG and "DMG" or "", color = Color.RGBA(255, 255, 255, 255)})

                            for k, indicator in ipairs(indicator_list) do
                                if indicator.text ~= nil and indicator.text ~= "" then
                                    add_y = add_y + 9
                                    Render.Text(
                                        indicator.text,
                                        Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y + 20),
                                        indicator.color,
                                        9, font,
                                        true, true
                                    )
                                end
                            end
                        end

                        if menu_database.handler.elements["Under crosshair style"] == 2 then
                            local indicator_list = {}
                            local other_font = self.utils:get_font("Smallest Pixel-7", "10")
                            local add_y = 30

                            Render.Text(
                                "HALf-LIFE",
                                Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y),
                                Color.RGBA(255, 255, 255, 255),
                                10, other_font,
                                true, true
                            )

                            local isHS = Menu.FindVar("Aimbot", "Ragebot", "Exploits", "Hide Shots"):GetBool()
                            local isQP = Menu.FindVar("Miscellaneous", "Main", "Movement", "Auto Peek"):GetBool()
                            local isDT = Menu.FindVar("Aimbot", "Ragebot", "Exploits", "Double Tap"):GetBool()
                            local desync_value = ("%s%%"):format(self.utils.get_desync(0))

                            local binds = Cheat.GetBinds()
                            local isDMG = false
          
                            for i = 1, #binds do
                                if binds[i]:IsActive() then
                                    if binds[i]:GetName() == "Minimum Damage" then
                                        isDMG = true
                                    end
                                end
                            end

                            if isDT then
                                local attack = my_index:GetProp("m_flNextAttack") + 0.25
                                local primary_attack = active_weapon:GetProp("m_flNextPrimaryAttack") + 0.25
  
                                local fraction = math.abs(GlobalVars.curtime - math.max(attack, primary_attack))
                                if fraction >= 1 then fraction = 1 end

                                if Exploits.GetCharge() ~= 1 then
                                    Render.Circle(
                                        Vector2.new(screen_size.x / 2 + 10, screen_size.y / 2 + add_y + 19),
                                        3, 60, Color.RGBA(190, 190, 190, 255), 2,
                                        270, fraction * 640
                                    )
                                end
                            end

                            table.insert(indicator_list, {text = desync_value, color = Color.RGBA(190, 190, 190, 255)})
                            table.insert(indicator_list, {text = isDT and "DT" or "", color = Color.RGBA(190, 190, 190, 255)})
                            table.insert(indicator_list, {text = isHS and "ONSHOT" or "", color = Color.RGBA(190, 190, 190, 255)})
                            table.insert(indicator_list, {text = isQP and "QP" or "", color = Color.RGBA(190, 190, 190, 255)})
                            table.insert(indicator_list, {text = isDMG and "DMG" or "", color = Color.RGBA(190, 190, 190, 255)})
                          
                            for k, indicator in ipairs(indicator_list) do
                                if indicator.text ~= nil and indicator.text ~= "" then
                                    add_y = add_y + 9
                                    Render.Text(
                                        indicator.text,
                                        Vector2.new(screen_size.x / 2, screen_size.y / 2 + add_y),
                                        indicator.color,
                                        10, other_font,
                                        true, true
                                    )
                                end
                            end
                        end
                    end
                end
            end
        end,

        watermark_modules = {
            hit_counter = 0,
            count_hurt_shots = function(self, e)
                if menu_database.handler.elements["Enable indicator list"] then
                    if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 1)) ~= 0 then
                        local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                        if not localplayer then return end
                      
                        local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                        if not my_index then return end
  
                        if EngineClient.IsConnected() and my_index:IsAlive() then
                            if e:GetName() ~= "player_hurt" then return end

                            local victim = EntityList.GetPlayerForUserID(e:GetInt("userid"))
                            local attacker = EntityList.GetPlayerForUserID(e:GetInt("attacker"))
                            if victim == attacker or attacker == my_index then return end

                            self.hit_counter = self.hit_counter + 1
                            if self.hit_counter > 10 then self.hit_counter = 0 end
                        end
                    end
                end
            end
        },

        watermark = function(self)
            if menu_database.handler.elements["Enable indicator list"] then
                if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 1)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end

                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local font = self.utils:get_font("Verdana", "10", "b")
                        local add_x, add_y = screen_size.x / 2 - (screen_size.x / 2 - 85), screen_size.y / 2 - 35

                        Render.Text(
                            "half-life - version 0.3.0 beta",
                            Vector2.new(add_x, add_y),
                            Color.RGBA(255, 255, 255, 255),
                            10, font,
                            true
                        )

                        local aa_state = (
                            my_index:GetState() == "IN AIR" and "nil: (1. 0. 0)"
                            or AntiAim.GetInverterState() and "0: (1. 0. 0)" or "1: (1. 0. 0)"
                        )
                      
                        Render.Text(
                            ("> anti-aim info: side - %s;"):format(aa_state),
                            Vector2.new(add_x, add_y + 15),
                            Color.RGBA(255, 218, 244, 215),
                            10, font,
                            true
                        )
  
                        local data, current_enemy = all_utils:update_enemies(), nil
                        if data ~= nil then
                            current_enemy = data.enemy
                        end
                      
                        local target_name = (current_enemy ~= nil and current_enemy:IsAlive()) and current_enemy:GetName() or "nil"
                        local name_size = Render.CalcTextSize(("> anti-aim info: side - %s;"):format(aa_state), 10, font)
                      
                        Render.Text(
                            ("target: %s"):format(target_name),
                            Vector2.new(add_x + name_size.x / 2 + 85, add_y + 15),
                            Color.RGBA(255, 218, 244, 215),
                            10, font,
                            true
                        )
  
                        local is_rolling = anti_aimbotting_functions.roll_angles.is_rolling_and_controlling
                        local state = is_rolling and "exploiting" or (my_index:GetState()):lower()

                        Render.Text(
                            ("> player info: state - %s"):format(state),
                            Vector2.new(add_x, add_y + 30),
                            Color.RGBA(223, 255, 166, 215),
                            10, font,
                            true
                        )
  
                        Render.Text(
                            ("> anti brute info: misses - %s: hurt - %s"):format(
                                anti_aimbotting_functions.anti_bruteforce.vars.anti_bruteforcing_counter,
                                self.watermark_modules.hit_counter
                            ),
                            Vector2.new(add_x, add_y + 45),
                            Color.RGBA(255, 186, 145, 255),
                            10, font,
                            true
                        )
                    end
                end
            end
        end,

        minimum_damage = function(self)
            if menu_database.handler.elements["Enable indicator list"] then
                if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 2)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end

                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local font = self.utils:get_font("Smallest Pixel-7", "10")
                        local current_damage = ("%s"):format(Menu.FindVar("Aimbot", "Ragebot", "Accuracy", "Minimum Damage"):GetInt())
                        local text_size = Render.CalcTextSize(current_damage, 10, font)
                      
                        local position = menu_database.handler.elements["Minimum damage position"]
                        local y_position_list = {10, 10, -30, -30, -30, -55, -55, -55}
                        local x_position_list = {text_size.x / 2 + 5, -15, -55, 55, 0, 45, -45, 0}

                        local add_y = y_position_list[position + 1]
                        local add_x = x_position_list[position + 1]

                        Render.Text(
                            current_damage,
                            Vector2.new(screen_size.x / 2 - add_x, screen_size.y / 2 + add_y),
                            Color.RGBA(255, 255, 255, 255),
                            10, font,
                            true, true
                        )
                    end
                end
            end
        end,

        default_origin = Vector.new(0, 0, 0),
        skeet_autopeek = function(self)
            if menu_database.handler.elements["Enable indicator list"] then
                if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 3)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end

                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        if not Menu.FindVar("Miscellaneous", "Main", "Movement", "Auto Peek"):GetBool() then
                            self.default_origin = my_index:GetProp("m_vecOrigin")
                        end

                        if Menu.FindVar("Miscellaneous", "Main", "Movement", "Auto Peek"):GetBool() then
                            local color = menu_database.handler.references["Skeet autopeek color"].reference:Get()
                            color.a = color.a / 50
                          
                            for i = 1, 40 do
                                Render.Circle3DFilled(
                                    self.default_origin,
                                    60,
                                    i / 2,
                                    color,
                                    false
                                )
                            end
                        end
                    end
                end
            end
        end,

        skeet_modules = {
            vars = {
                fakelags = {
                    fakelag_1 = 0,
                    fakelag_2 = 0,
                    fakelag_3 = 0,
                    fakelag_4 = 0,
                    fakelag_5 = 0,
                    old_choke = 0
                },

                lag_compensation = {
                    is_lc = false,
                    timer = GlobalVars.curtime
                },

                fake = {
                    smooth_fill = 0
                },

                shot_stats = {
                    hits = 0,
                    misses = 0,
                    all_shots = 0,

                    count_shots = function(self, shot)
                        if menu_database.handler.elements["Enable indicator list"] then
                            if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 4)) ~= 0 then
                                local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                                if not localplayer then return end
                              
                                local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                                if not my_index then return end
          
                                if EngineClient.IsConnected() and my_index:IsAlive() then
                                    if bit.band(menu_database.handler.elements["Skeet indicator elements"], bit.lshift(1, 1)) ~= 0 then
                                        if shot.reason == 0 then
                                            self.hits = self.hits + 1
                                        else
                                            self.misses = self.misses + 1
                                        end

                                        self.all_shots = self.all_shots + 1
                                    end
                                end
                            end
                        end
                    end,
                },

                bomb_info = {
                    bombsite = -1,
                    is_defusing = false,
                    is_planting = false,
                    plant_time = 0,

                    on_begin_plant = function(self, e)
                        if e:GetName() ~= "bomb_beginplant" then return end
      
                        self.bombsite = e:GetInt("site")
                        self.is_planting = true
                        self.plant_time = GlobalVars.curtime
                    end, 
  
                    on_bomb_plant = function(self, e)
                        if e:GetName() ~= "bomb_planted" then return end
  
                        self.bombsite = -1
                        self.is_planting = false
                    end,
  
                    on_abort_plant = function(self, e)
                        if e:GetName() ~= "bomb_abortplant" then return end
      
                        self.bombsite = -1
                        self.is_planting = false
                    end,
  
                    on_defusing = function(self, e)
                        if e:GetName() ~= "bomb_begindefuse" then return end
  
                        self.is_defusing = true
                    end,
  
                    on_abort_defusing = function(self, e)
                        if e:GetName() ~= "bomb_abortdefuse" then return end
                      
                        self.is_defusing = false
                    end,
  
                    on_round_prestart = function(self, e)
                        if e:GetName() ~= "round_prestart" then return end
      
                        self.bombsite = -1
                        self.is_defusing = false
                        self.is_planting = false
                        self.plant_time = 0
                    end,
  
                    on_self_connected = function(self, e)
                        if e:GetName() ~= "player_connect_full" then return end
  
                        self.plant_time = 0
                        local c4 = EntityList.GetEntitiesByClassID(129)[1]
  
                        if not c4 then
                            self.bombsite = -1
                            self.is_planting = false
                        else
                            self.is_planting = true
                            self.bombsite = c4:GetProp("m_nBombSite")
                        end
                    end,
  
                    load_bomb_modules = function(self, e)
                        self:on_begin_plant(e)
                        self:on_bomb_plant(e)
                        self:on_abort_plant(e)
                        self:on_round_prestart(e)
                        self:on_defusing(e)
                        self:on_abort_defusing(e)
                        self:on_self_connected(e)
                    end
                }
            },

            directories = {
                isBaim = Menu.FindVar("Aimbot", "Ragebot", "Misc", "Body Aim")
            }
        },

        side_skeet_indicators = function(self)
            if menu_database.handler.elements["Enable indicator list"] then
                if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 4)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end

                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local indicator_list = {}
                        local font = self.utils:get_font("Calibri", "30", "b")

                        local add_x, add_y = 2, 50
                        local x, y = screen_size.x / 100 - 3, screen_size.y / 1.50 - 5

                        local render_indicator = function(text, color, add_y)
                            local text_size = Render.CalcTextSize(text, 22, font)
                            local back_alpha = 65
                          
                            Render.GradientBoxFilled(
                                Vector2.new(13, y + add_y),
                                Vector2.new(13 + text_size.x / 2, y + add_y + 28),
                                Color.RGBA(0, 0, 0, 0), Color.RGBA(0, 0, 0, back_alpha),
                                Color.RGBA(0, 0, 0, 0), Color.RGBA(0, 0, 0, back_alpha)
                            )

                            Render.GradientBoxFilled(
                                Vector2.new(13 + text_size.x / 2, y + add_y),
                                Vector2.new(13 + text_size.x, y + add_y + 28),
                                Color.RGBA(0, 0, 0, back_alpha), Color.RGBA(0, 0, 0, 0),
                                Color.RGBA(0, 0, 0, back_alpha), Color.RGBA(0, 0, 0, 0)
                            )

                            self.utils.draw_shadow(
                                2,
                                text,
                                x + add_x + 2, y + add_y + 4,
                                color,
                                23, font,
                                false, Color.RGBA(0, 0, 0, 170)
                            )
                        end

                        local render_circle = function(text, x_position, y_position, add_y, size, color, value)   
                            local text_size = Render.CalcTextSize(text, 22, font)
                          
                            Render.Circle(
                                Vector2.new(x + add_x + text_size.x + x_position + 3, y + add_y + text_size.y / 2 + y_position + 3),
                                size + 1, 60, Color.RGBA(0, 0, 0, 255), 3
                            )
                          
                            Render.Circle(
                                Vector2.new(x + add_x + text_size.x + x_position + 3, y + add_y + text_size.y / 2 + y_position + 3),
                                size, 60,
                                color,
                                4, 0, value
                            )
                        end

                        local get_text_fakelag = function()
                            local self_chocking = ClientState.m_choked_commands
                            if self_chocking < self.skeet_modules.vars.fakelags.old_choke then
                                self.skeet_modules.vars.fakelags.fakelag_1 = self.skeet_modules.vars.fakelags.fakelag_2
                                self.skeet_modules.vars.fakelags.fakelag_2 = self.skeet_modules.vars.fakelags.fakelag_3
                                self.skeet_modules.vars.fakelags.fakelag_3 = self.skeet_modules.vars.fakelags.fakelag_4
                                self.skeet_modules.vars.fakelags.fakelag_4 = self.skeet_modules.vars.fakelags.fakelag_5
                                self.skeet_modules.vars.fakelags.fakelag_5 = self.skeet_modules.vars.fakelags.old_choke
                            end

                            self.skeet_modules.vars.fakelags.old_choke = self_chocking
                            return ("%i-%i-%i-%i-%i"):format(
                                self.skeet_modules.vars.fakelags.fakelag_1,
                                self.skeet_modules.vars.fakelags.fakelag_2,
                                self.skeet_modules.vars.fakelags.fakelag_3,
                                self.skeet_modules.vars.fakelags.fakelag_4,
                                self.skeet_modules.vars.fakelags.fakelag_5
                            )
                        end

                        local is_enabled = function(value)
                            return bit.band(menu_database.handler.elements["Skeet indicator elements"], bit.lshift(1, value)) ~= 0
                        end

                        self.skeet_modules.vars.fake.smooth_fill = all_utils.easings.lerp(
                            self.skeet_modules.vars.fake.smooth_fill,
                            self.utils.get_desync(0),
                            GlobalVars.frametime * 5
                        )
  
                        local fake_color = Color.new(
                            (170 + (154 - 186) * self.skeet_modules.vars.fake.smooth_fill / 60) / 255,
                            (0 + (255 - 0) * self.skeet_modules.vars.fake.smooth_fill / 60) / 255,
                            (16 + (0 - 16) * self.skeet_modules.vars.fake.smooth_fill / 60) / 255,
                            1
                        )

                        table.insert(indicator_list, {
                            type = "circle",
  
                            fl_text = "FAKE",
                            fl_color = fake_color,
  
                            x_pos = is_enabled(0) and 15 or "",
                            y_pos = 0,
                            size = 7,
                            color = fake_color,
                            value = self.skeet_modules.vars.fake.smooth_fill * 6.4
                        })

                        if is_enabled(1) then
                            local hits = self.skeet_modules.vars.shot_stats.hits
                            local misses = self.skeet_modules.vars.shot_stats.misses
                            local all_shots = self.skeet_modules.vars.shot_stats.all_shots

                            local selected_style = menu_database.handler.elements["Hit/miss type"]
                            if selected_style == 0 then
                                if all_shots > 0 then
                                    local result_stats = ("%.1f"):format((hits / all_shots) * 100)
                                    local result_text = ("%s/%s (%s)"):format(hits, all_shots, result_stats)
      
                                    table.insert(indicator_list, {
                                        type = "text",
                                        text = result_text,
                                        color = Color.RGBA(255, 255, 255, 255)
                                    })
                                end
                            else
                                local hard_math = math.floor((hits / all_shots) * 100)
                                if hard_math ~= hard_math then hard_math = 100 end

                                local result_stats = ("%s%%"):format(hard_math)
                                local result_text = ("%s/%s"):format(misses, result_stats)
  
                                table.insert(indicator_list, {
                                    type = "text",
                                    text = result_text,
                                    color = Color.RGBA(255, 255, 255, 255)
                                })
                            end
                        end

                        table.insert(indicator_list, {
                            type = "text",
                            text = is_enabled(2) and get_text_fakelag() or "",
                            color = Color.RGBA(255, 255, 255, 255)
                        })

                        table.insert(indicator_list, {
                            type = "text",
                            text = (is_enabled(3) and self.skeet_modules.directories.isBaim:GetInt() == 2) and "BODY" or "",
                            color = Color.RGBA(255, 255, 255, 255)
                        })

                        local isDT = Menu.FindVar("Aimbot", "Ragebot", "Exploits", "Double Tap"):GetBool()
                        local binds = Cheat.GetBinds()
                        local isDMG, curDMG, isPing = false, 0, false
      
                        for i = 1, #binds do
                            local bind = binds[i]
                            if bind:IsActive() then
                                if bind:GetName() == "Minimum Damage" then
                                    isDMG = true
                                    curDMG = bind:GetValue()
                                end

                                if bind:GetName() == "Fake Ping" then
                                    isPing = true
                                end
                            end
                        end

                        local current_state = my_index:GetState()
                        if not current_state then return end

                        table.insert(indicator_list, {
                            type = "text",
                            text = is_enabled(4) and "EX" or "",
                            color = (isDT and current_state == "IN AIR") and Color.RGBA(132, 195, 16, 255) or Color.RGBA(208, 208, 20, 255)
                        })

                        local damage_type = menu_database.handler.elements["Damage type"]
                        table.insert(indicator_list, {
                            type = "text",
                            text = (is_enabled(5) and isDMG) and (
                                damage_type == 0 and ("Damage: %s"):format(curDMG) or damage_type == 1 and ("DMG: %s"):format(curDMG)
                                or damage_type == 2 and tostring(curDMG) or ""
                            ) or "",
                            color = (
                                damage_type == 0 and Color.RGBA(255, 255, 255, 255) or damage_type == 1 and Color.RGBA(255, 255, 255, 150) or Color.RGBA(255, 255, 255, 255)
                            )
                        })

                        local isDA = menu_database.handler.elements["Enable dormant aimbot"]
                        table.insert(indicator_list, {
                            type = "text",
                            text = (is_enabled(6) and isDA) and "DA" or "",
                            color = Color.RGBA(132, 195, 16, 255)
                        })

                        local get_ping_color = function()
                            local ping = EntityList.GetPlayerResource():GetProp("DT_CSPlayerResource", "m_iPing")[2]
                            local color = Color.RGBA(
                                math.floor(255 - ((ping / 189 * 60) * 2.29824561404)),
                                math.floor((ping / 189 * 60) * 2.42105263158),
                                math.floor((ping / 189 * 60) * 0.22807017543),
                                255
                            )

                            return color
                        end

                        table.insert(indicator_list, {
                            type = "text",
                            text = (is_enabled(7) and isPing) and "PING" or "",
                            color = get_ping_color()
                        })

                        if my_index:GetState() == "IN AIR" then
                            self.skeet_modules.vars.lag_compensation.is_lc = true
                            self.skeet_modules.vars.lag_compensation.timer = GlobalVars.curtime + 0.1
                        else
                            if self.skeet_modules.vars.lag_compensation.timer > GlobalVars.curtime then
                                self.skeet_modules.vars.lag_compensation.is_lc = true
                            else
                                self.skeet_modules.vars.lag_compensation.is_lc = false
                            end
                        end

                        table.insert(indicator_list, {
                            type = "text",
                            text = (is_enabled(8) and self.skeet_modules.vars.lag_compensation.is_lc) and "LC" or "",
                            color = my_index:GetVelocity() < 285 and Color.RGBA(255, 0, 0, 255) or Color.RGBA(132, 195, 16, 255)
                        })

                        local isFD = Menu.FindVar("Aimbot", "Anti Aim", "Misc", "Fake Duck"):GetBool()
                        table.insert(indicator_list, {
                            type = "text",
                            text = (is_enabled(9) and isFD) and "DUCK" or "",
                            color = Color.RGBA(255, 255, 255, 255)
                        })

                        if is_enabled(10) then
                            local c4 = EntityList.GetEntitiesByClassID(129)[1]
                            if c4 then
                                if c4:GetProp("m_bBombTicking") and not c4:GetProp("m_bBombDefused") then
                                    local get_damage = function()
                                        local armor = my_index:GetProp("m_ArmorValue")
                                        local health = my_index:GetProp("m_iHealth")
  
                                        local c4_origin = c4:GetRenderOrigin()
                                        local my_origin = my_index:GetRenderOrigin()
                                        local distance = my_origin:DistTo(c4_origin)
  
                                        local a, b, c = 450.7, 75.68, 789.2
                                        local d = (distance - b) / c
                                        local damage = a * math.exp(-d * d)
  
                                        if armor > 0 then
                                            local new_damage = damage * 0.5
                                            local armor_damage = (damage - new_damage) * 0.5
  
                                            if armor_damage > armor then
                                                armor = armor * (1 / .5)
                                                new_damage = damage - armor_damage
                                            end
  
                                            damage = new_damage
                                        end
  
                                        return ({
                                            text = math.ceil(damage) >= health and "FATAL" or ("-%s HP"):format(math.ceil(damage)),
                                            color = math.ceil(damage) >= health and Color.RGBA(255, 0, 0, 255)
                                            or Color.RGBA(210, 216, 112, 255)
                                        })
                                    end
  
                                    local current_site = self.skeet_modules.vars.bomb_info.bombsite % 2 == 1 and "B" or "A"
                                    local timer = c4:GetProp("m_flC4Blow") - GlobalVars.curtime
  
                                    if timer > 0.1 then
                                        local plant_info = ("%s - %ss"):format(current_site, ("%.1f"):format(timer))
                                        table.insert(indicator_list, {
                                            type = "text",
                                            text = plant_info,
                                            color = Color.RGBA(255, 255, 255, 255)
                                        })
  
                                        local health_info = get_damage()
                                        table.insert(indicator_list, {
                                            type = "text",
                                            text = health_info.text,
                                            color = health_info.color
                                        })
  
                                        if self.skeet_modules.vars.bomb_info.is_defusing then
                                            local defuse_timer = c4:GetProp("m_flDefuseCountDown") - GlobalVars.curtime
                                            local defuse_length = c4:GetProp("m_flDefuseLength")
                                            local defuse_bar_length = ((screen_size.y - 50) / defuse_length) * defuse_timer
                                            local bar_color = timer > defuse_length and Color.RGBA(58, 191, 54, 120)
                                            or Color.RGBA(252, 18, 19, 120)
  
                                            Render.BoxFilled(
                                                Vector2.new(0, 0),
                                                Vector2.new(10, screen_size.y),
                                                Color.RGBA(25, 25, 25, 120)
                                            )
  
                                            Render.BoxFilled(
                                                Vector2.new(0, screen_size.y - defuse_bar_length),
                                                Vector2.new(10, screen_size.y),
                                                bar_color
                                            )
  
                                            Render.Box(
                                                Vector2.new(0, 0),
                                                Vector2.new(10, screen_size.y),
                                                Color.RGBA(25, 25, 25, 120)
                                            )
                                        end
                                    end
                                end
                            end
  
                            if self.skeet_modules.vars.bomb_info.is_planting then
                                local current_site = self.skeet_modules.vars.bomb_info.bombsite % 2 == 1 and "B" or "A"
                                local frac = all_utils.easings.clamp(3.125 - (3.125 + self.skeet_modules.vars.bomb_info.plant_time - GlobalVars.curtime), 0, 3.125)

                                table.insert(indicator_list, {
                                    type = "circle",
          
                                    fl_text = ("Bombsite %s"):format(current_site),
                                    fl_color = Color.RGBA(234, 209, 138, 255),
          
                                    x_pos = 16,
                                    y_pos = 0,
                                    size = 8,
                                    color = Color.RGBA(255, 255, 255, 255),
                                    value = (frac / 3.3) * 360
                                })
                            end
                        end

                        table.insert(indicator_list, {
                            type = "text",
                            text = (is_enabled(11) and Menu.FindVar("Aimbot", "Ragebot", "Exploits", "Double Tap"):GetBool()) and "DT" or "",
                            color = Exploits.GetCharge() == 1 and Color.RGBA(255, 255, 255, 255) or Color.RGBA(255, 0, 0, 255)
                        })

                        for k, indicator in ipairs(indicator_list) do
                            if indicator.type == "text" then
                                if indicator.text ~= nil and indicator.text ~= "" then
                                    render_indicator(
                                        indicator.text,
                                        indicator.color,
                                        add_y
                                    )
                                end
                            end

                            if indicator.type == "circle" then
                                if indicator.x_pos ~= "" then
                                    render_indicator(
                                        indicator.fl_text,
                                        indicator.fl_color,
                                        add_y
                                    )
  
                                    render_circle(
                                        indicator.fl_text,
                                        indicator.x_pos, indicator.y_pos, add_y,
                                        indicator.size,
                                        indicator.color,
                                        indicator.value
                                    )
                                end
                            end

                            if (indicator.text ~= nil and indicator.text ~= "") or (indicator.type == "circle" and indicator.x_pos ~= "") then
                                add_y = add_y - 35
                            end
                        end
                    end
                end
            end
        end,

        thirdperson_animations = function()
            if menu_database.handler.elements["Enable indicator list"] then
                if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 5)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end

                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        Cheat.SetThirdPersonAnim(false)
                    end
                else
                    Cheat.SetThirdPersonAnim(true)
                end
            else
                Cheat.SetThirdPersonAnim(true)
            end
        end,

        hitmarker_modules = {
            hitmarkers = {},
            on_registered_shot = function(self, shot)
                if menu_database.handler.elements["Enable indicator list"] then
                    if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 6)) ~= 0 then
                        local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                        if not localplayer then return end
                      
                        local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                        if not my_index then return end
  
                        if EngineClient.IsConnected() and my_index:IsAlive() then
                            if shot.reason == 0 then
                                table.insert(self.hitmarkers, {timer = GlobalVars.realtime, alpha = 0})
                            end
                        end
                    end
                end
            end
        },

        crosshair_hitmarker = function(self)
            if menu_database.handler.elements["Enable indicator list"] then
                if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 6)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end

                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        for i, info in ipairs(self.hitmarker_modules.hitmarkers) do
                            if info.timer + 0.5 < GlobalVars.realtime then
                                info.alpha = all_utils.easings.lerp(
                                    info.alpha, 0, GlobalVars.frametime * 15
                                )
                            else
                                info.alpha = all_utils.easings.lerp(
                                    info.alpha, 255, GlobalVars.frametime * 15
                                )
                            end

                            local alpha = math.floor(info.alpha)
                            local color = menu_database.handler.references["Crosshair hitmarker color"].reference:Get()

                            Render.Line(
                                Vector2.new(screen_size.x / 2 - 5, screen_size.y / 2 - 5),
                                Vector2.new(screen_size.x / 2 - 10, screen_size.y / 2 - 10),
                                Color.new(color.r, color.g, color.b, alpha / 200)
                            )

                            Render.Line(
                                Vector2.new(screen_size.x / 2 + 5, screen_size.y / 2 - 5),
                                Vector2.new(screen_size.x / 2 + 10, screen_size.y / 2 - 10),
                                Color.new(color.r, color.g, color.b, alpha / 200)
                            )
                          
                            Render.Line(
                                Vector2.new(screen_size.x / 2 + 5, screen_size.y / 2 + 5),
                                Vector2.new(screen_size.x / 2 + 10, screen_size.y / 2 + 10),
                                Color.new(color.r, color.g, color.b, alpha / 200)
                            )

                            Render.Line(
                                Vector2.new(screen_size.x / 2 - 5, screen_size.y / 2 + 5),
                                Vector2.new(screen_size.x / 2 - 10, screen_size.y / 2 + 10),
                                Color.new(color.r, color.g, color.b, alpha / 200)
                            )

                            if info.timer + 1.5 < GlobalVars.realtime then table.remove(self.hitmarker_modules.hitmarkers, i) end
                        end
                    end
                end
            end
        end,

        script_start_modules = {
            show_one_time = false,
            timer = GlobalVars.realtime,

            smooth_y = screen_size.y - 100,
            alpha = 0,

            first_circle = 0,
            second_circle = 0,

            box_left = screen_size.x / 2,
            box_right = screen_size.x / 2,

            box_left_1 = screen_size.x / 2,
            box_right_1 = screen_size.x / 2
        },

        on_script_start = function(self)
            if not self.script_start_modules.show_one_time then
                local font = self.utils:get_font("Verdana", "12")
                local text = ("[half-life beta] Welcome back, %s! Successfully loaded half-life; build: beta; days left: lifetime."):format(Cheat.GetCheatUserName())
                local text_size = Render.CalcTextSize(text, 12, font)

                self.script_start_modules.alpha = all_utils.easings.lerp(
                    self.script_start_modules.alpha,
                    255,
                    GlobalVars.frametime * 4
                )

                self.script_start_modules.first_circle = all_utils.easings.lerp(
                    self.script_start_modules.first_circle, 275, GlobalVars.frametime * 5
                )

                self.script_start_modules.second_circle = all_utils.easings.lerp(
                    self.script_start_modules.second_circle, -95, GlobalVars.frametime * 3
                )

                self.script_start_modules.box_left = all_utils.easings.lerp(
                    self.script_start_modules.box_left, screen_size.x / 2 - text_size.x / 2 - 2, GlobalVars.frametime * 6
                )

                self.script_start_modules.box_right = all_utils.easings.lerp(
                    self.script_start_modules.box_right, screen_size.x / 2 + text_size.x / 2 + 4, GlobalVars.frametime * 6
                )

                self.script_start_modules.box_left_1 = all_utils.easings.lerp(
                    self.script_start_modules.box_left_1, screen_size.x / 2 - text_size.x / 2 - 2, GlobalVars.frametime * 6
                )

                self.script_start_modules.box_right_1 = all_utils.easings.lerp(
                    self.script_start_modules.box_right_1, screen_size.x / 2 + text_size.x / 2 + 4, GlobalVars.frametime * 6
                )

                if self.script_start_modules.timer + 3.8 < GlobalVars.realtime then
                    self.script_start_modules.first_circle = all_utils.easings.lerp(
                        self.script_start_modules.first_circle, 0, GlobalVars.frametime * 1
                    )
  
                    self.script_start_modules.second_circle = all_utils.easings.lerp(
                        self.script_start_modules.second_circle, 0, GlobalVars.frametime * 1
                    )
  
                    self.script_start_modules.box_left = all_utils.easings.lerp(
                        self.script_start_modules.box_left, screen_size.x / 2, GlobalVars.frametime * 1
                    )
  
                    self.script_start_modules.box_right = all_utils.easings.lerp(
                        self.script_start_modules.box_right, screen_size.x / 2, GlobalVars.frametime * 1
                    )
  
                    self.script_start_modules.box_left_1 = all_utils.easings.lerp(
                        self.script_start_modules.box_left_1, screen_size.x / 2, GlobalVars.frametime * 1
                    )
  
                    self.script_start_modules.box_right_1 = all_utils.easings.lerp(
                        self.script_start_modules.box_right_1, screen_size.x / 2, GlobalVars.frametime * 1
                    )
                end

                if self.script_start_modules.timer + 4 < GlobalVars.realtime then
                    self.script_start_modules.smooth_y = all_utils.easings.lerp(
                        self.script_start_modules.smooth_y,
                        screen_size.y + 100,
                        GlobalVars.frametime * 4
                    )

                    self.script_start_modules.alpha = all_utils.easings.lerp(
                        self.script_start_modules.alpha,
                        0,
                        GlobalVars.frametime * 8
                    )
                end

                local add_y = math.floor(self.script_start_modules.smooth_y)
                local alpha = math.floor(self.script_start_modules.alpha)

                local first_circle = math.floor(self.script_start_modules.first_circle)
                local second_circle = math.floor(self.script_start_modules.second_circle)

                local left_box = math.floor(self.script_start_modules.box_left)
                local right_box = math.floor(self.script_start_modules.box_right)

                local left_box_1 = math.floor(self.script_start_modules.box_left_1)
                local right_box_1 = math.floor(self.script_start_modules.box_right_1)

                local rgb = self.utils.hsv_to_rgb(GlobalVars.realtime / 4, 1, 1)
                local second_gradient = Color.new(rgb.b, rgb.r, rgb.g, 1)
                local third_gradient = Color.new(rgb.g, rgb.b, rgb.r, 1)

                Render.BoxFilled(
                    Vector2.new(screen_size.x / 2 - text_size.x / 2 - 11, add_y - 26),
                    Vector2.new(screen_size.x / 2 + text_size.x / 2 + 11, add_y - 4),
                    Color.RGBA(17, 17, 17, alpha - 65), 90
                )
              
                Render.Circle(
                    Vector2.new(screen_size.x / 2 - text_size.x / 2 - 2, add_y - 15),
                    10, 90, second_gradient, 2, 90, first_circle
                )

                Render.Circle(
                    Vector2.new(screen_size.x / 2 + text_size.x / 2 + 2, add_y - 15),
                    10, 90, third_gradient, 2, 90, second_circle
                )

                for i = 1, 1 do
                    for k = 1, 2 do
                        Render.GradientBoxFilled(
                            Vector2.new(left_box, add_y - 7 + i),
                            Vector2.new(screen_size.x / 2, add_y - 5.5 + i),
                            second_gradient, second_gradient, second_gradient, second_gradient
                        )

                        Render.GradientBoxFilled(
                            Vector2.new(right_box, add_y - 7 + i),
                            Vector2.new(screen_size.x / 2, add_y - 5.5 + i),
                            third_gradient, second_gradient, third_gradient, second_gradient
                        )
                      
                        Render.GradientBoxFilled(
                            Vector2.new(screen_size.x / 2, add_y - 22.7 - i),
                            Vector2.new(left_box_1, add_y - 24.5 - i),
                            second_gradient, second_gradient, second_gradient, second_gradient
                        )

                        Render.GradientBoxFilled(
                            Vector2.new(screen_size.x / 2, add_y - 22.7 - i),
                            Vector2.new(right_box_1, add_y - 24.5 - i),
                            second_gradient, third_gradient, second_gradient, third_gradient
                        )
                    end
                end

                self.utils.draw_shadow(
                    2,
                    text,
                    screen_size.x / 2 - text_size.x / 2, add_y - 21,
                    Color.RGBA(255, 255, 255, alpha - 70),
                    12, font,
                    false, Color.RGBA(0, 0, 0, alpha)
                )

                if self.script_start_modules.timer + 5 < GlobalVars.realtime then
                    self.script_start_modules.timer = GlobalVars.realtime
                    self.script_start_modules.show_one_time = true
                end
            end
        end,

        hitlog_modules = {
            hitlogs = {},
            count_shots = 0,

            on_registered_shot = function(self, shot)
                if menu_database.handler.elements["Enable hitlogs"] then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end
  
                    if EngineClient.IsConnected() then
                        self.count_shots = self.count_shots + 1
                        if self.count_shots > 99 then self.count_shots = 0 end

                        local other_info = function()
                            local index = EntityList.GetClientEntity(shot.target_index)
                            if not index then return end

                            local target = index:GetPlayer()
                            local name = target:GetName()
  
                            local get_hitbox = function()
                                local hitgroups = {
                                    "head", "neck", "pelvis",
                                    "stomach", "lower chest", "chest",
                                    "upper chest", "right leg", "left leg",
                                    "right leg", "left leg", "right foot",
                                    "left foot", "right hand", "left hand",
                                    "right arm", "right arm", "left arm", "left arm"
                                }

                                local hitboxes = {0, 3, 2, 16, 18, 11, 10, 0}
                                local hitbox = hitboxes[shot.hitgroup]
                                if hitbox == nil then hitbox = 3 end
  
                                local hitbox = hitgroups[hitbox + 1]
                                local wanted_hitgroup = hitgroups[shot.wanted_hitgroup]
  
                                return ({
                                    hitbox = hitbox,
                                    wanted = wanted_hitgroup
                                })
                            end

                            local damage = {
                                hit = shot.damage,
                                wanted = shot.wanted_damage,
                                remain = target:GetProp("m_iHealth") - shot.damage
                            }
                          
                            if damage.remain <= 0 then damage.remain = 0 end

                            local hit_hitchance = shot.hitchance
                            local is_missmatch = damage.hit ~= damage.wanted and true or false

                            local backtrack = shot.backtrack
                            local reasons = {"resolver", "spread", "occlusion", "prediction error"}
                            local miss_reason = reasons[shot.reason]

                            local second_correction = Utils.RandomInt(-15, 15)
                            local first_correction = 0
                            if 1 - math.floor(hit_hitchance / 100) == 0 then
                                first_correction = 1
                            elseif 1 - math.floor(hit_hitchance / 100) == 1 then
                                first_correction = 2
                            else
                                first_correction = 3
                            end

                            return ({
                                name = name,
                                hitbox = get_hitbox().hitbox,
                                wanted_hitbox = get_hitbox().wanted,

                                shot = self.count_shots,
                                damage = damage.hit,
                                wanted_damage = damage.wanted,
                                remain_damage = damage.remain,

                                hitchance = hit_hitchance,
                                missmatch = is_missmatch,

                                backtrack = backtrack,
                                miss_reason = miss_reason,

                                first_correction = first_correction,
                                second_correction = second_correction
                            })
                        end

                        local text = ""
                        local text_color = Color.RGBA(255, 255, 255, 255)
                        local info = other_info()

                        if shot.reason == 0 then
                            if info.missmatch then
                                text = string.format(
                                    "Registered %sth shot in %s's %s for %s damage [angle: 0.%s°, %s:%s°] ( hitchance: %s | history(Δ): %s | %s health | missmatch: [dmg: %s] )",
                                    info.shot, info.name, info.hitbox, info.damage, Utils.RandomInt(0, 60),
                                    info.first_correction, info.second_correction, info.hitchance, info.backtrack,
                                    info.remain_damage, info.wanted_damage
                                )
                            else
                                text = string.format(
                                    "Registered %sth shot in %s's %s for %s damage [angle: 0.%s°, %s:%s°] ( hitchance: %s | history(Δ): %s | %s health )",
                                    info.shot, info.name, info.hitbox, info.damage, Utils.RandomInt(0, 60),
                                    info.first_correction, info.second_correction, info.hitchance, info.backtrack,
                                    info.remain_damage
                                )
                            end
                        else
                            text = string.format(
                                "Missed %sth shot at %s's %s due to %s [angle: 0.%s°, %s:%s°] ( damage: %s | hitchance: %s | history(Δ): %s | %s health )",
                                info.shot, info.name, info.wanted_hitbox,
                                info.miss_reason, Utils.RandomInt(0, 60), info.first_correction,
                                info.second_correction, info.wanted_damage,
                                info.hitchance, info.backtrack, info.remain_damage
                            )
                        end

                        table.insert(self.hitlogs, {
                            text = text, time = GlobalVars.realtime, color = text_color
                        })

                        colored_print(Color.RGBA(255, 255, 102, 255), "[half-life] ")
                        print(text)
                    end
                end
            end,

            get_addictional_hits = function(self, e)
                if menu_database.handler.elements["Enable hitlogs"] then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end
  
                    if EngineClient.IsConnected() then
                        if e:GetName() ~= "player_hurt" then return end

                        local me = EntityList.GetLocalPlayer()
                        local victim = EntityList.GetPlayerForUserID(e:GetInt("userid"))
                        local attacker = EntityList.GetPlayerForUserID(e:GetInt("attacker"))
                        if victim == attacker or attacker ~= me then return end

                        local victim_index = EntityList.GetPlayerForUserID(e:GetInt("userid"))
                        if not victim_index then return end

                        local target_name = victim_index:GetName()
                        local health_damage = e:GetInt("dmg_health")
                        local remaining_damage = e:GetInt("health")

                        local weapon = e:GetString("weapon")
                        local text = (
                            weapon == "hegrenade" and ("Naded %s for %s (%s remaining)"):format(
                                target_name, health_damage, remaining_damage
                            ) or weapon == "inferno" and ("Burned %s for %s (%s remaining)"):format(
                                target_name, health_damage, remaining_damage
                            ) or weapon == "knife" and ("Knifed %s for %s (%s remaining)"):format(
                                target_name, health_damage, remaining_damage
                            ) or nil
                        )

                        if text ~= nil then
                            table.insert(self.hitlogs, {
                                text = text, time = GlobalVars.realtime, color = Color.RGBA(255, 255, 255, 255)
                            })
  
                            colored_print(Color.RGBA(255, 255, 102, 255), "[half-life] ")
                            print(text)
                        end
                    end
                end
            end
        },

        hitlogs = function(self)
            if menu_database.handler.elements["Enable hitlogs"] then
                local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                if not localplayer then return end
              
                local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                if not my_index then return end

                if EngineClient.IsConnected() then
                    local x, y = 5, 5

                    for k, information in ipairs(self.hitlog_modules.hitlogs) do
                        if information.text and information.time and information.color then
                            local text = information.text
                            local font = self.utils:get_font("Lucida Console", "10", "r")
                            local color = information.color

                            self.utils.draw_shadow(
                                0,
                                text,
                                x, y,
                                color,
                                10, font,
                                false, Color.RGBA(0, 0, 0, 255)
                            )

                            y = y + 15
                            if information.time + 3.8 < GlobalVars.realtime then
                                table.remove(self.hitlog_modules.hitlogs, k)
                            end
                        end
                    end
                end
            end
        end,

        execute_sauron_shots = function(self, shot)
            if menu_database.handler.elements["Enable indicator list"] then
                if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 7)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end

                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        local hitgroups = {
                            "head", "neck", "pelvis", "stomach", "lower chest", "chest", "upper chest",
                            "right leg", "left leg", "right leg", "left leg", "right foot", "left foot",
                            "right hand", "left hand", "right arm", "right arm", "left arm", "left arm"
                        }

                        local all_hitgroups = {0, 3, 2, 16, 18, 11, 10, 0}
                        local current_hitgroups = all_hitgroups[shot.hitgroup]
                        if not current_hitgroups then current_hitgroups = 3 end
                        local hitbox = hitgroups[current_hitgroups + 1]

                        local target_name = EntityList.GetClientEntity(shot.target_index):GetPlayer():GetName()
                        local hit_damage = shot.damage
                        local hit_hitchance = shot.hitchance
                        local wanted_damage = shot.wanted_damage
                        local wanted_hitgroup = hitgroups[shot.wanted_hitgroup]
                        local delta = self.utils.get_desync(0)
                        local backtrack = shot.backtrack
                        local spread = string.format("%.2f", shot.spread_degree)

                        local reasons = {"resolver", "spread", "occlusion", "prediction error"}
                        local miss_reason = reasons[shot.reason]

                        local text = (
                            shot.reason == 0 and
                            ("Registered shot at %s's %s for %s damage [angle: %s°] (hitchance: %s | history: %s)"):format(
                                target_name, hitbox, hit_damage, spread, hit_hitchance, backtrack
                            ) or shot.reason ~= 0 and (
                                "Missed shot at %s's %s due to %s [delta: %s, bt=%s, spread: %s°]"
                            ):format(
                                target_name, wanted_hitgroup, miss_reason, delta, backtrack, spread
                            ) or ""
                        )

                        table.insert(sauron_text, {
                            text = text,
                            timer = GlobalVars.realtime,

                            smooth_y = screen_size.y + 100,
                            alpha = 0,
              
                            first_circle = 0,
                            second_circle = 0,
              
                            box_left = screen_size.x / 2,
                            box_right = screen_size.x / 2,
              
                            box_left_1 = screen_size.x / 2,
                            box_right_1 = screen_size.x / 2
                        })
                    end
                end
            end
        end,

        notifications = function(self)
            if menu_database.handler.elements["Enable indicator list"] then
                if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 7)) ~= 0 then
                    local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                    if not localplayer then return end
                  
                    local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                    if not my_index then return end

                    if EngineClient.IsConnected() and my_index:IsAlive() then
                        if anti_aimbotting_functions.anti_bruteforce.vars.phase_state then
                            table.insert(sauron_text, {
                                text = "Switched angle due to shot",

                                timer = GlobalVars.realtime,
                                smooth_y = screen_size.y + 100,
                                alpha = 0,
                  
                                first_circle = 0,
                                second_circle = 0,
                  
                                box_left = screen_size.x / 2,
                                box_right = screen_size.x / 2,
                  
                                box_left_1 = screen_size.x / 2,
                                box_right_1 = screen_size.x / 2
                            })
                          
                            anti_aimbotting_functions.anti_bruteforce.vars.phase_state = false
                        end

                        local y = screen_size.y - 100
                        for i, info in ipairs(sauron_text) do
                            if i > 3 then
                                table.remove(sauron_text, i)
                            end

                            if info.text ~= nil and info.text ~= "" then
                                local font = self.utils:get_font("Verdana", "12")
                                local text_size = Render.CalcTextSize(
                                    info.text,
                                    12,
                                    font
                                )

                                if info.timer + 3.8 < GlobalVars.realtime then
                                    info.first_circle = all_utils.easings.lerp(
                                        info.first_circle, 0, GlobalVars.frametime * 1
                                    )
                  
                                    info.second_circle = all_utils.easings.lerp(
                                        info.second_circle, 0, GlobalVars.frametime * 1
                                    )
                  
                                    info.box_left = all_utils.easings.lerp(
                                        info.box_left, screen_size.x / 2, GlobalVars.frametime * 1
                                    )
                  
                                    info.box_right = all_utils.easings.lerp(
                                        info.box_right, screen_size.x / 2, GlobalVars.frametime * 1
                                    )
                  
                                    info.box_left_1 = all_utils.easings.lerp(
                                        info.box_left_1, screen_size.x / 2, GlobalVars.frametime * 1
                                    )
                  
                                    info.box_right_1 = all_utils.easings.lerp(
                                        info.box_right_1, screen_size.x / 2, GlobalVars.frametime * 1
                                    )

                                    info.smooth_y = all_utils.easings.lerp(
                                        info.smooth_y,
                                        screen_size.y + 100,
                                        GlobalVars.frametime * 2
                                    )
              
                                    info.alpha = all_utils.easings.lerp(
                                        info.alpha,
                                        0,
                                        GlobalVars.frametime * 4
                                    )
                                else
                                    info.alpha = all_utils.easings.lerp(
                                        info.alpha,
                                        255,
                                        GlobalVars.frametime * 4
                                    )
                                  
                                    info.smooth_y = all_utils.easings.lerp(
                                        info.smooth_y,
                                        y,
                                        GlobalVars.frametime * 4
                                    )
  
                                    info.first_circle = all_utils.easings.lerp(
                                        info.first_circle, 275, GlobalVars.frametime * 5
                                    )
  
                                    info.second_circle = all_utils.easings.lerp(
                                        info.second_circle, -95, GlobalVars.frametime * 3
                                    )
  
                                    info.box_left = all_utils.easings.lerp(
                                        info.box_left, screen_size.x / 2 - text_size.x / 2 - 2, GlobalVars.frametime * 6
                                    )
  
                                    info.box_right = all_utils.easings.lerp(
                                        info.box_right, screen_size.x / 2 + text_size.x / 2 + 4, GlobalVars.frametime * 6
                                    )
  
                                    info.box_left_1 = all_utils.easings.lerp(
                                        info.box_left_1, screen_size.x / 2 - text_size.x / 2 - 2, GlobalVars.frametime * 6
                                    )
  
                                    info.box_right_1 = all_utils.easings.lerp(
                                        info.box_right_1, screen_size.x / 2 + text_size.x / 2 + 4, GlobalVars.frametime * 6
                                    )
                                end

                                local add_y = math.floor(info.smooth_y)
                                local alpha = math.floor(info.alpha)
              
                                local first_circle = math.floor(info.first_circle)
                                local second_circle = math.floor(info.second_circle)
              
                                local left_box = math.floor(info.box_left)
                                local right_box = math.floor(info.box_right)
              
                                local left_box_1 = math.floor(info.box_left_1)
                                local right_box_1 = math.floor(info.box_right_1)

                                local rgb = self.utils.hsv_to_rgb(GlobalVars.realtime / 4, 1, 1)
                                local second_gradient = Color.new(rgb.b, rgb.r, rgb.g, 1)
                                local third_gradient = Color.new(rgb.g, rgb.b, rgb.r, 1)

                                Render.BoxFilled(
                                    Vector2.new(screen_size.x / 2 - text_size.x / 2 - 13, add_y - 26),
                                    Vector2.new(screen_size.x / 2 + text_size.x / 2 + 13, add_y - 4),
                                    Color.RGBA(17, 17, 17, alpha - 65), 90
                                )
                              
                                Render.Circle(
                                    Vector2.new(screen_size.x / 2 - text_size.x / 2 - 4, add_y - 15),
                                    10, 90, second_gradient, 2, 90, first_circle
                                )

                                Render.Circle(
                                    Vector2.new(screen_size.x / 2 + text_size.x / 2 + 4, add_y - 15),
                                    10, 90, third_gradient, 2, 90, second_circle
                                )

                                for i = 1, 1 do
                                    for k = 1, 2 do
                                        Render.GradientBoxFilled(
                                            Vector2.new(left_box - 2, add_y - 7 + i),
                                            Vector2.new(screen_size.x / 2, add_y - 5.5 + i),
                                            second_gradient, second_gradient, second_gradient, second_gradient
                                        )

                                        Render.GradientBoxFilled(
                                            Vector2.new(right_box + 2, add_y - 7 + i),
                                            Vector2.new(screen_size.x / 2, add_y - 5.5 + i),
                                            third_gradient, second_gradient, third_gradient, second_gradient
                                        )
                                      
                                        Render.GradientBoxFilled(
                                            Vector2.new(screen_size.x / 2, add_y - 23 - i),
                                            Vector2.new(left_box_1 - 1, add_y - 25 - i),
                                            second_gradient, second_gradient, second_gradient, second_gradient
                                        )

                                        Render.GradientBoxFilled(
                                            Vector2.new(screen_size.x / 2, add_y - 23 - i),
                                            Vector2.new(right_box_1 + 1, add_y - 25 - i),
                                            second_gradient, third_gradient, second_gradient, third_gradient
                                        )
                                    end
                                end

                                self.utils.draw_shadow(
                                    0,
                                    info.text,
                                    screen_size.x / 2 - text_size.x / 2, add_y - 21,
                                    Color.RGBA(255, 255, 255, alpha),
                                    12, font,
                                    false, Color.RGBA(0, 0, 0, alpha)
                                )

                                y = y - 30
                                if info.timer + 4 < GlobalVars.realtime then table.remove(sauron_text, i) end
                            end
                        end
                    end
                end
            end
        end,

        keybind_modules = {
            vars = {
                keybinds_alpha = {},
                keybinds_y = {},

                width = 0,
                is_draggable = false,
                cursor_last_pos = Vector2.new(0, 0)
            }
        },

        keybinds = function(self)
            if menu_database.handler.elements["Enable keybinds"] then
                local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                if not localplayer then return end
              
                local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                if not my_index then return end

                if EngineClient.IsConnected() and my_index:IsAlive() then
                    local x = menu_database.handler.elements["Keybinds x-adding"]
                    local y = menu_database.handler.elements["Keybinds y-adding"]

                    local max_width = 0
                    local font = self.utils:get_font("Verdana", "11", "r")

                    local render_container = function(x, y, w)
                        local color = menu_database.handler.references["Keybinds color"].reference:Get()
                        local name_size = Render.CalcTextSize("keybinds", 11, font)

                        local height = 18
                        local line_height = 1.5
                  
                        local render_rounded_line = function()
                            Render.BoxFilled(
                                Vector2.new(x - 70, y),
                                Vector2.new(x + w, y + height),
                                Color.RGBA(17, 17, 17, math.floor(color.a * 255))
                            )

                            Render.Circle( -- right
                                Vector2.new(x + w - 4, y + line_height + 2),
                                5, 90, Color.new(color.r, color.g, color.b, 1), 2, 270, 370
                            )

                            Render.Circle( -- left
                                Vector2.new(x - 66, y + line_height + 2),
                                5, 90, Color.new(color.r, color.g, color.b, 1), 2, 270, 170
                            )

                            Render.BoxFilled(
                                Vector2.new(x - 66, y),
                                Vector2.new(x + w - 4, y - line_height - 0.5),
                                Color.new(color.r, color.g, color.b, 1)
                            )

                            Render.GradientBoxFilled(
                                Vector2.new(x + w - 0.2, y + 4),
                                Vector2.new(x + w + 1.5, y + 10),
                                Color.new(color.r, color.g, color.b, 1), Color.new(color.r, color.g, color.b, 1),
                                Color.new(color.r, color.g, color.b, 1), Color.new(color.r, color.g, color.b, 0.6)
                            )

                            Render.GradientBoxFilled(
                                Vector2.new(x - 69.8, y + 4),
                                Vector2.new(x - 71.5, y + 10),
                                Color.new(color.r, color.g, color.b, 1), Color.new(color.r, color.g, color.b, 1),
                                Color.new(color.r, color.g, color.b, 1), Color.new(color.r, color.g, color.b, 0.6)
                            )
                        end

                        render_rounded_line()
                        self.utils.draw_shadow(
                            2,
                            "keybinds",
                            x - 35 + w / 2 - name_size.x / 2, y + 2,
                            Color.RGBA(255, 255, 255, 255),
                            11, font,
                            false, Color.RGBA(0, 0, 0, 205)
                        )
                    end

                    local binds = Cheat.GetBinds()
                    local add_y = 0

                    for i = 1, #binds do
                        table.insert(self.keybind_modules.vars.keybinds_alpha, 0)
                        local bind = binds[i]

                        local yaw_base = Menu.FindVar("Aimbot", "Anti Aim", "Main", "Yaw Base"):Get()
                        local isFS = yaw_base == 5

                        local bind_name = bind:GetName()
                        bind_name = bind_name:gsub("Double Tap", "Double tap")
                        bind_name = bind_name:gsub("Fake Duck", "Duck peek assist")
                        bind_name = bind_name:gsub("Auto Peek", "Quick peek assist")
                        bind_name = isFS and bind_name:gsub("Yaw Base", "Freestanding") or bind_name:gsub("Yaw Base", "")

                        add_y = add_y + 13
                        if bind_name ~= "" then
                            if bind:IsActive() then
                                self.keybind_modules.vars.keybinds_alpha[i] = all_utils.easings.lerp(
                                    self.keybind_modules.vars.keybinds_alpha[i],
                                    255,
                                    GlobalVars.frametime * 8
                                )
                            else
                                self.keybind_modules.vars.keybinds_alpha[i] = all_utils.easings.lerp(
                                    self.keybind_modules.vars.keybinds_alpha[i],
                                    0,
                                    GlobalVars.frametime * 8
                                )
                            end

                            local render_binds = function(binds, name)
                                local bind_state = binds:GetMode() == 1 and "[holding]" or "[toggled]"
                                local bind_name = name

                                local bind_state_size = Render.CalcTextSize(bind_state, 11, font)
                                local bind_name_size = Render.CalcTextSize(bind_name, 11, font)

                                local smooth_alpha = math.floor(self.keybind_modules.vars.keybinds_alpha[i])
                                local width = math.floor(self.keybind_modules.vars.width)
                              
                                self.utils.draw_shadow(
                                    1,
                                    bind_name,
                                    x - 63, y + 7 + add_y,
                                    Color.RGBA(255, 255, 255, smooth_alpha),
                                    11, font,
                                    false, Color.RGBA(0, 0, 0, smooth_alpha - 50)
                                )

                                self.utils.draw_shadow(
                                    1,
                                    bind_state,
                                    x + (width - bind_state_size.x) - 5, y + 7 + add_y,
                                    Color.RGBA(255, 255, 255, smooth_alpha),
                                    11, font,
                                    false, Color.RGBA(0, 0, 0, smooth_alpha - 50)
                                )

                                local bind_width = bind_state_size.x + bind_name_size.x - 40
                                local length = 75
      
                                if bind_width > length then
                                    if bind_width > max_width then
                                        max_width = bind_width
                                    end
                                end
                            end
                            render_binds(bind, bind_name)
                        else
                            add_y = add_y - 13
                        end
                    end

                    self.keybind_modules.vars.width = math.max(75, max_width)
                    if not Cheat.IsMenuVisible() then
                        self.keybind_modules.vars.is_draggable = false
                    end

                    local width = math.floor(self.keybind_modules.vars.width)
                    if Cheat.IsMenuVisible() or #binds > 0 then
                        render_container(x, y, width, 18)
                        local mouse = Cheat.GetMousePos()

                        if Cheat.IsKeyDown(0x1) then
                            if not self.keybind_modules.vars.is_draggable then
                                if mouse.x >= x - 70 and mouse.y >= y and mouse.x <= x + width and mouse.y <= y + 18 then
                                    self.keybind_modules.vars.is_draggable = true
                                end
                            else
                                local x_pos = x + (mouse.x - self.keybind_modules.vars.cursor_last_pos.x)
                                local y_pos = y + (mouse.y - self.keybind_modules.vars.cursor_last_pos.y)

                                menu_database:set_value("Keybinds x-adding", math.floor(x_pos))
                                menu_database:set_value("Keybinds y-adding", math.floor(y_pos))
                            end
                        else
                            self.keybind_modules.vars.is_draggable = false
                        end

                        self.keybind_modules.vars.cursor_last_pos = mouse
                    end
                end
            end
        end,

        solus_watermark_modules = {
            vars = {
                width = 0,

                current_time = GlobalVars.curtime,
                current_fps = 0,

                is_draggable = false,
                cursor_last_pos = Vector2.new(0, 0)
            }
        },

        fps_counter = 0,
        solus_watermark = function(self)
            if menu_database.handler.elements["Enable watermark"] then
                local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                if not localplayer then return end
              
                local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                if not my_index then return end

                if EngineClient.IsConnected() and my_index:IsAlive() then
                    local x = menu_database.handler.elements["Watermark x-adding"]
                    local y = menu_database.handler.elements["Watermark y-adding"]

                    local utils = {
                        get_ping = function()
                            local netchann_info = EngineClient.GetNetChannelInfo()
                            if not netchann_info then return "0" end
      
                            local latency = netchann_info:GetLatency(0)
                            return string.format("%1.f", math.max(0.0, latency) * 1000.0)
                        end,
      
                        get_current_time = function()
                            local seconds = math.floor(Utils.UnixTime() / 1000)
                            local hours = math.floor((seconds / 3600 + 3) % 24)
                            local minutes = math.floor(seconds / 60 % 60)

                            return string.format("%02d:%02d:%02d", hours, minutes, (seconds % 60))
                        end,

                        get_ticks = function()
                            return math.floor(1.0 / GlobalVars.interval_per_tick)
                        end,

                        get_fps = function()
                            local get_fps = function()
                                self.fps_counter = 0.9 * self.fps_counter + (1.0 - 0.9) * GlobalVars.absoluteframetime
                                return math.floor((1.0 / self.fps_counter) + 0.5)
                            end

                            local current_fps = get_fps()
                            if self.solus_watermark_modules.vars.current_time + 0.3 < GlobalVars.curtime then
                                self.solus_watermark_modules.vars.current_fps = current_fps
                                self.solus_watermark_modules.vars.current_time = GlobalVars.curtime
                            end
      
                            return self.solus_watermark_modules.vars.current_fps
                        end
                    }

                    local max_width = 0
                    local font = self.utils:get_font("Verdana", "11", "r")

                    local name = Cheat.GetCheatUserName()
                    local ticks = utils.get_ticks()
                    local fps = utils.get_fps()
                    local ping = utils.get_ping()
                    local time = utils.get_current_time()

                    local render_container = function()
                        local text = ("%s  %s fps  delay: %sms  %s tick  %s"):format(name, fps, ping, ticks, time)
                        local text_size = Render.CalcTextSize(text, 11, font)

                        local color = menu_database.handler.references["Watermark color"].reference:Get()
                        local width = self.solus_watermark_modules.vars.width
                        local start_position = x - 22

                        local render_rounded_line = function()
                            Render.BoxFilled(
                                Vector2.new(start_position, y - 8),
                                Vector2.new(x + width + 53, y + text_size.y - 2),
                                Color.RGBA(17, 17, 17, 85), 10
                            )

                            Render.BoxFilled(
                                Vector2.new(start_position + 4, y - 10),
                                Vector2.new(x + width + 47, y + text_size.y - 19),
                                color
                            )

                            Render.GradientBoxFilled(
                                Vector2.new(x + width + 50.8, y + text_size.y - 15),
                                Vector2.new(x + width + 52.4, y + text_size.y - 8),
                                color, Color.new(color.r, color.g, color.b, 1),
                                color, Color.new(color.r, color.g, color.b, 0.6)
                            )

                            Render.GradientBoxFilled(
                                Vector2.new(start_position, y + text_size.y - 15),
                                Vector2.new(start_position - 1.7, y + text_size.y - 8),
                                color, color,
                                color, Color.new(color.r, color.g, color.b, color.a - 0.4)
                            )

                            Render.Circle( -- right
                                Vector2.new(x + width + 47, y + text_size.y - 15.2),
                                5, 90, color, 2, 270, 370
                            )

                            Render.Circle( -- left
                                Vector2.new(start_position + 4, y + text_size.y - 15.2),
                                5, 90, color, 2, 270, 170
                            )
                        end

                        render_rounded_line()
                        self.utils.draw_shadow(
                            2,
                            "half",
                            x - 18, y - 6,
                            color,
                            11, font,
                            false, Color.RGBA(0, 0, 0, 205)
                        )

                        self.utils.draw_shadow(
                            2,
                            "-life [beta]",
                            x, y - 6,
                            Color.RGBA(255, 255, 255, 255),
                            11, font,
                            false, Color.RGBA(0, 0, 0, 205)
                        )

                        self.utils.draw_shadow(
                            2,
                            text,
                            x + 57, y - 6,
                            Color.RGBA(255, 255, 255, 255),
                            11, font,
                            false, Color.RGBA(0, 0, 0, 205)
                        )

                        local max_width = 0
                        local text_width = text_size.x + 10
          
                        if text_width > 5 then
                            if text_width > max_width then
                                max_width = text_width
                            end
                        end

                        self.solus_watermark_modules.vars.width = math.max(5, max_width)
                    end

                    render_container()
                    if Cheat.IsMenuVisible() then
                        local mouse = Cheat.GetMousePos()
                        local width = math.floor(self.solus_watermark_modules.vars.width)

                        if Cheat.IsKeyDown(0x1) then
                            if not self.solus_watermark_modules.vars.is_draggable then
                                if mouse.x >= x and mouse.y >= y - 10 and mouse.x <= x + width and mouse.y <= y + 11 then
                                    self.solus_watermark_modules.vars.is_draggable = true
                                end
                            else
                                local x_pos = x + (mouse.x - self.solus_watermark_modules.vars.cursor_last_pos.x)
                                local y_pos = y + (mouse.y - self.solus_watermark_modules.vars.cursor_last_pos.y)

                                menu_database:set_value("Watermark x-adding", math.floor(x_pos))
                                menu_database:set_value("Watermark y-adding", math.floor(y_pos))
                            end
                        else
                            self.solus_watermark_modules.vars.is_draggable = false
                        end
                        self.solus_watermark_modules.vars.cursor_last_pos = mouse
                    end
                else
                    self.solus_watermark_modules.vars.current_time = GlobalVars.curtime
                end
            else
                self.solus_watermark_modules.vars.current_time = GlobalVars.curtime
            end
        end,

        weapons_in_scope = function(self)
            if menu_database.handler.elements["Enable weapons in scope"] then
                local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                if not localplayer then return end
              
                local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                if not my_index then return end

                if EngineClient.IsConnected() and my_index:IsAlive() then
                    local is_scoped = my_index:GetProp("m_bIsScoped")
                    if is_scoped then
                        if Menu.FindVar("Visuals", "View", "Thirdperson", "Enable Thirdperson"):GetBool() then
                            CVar.FindVar("fov_cs_debug"):SetInt(0)
                        else
                            CVar.FindVar("fov_cs_debug"):SetInt(90)
                        end
                    else
                        CVar.FindVar("fov_cs_debug"):SetInt(0)
                    end
                end
            else
                CVar.FindVar("fov_cs_debug"):SetInt(0)
            end
        end,

        damage_markers = {
            particles = {},
            hitmarkers = {},

            on_registered_shot = function(self, shot)
                if menu_database.handler.elements["Enable indicator list"] then
                    if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 8)) ~= 0 then
                        local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                        if not localplayer then return end
                      
                        local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                        if not my_index then return end

                        if EngineClient.IsConnected() and my_index:IsAlive() then
                            local index = EntityList.GetClientEntity(shot.target_index)
                            if not index then return end

                            local get_player = index:GetPlayer()
                            if not get_player then return end

                            if shot.reason == 0 then
                                local damage = shot.damage
                                if damage < 1 then return end

                                local bullet_position = get_player:GetHitboxCenter(shot.hitgroup)
                                if not bullet_position then
                                    bullet_position = get_player:GetRenderOrigin()
                                    bullet_position.y = bullet_position.y + 30
                                end
                              
                                bullet_position.x = (bullet_position.x - 10) + (math.random() * 20)
                                bullet_position.y = (bullet_position.y - 10) + (math.random() * 20)
                                bullet_position.z = (bullet_position.z - 15) + (math.random() * 30)

                                table.insert(self.particles, {
                                    position = bullet_position,
                                    timer = GlobalVars.tickcount + 80,
                                    damage = damage,
                                    is_killed = get_player:GetProp("m_iHealth") - damage <= 0 and true or false
                                })

                                table.insert(self.hitmarkers, {
                                    position = get_player:GetHitboxCenter(shot.hitgroup),
                                    timer = GlobalVars.realtime,
                                    alpha = 0,
                                })
                            end
                        end
                    end
                end
            end,

            move_position = function(self)
                if menu_database.handler.elements["Enable indicator list"] then
                    if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 8)) ~= 0 then
                        if #self.particles > 0 then
                            for k, information in pairs(self.particles) do
                                local delta = information.timer - GlobalVars.tickcount
                                if delta > 0 then
                                    information.position.z = information.position.z + 0.3
                                end
                            end
                        end
                    end
                end
            end,

            on_round_prestart = function(self, e)
                if e:GetName() ~= "round_prestart" then return end
                self.particles = {}
                self.hitmarkers = {}
            end,

            on_self_connected = function(self, e)
                if e:GetName() ~= "player_connect_full" then return end
                self.particles = {}
                self.hitmarkers = {}
            end,

            load_markers_modules = function(self, e)
                self:on_round_prestart(e)
                self:on_self_connected(e)
            end
        },

        draw_damage_markers = function(self)
            if menu_database.handler.elements["Enable indicator list"] then
                local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                if not localplayer then return end
              
                local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                if not my_index then return end

                if EngineClient.IsConnected() and my_index:IsAlive() then
                    if bit.band(menu_database.handler.elements["Indicator list"], bit.lshift(1, 8)) ~= 0 then
                        if #self.damage_markers.particles > 0 then
                            for k, information in ipairs(self.damage_markers.particles) do
                                if information.position and information.timer and (information.damage and information.damage > 0) then
                                    local position = Render.WorldToScreen(information.position)
                                    local time = math.floor(information.timer - GlobalVars.tickcount)
                                  
                                    if time > 255 then time = 255 end
                                    if (not(time < 0)) then
                                        local damage = information.damage .. ""
                                        local color = information.is_killed and Color.RGBA(255, 236, 132, 255) or Color.RGBA(255, 255, 255, 255)
                                        color.a = time

                                        local font = self.utils:get_font("Tahoma", "10")
                                        self.utils.draw_shadow(
                                            1,
                                            damage,
                                            position.x, position.y,
                                            color,
                                            10, font,
                                            false, Color.RGBA(0, 0, 0, 255)
                                        )
                                    end
                                end
                            end
                        end
                      
                        if #self.damage_markers.hitmarkers > 0 then
                            for k, information in ipairs(self.damage_markers.hitmarkers) do
                                if information.position and information.timer and information.alpha then
                                    local position = Render.WorldToScreen(information.position)
                                    if information.timer + 4 < GlobalVars.realtime then
                                        information.alpha = math.max(0, information.alpha - 2)
                                    else
                                        information.alpha = math.min(information.alpha + 3, 255)
                                    end

                                    local alpha = math.floor(information.alpha)
                                    local current_size = menu_database.handler.elements["Hitmarker size"]
                                    local current_mode = menu_database.handler.elements["Hitmarker mode"]

                                    local current_color = menu_database.handler.references["Hitmarker color"].reference:Get()
                                    local color = Color.new(current_color.r, current_color.g, current_color.b, alpha / 255)

                                    if current_mode == 0 then
                                        Render.Line(Vector2.new(position.x, position.y - current_size), position, color)
                                        Render.Line(Vector2.new(position.x - current_size, position.y), position, color)
                                        Render.Line(Vector2.new(position.x, position.y + current_size), position, color)
                                        Render.Line(Vector2.new(position.x + current_size, position.y), position, color)
                                    else
                                        Render.Line(position, Vector2.new(position.x - current_size, position.y - current_size), color)
                                        Render.Line(position, Vector2.new(position.x - current_size, position.y + current_size), color)
                                        Render.Line(position, Vector2.new(position.x + current_size, position.y + current_size), color)
                                        Render.Line(position, Vector2.new(position.x + current_size, position.y - current_size), color)
                                    end

                                    if information.timer + 5 < GlobalVars.realtime then
                                        table.remove(self.damage_markers.hitmarkers, k)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end,

        scope_cache = false,
        scope_time = 0,

        custom_scope = function(self)
            if menu_database.handler.elements["Enable custom scope"] then
                local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                if not localplayer then return end
              
                local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                if not my_index then return end

                if EngineClient.IsConnected() and my_index:IsAlive() then
                    if not self.scope_cache then self.scope_cache = true end
                    local is_scoped = my_index:GetProp("m_bIsScoped")

                    if is_scoped then
                        Menu.FindVar("Visuals", "View", "Camera", "Remove Scope"):SetInt(2)

                        local initial_position = menu_database.handler.elements["Custom scope initial position"]
                        local offset = menu_database.handler.elements["Custom scope offset"]

                        if self.scope_time < initial_position / 2 + offset then
                            self.scope_time = self.scope_time + 100
                        else
                            self.scope_time = initial_position / 2 + offset
                        end

                        local color = menu_database.handler.references["Enable custom scope"].reference:GetColor()
                        local col = Color.new(color.r, color.g, color.b, 0.05)
                        local first_col = (function(a, b) if initial_position <= 30 then return b else return a end end)(color, col)
                        local second_col = (function(a, b) if initial_position <= 30 then return a else return b end end)(color, col)
                        local alpha_time = self.scope_time
                      
                        Render.GradientBoxFilled(
                            Vector2.new(screen_size.x / 2 - 0.1, screen_size.y / 2 - math.min(initial_position, alpha_time)),
                            Vector2.new(
                                screen_size.x / 2 + 1,
                                screen_size.y / 2 - math.min(initial_position, alpha_time) - math.min(offset, alpha_time)
                            ),
                            second_col, second_col,
                            first_col, first_col
                        ) -- upper

                        Render.GradientBoxFilled(
                            Vector2.new(screen_size.x / 2 - math.min(initial_position, alpha_time), screen_size.y / 2 - 0.1),
                            Vector2.new(
                                screen_size.x / 2 - math.min(initial_position, alpha_time) - math.min(offset, alpha_time),
                                screen_size.y / 2 + 1
                            ),
                            second_col, first_col,
                            second_col, first_col
                        ) -- left

                        Render.GradientBoxFilled(
                            Vector2.new(screen_size.x / 2 - 0.1, screen_size.y / 2 + math.min(initial_position, alpha_time)),
                            Vector2.new(
                                screen_size.x / 2 + 1,
                                screen_size.y / 2  + math.min(initial_position, alpha_time) + math.min(offset, alpha_time)
                            ),
                            second_col, second_col,
                            first_col, first_col
                        ) -- down

                        Render.GradientBoxFilled(
                            Vector2.new(screen_size.x / 2 + math.min(initial_position, alpha_time), screen_size.y / 2 - 0.1),
                            Vector2.new(
                                screen_size.x / 2  + math.min(initial_position, alpha_time) + math.min(offset, alpha_time),
                                screen_size.y / 2 + 1
                            ),
                            second_col, first_col,
                            second_col, first_col
                        ) -- right
                    else
                        if self.scope_time > 0 then
                            self.scope_time = self.scope_time - 100
                        else
                            self.scope_time = 0
                        end
                    end
                else
                    if self.scope_cache then
                        Menu.FindVar("Visuals", "View", "Camera", "Remove Scope"):SetInt(1)
                        self.scope_cache = false
                    end
                end
            else
                if self.scope_cache then
                    Menu.FindVar("Visuals", "View", "Camera", "Remove Scope"):SetInt(1)
                    self.scope_cache = false
                end
            end
        end,

        peek_arrows = function(self)
            if menu_database.handler.elements["Enable peek arrows"] then
                local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                if not localplayer then return end
              
                local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                if not my_index then return end

                if EngineClient.IsConnected() and my_index:IsAlive() then
                    local font = self.utils:get_font("Verdana", "21", "b")
                    local color = menu_database.handler.references["Enable peek arrows"].reference:GetColor()
                    local inverted = AntiAim.GetInverterState()

                    self.utils.draw_shadow(
                        3,
                        ">",
                        screen_size.x / 2 + 50, screen_size.y / 2 - 12,
                        inverted and color or Color.RGBA(255, 255, 255, 255),
                        21, font,
                        false, Color.RGBA(0, 0, 0, 170)
                    )

                    self.utils.draw_shadow(
                        3,
                        "<",
                        screen_size.x / 2 - 65, screen_size.y / 2 - 12,
                        not inverted and color or Color.RGBA(255, 255, 255, 255),
                        21, font,
                        false, Color.RGBA(0, 0, 0, 170)
                    )
                end
            end
        end,

        load_indicators = function(self)
            self:under_crosshair()
            self:watermark()
            self:minimum_damage()
            self:skeet_autopeek()
            self:side_skeet_indicators()
            self:thirdperson_animations()
            self:crosshair_hitmarker()
            self:on_script_start()
            self:hitlogs()
            self:notifications()
            self:keybinds()
            self:solus_watermark()
            self:weapons_in_scope()
            self.damage_markers:move_position()
            self:draw_damage_markers()
            self:custom_scope()
            self:peek_arrows()
        end
    }
    -- @endregion

    -- @region: all miscellaneous functions
    local miscellaneous_functions = {
        trashtalk = function(e)
            if menu_database.handler.elements["Enable trashtalk"] then
                local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                if not localplayer then return end
              
                local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                if not my_index then return end

                if EngineClient.IsConnected() then
                    if e:GetName() ~= "player_death" then return end
              
                    local me = EntityList.GetLocalPlayer()
                    local victim = EntityList.GetPlayerForUserID(e:GetInt("userid"))
                    local attacker = EntityList.GetPlayerForUserID(e:GetInt("attacker"))
                    if victim == attacker or attacker ~= me then return end

                    local phrases = {
                        "Найс дед скачай конфиг от алексбомбера",
                        "Made your mom proud,at payhip.com/Ivanovo", "Прости shoppy.gg/@Ivanovo",
                        "Ничего страшного ты  хорошо играешь",
                        "Мне друг (витма) (бигнейм) сказал в таких случаях 1 писать но я добрый так что не буду",
                        "Блин друг прости пожалуйста не увидел",
                        "Я с конфигом от кеннеди",
                        "Была бы газелька с салом выиграл бы",
                        "Ты все равно лучше меня не расстраивайся",
                        "Опять ты, прости я без ников убил",
                        "Нифига смачный бектрек", "Был бы пелучкорд тапнул бы",
                        "Сори что убил я просто отвернулся и не увидел",
                        "laff u suck AHAHAHAHAAH",
                        "Посаны а как вам микрофон яспер мо о глод у фипа такой вроде",
                        "Какой у тебя мейн Ник ? Мне сказали это важна чтоб медия сделать, ты витма ?",
                        "by Kennedy hvh boss", "спать покемон ушастый"
                    }

                    local get_phrase = phrases[Utils.RandomInt(1, #phrases)]:gsub('\"', '')
                    EngineClient.ExecuteClientCmd((' say "%s"'):format(get_phrase))
                end
            end
        end,

        hitsounds = function(self, e)
            if menu_database.handler.elements["Enable hitsounds"] then
                local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
                if not localplayer then return end
              
                local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
                if not my_index then return end

                if EngineClient.IsConnected() then
                    if e:GetName() ~= "player_hurt" then return end

                    local attacker = EntityList.GetPlayerForUserID(e:GetInt("attacker"))
                    if attacker == my_index then
                        local file_name = menu_database.handler.references["Hitsound"].reference:Get()
                        local path = ("playvol %s %s"):format(file_name, "0.8")

                        EngineClient.ExecuteClientCmd(path)
                    end
                end
            end
        end
    }
    -- @endregion

    -- @region: animation breaker
    local hooked_function = nil
    local is_jumping = false

    local updateCSA = function(thisptr, edx)
        local is_localplayer = ffi.cast("uintptr_t", thisptr) == get_entity_address(EngineClient.GetLocalPlayer())
        hooked_function(thisptr, edx)
      
        if is_localplayer then
            if menu_database.handler.elements["Enable anim breakers"] then
                local addons = menu_database.handler.elements["Anim breakers"]
                if bit.band(addons, bit.lshift(1, 0)) ~= 0 then
                    local static_legs_value = menu_database.handler.elements["Static legs timer"]
                    ffi.cast("float*", ffi.cast("uintptr_t", thisptr) + 10104)[6] = static_legs_value
                end

                if bit.band(addons, bit.lshift(1, 1)) ~= 0 then
                    local leg_breaker_value = menu_database.handler.elements["Leg fucker type"]
                    ffi.cast("float*", ffi.cast("uintptr_t", thisptr) + 10104)[0] = leg_breaker_value == 0 and 1 or (
                        GlobalVars.tickcount % 4 == 0 and 0.5 or 0
                    )
                end

                if bit.band(addons, bit.lshift(1, 2)) ~= 0 then
                    if ffi.cast("CCSGOPlayerAnimationState_534535_t**", ffi.cast("uintptr_t", thisptr) + 0x9960)[0].bHitGroundAnimation then
                        if not is_jumping then
                            ffi.cast("float*", ffi.cast("uintptr_t", thisptr) + 10104)[12] = 0.5
                        end
                    end
                end
            end
        end
    end

    local breaker_functions = {
        on_pre_prediction = function(cmd)
            is_jumping = bit.band(cmd.buttons, bit.lshift(1, 1)) ~= 0
        end,

        on_create_move = function()
            local local_player = EntityList.GetLocalPlayer()
            if not local_player then return end
          
            local local_player_ptr = get_entity_address(local_player:EntIndex())
            if not local_player_ptr or hooked_function then return end

            local C_CSPLAYER = vmt_hook.new(local_player_ptr)
            hooked_function = C_CSPLAYER.hookMethod("void(__fastcall*)(void*, void*)", updateCSA, 224)
        end,

        on_destroy = function()
            for i, unHookFunc in ipairs(vmt_hook.hooks) do
                unHookFunc()
            end
      
            for i, free in ipairs(buff.free) do
                free()
            end
        end,

        on_prediction = function(cmd)
            local localplayer = EntityList.GetClientEntity(EngineClient.GetLocalPlayer())
            if not localplayer then return end
          
            local my_index = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
            if not my_index then return end

            if EngineClient.IsConnected() and my_index:IsAlive() then
                if menu_database.handler.elements["Enable anim breakers"] then
                    local addons = menu_database.handler.elements["Anim breakers"]
                    if bit.band(addons, bit.lshift(1, 1)) ~= 0 then
                        local directory = Menu.FindVar("Aimbot", "Anti Aim", "Misc", "Leg Movement")
                        directory:Set(cmd.command_number % 3 == 0 and 0 or 1)
                    end
                end
            end
        end
    }
    -- @endregion

    -- @region: all callbacks
    local all_callbacks = {
        on_prediction = function(cmd)
            ragebot_functions:load_ragebot_functions(cmd)
            anti_aimbotting_functions:load_anti_aimbotting_functions(cmd)
            breaker_functions.on_prediction(cmd)
        end,

        on_events = function(e)
            ragebot_functions.dormant_aimbot:reset_data(e)
            anti_aimbotting_functions.anti_bruteforce:run_work(e)
            anti_aimbotting_functions.bombsite_fix:check_bombsite(e)

            visual_functions.watermark_modules:count_hurt_shots(e)
            visual_functions.hitlog_modules:get_addictional_hits(e)
            visual_functions.damage_markers:load_markers_modules(e)
            visual_functions.skeet_modules.vars.bomb_info:load_bomb_modules(e)

            miscellaneous_functions.trashtalk(e)
            miscellaneous_functions:hitsounds(e)
        end,

        on_draw = function()
            visual_functions:load_indicators()
            anti_aimbotting_functions:run_main_anti_aim()
        end,

        on_pre_prediction = function(cmd)
            breaker_functions.on_pre_prediction(cmd)
            anti_aimbotting_functions.roll_angles:on_pre_prediction(cmd)
        end,

        on_registered_shot = function(shot)
            visual_functions.hitmarker_modules:on_registered_shot(shot)
            visual_functions.hitlog_modules:on_registered_shot(shot)
            visual_functions:execute_sauron_shots(shot)
            visual_functions.damage_markers:on_registered_shot(shot)
            visual_functions.skeet_modules.vars.shot_stats:count_shots(shot)
        end,

        on_destroy = function()
            breaker_functions.on_destroy()
        end,

        on_create_move = function(cmd)
            breaker_functions.on_create_move()
            anti_aimbotting_functions.roll_angles:on_createmove(cmd)
        end,

        load_callbacks = function(self)
            Cheat.RegisterCallback("prediction", self.on_prediction)
            Cheat.RegisterCallback("createmove", self.on_create_move)
            Cheat.RegisterCallback("pre_prediction", self.on_pre_prediction)
            Cheat.RegisterCallback("events", self.on_events)
            Cheat.RegisterCallback("draw", self.on_draw)
            Cheat.RegisterCallback("registered_shot", self.on_registered_shot)
            Cheat.RegisterCallback("destroy", self.on_destroy)
        end
    }

    all_callbacks:load_callbacks()
    -- @endregion
end

--[[
    if __name__ == "__main__":
        __main__
    O_O O_O O_O O_O O_O O_O O_O O_O
--]]

__main__()
