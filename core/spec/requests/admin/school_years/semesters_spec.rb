require 'spec_helper'

describe 'Admin School Years' do

  let(:school_year) { create(:school_year)}
  let(:semester) { create(:semester, :school_year => school_year)}

  as_admin

  before :all do
    set_resource "admin-school-year-semester"
  end

  context 'new', :js => true do
    before do
      school_year
      visit gaku.admin_school_year_path(school_year)
      click new_link
      wait_until_visible submit
    end

    it 'creates and shows' do
      expect do
        fill_in 'semester_ending', :with => '2013-04-08'
        fill_in 'semester_ending', :with => '2014-04-08'
        click submit
        wait_until_invisible form
      end.to change(Gaku::Semester, :count).by(1)

      within(count_div) { page.should have_content 'Semesters list(1)' }
      flash_created?
    end

    it 'has validations' do
      fill_in 'semester_ending', :with => ''
      fill_in 'semester_ending', :with => ''
      has_validations?
    end

    it 'cancels creating', :cancel => true do
      ensure_cancel_creating_is_working
    end
  end

  context 'existing' do
    before do
      school_year
      semester
      visit gaku.admin_school_year_path(school_year)
    end

    context 'edit', :js => true do
      before do
        within(table) { click edit_link }
        wait_until_visible modal
      end

      it 'edits' do
        fill_in 'semester_starting', :with => '2013-10-08'
        fill_in 'semester_ending', :with => '2014-10-09'

        click submit

        wait_until_invisible modal

        page.should have_content '2013 October 08'
        page.should have_content '2014 October 09'

        flash_updated?
      end

      it 'cancels editting', :cancel => true do
        ensure_cancel_modal_is_working
      end

      it 'has validations' do
        fill_in 'semester_starting', :with => ''
        fill_in 'semester_ending', :with => ''
        has_validations?
      end
    end

    context "#back", :js => true do
      before do
        school_year
        visit gaku.admin_school_year_path(school_year)
      end

      it "back to school year index" do
        click '.back-link'
        current_path.should == gaku.admin_school_years_path

      end
    end
  end

end