class Prepositional < Substantive
	def has_complements?
		false
	end

	def prepositional_object
		@prepositional_object ||= new_component(words[after_head..-1], index_start: index + 1, role: 'prob', pos: 'i', parent: self)
	end

	def children
		[ prepositional_object ]
	end

	def tree
		super
		@tree[:prepositional_object] = prepositional_object.tree
		@tree
	end

	def analysis
		super.merge(objects: children.map(&:index))
	end
end
