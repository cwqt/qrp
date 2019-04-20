--luarocks install rxi-json-lua
json    = require "rxi-json-lua"
log     = require "log.log"

url = "dat://rt.cass.si"
path = "/Users/cass/Code/Projects/Sites/rt.cass.si/posts"
imgpath = "/Users/cass/Code/Projects/Sites/rt.cass.si/media/content"
imageName = ""

_VERSION = "0.1"

getopt = (arg, options) ->
  tab = {}
  for k, v in ipairs(arg) do
    if string.sub( v, 1, 2) == "--" then
      x = string.find( v, "=", 1, true )
      if x then tab[ string.sub( v, 3, x-1 ) ] = string.sub( v, x+1 )
      else      tab[ string.sub( v, 3 ) ] = true
    elseif string.sub( v, 1, 1 ) == "-" then
      y = 2
      l = string.len(v)
      local jopt
      while ( y <= l ) do
        jopt = string.sub( v, y, y )
        if string.find( options, jopt, 1, true ) then
          if y < l then
            tab[ jopt ] = string.sub( v, y+1 )
            y = l
          else
            tab[ jopt ] = arg[ k + 1 ]
        else
          tab[ jopt ] = true
        y = y + 1
  return tab

listPosts = () ->
  f = io.popen("ls -1 | wc -l | tr -d ' ' | tr -d '\n'", "r")
  s = f\read("*a")
  f\close()
  print("#{s} posts.")

  f = io.popen("ls #{path}", "r")
  s = f\read("*a")
  f\close()
  print s

deletePost = (id) ->
  os.execute("rm #{path}/#{id}.json")
  log.info("Deleted #{id}.json")

printHelp = () ->
  s = ""
  s = "rtp #{_VERSION}, quick Rotonde poster.\n"
  s = s .. "Usage: rtp -m [MESSAGE]... \n\n"
  s = s .. "Commands:\n"
  s = s .. "\t -h \tprint help message (this)\n"
  s = s .. "\t -m \tspecify message\n"
  s = s .. "\t -i \tspecify media image url\n"
  s = s .. "\t -l \tlist all posts\n"
  s = s .. "\t -d \tdelete post with id\n"
  s = s .. "\nSubmit issues to: https://gitlab.com/cxss/rtp"
  print s

insertImage = (url) ->
  log.info("Downloading #{url}")
  os.execute("wget #{url} -P #{imgpath} -q --show-progress")
  f = io.popen("basename #{url} | tr -d '\n'", "r")
  imageName = f\read("*a")
  f\close()

postMessage = (msg) ->
  t = {}
  t._version     = 15
  t.timestamp    = os.time(os.date('!*t')) .. "000"
  t.text         = tostring(msg)
  t.createdAt    = t.timestamp
  t.target       = {}
  t.media        = imageName
  t.threadRoot   = nil
  t.threadParent = nil
  t._url         = "#{url}/posts/#{t.timestamp}.json"
  t._origin      = url
  t._indexed     = t.timestamp
  t.id           = t.timestamp

  x = json.encode(t)
  os.execute("echo '#{x}' >> #{path}/#{t.timestamp}.json")
  log.info("Made post id:#{t.timestamp}")

cmd = {
  ["m"]: (msg) -> postMessage(msg)
  ["i"]: (url) -> insertImage(url)
  ["h"]: ()    -> printHelp()
  ["l"]: ()    -> listPosts()
  ["d"]: (id)  -> deletePost(id)
}

opts = getopt( arg, "imd")
for k, v in pairs(opts) do
  if k == "i"
    cmd["i"](v)

for k, v in pairs(opts) do
  if k == "i" then continue
  cmd[k](v)

-- {
--   "text": "pretty neato thing",
--   "createdAt": 1547903624769,
--   "target": [],
--   "media": "",
--   "threadRoot": null,
--   "threadParent": null,
--   "_url": "dat://rt.cass.si/posts/1547903624769.json",
--   "_origin": "dat://rt.cass.si",
--   "_indexed": 1547903624778,
--   "_version": 15,
--   "timestamp": 1547903624769,
--   "id": 1547903624769
-- }
