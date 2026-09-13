function Code(element)
  if FORMAT:match('latex')
      and not element.text:find('%s')
      and utf8.len(element.text) > 18
      and not element.text:find('|', 1, true) then
    return pandoc.RawInline(
      'latex',
      '\\path{' .. element.text .. '}'
    )
  end
end

function Table(table_element)
  local count = #table_element.colspecs
  local widths

  if count == 2 then
    widths = {0.52, 0.48}
  elseif count == 3 then
    widths = {0.25, 0.28, 0.47}
  elseif count == 4 then
    widths = {0.35, 0.18, 0.29, 0.18}
  elseif count == 5 then
    widths = {0.19, 0.22, 0.24, 0.14, 0.21}
  else
    widths = {}
    for index = 1, count do
      widths[index] = 1 / count
    end
  end

  for index, width in ipairs(widths) do
    table_element.colspecs[index][2] = width
  end

  return table_element
end
