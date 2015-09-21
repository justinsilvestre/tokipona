module Indexable
	def indices
		total = 0
		components.each do |component|
			total += component.indices
		end
		total
	end

	def all_indices(components)
		return 0 if components.empty?
		components.inject(0) do |total, component|
 			total += component.indices 
 		end
	end
end