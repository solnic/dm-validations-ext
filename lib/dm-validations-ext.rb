module DataMapper
  ##
  # @author Piotr Solnica
  module ValidationsExt
    module ChildAssociations
      ##
      # Checks if the associated child objects are valid
      #
      # @return [Boolean]
      #   true if all are valid, otherwise false
      # @api public
      def children_valid?
        validate_children!
        child_relationships.all? { |relationship| errors[relationship.name].empty? }
      end

      ##
      # Forces validation of all the associated child objects. Errors will be
      # available through errors object indexed by child association names.
      #
      # @api public
      def validate_children!
        child_associations.each do |collection|
          if collection.dirty?
            add_children_errors_for(collection)
          end
        end
      end

      protected

      ##
      # @api private
      def add_children_errors_for(collection)
        collection.each do |child|
          unless child.valid?
            (errors[collection.relationship.name] ||= []) << child.errors
          end
        end
      end

      Model.append_inclusions self
    end # ChildrenErrors
  end # DetailedErrors
end # DataMapper
