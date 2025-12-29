local IconLibrary = {}
IconLibrary.__index = IconLibrary

local ICONS_URL = "https://raw.githubusercontent.com/TekScripts/TekUix/refs/heads/main/src/utils/LucideIcons.lua"
local CACHE_FOLDER = "TekIconsCache"

local RAM_CACHE = {} 
local TTL_MEMO = {}

local TTL_MULT = { s = 1, m = 60, d = 86400 }

local function parseTTL(ttlStr)
    if TTL_MEMO[ttlStr] then return TTL_MEMO[ttlStr] end
    
    local v, u = ttlStr:match("^(%d+)([smd])$")
    local result = (v and u) and (tonumber(v) * TTL_MULT[u]) or 86400
    
    TTL_MEMO[ttlStr] = result
    return result
end

function IconLibrary:Init()
    if not isfolder(CACHE_FOLDER) then
        makefolder(CACHE_FOLDER)
        return
    end

    local now = os.time()
    local files = listfiles(CACHE_FOLDER)

    for _, path in ipairs(files) do
        local name, size, created, ttlStr = path:match("([^/]+)__(%d+)__(%d+)__(%w+)%.png$")
        
        if created and ttlStr then
            local expiryTime = parseTTL(ttlStr)
            if (now - tonumber(created)) < expiryTime then
                RAM_CACHE[name:lower()] = { path = path, expires = tonumber(created) + expiryTime }
            else
                pcall(delfile, path)
            end
        else
            pcall(delfile, path)
        end
    end
end

local function fetchIcons()
    local success, content = pcall(game.HttpGet, game, ICONS_URL)
    if not success then return {} end
    
    local fn, err = loadstring(content)
    if not fn then warn("IconLibrary: Erro no parse remoto:", err) return {} end
    
    local Icons = fn()
    local Normalized = {}
    for name, data in pairs(Icons) do
        Normalized[name:lower()] = data
    end
    return Normalized
end

local Icons = fetchIcons()

function IconLibrary:GetIcon(params)
    local iconName = (params.Icon or ""):lower()
    local ttlStr = params.Expire or "24h"
    local now = os.time()
    
    if RAM_CACHE[iconName] then
        local entry = RAM_CACHE[iconName]
        if now < entry.expires then
            return getcustomasset(entry.path)
        else
            RAM_CACHE[iconName] = nil
        end
    end

    local iconData = Icons[iconName]
    if not iconData then return nil, "Icon not found" end

    local fileName = string.format(
        "%s/%s__%d__%d__%s.png",
        CACHE_FOLDER,
        iconName,
        iconData.size or 24,
        now,
        ttlStr
    )

    local success, bin = pcall(crypt.base64decode, iconData.data)
    if success then
        writefile(fileName, bin)
        
        RAM_CACHE[iconName] = { 
            path = fileName, 
            expires = now + parseTTL(ttlStr) 
        }
        
        return getcustomasset(fileName)
    end
    
    return nil, "Failed to process icon"
end

IconLibrary:Init()

return IconLibrary
