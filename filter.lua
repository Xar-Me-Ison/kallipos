function Image(images)
  if images.classes:find('filter',1) then
    local f = io.open("Kallipos-Notes-LetMeDoItForYou/" .. images.src, 'r')
    local doc = pandoc.read(f:read('*a'))
    f:close()
    local caption = pandoc.utils.stringify(doc.meta.caption)
    local student = pandoc.utils.stringify(doc.meta.student)
    local am = pandoc.utils.stringify(doc.meta.AM)
    local content = " > ".. caption .." \n>".. " Ονοματεπώνυμο: ".. student .." \n>".." ΑΜ: ".. am ..
    return pandoc.RawInline('markdown',text)
  end
end
