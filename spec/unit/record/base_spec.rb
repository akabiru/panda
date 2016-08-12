require "spec_helper"

RSpec.describe Panda::Record::Base do
  before(:all) { create_list(:todo, 4) }

  describe "subclasses" do
    subject { Todo }

    it "includes BaseHelper" do
      expect(subject.included_modules.include?(Panda::Record::BaseHelper)).
        to be true
    end
  end

  describe "#save" do
    context "when record does not exist" do
      let(:record) { build(:todo) }

      it "creates a new record" do
        expect { record.save }.to change(Todo, :count).by(1)
      end
    end

    context "when the record exists" do
      let(:record) { Todo.first }

      it "updates the record" do
        record.title = "Ipsum"
        record.save
      end
    end
  end

  describe "#update" do
    it "updates a record" do
      record = Todo.first
      record.update(title: "New Title")
      expect(Todo.first.title).to eq("New Title")
    end
  end

  describe "#destroy" do
    it "deletes a record" do
      record = Todo.last
      expect { record.destroy }.to change(Todo, :count).by(-1)
    end
  end

  describe ".to_table" do
    it "sets the table name in @table" do
      Todo.to_table(:my_todos)
      expect(Todo.table).to eq("my_todos")
    end

    after(:all) { Todo.to_table(:todos) }
  end

  describe ".property" do
    it "sets model properties" do
      Todo.property :description, type: :text, nullable: false
      expect(Todo.properties[:description]).
        to eq(type: :text, nullable: false)
    end

    after(:all) { Todo.properties.delete(:description) }
  end

  describe ".create" do
    it "creates a new record" do
      expect do
        Todo.create(attributes_for(:todo))
      end.to change(Todo, :count).by(1)
    end
  end

  describe ".all" do
    subject { Todo.all }

    it "returns all records ordered by id ASC" do
      is_expected.not_to be_nil
      expect(subject.first.id).to be < subject.last.id
    end
  end

  describe ".find" do
    context "when record exists" do
      let(:query_id) { Todo.last.id }

      context "when id an integer" do
        subject { Todo.find(query_id) }

        it_behaves_like "a finder"
      end

      context "when id a string" do
        let(:id) { query_id.to_s }

        subject { Todo.find(query_id) }

        it_behaves_like "a finder"
      end
    end

    context "when record does not exist" do
      let(:query_id) { 5000 }

      subject { Todo.find(query_id) }

      it "returns nil" do
        is_expected.to be_nil
      end
    end
  end

  describe "find_by" do
    before(:all) { create(:todo, title: "Andela") }

    context "when record exists" do
      subject { Todo.find_by(title: "Andela") }

      it "finds the record by column" do
        is_expected.not_to be_nil
        expect(subject.title).to eq("Andela")
      end
    end

    context "when record does not exist" do
      subject { Todo.find_by(title: "A very long title") }

      it "returns nil" do
        is_expected.to be_nil
      end
    end
  end

  describe ".last" do
    context "when the table is empty" do
      before(:all) { Todo.destroy_all }

      subject { Todo.last }

      it_behaves_like "a nil return"
    end

    context "when the table is not empty" do
      before(:all) { create_list(:todo, 4) }

      let!(:last_record) { create(:todo, title: "last One") }

      subject { Todo.last }

      it "returns the last record in the table" do
        expect(subject.title).to eq(last_record.title)
      end
    end
  end

  describe ".first" do
    context "when the table is empty" do
      before(:all) { Todo.destroy_all }

      subject { Todo.first }

      it_behaves_like "a nil return"
    end

    context "when the table is not empty" do
      before(:all) { create_list(:todo, 4) }

      subject { Todo.first }

      it "returns the first record in the table" do
        is_expected.not_to be_nil
      end
    end
  end

  describe ".count" do
    before(:all) do
      Todo.destroy_all
      create_list(:todo, 4)
    end

    subject { Todo.count }

    it "returns the number of records in the table" do
      is_expected.not_to be_nil
      is_expected.to eq 4
    end
  end

  describe ".destroy" do
    before(:all) { create_list(:todo, 4) }

    context "when the record exists" do
      let(:last_record) { Todo.last }

      it "deletes a record from the table" do
        expect { Todo.destroy(last_record.id) }.to change(Todo, :count).by(-1)
      end
    end

    context "whem the record does not exist" do
      subject { Todo.destroy(123_456) }
      it "returns an empty array" do
        is_expected.to eq []
      end
    end
  end

  describe ".destroy_all" do
    it "deletes all records in the table" do
      Todo.destroy_all
      expect(Todo.all).to eq []
    end
  end

  after(:all) { Todo.destroy_all }
end
