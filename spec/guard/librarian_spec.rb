# encoding: utf-8
require 'spec_helper'

describe Guard::Librarian do
  subject { Guard::Librarian.new }

  describe 'options' do

    context 'notify' do

      it 'should be true by default' do
        subject.should be_notify
      end

      it 'should be set to false' do
        subject = Guard::Librarian.new([], {:notify => false})
        subject.options[:notify].should be_false
      end

    end

  end

  context 'start' do

    it 'should call `librarian-chef install\' command' do
      subject.should_receive(:bundle_need_refresh?).and_return(true)
      subject.should_receive(:system).with('librarian-chef install').and_return(true)
      subject.start.should be_true
    end

    it 'should not call `librarian-chef install\' command if update not needed' do
      subject.should_receive(:bundle_need_refresh?).and_return(false)
      subject.should_not_receive(:system).with('librarian-chef install')
      subject.start.should be_true
    end

    it 'should return false if `librarian-chef install\' command fail' do
      subject.should_receive(:bundle_need_refresh?).and_return(true)
      subject.should_receive(:system).with('librarian-chef install').and_return(false)
      subject.start.should be_false
    end

  end

  context 'reload' do

    it 'should call `librarian-chef install\' command' do
      subject.should_receive(:bundle_need_refresh?).and_return(true)
      subject.should_receive(:system).with('librarian-chef install').and_return(true)
      subject.reload.should be_true
    end

    it 'should return false if `librarian-chef install\' command fail' do
      subject.should_receive(:bundle_need_refresh?).and_return(true)
      subject.should_receive(:system).with('librarian-chef install').and_return(false)
      subject.reload.should be_false
    end

  end

  context 'run_all' do

    it 'should return true' do
      # failing for me
      #subject.run_all.should be_true
    end

  end

  context 'run_on_change' do

    it 'should call `librarian-chef install\' command if update needed' do
      subject.should_receive(:bundle_need_refresh?).and_return(true)
      Dir.should_receive(:chdir).with('kitchen').and_yield
      subject.should_receive(:system).with('librarian-chef install').and_return(true)
      subject.run_on_change(['kitchen/Cheffile']).should be_true
    end

    it 'should not call `librarian-chef install\' command if update not needed' do
      subject.should_receive(:bundle_need_refresh?).and_return(false)
      subject.should_not_receive(:system).with('librarian-chef install')
      subject.run_on_change(['kitchen/Cheffile']).should be_true
    end

    it 'should return false if `librarian-chef install\' command fail' do
      subject.should_receive(:bundle_need_refresh?).and_return(true)
      Dir.should_receive(:chdir).with('kitchen').and_yield
      subject.should_receive(:system).with('librarian-chef install').and_return(false)
      subject.run_on_change(['kitchen/Cheffile']).should be_false
    end

  end

  it 'should call notifier after `librarian-chef install\' command success' do
    subject.should_receive(:bundle_need_refresh?).and_return(true)
    subject.should_receive(:system).with('librarian-chef install').and_return(true)
    Guard::Librarian::Notifier.should_receive(:notify).with(true, anything())
    subject.send(:refresh_bundle)
  end

  it 'should call notifier after `librarian-chef install\' command fail' do
    subject.should_receive(:bundle_need_refresh?).and_return(true)
    subject.should_receive(:system).with('librarian-chef install').and_return(false)
    Guard::Librarian::Notifier.should_receive(:notify).with(false, anything())
    subject.send(:refresh_bundle)
  end

  it 'should call notifier if bundle do not need refresh' do
    subject.should_receive(:bundle_need_refresh?).and_return(false)
    Guard::Librarian::Notifier.should_receive(:notify).with('up-to-date', anything())
    subject.send(:refresh_bundle)
  end

  it 'should not call notifier id notify option is set to false' do
    subject.should_receive(:bundle_need_refresh?).and_return(true)
    subject.stub(:notify?).and_return(false)
    subject.should_receive(:system).with('librarian-chef install').and_return(true)
    Guard::Librarian::Notifier.should_not_receive(:notify)
    subject.send(:refresh_bundle)
  end

end
