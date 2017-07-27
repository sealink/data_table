module DataTable
  class Table
    include ActionView::Helpers::TagHelper

    attr_accessor :children, :colgroups

    def initialize
      @children = []
      @colgroups = []
      self
    end

    def <<(child)
      if child.is_a? Array
        @children << Row.new(child, self)

      else # hash of one or more types
        [:header, :footer, :body].each do |type|
          @children << RowGroup.new(child[type], self, type) if child[type]
        end
      end
    end

    def to_csv
      @children.map(&:to_csv).join("\n")
    end

    def to_html(opts={})
      content_tag :table, (colgroups + children).map(&:to_html).join.html_safe, opts
    end
  end
end
