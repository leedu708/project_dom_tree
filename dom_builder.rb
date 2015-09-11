class DOMBuilder
  attr_reader :write_array

  def initialize(tree)

    @root = tree.root
    @write_array = []
    build(@root)
    write_file

  end

  def build(node)

    @write_array << "<#{node.name}"

    unless node.classes == nil
      @write_array[-1] = @write_array[-1] + " classes=\"#{node.classes.join(" ")}\""
    end

    if node.id == nil
      @write_array[-1] = @write_array[-1] + ">\n"
    else
      @write_array[-1] = @write_array[-1] + " id=\"#{node.id}\">\n"
    end

    unless node.text == ""
      @write_array << node.text + "\n"
    end

    unless node.children == []
      node.children.each do |child|
        build(child)
      end
    else
      @write_array << "</#{node.name}>\n"
      return
    end

    @write_array << "</#{node.name}>\n"

  end

  def write_file

    File.open("rebuild.html", "w") do |file|
      @write_array.each do |tags_and_text|
        file.write tags_and_text
      end
    end

  end

end