require 'config'
require 'lib'

rulematch = ngx.re.find
unescape = ngx.unescape_uri

function white_ip_check()
     if config_white_ip_check == "on" then
        IP_WHITE_RULE = get_rule('whiteip.rule')
        WHITE_IP = get_client_ip()
        if IP_WHITE_RULE ~= nil then
            for _,rule in pairs(IP_WHITE_RULE) do
                if rule ~= "" and rulematch(WHITE_IP,rule,"jo") then
                    log_record('White_IP',ngx.var_request_uri,"_","_")
                    return true
                end
            end
        end
    end
end

function black_ip_check()
     if config_black_ip_check == "on" then
        IP_BLACK_RULE = get_rule('blackip.rule')
        BLACK_IP = get_client_ip()
        if IP_BLACK_RULE ~= nil then
            for _,rule in pairs(IP_BLACK_RULE) do
                if rule ~= "" and rulematch(BLACK_IP,rule,"jo") then
                    log_record('BlackList_IP',ngx.var_request_uri,"_","_")
                    if config_waf_enable == "on" then
                        ngx.exit(403)
                        return true
                    end
                end
            end
        end
    end
end

function white_url_check()
    if config_white_url_check == "on" then
        URL_WHITE_RULES = get_rule('whiteurl.rule')
        REQ_URI = ngx.var.request_uri
        if URL_WHITE_RULES ~= nil then
            for _,rule in pairs(URL_WHITE_RULES) do
                if rule ~= "" and rulematch(REQ_URI,rule,"jo") then
                    return true
                end
            end
        end
    end
end

function cc_attack_check()
    if config_cc_check == "on" then
        ATTACK_URI=ngx.var.uri
        CC_TOKEN = get_client_ip()..ATTACK_URI
        limit = ngx.shared.limit
        CCcount=tonumber(string.match(config_cc_rate,'(.*)/'))
        CCseconds=tonumber(string.match(config_cc_rate,'/(.*)'))
        req,_ = limit:get(CC_TOKEN)
        if req then
            if req > CCcount then
                log_record('CC_Attack',ngx.var.request_uri,"-","-")
                if config_waf_enable == "on" then
                    ngx.exit(403)
                end
            else
                limit:incr(CC_TOKEN,1)
            end
        else
            limit:set(CC_TOKEN,1,CCseconds)
        end
    end
    return false
end

function cookie_attack_check()
    if config_cookie_check == "on" then
        COOKIE_RULES = get_rule('cookie.rule')
        USER_COOKIE = ngx.var.http_cookie
        if USER_COOKIE ~= nil then
            for _,rule in pairs(COOKIE_RULES) do
                if rule ~="" and rulematch(USER_COOKIE,rule,"jo") then
                    log_record('Deny_Cookie',ngx.var.request_uri,"-",rule)
                    if config_waf_enable == "on" then
                        waf_output()
                        return true
                    end
                end
             end
        end
    end
    return false
end

function url_attack_check()
    if config_url_check == "on" then
        URL_RULES = get_rule('url.rule')
        REQ_URI = ngx.var.request_uri
        for _,rule in pairs(URL_RULES) do
            if rule ~="" and rulematch(REQ_URI,rule,"jo") then
                log_record('Deny_URL',REQ_URI,"-",rule)
                if config_waf_enable == "on" then
                    waf_output()
                    return true
                end
            end
        end
    end
    return false
end

function url_args_attack_check()
    if config_url_args_check == "on" then
        ARGS_RULES = get_rule('args.rule')
        for _,rule in pairs(ARGS_RULES) do
            REQ_ARGS = ngx.req.get_uri_args()
            for key, val in pairs(REQ_ARGS) do
                if type(val) == 'table' then
                    ARGS_DATA = table.concat(val, " ")
                else
                    ARGS_DATA = val
                end
                if ARGS_DATA and type(ARGS_DATA) ~= "boolean" and rule ~="" and rulematch(unescape(ARGS_DATA),rule,"jo") then
                    log_record('Deny_URL_Args',ngx.var.request_uri,"-",rule)
                    if config_waf_enable == "on" then
                        waf_output()
                        return true
                    end
                end
            end
        end
    end
    return false
end

function user_agent_attack_check()
    if config_user_agent_check == "on" then
        USER_AGENT_RULES = get_rule('useragent.rule')
        USER_AGENT = ngx.var.http_user_agent
        if USER_AGENT ~= nil then
            for _,rule in pairs(USER_AGENT_RULES) do
                if rule ~="" and rulematch(USER_AGENT,rule,"jo") then
                    log_record('Deny_USER_AGENT',ngx.var.request_uri,"-",rule)
                    if config_waf_enable == "on" then
                        waf_output()
                        return true
                    end
                end
            end
        end
    end
    return false
end

function post_attack_check()
    if config_post_check == "on" then
        POST_RULES = get_rule('post.rule')
        for _,rule in pairs(ARGS_RULES) do
            POST_ARGS = ngx.req.get_post_args()
        end
        return true
    end
    return false
end