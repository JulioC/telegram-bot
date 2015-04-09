require("./bot/utils")

do

function read_file_fromgame (gameid)
  local f = io.open('./data/dragaofoder/'.. gameid ..'.lua', "r+")
  if f == nil then
    print ('Creating game file '..'./data/dragaofoder/'.. gameid ..'.lua')
    serialize_to_file({}, './data/dragaofoder/'.. gameid ..'.lua')
  else
    print ('Values loaded: '..'./data/dragaofoder/'.. gameid ..'.lua')
    f:close()
  end
  return loadfile ('./data/dragaofoder/'.. gameid ..'.lua')()
end


function save_to_game(userid,gameid)
  local _list = read_file_fromgame (gameid);
  if _list == nil then
    _list = {}
  end
  table.insert(_list, userid);

  serialize_to_file(_list, './data/dragaofoder/'.. gameid ..'.lua')
  
end

function run(msg, matches)

    local games = {'dota','league','csgo','damned','swat'};
    local shouldreturn = 0;

    --Iterate over games list: If it typed a game's name, continue
    for i = 0, i<table.getn(games), 1 do
         if (games[i] == matches [2]) then
          shouldreturn=1;
         end
    end

----------
    if (shouldreturn==0) then
      return "Invalid game."
    end
----------

    if (matches [1] == "yadd") then
      return "msg.from.print_name" .. " added to game " .. matches[2];
      save_to_game(msg.from.id,matches[2]);
    end

    else
      --Send private messages ///////////////////

      local _list=read_file_fromgame (matches[2]);

      for i = 0, i<table.getn(_list), 1 do

        if (_list[i]!='') then

          local receiver='user#id'.._list[i];
          local string=msg.from.print_name .. " wants to play " .. matches[2];
          _send_msg(receiver, string);

        end

      end
      --///////////////////
      return "Messaging everyone to play " .. matches[2]; 
    end
end

return {
  description = "Messages people to play videojuegos. List of games: dota, league, csgo, damned, swat"
  usage = {
    "!play [game]: Sends a message to everyone added into that game",
    "!playadd [game]: Adds you on that game's list",
  },
  patterns = {
    "^!pla(y) (.*)$",
    "^!pla(yadd) (.*)$"
  }, 
  run = run 
}

end
