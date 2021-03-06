require "test_helper"
require "rubocop"

class CLITest < Minitest::Test
  def setup
    @cli = Meowcop::CLI.new
  end

  def teardown
    FileUtils.rm_f ".rubocop.yml"
  end

  def test_start_when_invalid_command
    assert_output(/Could not find command foo./) do
      assert_equal 0, Meowcop::CLI.start(["foo"])
    end
  end

  def test_init_when_created
    assert_output("Meow! .rubocop.yml has been created successfully.\n") do
      assert_equal 0, @cli.init([])
    end
  end

  def test_init_when_updated
    FileUtils.touch ".rubocop.yml"
    assert_output("Meow! .rubocop.yml has been overwritten successfully.\n") do
      assert_equal 0, @cli.init([])
    end
  end

  def test_run
    rubocop_cli = Minitest::Mock.new
    rubocop_cli.expect :run, 0, [["--config", File.absolute_path("examples/.rubocop.yml"), "--foo", "bar"]]

    RuboCop::CLI.stub :new, rubocop_cli do
      assert_equal 0, @cli.run(["--foo", "bar"])
    end
  end

  def test_help
    assert_output(/MeowCop commands:/) do
      assert_equal 0, @cli.help([])
    end
  end
end
