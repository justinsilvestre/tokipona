class Transitive < Substantive
	def head_and_complements
		super
		@head_and_complements = @head_and_complements[0...@head_and_complements.index('e')]
	end

	def direct_objects
		@direct_objects = []
		direct_object_strings = words.join(' ').split(' e ')[1..-1]
		direct_object_strings.each do |object_string|
			add_direct_object object_string.split, new_direct_object_index
		end
		@direct_objects
	end

	def add_direct_object(words, index)
		@direct_objects << new_component(words,
			index_start: index, role: 'drob', pos: 'i', parent: self)
	end

	def new_direct_object_index
		complement_indices = has_complements? ? all_indices(complements) : 0
		d_o_indices = @direct_objects ? all_indices(@direct_objects) : 0
		index_start + 1 + complement_indices + d_o_indices
	end

	def children
		return direct_objects unless has_complements?
		direct_objects + complements
	end

	def tree
		super
		@tree[:direct_objects] = direct_objects.map(&:tree)
		@tree
	end

	def analysis
		super.merge(objects: direct_objects.map(&:index))
	end
end

