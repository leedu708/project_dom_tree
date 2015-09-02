# Usage of the DOM Reader:

# reader = DOMReader.new
# tree = reader.build_tree("test.html")

=begin

Building the DOM Tree:

- create Node struct
  1. name
  2. text
  3. classes
  4. id
  5. children
  6. parent

- capture in between open and closing tags
  - keep track of opening tag to properly end capture on closing tag
  - parse for possible text
  - always look for next open tag until document is fully read

- if there are multiple tags nested within each other, rerun capture for each level.
  - increase in depth as needed
  - recursive approach

- include all non-tag text in a separate field
  - use another search to only capture non-html text

* NOTES *

- consecutive open tags should be similar to tree structure
  - eg each consecutive open tag should be the child of the tag it is nested in

=end

# Create Node Struct
Node = Struct.new(:name, :text, :classes, :id, :children, :parent)

class DOMReader
  attr_reader :root

  def initialze(file)

    @root = nil
    tree = build_tree(file)
    render = NodeRender.new(tree)
    search = TreeSearcher.new(tree)

  end

  def build_tree(file)

    # load the file
    html_file = load_file(file)

    # build an array of the edges
    build_edges(html_file)

  end

  def load_file(file)

    input = File.read(file)

    # remove <!doctype html>
    input.match(/<!doctype html>/i).post_match.strip

  end

  def build_edges(string)

    # grabs all tags
    tags = string.scan(/(\/?[a-z]+[1-6]*.*?)>(.*?)</m)

    edge_stack = []

    tags.each do |tag|
      base_node(tag, edge_stack)
    end

  end

  def base_node(tag, stack)

    text = tag[1].strip

    # pop top stack item if there is a closing tag
    if tag[0].strip.include?("/")
      stack.pop
      stack.last[:text] << " #{text}" unless text.empty?

    # if open tag, assign top item as parent
    else
      tag_data = parse_tag(tag[0])
      parent = stack.last

      # add parent to new child
      new_node = Node.new(tag_data[:name], text, tag_data[:classes], tag_data[:id], [], parent)

      # add new child to parent
      parent[:children] << new_node unless parent.nil?
      @root = new_node if parent.nil?

      # put self on top of stack
      stack << new_node
    end

  end

  # similar to parsing warmup
  def parse_tag(tag)

    output = {}

    name_match = tag.match(/\A(\S+)\s?/)
    output[:name] = name_match[1]

    output[:classes], output[:id] = nil, nil

    class_string = tag.match(/class['"](.+?)['"]/)
    output[:classes] = class_string[1].to_s.split(" ") unless class_string.nil?

    id_match = tag.match(/id=['"](.+?)['"]/)
    output[:id] = id_match[1] unless id_match.nil?

    output

  end

end