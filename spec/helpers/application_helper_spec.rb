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
end
