class Preverbal < Substantive
	def has_complements?
		false
	end

	def gerundive
		@gerundive ||= new_component(words[after_head..-1], index_start: index + 1, role: 'geru', parent: self)
	end

	def children
		[ gerundive ]
	end

	def tree
		super
		@tree[:gerundive] = gerundive.tree
		@tree
	end
end
