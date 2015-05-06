# Data Mapperの利用ガイド

## Gemの追加(Gemfile)

	gem 'data_mapper'
	gem 'dm-postgres-adapter'

## Bundlerのアップデート

	bundle update

## データベースの作成

下のPostgreSQL よく使うコマンド or SQLを参考にデータベース"myapp"を作成。

## モデルクラスの追加(src/word.rb)

	require 'data_mapper'

	# Model Class
	class Word
  		include DataMapper::Resource

		property :id, Serial
  		property :msg, String
	end

	DataMapper.finalize

## Rakefileのタスク追加(Rakefile)

	require 'rspec/core/rake_task'
	require 'dm-core'
	require 'dm-migrations'
	# Model Classes
  	require_relative 'src/word'

	RSpec::Core::RakeTask.new(:spec)

	task 'db:migrate' do
	  DataMapper::Logger.new($stdout, :debug)
	  DataMapper.setup(:default, 'postgres://vagrant:vagrant@localhost/myapp')
	  DataMapper.auto_upgrade!
	  self
	end

	task default: :spec

## DB Migrade

以下のコマンドで自動的にテーブルを作成。

	$ bundle exec rake db:migrate

## Data Mapperを使った演習課題(src/app.rb)

以下のソースコードのコメント部分を埋めて、動作するようにせよ。
適宜、下のDataMapper公式ドキュメントやググった情報を使うように。

	# coding: utf-8
	require 'sinatra/base'
	require 'sinatra/reloader'
	require 'data_mapper'
	require_relative 'word'

	DataMapper::Logger.new($stdout, :debug)
	DataMapper.setup(:default, 'postgres://vagrant:vagrant@localhost/myapp')

	# Sinatra Main controller
	class MainApp < Sinatra::Base
	  # Sinatra Auto Reload
	  configure :development do
		register Sinatra::Reloader
	  end
	  get '/words' do
		# テーブルwordsの全件を取得(データの見せ方は自由)。
	  end
	  get '/words/:id' do
		# パラメータidに対応するwordsテーブルのレコード一件を取得。(idとmsgを表示)
		# もし対応するidが無ければエラーメッセージを表示。
	  end
	  post '/words' do
		# bodyの文字列をmsgとして、新しいwordレコードを一件追加。
		# レスポンスとして追加時のレコードのidを返す。
	  end
	  put '/words/:id' do
		# パラメータidに対応するwordsテーブルのレコード一件を更新。
		# 成功した場合、"true" 失敗した場合、"false"をレスポンスとして返す。
	  end
	  delete '/words/:id' do
		# パラメータidに対応するwordsテーブルのレコード一件を削除。
		# 成功した場合、"true" 失敗した場合、"false"をレスポンスとして返す。
	  end
	end


## PostgreSQL よく使うコマンド or SQL

PostgreSQLの接続

	$ psql

PostgreSQLの終了

	\q (or C-d)

データベース一覧の表示

	\l

データベースの接続

	\connect db_name
	\c db_name

データベースの作成

	create database db_name;

データベースの削除

	drop database db_name;

テーブル一覧の表示

	\d

テーブルの作成は、migrateするので省略

テーブルの削除

	drop table table_name;

レコードの確認

	SELECT * FROM table_name;

## ドキュメント
http://datamapper.org

