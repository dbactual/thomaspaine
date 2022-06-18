-- sets the publication year from the publication date
function Meta(m)
  if m.PubDate then
     m.PubYear = string.sub(pandoc.utils.stringify(m.PubDate), 0, 4)
    return m
  end
end
