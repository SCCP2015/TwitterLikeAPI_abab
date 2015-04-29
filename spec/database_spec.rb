# coding: utf-8
require 'spec_helper'

describe Database.instance do
  describe '#read' do
    before do
      File.delete('data') if File.exist?('data')
    end
    context 'In the case of database is empty' do
      it 'return an empty String' do
        expect(Database.instance.read).to eq ''
      end
    end
    after do
      File.delete('data') if File.exist?('data')
    end
  end
  describe '#write' do
    before do
      File.delete('data') if File.exist?('data')
    end
    it 'return hoge String' do
      expect(Database.instance.write('hoge')).to eq "hoge\n"
      expect(Database.instance.read).to eq "hoge\n"
    end
    context 'In the case of write multiple lines' do
      it 'write a word to next line' do
        expect(Database.instance.write('hoge')).to eq "hoge\n"
        expect(Database.instance.read).to eq "hoge\n"
        expect(Database.instance.write('foo')).to eq "hoge\nfoo\n"
        expect(Database.instance.read).to eq "hoge\nfoo\n"
      end
    end
  end
  describe '#update' do
    it 'rewrite a word' do
      File.delete('data') if File.exist?('data')
      expect(Database.instance.update('hoge')).to eq "hoge\n"
      expect(Database.instance.read).to eq "hoge\n"
      Database.instance.write('foo')
      Database.instance.write('bar')
      expect(Database.instance.update('hoge')).to eq "hoge\n"
      expect(Database.instance.read).to eq "hoge\n"
    end
  end
  describe '#delete' do
    it 'rewrite a word' do
      File.delete('data') if File.exist?('data')
      expect(Database.instance.delete).to eq ''
      expect(Database.instance.read).to eq ''
      Database.instance.write('foo')
      Database.instance.write('bar')
      expect(Database.instance.delete).to eq ''
      expect(Database.instance.read).to eq ''
    end
  end
end
