function Image(img)
  if img.classes:find('filter',1) then
    local f = io.open("Kallipos-Notes-LetMeDoItForYou/" .. img.src, 'r')
    local doc = pandoc.read(f:read('*a'))
    f:close()
    local addition = pandoc.utils.stringify(doc.meta.caption)
    local student = pandoc.utils.stringify(doc.meta.student)
    local am = pandoc.utils.stringify(doc.meta.AM)
    content = content .. ">_" .. addition .. "_\n>"
    content = content .. ">" .. student .. "\n\n"
    content = content .. ">" .. am .. " \n>"
    return pandoc.RawInline('markdown',content)
  end
end
