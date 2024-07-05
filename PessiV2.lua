--all credits to me and phobos (Very Based) thanks for making the code more optimized and make it looks better :)

local TransactionManager <const> = {};
TransactionManager.__index = TransactionManager

function TransactionManager.new()
    local instance = setmetatable({}, TransactionManager);

    instance.Transactions = {
        {label = "15M (Bend Job Limited)", hash = 0x176D9D54},
        {label = "15M (Bend Bonus Limited)", hash = 0xA174F633},
        {label = "7M (Gang Money Limited)", hash = 0xED97AFC1},
        {label = "3.6M (Casino Heist Money Limited)", hash = 0xB703ED29},
        {label = "2.5M (Gang Money Limited)", hash = 0x46521174},
        {label = "2.5M (Island Heist Money Limited)", hash = 0xDBF39508},
        {label = "2M (Heist Awards Money Limited)", hash = 0x8107BB89},
        {label = "2M (Tuner Robbery Money Limited)", hash = 0x921FCF3C},
        {label = "2M (Business Hub Money Limited)", hash = 0x4B6A869C},
        {label = "1M (Avenger Operations Money Limited)", hash = 0xE9BBC247},
        {label = "1M (Daily Objective Event Money Limited)", hash = 0x314FB8B0},
        {label = "1M (Daily Objective Money Limited)", hash = 0xBFCBE6B6},
        {label = "680K (Betting Money Limited)", hash = 0xACA75AAE},
        {label = "500K (Juggalo Story Money Limited)", hash = 0x05F2B7EE},
        {label = "310K (Vehicle Export Money Limited)", hash = 0xEE884170},
        {label = "200K (DoomsDay Finale Bonus Money Limited)", hash = 0xBA16F44B},
        {label = "200K (Action Figures Money Limited)",  hash = 0x9145F938},
        {label = "200K (Collectibles Money Limited)",    hash = 0xCDCF2380},
        {label = "190K (Vehicle Sales Money Limited)",   hash = 0xFD389995}
    }

    return instance;
end

---@return Table TransactionList
function TransactionManager:GetTransactionList()
    return self.Transactions;
end

---@return Int32 character
function TransactionManager:GetCharacter()
    local _, char = STATS.STAT_GET_INT(joaat("MPPLY_LAST_MP_CHAR"), 0, 1)
    return tonumber(char);
end

---@param Int32 hash 
---@param Int32 category
---@return Int32 price
function TransactionManager:GetPrice(hash, category)
    return tonumber(NETSHOPPING.NET_GAMESERVER_GET_PRICE(hash, category, true))
end

---@param Int32 hash 
---@param? Int32 amount 
function TransactionManager:TriggerTransaction(hash, amount)
    local troonsaction_global = 4537311
    globals.set_int(troonsaction_global + 1, 2147483646)
    globals.set_int(troonsaction_global + 7, 2147483647)
    globals.set_int(troonsaction_global + 6, 0)
    globals.set_int(troonsaction_global + 5, 0)
    globals.set_int(troonsaction_global + 3, hash)
    globals.set_int(troonsaction_global + 2, amount or self:GetPrice(hash, 0x57DE404E))
    globals.set_int(troonsaction_global, 1)
end

function TransactionManager:Init()
    local network           = gui.get_tab("GUI_TAB_NETWORK")
    local tab               = network:add_tab("Pessi")
    tab:add_text('Use at your own risk!\r\nThis can get you banned.')
    local checkboxwb        = tab:add_checkbox("Transfer Wallet Money To Bank")
    local checkbox180k      = tab:add_checkbox("180K Loop")
    local sameline          = tab:add_sameline()
    local checkbox50k       = tab:add_checkbox("50K Loop")

    script.register_looped("180ktransaction", function(script)
        if checkbox180k:is_enabled() then
            self:TriggerTransaction(0x615762F1)
        end
    end)
    
    script.register_looped("50ktransaction", function(script)
        if(checkbox50k:is_enabled()) then
            self:TriggerTransaction(0x610F9AB4)
        end
    end)
    
    
    script.register_looped("walletbank", function(script)
        if(checkboxwb:is_enabled()) then
            NETSHOPPING.NET_GAMESERVER_TRANSFER_WALLET_TO_BANK(self:GetCharacter(), MONEY.NETWORK_GET_VC_WALLET_BALANCE(self:GetCharacter()))
        end
    end)
    
    for _, stealth in ipairs(self:GetTransactionList()) do
        tab:add_button(stealth.label, function()
            self:TriggerTransaction(stealth.hash)
        end)
    end    
end


TransactionManager.new():Init()