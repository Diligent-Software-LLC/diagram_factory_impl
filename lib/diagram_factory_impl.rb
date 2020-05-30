# Copyright (C) 2020 Diligent Software LLC. All rights reserved. Released
# under the GNU General Public License, Version 3. Refer LICENSE.txt.

require_relative "diagram_factory_impl/version"
require 'diagram_comp'
require 'set'

# DiagramFactory.
# @class_description
#   A DiagramFactory library implementation.
# @attr instance [DiagramFactory]
#   A DiagramFactory singleton instance.
# @attr inventory [Set]
#   The elements are hashes containing diagrams. The keys are children
#   instances, and the values are Sets. The value Set elements are particular
#   kind diagrams.
class DiagramFactory < DiagramFactoryInt

  # self.instance().
  # @description
  #   Lazily initializes an instance. In the case the singleton already
  #   exists, gets the instance. Otherwise, instantiates and returns the
  #   instance.
  # @return [DiagramFactory]
  #   The singleton instance.
  def self.instance()

    if (@instance.nil?())
      self.instance = new()
    end
    return @instance

  end

  # diagram(diagrammable = nil).
  # @description
  #   Gets a diagrammable object's diagram. In the case none exist, assembles
  #   one.
  # @param diagrammable [Diagram]
  #   Any diagrammable object. A Diagram kind instance.
  # @return [Diagram]
  #   The existing diagram or the assembled.
  def diagram(diagrammable = nil)

    if (!Diagram.verify_diagrammable(diagrammable))
      raise(ArgumentError, "#{diagrammable} is not diagrammable.")
    else

      case
      when diagram_exists(diagrammable) && k_diagram_exists(diagrammable)
        return kind_diagram(diagrammable)
      when diagram_exists(diagrammable)
        return diagrams(diagrammable)
      else

        assembly = Diagram.build(diagrammable)
        store_diagram(diagrammable, assembly)
        return assembly

      end

    end

  end

  # diagram_update(publisher = nil).
  # @description
  #   Reassembles a publisher's diagram. Updates the publisher's inventory.
  # @param publisher [.]
  #   Any publishable object.
  # @return [Diagram]
  #   The reassembly.
  def diagram_update(publisher = nil)
    return reassemble(publisher)
  end

  # diagram_exists(diagrammable = nil).
  # @description
  #   Predicate. Verifies a diagrammable object's diagram was assembled.
  # @param diagrammable [Diagram]
  #   A diagrammable object. A Diagram kind instance.
  # @return [TrueClass, FalseClass]
  #   True in the case inventory contains an identical hash key. False
  #   otherwise.
  def diagram_exists(diagrammable = nil)

    inventory().each { |model|
      if (model.key?(diagrammable)) then
        return(true)
      end
    }
    return false

  end

  # k_diagram_exists(diagrammable = nil).
  # @description
  #   Predicate. Verifies the diagrammable's kind diagram exists.
  # @param diagrammable [.]
  #   A diagrammable object.
  # @return [TrueClass, FalseClass]
  #   True in the case the diagrammable diagram kind exists. False otherwise.
  def k_diagram_exists(diagrammable = nil)

    case
    when diagrammable.instance_of?(Node)

      kind = diagrammable.kind()
      if (diagram_exists(diagrammable))

        diagram_set     = diagrams(diagrammable)
        kind_key_exists = false
        diagram_set.to_a().each { |model|
          if (model.key?(kind)) then
            kind_key_exists = true
          end
        }
        return (diagram_set.instance_of?(Set) && kind_key_exists)

      else
        return false
      end

    end

  end

  private

  # inventory().
  # @description
  #   Gets inventory.
  # @return [Set]
  #   A hash Set. Each element is a hash. The key is a diagrammable instance,
  #   and the values are either a Set or a diagram instance. The values are
  #   Sets in the cases diagrammables have kinds.
  def inventory()
    return @inventory
  end

  # inventory=(s = nil).
  # @description
  #   Sets inventory.
  # @return [NilClass]
  #   nil.
  def inventory=(s = nil)
    @inventory = Set[]
  end

  # reassemble(diagrammable = nil).
  # @description
  #   Reassembles a diagram.
  # @param diagrammable [Diagram]
  #   Any diagrammable object. A Diagram kind instance.
  # @return [Diagram]
  #   The assembly.
  def reassemble(diagrammable = nil)

    if (!Diagram.verify_diagrammable(diagrammable))
      raise(ArgumentError, "#{diagrammable} is not diagrammable.")
    else

      assembly = Diagram.build(diagrammable)
      if (k_diagram_exists(diagrammable))

        d_kind      = diagrammable.kind()
        diagram_set = diagrams(diagrammable)
        diagram_set.to_a().each { |diagram|

          if (diagram.key?(d_kind))
            diagram_set.delete(diagram)
            store_diagram(diagrammable, assembly)
          end

        }
      else
        store_diagram(diagrammable, assembly)
      end
      return assembly

    end

  end

  # diagrams(diagrammable = nil).
  # @description
  #   Gets a diagrammable's diagram Set.
  # @param diagrammable [.]
  #   Any diagrammable object.
  # @return [Set]
  #   The diagrammable diagrams.
  # @raise [ArgumentError]
  #   In the case the diagrammable's diagrams were never assembled.
  def diagrams(diagrammable = nil)

    if (diagram_exists(diagrammable))

      inventory().to_a().each { |model|
        if (model.key?(diagrammable)) then
          return model[diagrammable]
        end
      }

    else
      raise(ArgumentError, "#{diagrammable}'s diagram was never assembled.'")
    end

  end

  # kind_diagram(diagrammable = nil).
  # @description
  #   Gets diagrammable's kind diagram.
  # @param diagrammable [.]
  #   Any diagrammable object.
  # @return [Diagram]
  #   A Diagram kind instance.
  # @raise [ArgumentError]
  #   In the case diagrammable has no corresponding diagram.
  def kind_diagram(diagrammable = nil)

    if (k_diagram_exists(diagrammable))

      d_set = diagrams(diagrammable)
      case
      when diagrammable.instance_of?(Node)

        arg_kind = diagrammable.kind()
        d_set.to_a().each { |diagram|
          if (diagram.key?(arg_kind)) then
            return diagram[arg_kind]
          end
        }

      end

    else
      raise(ArgumentError, "#{diagrammable}'s kind diagram was never
assembled.'")
    end

  end

  # store_diagram(diagrammable = nil, diagram = nil).
  # @description
  #   Stores a diagrammable's diagram.
  # @param diagrammable [.]
  #   Any diagrammable object.
  # @param diagram [Diagram]
  #   diagrammable's assembly.
  # @return [NilClass]
  #   nil.
  def store_diagram(diagrammable = nil, diagram = nil)

    case
    when diagrammable.instance_of?(Node)

      kind         = diagrammable.kind()
      kind_h       = {}
      kind_h[kind] = diagram

      if (!diagram_exists(diagrammable))

        model               = {}
        model[diagrammable] = Set[kind_h]
        inventory().add(model)

      elsif (!k_diagram_exists(diagrammable))
        d_set = diagrams(diagrammable)
        d_set.add(kind_h)
      end

    end
    return nil

  end

  # initialize().
  # @description
  #   Initializes inventory.
  def initialize()
    self.inventory = ()
  end

  # self.instance=(singleton = nil).
  # @description
  #   Sets instance.
  # @return [DiagramFactory]
  #   The singleton instance.
  def self.instance=(singleton = nil)
    @instance = singleton
  end

  private_class_method :instance=
  private_class_method :new

end
