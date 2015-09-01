def parse_tag(string)

  output = {}

  # match '<' and capture anything after [a-z] and [1-6] followed by whitespace
  tag_match = string.match(/<([a-z]+[1-6]*)\s/)
  output[:tag] = tag_match[1]

  # match 'class=' capture anything after in between ' ' or " "
  class_string = string.match(/class=['"](.+?)['"]/)

  # split multiple classes
  class_matches = class_string[1].to_s.split(" ")
  output[:classes] = class_matches

  # match 'id=' capture anything after in between ' ' or " "
  id_match = string.match(/id=['"](.+?)['"]/)
  output[:id] = id_match[1]

  # match 'name=' capture anything after in between ' ' or " "
  name_match = string.match(/name=['"](.+?)['"]/)
  output[:name] = name_match[1]

  output

end

print parse_tag("<p class='foo bar' id='baz' name='fozzie'>").to_s + "\n"