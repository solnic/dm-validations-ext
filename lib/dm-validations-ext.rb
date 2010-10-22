module DataMapper
  module ValidationsExt
    def _save(execute_hooks = true)
      result = super

      # TODO: should we wrap it with run_once?
      unless result
        validate          if dirty_self?
        validate_parents  if dirty_parents?
        validate_children if dirty_children?
      end

      result
    end

    # Run validations on the resource
    #
    # @return [Boolean]
    #   true if the resource is valid
    #
    # @api public
    def validate
      valid?
    end

    # Run validations on the associated parent resources
    #
    # @api semipublic
    def validate_parents
      parent_relationships.each do |relationship|
        parent = relationship.get(self)
        unless parent.valid?
          unless errors[relationship.name].include?(parent.errors)
            errors[relationship.name] = parent.errors
          end
        end
      end
    end

    # Run validations on the associated child resources
    #
    # @api semipublic
    def validate_children
      child_associations.each do |collection|
        if collection.dirty?
          collection.each do |child|
            unless child.valid?
              relationship_errors = (errors[collection.relationship.name] ||= [])
              unless relationship_errors.include?(child.errors)
                relationship_errors << child.errors
              end
            end
          end
        end
      end
    end

    Model.append_inclusions self
  end # ValidationsExt
end # DataMapper
