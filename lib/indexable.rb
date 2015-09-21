module Indexable
	def indices
		total = 0
		components.each do |component|
			total += component.indices
		end
		total
	end

	def all_indices(components)
		components.inject(0) { |total, component|
 			total += component.indices
		}
	end
end