class NodeRenderer

  def initialize(tree)
    @tree = tree
  end


  def render(node = nil)

    node = @tree.root if node.nil?

    descendant_stats = count_descendants(node)

    # All of the node's data attributes
    render_attributes(node)

    # How many total nodes there are in the sub-tree below this node
    puts "\nTotal descendant nodes: #{descendant_stats[0]}"

    # A count of each node type in the sub-tree below this node
    puts "\nDescendants by name:"
    render_descendants(descendant_stats[1])

  end

  def count_descendants(node)

    queue = [node]
    total = 0
    types = {}

    until queue.empty?
      node = queue.shift

      # counts number of each type of tag
      node.children.each do |child|
        types[child.name] ||= 0
        types[child.name] += 1
        queue << child
      end

      # sums total descendants
      total = types.values.inject { |sum, value| sum += value }

    end

    [total, types]

  end

  def render_attributes(node)

    puts "\nCURRENT NODE\n\n"
    puts "\tName: #{node.name}"
    puts "\tText: #{node.text}"

    if node.classes.nil?
      puts "\tClasses:"
    else
      puts "\tClasses: #{node.classes.join(", ")}"
    end

    puts "\tID: #{node.id}"

    child_names = get_child_names(node)
    puts "\tChildren: #{child_names}"

    parent = get_parent_name(node)
    puts "\tParent: #{parent}"

  end

  # properly renders the descendant tags
  def render_descendants(name_counts)

    name_counts.each { |key, value| puts "\t<#{key}> = #{value}"}
    return

  end

  # returns names of children
  def get_child_names(node)

    child_names = []
    node.children.each { |child| child_names << child.name }
    child_names.join(", ")

  end

  # returns parent name
  def get_parent_name(node)

    parent_name = node.parent.name unless node.parent.nil?
    
  end

end