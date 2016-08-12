require "spec_helper"

RSpec.describe "Todo", type: :feature do
  scenario "user visits root path" do
    visit "/"
    expect(page).to have_content("My Todos")
    expect(page).to have_selector("a", "New Todo")
  end

  scenario "user clicks 'New Todo'" do
    visit "/"
    click_link "New Todo"
    expect(page).to have_content("New Todo")
    expect(page).to have_css("form#new-todo")
  end

  scenario "user adds a new todo" do
    visit "/todo/new"
    fill_in "title", with: "Panda"
    fill_in "body", with: "Make it awesome."
    choose "done"
    click_button "Submit"

    expect(current_path).to eq("/todo")
    expect(page).to have_content("Panda")
    expect(page).to have_selector("a", "Show")
  end

  scenario "user clicks show on a todo" do
    visit "/"
    click_link "Show"
    expect(page).to have_content("Panda Make it awesome. Done")
  end

  scenario "user clicks edit on a todo" do
    visit "/todo"
    click_link "Edit"

    expect(page).to have_css("form#edit-todo")
  end

  scenario "user edits todo" do
    todo = Todo.last
    visit "/"
    click_link "Edit"
    fill_in "title", with: "Shifu"
    choose "pending"
    click_button "Update"

    expect(current_path).to eq("/todo/#{todo.id}")
    expect(page).to have_content("Shifu Make it awesome. Pending")
  end

  scenario "user deletes a todo" do
    visit "/"
    click_link "Show"
    click_button "Delete"

    expect(current_path).to eq("/todo")
    expect(page).not_to have_content("Shifu Pending")
  end

  scenario "user visits wrong address" do
    visit "/foobar"
    expect(page).to have_content("Oops! No route for GET /foobar")
  end

  after(:all) { Todo.destroy_all }
end
