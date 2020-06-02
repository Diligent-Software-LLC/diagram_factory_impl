require_relative 'test_helper'

# DiagramFactoryTest.
# @class_description
#   Tests the DiagramFactory class.
class DiagramFactoryTest < Minitest::Test

  # Constants.
  CLASS       = DiagramFactory
  TEST_SYMBOL = :test_symbol
  TEST_FLOAT  = 3.14

  # test_conf_doc_f_ex().
  # @description
  #   The .travis.yml, CODE_OF_CONDUCT.md, Gemfile, LICENSE.txt, README.md,
  #   .yardopts, .gitignore, Changelog.md, CODE_OF_CONDUCT.md,
  #   diagram_factory_impl.gemspec, Gemfile.lock, and Rakefile files exist.
  def test_conf_doc_f_ex()

    assert_path_exists('.travis.yml')
    assert_path_exists('CODE_OF_CONDUCT.md')
    assert_path_exists('Gemfile')
    assert_path_exists('LICENSE.txt')
    assert_path_exists('README.md')
    assert_path_exists('.yardopts')
    assert_path_exists('.gitignore')
    assert_path_exists('Changelog.md')
    assert_path_exists('CODE_OF_CONDUCT.md')
    assert_path_exists('diagram_factory_impl.gemspec')
    assert_path_exists('Gemfile.lock')
    assert_path_exists('Rakefile')

  end

  # test_version_declared().
  # @description
  #   The version was declared.
  def test_version_declared()
    refute_nil(DiagramFactory::VERSION)
  end

  # setup().
  # @description
  #   Set fixtures.
  def setup()
  end

  # Private methods.

  # test_privm_dec().
  # @description
  #   'inventory()', 'instance=()', 'inventory=()', 'diagrams()',
  #   'kind_diagram(diagrammable = nil)', 'reassemble(diagrammable = nil)',
  #   'store_diagram(diagrammable = nil, diagram = nil)', 'initialize()', and
  #   'DiagramFactory.new()' were defined.
  def test_privm_dec()

    privcm = CLASS.private_methods(false)
    privim = CLASS.private_instance_methods(false)
    assert_includes(privcm, :new)
    assert_includes(privim, :inventory)
    assert_includes(privim, :inventory=)
    assert_includes(privim, :diagrams)
    assert_includes(privim, :kind_diagram)
    assert_includes(privim, :reassemble)
    assert_includes(privim, :store_diagram)
    assert_includes(privim, :initialize)

  end

  # teardown().
  # @description
  #   Cleanup.
  def teardown()
  end

end
