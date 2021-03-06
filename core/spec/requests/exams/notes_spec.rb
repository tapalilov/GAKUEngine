require 'spec_helper'

describe 'Exam Notes' do

  stub_authorization!

  let(:exam) { create(:exam) }
  let(:note) { create(:note, :notable => exam) }

  before :all do
    set_resource "exam-note"
  end

  context 'new', :js => true do
    before do
      visit gaku.exam_path(exam)
      click new_link
      wait_until_visible submit
    end

    it "creates and shows" do
      expect do
        fill_in "note_title",   :with => "The note title"
        fill_in "note_content", :with => "The note content"
        click submit
        wait_until_invisible submit
      end.to change(exam.notes, :count).by 1

      page.should have_content "The note title"
      page.should have_content "The note content"
      within(count_div) { page.should have_content 'Notes list(1)' }
      flash_created?
    end

    it {has_validations?}

    it 'cancels creating', :cancel => true, :js => true do
      ensure_cancel_creating_is_working
    end
  end

  context "existing", :js => true do
    before do
      note
      visit gaku.exam_path(exam)
    end

    context 'edit' do
      before do
        within(table) { click edit_link }
        wait_until_visible modal
      end

      it "edits" do
        fill_in 'note_title',   :with => 'Edited note title'
        fill_in 'note_content', :with => 'Edited note content'
        click submit

        wait_until_invisible modal
        page.should have_content 'Edited note title'
        page.should have_content 'Edited note content'
        flash_updated?
      end

      it 'cancels editting', :cancel => true  do
        ensure_cancel_modal_is_working
      end
    end

    it "deletes" do
      page.should have_content note.title
      within(count_div) { page.should have_content 'Notes list(1)' }

      expect do
        ensure_delete_is_working
      end.to change(exam.notes, :count).by -1

      within(count_div) { page.should_not have_content 'Notes list(1)' }
      page.should_not have_content note.title
      flash_destroyed?
    end
  end

end
