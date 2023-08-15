local pegasus = require 'pegasus'
-- https://github.com/dannote/lua-template

-- require 'lua52_compat' -- we need this for the template lib to work
-- cli to use templatec some.tpl -o some.lua
-- local template = require 'template'
-- local button = require 'button'

local server = pegasus:new({
  port = '9090',
  location = 'example/root'
})

local counter = 0

local function readfile(filename)
  local file, err = io.open(filename, 'rb')
  if not file then
    return nil, err
  end

  local value, err = file:read('*a')
  file:close()
  return value, err
end

server:start(function(request, response)
  local path = request:path()
  if path == '/' then
    print('index.html')
    response:writeFile('index.html')
  elseif path == '/clicked' then
    print('/clicked')
    counter = counter + 1
    local button_html = readfile('button.tpl')
    if button_html then
      local subs = { counter = counter }
      for key in pairs(subs) do
        local pattern = "__" .. key .. "__"
        button_html = button_html:gsub(pattern, subs[key])
      end
      response:write(button_html)
    end
    response:close()
  end
end)
