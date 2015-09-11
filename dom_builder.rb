class DOMBuilder

  def initialize(tree)

    @root = tree.root
    @write_array = []
    build(@root)
    write_file

  end

  # need to configure tab structure
  def build(node)

    # add <node.name to write_array
    @write_array << "<#{node.name}"

    # if node has classes, append them to last element of write array
    unless node.classes == nil
      @write_array[-1] = @write_array[-1] + " classes=\"#{node.classes.join(" ")}\""
    end

    # if node has id's, append them to last element of write array.  else append closing bracket
    if node.id == nil
      @write_array[-1] = @write_array[-1] + ">\n"
    else
      @write_array[-1] = @write_array[-1] + " id=\"#{node.id}\">\n"
    end

    # add tag text to array if available
    unless node.text == ""
      @write_array << node.text + "\n"
    end

    # build children
    unless node.children == []
      node.children.each do |child|
        build(child)
      end
    else
      @write_array << "</#{node.name}>\n"
      return
    end

    # add closing tag e.g. </html>
    @write_array << "</#{node.name}>\n"

  end

  # prints write_array to file
  def write_file

    File.open("rebuild.html", "w") do |file|
      @write_array.each do |tags_and_text|
        file.write tags_and_text
      end
    end

  end

end