require 'spec_helper'

describe DataMapper::ValidationsExt do
  supported_by :all do
    before :all do
      class User
        include DataMapper::Resource

        property :id, Serial
        property :name, String, :required => true

        belongs_to :group, :required => false
        has n, :roles
      end

      class Group
        include DataMapper::Resource

        property :id, Serial
        property :name, String, :length => 6..255

        has n, :users
      end

      class Role
        include DataMapper::Resource

        property :name, String, :required => true, :key => true
        belongs_to :user, :key => true
      end

      DataMapper.finalize
      DataMapper.auto_migrate!
    end

    describe "Parent errors" do
      describe "when the parent is valid" do
        before :all do
          @group = Group.new(:name => "DataMapperists")
          @user  = User.new(:name => "John", :group => @group)
        end

        describe "#save" do
          subject { @user.save }
          it { should be(true) }
        end

        describe "#errors" do
          before { @user.save }
          subject { @user.errors[:group] }
          it { should be_blank }
        end
      end

      describe "when the parent is valid" do
        before :all do
          @group = Group.new(:name => "a")
          @user  = User.new(:name => "John", :group => @group)
        end

        describe "#save" do
          subject { @user.save }
          it { should be(false) }
        end

        describe "#errors" do
          before { @user.save }
          let(:expected_errors) { @group.errors }
          subject { @user.errors[:group] }

          it { should_not be_nil }
          it { should be_kind_of(DataMapper::Validations::ValidationErrors) }
          it { should eql(expected_errors) }
        end
      end
    end

    describe "Child errors" do
      describe "when children are not valid" do
        before :all do
          @user = User.create(:name => 'John')

          @role = Role.new
          @user.roles << @role
          @role_errors = [ @role.errors ]
        end

        describe "#save" do
          subject { @user.save }

          it { should be(false) }
        end

        describe "#errors" do
          before  { @user.save }
          subject { @user.errors[:roles] }

          it { should_not be_nil }
          it { should be_kind_of(Array) }
          it { should eql(@role_errors) }
        end
      end

      describe "when children are valid" do
        before :all do
          @user = User.create(:name => 'Jane')
          @user.roles << @user.roles.new(:name => "SuperUser")
        end

        describe "#save" do
          subject { @user.save }

          it { should be(true) }
        end

        describe "#errors" do
          subject { @user.errors[:roles] }

          it { should be_blank }
        end
      end
    end
  end
end
