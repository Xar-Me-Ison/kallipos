function Filter(images)
    if images.classes:find('filter',1) then
      local f = io.open("./Kallipos-Notes-LetMeDoItForYou" .. fn .. ".md", 'r')
      local doc = pandoc.read(f:read('*a'))
      f:close()
      local caption = pandoc.utils.stringify(doc.meta.caption) 
      local student = pandoc.utils.stringify(doc.meta.student)
      local am = pandoc.utils.stringify(doc.meta.AM)
      local content = "> " .. caption .. "  \n>" .. " Ονοματεπώνυμο:" .. student .. "  \n>" .. " Αριθμός Μητρώου:" .. am
      return pandoc.RawInline('markdown',content)
    end
end
