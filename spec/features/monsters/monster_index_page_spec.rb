require "rails_helper"

RSpec.describe "As a visitor", type: :feature do
  context "when I visit the monsters index page" do
    it "displays all monsters" do
      monster1 = Monster.create(name: "Imp")
      monster2 = Monster.create(name: "Helmed Horror")

      visit monsters_path

      expect(page).to have_content(monster1.name)
      expect(page).to have_content(monster2.name)
    end

    it "has a link to each monster's show page" do
      monster1 = Monster.create(name: "Imp")
      monster2 = Monster.create(name: "Helmed Horror")

      visit monsters_path

      click_link "Imp"

      expect(current_path).to eq monster_path(monster1)
      expect(page).to have_content(monster1.name)
    end
  end
end