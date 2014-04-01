require 'spec_helper'

describe ApplicationHelper do
  describe "#page_header" do
    it "returns a formatted page header" do
      expected_value = <<HEADER
<div class="row">
  <div class="page-header col-md-6 col-md-offset-3">
    <h1>Dixit <small>Nice header</small></h1>
  </div>
</div>
HEADER
      expect(helper.page_header("Nice header")).to eq expected_value
    end
  end

  describe '#flash_notice' do
    context 'with param ":error"' do
      it 'renders the flash notices' do
        flash[:error] = 'Test error'
        expected_value = <<FLASH
<div class="alert alert-dismissable alert-danger">
  <button type="button" class="close" data-dismiss="alert">×</button>
  Test error
</div>
FLASH
        expect(helper.render_flash(:error)).to eq expected_value
      end
    end

    context 'with param ":error"' do
      it 'renders the flash notices' do
        flash[:success] = 'Success notice'
        expected_value = <<FLASH
<div class="alert alert-dismissable alert-success">
  <button type="button" class="close" data-dismiss="alert">×</button>
  Success notice
</div>
FLASH
        expect(helper.render_flash(:success)).to eq expected_value
      end
    end
  end
end
