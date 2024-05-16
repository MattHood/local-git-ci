require "rspec"
require "rugged"
require "debug"

RSpec.describe "usage of rugged" do
  let(:repo) { Rugged::Repository.new(".") }
  it "can open this repository" do
    expect(repo.path).to eq(File.join(Dir.pwd, ".git/"))
  end

  context "when a commit has been created" do
    # subject { repo.head }
    # before do
    #   testfile = "testfile.txt"
    #   File.write testfile, "foo bar baz"

    #   repo.write("This is a blob.", :blob)
    #   index = repo.index
    #   index.read_tree repo.head.target.tree
    #   index.add path: testfile

    #   options = {}
    #   options[:tree] = index.write_tree(repo)

    #   options[:author] = {email: "testuser@github.com", name: "Test Author", time: Time.now}
    #   options[:committer] = {email: "testuser@github.com", name: "Test Author", time: Time.now}
    #   options[:message] ||= "Making a commit via Rugged!"
    #   options[:parents] = repo.empty? ? [] : [repo.head.target].compact
    #   options[:update_ref] = "HEAD"

    #   Rugged::Commit.create(repo, options)
    # end

    # it "has a commit at as the HEAD" do
    #   subject
    # end

    # after do
    # end
  end
end
