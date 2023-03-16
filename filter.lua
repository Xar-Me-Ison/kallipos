function Image(filter)
  if filter.classes:find('filter',1) then
    local f = io.open("Kallipos-Notes-LetMeDoItForYou/" .. filter.src, 'r')
    local doc = pandoc.read(f:read('*a'))
    f:close()
    local caption = pandoc.utils.stringify(doc.meta.caption)
    local student = pandoc.utils.stringify(doc.meta.student)
    local am = pandoc.utils.stringify(doc.meta.AM)
    local text = caption .. "\n"
    text = text .. " Ονοματεπώνυμο: " .. student .. " "
    text = text .. " " .. am .. "\n\n"
    return pandoc.RawInline('markdown',text)
  end
end
