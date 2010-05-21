require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AudioController do

  it "should inherit from Admin::ResourceController" do
    (Admin::AudioController < Admin::ResourceController).should be_true
  end

end
