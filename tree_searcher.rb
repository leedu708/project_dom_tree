class TreeSearcher

  def initialize(tree)

    @tree = tree

  end

  # calls search method starting from root
  def search_by(field, value)

    # Search for and return a collection with all nodes exactly matching the name, text, id, or class provided
    queue = [@tree.root]
    search_init(queue, field, value)

  end

  # calls search method for children
  def search_descendants(node, field, value)

    # Search just the tree beginning at a particular node
    queue = [node]
    search_init(queue, field, value)

  end

  # calls search method for ancestors
  def search_ancestors(node, field, value)

    # Search just the direct ancestors of a particular node
    queue = []
    node.children.each { |child| queue << child }
    search_init(queue, field, value)

  end

  # primary search method
  def search_init(queue, field, value)

    output = []

    # crawls down the tree to find nodes that match the search
    until queue.empty?
      check_node = queue.shift

      output << check_node if match?(check_node, field, value)

      check_node.children.each { |child| queue << child }
    end

    output

  end

  # checks if there is a match
  def match?(node, field, value)

    # classes saved as arrays, needs separate check
    if field == :class
      node[:classes] ||= []
      node[:classes].include?(value)

    # text saved as string.  break the string, check if value is included in the text attribute 
    elsif field == :text
      node[field].split(" ").include?(value)

    # the other attributes are assumed to only have one value
    else
      node[field] == value
    end

  end

end