# encoding: utf-8
require 'spec_helper'

describe Guard::Librarian::Notifier do
  subject { Guard::Librarian::Notifier }

  it 'should format success message' do
    message = subject.guard_message(true, 10.1)
    message.should == "Cookbooks have been updated\nin 10.1 seconds."
  end

  it 'should format fail message' do
    message = subject.guard_message(false, 10.1)
    message.should == "Cookbooks can't be updated,\nplease check manually."
  end

  it 'should select success image' do
    subject.guard_image(true).should == :success
  end

  it 'should select failed image' do
    subject.guard_image(false).should == :failed
  end

  it 'should call Guard::Notifier' do
    ::Guard::Notifier.should_receive(:notify).with(
      "Cookbooks have been updated\nin 10.1 seconds.",
      :title => 'Cookbooks updated',
      :image => :success
    )
    subject.notify(true, 10.1)
  end

end
